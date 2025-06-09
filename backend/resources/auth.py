from flask_restful import Resource
from flask import request
from flask_jwt_extended import create_access_token
from models.user import User, bycript
from config import db
from schemas.user import user_schema
from sqlalchemy.exc import IntegrityError

class RegisterRoute(Resource):
    def post(self):
        data = request.get_json()
        try:
            user = User(
                email=data["email"],
                full_name=data["full_name"],
                password=data["password"]
            )
            db.session.add(user)
            db.session.commit()
            return {"message": "User registered successfully", "user": user_schema.dump(user)}, 201
        except IntegrityError:
            db.session.rollback()
            return {"message": "Email already used"}, 400

class LoginRoute(Resource):
    def post(self):
        data = request.get_json()
        user = User.query.filter_by(email=data["email"]).first()
        if user and bycript.check_password_hash(user.password, data["password"]):
            access_token = create_access_token(identity=user.id)
            return {
                "message": "Login successful",
                "access_token": access_token,
                "user_id": user.id,
                "full_name": user.full_name
            }, 200
        return {"message": "Invalid credentials"}, 401
    
class ResetPasswordRoute(Resource):
    def post(self):
        data = request.get_json()
        user = User.query.filter_by(email=data["email"]).first()
        if not user:
            return {"message": "User not found"}, 404
        
        user.set_password(data["new_password"])
        db.session.commit()
        return {"message": "Password reset successfully"}, 200