within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4ComplianceNoBoundaryNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4NoInverseFromDpLoad(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase4ComplianceNoBoundaryNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 57080.43144332048
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

  Jacobian inverse norm estimate: 4.92219e+07
  Condition number estimate: 2.29908e+07
  1-norm of the residual = 110516
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatSec.valChe[2].dp = 81631.3
    pla.pumHeaWatSec.valChe[2].dp = 614.592
    pla.THeaWatSecSup.port_a.m_flow = 0.179143
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 503284
    pla.valIso.port_bHeaWat.m_flow = -0.222914
    loaCoo.con.val.valEqu.dp = 7117.61
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 49661.9
    pla.pumPri.pumHeaWat.valChe[2].dp = -454046
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 48561.2
    pla.valIso.port_aHeaWat.m_flow = 0.418563
  Last value of the residual:
    { -0.0910977, 0.364275, -0.396346, 1.54259, 1.25086,
      -106890, -47.3619, -3574.67, 0.00405315, 0.175489 }
 

Integration terminated successfulWarning: Possible chattering detected at t = 1.916117e+04 in state event(s): [47]
Final Run Statistics: ---

 Number of steps                                 : 21463
 Number of function evaluations                  : 34555
 Number of Jacobian evaluations                  : 1888
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 762
 Number of nonlinear iterations                  : 31080
 Number of nonlinear convergence failures        : 461
 Number of state function evaluations            : 26279
 Number of state events                          : 393
 Number of time events                           : 473

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 43.46633630500219 seconds.ly at T = 86400
   CPU-time for integration                  : 7.70849 seconds
   CPU-time for initialization               : 0.352829 seconds
   Number of result points                   : 2135
   Number of grid points                     : 501
   Number of accepted steps                  : 20565
   Number of rejected steps                  : 679
   Number of f-evaluations (dynamics)        : 31894
   Number of non-linear iteration            : 29999
   Number of non-linear convergence failures : 1060
   Number of Jacobian-evaluations            : 1724
   Number of crossing function evaluations   : 24612
   Number of model time events               : 477
   Number of state events                    : 342
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase4ComplianceNoBoundaryNoInverseFromDpLoad

-------------------- OCT 26 NonlinearBlockConvergenceError

Warning: Possible chattering detected at t = 1.916117e+04 in state event(s): [47]
Final Run Statistics: ---

 Number of steps                                 : 21463
 Number of function evaluations                  : 34555
 Number of Jacobian evaluations                  : 1888
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 762
 Number of nonlinear iterations                  : 31080
 Number of nonlinear convergence failures        : 461
 Number of state function evaluations            : 26279
 Number of state events                          : 393
 Number of time events                           : 473

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-01 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-01 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 43.46633630500219 seconds.

"), Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4ComplianceNoBoundaryNoInverseFromDpLoad;
