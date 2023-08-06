var StreamCallback = Java.type("org.apache.nifi.processor.io.StreamCallback");
var IOUtils = Java.type("org.apache.commons.io.IOUtils");
var StandardCharsets = Java.type("java.nio.charset.StandardCharsets");


var additionalContent = "test";
var flowFileAttr = {};
var newAttrs = { "newAttr1": "apple",
                "newAttr2": String(12)};

var flowFile = session.get();
if (flowFile != null){
    try {
        flowFileAttr = flowFile.getAttributes()
        flowFile = session.write(flowFile,
            new StreamCallback(function(inputStream, outputStream) {
                var flowFileContent = IOUtils.toString(inputStream, StandardCharsets.UTF_8)
                for (var key in flowFileAttr) {
                    flowFileContent += "\n" + String(key) + ": " + String(flowFileAttr[key])
                }
                outputStream.write(flowFileContent.getBytes(StandardCharsets.UTF_8));
            }))
        log.info(String('Content has been modify!'));
        flowFile = session.putAttribute(flowFile, "modify", "true");
        flowFile = session.putAllAttributes(flowFile, newAttrs);
        session.transfer(flowFile, REL_SUCCESS);
    } catch (error) {
        flowFile = session.putAttribute(flowFile, "error", String(error));
        session.transfer(flowFile, REL_FAILURE);
    }
    session.commit()
}
