from flask_restful import Api
from resources.user import UserRoute
from resources.auth import RegisterRoute, LoginRoute, ResetPasswordRoute
from resources.predict import PredictRoute
from resources.disease import DiseaseByLabelRoute, DiseaseListRoute, DiseaseByIdRoute

def config_routes(app):
    api = Api()
    api.add_resource(
        UserRoute,
        "/users",
        "/users/<int:identifier>",
        methods=["GET", "POST", "DELETE", "PUT", "PATCH"],
    )
    api.add_resource(LoginRoute, "/auth/login")
    api.add_resource(RegisterRoute, "/auth/register")
    api.add_resource(
        ResetPasswordRoute, "/auth/reset-password"
    )
    api.add_resource(PredictRoute, "/predict")
    api.add_resource(DiseaseByLabelRoute, 
        "/disease/<string:label>",
        methods=["GET", "POST", "DELETE", "PUT", "PATCH"],
    )
    api.add_resource(
        DiseaseListRoute,
        "/disease",
        methods=["GET", "POST"]
    )
    api.add_resource(
    DiseaseByIdRoute,
    "/disease/id/<int:id>",
    methods=["GET","DELETE", "PUT", "PATCH"]
    )
    api.init_app(app)