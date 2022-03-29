package ass01.ConcurrentNOGUI;

public class SimulationController {

	private SimulationModel simModel;
	private int nWorkers;
	private Master master;

	public SimulationController(SimulationModel simModel, int nWorkers) {
		this.simModel = simModel;
		this.nWorkers = nWorkers;
	}

	public void stop(){
		if(master != null){
			System.out.println("Stop invoked");
			master.interrupt();
		}
	}

	//todo
	public void restart(){
		master = new Master(new SimulationModel(simModel.getnBodies(), simModel.getBounds(), simModel.getTotalIter()), nWorkers);
		master.start();
	}
	
	public void execute() {
		master = new Master(simModel, nWorkers);
		master.start();
	}
}
