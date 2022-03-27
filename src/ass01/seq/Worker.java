package ass01.seq;

import java.util.List;
import java.util.concurrent.CyclicBarrier;

public class Worker extends Thread{

    private int start;
    private int nBodiesForWorker;
    private List<Body> bodies;
    private CyclicBarrier readyToComputeNewPositions;
    private CyclicBarrier readyToDisplay;

    public Worker(int start, int nBodiesForWorker, List<Body> bodies, CyclicBarrier readyToComputeNewPositions, CyclicBarrier readyToDisplay) {
        this.start = start;
        this.nBodiesForWorker = nBodiesForWorker;
        this.bodies = bodies;
        this.readyToComputeNewPositions = readyToComputeNewPositions;
        this.readyToDisplay = readyToDisplay;
    }
}
