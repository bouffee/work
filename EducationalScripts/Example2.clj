(import 'java.nio.charset.StandardCharsets)
(import 'org.apache.commons.io.IOUtils)
(import 'org.apache.nifi.processor.io.StreamCallback)

;; (def additionalContent "test")
(def newAttrs {"newAttr1" "apple"
               "newAttr2" (str 12)})

(defn stream-callback [flow content]
  (reify StreamCallback
    (process [this inputStream outputStream]
      (.write outputStream
              (.getBytes (str (slurp inputStream) "\n" content))))))

(defn write-content[flow content]
  (.write session flow (stream-callback flow content)))

(let [flowFile (.get session)]
  (try
  (def flowFileAttrs (.getAttributes flowFile))
  (write-content flowFile flowFileAttrs)
  (.putAllAttributes session flowFile newAttrs)
  (.putAttribute session flowFile "modify" "true") 
  (.info log "Content has been modified!")
  (.transfer session flowFile REL_SUCCESS)
    (catch Exception e
      (.putAttribute session flowFile "error" (.getMessage e))
      (.transfer session flowFile REL_FAILURE))
    (finally (.commit session))))
