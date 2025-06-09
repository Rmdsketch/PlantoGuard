from config import ma
from models.user import User
from marshmallow import validates, ValidationError

class UserSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = User
        load_instance = False

    @validates("email")
    def validate_email(self, email):
        if "@" not in email:
            raise ValidationError("Email not valid!")

    @validates("password")
    def validate_password(self, password):
        if len(password) < 8:
            raise ValidationError("Password must be at least 8 characters long!")

user_schema = UserSchema()
users_schema = UserSchema(many=True)