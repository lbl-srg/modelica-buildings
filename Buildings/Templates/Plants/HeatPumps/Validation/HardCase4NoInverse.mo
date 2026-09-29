within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase4NoInverse "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase4(
    pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
        valChiWatUniInlIso(lin(each use_inv=false))),
      valHeaWatMinByp(lin(use_inv=false)),
      valChiWatMinByp(lin(use_inv=false))))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase4NoInverse
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 57067.9470950238
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

  Jacobian inverse norm estimate: 3.55669e+07
  Condition number estimate: 739720
  1-norm of the residual = 99751.9

  Last value of the solution:
    pla.port_aChiWat.m_flow = 26.4602
    pla.pumChiWatSec.valChe[2].dp = 74654.9
  Last value of the residual:
    { -99700.6, -51.3541 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.16558 seconds
   CPU-time for initialization               : 0.351768 seconds
   Number of result points                   : 2127
   Number of grid points                     : 501
   Number of accepted steps                  : 19001
   Number of rejected steps                  : 609
   Number of f-evaluations (dynamics)        : 29171
   Number of non-linear iteration            : 27289
   Number of non-linear convergence failures : 927
   Number of Jacobian-evaluations            : 1601
   Number of crossing function evaluations   : 22998
   Number of model time events               : 475
   Number of state events                    : 340
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase4NoInverse

------------------- OCT 6 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 19961
 Number of function evaluations                  : 31887
 Number of Jacobian evaluations                  : 1767
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 682
 Number of nonlinear iterations                  : 28575
 Number of nonlinear convergence failures        : 456
 Number of state function evaluations            : 24267
 Number of state events                          : 351
 Number of time events                           : 475

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
 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 33.54775542399875 seconds.
"), Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase4NoInverse;
