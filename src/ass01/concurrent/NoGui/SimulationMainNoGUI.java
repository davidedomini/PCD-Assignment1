package ass01.concurrent.NoGui;

import ass01.lib.Boundary;
import ass01.concurrent.SimulationController;
import ass01.concurrent.SimulationModel;

/**
 * Bodies simulation - legacy code: sequential, unstructured
 * 
 * @author aricci
 */
public class SimulationMainNoGUI {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

        long totalIter = 1000;
        int nBodies = 100;

        SimulationModel simModel = new SimulationModel(nBodies, bounds, totalIter);
        int nWorkers = Runtime.getRuntime().availableProcessors() + 1;
        System.out.println("Available CPU: " + (nWorkers-1));
    	SimulationController simController = new SimulationController(simModel, nWorkers);
        simController.execute();
    }
}
