from flask import Flask
ai_api = Flask(__name__)


@ai_api.route('/',methods=["GET"])
def hello_world():
    return 'A hello world Flask Project'

if __name__ == '__main__':
    ai_api.run(port=8080)