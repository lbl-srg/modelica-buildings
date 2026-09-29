within Buildings.Templates.Plants.Chillers.Validation;
model HardCase1
  "Validation of chiller plant template"
  extends Buildings.Templates.Plants.Chillers.Validation.WaterCooled(
    pla(
      ctl(
        locSenFloChiWatPri=Buildings.Templates.Plants.Chillers.Types.SensorLocation.Supply,
        have_senDpChiWatRemWir=false,
        typCtlHea=Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByChiller),
      redeclare Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve eco))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(Tolerance=1e-6,
  StopTime=86400.0,
  __Dymola_Algorithm="Cvode"),
    Icon(graphics={
        Polygon(lineColor = {0,0,255},
                fillColor={238,46,47},
                pattern = LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-50,60},{50,0},{-50,-60},{-50,60}})}),
    Documentation(info="Warning: The following was detected at time: 0
  In HardCase1.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1.pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index > 0 and pla.ctl.ctl.dowProCon.dowSta.minChiWatSet.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiRat.index <= 2

Warning: The following was detected at time: 0
  In HardCase1.pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index > 0 and pla.ctl.ctl.upProCon.minChiWatFlo.nexChiMaxFlo.index <= 2

Warning: The following was detected at time: 0
  In HardCase1.pla.ctl.ctl.dowProCon.curDisChi: The extract index is out of the range.
With: index=0
  Failed condition: pla.ctl.ctl.dowProCon.curDisChi.index > 0 and pla.ctl.ctl.dowProCon.curDisChi.index <= 2

Model: Buildings.Templates.Plants.Chillers.Validation.HardCase1
Integration started at 0 using integration method:
cvode from sundials


Warning: Failed to solve nonlinear system using Newton solver.
  Time: 30820.79078302091
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

  Jacobian inverse norm estimate: 2.9724e+08
  Condition number estimate: 5.14083e+08
  1-norm of the residual = 227.344
  The estimates indicate that the Jacobian is close to singular, suggesting that there is no solution.

  Last value of the solution:
    pla.pumChiWatPri.valChe[2].dp = -57435.3
    pla.port_a.m_flow = 7.96592
    pla.intChi.valChiWatChiBypPar.port_a.m_flow = 0.000552757
  Last value of the residual:
    { 208.826, -14.7577, -3.75946 }
 
Previous problem occured when evaluating crossing function, reducing step-size
SUNDIALS: CVODE cvRcheck3 At t = 30820.7, the rootfinding routine failed in an unrecoverable manner.
Cannot recover from failed crossing function evaluation at time 30819
CVode simulation failed

Integration terminated unsuccesfully at T = 30819
   CPU-time for integration                  : 0.57841 seconds
   CPU-time for initialization               : 0.346145 seconds
   Number of result points                   : 464
   Number of grid points                     : 179
   Number of accepted steps                  : 1343
   Number of rejected steps                  : 107
   Number of f-evaluations (dynamics)        : 2246
   Number of non-linear iteration            : 2009
   Number of non-linear convergence failures : 38
   Number of Jacobian-evaluations            : 119
   Number of crossing function evaluations   : 1870
   Number of model time events               : 114
   Number of state events                    : 29
   Number of step events                     : 0
   Maximum integration order                 : 5

ERROR: The simulation of Buildings.Templates.Plants.Chillers.Validation.HardCase1 FAILED"));
end HardCase1;
