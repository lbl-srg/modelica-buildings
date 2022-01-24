within Buildings.Fluid.Movers.BaseClasses.Validation;
model EulerComparison
  "Simple model to validate the power computation method using the Euler number"
  extends Modelica.Icons.Example;

  parameter Integer nOri(min=1)=size(per1.power.V_flow,1)
    "Number of data points for pressure curve"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Density rhoCon=1.2
    "Constant density";

  Buildings.Fluid.Movers.Data.Fans.Greenheck.BIDW13 per1
    "Mover curves with flow rate, pressure rise, and power";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff1(
    per=per1,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power characteristic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Movers.Data.Generic per2(
    final powMet=Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.EulerNumber,
    pressure=per1.pressure,
    power=per1.power,
    peak=Buildings.Fluid.Movers.BaseClasses.Euler.getPeak(
      pressure=per2.pressure,
      power=per2.power))
    "Peak condition";
  Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface eff2(
    per=per2,
    rho_default=rhoCon,
    nOri=nOri,
    computePowerUsingSimilarityLaws=false)
    "Flow machine interface using power Euler correlation"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));

  Modelica.Blocks.Sources.Constant y(k=1) "Control signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant rho(k=rhoCon) "Density"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Units.SI.VolumeFlowRate V_flow = m_flow.y/rhoCon "Volumetric flow rate";

  Modelica.Blocks.Sources.Ramp m_flow(
    height=eff1.V_flow_max*rhoCon,
    duration=1)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(eff1.rho, rho.y)
    annotation (Line(points={{-12,-6},{-26,-6},{-26,10},{-39,10}},
                                               color={0,0,127}));
  connect(y.y, eff1.y_in)
    annotation (Line(points={{-39,50},{-4,50},{-4,12}},   color={0,0,127}));
  connect(m_flow.y, eff1.m_flow) annotation (Line(points={{-39,-30},{-18,-30},{-18,
          4},{-12,4}}, color={0,0,127}));
  connect(y.y, eff2.y_in) annotation (Line(points={{-39,50},{-4,50},{-4,18},{18,
          18},{18,-14},{-4,-14},{-4,-22}}, color={0,0,127}));
  connect(rho.y, eff2.rho) annotation (Line(points={{-39,10},{-26,10},{-26,-40},
          {-12,-40}},               color={0,0,127}));
  connect(m_flow.y, eff2.m_flow) annotation (Line(points={{-39,-30},{-12,-30}},
                           color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/Validation/EulerComparison.mos"
 "Simulate and plot"),
Documentation(
info="<html>
<p>
This simple model validates the power computation path
using the Euler number and its correlation as implemented in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler\">
Buildings.Fluid.Movers.BaseClasses.Euler</a>.
Its results of calculated efficiency and power are compared
with those obtained by using the power characteristic path.
Note that full performance curves are needed in this validation model
because otherwise
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>
would not know the pressure of the mover.
See <a href=\"modelica://Buildings.Fluid.Movers.Validation.PowerEuler\">
Buildings.Fluid.Movers.Validation.PowerEuler</a>
for a more typical use case where only the peak point itself is supplied.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end EulerComparison;
