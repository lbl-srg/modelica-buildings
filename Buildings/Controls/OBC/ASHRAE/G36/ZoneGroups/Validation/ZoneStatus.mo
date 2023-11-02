within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.Validation;
model ZoneStatus
  "Validate block for checking temperatures in the zone"

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus noWinZonSta(
    final have_winSen=false)
    "Status of zone when there is no window operation sensor"
    annotation (Placement(transformation(extent={{80,60},{100,88}})));
  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus witWinZonSta(
    final have_winSen=true)
    "Status of zone when there is window operation sensor"
    annotation (Placement(transformation(extent={{80,-20},{100,8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uWinSta(
    final width=0.3,
    final period=43200,
    final shift=1800)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={-70,-10})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=12.5) "Gain factor"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetOcc(
    final k=293.15)
    "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetOcc(
    final k=297.15)
    "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaSetUno(
    final k=285.15)
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCooSetUno(
    final k=303.15)
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
equation
  connect(cooDowTim.y, noWinZonSta.cooDowTim) annotation (Line(points={{-58,100},
          {28,100},{28,85},{78,85}},  color={0,0,127}));
  connect(warUpTim.y, noWinZonSta.warUpTim) annotation (Line(points={{-58,60},{32,
          60},{32,82},{78,82}},  color={0,0,127}));
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-88,20},{-72,20}},   color={0,0,127}));
  connect(zonTem.y, noWinZonSta.TZon) annotation (Line(points={{12,20},{36,20},{
          36,76.2},{78,76.2}}, color={0,0,127}));
  connect(cooDowTim.y, witWinZonSta.cooDowTim) annotation (Line(points={{-58,100},
          {28,100},{28,5},{78,5}},     color={0,0,127}));
  connect(warUpTim.y, witWinZonSta.warUpTim) annotation (Line(points={{-58,60},{
          32,60},{32,2},{78,2}},        color={0,0,127}));
  connect(zonTem.y, witWinZonSta.TZon) annotation (Line(points={{12,20},{36,20},
          {36,-3.8},{78,-3.8}},  color={0,0,127}));
  connect(sin2.y, gai.u)
    annotation (Line(points={{-48,20},{-42,20}},   color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-18,20},{-12,20}},   color={0,0,127}));
  connect(THeaSetOcc.y,noWinZonSta.TOccHeaSet)  annotation (Line(points={{-78,-40},
          {44,-40},{44,72},{78,72}}, color={0,0,127}));
  connect(TCooSetOcc.y,noWinZonSta.TOccCooSet)  annotation (Line(points={{-38,-60},
          {48,-60},{48,69},{78,69}}, color={0,0,127}));
  connect(THeaSetUno.y,noWinZonSta.TUnoHeaSet)  annotation (Line(points={{-78,-80},
          {52,-80},{52,66},{78,66}}, color={0,0,127}));
  connect(TCooSetUno.y,noWinZonSta.TUnoCooSet)  annotation (Line(points={{-38,-100},
          {56,-100},{56,63},{78,63}}, color={0,0,127}));
  connect(THeaSetOcc.y,witWinZonSta.TOccHeaSet)  annotation (Line(points={{-78,-40},
          {44,-40},{44,-8},{78,-8}}, color={0,0,127}));
  connect(TCooSetOcc.y,witWinZonSta.TOccCooSet)  annotation (Line(points={{-38,-60},
          {48,-60},{48,-11},{78,-11}}, color={0,0,127}));
  connect(THeaSetUno.y,witWinZonSta.TUnoHeaSet)  annotation (Line(points={{-78,-80},
          {52,-80},{52,-14},{78,-14}}, color={0,0,127}));
  connect(TCooSetUno.y,witWinZonSta.TUnoCooSet)  annotation (Line(points={{-38,-100},
          {56,-100},{56,-17},{78,-17}}, color={0,0,127}));
  connect(uWinSta.y, not2.u)
    annotation (Line(points={{-58,-10},{-22,-10}}, color={255,0,255}));
  connect(not2.y, witWinZonSta.u1Win) annotation (Line(points={{2,-10},{40,-10},
          {40,-1},{78,-1}}, color={255,0,255}));
annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ZoneGroups/Validation/ZoneStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatus</a>
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
