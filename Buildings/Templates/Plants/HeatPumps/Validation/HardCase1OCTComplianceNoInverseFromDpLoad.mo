within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTComplianceNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT(
    pla(
      use_cpl=true,
      use_bouChiWat=false,
      use_bouHeaWat=false,
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTComplianceNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials

SUNDIALS: CVODE CVode At t = 27947.5, mxstep steps taken before reaching tout.

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36510.54188722441
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

  Jacobian inverse norm estimate: 1.76901e+09
  Condition number estimate: 2.00084e+07
  1-norm of the residual = 23.2239
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 309368
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 338016
    pla.valIso.valChiWatUniOutIso[3].non.dp = 138003
    pla.valIso.port_aChiWat.m_flow = 55.0226
    loaCoo.con.val.valEqu.dp = 42544.8
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 504125
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 269962
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 536240
    pla.valIso.port_aHeaWat.m_flow = 20.7711
    pipHeaWat.port_b.p = 309403
  Last value of the residual:
    { 0.00012631, 0.0211809, 3.14247, -13.3311, -2.08057,
      2.31898, -0.000113873, 2.32468, 6.37364E-06, 0.0046624 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 5.46127 seconds
   CPU-time for initialization               : 0.326832 seconds
   Number of result points                   : 1987
   Number of grid points                     : 501
   Number of accepted steps                  : 20922
   Number of rejected steps                  : 853
   Number of f-evaluations (dynamics)        : 31858
   Number of non-linear iteration            : 30070
   Number of non-linear convergence failures : 900
   Number of Jacobian-evaluations            : 1549
   Number of crossing function evaluations   : 25523
   Number of model time events               : 447
   Number of state events                    : 298
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTComplianceNoInverseFromDpLoad


---------------------- OCT 26 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 20454
 Number of function evaluations                  : 32569
 Number of Jacobian evaluations                  : 1660
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 882
 Number of nonlinear iterations                  : 29533
 Number of nonlinear convergence failures        : 399
 Number of state function evaluations            : 25399
 Number of state events                          : 312
 Number of time events                           : 445

Solver options:

 Solver                   : CVode
 Linear multistep method  : BDF
 Nonlinear solver         : Newton
 Linear solver type       : DENSE
 Maximal order            : 5
 Tolerances (absolute)    : [3.e-04 3.e-04 3.e-04 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 3.e-04 3.e-04 3.e-04 1.e-06 1.e-06
 1.e-01 1.e-01 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06 1.e-01 1.e-06
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-01 3.e-04 1.e-01 3.e-04 1.e-06 1.e-01 3.e-04 1.e-01
 3.e-04 3.e-04 1.e-01 1.e-06 1.e-01 3.e-04 1.e-01 1.e-01 1.e-01 1.e-01
 1.e-01 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 40.70999831599693 seconds."),
    Icon(graphics={
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
end HardCase1OCTComplianceNoInverseFromDpLoad;
