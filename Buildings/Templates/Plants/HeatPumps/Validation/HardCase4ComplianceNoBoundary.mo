within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4ComplianceNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Warning: Failed to solve nonlinear system using Newton solver.
  During initialization at time: 0
  Tag: initialization.nonlinear[3]

  Common causes:
   * The system of equations has no solution - the residual will be above zero.
     - This may be caused by initial conditions not being fully specified, check the translation log.
     - In some cases the event-logic can cause this.
   * Starting values are too far from the solution, see homotopy in the manual.
     - In rare cases this could occur at events.
   * The equations are too discontinuous for the nonlinear solver - the residual will have knees.
     - Likely caused by over-using noEvent.
  Especially consider the first two items above when the nonlinear solver fails during initialization.

  To get more information consider the options:
   * Simulation/Setup/Translation/Generate listing of translated Modelica code in dsmodel.mof
   * Simulation/Setup/Translation/List non-linear iteration variables
   * Simulation/Setup/Debug/Store variables after failed initialization
     - If a failure to solve a nonlinear equation caused failed initialization.
   * The options under the group Simulation/Setup/Debug/Nonlinear solver diagnostics

  Jacobian inverse norm estimate: 8.76795e+10
  Condition number estimate: 5.85097e+10
  1-norm of the residual = 66770.9
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatSec.valChe[2].dp = -0.0157673
    pla.pumHeaWatSec.valChe[2].dp = 0.0218888
    pla.THeaWatSecSup.port_a.m_flow = 2.3609E-05
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 300005
    pla.pumPri.pumHeaWat.valChe[2].dp = -0.00485819
    pla.valIso.port_bHeaWat.m_flow = 2.23991E-05
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 300006
    pla.valIso.port_aHeaWat.m_flow = 2.27371E-05
    pipChiWat.dp = 0.0272591
  Last value of the residual:
    { 9.22783, -26.4894, -11.074, -7.07631, -2.15279E-06,
      -28749.8, 0.00588268, -37967.2, 0.00546127 }
 
Trying to solve non-linear system using global homotopy-method.
Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase4ComplianceNoBoundary
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 57080.54946494092
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 4.01567e+10
  Condition number estimate: 2.22113e+10
  1-norm of the residual = 134932
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatSec.valChe[2].dp = 150305
    pla.pumHeaWatSec.valChe[2].dp = -1921.5
    pla.THeaWatSecSup.port_a.m_flow = 0.000763943
    pla.valIso.port_bHeaWat.m_flow = -0.32486
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 594197
    pla.pumPri.pumHeaWat.valChe[2].dp = -881814
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = -286696
    pla.valIso.port_aHeaWat.m_flow = 0.540447
    pla.port_aChiWat.m_flow = 88.2761
  Last value of the residual:
    { -0.0153998, 0.283595, 0.0418509, -0.14887, 2.02064,
      -134887, -21.8359, 20.8951, 0.00131136 }
 
SUNDIALS: CVODE CVode At t = 70447.7, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 9.93221 seconds
   CPU-time for initialization               : 0.47307 seconds
   Number of result points                   : 2139
   Number of grid points                     : 501
   Number of accepted steps                  : 21145
   Number of rejected steps                  : 701
   Number of f-evaluations (dynamics)        : 33009
   Number of non-linear iteration            : 31094
   Number of non-linear convergence failures : 1075
   Number of Jacobian-evaluations            : 1751
   Number of crossing function evaluations   : 25199
   Number of model time events               : 476
   Number of state events                    : 345
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase4ComplianceNoBoundary

---------------------- OCT

---------------------------------------------------------------------------
CVodeError                                Traceback (most recent call last)
File /mnt/home/reituag/gitrepo/docker-ubuntu-optimica/jmodelica.py:113
    109     mod.set('_log_level', 4)
    111 ######################################################################
    112 # Simulate
--> 113 res = mod.simulate(options=opts)
    114 #        logging.error(traceback.format_exc())
    116 if generate_plot:

File src/pyfmi/fmi2.pyx:4809, in pyfmi.fmi2.FMUModelME2.simulate()

File src/pyfmi/fmi_base.pyx:214, in pyfmi.fmi_base.ModelBase._exec_simulate_algorithm()

File /opt/OCT/P538-OCT/../install/Python/pyfmi/fmi_algorithm_drivers.py:672, in solve(self)

File assimulo/ode.pyx:192, in assimulo.ode.ODE.simulate()

File assimulo/ode.pyx:312, in assimulo.ode.ODE.simulate()

File assimulo/explicit_ode.pyx:137, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/explicit_ode.pyx:222, in assimulo.explicit_ode.Explicit_ODE._simulate()

File assimulo/solvers/sundials.pyx:2112, in assimulo.solvers.sundials.CVode.integrate()

File assimulo/solvers/sundials.pyx:2147, in assimulo.solvers.sundials.CVode.integrate()

CVodeError: 'The rootfinding function failed in an unrecoverable manner. At time 19161.438276.'

"), Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4ComplianceNoBoundary;
