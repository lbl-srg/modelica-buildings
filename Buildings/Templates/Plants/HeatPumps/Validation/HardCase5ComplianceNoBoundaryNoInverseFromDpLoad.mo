within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase5ComplianceNoBoundaryNoInverseFromDpLoad
  "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase5NoInverseFromDpLoad(
    pla(use_cpl=true, use_bouChiWat=false, use_bouHeaWat=false))
     annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"),
    Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase5ComplianceNoBoundaryNoInverseFromDpLoad
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 50678.31205689941
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

  Jacobian inverse norm estimate: 3.63739e+07
  Condition number estimate: 340673
  1-norm of the residual = 8.38258

  Last value of the solution:
    loaHea.con.val.valEqu.dp = 0.239473
    pla.pumChiWatPri.valChe[3].dp = 8593.97
    pla.valIso.valChiWatUniOutIso[3].lin.dp = 149767
    pla.pumChiWatPri.valChe[2].dp = 8593.97
    pla.pumHeaWatPri.valChe[3].dp = 132.343
    pla.pumHeaWatPri.valChe[2].dp = 132.337
    pla.valIso.valHeaWatUniOutIso[2].lin.dp = -1585.6
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 295477
    pla.valIso.port_aHeaWat.m_flow = 0.00709165
    pla.valIso.port_aChiWat.m_flow = 66.3013
    loaCoo.con.val.valEqu.dp = 37303.1
  Last value of the residual:
    { 0.749727, -2.21202, 0.765757, -0.409913, -0.0033863,
      -0.0352734, 3.43271, 0.00065109, -0.00640339, 0.765793,
      -0.00094131 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83925.24301793271
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.93977e+10
  Condition number estimate: 6.75021e+08
  1-norm of the residual = 37.5591
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    loaHea.con.val.valEqu.dp = 3.50738
    pla.pumChiWatPri.valChe[3].dp = 3797.53
    pla.valIso.valChiWatUniOutIso[3].lin.dp = 123876
    pla.pumChiWatPri.valChe[2].dp = -148422
    pla.pumHeaWatPri.valChe[3].dp = 408.954
    pla.pumHeaWatPri.valChe[2].dp = 408.935
    pla.valIso.valHeaWatUniOutIso[2].lin.dp = -46009.2
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 312729
    pla.valIso.port_aHeaWat.m_flow = 0.0861436
    pla.valIso.port_aChiWat.m_flow = 26.718
    loaCoo.con.val.valEqu.dp = 49515.7
  Last value of the residual:
    { 0.920897, -1.77523, -1.61848, -0.920897, -0.810722,
      -28.2506, 2.27651, 0.000329613, -0.0189071, 0.964464,
      -0.00205056 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83928.26404109944
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.43518e+11
  Condition number estimate: 5.57924e+09
  1-norm of the residual = 1.36664
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    loaHea.con.val.valEqu.dp = 0.151335
    pla.pumChiWatPri.valChe[3].dp = 3723.48
    pla.valIso.valChiWatUniOutIso[3].lin.dp = 121685
    pla.pumChiWatPri.valChe[2].dp = -148643
    pla.pumHeaWatPri.valChe[3].dp = -0.167025
    pla.pumHeaWatPri.valChe[2].dp = -0.166887
    pla.valIso.valHeaWatUniOutIso[2].lin.dp = -44566.5
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 313439
    pla.valIso.port_aHeaWat.m_flow = 0.00388285
    pla.valIso.port_aChiWat.m_flow = 26.7251
    loaCoo.con.val.valEqu.dp = 49708.7
  Last value of the residual:
    { 0.0135156, 0.232549, -0.225238, -0.0135156, 0.245974,
      -0.0301217, -0.59215, -1.21553E-06, 0.000138224, 0.0134248,
      1.59901E-05 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 83940.27882604081
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.31293e+11
  Condition number estimate: 5.32941e+09
  1-norm of the residual = 1.33729
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    loaHea.con.val.valEqu.dp = 0.103319
    pla.pumChiWatPri.valChe[3].dp = 3702.61
    pla.valIso.valChiWatUniOutIso[3].lin.dp = 112006
    pla.pumChiWatPri.valChe[2].dp = -147559
    pla.pumHeaWatPri.valChe[3].dp = -0.538723
    pla.pumHeaWatPri.valChe[2].dp = -0.538526
    pla.valIso.valHeaWatUniOutIso[2].lin.dp = -38967
    pla.valIso.valHeaWatUniOutIso[1].port_a.p = 317675
    pla.valIso.port_aHeaWat.m_flow = 0.00328012
    pla.valIso.port_aChiWat.m_flow = 26.5676
    loaCoo.con.val.valEqu.dp = 49787.3
  Last value of the residual:
    { 0.00522748, 0.2515, -0.246253, -0.00522749, 0.256668,
      -0.0446283, -0.522391, -1.58257E-06, 0.000196293, 0.00516766,
      2.70837E-05 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 6.96953 seconds
   CPU-time for initialization               : 0.361558 seconds
   Number of result points                   : 1977
   Number of grid points                     : 501
   Number of accepted steps                  : 16472
   Number of rejected steps                  : 558
   Number of f-evaluations (dynamics)        : 24895
   Number of non-linear iteration            : 23322
   Number of non-linear convergence failures : 728
   Number of Jacobian-evaluations            : 1304
   Number of crossing function evaluations   : 20265
   Number of model time events               : 476
   Number of state events                    : 264
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase5ComplianceNoBoundaryNoInverseFromDpLoad

-------------------- OCT

"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-80,100},{20,40},{-80,-20},{-80,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor={0,140,72},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{0,20},{100,-40},{0,-100},{0,20}})}));
end HardCase5ComplianceNoBoundaryNoInverseFromDpLoad;
