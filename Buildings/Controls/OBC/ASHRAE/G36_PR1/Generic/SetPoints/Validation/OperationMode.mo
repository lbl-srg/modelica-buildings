within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model OperationMode "Validate block for selecting operation mode"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=1)
    "Operation mode selection"
    annotation (Placement(transformation(extent={{120,84},{140,116}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final height=6.2831852,
    final duration=172800)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final k=14.5,
    final p=295.65) "Zone temperarure"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=285.15)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=303.15)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=293.15)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=297.15)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cloWin(
    final k=0) "No window is open"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,0})));
  Buildings.Controls.OBC.CDL.Continuous.Greater lowThaHeaSet
    "True when the zone temperature is lower than the occupied heating setpoint"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater higThaCooSet
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu2
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater greEqu3
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1 "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3(
    final k2=-1)
    "Calculate zone temperature difference to unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis that outputs if the zone temperature is higher than its unoccupied heating setpoint by a given limit"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(
    final k1=-1)
    "Calculate zone temperature difference to unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis that outputs if the zone temperature is lower than its unoccupied cooling setpoint by a given limit"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-118,50},{-102,50}}, color={0,0,127}));
  connect(sin1.y,zonTem. u)
    annotation (Line(points={{-78,50},{-62,50}},  color={0,0,127}));
  connect(cooDowTim.y, opeModSel.maxCooDowTim) annotation (Line(points={{-118,130},
          {30,130},{30,110},{118,110}}, color={0,0,127}));
  connect(warUpTim.y, opeModSel.maxWarUpTim) annotation (Line(points={{-78,110},
          {-60,110},{-60,106},{118,106}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, lowThaHeaSet.u1)
    annotation (Line(points={{-118,80},{-2,80}}, color={0,0,127}));
  connect(zonTem.y, lowThaHeaSet.u2) annotation (Line(points={{-38,50},{-20,50},
          {-20,72},{-2,72}}, color={0,0,127}));
  connect(zonTem.y, higThaCooSet.u1) annotation (Line(points={{-38,50},{-20,50},
          {-20,30},{-2,30}}, color={0,0,127}));
  connect(TZonCooSetOcc.y, higThaCooSet.u2) annotation (Line(points={{-78,20},{-40,
          20},{-40,22},{-2,22}}, color={0,0,127}));
  connect(TZonHeaSetUno.y, greEqu2.u1)
    annotation (Line(points={{-78,-30},{-2,-30}},   color={0,0,127}));
  connect(zonTem.y, greEqu2.u2) annotation (Line(points={{-38,50},{-20,50},{-20,
          -38},{-2,-38}}, color={0,0,127}));
  connect(greEqu2.y, booToInt.u)
    annotation (Line(points={{22,-30},{38,-30}},   color={255,0,255}));
  connect(booToInt.y, opeModSel.totColZon) annotation (Line(points={{62,-30},{76,
          -30},{76,100},{118,100}}, color={255,127,0}));
  connect(zonTem.y, opeModSel.TZonMax) annotation (Line(points={{-38,50},{58,50},
          {58,94},{118,94}}, color={0,0,127}));
  connect(zonTem.y, opeModSel.TZonMin) annotation (Line(points={{-38,50},{64,50},
          {64,92},{118,92}}, color={0,0,127}));
  connect(zonTem.y, greEqu3.u1) annotation (Line(points={{-38,50},{-20,50},{-20,
          -100},{-2,-100}}, color={0,0,127}));
  connect(TZonCooSetUno.y, greEqu3.u2) annotation (Line(points={{-78,-100},{-40,
          -100},{-40,-108},{-2,-108}}, color={0,0,127}));
  connect(greEqu3.y, booToInt1.u)
    annotation (Line(points={{22,-100},{38,-100}}, color={255,0,255}));
  connect(booToInt1.y, opeModSel.totHotZon) annotation (Line(points={{62,-100},{
          88,-100},{88,90},{118,90}},  color={255,127,0}));
  connect(occSch.occupied, opeModSel.uOcc) annotation (Line(points={{-79,144},{100,
          144},{100,114},{118,114}}, color={255,0,255}));
  connect(occSch.tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-79,156},
          {96,156},{96,112},{118,112}}, color={0,0,127}));
  connect(higThaCooSet.y, opeModSel.uHigOccCoo) annotation (Line(points={{22,30},
          {50,30},{50,108},{118,108}}, color={255,0,255}));
  connect(lowThaHeaSet.y, opeModSel.uOccHeaHig) annotation (Line(points={{22,80},
          {46,80},{46,104},{118,104}}, color={255,0,255}));
  connect(cloWin.y, opeModSel.uOpeWin) annotation (Line(points={{-118,0},{54,0},
          {54,102},{118,102}}, color={255,127,0}));
  connect(greEqu2.y, opeModSel.uSetBac) annotation (Line(points={{22,-30},{30,-30},
          {30,-10},{70,-10},{70,98},{118,98}}, color={255,0,255}));
  connect(greEqu3.y, opeModSel.uSetUp) annotation (Line(points={{22,-100},{30,-100},
          {30,-80},{94,-80},{94,88},{118,88}}, color={255,0,255}));
  connect(zonTem.y, add3.u1) annotation (Line(points={{-38,50},{-20,50},{-20,-54},
          {-2,-54}}, color={0,0,127}));
  connect(TZonHeaSetUno.y, add3.u2) annotation (Line(points={{-78,-30},{-40,-30},
          {-40,-66},{-2,-66}}, color={0,0,127}));
  connect(add3.y, hys3.u)
    annotation (Line(points={{22,-60},{38,-60}}, color={0,0,127}));
  connect(hys3.y, opeModSel.uEndSetBac) annotation (Line(points={{62,-60},{82,-60},
          {82,96},{118,96}}, color={255,0,255}));
  connect(zonTem.y, add1.u1) annotation (Line(points={{-38,50},{-20,50},{-20,-134},
          {-2,-134}}, color={0,0,127}));
  connect(TZonCooSetUno.y, add1.u2) annotation (Line(points={{-78,-100},{-40,-100},
          {-40,-146},{-2,-146}}, color={0,0,127}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{22,-140},{38,-140}}, color={0,0,127}));
  connect(hys1.y, opeModSel.uEndSetUp) annotation (Line(points={{62,-140},{100,-140},
          {100,86},{118,86}}, color={255,0,255}));

annotation (
  experiment(StopTime=172800, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/OperationMode.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode</a>
for a change of zone temperature and occupancy schedule.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2020, by Kun Zhang:<br/>
Changed zone temperature profile to showcase warm-up and cool down mode.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1893\">#1893</a>.
</li>
<li>
March 21, 2019, by Jianjun Hu:<br/>
Reimplemented occupancy schedule block to avoid use block that is not in CDL. 
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1389\">issue 1389</a>.
</li>
<li>
June 19, 2017, by Jianjun Hu:<br/>
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
  Diagram(coordinateSystem(extent={{-160,-160},{160,180}})));
end OperationMode;
