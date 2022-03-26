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

        Model m = new Model(1000, bounds);
    	Simulator sim = new Simulator(viewer, m, bounds);
        sim.execute(50000);
    }
}
