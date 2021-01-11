package agentAndBehaviour;

import jade.core.Agent;
import jade.lang.acl.ACLMessage;


import jess.Funcall;
import jess.JessException;
import jess.RU;
import jess.Userfunction;
import jess.Value;
import jess.ValueVector;

/**
 * This class implements the Jess userfunction to send ACLMessages
 * directly from Jess.
 * It can be used by Jess by using the name <code>send</code>.
 */
public class JessSend implements Userfunction {
    // data
    DialogueAgent my_agent;
    DialogueAgentBehaviour bjb;

    public JessSend(DialogueAgent a, DialogueAgentBehaviour b) {
        my_agent = a;
        bjb = b;
    }
    

    // The name method returns the name by which the function appears in Jess
    public String getName() {
        return ("send");
    }

    //Called when (send ...) is encountered
    public Value call(ValueVector vv, jess.Context context)
        throws JessException {
        System.out.println( 
                "******** Sender *********" + my_agent.getName());
        //for (int i=0; i<vv.size(); i++) {
        //  System.out.println(" parameter " + i + "=" + vv.get(i).toString() +
        //   " type=" + vv.get(i).type());
        //  }
        //////////////////////////////////
        // Case where JESS calls (send ?m)
        if (vv.get(1).type() == RU.VARIABLE) {
            // Uncomment for JESS 5.0 vv =  context.getEngine().findFactByID(vv.get(1).factIDValue(context));
            vv = context.getEngine().findFactByID(vv.get(1)
                                                    .factValue(context)
                                                    .getFactId()); //JESS6.0
        }
        //////////////////////////////////
        // Case where JESS calls (send (assert (ACLMessage ...)))
        else if (vv.get(1).type() == RU.FUNCALL) {
            Funcall fc = vv.get(1).funcallValue(context);
            vv = fc.get(1).factValue(context);
        }

        ACLMessage msg = bjb.JessFact2ACL(context, vv);

        return Funcall.TRUE;
    }
} // end JessSend class
