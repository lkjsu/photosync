# project/server/upload/views.py

from flask import Blueprint, request, make_response, jsonify
from flask.views import MethodView

from project.server import bcrypt, db
from project.server.models import User

upload_blueprint = Blueprint('upload', __name__)

class UploadAPI(MethodView):
    """
    Upload Registration Resource
    """

    def post(self):
        # get the auth token to check if user is authenticated
        auth_header = request.headers.get('Authorization')
        #print(request.get_data().split())
        f = open('bff.png', 'wb')
        f.write(request.get_data())
        f.close()
        if auth_header:
            try:
                auth_token = auth_header.split(" ")[1]
            except IndexErrror:
                reponseObject = {
                    'status': 'fail',
                    'message': 'Bearer token malformed.'
                }
                return make_response(jsonify(responseObject)), 401
        else:
            auth_token = ''
        if auth_token:
            resp = User.decode_auth_token(auth_token)
            if not isinstance(resp, str):
                user = User.query.filter_by(id=resp).first()
                responseObject = {
                        'status': 'success'
                }
                return make_response(jsonify(responseObject)), 200
            reponseObject = {
                'status': 'fail',
                'message': resp
            }
        else:
            responseObject = {
                'status': 'fail',
                'message': 'Provide a volid auth token.'
            }
            return make_response(jsonify(responseObject)), 401

# define the API resources
upload_view = UploadAPI.as_view('upload_api')

# add Rules for API Endpoints
upload_blueprint.add_url_rule(
    '/upload',
    view_func=upload_view,
    methods=['POST']
) 
