package ass01.seq;

public class SimulationController {

	private SimulationModel simModel;
	private int nWorkers;

	public SimulationController(SimulationModel simModel, int nWorkers) {
		this.simModel = simModel;
		this.nWorkers = nWorkers;
	}
	
	public void execute() {
		Master master = new Master(simModel, nWorkers);
		master.start();
	}
}
