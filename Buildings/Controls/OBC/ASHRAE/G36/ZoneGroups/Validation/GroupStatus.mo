within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.Validation;
model GroupStatus
  "Validate block for checking temperatures in the group"

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus zonGroSta(
    final nBuiZon=3,
    final nGroZon=2,
    final zonGroMsk={true,false,true}) "Calculate zone group status"
    annotation (Placement(transformation(extent={{120,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant warUpTim[3](
    final k={1800,1700,1900})
    "Warm-up time"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooDowTim[3](
    final k={1600,1700,1800})
    "Cooling down time"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta[3](
    final width={0.3,0.2,0.1},
    final period=fill(3600, 3),
    final shift={150,130,120})
    "Window status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-50,-300})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-100,-220},{-80,-200}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=6)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter zonTem(
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccOve[3](
    final k=fill(false,3))
    "Occupancy local override"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={70,180})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse zonOcc1(
    final width=0.8,
    final period=7200,
    shift=1800)
    "Zone 1 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,160})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse zonOcc3(
    final width=0.8,
    final period=7200,
    shift=2100) "Zone 3 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,40})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Time after input becomes true"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim3 "Time after input becomes true"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract addPar1
    "Time to occupied period"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract addPar3
    "Time to occupied period"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowOccHea[3](
    final width=fill(0.5, 3),
    final period=fill(3600, 3),
    final shift=fill(1000, 3)) "Lower than occupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      origin={-130,-40})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higOccCoo[3](
    final k=fill(false, 3))
    "Higher than occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,-60})));
  Buildings.Controls.OBC.CDL.Logical.And and2[3]
    "Lower than occupied heating setpoint when it is not occupied"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowUnoHea1[3](
    final width=fill(0.1, 3),
    final period=fill(3600, 3))
    "Lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,-80})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant heaSetOff[3](
    final k={285.15,282.15,283.15})
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse endSetBac[3](
    final width=fill(0.8, 3),
    final period=fill(3600, 3),
    final shift=fill(900, 3)) "End setback"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,-120})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higUnoCoo[3](
    final k=fill(false, 3))
    "HIgher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,-140})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooSetOff[3](
    final k={303.15,304.15,305.15})
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endSetUp[3](
    final k=fill(false,3))
    "End setup mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,-180})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse zonTem3(
    final amplitude=7,
    final period=600,
    final offset=273.15 + 19) "Zone 3 temperature"
    annotation (Placement(transformation(extent={{-80,-280},{-60,-260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zonTem2(
    final k=273.15 + 20)
    "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant zonOcc2(
    final k=true)
    "Zone 2 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,100})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant tNexOcc2(
    final k=0) "Zone 2 next occupancy time"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=1800)
    "Constant"
    annotation (Placement(transformation(extent={{-20,170},{0,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=2100)
    "Constant"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

equation
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-118,-210},{-102,-210}}, color={0,0,127}));
  connect(not1.y, tim1.u)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(not3.y,tim3. u)
    annotation (Line(points={{-38,20},{-22,20}},   color={255,0,255}));
  connect(uOccOve.y, zonGroSta.zonOcc) annotation (Line(points={{82,180},{100,180},
          {100,-21},{118,-21}},      color={255,0,255}));
  connect(zonOcc1.y, not1.u) annotation (Line(points={{-78,160},{-72,160},{-72,140},
          {-62,140}}, color={255,0,255}));
  connect(zonOcc3.y,not3. u) annotation (Line(points={{-78,40},{-72,40},{-72,20},
          {-62,20}},  color={255,0,255}));
  connect(zonOcc1.y, zonGroSta.u1Occ[1]) annotation (Line(points={{-78,160},{98,
          160},{98,-23.6667},{118,-23.6667}}, color={255,0,255}));
  connect(zonOcc3.y, zonGroSta.u1Occ[3]) annotation (Line(points={{-78,40},{98,
          40},{98,-38},{118,-38},{118,-22.3333}}, color={255,0,255}));
  connect(addPar1.y, zonGroSta.tNexOcc[1]) annotation (Line(points={{42,140},{
          94,140},{94,-25.6667},{118,-25.6667}},
                                              color={0,0,127}));
  connect(addPar3.y, zonGroSta.tNexOcc[3]) annotation (Line(points={{42,20},{92,
          20},{92,-24.3333},{118,-24.3333}}, color={0,0,127}));
  connect(cooDowTim.y, zonGroSta.uCooTim) annotation (Line(points={{-118,0},{90,
          0},{90,-29},{118,-29}},color={0,0,127}));
  connect(warUpTim.y, zonGroSta.uWarTim) annotation (Line(points={{-78,-20},{88,
          -20},{88,-31},{118,-31}}, color={0,0,127}));
  connect(not1.y, and2[1].u2) annotation (Line(points={{-38,140},{-34,140},{-34,
          -48},{-22,-48}}, color={255,0,255}));
  connect(not3.y, and2[3].u2) annotation (Line(points={{-38,20},{-30,20},{-30,-48},
          {-22,-48}},      color={255,0,255}));
  connect(lowOccHea.y, and2.u1)
    annotation (Line(points={{-118,-40},{-22,-40}}, color={255,0,255}));
  connect(and2.y, zonGroSta.u1OccHeaHig) annotation (Line(points={{2,-40},{20,-40},
          {20,-35},{118,-35}}, color={255,0,255}));
  connect(higOccCoo.y, zonGroSta.u1HigOccCoo) annotation (Line(points={{-78,-60},
          {22,-60},{22,-37},{118,-37}}, color={255,0,255}));
  connect(lowUnoHea1.y, zonGroSta.u1UnoHeaHig) annotation (Line(points={{-118,-80},
          {24,-80},{24,-41},{118,-41}}, color={255,0,255}));
  connect(heaSetOff.y, zonGroSta.THeaSetOff) annotation (Line(points={{-78,-100},
          {26,-100},{26,-43},{118,-43}},color={0,0,127}));
  connect(endSetBac.y, zonGroSta.u1EndSetBac) annotation (Line(points={{-118,-120},
          {28,-120},{28,-45},{118,-45}}, color={255,0,255}));
  connect(higUnoCoo.y, zonGroSta.u1HigUnoCoo) annotation (Line(points={{-78,-140},
          {30,-140},{30,-49},{118,-49}}, color={255,0,255}));
  connect(cooSetOff.y, zonGroSta.TCooSetOff) annotation (Line(points={{-118,-160},
          {32,-160},{32,-51},{118,-51}},       color={0,0,127}));
  connect(endSetUp.y, zonGroSta.u1EndSetUp) annotation (Line(points={{-78,-180},
          {34,-180},{34,-53},{118,-53}}, color={255,0,255}));
  connect(zonTem.y, zonGroSta.TZon[1]) annotation (Line(points={{2,-210},{36,
          -210},{36,-57.6667},{118,-57.6667}},
                                         color={0,0,127}));
  connect(zonTem3.y, zonGroSta.TZon[3]) annotation (Line(points={{-58,-270},{
          104,-270},{104,-56},{118,-56},{118,-56.3333}},
                                                     color={0,0,127}));
  connect(winSta.y, zonGroSta.u1Win) annotation (Line(points={{-38,-300},{118,-300},
          {118,-59}}, color={255,0,255}));
  connect(zonTem2.y, zonGroSta.TZon[2]) annotation (Line(points={{-98,-250},{80,
          -250},{80,-60},{118,-60},{118,-57}}, color={0,0,127}));
  connect(zonOcc2.y, not2.u) annotation (Line(points={{-78,100},{-72,100},{-72,80},
          {-62,80}},     color={255,0,255}));
  connect(not2.y, and2[2].u2) annotation (Line(points={{-38,80},{-26,80},{-26,-48},
          {-22,-48}},      color={255,0,255}));
  connect(zonOcc2.y, zonGroSta.u1Occ[2]) annotation (Line(points={{-78,100},{98,
          100},{98,-23},{118,-23}}, color={255,0,255}));
  connect(tNexOcc2.y, zonGroSta.tNexOcc[2]) annotation (Line(points={{62,70},{94,
          70},{94,-25},{118,-25}},    color={0,0,127}));
  connect(con.y, addPar1.u1) annotation (Line(points={{2,180},{10,180},{10,146},
          {18,146}}, color={0,0,127}));
  connect(tim1.y, addPar1.u2) annotation (Line(points={{2,140},{10,140},{10,134},
          {18,134}}, color={0,0,127}));
  connect(con1.y, addPar3.u1) annotation (Line(points={{2,70},{10,70},{10,26},{18,
          26}}, color={0,0,127}));
  connect(tim3.y, addPar3.u2) annotation (Line(points={{2,20},{10,20},{10,14},{18,
          14}}, color={0,0,127}));
  connect(sin2.y, gai.u)
    annotation (Line(points={{-78,-210},{-62,-210}}, color={0,0,127}));
  connect(gai.y, zonTem.u)
    annotation (Line(points={{-38,-210},{-22,-210}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ZoneGroups/Validation/GroupStatus.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus</a>
for checking group temperature status.
</p>
<p>
The block takes 3 zones as input, but filters them
down to only processing zone 1 and 3 
(reindexed in output to 1 and 2 respectively).
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
    Diagram(coordinateSystem(extent={{-160,-320},{160,200}})));
end GroupStatus;
