package ass01.concurrent;

import ass01.concurrent.WithGui.ModelObserver;
import ass01.lib.Body;
import ass01.lib.Boundary;
import ass01.lib.P2d;
import ass01.lib.V2d;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class SimulationModel {

    private List<Body> bodies;
    private List<ModelObserver> observers;
    private Boundary bounds;
    private long totalIter;
    private long iter;
    private int nBodies;
    /* virtual time */
    private double vt = 0;
    /* virtual time step */
    private double dt = 0.001;

    public SimulationModel(final int nBodies, final Boundary bounds, final long totalIter){
        this.bounds = bounds;
        this.nBodies = nBodies;
        this.observers = new ArrayList<>();
        this.totalIter = totalIter;
        this.iter = 0;
    }

    // generate bodies
    public void init(){
        this.bodies = new ArrayList<>();
        Random rand = new Random(System.currentTimeMillis());
        for (int i = 0; i < nBodies; i++) {
            double x = bounds.getX0()*0.25 + rand.nextDouble() * (bounds.getX1() - bounds.getX0()) * 0.25;
            double y = bounds.getY0()*0.25 + rand.nextDouble() * (bounds.getY1() - bounds.getY0()) * 0.25;
            Body b = new Body(i, new P2d(x, y), new V2d(0, 0), 10);
            bodies.add(b);
        }
    }

    public void update(){
        //Notifica gli observer
        notifyObservers();
    }

    public void updateVirtualTime(){
        vt = vt + dt;
        iter++;
    }

    public void reset(){
        this.iter = 0;
        this.vt = 0;
//        this.init();
    }

    public long getTotalIter() {
        return totalIter;
    }

    public boolean isCompleted(){
        return totalIter == iter;
    }

    public List<Body> getBodies() {
        return bodies;
    }

    public Boundary getBounds() {
        return bounds;
    }

    public long getIter() {
        return iter;
    }

    public double getVt() {
        return vt;
    }

    public int getnBodies() { return nBodies;}

    public double getDt() { return dt;}

    public void addObserver(ModelObserver obs){
        observers.add(obs);
    }

    private void notifyObservers(){
        for (ModelObserver obs: observers){
            obs.modelUpdated(this);
        }
    }
}
