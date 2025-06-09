from flask_restful import Resource
from flask import request
from schemas.user import user_schema, users_schema
from config import db
from models.user import User

class UserRoute(Resource):
    def get(self, identifier=None):
        if identifier is not None:
            user = User.query.get(identifier)
            if not user:
                return {"message": "User not found"}, 404
            return user_schema.dump(user), 200
        else:
            users = User.query.all()
            return users_schema.dump(users), 200
        
    def post(self):
        json_data = request.get_json()
        if not json_data:
            return {"message": "Error: No data!"}, 400

        data = user_schema.load(json_data)
        user = User(
            email=data["email"],
            full_name=data["full_name"],
            password=data["password"],
        )
        db.session.add(user)
        db.session.commit()

        return {"status": "Success", "data": user_schema.dump(user)}, 201

    def delete(self, identifier):

        user = User.query.get(identifier)
        if not user:
            return {"message": "User not found"}, 404

        db.session.delete(user)
        db.session.commit()

        return {"status": "User deleted"}, 204
    
    def put(self, identifier):
        json_data = request.get_json()
        if not json_data:
            return {"message": "Error: No data!"}, 400

        user = User.query.get(identifier)
        if not user:
            return {"message": "User not found"}, 404

        user.email = json_data.get("email", user.email)
        user.full_name = json_data.get("full_name", user.full_name)
        if "password" in json_data:
            user.set_password(json_data["password"])
        db.session.commit()
        return {"status": "Success", "data": user_schema.dump(user)}, 200

    def patch(self, identifier):
        user = User.query.get(identifier)
        if not user:
            return {"message": "Error: User not found"}, 404

        json_data = request.get_json()
        if not json_data:
            return {"message": "No data!"}, 400

        data = user_schema.load(json_data, partial=True)
        for key, value in data.items():
            if key == "password":
                user.set_password(value)
            else:
                setattr(user, key, value)

        db.session.commit()
        result = user_schema.dump(user)
        return {"status": "Success", "data": result}, 200