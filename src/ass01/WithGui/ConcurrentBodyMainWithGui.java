package ass01.WithGui;

import ass01.ConcurrentNOGUI.SimulationController;
import ass01.ConcurrentNOGUI.SimulationModel;
import ass01.lib.Boundary;

public class ConcurrentBodyMainWithGui {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

    	SimulationView viewer = new SimulationView(620,620);

        long totalIter = 1000;
        int nBodies = 1000;

        SimulationModel simModel = new SimulationModel(nBodies, bounds, totalIter);
        simModel.addObserver(viewer);

        int nWorkers = Runtime.getRuntime().availableProcessors() + 1;
        System.out.println("CPU: " + nWorkers);
        SimulationController simController = new SimulationController(simModel, nWorkers);
        simController.execute();
    }
}
