within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.Validation;
model ReturnFan
  "Validation model for modulating dampers of units with return fan"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan ecoMod
    "Multi zone VAV AHU minimum outdoor air control - damper modulation"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan ecoMod1(
    final have_dirCon=false)
    "Multi zone VAV AHU minimum outdoor air control - damper modulation, the unit does not have direct pressure control"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxRetDam(
    final k=0.9)
    "Return damper maximum position"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp temLoo(
    final duration=1800,
    final offset=-1,
    final height=2) "Temperature control loop output"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minRetDam(
    final k=0.1)
    "Return damper minimum position"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(temLoo.y, ecoMod.uTSup)
    annotation (Line(points={{-38,0},{10,0},{10,6},{58,6}}, color={0,0,127}));
  connect(maxRetDam.y, ecoMod.uRetDam_max) annotation (Line(points={{-18,80},{
          40,80},{40,0},{58,0}}, color={0,0,127}));
  connect(minRetDam.y, ecoMod.uRetDam_min) annotation (Line(points={{-18,40},{
          20,40},{20,-6},{58,-6}}, color={0,0,127}));
  connect(temLoo.y, ecoMod1.uTSup) annotation (Line(points={{-38,0},{10,0},{10,-84},
          {58,-84}}, color={0,0,127}));
  connect(maxRetDam.y, ecoMod1.uRetDam_max) annotation (Line(points={{-18,80},
          {40,80},{40,-90},{58,-90}}, color={0,0,127}));
  connect(minRetDam.y, ecoMod1.uRetDam_min) annotation (Line(points={{-18,40},
          {20,40},{20,-96},{58,-96}}, color={0,0,127}));

annotation (
  experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/Economizers/Subsequences/Modulations/Validation/ReturnFan.mos"
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
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers.Subsequences.Modulations.ReturnFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 5, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFan;
