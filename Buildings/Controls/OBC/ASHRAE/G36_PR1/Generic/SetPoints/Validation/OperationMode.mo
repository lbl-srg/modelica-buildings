within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model OperationMode "Validate block for selecting operation mode"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final offset=0,
    final height=6.2831852,
    final duration=48*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final k=14.5,
                  final p=273.15 + 22.5) "Zone temperarure"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=273.15 + 12)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=273.15 + 30)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=273.15 + 20)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=273.15 + 24)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWinSta(final k=false)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={-90,-50})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final have_winSen=true, final numZon=1)
    "Operation mode selection"
    annotation (Placement(transformation(extent={{100,84},{120,116}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    "True when zone occupied heating setpoint temperature is larger than zone temperature"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu1
    "True when zone occupied heating setpoint temperature is larger than zone temperature"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu2
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu3
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1 "Convert boolean to integer"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
protected
  final parameter Real occSta(
    final unit="s",
    final quantity="Time") = 7*3600 "Occupancy start time";
  final parameter Real occEnd(
    final unit="s",
    final quantity="Time") =  19*3600 "Occupancy end time";

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-118,10},{-102,10}}, color={0,0,127}));
  connect(sin1.y, addPar.u)
    annotation (Line(points={{-78,10},{-62,10}},  color={0,0,127}));
  connect(cooDowTim.y, opeModSel.maxCooDowTim) annotation (Line(points={{-78,110},
          {98,110}},                 color={0,0,127}));
  connect(warUpTim.y, opeModSel.maxWarUpTim) annotation (Line(points={{-78,80},
          {-60,80},{-60,106},{98,106}},
                                     color={0,0,127}));
  connect(TZonHeaSetOcc.y, greEqu.u1)
    annotation (Line(points={{-78,40},{-2,40}},   color={0,0,127}));
  connect(addPar.y, greEqu.u2) annotation (Line(points={{-38,10},{-20,10},{-20,32},
          {-2,32}},  color={0,0,127}));
  connect(greEqu.y, opeModSel.uOccHeaHig) annotation (Line(points={{22,40},{30,
          40},{30,104},{98,104}},
                                color={255,0,255}));
  connect(addPar.y, greEqu1.u1) annotation (Line(points={{-38,10},{-20,10},{-20,
          -10},{-2,-10}},
                     color={0,0,127}));
  connect(TZonCooSetOcc.y, greEqu1.u2) annotation (Line(points={{-78,-20},{-40,-20},
          {-40,-18},{-2,-18}},
                             color={0,0,127}));
  connect(greEqu1.y, opeModSel.uHigOccCoo) annotation (Line(points={{22,-10},{
          34,-10},{34,108},{98,108}},
                                    color={255,0,255}));
  connect(uWinSta.y, opeModSel.uWinSta) annotation (Line(points={{-78,-50},{38,-50},
          {38,90},{88,90}},        color={255,0,255}));
  connect(TZonHeaSetUno.y, greEqu2.u1)
    annotation (Line(points={{-78,-80},{-2,-80}},   color={0,0,127}));
  connect(addPar.y, greEqu2.u2) annotation (Line(points={{-38,10},{-20,10},{-20,
          -88},{-2,-88}},
                      color={0,0,127}));
  connect(greEqu2.y, booToInt.u)
    annotation (Line(points={{22,-80},{38,-80}},   color={255,0,255}));
  connect(booToInt.y, opeModSel.totColZon) annotation (Line(points={{62,-80},{
          68,-80},{68,100},{98,100}},  color={255,127,0}));
  connect(greEqu2.y, opeModSel.unoHeaHigMin) annotation (Line(points={{22,-80},{
          30,-80},{30,-60},{60,-60},{60,86},{88,86}},      color={255,0,255}));
  connect(addPar.y, opeModSel.TZonMax) annotation (Line(points={{-38,10},{42,10},
          {42,94},{98,94}},color={0,0,127}));
  connect(addPar.y, opeModSel.TZonMin) annotation (Line(points={{-38,10},{42,10},
          {42,92},{98,92}},color={0,0,127}));
  connect(addPar.y, greEqu3.u1) annotation (Line(points={{-38,10},{-20,10},{-20,
          -120},{-2,-120}},
                      color={0,0,127}));
  connect(TZonCooSetUno.y, greEqu3.u2) annotation (Line(points={{-78,-120},{-40,
          -120},{-40,-128},{-2,-128}},
                               color={0,0,127}));
  connect(greEqu3.y, booToInt1.u)
    annotation (Line(points={{22,-120},{38,-120}}, color={255,0,255}));
  connect(greEqu3.y, opeModSel.maxHigUnoCoo) annotation (Line(points={{22,-120},
          {30,-120},{30,-100},{80,-100},{80,78},{88,78}},    color={255,0,255}));
  connect(booToInt1.y, opeModSel.totHotZon) annotation (Line(points={{62,-120},
          {74,-120},{74,90},{98,90}},  color={255,127,0}));
  connect(occSch.occupied, opeModSel.uOcc) annotation (Line(points={{-79,144},{
          80,144},{80,114},{98,114}}, color={255,0,255}));
  connect(occSch.tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-79,156},
          {-40,156},{-40,114},{60,114},{60,112},{98,112}},
                                                     color={0,0,127}));

annotation (
  experiment(
      StopTime=172800,
      Tolerance=1e-06),
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
