import json
from java.net import URL
from java.io import OutputStreamWriter

myHash = {
    "name": "John",
    "age": 25,
    "phones": ["+1-9920394631", "+1-8928374743"],
    "address": {
        "city": "New York",
        "country": "USA"
    }
}

jsonDoc = json.dumps(myHash)

url = "http://localhost:80"

connection = URL(url).openConnection()
connection.setRequestMethod("POST")
connection.setRequestProperty("Content-Type", "application/json")
connection.setDoOutput(True)

outputStream = connection.getOutputStream()
outputStream.write(jsonDoc.encode('UTF-8'))
outputStream.flush()

responseCode = connection.getResponseCode()
