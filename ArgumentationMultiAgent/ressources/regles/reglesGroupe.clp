;;QUAND ON EST PARTICIPANTS

(deftemplate alreadyInGroup)
(bind ?k (random))
(defrule proposeRejected
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	(< ?k 32000)
	=>
	(assert (ACLMessage (communicative-act REJECT-PROPOSAL)(sender ?r)(receiver ?s)))
	(retract ?m)
)

(defrule proposeAccepted
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	(KT(type ?kt))
	(>= ?k 32000)
	=>
	(assert (ACLMessage (communicative-act ACCEPT-PROPOSAL)(sender ?r)(receiver ?s)(content ?kt)))
	(retract ?m)
)

(defrule accepted
	?m <- (ACLMessage (communicative-act CONFIRM)(sender ?s)(receiver ?r)(content ?c))
	=>
	(retract ?m)
	(assert (group(num ?c)))
)

(defrule rejected
	?m <- (ACLMessage (communicative-act REJECT)(sender ?s)(receiver ?r))
	=>
	(retract ?m)
)

;;QUAND ON EST REFERENT

(defrule cancelInvite
?m <- (ACLMessage(communicative-act ACCEPT-PROPOSAL)(sender ?s)(receiver ?r)(content ?c))
?kt <- (KT(type ?c)(full true))
=>
(assert (ACLMessage (communicative-act CANCEL)(sender ?r)(receiver ?s)))
)

(defrule confirmInvite
	?m <- (ACLMessage(communicative-act ACCEPT-PROPOSAL)(sender ?s)(receiver ?r)(content ?c))
	?kt <- (KT(type ?c)(full false))
	=>
	(assert (ACLMessage (communicative-act CONFIRM)(sender ?r)(receiver ?s)))
)

(defrule sendExtension
	?m <- (ACLMessage (communicative-act CFP) (sender ?s) (receiver ?r))
	=>
	(assert (ACLMessage (communicative-act INFORM) (sender ?r) (receiver ?s) (content )))
)