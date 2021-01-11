(import model.Patient)
(import extensions.Extension)
(deftemplate Patient       (declare (from-class Patient)))
(defrule Rule_1 ?p <- (Patient  {pas_v3 < 1.1651} {pas_mes_v4 < 0.719523} ) => (add (new Treatment 	0.992908 class=2 Rule_1)))
(defrule Rule_2 ?p <- (Patient  {pad_v2 < 0.524448} {pas_v3 < 1.33455} {pas_mes_v4 < 0.719523} ) => (add (new Treatment 	0.907801 class=2 Rule_2)))
(defrule Rule_3 ?p <- (Patient  {pas_v3 > 1.1651} {pas_mes_v4 > 0.735968} ) => (add (new Treatment 	0.97561 class=1 Rule_3)))
(defrule Rule_4 ?p <- (Patient  {pad_v2 < 0.524448} {pas_mes_v2 < 0.859748} {pas_mes_v4 > 0.768858} ) => (add (new Treatment 	0.846154 class=3 Rule_4)))
(defrule Rule_5 ?p <- (Patient  {pad_v2 < 0.524448} {pas_mes_v4 > 0.966195} {pas_mes_v4 < 1.1142} ) => (add (new Treatment 	0.461538 class=3 Rule_5)))
(defrule Rule_6 ?p <- (Patient  {pas_v3 < 1.33455} {pas_mes_v4 > 0.719523} {pas_mes_v4 < 0.851081} ) => (add (new Treatment 	0.384615 class=3 Rule_6)))
(defrule Rule_7 ?p <- (Patient  {pas_v3 > 1.44751} {pas_mes_v4 < 0.670189} ) => (add (new Treatment 	0.8 class=4 Rule_7)))
(defrule Rule_8 ?p <- (Patient  {pad_v2 > 0.524448} {pas_v3 > 1.1651} {pas_mes_v4 < 0.670189} ) => (add (new Treatment 	0.6 class=4 Rule_8)))

(deftemplate Attack (slot Attacker) (slot Attacked))

(assert (Attack (Attacker 1) (Attacked 3)))
(assert (Attack (Attacker 1) (Attacked 4)))
(assert (Attack (Attacker 1) (Attacked 5)))
(assert (Attack (Attacker 1) (Attacked 6)))
(assert (Attack (Attacker 1) (Attacked 7)))
(assert (Attack (Attacker 1) (Attacked 8)))

(assert (Attack (Attacker 2) (Attacked 3)))
(assert (Attack (Attacker 2) (Attacked 4)))
(assert (Attack (Attacker 2) (Attacked 5)))
(assert (Attack (Attacker 2) (Attacked 6)))
(assert (Attack (Attacker 2) (Attacked 7)))
(assert (Attack (Attacker 2) (Attacked 8)))

(assert (Attack (Attacker 3) (Attacked 1)))
(assert (Attack (Attacker 3) (Attacked 2)))
(assert (Attack (Attacker 3) (Attacked 4)))
(assert (Attack (Attacker 3) (Attacked 5)))
(assert (Attack (Attacker 3) (Attacked 6)))
(assert (Attack (Attacker 3) (Attacked 7)))
(assert (Attack (Attacker 3) (Attacked 8)))

(assert (Attack (Attacker 4) (Attacked 1)))
(assert (Attack (Attacker 4) (Attacked 2)))
(assert (Attack (Attacker 4) (Attacked 3)))
(assert (Attack (Attacker 4) (Attacked 7)))
(assert (Attack (Attacker 4) (Attacked 8)))

(assert (Attack (Attacker 5) (Attacked 1)))
(assert (Attack (Attacker 5) (Attacked 2)))
(assert (Attack (Attacker 5) (Attacked 3)))
(assert (Attack (Attacker 5) (Attacked 6)))
(assert (Attack (Attacker 5) (Attacked 7)))
(assert (Attack (Attacker 5) (Attacked 8)))

(assert (Attack (Attacker 6) (Attacked 1)))
(assert (Attack (Attacker 6) (Attacked 2)))
(assert (Attack (Attacker 6) (Attacked 3)))
(assert (Attack (Attacker 6) (Attacked 5)))
(assert (Attack (Attacker 6) (Attacked 7)))
(assert (Attack (Attacker 6) (Attacked 8)))

