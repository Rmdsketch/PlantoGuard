from flask_restful import Resource
from resources.predict import labels

class DiseaseLabels(Resource):
    def get(self):
        return {
            "success": True,
            "labels": labels
        }, 200