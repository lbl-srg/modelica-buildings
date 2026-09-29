within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1NLoadsNoInverseFromDpLoad
  "Validation of AWHP plant template with a distributed set of terminal loads"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoads(
    pla(
      valIso(
        valHeaWatUniOutIso(lin(each use_inv=false)),
        valHeaWatUniInlIso(lin(each use_inv=false)),
        valChiWatUniOutIso(lin(each use_inv=false)),
        valChiWatUniInlIso(lin(each use_inv=false))),
      valHeaWatMinByp(lin(use_inv=false)),
      valChiWatMinByp(lin(use_inv=false))),
    loaCoo(con(val(each from_dp=true, valEqu(each use_inv=false)))),
    loaHea(con(val(each from_dp=true, valEqu(each use_inv=false)))))
    annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
  Documentation(
    info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoadsNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 27320.44644792662
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

  Jacobian inverse norm estimate: 3.78631e+08
  Condition number estimate: 1.71272e+08
  1-norm of the residual = 37452.7
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[2].dp = -48211.2
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 402880
    loaCoo[12].con.val.valEqu.dp = -1.21118
    loaCoo[11].con.val.valEqu.dp = -1.21118
    loaCoo[10].con.val.valEqu.dp = -1.21118
    pla.pumPri.pumChiWat.valChe[3].dp = -54871.5
    pla.valIso.valHeaWatUniInlIso[3].port_b.p = 359429
    loaHea[12].con.val.valEqu.dp = -54117.6
    loaHea[11].con.val.valEqu.dp = -72840.5
    loaHea[10].con.val.valEqu.dp = -92433.3
    loaHea[9].con.val.valEqu.dp = -112328
    loaHea[8].con.val.valEqu.dp = -132260
    loaHea[7].con.val.valEqu.dp = -152144
    loaHea[6].con.val.valEqu.dp = -171978
    loaHea[5].con.val.valEqu.dp = -191780
    loaHea[4].con.val.valEqu.dp = -211567
    loaHea[3].con.val.valEqu.dp = -231350
    loaHea[2].con.val.valEqu.dp = -251130
    loaHea[1].con.val.valEqu.dp = -272021
    pla.pumPri.pumHeaWat.valChe[2].dp = 5468.16
    pla.valIso.valChiWatUniInlIso[3].lin.dp = 54630.8
    pla.valIso.port_aChiWat.m_flow = -0.0187968
    loaCoo[1].con.val.valEqu.dp = -1.12273
    loaCoo[2].con.val.valEqu.dp = -1.21118
    loaCoo[3].con.val.valEqu.dp = -1.21118
    loaCoo[4].con.val.valEqu.dp = -1.21118
    loaCoo[5].con.val.valEqu.dp = -1.21118
    loaCoo[6].con.val.valEqu.dp = -1.21118
    loaCoo[7].con.val.valEqu.dp = -1.21118
    loaCoo[8].con.val.valEqu.dp = -1.21118
    loaCoo[9].con.val.valEqu.dp = -1.21118
  Last value of the residual:
    { -0.0884421, -0.0884421, -0.0884421, -0.0884421, -0.0884421,
      -0.0884421, -0.0884421, -0.0884421, -0.0884421, -0.0884421,
      -0.0884421, 1114.43, 1119.22, 1125.76, 1137.73,
      1163.98, 1220.77, 1326.23, 1472.02, 1555.93,
      1270.22, -66.5546, -21.81, -7.61152, -24524.1,
      241.875, -0.000403751, 2.57295, -2.55183, -0.0403493,
      -78.3758 }
 
SUNDIALS: CVODE CVode At t = 45767.2, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 51193.8, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 36.6472 seconds
   CPU-time for initialization               : 0.420241 seconds
   Number of result points                   : 1611
   Number of grid points                     : 501
   Number of accepted steps                  : 15926
   Number of rejected steps                  : 512
   Number of f-evaluations (dynamics)        : 24475
   Number of non-linear iteration            : 23281
   Number of non-linear convergence failures : 915
   Number of Jacobian-evaluations            : 1373
   Number of crossing function evaluations   : 18555
   Number of model time events               : 417
   Number of state events                    : 140
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1NLoadsNoInverseFromDpLoad



-------------------- OCT 0 NL failure

Final Run Statistics: ---

 Number of steps                                 : 15803
 Number of function evaluations                  : 25115
 Number of Jacobian evaluations                  : 1501
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 490
 Number of nonlinear iterations                  : 22869
 Number of nonlinear convergence failures        : 446
 Number of state function evaluations            : 18252
 Number of state events                          : 145
 Number of time events                           : 414

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
 1.e-01 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06
 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04
 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06
 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04
 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04
 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06
 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04
 1.e-01 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01
 1.e-01 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01
 1.e-08 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 153.55450463200032 seconds.",
    revisions="<html>
<ul>
<li>
September 18, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
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
end HardCase1NLoadsNoInverseFromDpLoad;
