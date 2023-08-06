java_import org.apache.commons.io.IOUtils
java_import java.nio.charset.StandardCharsets
java_import org.apache.nifi.processor.io.StreamCallback

additionalContent = "test"
$flowFileAttr = {}
newAttrs = { "newAttr1" => "apple",
             "newAttr2" => "12" }

class ModifyContent
  include Java::OrgApacheNifiProcessorIo::StreamCallback

  def process(inputStream, outputStream)
    flowFileContent = Java::OrgApacheCommonsIo::IOUtils.toString(inputStream, Java::JavaNioCharset::StandardCharsets::UTF_8)
    $flowFileAttr.each do |key, value|
      flowFileContent += "\n" + (key).to_s + ": " +  (value).to_s
    end
    outputStream.write(flowFileContent.to_java_bytes)
  end
end

flowFile = session.get()

if flowFile
  begin
    $flowFileAttr = flowFile.getAttributes()
    session.write(flowFile, ModifyContent.new)
    log.info("Content has been modified!")
    flowFile = session.putAttribute(flowFile, "modify", "true")
    flowFile = session.putAllAttributes(flowFile, newAttrs)

  rescue Exception => e
    flowFile = session.putAttribute(flowFile, "error", e.to_s)
    session.transfer(flowFile, REL_FAILURE)
  else
    session.transfer(flowFile, REL_SUCCESS)
  ensure
    session.commit()
  end
end
