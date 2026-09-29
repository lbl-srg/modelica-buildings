within Buildings.Templates.Plants.Chillers.Validation;
model HardCase1Compliance "Validation of chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.HardCase1(
    pla(intChi(use_cpl=true)))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(Tolerance=1e-6,
  StopTime=86400.0,
  __Dymola_Algorithm="Cvode"), Documentation(info="Warning: The following was detected at time: 0
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1Compliance.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1Compliance.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Model: Buildings.Templates.Plants.Chillers.Validation.HardCase1Compliance
Integration started at 0 using integration method:
cvode from sundials

Warning: The following was detected at time: 37800
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 49672.23490921102
  Tag: simulation.nonlinear[3]

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

  Jacobian inverse norm estimate: 2.06975e+09
  Condition number estimate: 1.1674e+10
  1-norm of the residual = 26022.7
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.coo.inlCoo.ports_b[2].m_flow = -6.97299
    pla.pumConWat.valChe[2].dp = -6778.25
    pla.outConChi.ports_a[3].m_flow = 7.62608E-06
  Last value of the residual:
    { 22829, 3192.48, -1.19746 }
 
Warning: The following was detected at time: 70485.2972089689
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 71425.97780073156
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Warning: The following was detected at time: 74006.49520222929
  In HardCase1Compliance.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2


Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.87909 seconds
   CPU-time for initialization               : 0.354437 seconds
   Number of result points                   : 1885
   Number of grid points                     : 501
   Number of accepted steps                  : 15008
   Number of rejected steps                  : 657
   Number of f-evaluations (dynamics)        : 22669
   Number of non-linear iteration            : 21014
   Number of non-linear convergence failures : 337
   Number of Jacobian-evaluations            : 920
   Number of crossing function evaluations   : 18570
   Number of model time events               : 438
   Number of state events                    : 256
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.Chillers.Validation.HardCase1Compliance"));
end HardCase1Compliance;
