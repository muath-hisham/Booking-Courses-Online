from flask import Flask, jsonify, request

from the_final_model import textRankSumm

app = Flask(__name__)

@app.route('/', methods=['POST', 'GET'])
def json_example():
    request_data = request.get_json()

    # You can now use the data in your application.
    # For example, you can print it to console:
    output = []
    for file in request_data["files"]:
        output.append(textRankSumm(file))

    
    # You can also send a response back to the Flutter app:
    return jsonify({"state": 101 ,"result": output}), 200
    
if __name__ == '__main__':
    app.run(host='192.168.43.247',port=5000,debug=True)
