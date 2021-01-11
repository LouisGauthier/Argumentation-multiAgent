package main;

import java.io.File;
import java.util.LinkedHashMap;
import java.util.Random;

import agentAndBehaviour.DialogueAgent;
import jade.core.Profile;
import jade.core.ProfileImpl;
import jade.core.Runtime;
import jade.wrapper.AgentController;
import jade.wrapper.StaleProxyException;

public class MainClass {
	private int nbGroup;
	static jade.core.Runtime rt = Runtime.instance();
	static Profile profile = new ProfileImpl(null, 1200, null);
	private static LinkedHashMap<String, String[]> Agents = new LinkedHashMap<>();
	public static jade.wrapper.AgentContainer mainContainer = rt.createMainContainer(profile);
	String semantique = "/ressources/semantique/admissible.clp";
	private int nbInstances;
	public static void main(String[] args) {
		File repDomaine = new File("D:\\Eclipse\\workspace\\ArgumentationMultiAgent\\ressources\\connaissances\\domaine");
		String ListeD[] = repDomaine.list();
		File repComorbidite = new File("D:\\Eclipse\\workspace\\ArgumentationMultiAgent\\ressources\\connaissances\\comorbidites");
		String ListeC[] = repComorbidite.list();
		File repEntrainement = new File("D:\\Eclipse\\workspace\\ArgumentationMultiAgent\\ressources\\connaissances\\entrainement");
		String ListeE[] = repEntrainement.list();
		int i = 1;
		Random rn = new Random();
		//On ne génère qu'un ou deux référent car on a que 4 agents au total pour nos essais
		int ref1 = rn.nextInt(4);
		int ref2 = rn.nextInt(4);
		String[] argu = {};
		//création des agents de type de connaissances : domaine
		argu[1] = "domaine";
		for(String r : ListeD) {
			argu[0] = "ressources/connaissances/domaine/"+r;
			//test pour savoir si l'agent sera referent ou non
			if(i == ref1 || i == ref2)
			{
				
				argu[2] = "referent";
				argu[3] = ""+i;
			}
			else
			{
				argu[2] = "participant";
			}
			Agents.put("Agent"+i, argu);
			i+=1;
		}
		//création des agents de type de connaissances : comorbidites
		argu[1] = "comorbidites";
		for(String r : ListeC) {
			argu[0] = "ressources/connaissances/comorbidites/" + r;
			//test pour savoir si l'agent sera referent ou non
			if(i == ref1 || i == ref2)
			{
				
				argu[2] = "referent";
				argu[3] = ""+i;
			}
			else
			{
				argu[2] = "participant";
			}
			Agents.put("Agent"+i,argu);
			i+=1;
		}
		//création des agents de type de connaissances : comorbidites
		argu[1] = "entrainement";
		for(String r : ListeE) {
			argu[0] = "ressources/connaissances/entrainement/"+r;
			//test pour savoir si l'agent sera referent ou non
			if(i == ref1 || i == ref2)
			{
				
				argu[2] = "referent";
				argu[3] = ""+i;
			}
			else
			{
				argu[2] = "participant";
			}
			Agents.put("Agent"+i,argu );
			i+=1;
		}
		rt.setCloseVM(true);
		AgentController rma;
		String agentToSniff = "";
		int last = 0;
		String[] arg;
		try {
			rma = mainContainer.createNewAgent("rma",
					"jade.tools.rma.rma", new Object[0]);
			rma.start();
			for (String agent : Agents.keySet()) {
				arg = Agents.get(agent);
				AgentController TreatmentAgent = mainContainer
						.createNewAgent(
								agent,
								"agentAndBehaviour.DialogueAgent",
								new Object[] { arg });
				TreatmentAgent.start();
			}
			for (String agent : Agents.keySet()) {
				if(last < Agents.keySet().size()-1)
				{
				agentToSniff = agentToSniff+agent+";" ;
				}
				else
				{
					agentToSniff = agentToSniff+agent ;
				}
				
				last++;
			}
			// Create a Sniffer
			AgentController sniffer =
					 mainContainer.createNewAgent( "mySniffer",
					 "jade.tools.sniffer.Sniffer", new Object[]{agentToSniff});
			sniffer.start();
	        Thread.sleep(500);
			/*
			 * Create a Introspector AgentController introspector =
			 * mainContainer.createNewAgent( "myIntrospector",
			 * "jade.tools.introspector.Introspector", null);
			 * introspector.start();
			 */

		} catch (StaleProxyException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
