within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model FreezeProtection_Disable
  "Validate model for disabling freeze protection"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection
    frePro(
    final have_frePro=false)
    "Freeze protection control"
    annotation (Placement(transformation(extent={{80,0},{100,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp outDamPos(
    final height=0.5,
    final offset=0.1,
    final duration=3600) "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp heaCoiPos(
    final height=0.46,
    final offset=0.5,
    final duration=3600) "Heating coil position"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp retDamPos(
    final height=0.2,
    final offset=0.7,
    final duration=3600) "Return air damper position"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp supFanSpe(
    final height=0.2,
    final offset=0.5,
    final duration=3600) "Supply fan speed"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp cooCoiPos(
    final height=0.2,
    final offset=0.5,
    final duration=3600) "Cooling coil position"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final h=0.01)
    "Check if the supply fan is proven on"
    annotation (Placement(transformation(extent={{0,-56},{20,-36}})));
equation
  connect(outDamPos.y, frePro.uOutDam) annotation (Line(points={{-18,80},{60,80},
          {60,37},{78,37}}, color={0,0,127}));
  connect(heaCoiPos.y,frePro. uHeaCoi) annotation (Line(points={{-58,60},{56,60},
          {56,34},{78,34}},    color={0,0,127}));
  connect(retDamPos.y, frePro.uRetDam) annotation (Line(points={{-58,20},{40,20},
          {40,31},{78,31}}, color={0,0,127}));
  connect(supFanSpe.y, frePro.uSupFan) annotation (Line(points={{-18,-60},{56,-60},
          {56,17},{78,17}}, color={0,0,127}));
  connect(cooCoiPos.y,frePro. uCooCoi) annotation (Line(points={{-58,-80},{60,-80},
          {60,4},{78,4}},      color={0,0,127}));
  connect(supFanSpe.y, greThr.u) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -46},{-2,-46}}, color={0,0,127}));
  connect(greThr.y, frePro.u1SupFan) annotation (Line(points={{22,-46},{52,-46},
          {52,19},{78,19}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/FreezeProtection_Disable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.FreezeProtection</a>
for air handling unit serving single zones, when disabling the freeze protection.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end FreezeProtection_Disable;
