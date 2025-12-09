within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Validation;
model WithoutWSE
  "Validation sequence of controlling tower of a plant without waterside economizer"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Controller
    towCon(
    nChi=2,
    totSta=3,
    nTowCel=2,
    nConWatPum=2,
    have_WSE=false,
    kWSE=0.5,
    TiWSE=10,
    staVec={0,1,2},
    towCelOnSet={0,1,2})
    "Cooling tower controller"
    annotation (Placement(transformation(extent={{200,340},{220,380}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,130},{-340,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-190},{-340,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-230},{-340,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Add conWatSupTem
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram3(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-130},{-340,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet2(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-90},{-340,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Add conWatRetTem
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-300,-110},{-280,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,110},{-300,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatSupSet(
    final k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(final width=0.1,
    final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,260},{-340,280}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiOneSta "Chiller one status"
    annotation (Placement(transformation(extent={{-320,260},{-300,280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,70},{-300,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch maxTowSpe1
    "Max tower speed from chiller 1 head pressure control"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage "
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay towStaUp(
    final delayTime=30) "Cooling tower stage up"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[2] "Break algebraic"
    annotation (Placement(transformation(extent={{280,370},{300,390}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  CDL.Routing.BooleanScalarReplicator                     conWatPumSta(
    final nout=2) "Condenser water pump status"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta2(
    final width=0.7,
    final period=3600)
    "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,198},{-340,218}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiTwoSta1
    "Chiller two status"
    annotation (Placement(transformation(extent={{-320,198},{-300,218}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta3
    "Chiller stage "
    annotation (Placement(transformation(extent={{-100,-260},{-80,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch maxTowSpe2
    "Max tower speed from chiller 2 head pressure control"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Chiller stage"
    annotation (Placement(transformation(extent={{-40,-250},{-20,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 360,1; 1560,2; 3600,2],
    period=3600) "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-40,-290},{-20,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse conWatPum(
    final width=0.1,
    final period=3600) "Condenser water pump status"
    annotation (Placement(transformation(extent={{-300,-160},{-280,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-240,-160},{-220,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Logical and"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));

equation
  connect(ram2.y, conWatSupTem.u2) annotation (Line(points={{-338,-220},{-320,-220},
          {-320,-206},{-302,-206}}, color={0,0,127}));
  connect(conSup.y, conWatSupTem.u1) annotation (Line(points={{-338,-180},{-320,
          -180},{-320,-194},{-302,-194}}, color={0,0,127}));
  connect(conRet2.y, conWatRetTem.u1) annotation (Line(points={{-338,-80},{-320,
          -80},{-320,-94},{-302,-94}},    color={0,0,127}));
  connect(ram3.y, conWatRetTem.u2) annotation (Line(points={{-338,-120},{-320,
          -120},{-320,-106},{-302,-106}}, color={0,0,127}));
  connect(chiSta1.y, chiOneSta.u)
    annotation (Line(points={{-338,270},{-322,270}}, color={255,0,255}));
  connect(chiOneSta.y, maxTowSpe1.u2) annotation (Line(points={{-298,270},{-280,
          270},{-280,100},{-162,100}}, color={255,0,255}));
  connect(hpTowSpe1.y, maxTowSpe1.u1) annotation (Line(points={{-298,120},{-240,
          120},{-240,108},{-162,108}}, color={0,0,127}));
  connect(zer.y, maxTowSpe1.u3) annotation (Line(points={{-298,80},{-260,80},{-260,
          92},{-162,92}}, color={0,0,127}));
  connect(chiOneSta.y, towCon.uChi[1]) annotation (Line(points={{-298,270},{-30,
          270},{-30,377.5},{198,377.5}}, color={255,0,255}));
  connect(chiWatSupSet.y, towCon.TChiWatSupSet) annotation (Line(points={{-338,
          -40},{10,-40},{10,372},{198,372}}, color={0,0,127}));
  connect(plaCap.y, towCon.reqPlaCap) annotation (Line(points={{-338,140},{20,
          140},{20,370},{198,370}},
                               color={0,0,127}));
  connect(maxTowSpe1.y, towCon.uMaxSpeSet[1]) annotation (Line(points={{-138,
          100},{30,100},{30,367.5},{198,367.5}}, color={0,0,127}));
  connect(or3.y, towCon.uPla) annotation (Line(points={{-118,-70},{60,-70},{60,
          364},{198,364}}, color={255,0,255}));
  connect(conWatRetTem.y, towCon.TConWatRet) annotation (Line(points={{-278,
          -100},{70,-100},{70,362},{198,362}}, color={0,0,127}));
  connect(conWatSupTem.y, towCon.TConWatSup) annotation (Line(points={{-278,
          -200},{90,-200},{90,358},{198,358}}, color={0,0,127}));
  connect(chiOneSta.y, chiSta.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-220},{-142,-220}}, color={255,0,255}));
  connect(chiOneSta.y, towStaUp.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-320},{-142,-320}}, color={255,0,255}));
  connect(watLev.y, towCon.watLev) annotation (Line(points={{162,60},{170,60},{
          170,340},{198,340}}, color={0,0,127}));
  connect(towCon.yTowSta, pre1.u) annotation (Line(points={{222,355},{250,355},{
          250,380},{278,380}}, color={255,0,255}));
  connect(pre1.y, towCon.uTowSta) annotation (Line(points={{302,380},{340,380},
          {340,280},{50,280},{50,366},{198,366}},color={255,0,255}));
  connect(towStaUp.y, towCon.uTowStaCha) annotation (Line(points={{-118,-320},{
          120,-320},{120,350},{198,350}}, color={255,0,255}));
  connect(con3.y, towCon.uEnaPla) annotation (Line(points={{-58,-180},{94,-180},
          {94,356},{198,356}}, color={255,0,255}));
  connect(chiOneSta.y, or3.u1) annotation (Line(points={{-298,270},{-188,270},{-188,
          -70},{-142,-70}}, color={255,0,255}));
  connect(chiSta2.y, chiTwoSta1.u)
    annotation (Line(points={{-338,208},{-322,208}}, color={255,0,255}));
  connect(chiTwoSta1.y, towCon.uChi[2]) annotation (Line(points={{-298,208},{
          -30,208},{-30,378.5},{198,378.5}},
                                         color={255,0,255}));
  connect(chiTwoSta1.y, or3.u2) annotation (Line(points={{-298,208},{-200,208},{
          -200,-78},{-142,-78}}, color={255,0,255}));
  connect(chiTwoSta1.y, chiSta3.u) annotation (Line(points={{-298,208},{-200,208},
          {-200,-250},{-102,-250}}, color={255,0,255}));
  connect(chiSta.y, addInt.u1) annotation (Line(points={{-118,-220},{-60,-220},{
          -60,-234},{-42,-234}}, color={255,127,0}));
  connect(chiSta3.y, addInt.u2) annotation (Line(points={{-78,-250},{-62,-250},{
          -62,-246},{-42,-246}}, color={255,127,0}));
  connect(addInt.y, towCon.uChiSta) annotation (Line(points={{-18,-240},{100,
          -240},{100,354},{198,354}},
                                color={255,127,0}));
  connect(intTimTab.y[1], towCon.uChiStaSet) annotation (Line(points={{-18,-280},
          {108,-280},{108,352},{198,352}}, color={255,127,0}));
  connect(chiTwoSta1.y, maxTowSpe2.u2) annotation (Line(points={{-298,208},{-270,
          208},{-270,40},{-162,40}}, color={255,0,255}));
  connect(hpTowSpe1.y, maxTowSpe2.u1) annotation (Line(points={{-298,120},{-240,
          120},{-240,48},{-162,48},{-162,48}}, color={0,0,127}));
  connect(zer.y, maxTowSpe2.u3) annotation (Line(points={{-298,80},{-260,80},{-260,
          32},{-162,32}}, color={0,0,127}));
  connect(maxTowSpe2.y, towCon.uMaxSpeSet[2]) annotation (Line(points={{-138,40},
          {40,40},{40,368.5},{198,368.5}}, color={0,0,127}));
  connect(conWatPum.y, not2.u)
    annotation (Line(points={{-278,-150},{-242,-150}}, color={255,0,255}));
  connect(not2.y, and2.u1)
    annotation (Line(points={{-218,-150},{-62,-150}}, color={255,0,255}));
  connect(or3.y, and2.u2) annotation (Line(points={{-118,-70},{-80,-70},{-80,-158},
          {-62,-158}}, color={255,0,255}));
  connect(and2.y, conWatPumSta.u)
    annotation (Line(points={{-38,-150},{18,-150}}, color={255,0,255}));
  connect(conWatPumSta.y, towCon.uConWatPum) annotation (Line(points={{42,-150},
          {80,-150},{80,360},{198,360}}, color={255,0,255}));
annotation (experiment(StopTime=3500.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Towers/Validation/WithoutWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Controller</a>.
It demonstates the cooling tower control of a less coupled chiller plant that has
two chillers without waterside economizer.
</p>
<ul>
<li>
At begining, the water level is lower than the minimum thus the tower starts
adding water (<code>yMakUp</code>). When the water level becomes greater than the
maximum, it stops adding water at 1500 seconds.
</li>
<li>
The plant is enabled in chiller mode at 360 seconds. The chiller 1 becomes enabled
and the lead cooling tower cell becomes enabled at 372 seconds.
</li>
<li>
After 300 seconds (<code>chaTowCelIsoTim</code>) at 660 seconds, it turns on the
leading cell.
</li>
<li>
The tower fan speed is controlled based on the control of condenser water return
temperature
(<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.ReturnWaterTemperature.Controller</a>).
</li>
<li>
At 1560 seconds, the plant state setpoint changes from 1 to 2. According to
the vector <code>towCelOnSet</code>, which specifies number of cells at each plant
stage (<code>staVec</code>), two tower cell should be enabled. After 300 seconds
(<code>chaTowCelIsoTim</code>) at 1860 seconds, it turns on the cell two.
</ul>
</html>", revisions="<html>
<ul>
<li>
September 16, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-420},{400,420}})));
end WithoutWSE;
