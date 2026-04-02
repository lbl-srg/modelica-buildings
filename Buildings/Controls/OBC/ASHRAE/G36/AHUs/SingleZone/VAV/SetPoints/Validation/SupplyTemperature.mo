within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.Validation;
model SupplyTemperature "Validation model for supply temperature"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature temSet(
    final TSup_max=303.15,
    final TSup_min=289.15)
    "Block that computes the setpoints for temperature"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonCooSet(
    final k=273.15 + 24)
    "Zone cooling set point"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZonHeaSet(
    final k=273.15 + 20)
    "Zone heating set point"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final duration=900,
    final height=-1,
    final offset=1) "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final duration=900,
    final startTime=2700)
    "Cooling control signal"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation
  connect(TZonCooSet.y, temSet.TCooSet) annotation (Line(points={{-38,60},{20,60},
          {20,-2},{38,-2}},color={0,0,127}));
  connect(TZonHeaSet.y, temSet.THeaSet) annotation (Line(points={{-58,20},{10,20},
          {10,-7},{38,-7}}, color={0,0,127}));
  connect(uHea.y, temSet.uHea) annotation (Line(points={{-38,-30},{10,-30},{10,-13},
          {38,-13}}, color={0,0,127}));
  connect(uCoo.y, temSet.uCoo) annotation (Line(points={{-58,-80},{20,-80},{20,-18},
          {38,-18}}, color={0,0,127}));
  annotation (
  experiment(StopTime=3600.0, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/Validation/SupplyTemperature.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints.SupplyTemperature</a>
for a change in the loop inputs and the effects on the supply temperature setpoints.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2025, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}}),
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
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})));
end SupplyTemperature;
