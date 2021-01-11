(defrule request 
	?m <- (ACLMessage (communicative-act REQUEST)(content ?c)(sender ?s)(receiver ?r)) 
	=>
	(assert (Chercher un traitement ?c))
)

(defrule proposeRejected
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	(alreadyInGroup)
	=>
	(assert (ACLMessage (communicative-act REJECT-PROPOSAL)(sender ?r)(receiver ?s)))
	)

(defrule proposeAccepted
	?m <- (ACLMessage (communicative-act PROPOSE)(sender ?s)(receiver ?r))
	=>
	(assert (ACLMessage (communicative-act ACCEPT-PROPOSAL)(sender ?r)(receiver ?s)))
)