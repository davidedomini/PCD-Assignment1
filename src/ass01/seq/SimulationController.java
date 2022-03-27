package ass01.seq;

public class SimulationController {

	private SimulationModel model;

	public SimulationController(SimulationModel model) {
		this.model = model;
	}
	
	public void execute(long nSteps) {

		long iter = 0;

		/* simulation loop */

		while (iter < nSteps) {

			/* update bodies */

			model.update(iter);

			/* update iteration */
			iter++;
		}
	}
}
