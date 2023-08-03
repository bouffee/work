import sys
from tempfile import TemporaryFile
from org.apache.commons.io import IOUtils
from java.nio.charset import StandardCharsets
from org.apache.nifi.processor.io import StreamCallback

reload(sys)
sys.setdefaultencoding('UTF-8')
additionalContent = "test"

class ModifyContent(StreamCallback):
    def __init__(self):
        pass

    def process(self, inputStream, outputStream):
        global additionalContent
        flowFileContent = IOUtils.toString(inputStream, StandardCharsets.UTF_8)
        flowFileContent = flowFileContent + "\n" + additionalContent
        outputStream.write(bytearray(flowFileContent.encode('utf-8')))       

flowFile = session.get()

if flowFile is not None:
    try:
        session.write(flowFile, ModifyContent())
    except Exception as e:
        flowFile = session.putAttribute(flowFile, "error", str(e))
        session.transfer(flowFile, REL_FAILURE)
    else:
        session.transfer(flowFile, REL_SUCCESS)
    finally:
        session.commit()
