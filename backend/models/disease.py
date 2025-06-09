from config import db

class Disease(db.Model):
    __tablename__ = 'diseases'
    id = db.Column(db.Integer, primary_key=True)
    label = db.Column(db.String(100), nullable=False)
    name = db.Column(db.String(255), nullable=False)
    image = db.Column(db.String(255))
    cause = db.Column(db.Text, nullable=True)
    solution = db.Column(db.Text, nullable=True)

    def __init__(self, label, name, image=None, cause=None, solution=None):
        self.label = label
        self.name = name
        self.image = image
        self.cause = cause
        self.solution = solution