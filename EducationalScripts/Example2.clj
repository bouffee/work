(import 'java.nio.charset.StandardCharsets)
(import 'org.apache.commons.io.IOUtils)
(import 'org.apache.nifi.processor.io.StreamCallback)

;; (def additionalContent "test")
;; (def newAttrs {"newAttr1" "apple"
;;                "newAttr2" (str 12)})

(defn put-attribute [flow]
  (.putAttribute session flow "modify" "true"))

;; (defn send-log []
;;   (.info log "Content has been modified!"))


(defn stream-callback [flow content]
  (reify StreamCallback
    (process [this inputStream outputStream]
      (.write outputStream
              (.getBytes (str (slurp inputStream) "\n" (apply str content )))))))

(defn write-content[flow content]
  (.write session flow (stream-callback flow content)))

(defn success-transfer [flow]
  (.transfer session flow REL_SUCCESS))

(let [flowFile (.get session)]
  (def flowFileAttrs (.getAttributes flowFile))
  (write-content flowFile flowFileAttrs)
  (-> flowFile
      put-attribute
      success-transfer)
  (.info log "Content has been modified!"))
