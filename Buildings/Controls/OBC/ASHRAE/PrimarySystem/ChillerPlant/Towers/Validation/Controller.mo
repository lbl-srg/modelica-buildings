within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Validation;
model Controller "Validation sequence of controlling tower"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller
    towCon(
    nChi=2,
    nTowCel=4,
    nConWatPum=2,
    have_WSE=true)
    annotation (Placement(transformation(extent={{200,340},{220,380}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-360,200},{-340,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,70},{-340,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-190},{-340,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-230},{-340,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Add conWatSupTem
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-300,-210},{-280,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram3(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-150},{-340,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conRet2(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-110},{-340,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add conWatRetTem
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp conWatPumSpe1[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-300,-170},{-280,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,50},{-300,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe2(final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-360,-10},{-340,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant towFanSpe3(final k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,170},{-300,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatSupSet(
    final k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-50},{-340,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.4,
    final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,260},{-340,280}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiTwoSta(final k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-360,230},{-340,250}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3 "Logical or"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiOneSta "Chiller one status"
    annotation (Placement(transformation(extent={{-320,260},{-300,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-240,30},{-220,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch chiOneLoa "Chiller one load"
    annotation (Placement(transformation(extent={{-260,320},{-240,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiTwoLoa(final k=0)
    "Chiller two load"
    annotation (Placement(transformation(extent={{-360,300},{-340,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=0.2*1e4,
    final freqHz=1/1200,
    final offset=1.1*1e4,
    final startTime=180) "Chiller load"
    annotation (Placement(transformation(extent={{-360,340},{-340,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.1) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-360,140},{-340,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,100},{-340,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add chiWatSupTem
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage "
    annotation (Placement(transformation(extent={{-140,-240},{-120,-220}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay towStaUp(
    final delayTime=30) "Cooling tower stage up"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol[4](
    final samplePeriod=fill(5, 4))
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{280,320},{300,340}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4] "Break algebraic"
    annotation (Placement(transformation(extent={{280,370},{300,390}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp watLev(
    final height=1.2,
    final duration=3600,
    final offset=0.5) "Water level in cooling tower"
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiStaSet(
    final k=1) "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis leaConPum(
    final uLow=0.005, final uHigh=0.01)
    "Lead condenser water pump status"
    annotation (Placement(transformation(extent={{-240,-190},{-220,-170}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=4)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,-390},{-60,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[4](
    final k=fill(false,4))
    "Constant zero"
    annotation (Placement(transformation(extent={{-240,-410},{-220,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[4](
    final k={false,true,true,false})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-140,-370},{-120,-350}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch chaCel[4]
    "Vector of changing tower cells when WSE is enabled"
    annotation (Placement(transformation(extent={{-20,-390},{0,-370}})));
  Buildings.Controls.OBC.CDL.Logical.Not wseSta1 "Water side economizer status"
    annotation (Placement(transformation(extent={{-320,200},{-300,220}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch chaCel1[4]
    "Vector of changing tower cells when chiller is enabled"
    annotation (Placement(transformation(extent={{40,-310},{60,-290}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=4)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-80,-310},{-60,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[4](
    final k={true,false,false,true})
    "Enabling cells index"
    annotation (Placement(transformation(extent={{-240,-290},{-220,-270}})));

equation
  connect(ram2.y, conWatSupTem.u2) annotation (Line(points={{-338,-220},{-320,-220},
          {-320,-206},{-302,-206}}, color={0,0,127}));
  connect(conSup.y, conWatSupTem.u1) annotation (Line(points={{-338,-180},{-320,
          -180},{-320,-194},{-302,-194}}, color={0,0,127}));
  connect(conRet2.y, conWatRetTem.u1) annotation (Line(points={{-338,-100},{-320,
          -100},{-320,-114},{-302,-114}}, color={0,0,127}));
  connect(ram3.y, conWatRetTem.u2) annotation (Line(points={{-338,-140},{-320,-140},
          {-320,-126},{-302,-126}}, color={0,0,127}));
  connect(chiTwoSta.y, or3.u2) annotation (Line(points={{-338,240},{-194,240},{-194,
          -70},{-142,-70}}, color={255,0,255}));
  connect(chiSta1.y, chiOneSta.u)
    annotation (Line(points={{-338,270},{-322,270}}, color={255,0,255}));
  connect(chiOneSta.y, or3.u1) annotation (Line(points={{-298,270},{-188,270},{-188,
          -62},{-142,-62}}, color={255,0,255}));
  connect(chiOneSta.y, swi1.u2) annotation (Line(points={{-298,270},{-280,270},{
          -280,40},{-242,40}}, color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-298,60},{-260,60},{-260,48},{-242,48}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-298,20},{-260,20},{-260,32},{-242,32}},
      color={0,0,127}));
  connect(chiTwoLoa.y, chiOneLoa.u3) annotation (Line(points={{-338,310},{-320,310},
          {-320,322},{-262,322}}, color={0,0,127}));
  connect(sin.y, chiOneLoa.u1) annotation (Line(points={{-338,350},{-320,350},{-320,
          338},{-262,338}}, color={0,0,127}));
  connect(chiOneSta.y, chiOneLoa.u2) annotation (Line(points={{-298,270},{-280,270},
          {-280,330},{-262,330}}, color={255,0,255}));
  connect(chiSup.y, chiWatSupTem.u1) annotation (Line(points={{-338,150},{-320,150},
          {-320,136},{-262,136}}, color={0,0,127}));
  connect(ram1.y, chiWatSupTem.u2) annotation (Line(points={{-338,110},{-320,110},
          {-320,124},{-262,124}}, color={0,0,127}));
  connect(chiOneLoa.y, towCon.chiLoa[1]) annotation (Line(points={{-238,330},{-40,
          330},{-40,378},{198,378}}, color={0,0,127}));
  connect(chiTwoLoa.y, towCon.chiLoa[2]) annotation (Line(points={{-338,310},{-40,
          310},{-40,380},{198,380}}, color={0,0,127}));
  connect(chiOneSta.y, towCon.uChi[1]) annotation (Line(points={{-298,270},{-30,
          270},{-30,376},{198,376}}, color={255,0,255}));
  connect(chiTwoSta.y, towCon.uChi[2]) annotation (Line(points={{-338,240},{-30,
          240},{-30,378},{198,378}}, color={255,0,255}));
  connect(towFanSpe3.y,towCon.uFanSpe)  annotation (Line(points={{-298,180},{-10,
          180},{-10,373},{198,373}}, color={0,0,127}));
  connect(chiWatSupTem.y, towCon.TChiWatSup) annotation (Line(points={{-238,130},
          {0,130},{0,371},{198,371}}, color={0,0,127}));
  connect(chiWatSupSet.y, towCon.TChiWatSupSet) annotation (Line(points={{-338,-40},
          {10,-40},{10,369},{198,369}}, color={0,0,127}));
  connect(plaCap.y, towCon.reqPlaCap) annotation (Line(points={{-338,80},{20,80},
          {20,367},{198,367}}, color={0,0,127}));
  connect(swi1.y, towCon.uMaxTowSpeSet[1]) annotation (Line(points={{-218,40},{30,
          40},{30,364},{198,364}},color={0,0,127}));
  connect(hpTowSpe2.y, towCon.uMaxTowSpeSet[2]) annotation (Line(points={{-338,0},
          {40,0},{40,366},{198,366}},   color={0,0,127}));
  connect(or3.y, towCon.uPla) annotation (Line(points={{-118,-70},{60,-70},{60,361},
          {198,361}},      color={255,0,255}));
  connect(conWatRetTem.y, towCon.TConWatRet) annotation (Line(points={{-278,-120},
          {70,-120},{70,359},{198,359}}, color={0,0,127}));
  connect(conWatPumSpe1.y, towCon.uConWatPumSpe) annotation (Line(points={{-278,
          -160},{80,-160},{80,357},{198,357}}, color={0,0,127}));
  connect(conWatSupTem.y, towCon.TConWatSup) annotation (Line(points={{-278,-200},
          {90,-200},{90,355},{198,355}}, color={0,0,127}));
  connect(chiOneSta.y, chiSta.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-230},{-142,-230}}, color={255,0,255}));
  connect(chiSta.y, towCon.uChiSta) annotation (Line(points={{-118,-230},{100,-230},
          {100,353},{198,353}}, color={255,127,0}));
  connect(chiOneSta.y, towStaUp.u) annotation (Line(points={{-298,270},{-188,270},
          {-188,-320},{-142,-320}}, color={255,0,255}));
  connect(towCon.yIsoVal, zerOrdHol.u) annotation (Line(points={{222,365},{260,365},
          {260,330},{278,330}}, color={0,0,127}));
  connect(zerOrdHol.y, towCon.uIsoVal) annotation (Line(points={{302,330},{320,330},
          {320,300},{150,300},{150,343},{198,343}}, color={0,0,127}));
  connect(watLev.y, towCon.watLev) annotation (Line(points={{162,60},{170,60},{170,
          341},{198,341}}, color={0,0,127}));
  connect(towCon.yTowSta, pre1.u) annotation (Line(points={{222,355},{250,355},{
          250,380},{278,380}}, color={255,0,255}));
  connect(pre1.y, towCon.uTowSta) annotation (Line(points={{302,380},{340,380},{
          340,280},{50,280},{50,363},{198,363}}, color={255,0,255}));
  connect(towStaUp.y, towCon.uTowStaCha) annotation (Line(points={{-118,-320},{120,
          -320},{120,349},{198,349}}, color={255,0,255}));
  connect(chiStaSet.y, towCon.uChiStaSet) annotation (Line(points={{-118,-260},{
          108,-260},{108,351},{198,351}}, color={255,127,0}));
  connect(conWatPumSpe1[1].y, leaConPum.u) annotation (Line(points={{-278,-160},
          {-260,-160},{-260,-180},{-242,-180}}, color={0,0,127}));
  connect(leaConPum.y, towCon.uLeaConWatPum) annotation (Line(points={{-218,-180},
          {114,-180},{114,347},{198,347}}, color={255,0,255}));
  connect(con2.y, chaCel.u1) annotation (Line(points={{-118,-360},{-40,-360},{-40,
          -372},{-22,-372}}, color={255,0,255}));
  connect(booRep.y, chaCel.u2)
    annotation (Line(points={{-58,-380},{-22,-380}}, color={255,0,255}));
  connect(wseSta.y, wseSta1.u)
    annotation (Line(points={{-338,210},{-322,210}}, color={255,0,255}));
  connect(wseSta1.y, or3.u3) annotation (Line(points={{-298,210},{-200,210},{-200,
          -78},{-142,-78}}, color={255,0,255}));
  connect(wseSta1.y, towCon.uWse) annotation (Line(points={{-298,210},{-200,210},
          {-200,375},{198,375}}, color={255,0,255}));
  connect(wseSta1.y, booRep.u) annotation (Line(points={{-298,210},{-200,210},{-200,
          -380},{-82,-380}}, color={255,0,255}));
  connect(towStaUp.y, booRep1.u) annotation (Line(points={{-118,-320},{-100,-320},
          {-100,-300},{-82,-300}}, color={255,0,255}));
  connect(booRep1.y, chaCel1.u2)
    annotation (Line(points={{-58,-300},{38,-300}}, color={255,0,255}));
  connect(con1.y, chaCel1.u1) annotation (Line(points={{-218,-280},{-40,-280},{-40,
          -292},{38,-292}}, color={255,0,255}));
  connect(chaCel.y, chaCel1.u3) annotation (Line(points={{2,-380},{20,-380},{20,
          -308},{38,-308}}, color={255,0,255}));
  connect(con.y, chaCel.u3) annotation (Line(points={{-218,-400},{-40,-400},{-40,
          -388},{-22,-388}}, color={255,0,255}));
  connect(chaCel1.y, towCon.uChaCel) annotation (Line(points={{62,-300},{126,-300},
          {126,345},{198,345}}, color={255,0,255}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Controller</a>.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-420},{400,420}})));
end Controller;
