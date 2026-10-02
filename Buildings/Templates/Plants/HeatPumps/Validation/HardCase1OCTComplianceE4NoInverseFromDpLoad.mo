within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTComplianceE4NoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCT(
    pla(
      use_cpl=true,
      C=1e-4,
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
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTComplianceE4NoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 31605.48152027483
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

  Jacobian inverse norm estimate: 3.06058e+08
  Condition number estimate: 5.09689e+06
  1-norm of the residual = 20.7272
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 269412
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 544051
    pla.valIso.valChiWatUniOutIso[3].non.dp = 183463
    pla.valIso.port_aChiWat.m_flow = 31.5653
    loaCoo.con.val.valEqu.dp = 7364.08
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 333840
    pla.valIso.valHeaWatUniInlIso[1].port_b.p = 270986
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 509209
    pla.valIso.port_aHeaWat.m_flow = 38.1696
    pipHeaWat.port_b.p = 270987
  Last value of the residual:
    { 0.0243233, -0.000985175, 18.9642, -0.694654, -0.323838,
      0.305883, 0.357793, -0.0518943, 1.68668E-06, -0.00361999 }
 
SUNDIALS: CVODE CVode At t = 44673.5, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 5.41487 seconds
   CPU-time for initialization               : 0.332263 seconds
   Number of result points                   : 1987
   Number of grid points                     : 501
   Number of accepted steps                  : 20514
   Number of rejected steps                  : 845
   Number of f-evaluations (dynamics)        : 31396
   Number of non-linear iteration            : 29608
   Number of non-linear convergence failures : 906
   Number of Jacobian-evaluations            : 1550
   Number of crossing function evaluations   : 25028
   Number of model time events               : 447
   Number of state events                    : 298
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTComplianceE4NoInverseFromDpLoad

------------------------ OCT 26 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 20642
 Number of function evaluations                  : 32838
 Number of Jacobian evaluations                  : 1656
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 898
 Number of nonlinear iterations                  : 29821
 Number of nonlinear convergence failures        : 395
 Number of state function evaluations            : 25425
 Number of state events                          : 308
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
Elapsed simulation time: 29.328826297001797 seconds.
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
end HardCase1OCTComplianceE4NoInverseFromDpLoad;
