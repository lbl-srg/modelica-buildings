within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model OperationMode "Validate block OperationModeSelector"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
    opeModSel(final numZon=1) "Block that outputs the operation mode"
    annotation (Placement(transformation(extent={{72,-100},{92,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-96,-100},{-76,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-52,-100},{-32,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final k=12.5, final p=273.15 + 22.5)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetUno(
    final k=273.15 + 12)  "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-170},{-40,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetUno(
    final k=273.15 + 30)  "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonHeaSetOcc(
    final k=273.15 + 20)  "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TZonCooSetOcc(
    final k=273.15 + 24)  "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim(
    final k=1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim(
    final k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uWinSta(final k=false)
    "Window on/off status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={60,-120})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable occTim(
    final table=[0,0; occSta,1; occEnd,0; 24*3600,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=24*3600) "One day in second"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Output first input divided by second input"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Round rou(final n=0)
    "Round real number to 0 digit"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=24*3600)
    "Begin time of each day"
    annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    "Check if it is beginning of next day"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-1, final k=1) "Add parameter"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=24*3600) "Begin of day"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Beginning of current day"
    annotation (Placement(transformation(extent={{40,130},{60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Add curTim(final k2=-1) "Current time "
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1)
    "Left time to beginning of current day occupancy "
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occStaTim(
    final k=occSta) "Occupancy start"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Left time to the end of current day"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar2(
    final p=occSta, final k=1)
    "Left time to next occupancy"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu1
    "Check if current time has already passed occupancy start time"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Time to next occupancy"
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold occ(
    final threshold=0.5) "Occupied status"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

protected
  final parameter Modelica.SIunits.Time occSta = 7*3600 "Occupancy start time";
  final parameter Modelica.SIunits.Time occEnd = 19*3600 "Occupancy end time";

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-75,-90},{-54,-90}}, color={0,0,127}));
  connect(sin1.y, addPar.u)
    annotation (Line(points={{-31,-90},{-2,-90}}, color={0,0,127}));
  connect(addPar.y, opeModSel.TZon[1])
    annotation (Line(points={{21,-90},{71,-90}}, color={0,0,127}));
  connect(TZonHeaSetOcc.y, opeModSel.TZonHeaSetOcc)
    annotation (Line(points={{-39,-120},{-20,-120},{-20,-102},{34,-102},
      {34,-92.2},{71,-92.2}}, color={0,0,127}));
  connect(TZonCooSetOcc.y, opeModSel.TZonCooSetOcc)
    annotation (Line(points={{21,-120},{36,-120},{36,-94.6},{71,-94.6}},
      color={0,0,127}));
  connect(TZonHeaSetUno.y, opeModSel.TZonHeaSetUno)
    annotation (Line(points={{-39,-160},{-20,-160},{-20,-138},{38,-138},
      {38,-96.8},{71,-96.8}}, color={0,0,127}));
  connect(TZonCooSetUno.y, opeModSel.TZonCooSetUno)
    annotation (Line(points={{21,-160},{40,-160},{40,-99},{71,-99}},
      color={0,0,127}));
  connect(warUpTim.y, opeModSel.warUpTim[1])
    annotation (Line(points={{-39,-50},{-20,-50},{-20,-70},{34,-70},{34,-88},
      {46,-88},{46,-87.8},{71,-87.8}}, color={0,0,127}));
  connect(cooDowTim.y, opeModSel.cooDowTim[1])
    annotation (Line(points={{21,-50},{36,-50},{36,-86},{48,-86},{48,-85.6},
      {71,-85.6}}, color={0,0,127}));
  connect(uWinSta.y, opeModSel.uWinSta[1])
    annotation (Line(points={{71,-120},{82,-120},{82,-101}}, color={255,0,255}));
  connect(modTim.y, div.u1)
    annotation (Line(points={{-139,160},{-130,160},{-130,146},{-122,146}},
      color={0,0,127}));
  connect(con.y, div.u2)
    annotation (Line(points={{-139,60},{-130,60},{-130,134},{-122,134}}, color={0,0,127}));
  connect(div.y, rou.u)
    annotation (Line(points={{-99,140},{-82,140}}, color={0,0,127}));
  connect(rou.y, gai.u)
    annotation (Line(points={{-59,140},{-42,140}}, color={0,0,127}));
  connect(gai.y, lesEqu.u1)
    annotation (Line(points={{-19,140},{-2,140}}, color={0,0,127}));
  connect(modTim.y, lesEqu.u2)
    annotation (Line(points={{-139,160},{-10,160},{-10,132},{-2,132}}, color={0,0,127}));
  connect(rou.y, addPar1.u)
    annotation (Line(points={{-59,140},{-50,140},{-50,110},{-42,110}}, color={0,0,127}));
  connect(addPar1.y, gai1.u)
    annotation (Line(points={{-19,110},{-2,110}}, color={0,0,127}));
  connect(lesEqu.y, swi.u2)
    annotation (Line(points={{21,140},{38,140}}, color={255,0,255}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-19,140},{-14,140},{-14,170},{30,170},{30,148},
      {38,148}}, color={0,0,127}));
  connect(gai1.y, swi.u3)
    annotation (Line(points={{21,110},{30,110},{30,132},{38,132}}, color={0,0,127}));
  connect(modTim.y, curTim.u1)
    annotation (Line(points={{-139,160},{-10,160},{-10,166},{78,166}}, color={0,0,127}));
  connect(swi.y, curTim.u2)
    annotation (Line(points={{61,140},{70,140},{70,154},{78,154}}, color={0,0,127}));
  connect(occStaTim.y, add2.u1)
    annotation (Line(points={{-119,20},{-100,20},{-100,86},{78,86}}, color={0,0,127}));
  connect(con.y, add1.u1)
    annotation (Line(points={{-139,60},{-130,60},{-130,66},{-2,66}}, color={0,0,127}));
  connect(add1.y, addPar2.u)
    annotation (Line(points={{21,60},{38,60}}, color={0,0,127}));
  connect(occStaTim.y, lesEqu1.u2)
    annotation (Line(points={{-119,20},{-100,20},{-100,12},{-2,12}}, color={0,0,127}));
  connect(curTim.y, lesEqu1.u1)
    annotation (Line(points={{101,160},{140,160},{140,40},{-20,40},{-20,20},
      {-2,20}}, color={0,0,127}));
  connect(lesEqu1.y, swi1.u2)
    annotation (Line(points={{21,20},{118,20}}, color={255,0,255}));
  connect(add2.y, swi1.u1)
    annotation (Line(points={{101,80},{110,80},{110,28},{118,28}}, color={0,0,127}));
  connect(addPar2.y, swi1.u3)
    annotation (Line(points={{61,60},{100,60},{100,12},{118,12}}, color={0,0,127}));
  connect(occTim.y[1], occ.u)
    annotation (Line(points={{-119,-20},{-102,-20}}, color={0,0,127}));
  connect(occ.y, opeModSel.uOcc)
    annotation (Line(points={{-79,-20},{60,-20},{60,-81},{71,-81}}, color={255,0,255}));
  connect(swi1.y, opeModSel.tNexOcc)
    annotation (Line(points={{141,20},{150,20},{150,-60},{40,-60},{40,-83.4},
      {71,-83.4}}, color={0,0,127}));
  connect(curTim.y, add2.u2)
    annotation (Line(points={{101,160},{140,160},{140,100},{60,100},{60,74},
      {78,74}}, color={0,0,127}));
  connect(curTim.y, add1.u2)
    annotation (Line(points={{101,160},{140,160},{140,40},{-20,40},{-20,54},
      {-2,54}}, color={0,0,127}));

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
    Diagram(coordinateSystem(extent={{-160,-180},{160,180}})));
end OperationMode;
