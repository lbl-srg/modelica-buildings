within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Validation;
model Controller "Validation sequence of controlling tower"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller
    towCon annotation (Placement(transformation(extent={{200,300},{220,340}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.2, final period=3600,
    startTime=-3000)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-360,160},{-340,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,30},{-340,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-230},{-340,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-270},{-340,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-250},{-280,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram3(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-180},{-340,-160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conRet2(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-150},{-340,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp conWatPumSpe1[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe2(final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant towFanSpe3(final k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,130},{-300,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatSupSet(
    final k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-100},{-340,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.2, final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,220},{-340,240}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(final k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-360,190},{-340,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 "Logical or"
    annotation (Placement(transformation(extent={{-140,-130},{-120,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-320,220},{-300,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,-30},{-300,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-240,-10},{-220,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-260,280},{-240,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-360,260},{-340,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.2*1e4,
    final freqHz=1/1200,
    final offset=1.1*1e4,
    final startTime=180) "Chiller load"
    annotation (Placement(transformation(extent={{-360,300},{-340,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.1) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-360,100},{-340,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,60},{-340,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage "
    annotation (Placement(transformation(extent={{-140,-280},{-120,-260}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[4](
    final k={4,1,2,3})
    "Tower cells enabling priority"
    annotation (Placement(transformation(extent={{-300,-310},{-280,-290}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay towStaUp(
    final delayTime=30) "Cooling tower stage up"
    annotation (Placement(transformation(extent={{-140,-340},{-120,-320}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(5, 4))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,280},{300,300}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4] "Break algebraic"
    annotation (Placement(transformation(extent={{280,330},{300,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{140,10},{160,30}})));

equation
  connect(ram2.y,add1. u2)
    annotation (Line(points={{-338,-260},{-320,-260},{-320,-246},{-302,-246}},
      color={0,0,127}));
  connect(conSup.y,add1. u1)
    annotation (Line(points={{-338,-220},{-320,-220},{-320,-234},{-302,-234}},
      color={0,0,127}));
  connect(conRet2.y, add3.u1)
    annotation (Line(points={{-338,-140},{-320,-140},{-320,-154},{-302,-154}},
      color={0,0,127}));
  connect(ram3.y, add3.u2)
    annotation (Line(points={{-338,-170},{-320,-170},{-320,-166},{-302,-166}},
      color={0,0,127}));
  connect(chiSta2.y, or3.u2)
    annotation (Line(points={{-338,200},{-194,200},{-194,-120},{-142,-120}},
      color={255,0,255}));
  connect(wseSta.y, or3.u3)
    annotation (Line(points={{-338,170},{-200,170},{-200,-128},{-142,-128}},
      color={255,0,255}));
  connect(chiSta1.y, not1.u)
    annotation (Line(points={{-338,230},{-322,230}}, color={255,0,255}));
  connect(not1.y, or3.u1)
    annotation (Line(points={{-298,230},{-188,230},{-188,-112},{-142,-112}},
      color={255,0,255}));
  connect(not1.y, swi1.u2)
    annotation (Line(points={{-298,230},{-280,230},{-280,0},{-242,0}},
      color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-298,20},{-260,20},{-260,8},{-242,8}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-298,-20},{-260,-20},{-260,-8},{-242,-8}},
      color={0,0,127}));
  connect(con1.y,swi2. u3)
    annotation (Line(points={{-338,270},{-320,270},{-320,282},{-262,282}},
      color={0,0,127}));
  connect(sin.y,swi2. u1)
    annotation (Line(points={{-338,310},{-320,310},{-320,298},{-262,298}},
      color={0,0,127}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-298,230},{-280,230},{-280,290},{-262,290}},
      color={255,0,255}));
  connect(chiSup.y,add2. u1)
    annotation (Line(points={{-338,110},{-320,110},{-320,96},{-262,96}},
      color={0,0,127}));
  connect(ram1.y,add2. u2)
    annotation (Line(points={{-338,70},{-320,70},{-320,84},{-262,84}},
      color={0,0,127}));
  connect(swi2.y, towCon.chiLoa[1]) annotation (Line(points={{-238,290},{-40,290},
          {-40,340},{198,340}}, color={0,0,127}));
  connect(con1.y, towCon.chiLoa[2]) annotation (Line(points={{-338,270},{-40,270},
          {-40,340},{198,340}}, color={0,0,127}));
  connect(not1.y, towCon.uChi[1]) annotation (Line(points={{-298,230},{-30,230},
          {-30,338},{198,338}}, color={255,0,255}));
  connect(chiSta2.y, towCon.uChi[2]) annotation (Line(points={{-338,200},{-30,200},
          {-30,338},{198,338}}, color={255,0,255}));
  connect(wseSta.y, towCon.uWseSta) annotation (Line(points={{-338,170},{-20,
          170},{-20,336},{198,336}}, color={255,0,255}));
  connect(towFanSpe3.y,towCon.uFanSpe)  annotation (Line(points={{-298,140},{-10,
          140},{-10,334},{198,334}}, color={0,0,127}));
  connect(add2.y, towCon.TChiWatSup) annotation (Line(points={{-238,90},{0,90},{
          0,332},{198,332}}, color={0,0,127}));
  connect(chiWatSupSet.y, towCon.TChiWatSupSet) annotation (Line(points={{-338,-90},
          {10,-90},{10,330},{198,330}}, color={0,0,127}));
  connect(plaCap.y, towCon.reqPlaCap) annotation (Line(points={{-338,40},{20,40},
          {20,328},{198,328}}, color={0,0,127}));
  connect(swi1.y, towCon.uMaxTowSpeSet[1]) annotation (Line(points={{-218,0},{30,
          0},{30,326},{198,326}}, color={0,0,127}));
  connect(hpTowSpe2.y, towCon.uMaxTowSpeSet[2]) annotation (Line(points={{-338,-40},
          {40,-40},{40,326},{198,326}}, color={0,0,127}));
  connect(or3.y, towCon.uPla) annotation (Line(points={{-118,-120},{60,-120},{60,
          322},{198,322}}, color={255,0,255}));
  connect(add3.y, towCon.TConWatRet) annotation (Line(points={{-278,-160},{70,-160},
          {70,320},{198,320}}, color={0,0,127}));
  connect(conWatPumSpe1.y, towCon.uConWatPumSpe) annotation (Line(points={{-278,
          -200},{80,-200},{80,318},{198,318}}, color={0,0,127}));
  connect(add1.y, towCon.TConWatSup) annotation (Line(points={{-278,-240},{90,-240},
          {90,316},{198,316}}, color={0,0,127}));
  connect(not1.y, chiSta.u) annotation (Line(points={{-298,230},{-188,230},{-188,
          -270},{-142,-270}}, color={255,0,255}));
  connect(chiSta.y, towCon.uChiSta) annotation (Line(points={{-118,-270},{100,-270},
          {100,314},{198,314}}, color={255,127,0}));
  connect(enaPri.y, towCon.uTowCelPri) annotation (Line(points={{-278,-300},{110,
          -300},{110,312},{198,312}}, color={255,127,0}));
  connect(not1.y, towCon.uStaUp) annotation (Line(points={{-298,230},{120,230},{
          120,310},{198,310}}, color={255,0,255}));
  connect(not1.y, towStaUp.u) annotation (Line(points={{-298,230},{-188,230},{-188,
          -330},{-142,-330}}, color={255,0,255}));
  connect(towStaUp.y, towCon.uTowStaUp) annotation (Line(points={{-118,-330},{130,
          -330},{130,308},{198,308}}, color={255,0,255}));
  connect(chiSta2.y, towCon.uStaDow) annotation (Line(points={{-338,200},{140,200},
          {140,306},{198,306}}, color={255,0,255}));
  connect(chiSta2.y, towCon.uTowStaDow) annotation (Line(points={{-338,200},{140,
          200},{140,304},{198,304}}, color={255,0,255}));
  connect(towCon.yIsoVal, zerOrdHol.u) annotation (Line(points={{222,316},{260,316},
          {260,290},{278,290}}, color={0,0,127}));
  connect(zerOrdHol.y, towCon.uIsoVal) annotation (Line(points={{302,290},{320,290},
          {320,260},{150,260},{150,302},{198,302}}, color={0,0,127}));
  connect(watLev.y, towCon.watLev) annotation (Line(points={{162,20},{170,20},{170,
          300},{198,300}}, color={0,0,127}));
  connect(towCon.yTowSta, pre1.u) annotation (Line(points={{222,330},{260,330},{
          260,340},{278,340}}, color={255,0,255}));
  connect(pre1.y, towCon.uTowSta) annotation (Line(points={{302,340},{340,340},{
          340,240},{50,240},{50,324},{198,324}}, color={255,0,255}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller</a>.
</p>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-360},{400,360}})));
end Controller;
