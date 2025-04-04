within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Examples;
model DryWetSelector "Test model for DryWetSelector"

extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Ramp XADP(
    duration=20,
    startTime=20,
    height=-0.002,
    offset=0.006) "Mass fraction at ADP"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Sources.Ramp XEvaIn(
    startTime=20,
    height=0.002,
    offset=0.004,
    duration=20) "Inlet mass-fraction"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector dryWet
    "Averages dry and wet coil conditions"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant mWetWat_flow(k=0.01)
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  Modelica.Blocks.Sources.Constant SHRWet(k=0.5)
    annotation (Placement(transformation(extent={{-34,62},{-14,82}})));
  Modelica.Blocks.Sources.Constant QWet_flow(k=-3000)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Modelica.Blocks.Sources.Constant EIRWet(k=0.3)
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Modelica.Blocks.Sources.Constant QDry_flow(k=-2000)
    annotation (Placement(transformation(extent={{-48,-70},{-28,-50}})));
  Modelica.Blocks.Sources.Constant EIRDry(k=0.2)
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
equation
  connect(XEvaIn.y, dryWet.XEvaIn)    annotation (Line(
      points={{-39,-10},{-28,-10},{-28,-4},{-1,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XADP.y, dryWet.XADP)    annotation (Line(
      points={{-69,10},{-10,10},{-10,4},{-1,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWetWat_flow.y, dryWet.mWetWat_flow) annotation (Line(
      points={{-67,40},{2,40},{2,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(SHRWet.y, dryWet.SHRWet) annotation (Line(
      points={{-13,72},{10,72},{10,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QWet_flow.y, dryWet.QWet_flow) annotation (Line(
      points={{11,90},{14,90},{14,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EIRWet.y, dryWet.EIRWet) annotation (Line(
      points={{41,90},{52,90},{52,40},{18,40},{18,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(QDry_flow.y, dryWet.QDry_flow) annotation (Line(
      points={{-27,-60},{14,-60},{14,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(EIRDry.y, dryWet.EIRDry) annotation (Line(
      points={{1,-80},{18,-80},{18,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/DXSystems/Cooling/BaseClasses/Examples/DryWetSelector.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates working of DryWetSelector block
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector\">
Buildings.Fluid.DXSystems.Cooling.BaseClasses.DryWetSelector</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 13, 2017, by Michael Wetter:<br/>
Removed connectors that are no longer needed.
</li>
<li>
August 29, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end DryWetSelector;
