import sys
from org.apache.commons.io import IOUtils
from java.nio.charset import StandardCharsets
from org.apache.nifi.processor.io import StreamCallback

reload(sys)
sys.setdefaultencoding('UTF-8')
additionalContent = "test"
flowFileAttr = dict()
newAttrs = { "newAttr1": "apple",
           "newAttr2": str(12)}

class ModifyContent(StreamCallback):
    def __init__(self):
        pass

    def process(self, inputStream, outputStream):
        global flowFileAttr
        flowFileContent = IOUtils.toString(inputStream, StandardCharsets.UTF_8)
        for key, value in flowFileAttr.items():
            flowFileContent = flowFileContent + "\n" + str(key) + ": " + str(value)
        outputStream.write(bytearray(flowFileContent.encode('utf-8')))       

flowFile = session.get()

if flowFile is not None:
    try:
        flowFileAttr = flowFile.getAttributes()
        session.write(flowFile, ModifyContent())
        log.info("Content has been modified!")
        flowFile = session.putAttribute(flowFile, "modify", str(True))
        flowFile = session.putAllAttributes(flowFile, newAttrs)

    except Exception as e:
        flowFile = session.putAttribute(flowFile, "error", str(e))
        session.transfer(flowFile, REL_FAILURE)
    else:
        session.transfer(flowFile, REL_SUCCESS)
    finally:
        session.commit()
