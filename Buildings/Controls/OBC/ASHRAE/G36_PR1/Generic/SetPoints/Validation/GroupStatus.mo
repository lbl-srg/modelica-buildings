within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.Validation;
model GroupStatus
  "Validate block for checking temperatures in the group"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus zonGroSta(
    final numZon=3,
    numZonGro=2,
    zonGroMsk={true,false,true})
    "Calculate zone group status"
    annotation (Placement(transformation(extent={{122,-58},{142,-18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant warUpTim[3](
    final k={1800,1700,1900})
    "Warm-up time"
    annotation (Placement(transformation(extent={{-98,-28},{-78,-8}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooDowTim[3](
    final k={1600,1700,1800})
    "Cooling down time"
    annotation (Placement(transformation(extent={{-138,-8},{-118,12}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta[3](
    final width={0.3,0.2,0.1},
    final period=fill(3600, 3),
    final shift={150,130,120})
    "Window status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-46,-298})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    final offset=0,
    final height=6.2831852,
    final duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-138,-218},{-118,-198}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin2
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-98,-218},{-78,-198}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter zonTem(
    final k=6,
    final p=273.15 + 22.5)
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-58,-218},{-38,-198}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uOccOve[3](
    final k=fill(false,3))
    "Occupancy local override"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-130,180})));
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
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1800,
    final k=-1) "Time to occupied period"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar3(
    final p=2100,
    final k=-1) "Time to occupied period"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowOccHea[3](
    final width=fill(0.5, 3),
    final period=fill(3600, 3),
    final shift=fill(1000, 3)) "Lower than occupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      origin={-128,-38})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higOccCoo[3](
    final k=fill(false, 3))
    "Higher than occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-88,-58})));
  Buildings.Controls.OBC.CDL.Logical.And and2[3]
    "Lower than occupied heating setpoint when it is not occupied"
    annotation (Placement(transformation(extent={{-18,-48},{2,-28}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lowUnoHea1[3](
    final width=fill(0.1, 3),
    final period=fill(3600, 3))
    "Lower than unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-128,-78})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetOff[3](
    final k={285.15,282.15,283.15})
    "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-98,-108},{-78,-88}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse endSetBac[3](
    final width=fill(0.8, 3),
    final period=fill(3600, 3),
    final shift=fill(900, 3)) "End setback"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-128,-118})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant higUnoCoo[3](
    final k=fill(false, 3))
    "HIgher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-88,-138})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetOff[3](
    final k={303.15,304.15,305.15})
    "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-138,-168},{-118,-148}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant endSetUp[3](
    final k=fill(false,3))
    "End setup mode"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-88,-178})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse zonTem3(
    final amplitude=7,
    final period=600,
    final offset=273.15 + 19) "Zone 3 temperature"
    annotation (Placement(transformation(extent={{-78,-278},{-58,-258}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonTem2(
    final k=273.15 + 20)
    "Zone 2 temperature"
    annotation (Placement(transformation(extent={{-118,-258},{-98,-238}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant zonOcc2(
    final k=true)
    "Zone 2 occupied status"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-90,100})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tNexOcc2(
    final k=0)
    "Zone 2 next occupancy time"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

equation
  connect(ramp2.y,sin2. u)
    annotation (Line(points={{-116,-208},{-100,-208}}, color={0,0,127}));
  connect(sin2.y, zonTem.u)
    annotation (Line(points={{-76,-208},{-60,-208}}, color={0,0,127}));
  connect(not1.y, tim1.u)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(not3.y,tim3. u)
    annotation (Line(points={{-38,20},{-22,20}},   color={255,0,255}));
  connect(tim1.y, addPar1.u)
    annotation (Line(points={{2,140},{18,140}}, color={0,0,127}));
  connect(tim3.y,addPar3. u)
    annotation (Line(points={{2,20},{18,20}},   color={0,0,127}));
  connect(uOccOve.y, zonGroSta.zonOcc) annotation (Line(points={{-118,180},{102,
          180},{102,-19},{120,-19}}, color={255,0,255}));
  connect(zonOcc1.y, not1.u) annotation (Line(points={{-78,160},{-70,160},{-70,140},
          {-62,140}}, color={255,0,255}));
  connect(zonOcc3.y,not3. u) annotation (Line(points={{-78,40},{-70,40},{-70,20},
          {-62,20}},  color={255,0,255}));
  connect(zonOcc1.y, zonGroSta.uOcc[1]) annotation (Line(points={{-78,160},{100,
          160},{100,-22.3333},{120,-22.3333}}, color={255,0,255}));
  connect(zonOcc3.y, zonGroSta.uOcc[3]) annotation (Line(points={{-78,40},{100,
          40},{100,-36},{120,-36},{120,-19.6667}},
                                               color={255,0,255}));
  connect(addPar1.y, zonGroSta.tNexOcc[1]) annotation (Line(points={{42,140},{
          96,140},{96,-24.3333},{120,-24.3333}},
                                              color={0,0,127}));
  connect(addPar3.y, zonGroSta.tNexOcc[3]) annotation (Line(points={{42,20},{94,
          20},{94,-21.6667},{120,-21.6667}}, color={0,0,127}));
  connect(cooDowTim.y, zonGroSta.uCooTim) annotation (Line(points={{-116,2},{92,
          2},{92,-27},{120,-27}},color={0,0,127}));
  connect(warUpTim.y, zonGroSta.uWarTim) annotation (Line(points={{-76,-18},{90,
          -18},{90,-29},{120,-29}}, color={0,0,127}));
  connect(not1.y, and2[1].u2) annotation (Line(points={{-38,140},{-28,140},{-28,
          -46},{-20,-46}}, color={255,0,255}));
  connect(not3.y, and2[3].u2) annotation (Line(points={{-38,20},{-30,20},{-30,
          -46},{-20,-46}}, color={255,0,255}));
  connect(lowOccHea.y, and2.u1)
    annotation (Line(points={{-116,-38},{-20,-38}}, color={255,0,255}));
  connect(and2.y, zonGroSta.uOccHeaHig) annotation (Line(points={{4,-38},{22,
          -38},{22,-33},{120,-33}}, color={255,0,255}));
  connect(higOccCoo.y, zonGroSta.uHigOccCoo) annotation (Line(points={{-76,-58},
          {24,-58},{24,-35},{120,-35}}, color={255,0,255}));
  connect(lowUnoHea1.y, zonGroSta.uUnoHeaHig) annotation (Line(points={{-116,
          -78},{26,-78},{26,-39},{120,-39}}, color={255,0,255}));
  connect(heaSetOff.y, zonGroSta.THeaSetOff) annotation (Line(points={{-76,-98},
          {28,-98},{28,-41},{120,-41}}, color={0,0,127}));
  connect(endSetBac.y, zonGroSta.uEndSetBac) annotation (Line(points={{-116,
          -118},{30,-118},{30,-43},{120,-43}}, color={255,0,255}));
  connect(higUnoCoo.y, zonGroSta.uHigUnoCoo) annotation (Line(points={{-76,-138},
          {32,-138},{32,-47},{120,-47}}, color={255,0,255}));
  connect(cooSetOff.y, zonGroSta.TCooSetOff) annotation (Line(points={{-116,
          -158},{34,-158},{34,-49},{120,-49}}, color={0,0,127}));
  connect(endSetUp.y, zonGroSta.uEndSetUp) annotation (Line(points={{-76,-178},
          {36,-178},{36,-51},{120,-51}}, color={255,0,255}));
  connect(zonTem.y, zonGroSta.TZon[1]) annotation (Line(points={{-36,-208},{38,
          -208},{38,-56.3333},{120,-56.3333}},
                                         color={0,0,127}));
  connect(zonTem3.y, zonGroSta.TZon[3]) annotation (Line(points={{-56,-268},{
          106,-268},{106,-58},{120,-58},{120,-53.6667}},
                                                     color={0,0,127}));
  connect(winSta.y, zonGroSta.uWin) annotation (Line(points={{-34,-298},{120,
          -298},{120,-57}},  color={255,0,255}));
  connect(zonTem2.y, zonGroSta.TZon[2]) annotation (Line(points={{-96,-248},{82,
          -248},{82,-58},{120,-58},{120,-55}}, color={0,0,127}));
  connect(zonOcc2.y, not2.u) annotation (Line(points={{-78,100},{-70,100},{-70,
          80},{-62,80}}, color={255,0,255}));
  connect(not2.y, and2[2].u2) annotation (Line(points={{-38,80},{-28,80},{-28,
          -46},{-20,-46}}, color={255,0,255}));
  connect(zonOcc2.y, zonGroSta.uOcc[2]) annotation (Line(points={{-78,100},{100,
          100},{100,-21},{120,-21}}, color={255,0,255}));
  connect(tNexOcc2.y, zonGroSta.tNexOcc[2]) annotation (Line(points={{42,70},{
          96,70},{96,-23},{120,-23}}, color={0,0,127}));

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
