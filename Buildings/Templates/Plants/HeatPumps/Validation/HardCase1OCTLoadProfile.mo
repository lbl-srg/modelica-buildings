within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1OCTLoadProfile "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTBoundaryHPOutletNoInverseFromDpLoad(
    ratLoa(
    table=[
      0, 0, 0;
      5, 0, 0;
      7, 1, 0;
      10, 0.5, 0;
      14, 0, 0.6;
      16, 0, 1;
      18, 0, 0.6;
      22, 0.1, 0.1;
      24, 0, 0]))
    annotation(IconMap(primitivesVisible=false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
  Documentation(
    info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTLoadProfile
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 28333.29588471402
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

  Jacobian inverse norm estimate: 1.32586e+12
  Condition number estimate: 2.41669e+10
  1-norm of the residual = 38.391
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -0.0272093
    loaCoo.con.val.valEqu.dp = 0.010179
    pla.valIso.port_aChiWat.m_flow = 0.000539216
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 25375.6
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351268
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 451496
    loaHea.con.val.valEqu.dp = 3449.39
    pla.valIso.port_bHeaWat.m_flow = -22.2608
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 389522
    loaHea.port_a.p = 366134
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 366154
  Last value of the residual:
    { -1.2719, 0.167706, 17.2522, -3.6311, -1.39117,
      3.77934, -3.63102, 3.63557, 3.63099, -1.60394E-06,
      4.89977E-06 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 28360.62295764788
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.24097e+12
  Condition number estimate: 1.68363e+10
  1-norm of the residual = 10.119
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumPri.pumChiWat.valChe[1].dp = -0.00335935
    loaCoo.con.val.valEqu.dp = 0.00016198
    pla.valIso.port_aChiWat.m_flow = 8.78736E-06
    pla.valIso.valChiWatUniOutIso[1].lin.dp = 4404.84
    pla.valIso.valHeaWatUniInlIso[2].port_b.p = 351325
    pla.valIso.valHeaWatUniOutIso[3].port_a.p = 358288
    loaHea.con.val.valEqu.dp = 262.979
    pla.valIso.port_bHeaWat.m_flow = -5.78908
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 356702
    loaHea.port_a.p = 352673
    pla.valIso.valHeaWatUniOutIso[2].port_a.p = 352675
  Last value of the residual:
    { -0.786455, 0.0192816, 4.2321, -0.764326, -1.05664,
      0.966172, -0.764398, 0.765268, 0.76435, -2.32229E-07,
      2.09696E-06 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.48933 seconds
   CPU-time for initialization               : 0.334764 seconds
   Number of result points                   : 1871
   Number of grid points                     : 501
   Number of accepted steps                  : 18502
   Number of rejected steps                  : 867
   Number of f-evaluations (dynamics)        : 28827
   Number of non-linear iteration            : 27309
   Number of non-linear convergence failures : 899
   Number of Jacobian-evaluations            : 1458
   Number of crossing function evaluations   : 21911
   Number of model time events               : 451
   Number of state events                    : 236
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1OCTLoadProfile


---------------------- OCT 172 NonlinearBlockConvergenceError

Final Run Statistics: --- e+04

 Number of steps                                 : 19473
 Number of function evaluations                  : 31338
 Number of Jacobian evaluations                  : 1598
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 919
 Number of nonlinear iterations                  : 28488
 Number of nonlinear convergence failures        : 384
 Number of state function evaluations            : 23017
 Number of state events                          : 262
 Number of time events                           : 451

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
Elapsed simulation time: 24.697847636999995 seconds."),
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
end HardCase1OCTLoadProfile;
