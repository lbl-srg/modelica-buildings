within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1ComplianceNoBoundaryNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceNoBoundary(
    pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
        valChiWatUniInlIso(lin(each use_inv=false))),
      valHeaWatMinByp(lin(use_inv=false)),
      valChiWatMinByp(lin(use_inv=false))),
    loaCoo(con(val(from_dp=true, valEqu(use_inv=false)))),
    loaHea(con(val(from_dp=true, valEqu(use_inv=false)))))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceNoBoundaryNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 85196.64649522792
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

  Jacobian inverse norm estimate: 1.18641e+10
  Condition number estimate: 8.68957e+08
  1-norm of the residual = 6.70577
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -1675.03
    pla.pumPri.pumHeaWat.valChe[1].dp = -2181.08
    pla.pumPri.pumChiWat.valChe[2].dp = -1674.94
    pla.pumPri.pumHeaWat.valChe[2].dp = -2180.99
    pla.valIso.port_aHeaWat.m_flow = 0.198483
    pipHeaWat.port_b.p = 351501
    pla.pumPri.pumChiWat.valChe[3].dp = -248.855
    pla.pumPri.pumHeaWat.valChe[3].dp = -762.667
    loaCoo.con.val.valEqu.dp = -3.30676
  Last value of the residual:
    { 1.40863E-07, 4.73133E-05, 0.0446107, 1.99276, -1.9922,
      0.000560862, 2.19133, 2.61779E-05, -0.484227 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.23275 seconds
   CPU-time for initialization               : 0.314854 seconds
   Number of result points                   : 1625
   Number of grid points                     : 501
   Number of accepted steps                  : 17158
   Number of rejected steps                  : 586
   Number of f-evaluations (dynamics)        : 26197
   Number of non-linear iteration            : 24999
   Number of non-linear convergence failures : 970
   Number of Jacobian-evaluations            : 1440
   Number of crossing function evaluations   : 19779
   Number of model time events               : 419
   Number of state events                    : 145
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1ComplianceNoBoundaryNoInverseFromDpLoad

--------------------- OCT 0 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 19395
 Number of function evaluations                  : 30195
 Number of Jacobian evaluations                  : 1590
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 641
 Number of nonlinear iterations                  : 27931
 Number of nonlinear convergence failures        : 432
 Number of state function evaluations            : 21794
 Number of state events                          : 148
 Number of time events                           : 416

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01
 1.e-08 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01
 1.e-06 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04
 1.e-01 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01
 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 21.88723832800315 seconds.
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
end HardCase1ComplianceNoBoundaryNoInverseFromDpLoad;
