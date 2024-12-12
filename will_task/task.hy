(import
  thoughtforms
  thoughtforms.task [FREE-RESPONSE]
  thoughtforms.html [E RawHTML]
  iso3166)
(setv  T True  F False)

;; * Task definition

(defn task-callback [task page]

  (setv scenario-html (E.blockquote :class "scenario" (map E.p [
    "Alice is a 21-year-old student at an American college. One night, she attends a party where she drinks 10 shots of vodka. There she meets Bob, a 21-year-old student at the same school, for the first time. Alice and Bob have a friendly conversation. Bob is sober, but he (and other attendees of the party) can tell that Alice is extremely drunk. Bob suggests they go to a bedroom together, and Alice agrees. Once alone, they kiss each other and begin to undress each other. Eventually, they have vaginal sex, during which Bob wears a condom. They talk, trade phone numbers, and fall asleep."
    #[[In the morning, Bob wakes up first and leaves. After Alice wakes up, she files a complaint with the college and a police report stating that Bob raped her. School policy and local law state that sex without consent is rape, and a person intoxicated to the point of incapacitation can't consent to sex, but "incapacitation" isn't precisely defined. Alice argues that, given her severe intoxication, she was incapacitated; Bob argues that she wasn't.]]
    "Both Alice and Bob have some previous experience with alcohol and with sex, although neither was in a committed relationship with anybody at the time of the event."])))

  (setv top-countries #("us" "gb"))
    ; These common choices of country are put on top of the list that
    ; the subject chooses from.

  (.consent-form task)

;; ** Rating the scenario

  (page 'continue "scenario" [
    (E.p "Consider the following scenario:")
    scenario-html])

  (for [[k [prompt yes no]] (.items (dict
      :scenario-accept ["Was it morally acceptable for Bob to have sex with Alice?"
        "acceptable"
        "unacceptable"]
      :scenario-alice-chose ["Did Alice choose to have sex with Bob?"
        "chose"
        "didn't choose"]
      :scenario-attention-no ["Did Alice have a boyfriend at the time?"
        "had a boyfriend"
        "didn't have a boyfriend"]
      :scenario-rape ["Did Bob rape Alice?"
        "raped"
        "didn't rape"]
      :scenario-attention-yes ["Did Bob have sex with Alice?"
        "had sex"
        "didn't have sex"]
      :scenario-alice-responsible ["Was Alice responsible for what happened?"
        "responsible"
        "not responsible"]
      :scenario-punish ["Should Bob receive official punishment, such as expulsion or jail time, for his actions?"
        "should be punished"
        "shouldn't be punished"]))]
    (page 'choice k
       [(E.p "In your opinion…")
         (E.p prompt)]
       {
          4 f"Very likely {yes}"
          3 f"Likely {yes}"
          2 f"Maybe {yes}"
          1 f"Likely {no}"
          0 f"Very likely {no}"}
       :after [
         (E.p "For your reference, the scenario is redisplayed below.")
         scenario-html]))

  (page 'textbox "scenario-why"
    (E.p "Briefly describe why you made the judgments that you did."))
  (page 'textbox "scenario-other-details"
    (E.p
      (E.em "(Optional) ")
      "Are there any other details of the situation that you would've liked to know when making these judgments?")
    :optional T)

;; ** Belief in a just world and free will

  (for [[k prompt] (+
      (.shuffle task "justworld-perm" (.items (dict
        ; Belief in a just world
        ; From Table 1 of: Lipkus, I. M., Dalbert, C., & Siegler, I. C. (1996). The importance of distinguishing the belief in a just world for self versus for others: Implications for psychological well-being. Personality and Social Psychology Bulletin, 22(7), 666–677. doi:10.1177/0146167296227002
        ; Each item began with "I feel with", which I thought was redundant, so I removed it.
        :justworld-self-1 "The world treats me fairly."
        :justworld-self-2 "I get what I deserve."
        :justworld-self-3 "People treat me fairly in life."
        :justworld-self-4 "I earn the rewards and punishments I get."
        :justworld-self-5 "People treat me with the respect I deserve."
        :justworld-self-6 "I get what I am entitled to have."
        :justworld-self-7 "My efforts are noticed and rewarded."
        :justworld-self-8 "When I meet with misfortune, I have brought it upon myself."
        :justworld-others-1 "The world treats people fairly."
        :justworld-others-2 "People get what they deserve."
        :justworld-others-3 "People treat each other fairly in life."
        :justworld-others-4 "People earn the rewards and punishments they get."
        :justworld-others-5 "People treat each other with the respect they deserve."
        :justworld-others-6 "People get what they are entitled to have."
        :justworld-others-7 "A person's efforts are noticed and rewarded."
        :justworld-others-8 "When people meet with misfortune, they have brought it upon themselves.")))
      (.shuffle task "freewill-perm" (.items (dict
        ; Belief in free will (and moral responsibility)
        ; From Table 1 of: Stinnett , A. J., Rodriguez , J. E., Littlefield , A. K., & Alquist , J. L. (2024). Distinguishing free will from moral responsibility when measuring free will beliefs: The FWS-II. Philosophical Psychology, 37(8), 2285–2311. doi:10.1080/09515089.2022.2139232
        ; An item 7 is shown there, but Stinnett et al. ultimately removed it from the instrument, as described in later the paper.
        :freewill-1 "People have complete control over the decisions they make."
        :moralresp-1 "People must take full responsibility for any bad choices they make."
        :freewill-2 "People can overcome any obstacles if they truly want to."
        :moralresp-2 "Criminals are totally responsible for the bad things they do."
        :freewill-3 "People have complete free will."
        :moralresp-3 "People are always at fault for their bad behavior."))))]
    (page 'choice k
      [(E.p "Rate how much you agree with each statement.")
        (E.blockquote prompt)]
      ; The two studies' original response scales both used "Strongly agree" and "Strongly disagree" as the anchor points, but the other options were unlabeled (I believe), and Lipkus et al. used a 6-point scale instead of a 7-point scale. Both studies had 1- rather than 0-indexed items.
      {
        6 "Strongly agree"
        5 "Agree"
        4 "Slightly agree"
        3 "Neither agree nor disagree"
        2 "Slightly disagree"
        1 "Disagree"
        0 "Strongly disagree"}))

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
