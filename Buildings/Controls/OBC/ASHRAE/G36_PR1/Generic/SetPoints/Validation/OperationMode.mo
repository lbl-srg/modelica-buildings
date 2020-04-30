within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model OperationMode "Validate block for selecting operation mode"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final offset=0,
    final height=6.2831852,
    final duration=48*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final k=14.5,
                  final p=273.15 + 22.5) "Zone temperarure"
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

  Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
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

  connect(occSch.occupied, opeModSel.uOcc) annotation (Line(points={{-39,64},{
          120,64},{120,22},{128,22}}, color={255,0,255}));
  connect(occSch.tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{-39,76},
          {0,76},{0,34},{100,34},{100,20},{128,20}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=172800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
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
