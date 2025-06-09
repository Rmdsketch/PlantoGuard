from config import ma
from models.disease import Disease

class DiseaseSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Disease
        load_instance = True

disease_schema = DiseaseSchema()
diseases_schema = DiseaseSchema(many=True)
