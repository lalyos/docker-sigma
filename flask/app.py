from flask import Flask
from flask import render_template
import os 

app = Flask(__name__)

@app.route("/hello")
def hello_world():
    return "<p>CoffeBreak for lalyos [flask]</p>"

@app.route('/')
def hello(name=None):
    return render_template('index.html',
                            title=os.getenv("TITLE", default="Welcome"), 
                            color=os.getenv("COLOR", default="gray"),
                            giphy=os.getenv("GIPHY", default="QTAVEex4ANH1pcdg16"),
                            body=os.getenv("BODY", default="use TITLE/BODY/COLOR/GIPHY env vars ..."),
            )