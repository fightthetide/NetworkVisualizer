from flask import Flask
network_visualizer = Flask(__name__)


@network_visualizer.route('/', methods=["GET"])
def hello_world():
    return 'A hello world Flask Project'

if __name__ == '__main__':
    network_visualizer.run(port=8080)