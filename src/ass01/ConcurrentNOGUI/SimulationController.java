package ass01.ConcurrentNOGUI;

import ass01.WithGui.SimulationView;
import ass01.WithGui.StopFlag;
import ass01.lib.Boundary;

public class SimulationController {

	private SimulationModel simModel;
	private int nWorkers;
	private Master master;
	private StopFlag stopFlag;

	public SimulationController(SimulationModel simModel, int nWorkers) {
		this.simModel = simModel;
		this.nWorkers = nWorkers;
		this.stopFlag = new StopFlag(false);
	}

	public void stop(){
		if(master != null){
			System.out.println("Stop invoked");
			stopFlag.setStopFlag(true);
		}
	}

	//todo
	public void restart(){
		simModel.reset();
		stopFlag.setStopFlag(false);
		master = new Master(simModel, nWorkers, stopFlag);
		master.start();
	}
	
	public void execute() {
		master = new Master(simModel, nWorkers, stopFlag);
		master.start();
	}
}
