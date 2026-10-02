within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT(
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 36510.15491945578
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

  Jacobian inverse norm estimate: 2.9084e+12
  Condition number estimate: 8.02055e+10
  1-norm of the residual = 26.379
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.port_aChiWat.m_flow = 55.0817
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 578439
    loaHea.con.val.valEqu.dp = 19030.3
    pla.valIso.port_bHeaWat.m_flow = -20.669
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 291297
    pla.valIso.valChiWatUniInlIso[2].lin.dp = -58675.2
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 379792
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351317
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 523487
    loaCoo.con.val.valEqu.dp = 42616.2
    pla.pumPri.pumChiWat.valChe[1].dp = 13376.7
  Last value of the residual:
    { 3.12682, 0.0579779, 19.5047, -0.000796422, 0.977526,
      -1.02346, 0.00119687, -0.708985, 0.977526, -3.41067E-05,
      -4.49532E-06 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.96885 seconds
   CPU-time for initialization               : 0.337618 seconds
   Number of result points                   : 1983
   Number of grid points                     : 501
   Number of accepted steps                  : 20441
   Number of rejected steps                  : 851
   Number of f-evaluations (dynamics)        : 31353
   Number of non-linear iteration            : 29571
   Number of non-linear convergence failures : 888
   Number of Jacobian-evaluations            : 1530
   Number of crossing function evaluations   : 24984
   Number of model time events               : 446
   Number of state events                    : 297
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTNoInverseFromDpLoad

-------------- OCT 166 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 20899
 Number of function evaluations                  : 33428
 Number of Jacobian evaluations                  : 1708
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 911
 Number of nonlinear iterations                  : 30388
 Number of nonlinear convergence failures        : 415
 Number of state function evaluations            : 25731
 Number of state events                          : 314
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
 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08
 3.e-04 1.e-06 3.e-04 3.e-04 1.e-06 3.e-04 1.e-01 1.e-01 1.e-08 3.e-04
 1.e-06 3.e-04 3.e-04 1.e-06 1.e-01 1.e-01]
 Tolerances (relative)    : 1e-06

Simulation interval    : 0.0 - 86400.0 seconds.
Elapsed simulation time: 29.462285425001028 seconds."),
    Icon(graphics={
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
end HardCase1OCTNoInverseFromDpLoad;
