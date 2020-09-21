within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model GroupStatus
  "Validate block for checking temperatures in the group"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(
    final numZon=2) "Calculate zone group status"
    annotation (Placement(transformation(extent={{120,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim[2](
    final k={1800,1900}) "Warm-up time"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim[2](
    final k={1600,1800}) "Cooling down time"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta[2](
    final width={0.3,0.1},
    final period=fill(3600, 2),
    final startTime={150,120}) "Window status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-50,-180})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final k=6,
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccOve[2](
    final k=fill(false, 2))
    "Occupancy local override"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,180})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse zonOcc1(
    final width=0.8,
    final period=7200,
    final startTime=1800) "Zone 1 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,160})));
 Buildings.Controls.OBC.CDL.Logical.Sources.Pulse zonOcc2(
    final width=0.8,
    final period=7200,
    final startTime=2100) "Zone 2 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,120})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim "Time after input becomes true"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Time after input becomes true"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1800,
    final k=-1) "Time to occupied period"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=2100,
    final k=-1) "Time to occupied period"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowOccHea[2](
    final width=fill(0.5, 2),
    final period=fill(3600, 2),
    final startTime=fill(1000, 2)) "Lower than occupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      origin={-130,40})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higOccCoo[2](
    final k=fill(false, 2))
    "Higher than occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,20})));
  Buildings.Controls.OBC.CDL.Logical.And and2[2]
    "Lower than occupied heating setpoint when it is not occupied"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowUnoHea1[2](
    final width=fill(0.1, 2),
    final period=fill(3600, 2)) "Lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetOff[2](
    final k={285.15,283.15})
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse endSetBac[2](
    final width=fill(0.8, 2),
    final period=fill(3600, 2),
    final startTime=fill(900, 2)) "End setback"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,-40})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higUnoCoo[2](
    final k=fill(false, 2))
    "HIgher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetOff[2](
    final k={303.15,305.15})
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endSetUp[2](
    final k=fill(false, 2))
    "End setup mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,-100})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse zonTem2(
    final amplitude=7,
    final period=600,
    final offset=273.15 + 19) "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));

equation
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(sin2.y, zonTem.u)
    annotation (Line(points={{-78,-130},{-62,-130}}, color={0,0,127}));
  connect(not1.y, tim.u)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(not2.y, tim1.u)
    annotation (Line(points={{-38,100},{-22,100}}, color={255,0,255}));
  connect(tim.y, addPar.u)
    annotation (Line(points={{2,140},{18,140}}, color={0,0,127}));
  connect(tim1.y, addPar1.u)
    annotation (Line(points={{2,100},{18,100}}, color={0,0,127}));
  connect(uOccOve.y, zonGroSta.zonOcc) annotation (Line(points={{-118,180},{100,
          180},{100,59},{118,59}}, color={255,0,255}));
  connect(zonOcc1.y, not1.u) annotation (Line(points={{-78,160},{-70,160},{-70,140},
          {-62,140}}, color={255,0,255}));
  connect(zonOcc2.y, not2.u) annotation (Line(points={{-78,120},{-70,120},{-70,100},
          {-62,100}}, color={255,0,255}));
  connect(zonOcc1.y, zonGroSta.uOcc[1]) annotation (Line(points={{-78,160},{98,160},
          {98,56},{118,56}}, color={255,0,255}));
  connect(zonOcc2.y, zonGroSta.uOcc[2]) annotation (Line(points={{-78,120},{96,120},
          {96,58},{118,58}}, color={255,0,255}));
  connect(addPar.y, zonGroSta.tNexOcc[1]) annotation (Line(points={{42,140},{94,
          140},{94,54},{118,54}}, color={0,0,127}));
  connect(addPar1.y, zonGroSta.tNexOcc[2]) annotation (Line(points={{42,100},{92,
          100},{92,56},{118,56}}, color={0,0,127}));
  connect(cooDowTim.y, zonGroSta.uCooTim) annotation (Line(points={{-118,80},{90,
          80},{90,51},{118,51}}, color={0,0,127}));
  connect(warUpTim.y, zonGroSta.uWarTim) annotation (Line(points={{-78,60},{88,60},
          {88,49},{118,49}}, color={0,0,127}));
  connect(not1.y, and2[1].u2) annotation (Line(points={{-38,140},{-30,140},{-30,
          32},{-22,32}}, color={255,0,255}));
  connect(not2.y, and2[2].u2) annotation (Line(points={{-38,100},{-32,100},{-32,
          32},{-22,32}}, color={255,0,255}));
  connect(lowOccHea.y, and2.u1)
    annotation (Line(points={{-118,40},{-22,40}}, color={255,0,255}));
  connect(and2.y, zonGroSta.uOccHeaHig) annotation (Line(points={{2,40},{20,40},
          {20,45},{118,45}}, color={255,0,255}));
  connect(higOccCoo.y, zonGroSta.uHigOccCoo) annotation (Line(points={{-78,20},{
          22,20},{22,43},{118,43}}, color={255,0,255}));
  connect(lowUnoHea1.y, zonGroSta.uUnoHeaHig) annotation (Line(points={{-118,0},
          {24,0},{24,39},{118,39}}, color={255,0,255}));
  connect(heaSetOff.y, zonGroSta.THeaSetOff) annotation (Line(points={{-78,-20},
          {26,-20},{26,37},{118,37}}, color={0,0,127}));
  connect(endSetBac.y, zonGroSta.uEndSetBac) annotation (Line(points={{-118,-40},
          {28,-40},{28,35},{118,35}}, color={255,0,255}));
  connect(higUnoCoo.y, zonGroSta.uHigUnoCoo) annotation (Line(points={{-78,-60},
          {30,-60},{30,31},{118,31}}, color={255,0,255}));
  connect(cooSetOff.y, zonGroSta.TCooSetOff) annotation (Line(points={{-118,-80},
          {32,-80},{32,29},{118,29}}, color={0,0,127}));
  connect(endSetUp.y, zonGroSta.uEndSetUp) annotation (Line(points={{-78,-100},{
          34,-100},{34,27},{118,27}}, color={255,0,255}));
  connect(zonTem.y, zonGroSta.TZon[1]) annotation (Line(points={{-38,-130},{36,-130},
          {36,22},{118,22}}, color={0,0,127}));
  connect(zonTem2.y, zonGroSta.TZon[2]) annotation (Line(points={{-78,-160},{38,
          -160},{38,24},{118,24}}, color={0,0,127}));
  connect(winSta.y, zonGroSta.uWin) annotation (Line(points={{-38,-180},{40,-180},
          {40,21},{118,21}}, color={255,0,255}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/Generic/SetPoints/Validation/GroupStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus</a>
for checking group temperature status.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2020, by Jianjun Hu:<br/>
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
    Diagram(coordinateSystem(extent={{-160,-200},{160,200}})));
end GroupStatus;
