;;Règles correspondant aux participants


(bind ?k (random))
(assert (Rand ?k))
(defrule proposeRejected
	(Role participant)
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	(Rand(< ?k 32000))
	=>
	(assert (ACLMessage (communicative-act REJECT-PROPOSAL)(sender ?r)(receiver ?s)))
	(retract ?m)
)

(defrule proposeAccepted
	(Role participant)
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	(KT(type ?kt))
	Rand((>= ?k 32000))
	=>
	(assert (ACLMessage (communicative-act ACCEPT-PROPOSAL)(sender ?r)(receiver ?s)(content ?kt)))
	(retract ?m)
)

(defrule accepted
	(Role participant)
	?g <- (group)
	?m <- (ACLMessage (communicative-act CONFIRM)(sender ?s)(receiver ?r)(content ?c))
	=>
	(retract ?m)
	(assert (group(num ?c)))
	(retract ?g)
)

(defrule rejected
	(Role participant)
	?m <- (ACLMessage (communicative-act CANCEL)(sender ?s)(receiver ?r))
	=>
	(retract ?m)
)

;;Règles correspondant aux référents

(defrule cancelInvite
	(Role referent)
?m <- (ACLMessage(communicative-act ACCEPT-PROPOSAL)(sender ?s)(receiver ?r)(content ?c))
?kt <- (KTinGroup (type ?c) (full true))
=>
(assert (ACLMessage (communicative-act CANCEL)(sender ?r)(receiver ?s)))
)

(defrule confirmInvite
	(Role referent)
	?m <- (ACLMessage(communicative-act ACCEPT-PROPOSAL)(sender ?s)(receiver ?r)(content ?c))
	?kt <- (KTinGroup (type ?c) (full false))
	=>
	(assert (ACLMessage (communicative-act CONFIRM)(sender ?r)(receiver ?s)))
)



