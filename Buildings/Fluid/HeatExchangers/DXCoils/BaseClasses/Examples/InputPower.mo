within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model InputPower "Test model for InputPower"
extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp SHR(
    height=0.5,
    duration=60,
    offset=0.5,
    startTime=0) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Sources.Ramp EIR(
    height=-0.083,
    duration=60,
    offset=0.333,
    startTime=0) "Energy input ratio"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.InputPower pwr(
      is_CooCoi=true)
    "Calculates electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    height=-20000,
    duration=60,
    startTime=0) "Cooling rate"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(EIR.y, pwr.EIR) annotation (Line(
      points={{-19,50},{-12,50},{-12,16.6},{-2,16.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, pwr.Q_flow) annotation (Line(
      points={{-19,10},{-2,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SHR.y, pwr.SHR) annotation (Line(
      points={{-19,-30},{-12,-30},{-12,4},{-2,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/InputPower.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of InputPower block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.InputPower\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.InputPower</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu:<br/>
Added parameter value for <code>is_CooCoi</code> to instance <code>pwr</code>.
</li>
<li>
August 29, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end InputPower;
