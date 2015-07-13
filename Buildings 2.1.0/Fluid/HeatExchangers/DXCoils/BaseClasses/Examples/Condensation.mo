within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model Condensation "Test model for Condensation block"
 package Medium =
      Buildings.Media.Air;
 extends Modelica.Icons.Example;
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation mWat(
      redeclare package Medium = Medium) "Calculates rate of condensation"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    height=-20000,
    startTime=600,
    offset=0,
    duration=2400) "Heat flow"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Ramp TDewPoi(
    each startTime=600,
    height=20,
    offset=5.4,
    each duration=1200) "Apparatus dew point temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Modelica.Blocks.Sources.Ramp shr(
    startTime=1800,
    height=1,
    offset=0,
    duration=1200) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation

  connect(TDewPoi.y, mWat.TDewPoi) annotation (Line(
      points={{-39,-50},{-20,-50},{-20,-6},{-1,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Q_flow.y, mWat.Q_flow) annotation (Line(
      points={{-39,50},{-20,50},{-20,6},{-1,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.y, mWat.SHR) annotation (Line(
      points={{-39,6.10623e-16},{-29.5,6.10623e-16},{-29.5,6.10623e-16},{-20,
          6.10623e-16},{-20,6.10623e-16},{-1,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of Condensation block
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
Aug 8, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Condensation;
