within Buildings.Fluid.DXSystems.BaseClasses.Examples;
model Condensation "Test model for Condensation block"
 package Medium =
      Buildings.Media.Air;
 extends Modelica.Icons.Example;
  Buildings.Fluid.DXSystems.BaseClasses.Condensation mWat
   "Calculates rate of condensation"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Ramp Q_flow(
    height=-20000,
    startTime=600,
    offset=0,
    duration=2400) "Heat flow"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Sources.Ramp shr(
    startTime=1800,
    height=1,
    offset=0,
    duration=1200) "Sensible heat ratio"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation

  connect(Q_flow.y, mWat.Q_flow) annotation (Line(
      points={{-39,20},{-20,20},{-20,4},{-1,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.y, mWat.SHR) annotation (Line(
      points={{-39,-30},{-20,-30},{-20,-4},{-1,-4}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of Condensation block
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.Condensation\">
Buildings.Fluid.DXSystems.BaseClasses.Condensation</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 13, 2017, by Michael Wetter:<br/>
Removed connectors that are no longer needed.
</li>
<li>
Aug 8, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Condensation;
