from flask import *
from flask_cors import *

app = Flask(__name__)
CORS(app, supports_credentials=True)

# 上传文件
@app.route('/upload', methods=['GET','POST'])
def uploadFile():
    result_text = {"statusCode": 200,"message": "文件上传成功"}
    response = make_response(jsonify(result_text))
    # response.headers['Access-Control-Allow-Origin'] = '*'
    # response.headers['Access-Control-Allow-Methods'] = 'OPTIONS,HEAD,GET,POST'
    # response.headers['Access-Control-Allow-Headers'] = 'x-requested-with'
    return response

if __name__ == '__main__':
    app.run()