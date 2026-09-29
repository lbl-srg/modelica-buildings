within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase2ComplianceNoBoundaryNoInverse
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverse(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
  annotation(IconMap(primitivesVisible = false));

annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(revisions="NL solver failures in Buildings/dslog.txt
  Reported blocks (with diagnostics)  : 1

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.8595 seconds
   CPU-time for initialization               : 0.35376 seconds
   Number of result points                   : 1973
   Number of grid points                     : 501
   Number of accepted steps                  : 16631
   Number of rejected steps                  : 569
   Number of f-evaluations (dynamics)        : 25598
   Number of non-linear iteration            : 24048
   Number of non-linear convergence failures : 889
   Number of Jacobian-evaluations            : 1466
   Number of crossing function evaluations   : 20172
   Number of model time events               : 477
   Number of state events                    : 261
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2BoundaryHPOutlet",
        info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverseComplianceNoBoundary
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 22018.54766986047
  Tag: simulation.nonlinear[1]

  Common causes:
   * The system of equations has no solution - the residual will be above zero.
     - In some cases the event-logic can cause this.
   * Starting values are too far from the solution.
     - In rare cases this could occur at events.
   * The equations are too discontinuous for the nonlinear solver - the residual will have knees.
     - Likely caused by over-using noEvent.

  To get more information consider the options:
   * Simulation/Setup/Translation/Generate listing of translated Modelica code in dsmodel.mof
   * Simulation/Setup/Translation/List non-linear iteration variables
   * The options under the group Simulation/Setup/Debug/Nonlinear solver diagnostics

  Jacobian inverse norm estimate: 1.26356e+07
  Condition number estimate: 7.244e+08
  1-norm of the residual = 2.01597
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[3].dp = -150.888
    pla.pumHeaWatPri.valChe[3].dp = 5710.38
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 352179
    pla.valIso.port_aHeaWat.m_flow = 33.8267
    VHeaWat_flow.port_a.m_flow = 25.2397
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 352087
    pla.pumHeaWatPri.valChe[2].dp = 5710.22
    pla.pumChiWatPri.valChe[2].dp = -150.873
    pla.valIso.valChiWatUniOutIso[3].lin.dp = 59281
    pla.port_aChiWat.m_flow = 8.58139E-09
  Last value of the residual:
    { 0.765272, 0.0206056, -0.129602, 0.0778227, 0.0152307,
      0.00306386, 0.111949, -0.827149, 0.0606394, 0.00464117 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.72106 seconds
   CPU-time for initialization               : 0.359469 seconds
   Number of result points                   : 1993
   Number of grid points                     : 501
   Number of accepted steps                  : 16489
   Number of rejected steps                  : 570
   Number of f-evaluations (dynamics)        : 25234
   Number of non-linear iteration            : 23656
   Number of non-linear convergence failures : 833
   Number of Jacobian-evaluations            : 1413
   Number of crossing function evaluations   : 20167
   Number of model time events               : 479
   Number of state events                    : 269
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase2NoInverseComplianceNoBoundary

---------------------------------------------------------------------------
FMUException                              Traceback (most recent call last)
File /mnt/home/reituag/gitrepo/docker-ubuntu-optimica/jmodelica.py:113
    109     mod.set('_log_level', 4)
    111 ######################################################################
    112 # Simulate
--> 113 res = mod.simulate(options=opts)
    114 #        logging.error(traceback.format_exc())
    116 if generate_plot:

File src/pyfmi/fmi2.pyx:4809, in pyfmi.fmi2.FMUModelME2.simulate()

File src/pyfmi/fmi_base.pyx:212, in pyfmi.fmi_base.ModelBase._exec_simulate_algorithm()

File /opt/OCT/P538-OCT/../install/Python/pyfmi/fmi_algorithm_drivers.py:348, in __init__(self, start_time, final_time, input, model, options)

File src/pyfmi/fmi2.pyx:1350, in pyfmi.fmi2.FMUModelBase2.initialize()

File src/pyfmi/fmi2.pyx:1298, in pyfmi.fmi2.FMUModelBase2.enter_initialization_mode()

FMUException: Enter Initialize returned with an error. Check the log for information (model.get_log)."),
    Icon(graphics={
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
end HardCase2ComplianceNoBoundaryNoInverse;
