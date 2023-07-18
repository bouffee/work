var HttpURLConnection = Java.type('java.net.HttpURLConnection');
var URL = Java.type('java.net.URL');
var OutputStreamWriter = Java.type('java.io.OutputStreamWriter');
var BufferedReader = Java.type('java.io.BufferedReader');
var InputStreamReader = Java.type('java.io.InputStreamReader');

var myObject = {
  name: "John",
  age: 25,
  phones: ["+1-9920394631", "+1-8928374743"],
  address: {
    city: "New York",
    country: "USA"
  }
};

var data = JSON.stringify(myObject);
var url = new URL("http://localhost:80");
var connection = url.openConnection();

connection.setRequestMethod("POST");
connection.setRequestProperty("Content-Type", "application/json");
connection.setDoOutput(true);

var outputStream = new OutputStreamWriter(connection.getOutputStream());
outputStream.write(data);
outputStream.flush();

var responseCode = connection.getResponseCode();
var responseBody = "";

if (responseCode === HttpURLConnection.HTTP_OK) {
  var inputStream = new BufferedReader(new InputStreamReader(connection.getInputStream()));
  var inputLine;
  
  while ((inputLine = inputStream.readLine()) !== null) {
    responseBody += inputLine;
  }
  
  inputStream.close();
} else {
  responseBody = "Request failed with status: " + responseCode;
}

flowFile = session.putAttribute(flowFile, "statusCode", String(responseCode));
flowFile = session.write(flowFile, responseBody);

session.transfer(flowFile, REL_SUCCESS);
