from flask_bcrypt import Bcrypt
from config import db

bycript = Bcrypt()

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    full_name = db.Column(db.String(255), nullable=False)
    password = db.Column(db.String(255), nullable=False)
    
    def __init__(self, email, full_name, password): 
        self.email = email
        self.full_name = full_name
        self.password = bycript.generate_password_hash(password).decode('utf-8')
        
    def set_password(self, password):
        self.password = bycript.generate_password_hash(password).decode('utf-8')
    def check_password(self, password):
        return bycript.check_password_hash(self.password, password)