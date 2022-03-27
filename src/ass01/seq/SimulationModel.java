package ass01.seq;

import ass01.seq.lib.P2d;
import ass01.seq.lib.V2d;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class SimulationModel {

    private final List<Body> bodies;
    private List<ModelObserver> observers;
    private Boundary bounds;
    private long iter;
    private int nBodies;
    /* virtual time */
    private double vt = 0;
    /* virtual time step */
    double dt = 0.001;

    public SimulationModel(final int nBodies, final Boundary bounds){
        this.bounds = bounds;
        this.nBodies = nBodies;
        bodies = new ArrayList<>();
        this.observers = new ArrayList<>();
    }

    // generate bodies
    public void init(){
        Random rand = new Random(System.currentTimeMillis());
        for (int i = 0; i < nBodies; i++) {
            double x = bounds.getX0()*0.25 + rand.nextDouble() * (bounds.getX1() - bounds.getX0()) * 0.25;
            double y = bounds.getY0()*0.25 + rand.nextDouble() * (bounds.getY1() - bounds.getY0()) * 0.25;
            Body b = new Body(i, new P2d(x, y), new V2d(0, 0), 10);
            bodies.add(b);
        }
    }

    public void update(long iter){

        this.iter = iter;

        //update bodies
        for (int i = 0; i < bodies.size(); i++) {
            Body b = bodies.get(i);

            /* compute total force on bodies */
            V2d totalForce = computeTotalForceOnBody(b);

            /* compute instant acceleration */
            V2d acc = new V2d(totalForce).scalarMul(1.0 / b.getMass());

            /* update velocity */
            b.updateVelocity(acc, dt);
        }

        for (Body b : bodies) {
            /* compute bodies new pos */
            b.updatePos(dt);
            /* check collisions with boundaries */
            b.checkAndSolveBoundaryCollision(bounds);
        }

//        for (Body b : bodies) {
//            b.checkAndSolveBoundaryCollision(bounds);
//        }

        vt = vt + dt;

        //Notifica gli observer
        notifyObservers();
    }

    private V2d computeTotalForceOnBody(Body b) {

        V2d totalForce = new V2d(0, 0);

        /* compute total repulsive force */

        for (int j = 0; j < bodies.size(); j++) {
            Body otherBody = bodies.get(j);
            if (!b.equals(otherBody)) {
                try {
                    V2d forceByOtherBody = b.computeRepulsiveForceBy(otherBody);
                    totalForce.sum(forceByOtherBody);
                } catch (Exception ex) {
                }
            }
        }

        /* add friction force */
        totalForce.sum(b.getCurrentFrictionForce());

        return totalForce;
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

    public void addObserver(ModelObserver obs){
        observers.add(obs);
    }

    private void notifyObservers(){
        for (ModelObserver obs: observers){
            obs.modelUpdated(this);
        }
    }
}
