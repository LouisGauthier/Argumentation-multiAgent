package agentAndBehaviour;

import group.AgentGroup;
import jade.core.Agent;

public class DialogueAgent extends Agent{
	private String role = "Talker";
	//private AgentGroup myGroup;
	private String knowledgeType;
	private int group = 0;
	private int nbInstance = 1;
	protected void setup() {
	    // add the behaviour
	    // 1 is the number of steps that must be executed at each run of
	    // the Jess engine before giving back the control to the Java code
		
		//Traiter requête
		System.out.println((String)getArguments()[0]);
	    addBehaviour(new DialogueAgentBehaviour(this,"ressources/reglesDialogue.clp")); 
	    String[] argu = (String[])getArguments();
	    //utilisation des arguments
	    addBehaviour(new DialogueAgentBehaviour(this,argu[0]));
	    setKT(argu[1]);
	    setRole(argu[2]);
	    if(getRole() == "referent")
	    {
	    	setAGroup(Integer.parseInt(argu[3]));
	    }
	    
	    //regles d'argumentation
	  }
	
	public String getRole() {
		return this.role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	/*public AgentGroup getGroup() {
		return this.myGroup;
	}
	public void setGroup(AgentGroup group) {
		this.myGroup = group;
	}*/
	public int getAGroup() {
		return this.group;
	}
	public void setAGroup(int group) {
		this.group = group;
	}
	public void setKT(String kt) {
		this.knowledgeType = kt;
	}
	public String getKT() {
		return this.knowledgeType;
	}

}
