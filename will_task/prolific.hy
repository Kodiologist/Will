(import
  thoughtforms.prolific :as P)


(defn make-study [db-path task-url]
  (P.make-study
    :db-path db-path
    :task-url task-url
    :project "67226d68cfc13fef37178754"
    :name "Sex and Decision-Making"
    :internal-name "will"
    :description "Read a description of a hypothetical sexual situation and answer some questions."
    :estimated-completion-minutes 5
    :reward-cents 100
    :filters [(P.first-lang-english)]
    :content-warnings ["explicit"]))
