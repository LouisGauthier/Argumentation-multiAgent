(import model.Patient)
(import extensions.Extension)
(deftemplate Patient       (declare (from-class Patient)))
(defrule Rule_1 ?p <- (Patient  {pas_v4 < 1.04878} {pas_mes_v4 < 0.593298} ) => (add (new Treatment 	0.992126 class=2 Rule_1)))
(defrule Rule_2 ?p <- (Patient  {pas_v4 > 0.902132} {pas_mes_v4 > 0.686055} ) => (add (new Treatment 	1 class=1 Rule_2)))
(defrule Rule_3 ?p <- (Patient  {pas_v4 < 0.902132} {pas_mes_v4 > 0.704606} ) => (add (new Treatment 	1 class=3 Rule_3)))
(defrule Rule_4 ?p <- (Patient  {pas_v4 > 0.902132} {pas_mes_v4 < 0.686055} ) => (add (new Treatment 	1 class=4 Rule_4)))
(defrule Rule_5 ?p <- (Patient  {pas_mes_v4 > 0.686055} {pas_mes_v4 < 0.704606} ) => (add (new Treatment 	0.00787402 class=2 Rule_5)))

;;Template représentant une attaque : Attacker correspond à l'attaquant et Attacked à l'attaqué
(deftemplate Attack (slot Attacker) (slot Attacked))
;;Template permettant de créer les extensions
(deftemplate Resultat(slot res))
(deftemplate Extension2 (multislot arguments) (slot card (default-dynamic (length$ (create$ arguments)))))
;(deftemplate Extension (declare (from-class Extension)))
;(bind ?a (new Extension))
;(add ?a)

;(deffunction listToQuery (?liste ?acc)
;	(if (neq ?liste ()) then
;	(listToQuery (rest$ ?liste) (insert$ ?acc 1 (str-cat "?" (first$ ?liste))))
;	else
;	?acc
;))

(defglobal ?*varGlobal* = 0)


(assert (Attack (Attacker 1) (Attacked 2)))
(assert (Attack (Attacker 1) (Attacked 3)))
(assert (Attack (Attacker 1) (Attacked 4)))
(assert (Attack (Attacker 1) (Attacked 5)))

(assert (Attack (Attacker 2) (Attacked 1)))
(assert (Attack (Attacker 2) (Attacked 3)))
(assert (Attack (Attacker 2) (Attacked 4)))
(assert (Attack (Attacker 2) (Attacked 5)))

(assert (Attack (Attacker 3) (Attacked 1)))
(assert (Attack (Attacker 3) (Attacked 2)))
(assert (Attack (Attacker 3) (Attacked 4)))
(assert (Attack (Attacker 3) (Attacked 5)))

(assert (Attack (Attacker 4) (Attacked 1)))
(assert (Attack (Attacker 4) (Attacked 2)))
(assert (Attack (Attacker 4) (Attacked 3)))
(assert (Attack (Attacker 4) (Attacked 5)))


(assert (Attack (Attacker 5) (Attacked 1)))
(assert (Attack (Attacker 5) (Attacked 2)))
(assert (Attack (Attacker 5) (Attacked 3)))
(assert (Attack (Attacker 5) (Attacked 4)))

(deftemplate ACLMessage (slot communicative-act) (slot sender) (multislot receiver) (slot reply-with) (slot in-reply-to) (slot envelope) (slot conversation-id) (slot protocol) (slot language) (slot ontology) (slot content) (slot encoding) (multislot reply-to) (slot reply-by))
(assert (calculnoneffectue))
(assert (ACLMessage (sender Agent1) (receiver Agent2) (communicative-act CFP)))



;; Toutes les extensions de cardinalité 1 sont admissibles avec l'hypothèse des attaques dans les deux sens
;;On crée donc ici toutes les extensions de cardinalité 1 et 2
(deffunction computeExtension1et2 (?p)
	(for (bind ?i 1) (< ?i (+ ?p 1)) (++ ?i)
		(assert (Extension2 (arguments ?i)))
		(for (bind ?j (+ ?i 1)) (< ?j (+ ?p 1)) (++ ?j)
			(bind ?k (assert (Extension2 (arguments ?i ?j)))) 
		) 
	)
)


