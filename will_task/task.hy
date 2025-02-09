(import
  thoughtforms
  thoughtforms.task [FREE-RESPONSE]
  thoughtforms.html [E RawHTML]
  iso3166)
(setv  T True  F False)

;; * Task definition

(defn task-callback [task page]

  (setv scenario-html (E.blockquote :class "scenario" (RawHTML (+
    #[[<p>Suppose, for example, a man who's entirely sober has sex with a woman who's drunk. Let's call them "Bob" and "Alice". Bob doesn't physically force Alice into it. In fact, he asks if she wants to have sex, she agrees, and she actively participates.</p>]]
    "<p>The situation, considering things like the relative ages of Bob and Alice, is such that <em>if</em> they'd both been sober, the sex would've clearly been fully consensual. Also, while Alice is obviously drunk, not just tipsy, she's still conscious and her speech is understandable. But Bob was the one who suggested sex, and he knew she was drunk before he brought it up.</p>"))))

  (setv top-countries #("us" "gb"))
    ; These common choices of country are put on top of the list that
    ; the subject chooses from.

  (.consent-form task)

;; ** The core questions

  (page 'continue "scenario" [
    (E.p "In this study, I want to know your opinions about the ethics of sex while drunk.")
    scenario-html])

  (setv reminder (dict :after [
    (E.p "For your reference, the scenario is redisplayed below.")
    scenario-html]))

  (page 'choice "scenario_accept"
    (E.p "Would you say that, for Bob, the sex was ethically and morally permissible? In other words, was it okay for him to have sex with her in this situation?")
    (dict
      :Yes "Yes, it was okay."
      :No "No, it wasn't okay."
      :Unsure "I'm not sure.")
    #** reminder)
  (page 'choice "scenario_alice_control"
    (E.p "Would you say that Alice was in control of her own actions here, in terms of agreeing to the sex and participating in it?")
    (dict
      :Yes "Yes, she was fully or mostly in control of her actions."
      :No "No, she had little or no control over her actions."
      :Unsure "I'm not sure.")
    #** reminder)
  (page 'choice "scenario_attention_yes_2"
    (E.p "Would you say that Bob initiated? That is, was he the one who suggested having sex?")
    (dict
      :Yes "Yes, he initiated."
      :No "No, he didn't initiate."
      :Unsure "I'm not sure.")
    #** reminder)
  (page 'choice "overall_free_will"
    (E.p #[[Overall, do you believe that humans have free will? Of course, there are a lot of different definitions of the term "free will". I just want you to use the definition that you believe is most appropriate.]])
    (dict
      :Yes "Yes, people generally have free will."
      :No "No, people generally don't have free will."
      :Unsure "I'm not sure."))
  (page 'choice "overall_justworld"
    (E.p "Overall, do you believe the world is fair, or just? In other words, do people tend to deserve what happens to them, and get what they deserve?")
    (dict
      :Yes "Yes, the world is ultimately fair."
      :No "No, the world is ultimately unfair."
      :Unsure "I'm not sure."))

;; ** Demographics

  (page 'choice "country"
    (E.p "What country do you live in?")
    (dfor
      c (sorted iso3166.countries :key (fn [c]
        #((not (in (.lower c.alpha2) top-countries)) c.name)))
      (.lower c.alpha2) c.name))
  (page 'enter-number "age"
    (E.p "How old are you?")
    :type int :sign 1)
  (page 'choice "gender"
    (E.p "What is your gender?")
    (dict
      :M "Male"
      :F "Female"
      :Other FREE-RESPONSE))
  (page 'checkbox "race"
    (E.p "What is your race? (Choose all that apply.)")
    (dict
      :Asian "Asian"
      :Black "Black"
      :Hispanic "Hispanic"
      :MENA "Middle Eastern or North African"
      :NatAm "Native American"
      :Islander "Native Hawaiian or other Pacific islander"
      :White "White"
      :Other FREE-RESPONSE)
    :min 1)
  (page 'enter-number "edu"
    (E.p "How many years of education have you completed? (Include any skipped years in the total, but count any repeated years only once each.)")
    :type int :sign [0 1])

;; ** Wrap-up

  (page 'textbox "comments"
     (E.p
       (E.em "(Optional) ")
       "Comments on this study")
     :optional T)

  (.complete task))

;; * CSS

(setv will-head "<style>
    blockquote
        {border-style: groove;
         padding: .25em}
    .scenario > p:first-child
        {margin-top: 0}
    .scenario > p
        {margin-bottom: 0}
    em
        {font-style: normal;
         font-weight: bold}</style>")

;; * Main

(defn application [db-path]
  (thoughtforms.wsgi-application
    task-callback
    :db-path db-path
    :task-version GIT-COMMIT
    :page-title "Task"
    :language "en-US"
    :page-head (RawHTML will-head)
    :cookie-path "/"
    :consent-elements (RawHTML (.read-text
      (/ (. (hy.I.pathlib.Path __file__) parent) "consent")))))
