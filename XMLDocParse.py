import traceback
from org.apache.commons.io import IOUtils
from java.nio.charset import StandardCharsets
from org.apache.nifi.processor.io import InputStreamCallback
import xml.etree.ElementTree as etree
import sys

reload(sys)  
sys.setdefaultencoding('UTF8') 

result = list()
attrMap = dict()
xmlPath = ''

# Define a subclass of StreamCallback for use in session.read()
class AddAttributeByContent(InputStreamCallback):
    def __init__(self):
        pass
    
    def process(self, inputStream, searchTag=xmlPath):
        try :
            flowFileContent = IOUtils.toString(inputStream, StandardCharsets.UTF_8)
            tree = etree.fromstring(flowFileContent)
            global result
            result = tree.findall(searchTag)
        
        except:
            print("Exception in Reader:")
            print('-' * 60)
            traceback.print_exc(file=sys.stdout)
            print('-' * 60)
            session.transfer(flowFile, REL_FAILURE)
            session.commit()
            raise           
# end class

flowFile = session.get()

if flowFile != None:
    session.read(flowFile, AddAttributeByContent())
    count = 1
    for i in result:
        attrMap[count] = i.text
    flowFile = session.putAllAttributes(flowFile, attrMap)

session.transfer(flowFile, REL_SUCCESS)
session.commit()