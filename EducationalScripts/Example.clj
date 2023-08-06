(ns my-namespace
  (:import [java.net URL]
           [java.io OutputStreamWriter])
  (:require [clojure.data.json :as json])) ; Внешняя библиотека, устанавливается отдельно

(defn send-json-to-url []
  (let [my-hash {"name" "John"
                 "age" 25
                 "phones" ["+1-9920394631" "+1-8928374743"]
                 "address" {"city" "New York"
                            "country" "USA"}}
        json-doc (json/write-str my-hash)
        url "http://localhost:80"
        connection (.openConnection (URL. url))]
    (.setRequestMethod connection "POST")
    (.setRequestProperty connection "Content-Type" "application/json")
    (.setDoOutput connection true)
    (let [output-stream (.getOutputStream connection)
          output-writer (OutputStreamWriter. output-stream)]
      (.write output-writer json-doc) 
      (.flush output-writer))
    (.getResponseCode connection)))

(def response-code (send-json-to-url))
