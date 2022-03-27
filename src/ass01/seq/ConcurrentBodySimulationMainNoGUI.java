package ass01.seq;

/**
 * Bodies simulation - legacy code: sequential, unstructured
 * 
 * @author aricci
 */
public class ConcurrentBodySimulationMainNoGUI {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

//    	SimulationView viewer = new SimulationView(620,620);

        long totalIter = 1000;
        int nBodies = 1000;

        SimulationModel simModel = new SimulationModel(nBodies, bounds, totalIter);
//        simModel.addObserver(viewer);

        int nWorkers = Runtime.getRuntime().availableProcessors() + 1;
    	SimulationController simController = new SimulationController(simModel, nWorkers);
        simController.execute();
    }
}
