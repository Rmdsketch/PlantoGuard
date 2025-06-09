from flask_restful import Resource
from flask import request
from config import db
from models.disease import Disease
from schemas.disease import disease_schema, diseases_schema

class DiseaseListRoute(Resource):
    def get(self):
        diseases = Disease.query.all()
        result = diseases_schema.dump(diseases)
        return {"status": "Success", "data": result}, 200

    def post(self):
        json_data = request.get_json()
        if not json_data:
            return {"message": "Error: No data!"}, 400
        disease = disease_schema.load(json_data)

        db.session.add(disease)
        db.session.commit()

        return {"status": "Success", "data": disease_schema.dump(disease)}, 201


class DiseaseByLabelRoute(Resource):
    def get(self, label):
        disease = Disease.query.filter_by(label=label).first()
        if not disease:
            return {"message": "Disease not found"}, 404
        return disease_schema.dump(disease), 200

    def delete(self, label):
        disease = Disease.query.filter_by(label=label).first()
        if not disease:
            return {"message": "Disease not found"}, 404

        db.session.delete(disease)
        db.session.commit()

        return {"status": "Disease deleted"}, 204

    def put(self, label):
        json_data = request.get_json()
        if not json_data:
            return {"message": "Error: No data!"}, 400

        disease = Disease.query.filter_by(label=label).first()
        if not disease:
            return {"message": "Disease not found"}, 404
        
        disease.name = json_data.get("name", disease.name)
        disease.image = json_data.get("image", disease.image)
        disease.cause = json_data.get("cause", disease.cause)
        disease.solution = json_data.get("solution", disease.solution)

        db.session.commit()
        return {"status": "Success", "data": disease_schema.dump(disease)}, 200

    def patch(self, label):
        disease = Disease.query.filter_by(label=label).first()
        if not disease:
            return {"message": "Error: Disease not found"}, 404

        json_data = request.get_json()
        if not json_data:
            return {"message": "No data!"}, 400
        updated_data = disease_schema.load(json_data, instance=disease, partial=True)

        db.session.commit()
        return {"status": "Success", "data": disease_schema.dump(updated_data)}, 200
    

class DiseaseByIdRoute(Resource):
    def get(self, id):
        disease = Disease.query.get(id)
        if not disease:
            return {"message": "Disease not found"}, 404
        return disease_schema.dump(disease), 200
    
    def delete(self, id):
        disease = Disease.query.get(id)
        if not disease:
            return {"message": "Disease not found"}, 404

        db.session.delete(disease)
        db.session.commit()

        return {"status": "Disease deleted"}, 204
    
    def put(self, id):
        json_data = request.get_json()
        if not json_data:
            return {"message": "Error: No data!"}, 400

        disease = Disease.query.get(id)
        if not disease:
            return {"message": "Disease not found"}, 404
        
        disease.name = json_data.get("name", disease.name)
        disease.image = json_data.get("image", disease.image)
        disease.cause = json_data.get("cause", disease.cause)
        disease.solution = json_data.get("solution", disease.solution)

        db.session.commit()
        return {"status": "Success", "data": disease_schema.dump(disease)}, 200
    
    def patch(self, id):
        disease = Disease.query.get(id)
        if not disease:
            return {"message": "Disease not found"}, 404
        json_data = request.get_json()
        if not json_data:
            return {"message": "No data!"}, 400

        updated_data = disease_schema.load(json_data, instance=disease, partial=True)
        db.session.commit()
        return {"status": "Success", "data": disease_schema.dump(updated_data)}, 200