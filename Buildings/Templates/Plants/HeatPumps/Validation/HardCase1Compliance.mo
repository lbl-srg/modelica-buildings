within Buildings.Templates.Plants.HeatPumps.Validation;
model HardCase1Compliance "Validation of AWHP plant template"
  extends Buildings.Templates.Plants.HeatPumps.Validation.HardCase1(
    pla(use_cpl=true))
  annotation(IconMap(primitivesVisible = false));
annotation(experiment(StopTime=86400,
  Tolerance=1e-06,
  __Dymola_Algorithm="Cvode"), Documentation(info="Model: Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Compliance
Integration started at 0 using integration method:
cvode from sundials

Warning: The following was detected at time: 27247.35556836889
  *** Warning in HardCase1Compliance.loaHea.loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-71.086746265623
and    m_flow=147.78325123153
  Failed condition: noEvent(loaHea.port_a.m_flow > -4.481357552581262) and noEvent(loaHea.loa.coi.port_a2.m_flow > -14.77832512315271)

Warning: The following was detected at time: 27258.64247126772
  *** Warning in HardCase1Compliance.loaHea.loa.coi: The flow direction reversed.
      However, because the constant use_dynamicFlowRegime is set to false,
      the model does not change equations based on the actual flow regime.
      To switch equations based on the actual flow regime during the simulation,
      set the constant use_dynamicFlowRegime=true.
      Note that this can lead to slow simulation because of events.
With: m_flow=-45.909218488635
and    m_flow=147.78325123153
  Failed condition: noEvent(loaHea.port_a.m_flow > -4.481357552581262) and noEvent(loaHea.loa.coi.port_a2.m_flow > -14.77832512315271)

SUNDIALS: CVODE CVode At t = 36166.2, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 49503.2, mxstep steps taken before reaching tout.
SUNDIALS: CVODE CVode At t = 49803.1, mxstep steps taken before reaching tout.

Integration terminated successfully at T = 86400
   CPU-time for integration                  : 4.54734 seconds
   CPU-time for initialization               : 0.314748 seconds
   Number of result points                   : 1637
   Number of grid points                     : 501
   Number of accepted steps                  : 20709
   Number of rejected steps                  : 797
   Number of f-evaluations (dynamics)        : 30657
   Number of non-linear iteration            : 29436
   Number of non-linear convergence failures : 896
   Number of Jacobian-evaluations            : 1415
   Number of crossing function evaluations   : 23423
   Number of model time events               : 420
   Number of state events                    : 150
   Number of step events                     : 0
   Maximum integration order                 : 5

SUCCESSFUL simulation of Buildings.Templates.Plants.HeatPumps.Validation.HardCase1Compliance


------------------ OCT 368 NonlinearBlockConvergenceError

Final Run Statistics: ---

 Number of steps                                 : 21600
 Number of function evaluations                  : 32709
 Number of Jacobian evaluations                  : 1523
 Number of function eval. due to Jacobian eval.  : 0
 Number of error test failures                   : 795
 Number of nonlinear iterations                  : 30270
 Number of nonlinear convergence failures        : 336
 Number of state function evaluations            : 25393
 Number of state events                          : 192
 Number of time events                           : 417

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
Elapsed simulation time: 26.218182697000884 seconds."),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
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
end HardCase1Compliance;
