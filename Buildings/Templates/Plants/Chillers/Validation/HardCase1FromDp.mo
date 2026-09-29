within Buildings.Templates.Plants.Chillers.Validation;
model HardCase1FromDp "Validation of chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.HardCase1(
    pla(intChi(valChiWatChiBypPar(from_dp=true))))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(Tolerance=1e-6,
  StopTime=86400.0,
  __Dymola_Algorithm="Cvode"), Documentation(info="Warning: The following was detected at time: 0
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1FromDp.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1FromDp.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Model: Buildings.Templates.Plants.Chillers.Validation.HardCase1FromDp
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 29439.53415377231
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

  Jacobian inverse norm estimate: 1.77578e+07
  Condition number estimate: 21880.4
  1-norm of the residual = 433.705

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = -5856.24
    pla.chi.valChiWatChiIsoPar[1].lin.dp = 39.4207
    pla.port_a.m_flow = 16.873
  Last value of the residual:
    { -400.768, 8.77472, 24.163 }
 
Warning: The following was detected at time: 37800
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 49672.43341208082
  Tag: simulation.nonlinear[2]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 2.14684e+09
  Condition number estimate: 3.31027e+09
  1-norm of the residual = 25411.3
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.coo.inlCoo.ports_b[2].m_flow = -6.60234
    pla.pumConWat.valChe[2].dp = -10900.3
    pla.outConChi.ports_a[3].m_flow = 1.4766E-05
  Last value of the residual:
    { 18108.9, 7247, 55.3879 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 49672.43341208082
  Tag: simulation.nonlinear[2]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 6.40868e+07
  Condition number estimate: 2.51082e+08
  1-norm of the residual = 30632.2
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.coo.inlCoo.ports_b[2].m_flow = -6.84524
    pla.pumConWat.valChe[2].dp = -11326.3
    pla.outConChi.ports_a[3].m_flow = 7.42064E-06
  Last value of the residual:
    { 27514.2, 3114.56, -3.45866 }
 
Warning: The following was detected at time: 70485.27908596808
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 71425.97314948036
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 74006.53217385555
  In HardCase1FromDp.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84131.84878547584
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.06254e+07
  Condition number estimate: 3.65655e+07
  1-norm of the residual = 274.772
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = 1232.7
    pla.chi.valChiWatChiIsoPar[1].lin.dp = 2.19654
    pla.port_a.m_flow = 1.54085
  Last value of the residual:
    { -251.258, 0.00812035, -23.5061 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84132.21074084583
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 3.38046e+07
  Condition number estimate: 1.03629e+08
  1-norm of the residual = 45.0224
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = 1120.61
    pla.chi.valChiWatChiIsoPar[1].lin.dp = 2.02702
    pla.port_a.m_flow = 1.51567
  Last value of the residual:
    { 14.463, -0.00920027, -30.5502 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84133.48031001192
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 3.9811e+06
  Condition number estimate: 380265
  1-norm of the residual = 170.121

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = 927.033
    pla.chi.valChiWatChiIsoPar[1].lin.dp = 1.19112
    pla.port_a.m_flow = 1.04047
  Last value of the residual:
    { 152.787, -0.265799, -17.0682 }
 

Warning: Failed to solve nonlinear system using Newton solver.
  Time: 84133.71422143998
  Tag: simulation.nonlinear[1]

  For debugging help refer to the first error message of this type.

  Jacobian inverse norm estimate: 1.89809e+09
  Condition number estimate: 4.03874e+09
  1-norm of the residual = 161.284
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = 1070.28
    pla.chi.valChiWatChiIsoPar[1].lin.dp = 1.17477
    pla.port_a.m_flow = 1.10367
  Last value of the residual:
    { -135.126, -0.00138889, -26.1563 }
 

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.38215 seconds
   CPU-time for initialization               : 0.356027 seconds
   Number of result points                   : 1855
   Number of grid points                     : 501
   Number of accepted steps                  : 14055
   Number of rejected steps                  : 675
   Number of f-evaluations (dynamics)        : 21250
   Number of non-linear iteration            : 19641
   Number of non-linear convergence failures : 307
   Number of Jacobian-evaluations            : 876
   Number of crossing function evaluations   : 17311
   Number of model time events               : 438
   Number of state events                    : 241
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.Chillers.Validation.HardCase1FromDp"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={244,125,35},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-50,60},{50,0},{-50,-60},{-50,60}})}));
end HardCase1FromDp;
