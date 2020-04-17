within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model OperationMode "Validate block for selecting operation mode"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final k=12.5, final p=273.15 + 22.5) "Zone temperarure"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=273.15 + 12)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=273.15 + 30)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-210},{-40,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=273.15 + 20)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=273.15 + 24)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWinSta(final k=false)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={-50,-130})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable occTim(
    final table=[0,0; occSta,1; occEnd,0; 24*3600,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-160,230},{-140,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=24*3600) "One day in second"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Output first input divided by second input"
    annotation (Placement(transformation(extent={{-120,210},{-100,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Round rou(final n=0)
    "Round real number to 0 digit"
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=24*3600)
    "Begin time of each day"
    annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    "Check if it is beginning of next day"
    annotation (Placement(transformation(extent={{0,210},{20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1, final k=1) "Add parameter"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=24*3600) "Begin of day"
    annotation (Placement(transformation(extent={{0,180},{20,200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Beginning of current day"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Add curTim(final k2=-1) "Current time "
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Left time to beginning of current day occupancy "
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occStaTim(
    final k=occSta) "Occupancy start"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Left time to the end of current day"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=occSta, final k=1)
    "Left time to next occupancy"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu1
    "Check if current time has already passed occupancy start time"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Time to next occupancy"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold occ(
    final threshold=0.5) "Occupied status"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel(final
      have_winSen=true, final numZon=1) "Operation mode selection"
    annotation (Placement(transformation(extent={{130,0},{150,20}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    "True when zone occupied heating setpoint temperature is larger than zone temperature"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu1
    "True when zone occupied heating setpoint temperature is larger than zone temperature"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu2
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt "Convert boolean to integer"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu3
    "True when the zone temperature is lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1 "Convert boolean to integer"
    annotation (Placement(transformation(extent={{80,-210},{100,-190}})));

protected
  final parameter Real occSta(
    final unit="s",
    final quantity="Time") = 7*3600 "Occupancy start time";
  final parameter Real occEnd(
    final unit="s",
    final quantity="Time") =  19*3600 "Occupancy end time";

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={0,0,127}));
  connect(sin1.y, addPar.u)
    annotation (Line(points={{-38,-70},{-22,-70}},color={0,0,127}));
  connect(modTim.y, div.u1)
    annotation (Line(points={{-138,240},{-130,240},{-130,226},{-122,226}},
      color={0,0,127}));
  connect(con.y, div.u2)
    annotation (Line(points={{-138,140},{-130,140},{-130,214},{-122,214}}, color={0,0,127}));
  connect(div.y, rou.u)
    annotation (Line(points={{-98,220},{-82,220}}, color={0,0,127}));
  connect(rou.y, gai.u)
    annotation (Line(points={{-58,220},{-42,220}}, color={0,0,127}));
  connect(gai.y, lesEqu.u1)
    annotation (Line(points={{-18,220},{-2,220}}, color={0,0,127}));
  connect(modTim.y, lesEqu.u2)
    annotation (Line(points={{-138,240},{-10,240},{-10,212},{-2,212}}, color={0,0,127}));
  connect(rou.y, addPar1.u)
    annotation (Line(points={{-58,220},{-50,220},{-50,190},{-42,190}}, color={0,0,127}));
  connect(addPar1.y, gai1.u)
    annotation (Line(points={{-18,190},{-2,190}}, color={0,0,127}));
  connect(lesEqu.y, swi.u2)
    annotation (Line(points={{22,220},{38,220}}, color={255,0,255}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-18,220},{-14,220},{-14,250},{30,250},{30,228},{38,
          228}}, color={0,0,127}));
  connect(gai1.y, swi.u3)
    annotation (Line(points={{22,190},{30,190},{30,212},{38,212}}, color={0,0,127}));
  connect(modTim.y, curTim.u1)
    annotation (Line(points={{-138,240},{-10,240},{-10,246},{78,246}}, color={0,0,127}));
  connect(swi.y, curTim.u2)
    annotation (Line(points={{62,220},{70,220},{70,234},{78,234}}, color={0,0,127}));
  connect(occStaTim.y, add2.u1)
    annotation (Line(points={{-118,100},{-100,100},{-100,166},{78,166}},
                                                                     color={0,0,127}));
  connect(con.y, add1.u1)
    annotation (Line(points={{-138,140},{-130,140},{-130,146},{-2,146}},
                                                                     color={0,0,127}));
  connect(add1.y, addPar2.u)
    annotation (Line(points={{22,140},{38,140}},
                                               color={0,0,127}));
  connect(occStaTim.y, lesEqu1.u2)
    annotation (Line(points={{-118,100},{-100,100},{-100,92},{-2,92}},
                                                                     color={0,0,127}));
  connect(curTim.y, lesEqu1.u1)
    annotation (Line(points={{102,240},{140,240},{140,120},{-20,120},{-20,100},{
          -2,100}},
                color={0,0,127}));
  connect(lesEqu1.y, swi1.u2)
    annotation (Line(points={{22,100},{118,100}},
                                                color={255,0,255}));
  connect(add2.y, swi1.u1)
    annotation (Line(points={{102,160},{110,160},{110,108},{118,108}},
                                                                   color={0,0,127}));
  connect(addPar2.y, swi1.u3)
    annotation (Line(points={{62,140},{100,140},{100,92},{118,92}},
                                                                  color={0,0,127}));
  connect(occTim.y[1], occ.u)
    annotation (Line(points={{-118,60},{-102,60}},   color={0,0,127}));
  connect(curTim.y, add2.u2)
    annotation (Line(points={{102,240},{140,240},{140,180},{60,180},{60,154},{78,
          154}},color={0,0,127}));
  connect(curTim.y, add1.u2)
    annotation (Line(points={{102,240},{140,240},{140,120},{-20,120},{-20,134},{
          -2,134}},
                color={0,0,127}));
  connect(occ.y, opeModSel.uOcc) annotation (Line(points={{-78,60},{80,60},{80,
          22},{128,22}}, color={255,0,255}));
  connect(swi1.y, opeModSel.tNexOcc) annotation (Line(points={{142,100},{150,
          100},{150,40},{72,40},{72,20},{128,20}}, color={0,0,127}));
  connect(cooDowTim.y, opeModSel.maxCooDowTim) annotation (Line(points={{-38,30},
          {64,30},{64,18},{128,18}}, color={0,0,127}));
  connect(warUpTim.y, opeModSel.maxWarUpTim) annotation (Line(points={{-38,0},{
          -20,0},{-20,16},{128,16}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, greEqu.u1)
    annotation (Line(points={{-38,-40},{38,-40}}, color={0,0,127}));
  connect(addPar.y, greEqu.u2) annotation (Line(points={{2,-70},{20,-70},{20,-48},
          {38,-48}}, color={0,0,127}));
  connect(greEqu.y, opeModSel.occHeaHigMin) annotation (Line(points={{62,-40},{
          70,-40},{70,14},{128,14}}, color={255,0,255}));
  connect(addPar.y, greEqu1.u1) annotation (Line(points={{2,-70},{20,-70},{20,-90},
          {38,-90}}, color={0,0,127}));
  connect(TZonCooSetOcc.y, greEqu1.u2) annotation (Line(points={{-38,-100},{0,-100},
          {0,-98},{38,-98}}, color={0,0,127}));
  connect(greEqu1.y, opeModSel.maxHigOccCoo) annotation (Line(points={{62,-90},
          {74,-90},{74,12},{128,12}}, color={255,0,255}));
  connect(uWinSta.y, opeModSel.uWinSta) annotation (Line(points={{-38,-130},{78,
          -130},{78,10},{128,10}}, color={255,0,255}));
  connect(TZonHeaSetUno.y, greEqu2.u1)
    annotation (Line(points={{-38,-160},{38,-160}}, color={0,0,127}));
  connect(addPar.y, greEqu2.u2) annotation (Line(points={{2,-70},{20,-70},{20,-168},
          {38,-168}}, color={0,0,127}));
  connect(greEqu2.y, booToInt.u)
    annotation (Line(points={{62,-160},{78,-160}}, color={255,0,255}));
  connect(booToInt.y, opeModSel.totColZon) annotation (Line(points={{102,-160},
          {108,-160},{108,8},{128,8}}, color={255,127,0}));
  connect(greEqu2.y, opeModSel.unoHeaHigMin) annotation (Line(points={{62,-160},
          {70,-160},{70,-140},{100,-140},{100,6},{128,6}}, color={255,0,255}));
  connect(addPar.y, opeModSel.TZonMax) annotation (Line(points={{2,-70},{82,-70},
          {82,4},{128,4}}, color={0,0,127}));
  connect(addPar.y, opeModSel.TZonMin) annotation (Line(points={{2,-70},{82,-70},
          {82,2},{128,2}}, color={0,0,127}));
  connect(addPar.y, greEqu3.u1) annotation (Line(points={{2,-70},{20,-70},{20,-200},
          {38,-200}}, color={0,0,127}));
  connect(TZonCooSetUno.y, greEqu3.u2) annotation (Line(points={{-38,-200},{0,-200},
          {0,-208},{38,-208}}, color={0,0,127}));
  connect(greEqu3.y, booToInt1.u)
    annotation (Line(points={{62,-200},{78,-200}}, color={255,0,255}));
  connect(greEqu3.y, opeModSel.maxHigUnoCoo) annotation (Line(points={{62,-200},
          {70,-200},{70,-180},{120,-180},{120,-2},{128,-2}}, color={255,0,255}));
  connect(booToInt1.y, opeModSel.totHotZon) annotation (Line(points={{102,-200},
          {114,-200},{114,0},{128,0}}, color={255,127,0}));

annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
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
    Diagram(coordinateSystem(extent={{-160,-280},{160,280}})));
end OperationMode;
