within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerCorrelation "Simple model to validate the Euler correlation"
  extends Modelica.Icons.Example;

  parameter Integer nOri(min=1)=size(per1.power.V_flow,1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Density rhoCon=1.2
    "Constant density";

  Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per1
    "Power characteristic";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per=per1,
    rho_default=rhoCon,
    haveVMax=false,
    V_flow_max=1,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power characteristic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per2(
    powMet=Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.EulerCorrelation)
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
    table=[linspace(0,1,nOri),per1.power.V_flow*rhoCon])
    "mass flow rate"
    annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));

equation
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
  annotation (
    Documentation(info="<html>
<p>
Simple validation model for the flow machine interface model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 19, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0));
end EulerCorrelation;
