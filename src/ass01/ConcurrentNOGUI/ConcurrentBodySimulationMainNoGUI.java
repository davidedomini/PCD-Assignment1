package ass01.ConcurrentNOGUI;

import ass01.lib.Boundary;

/**
 * Bodies simulation - legacy code: sequential, unstructured
 * 
 * @author aricci
 */
public class ConcurrentBodySimulationMainNoGUI {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

//    	SimulationView viewer = new SimulationView(620,620);

        long totalIter = 10000;
        int nBodies = 5000;

        SimulationModel simModel = new SimulationModel(nBodies, bounds, totalIter);
//        simModel.addObserver(viewer);

        int nWorkers = Runtime.getRuntime().availableProcessors() + 1;
        System.out.println("CPU: " + nWorkers);
    	SimulationController simController = new SimulationController(simModel, nWorkers);
        simController.execute();
    }
}