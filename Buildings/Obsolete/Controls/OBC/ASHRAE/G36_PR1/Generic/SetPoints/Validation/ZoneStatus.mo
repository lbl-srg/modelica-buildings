within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model ZoneStatus
  "Validate block for checking temperatures in the zone"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus noWinZonSta(final
      have_winSen=false)
    "Status of zone when there is no window operation sensor"
    annotation (Placement(transformation(extent={{60,60},{80,88}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus witWinZonSta(final
      have_winSen=true) "Status of zone when there is window operation sensor"
    annotation (Placement(transformation(extent={{60,-20},{80,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uWinSta(
    final width=0.3,
    final period=43200,
    final shift=1800)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={-10,-80})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=12.5)
    "Gain factor"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter zonTem(
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation
  connect(cooDowTim.y, noWinZonSta.cooDowTim) annotation (Line(points={{-58,60},
          {-20,60},{-20,82},{58,82}}, color={0,0,127}));
  connect(warUpTim.y, noWinZonSta.warUpTim) annotation (Line(points={{-58,20},{-14,
          20},{-14,78},{58,78}}, color={0,0,127}));
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-78,-40},{-72,-40}}, color={0,0,127}));
  connect(zonTem.y, noWinZonSta.TZon) annotation (Line(points={{12,-40},{20,-40},
          {20,66},{58,66}},    color={0,0,127}));
  connect(cooDowTim.y, witWinZonSta.cooDowTim) annotation (Line(points={{-58,60},
          {-20,60},{-20,2},{58,2}},    color={0,0,127}));
  connect(warUpTim.y, witWinZonSta.warUpTim) annotation (Line(points={{-58,20},{
          -14,20},{-14,-2},{58,-2}},    color={0,0,127}));
  connect(zonTem.y, witWinZonSta.TZon) annotation (Line(points={{12,-40},{20,-40},
          {20,-14},{58,-14}},color={0,0,127}));
  connect(uWinSta.y, witWinZonSta.uWin) annotation (Line(points={{2,-80},{40,-80},
          {40,-10},{58,-10}}, color={255,0,255}));
  connect(sin2.y, gai.u)
    annotation (Line(points={{-48,-40},{-42,-40}}, color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-18,-40},{-12,-40}}, color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/ZoneStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus</a>
for checking zone temperature status.
</p>
</html>", revisions="<html>
<ul>
<li>
March 10, 2020, by Jianjun Hu:<br/>
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
end ZoneStatus;