(assert (Attack (Attacker 7) (Attacked 1)))
(assert (Attack (Attacker 7) (Attacked 2)))
(assert (Attack (Attacker 7) (Attacked 3)))
(assert (Attack (Attacker 7) (Attacked 4)))
(assert (Attack (Attacker 7) (Attacked 5)))

(assert (Attack (Attacker 8) (Attacked 1)))
(assert (Attack (Attacker 8) (Attacked 2)))
(assert (Attack (Attacker 8) (Attacked 3)))
(assert (Attack (Attacker 8) (Attacked 4)))
(assert (Attack (Attacker 8) (Attacked 5)))

(deftemplate Extension (multislot arguments))
(deftemplate Extension2 (declare (from-class Extension)))


;; Toutes les extensions de cardinalité 1 sont admissibles avec l'hypothèse des attaques dans les deux sens
;;On crée donc ici toutes les extensions de cardinalité 1 et 2
(deffunction computeExtension1et2 (?p)
	(for (bind ?i 1) (< ?i (+ ?p 1)) (++ ?i)
		(assert (Extension (arguments ?i)))
		(for (bind ?j (+ ?i 1)) (< ?j (+ ?p 1)) (++ ?j)
			(bind ?k (assert (Extension (arguments ?i ?j)))) 
		) 
	)
)

(computeExtension1et2 6)

;;Cette règle supprime les extensions de cardinalité 2 qui n'existent pas
(defrule extension2 
(declare (salience 0)) 
?k <- (Extension (arguments ?i ?j))
(Attack (Attacker ?i) (Attacked ?j))
=>
(retract ?k)
)

;;cette règles crée les extensions de cardinalité 3 à partir des extensions de cardinalité 2 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension3
	(declare (salience -100))
	(Extension (arguments ?i ?j))
	(Extension (arguments ?i ?k))
	(Extension (arguments ?j ?k))
	=>
	(assert (Extension (arguments ?i ?j ?k)))
)

;;cette règles crée les extensions de cardinalité 4 à partir des extensions de cardinalité 3 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension4
	(declare (salience -200))
	(Extension (arguments ?i ?j ?k))
	(Extension (arguments ?i ?k ?l))
	(Extension (arguments ?i ?j ?l))
	(Extension (arguments ?j ?k ?l))
	=>
	(assert (Extension (arguments ?i ?j ?k ?l)))
)

;;cette règles crée les extensions de cardinalité 5 à partir des extensions de cardinalité 4 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension5
	(declare (salience -300))
	(Extension (arguments ?i ?j ?k ?m))
	(Extension (arguments ?i ?k ?l ?m))
	(Extension (arguments ?i ?j ?l ?m))
	(Extension (arguments ?j ?k ?l ?m))
	(Extension (arguments ?i ?j ?k ?l))
	=>
	(assert (Extension (arguments ?i ?j ?k ?l ?m)))
)


;;cette règles crée les extensions de cardinalité 6 à partir des extensions de cardinalité 5 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension6
	(declare (salience -400))
	(Extension (arguments ?i ?j ?k ?m ?n))
	(Extension (arguments ?i ?k ?l ?m ?n))
	(Extension (arguments ?i ?j ?l ?m ?n))
	(Extension (arguments ?j ?k ?l ?m ?n))
	(Extension (arguments ?i ?j ?k ?l ?n))
	(Extension (arguments ?i ?j ?k ?l ?m))
	=>
	(assert (Extension (arguments ?i ?j ?k ?l ?m ?n)))
)


;;cette règles crée les extensions de cardinalité 7 à partir des extensions de cardinalité 6 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension7
	(declare (salience -500))
	(Extension (arguments ?i ?j ?k ?m ?n ?o))
	(Extension (arguments ?i ?k ?l ?m ?n ?o))
	(Extension (arguments ?i ?j ?l ?m ?n ?o))
	(Extension (arguments ?j ?k ?l ?m ?n ?o))
	(Extension (arguments ?i ?j ?k ?l ?n ?o))
	(Extension (arguments ?i ?j ?k ?l ?m ?o))
	(Extension (arguments ?i ?j ?k ?l ?m ?n))
	=>
	(assert (Extension (arguments ?i ?j ?k ?l ?m ?n)))
)

(run)
(defrule sendExtension
	?m <- (ACLMessage (communicative-act CFP) (sender ?s) (receiver ?r))
	=>
	(assert (ACLMessage (communicative-act INFORM) (sender ?r) (receiver ?s) (content qqchose)))
)