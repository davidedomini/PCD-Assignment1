package ass01.concurrent.WithGui;

import ass01.concurrent.SimulationController;
import ass01.concurrent.SimulationModel;
import ass01.lib.Boundary;

public class SimulationMainWithGui {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

        long totalIter = 1000;
        int nBodies = 1000;

        SimulationModel simModel = new SimulationModel(nBodies, bounds, totalIter);

        int nWorkers = Runtime.getRuntime().availableProcessors() + 1;
        System.out.println("CPU: " + nWorkers);
        SimulationController simController = new SimulationController(simModel, nWorkers);

        SimulationView viewer = new SimulationView(620,620, simController);
        simModel.addObserver(viewer);
        simController.execute();
    }
}
