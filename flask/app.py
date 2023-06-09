from flask import Flask
from flask import render_template
import os 
import psycopg2
import json
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route("/hello")
def hello_world():
    return "<p>CoffeBreak for lalyos [flask] v4</p>"

@app.route('/vip')
def vip():

    conn = psycopg2.connect(os.getenv("DB_URL"))
    table = os.getenv("DB_TABLE",default= "vip")
    app.logger.info("table used: %s", table)

    # Create a cursor object
    cursor = conn.cursor()

    # Execute a SELECT statement to get all lines from the 'vip' table
    cursor.execute(f"SELECT * FROM {table}")

    # Fetch all the results
    results = cursor.fetchall()

    # Convert the results to a list of dictionaries
    rows = []
    for row in results:
        rows.append({'Name': row[0], 'Age': row[1]})

    # Convert the list of dictionaries to a JSON array
    json_array = json.dumps(rows)

    # Print the JSON array
    print(json_array)

    # Close the cursor and database connection
    cursor.close()
    conn.close()
    return json_array


@app.route('/mithril')
def mithril(name=None):
    table = os.getenv("DB_TABLE",default= "vip")
    return render_template('vip.html', user=table[3:])

@app.route('/')
def hello(name=None):
    return render_template('index.html',
                            title=os.getenv("TITLE", default="Welcome"), 
                            color=os.getenv("COLOR", default="gray"),
                            giphy=os.getenv("GIPHY", default="QTAVEex4ANH1pcdg16"),
                            body=os.getenv("BODY", default="use TITLE/BODY/COLOR/GIPHY env vars ..."),
            )