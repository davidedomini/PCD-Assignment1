package ass01.ConcurrentNOGUI;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.CyclicBarrier;

public class Master extends Thread{

    private SimulationModel simModel;
    private int nWorkers;
    private List<Worker> workers;

    public Master(SimulationModel m, int nWorkers){
        this.simModel = m;
        this.nWorkers = nWorkers;
    }

    public void run(){
        simModel.init(); //generate bodies

        workers = new ArrayList<>();
        int nBodiesForWorker = (int) Math.ceil((double)(simModel.getnBodies()/nWorkers));

        // +1 perchè deve aspettare anche il master
        CyclicBarrier readyToStart = new CyclicBarrier(nWorkers + 1);
        CyclicBarrier readyToComputeNewPositions = new CyclicBarrier(nWorkers + 1);
        CyclicBarrier readyToDisplay = new CyclicBarrier(nWorkers + 1);

        int start = 0;
        for(int i = 0; i < nWorkers; i++){
            Worker w = new Worker(start, nBodiesForWorker, simModel.getBodies(),
                    simModel.getDt(), simModel.getBounds(),
                    readyToStart, readyToComputeNewPositions, readyToDisplay);
            workers.add(w);
            w.start();
            start += nBodiesForWorker;
        }

        long s = Calendar.getInstance().getTimeInMillis();

        try{
            while(!simModel.isCompleted()){
                readyToStart.await();
                readyToComputeNewPositions.await();
                readyToDisplay.await();
                simModel.updateVirtualTime();
            }
        } catch (Exception exception){ }

        long f = Calendar.getInstance().getTimeInMillis();

        System.out.println("Time:" + (f-s));

        for (Worker w: workers){
            w.interrupt();
        }
    }
}