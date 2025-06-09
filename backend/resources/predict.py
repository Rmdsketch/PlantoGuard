from flask_restful import Resource
from flask import request
from PIL import Image
import numpy as np
import io
import os
import tensorflow as tf

# ORM and Schema
from models.disease import Disease
from schemas.disease import disease_schema

# Constants
MODEL_PATH = os.path.join("models", "model.tflite")
LABELS_PATH = os.path.join("models", "labels.txt")
IMAGE_SIZE = (128, 128)

# Load model once
interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Load labels once
with open(LABELS_PATH, 'r') as f:
    labels = [line.strip() for line in f.readlines()]

# Image preprocessing function
def preprocess_image(image_bytes):
    try:
        img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        img = img.resize(IMAGE_SIZE)
        img_array = np.array(img, dtype=np.float32) / 255.0
        img_array = np.expand_dims(img_array, axis=0)
        return img_array
    except Exception as e:
        raise ValueError(f"Image preprocessing failed: {str(e)}")

# Prediction API route
class PredictRoute(Resource):
    def post(self):
        if "image" not in request.files:
            return {"message": "No image uploaded"}, 400

        image_file = request.files["image"]
        try:
            input_data = preprocess_image(image_file.read())

            # Perform inference
            interpreter.set_tensor(input_details[0]['index'], input_data)
            interpreter.invoke()
            output_data = interpreter.get_tensor(output_details[0]['index'])

            predicted_index = int(np.argmax(output_data))
            predicted_label = labels[predicted_index]
            confidence = float(np.max(output_data))

            # Search disease info from database
            disease = Disease.query.filter_by(name=predicted_label).first()

            response = {
                "success": True,
                "label": predicted_label,
                "confidence": confidence,
            }

            if disease:
                response["data"] = disease_schema.dump(disease)
            else:
                response["message"] = "Disease not found in database."

            return response, 200

        except Exception as e:
            return {"message": f"Prediction failed: {str(e)}"}, 500