package ass01.seq;

/**
 * Bodies simulation - legacy code: sequential, unstructured
 * 
 * @author aricci
 */
public class SequentialBodySimulationMain {

    public static void main(String[] args) {

        Boundary bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);

    	SimulationView viewer = new SimulationView(620,620);

        SimulationModel m = new SimulationModel(1000, bounds);
        m.addObserver(viewer);

    	SimulationController sim = new SimulationController(m);
        sim.execute(50000);
    }
}
