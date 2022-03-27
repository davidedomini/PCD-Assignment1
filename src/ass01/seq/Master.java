package ass01.seq;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CyclicBarrier;

public class Master extends Thread{

    private SimulationModel model;
    private int nWorkers;
    private List<Worker> workers;
    private int nTotalIterations;

    public Master(SimulationModel m, int nWorkers, int nTotalIterations){
        this.model = m;
        this.nWorkers = nWorkers;
        this.nTotalIterations = nTotalIterations;
    }

    public void run(){
        model.init(); //generate bodies

        workers = new ArrayList<>();
        int nBodiesForWorker = (int) Math.ceil((double)(model.getnBodies()/nWorkers));

        CyclicBarrier readyToComputeNewPositions = new CyclicBarrier(nWorkers);
        CyclicBarrier readyToDisplay = new CyclicBarrier(nWorkers);

        int start = 0;
        for(int i = 0; i < nWorkers; i++){
            Worker w = new Worker(start, nBodiesForWorker, model.getBodies(),
                    readyToComputeNewPositions, readyToDisplay);
            workers.add(w);
            w.start();
            start += nBodiesForWorker;
        }

        try{

        } catch (Exception exception){

        }

    }
}
