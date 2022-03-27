from flask import Flask
application = app = Flask(__name__)

@application.route('/', methods=["GET"])
def hello_world():
    return 'A hello world Flask Project'

if __name__ == '__main__':
    application.run(port=8000)