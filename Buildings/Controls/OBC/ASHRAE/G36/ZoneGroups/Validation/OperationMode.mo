within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.Validation;
model OperationMode "Validate block for selecting operation mode"

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode
    opeModSel(final nZon=1) "Operation mode selection"
    annotation (Placement(transformation(extent={{120,80},{140,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final height=6.2831852,
    final duration=172800)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final p=295.65) "Zone temperarure"
    annotation (Placement(transformation(extent={{-48,40},{-28,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=285.15)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=303.15)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=293.15)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=297.15)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cloWin(
    final k=0) "No window is open"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-150,0})));
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
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dif2
    "Calculate zone temperature difference to unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys3(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis that outputs if the zone temperature is higher than its unoccupied heating setpoint by a given limit"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dif1
    "Calculate zone temperature difference to unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-0.5,
    final uHigh=0.5)
    "Hysteresis that outputs if the zone temperature is lower than its unoccupied cooling setpoint by a given limit"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=14.5) "Gain factor"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-138,50},{-122,50}}, color={0,0,127}));
  connect(cooDowTim.y, opeModSel.maxCooDowTim) annotation (Line(points={{-138,130},
          {10,130},{10,114},{118,114}}, color={0,0,127}));
  connect(warUpTim.y, opeModSel.maxWarUpTim) annotation (Line(points={{-98,110},
          {118,110}},                     color={0,0,127}));
  connect(TZonHeaSetOcc.y, lowThaHeaSet.u1)
    annotation (Line(points={{-138,80},{-2,80}}, color={0,0,127}));
  connect(zonTem.y, lowThaHeaSet.u2) annotation (Line(points={{-26,50},{-20,50},
          {-20,72},{-2,72}}, color={0,0,127}));
  connect(zonTem.y, higThaCooSet.u1) annotation (Line(points={{-26,50},{-20,50},
          {-20,30},{-2,30}}, color={0,0,127}));
  connect(TZonCooSetOcc.y, higThaCooSet.u2) annotation (Line(points={{-98,20},{-60,
          20},{-60,22},{-2,22}}, color={0,0,127}));
  connect(TZonHeaSetUno.y, greEqu2.u1)
    annotation (Line(points={{-98,-30},{-2,-30}},   color={0,0,127}));
  connect(zonTem.y, greEqu2.u2) annotation (Line(points={{-26,50},{-20,50},{-20,
          -38},{-2,-38}}, color={0,0,127}));
  connect(greEqu2.y, booToInt.u)
    annotation (Line(points={{22,-30},{38,-30}},   color={255,0,255}));
  connect(booToInt.y, opeModSel.totColZon) annotation (Line(points={{62,-30},{
          76,-30},{76,102},{118,102}}, color={255,127,0}));
  connect(zonTem.y, opeModSel.TZonMin) annotation (Line(points={{-26,50},{64,50},
          {64,92},{118,92}}, color={0,0,127}));
  connect(zonTem.y, greEqu3.u1) annotation (Line(points={{-26,50},{-20,50},{-20,
          -100},{-2,-100}}, color={0,0,127}));
  connect(TZonCooSetUno.y, greEqu3.u2) annotation (Line(points={{-98,-100},{-60,
          -100},{-60,-108},{-2,-108}}, color={0,0,127}));
  connect(greEqu3.y, booToInt1.u)
    annotation (Line(points={{22,-100},{38,-100}}, color={255,0,255}));
  connect(booToInt1.y, opeModSel.totHotZon) annotation (Line(points={{62,-100},
          {88,-100},{88,88},{118,88}}, color={255,127,0}));
  connect(occSch.occupied, opeModSel.u1Occ) annotation (Line(points={{-99,144},
          {80,144},{80,118},{118,118}}, color={255,0,255}));
  connect(occSch.tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-99,156},
          {76,156},{76,116},{118,116}}, color={0,0,127}));
  connect(higThaCooSet.y, opeModSel.u1HigOccCoo) annotation (Line(points={{22,
          30},{50,30},{50,112},{118,112}}, color={255,0,255}));
  connect(lowThaHeaSet.y, opeModSel.u1OccHeaHig) annotation (Line(points={{22,
          80},{46,80},{46,108},{118,108}}, color={255,0,255}));
  connect(cloWin.y, opeModSel.uOpeWin) annotation (Line(points={{-138,0},{34,0},
          {34,104},{118,104}}, color={255,127,0}));
  connect(greEqu2.y, opeModSel.u1SetBac) annotation (Line(points={{22,-30},{30,
          -30},{30,-10},{70,-10},{70,98},{118,98}}, color={255,0,255}));
  connect(greEqu3.y, opeModSel.u1SetUp) annotation (Line(points={{22,-100},{30,
          -100},{30,-80},{94,-80},{94,84},{118,84}}, color={255,0,255}));
  connect(zonTem.y,dif2. u1) annotation (Line(points={{-26,50},{-20,50},{-20,-54},
          {-2,-54}}, color={0,0,127}));
  connect(TZonHeaSetUno.y,dif2. u2) annotation (Line(points={{-98,-30},{-60,-30},
          {-60,-66},{-2,-66}}, color={0,0,127}));
  connect(dif2.y, hys3.u)
    annotation (Line(points={{22,-60},{38,-60}}, color={0,0,127}));
  connect(hys3.y, opeModSel.u1EndSetBac) annotation (Line(points={{62,-60},{82,
          -60},{82,96},{118,96}}, color={255,0,255}));
  connect(dif1.y, hys1.u)
    annotation (Line(points={{22,-140},{38,-140}}, color={0,0,127}));
  connect(hys1.y, opeModSel.u1EndSetUp) annotation (Line(points={{62,-140},{100,
          -140},{100,82},{118,82}}, color={255,0,255}));
  connect(sin1.y, gai.u)
    annotation (Line(points={{-98,50},{-82,50}}, color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-58,50},{-50,50}}, color={0,0,127}));
  connect(TZonCooSetUno.y, dif1.u1) annotation (Line(points={{-98,-100},{-60,-100},
          {-60,-134},{-2,-134}}, color={0,0,127}));
  connect(zonTem.y, dif1.u2) annotation (Line(points={{-26,50},{-20,50},{-20,-146},
          {-2,-146}}, color={0,0,127}));
annotation (
  experiment(StopTime=172800, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ZoneGroups/Validation/OperationMode.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode</a>
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
  Diagram(coordinateSystem(extent={{-180,-180},{180,180}})));
end OperationMode;
