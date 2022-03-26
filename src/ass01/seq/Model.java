package ass01.seq;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Model {

    private final List<Body> bodies;
    private Boundary bounds;

    public Model(final int nBodies, final Boundary bounds){
        //Generazione dei bodies
        //bounds = new Boundary(-6.0, -6.0, 6.0, 6.0);
        this.bounds = bounds;
        Random rand = new Random(System.currentTimeMillis());
        bodies = new ArrayList<>();
        for (int i = 0; i < nBodies; i++) {
            double x = bounds.getX0()*0.25 + rand.nextDouble() * (bounds.getX1() - bounds.getX0()) * 0.25;
            double y = bounds.getY0()*0.25 + rand.nextDouble() * (bounds.getY1() - bounds.getY0()) * 0.25;
            Body b = new Body(i, new P2d(x, y), new V2d(0, 0), 10);
            bodies.add(b);
        }
    }

    public ArrayList<Body> update(){
        //Aggiorna i bodies
        double dt = 0.001;
        for (int i = 0; i < bodies.size(); i++) {
            Body b = bodies.get(i);

            /* compute total force on bodies */
            V2d totalForce = computeTotalForceOnBody(b);

            /* compute instant acceleration */
            V2d acc = new V2d(totalForce).scalarMul(1.0 / b.getMass());

            /* update velocity */
            b.updateVelocity(acc, dt);
        }

        /* compute bodies new pos */

        for (Body b : bodies) {
            b.updatePos(dt);
        }

        /* check collisions with boundaries */

        for (Body b : bodies) {
            b.checkAndSolveBoundaryCollision(bounds);
        }

        //Notifica gli observer

        return (ArrayList<Body>) this.bodies;
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

}
