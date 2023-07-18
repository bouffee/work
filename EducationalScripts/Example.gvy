import groovy.json.JsonOutput

def myMap = [
    name: "John",
    age: 25,
    phones: ["+1-9920394631", "+1-8928374743"],
    address: [
        city: "New York",
        country: "USA"
    ]
] as Map

def json = JsonOutput.prettyPrint(JsonOutput.toJson(myMap))

def post = new URL("http://localhost:80").openConnection()
def message = json
post.setRequestMethod("POST")
post.setDoOutput(true)
post.setRequestProperty("Content-Type", "application/json")
post.getOutputStream().write(message.getBytes("UTF-8"))
def postRC = post.getResponseCode()
