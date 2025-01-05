within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Validation;
model Effectiveness
  "Test model for calculating the input effectiveness of a sensible heat exchanger"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness
    epsCal(
    eps_nominal=0.8,
    epsPL=0.75,
    mSup_flow_nominal=1)
    "Effectiveness calculator"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Sources.Ramp VSup(
    height=0.4,
    duration=120,
    offset=0.6,
    startTime=0)
    "Supply air flow rate"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Ramp VExh(
    height=0.2,
    duration=120,
    offset=0.8,
    startTime=0)
    "Exhaust air flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
equation
  connect(VSup.y,epsCal.mSup_flow)
    annotation (Line(points={{-59,70},{-28,70},{-28,8},{-14,8}}, color={0,0,127}));
  connect(VExh.y,epsCal.mExh_flow)
    annotation (Line(points={{-59,-40},{-28,-40},{-28,-6},{-14,-6}},
                                                                 color={0,0,127}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6, StopTime=120),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/ThermalWheels/Sensible/BaseClasses/Validation/Effectiveness.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.Effectiveness</a>.
</p>
<p>
The input signals are configured as follows:
</p>
<ul>
<li>
The supply air flow rate, <i>VSup</i>, and the
exhaust air flow rate, <i>VExh</i>, change from
0.6 to 1 and 0.8 to 1 respectively.
</li>
</ul>
<p>
The expected outputs are:
</p>
<ul>
<li>
The sensible effectiveness <code>eps</code> increases from 0.75 to 0.8.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Effectiveness;