(defquery search-extension
	(declare (variables ?card))
	(Extension2(card ?card))
)
;;Fonction récupérant toutes les extension de taille maximale dans result
(deffunction findResult (?compteur)
	(bind ?result (run-query* search-extension ?compteur))
;(if (eq ?compteur 1)
;	then (bind ?result (run-query* search-extension-1))
;)
;(if (eq ?compteur 2)
;	then (bind ?result (run-query* search-extension-2))
;)
;(if (eq ?compteur 3)
;	then (bind ?result (run-query* search-extension-3))
;)
;(if (eq ?compteur 4)
;	then (bind ?result (run-query* search-extension-4))
;)
;(if (eq ?compteur 5)
;	then (bind ?result (run-query* search-extension-5))
;)
;(if (eq ?compteur 6)
;	then (bind ?result (run-query* search-extension-6))
;)
;(if (eq ?compteur 7)
;	then (bind ?result (run-query* search-extension-7))
;)
(assert (calculeffectue))
(assert (Resultat (res ?result)))
)
(defrule termine 
	(declare (salience -550))
	(travailtermine)
	=>
	(findResult ?*varGlobal*)
)


;(defrule calculEff 
;	(declare (salience 100))
;?c <- (calculnoneffectue)
;(calculeffectue)
;=>
;(retract ?c)
;)

;; règle lançant la fonction pour calculer les extensions si ça n'a pas été déjà fait
(defrule extension1 
?m <- (ACLMessage (sender ?s) (receiver ?r) (communicative-act CFP))
(calculnoneffectue)
=>
(computeExtension1et2 5)
(assert (calculencours ?s ?r))
(bind ?*varGlobal*  1)
(retract ?m)
(printout t debugext1 crlf)
)

;;règle qui lance le processus si le calcul a déjà été fait
(defrule extension1bis
?m <- (ACLMessage (sender ?s)(receiver ?r) (communicative-act CFP))
(calculeffectue)
=>
(assert (calculencours ?s ?r))
(retract ?m)
(printout t debugext1b crlf)
)

;;Cette règle supprime les extensions de cardinalité 2 qui n'existent pas
(defrule extension2
(declare (salience 0)) 
(calculnoneffectue)
?k <- (Extension2 (arguments ?i ?j))
(Attack (Attacker ?i) (Attacked ?j))
=>
(assert (travailtermine))
(retract ?k)
(printout t debugext2 crlf)
)

;;cette règle crée les extensions de cardinalité 3 à partir des extensions de cardinalité 2 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension3
	(declare (salience -100))
	(calculnoneffectue)
	(Extension2 (arguments ?i ?j))
	(Extension2 (arguments ?i ?k))
	(Extension2 (arguments ?j ?k))
	=>
	(assert (Extension2 (arguments ?i ?j ?k)))
	(printout t debugext3 crlf)
)

;;cette règle crée les extensions de cardinalité 4 à partir des extensions de cardinalité 3 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension4
	(declare (salience -200))
	(calculnoneffectue)
	(Extension2 (arguments ?i ?j ?k))
	(Extension2 (arguments ?i ?k ?l))
	(Extension2 (arguments ?i ?j ?l))
	(Extension2 (arguments ?j ?k ?l))
	=>
	(assert (Extension2 (arguments ?i ?j ?k ?l)))
	(printout t debugext4 crlf)
)

;;cette règle crée les extensions de cardinalité 5 à partir des extensions de cardinalité 4 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension5
	(declare (salience -300))
	(calculnoneffectue)
	(Extension2 (arguments ?i ?j ?k ?m))
	(Extension2 (arguments ?i ?k ?l ?m))
	(Extension2 (arguments ?i ?j ?l ?m))
	(Extension2 (arguments ?j ?k ?l ?m))
	(Extension2 (arguments ?i ?j ?k ?l))
	=>
	(assert (Extension2 (arguments ?i ?j ?k ?l ?m)))
	(printout t debugext5 crlf)
)


