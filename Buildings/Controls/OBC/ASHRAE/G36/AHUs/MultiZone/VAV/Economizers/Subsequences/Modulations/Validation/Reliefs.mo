within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Validation;
model Reliefs
  "Validation model for modulating dampers of units with relief damper control"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs mod1
    "Multi zone VAV AHU minimum outdoor air control - damper modulation"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxRetDam(
    final k=0.9)
    "Return damper maximum position"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp temLoo(
    final duration=1800,
    final offset=-1,
    final height=2) "Temperature control loop output"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxOutDam(
    final k=1)
    "Outdoor air damper maximum position"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minRetDam(
    final k=0.1)
    "Return damper minimum position"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minOutDam(
    final k=0)
    "Outdoor air damper minimum position"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

equation
  connect(temLoo.y, mod1.uTSup)
    annotation (Line(points={{-38,0},{58,0}}, color={0,0,127}));
  connect(maxRetDam.y, mod1.uRetDam_max) annotation (Line(points={{-18,80},{40,
          80},{40,9},{58,9}}, color={0,0,127}));
  connect(minRetDam.y, mod1.uRetDam_min) annotation (Line(points={{-18,40},{20,
          40},{20,5},{58,5}}, color={0,0,127}));
  connect(maxOutDam.y, mod1.uOutDam_max) annotation (Line(points={{-18,-40},{20,
          -40},{20,-5},{58,-5}}, color={0,0,127}));
  connect(minOutDam.y, mod1.uOutDam_min) annotation (Line(points={{-18,-80},{40,
          -80},{40,-9},{58,-9}}, color={0,0,127}));

annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Modulations/Validation/Reliefs.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
            120}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Reliefs</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Reliefs;
