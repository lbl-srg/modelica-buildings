within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model ZoneStatus
  "Validate block for checking temperatures in the zone"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus noWinZonSta
    "Status of zone when there is no window operation sensor"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus
    witWinZonSta(final have_winSen=true)
    "Status of zone when there is window operation sensor"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter maxZonTem(final k=13.5,
      final p=273.15 + 22.5) "Maximum zone temperature in the group"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=273.15 + 12)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=273.15 + 30)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-160},{20,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=273.15 + 20)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=273.15 + 24)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-80,120},{-60,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uWinSta(
    width=0.3,
    period=43200,
    startTime=1800)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={-110,20})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final k=12.5,
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp3(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin3
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter minZonTem(
    final k=12,
    final p=273.15 + 22.5)
    "Minimum zone temperature in the group"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-58,0},{-42,0}},     color={0,0,127}));
  connect(sin1.y, maxZonTem.u)
    annotation (Line(points={{-18,0},{-2,0}},     color={0,0,127}));
  connect(cooDowTim.y, noWinZonSta.cooDowTim) annotation (Line(points={{-58,130},
          {-20,130},{-20,139},{118,139}}, color={0,0,127}));
  connect(warUpTim.y, noWinZonSta.warUpTim) annotation (Line(points={{-58,100},{
          -14,100},{-14,137},{118,137}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, noWinZonSta.TZonHeaSetOcc) annotation (Line(points={{-58,70},
          {-8,70},{-8,133},{118,133}},       color={0,0,127}));
  connect(TZonCooSetOcc.y, noWinZonSta.TZonCooSetOcc) annotation (Line(points={{-58,40},
          {-2,40},{-2,131},{118,131}},     color={0,0,127}));
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={0,0,127}));
  connect(sin2.y, zonTem.u)
    annotation (Line(points={{-18,-40},{-2,-40}}, color={0,0,127}));
  connect(maxZonTem.y, noWinZonSta.TZonMax) annotation (Line(points={{22,0},{40,
          0},{40,129},{118,129}}, color={0,0,127}));
  connect(zonTem.y, noWinZonSta.TZon) annotation (Line(points={{22,-40},{46,-40},
          {46,127},{118,127}}, color={0,0,127}));
  connect(ramp3.y,sin3. u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(sin3.y, minZonTem.u)
    annotation (Line(points={{-18,-80},{-2,-80}},   color={0,0,127}));
  connect(minZonTem.y, noWinZonSta.TZonMin) annotation (Line(points={{22,-80},{52,
          -80},{52,125},{118,125}},   color={0,0,127}));
  connect(TZonHeaSetUno.y, noWinZonSta.TZonHeaSetUno) annotation (Line(points={{22,-110},
          {58,-110},{58,123},{118,123}},        color={0,0,127}));
  connect(TZonCooSetUno.y, noWinZonSta.TZonCooSetUno) annotation (Line(points={{22,-150},
          {64,-150},{64,121},{118,121}},        color={0,0,127}));
  connect(cooDowTim.y, witWinZonSta.cooDowTim) annotation (Line(points={{-58,130},
          {-20,130},{-20,59},{118,59}},color={0,0,127}));
  connect(warUpTim.y, witWinZonSta.warUpTim) annotation (Line(points={{-58,100},
          {-14,100},{-14,57},{118,57}}, color={0,0,127}));
  connect(uWinSta.y, witWinZonSta.uWinSta) annotation (Line(points={{-98,20},{-20,
          20},{-20,55},{118,55}},  color={255,0,255}));
  connect(TZonHeaSetOcc.y, witWinZonSta.TZonHeaSetOcc) annotation (Line(points={{-58,70},
          {-8,70},{-8,53},{118,53}},          color={0,0,127}));
  connect(TZonCooSetOcc.y, witWinZonSta.TZonCooSetOcc) annotation (Line(points={{-58,40},
          {-2,40},{-2,51},{118,51}},        color={0,0,127}));
  connect(maxZonTem.y, witWinZonSta.TZonMax) annotation (Line(points={{22,0},{40,
          0},{40,49},{118,49}},    color={0,0,127}));
  connect(zonTem.y, witWinZonSta.TZon) annotation (Line(points={{22,-40},{46,-40},
          {46,47},{118,47}}, color={0,0,127}));
  connect(minZonTem.y, witWinZonSta.TZonMin) annotation (Line(points={{22,-80},{
          52,-80},{52,45},{118,45}}, color={0,0,127}));
  connect(TZonHeaSetUno.y, witWinZonSta.TZonHeaSetUno) annotation (Line(points={{22,-110},
          {58,-110},{58,43},{118,43}},         color={0,0,127}));
  connect(TZonCooSetUno.y, witWinZonSta.TZonCooSetUno) annotation (Line(points={{22,-150},
          {64,-150},{64,41},{118,41}},         color={0,0,127}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/ZoneStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatus</a>
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
    Diagram(coordinateSystem(extent={{-160,-180},{160,160}})));
end ZoneStatus;
