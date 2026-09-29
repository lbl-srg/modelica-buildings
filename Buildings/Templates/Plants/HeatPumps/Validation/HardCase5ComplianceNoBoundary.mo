within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase5ComplianceNoBoundary
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase5(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase5ComplianceNoBoundary
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 24296.35324699051
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

  Jacobian inverse norm estimate: 3.31599e+06
  Condition number estimate: 1.86456e+08
  1-norm of the residual = 18.8608
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 14875.8
    pla.pumChiWatPri.valChe[3].dp = -2935.77
    pla.pumChiWatPri.valChe[2].dp = -2935.75
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 3935.14
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 294244
    pla.valIso.port_aHeaWat.m_flow = 54.6346
    VHeaWat_flow.port_a.m_flow = 39.0295
    pla.pumHeaWatPri.valChe[2].dp = 14872.5
    pla.valIso.valHeaWatUniOutIso[3].lin.dp = 45998.8
    pla.port_aChiWat.m_flow = -1.44908E-08
  Last value of the residual:
    { -1.21459, 0.160729, -0.133511, -0.0165652, 0.0214845,
      0.00167341, -0.21963, -16.9176, 0.153, -0.0220476 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 26835.76906376291
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 5.63008e+06
  Condition number estimate: 5.61753e+06
  1-norm of the residual = 8.04364
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 825.779
    pla.pumChiWatPri.valChe[3].dp = 85.3894
    pla.pumChiWatPri.valChe[2].dp = 85.3883
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 39350.8
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 370977
    pla.valIso.port_aHeaWat.m_flow = 0.806802
    VHeaWat_flow.port_a.m_flow = 0.413086
    pla.pumHeaWatPri.valChe[2].dp = 825.789
    pla.valIso.valHeaWatUniOutIso[3].lin.dp = 34.9553
    pla.port_aChiWat.m_flow = 2.97836E-08
  Last value of the residual:
    { 3.56571, -2.24121, 1.81273, -0.00702547, -0.00111098,
      5.4701E-07, -0.0169871, 0.010463, -0.388401, 2.30451E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 26838.77883723937
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.28995e+07
  Condition number estimate: 3.014e+09
  1-norm of the residual = 226.298
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumHeaWatPri.valChe[3].dp = 7438.97
    pla.pumChiWatPri.valChe[3].dp = -3173.08
    pla.pumChiWatPri.valChe[2].dp = -3174.48
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 4528.35
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 337671
    pla.valIso.port_aHeaWat.m_flow = 39.6807
    VHeaWat_flow.port_a.m_flow = 30.5639
    pla.pumHeaWatPri.valChe[2].dp = 7457.46
    pla.valIso.valHeaWatUniOutIso[3].lin.dp = 49731.8
    pla.port_aChiWat.m_flow = 1.59741E-08
  Last value of the residual:
    { 75.6597, 26.6548, -1.40986, -25.2706, -1.39751,
      0.00345298, 0.227676, 86.9076, -8.67622, -0.0901008 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.71485 seconds
   CPU-time for initialization               : 0.357436 seconds
   Number of result points                   : 1961
   Number of grid points                     : 501
   Number of accepted steps                  : 16473
   Number of rejected steps                  : 548
   Number of f-evaluations (dynamics)        : 24804
   Number of non-linear iteration            : 23253
   Number of non-linear convergence failures : 712
   Number of Jacobian-evaluations            : 1288
   Number of crossing function evaluations   : 20202
   Number of model time events               : 476
   Number of state events                    : 256
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase5ComplianceNoBoundary

------------------------- OCT 

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
end HardCase5ComplianceNoBoundary;
