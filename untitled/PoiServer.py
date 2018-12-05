from flask import *
from flask_cors import *

app = Flask(__name__)
CORS(app, supports_credentials=True)

poiStr = open('hk_poi_json.json').read()
poiJson = json.loads(poiStr)
coord = {}
values = []
for poi in poiJson:
    # 添加坐标
    lat = poi['lat']
    lng = poi['lng']
    poiId = poi['poiId']
    coord[poiId] = [lat,lng]

    # 添加值
    values.append({'name':poiId,'value':poi['count']})

data = {'coord':coord,'values':values}

# 请求poi数据
@app.route('/poiData', methods=['GET','POST'])
def uploadFile():
    result_text = {"statusCode": 200, "message": "文件上传成功"}
    response = make_response(jsonify(data))
    return response

if __name__ == '__main__':
    app.run()