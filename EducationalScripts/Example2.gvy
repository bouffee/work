import org.apache.commons.io.IOUtils
import java.nio.charset.StandardCharsets

def additionalContent = "test"
flowFileAttr = [:]
def newAttrs = [ "newAttr1": "apple", "newAttr2": "12" ]

def flowFile = session.get()

if (flowFile) {
    try {
        flowFileAttr = flowFile.getAttributes()
        
        session.write(flowFile, { inputStream, outputStream -> 
            flowFileContent = IOUtils.toString(inputStream, StandardCharsets.UTF_8)
            flowFileAttr.each{  key, value ->
                flowFileContent += "\n${key}: ${value}"
            }
            outputStream.write(flowFileContent.getBytes(StandardCharsets.UTF_8))
        } as StreamCallback)

        log.info("Content has been modified!")
        flowFile = session.putAttribute(flowFile, "modify", "true")
        flowFile = session.putAllAttributes(flowFile, newAttrs)
        session.transfer(flowFile, REL_SUCCESS)
    } catch (Exception e) {
        flowFile = session.putAttribute(flowFile, "error", e.toString())
        session.transfer(flowFile, REL_FAILURE)
    } 
    finally {
        session.commit()
    }
}
