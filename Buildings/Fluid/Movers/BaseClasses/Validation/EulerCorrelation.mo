within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerCorrelation "Simple model to validate the Euler correlation"
  extends Modelica.Icons.Example;
  import MoverRecord = Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8;

  parameter Integer nOri(min=1)=size(per1.power.V_flow,1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Density rhoCon=1.2
    "Constant density";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    efficiency(
    V_flow=per1.pressure.V_flow,
    eta=per1.pressure.V_flow.*per1.pressure.dp./per1.power.P)
    "Efficiency vs. flow rate";

  MoverRecord per1 "Mover curves with flow rate, pressure rise, and power";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per=per1,
    rho_default=rhoCon,
    haveVMax=false,
    V_flow_max=1,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power characteristic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  MoverRecord per2(
    powMet=Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.EulerCorrelation,
    peak=Buildings.Fluid.Movers.BaseClasses.Euler.findPeakCondition(
      pressure=per2.pressure,
      power=per2.power))
    "Peak condition";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per=per2,
    rho_default=rhoCon,
    haveVMax=false,
    V_flow_max=1,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power Euler correlation"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));

  Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Sources.Constant rho(k=rhoCon) "Density"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.TimeTable m_flow(
    table=[{0,1},{per1.power.V_flow[1]*rhoCon,per1.power.V_flow[end]*rhoCon}])
    "mass flow rate"
    annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));

  Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
  Modelica.SIunits.Efficiency etaIpo "Efficiency values directly interpolated";

equation
  V_flow = m_flow.y/rhoCon;
  etaIpo=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=V_flow,
    xSup=efficiency.V_flow,
    ySup=efficiency.eta,
    ensureMonotonicity=false);
  connect(eff1.rho, rho.y)
    annotation (Line(points={{-12,-6},{-26,-6},{-26,0},{-39,0}},
                                               color={0,0,127}));
  connect(y.y, eff1.y_in)
    annotation (Line(points={{-39,30},{-4,30},{-4,12}},   color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,-36},{-22,-36},{-22,
          4},{-12,4}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,30},{-4,30},{-4,18},{18,
          18},{18,-14},{-4,-14},{-4,-22}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,0},{-26,0},{-26,-6},{-18,
          -6},{-18,-40},{-12,-40}}, color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,-36},{-22,-36},{-22,
          -30},{-12,-30}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EulerCorrelation.mos"
 "Simulate and plot"),
Documentation(
info="<html>
<p>
Document pending.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0));
end EulerCorrelation;
