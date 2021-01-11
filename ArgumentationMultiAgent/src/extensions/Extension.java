package extensions;
import java.io.Serializable;
import java.util.List;
public class Extension implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private List<Integer> arguments;
	public List<Integer> getArg()
	{
		return arguments;
	}
	
	public void setArg(List<Integer> args)
	{
		this.arguments = args;
	}
	
	public void addArg(int arg)
	{
		arguments.add(arg);
	}
}