;;cette règle crée les extensions de cardinalité 6 à partir des extensions de cardinalité 5 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)

(defrule extension6
	(declare (salience -400))
	(calculnoneffectue)
	(Extension2 (arguments ?i ?j ?k ?m ?n))
	(Extension2 (arguments ?i ?k ?l ?m ?n))
	(Extension2 (arguments ?i ?j ?l ?m ?n))
	(Extension2 (arguments ?j ?k ?l ?m ?n))
	(Extension2 (arguments ?i ?j ?k ?l ?n))
	(Extension2 (arguments ?i ?j ?k ?l ?m))
	=>
	(assert (Extension2 (arguments ?i ?j ?k ?l ?m ?n)))
	(printout t debugext6 crlf)
)


;;cette règle crée les extensions de cardinalité 7 à partir des extensions de cardinalité 6 (uniquement valable car on a l'hypothèse des attaques dans les deux sens, sans l'hypothèse il est possible que l'on rate certaines extensions)
;;On s'arrète à une cardinalité de 7 pour notre programme mais il est certains qu'à terme il faudrait pouvoir calculer les extensions de toutes cardinalité

(defrule extension7
	(declare (salience -500))
	?c <- (calculnoneffectue)
	(Extension2 (arguments ?i ?j ?k ?m ?n ?o))
	(Extension2 (arguments ?i ?k ?l ?m ?n ?o))
	(Extension2 (arguments ?i ?j ?l ?m ?n ?o))
	(Extension2 (arguments ?j ?k ?l ?m ?n ?o))
	(Extension2 (arguments ?i ?j ?k ?l ?n ?o))
	(Extension2 (arguments ?i ?j ?k ?l ?m ?o))
	(Extension2 (arguments ?i ?j ?k ?l ?m ?n))
	=>
	(retract ?k)
	(assert (Extension2 (arguments ?i ?j ?k ?l ?m ?n ?o)))
	(printout t debugext7 crlf)
	(findresult ?*varGlobal*)
	(retract ?c)
)




;;Requêtes permettant de trouver les extensions de cardinalité 1 à 7
;(defquery search-extension-7
;(Extension2(arguments ?i ?j ?k ?l ?m ?n ?o))
;)
;(defquery search-extension-6
;(Extension2(arguments ?i ?j ?k ?l ?m ?n))
;)
;(defquery search-extension-5
;(Extension2(arguments ?i ?j ?k ?l ?m))
;)
;(defquery search-extension-4
;(Extension2(arguments ?i ?j ?k ?l))
;)
;(defquery search-extension-3
;(Extension2(arguments ?i ?j ?k))
;)
;(defquery search-extension-2
;(Extension2(arguments ?i ?j))
;)
;(defquery search-extension-1
;(Extension2(arguments ?i))
;)



(bind ?compteur 7)
(bind ?cardExt 1)
(bind ?result 5)


;;Fonction permettant de trouver la taille des extensions les plus grandes
; (deffunction trouverCompteur ()
;(bind ?cardExt (count-query-results search-extension-7))
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-6))(bind ?compteur 6)
;)
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-5))(bind ?compteur 5)
;)
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-4))(bind ?compteur 4)
;)
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-3))(bind ?compteur 3)
;)
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-2))(bind ?compteur 2)
;)
;(if (eq ?cardExt 0) 
;	then (bind ?cardExt (count-query-results search-extension-1))(bind ?compteur 1)
;)
;(printout t ?cardExt crlf)
;(printout t ?compteur crlf)
;(findResult ?compteur)
;) 






;;Règle créant le message à envoyer au référent
(defrule sendExtension2
	(declare (salience -700))
	?c <- (calculencours ?s ?r)
	(Resultat (res ?res))
	=>
	;(?res next)
	(assert (ACLMessage (communicative-act INFORM) (sender ?r) (receiver ?s) (content (?res next ))))
	(retract ?c)
)

;;Règle permettant d'envoyer les messages crées
(defrule send-a-message
	(declare (salience -800))
 ?m <- (ACLMessage)
 =>
 (send ?m)
 (retract ?m)
)


