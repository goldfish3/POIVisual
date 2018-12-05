from flask import *

app = Flask(__name__)

car1 = {'id':1,'name':'abc','ctime':'2017-08-12'}
car2 = {'id':2,'name':'ert','ctime':'2017-09-22'}
dict = {'status':0,'message':[car1,car2]}

@app.route('/', methods=['GET', 'POST'])
def hello():
    print(request.url)
    print(request.form.get('name'))
    print(request.args)

    callback = request.args['callback']
    name = request.args['name']

    resultText = callback+('(%s)'%json.dumps(dict))
    response = make_response(resultText)
    return response

if __name__ == '__main__':
    app.run()