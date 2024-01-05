within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Validation;
model Controller "Validation sequence of controlling tower fan speed"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller
    cloCouWitWse
    "Tower fan speed controller of plant that is close coupled plant and has waterside economizer"
    annotation (Placement(transformation(extent={{-80,280},{-60,320}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller
    lesCouWitWse(final closeCoupledPlant=false)
    "Tower fan speed controller of plant that is less coupled plant and has waterside economizer"
    annotation (Placement(transformation(extent={{100,280},{120,320}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller
    cloCouNoWse(final have_WSE=false)
    "Tower fan speed controller of plant that is close coupled plant and has no waterside economizer"
    annotation (Placement(transformation(extent={{280,280},{300,320}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.2, final period=3600,
    shift=-3000)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-360,140},{-340,160}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,10},{-340,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conSup(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-250},{-340,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-290},{-340,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-270},{-280,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram3(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-200},{-340,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet2(
    final amplitude=2,
    final freqHz=1/1800,
    final offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-170},{-340,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-190},{-280,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conWatPumSpe1[2](
    final height=fill(0.5, 2),
    final duration=fill(3600, 2),
    final startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-300,-230},{-280,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,-10},{-300,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe2(final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-360,-70},{-340,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe3(final k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,110},{-300,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatSupSet(
    final k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-120},{-340,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.2, final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,200},{-340,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(final k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-360,170},{-340,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 "Logical or"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=4) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-320,200},{-300,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,-50},{-300,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi2 "Logical switch"
    annotation (Placement(transformation(extent={{-260,260},{-240,280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-360,240},{-340,260}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final amplitude=0.2*1e4,
    final freqHz=1/1200,
    final offset=1.1*1e4,
    final startTime=180) "Chiller load"
    annotation (Placement(transformation(extent={{-360,280},{-340,300}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.1) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-360,80},{-340,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));

equation
  connect(ram2.y,add1. u2)
    annotation (Line(points={{-338,-280},{-320,-280},{-320,-266},{-302,-266}},
      color={0,0,127}));
  connect(conSup.y,add1. u1)
    annotation (Line(points={{-338,-240},{-320,-240},{-320,-254},{-302,-254}},
      color={0,0,127}));
  connect(conRet2.y, add3.u1)
    annotation (Line(points={{-338,-160},{-320,-160},{-320,-174},{-302,-174}},
      color={0,0,127}));
  connect(ram3.y, add3.u2)
    annotation (Line(points={{-338,-190},{-320,-190},{-320,-186},{-302,-186}},
      color={0,0,127}));
  connect(or3.y, booRep.u)
    annotation (Line(points={{-238,-140},{-220,-140},{-220,-80},{-202,-80}},
      color={255,0,255}));
  connect(chiSta1.y, not1.u)
    annotation (Line(points={{-338,210},{-322,210}}, color={255,0,255}));
  connect(not1.y, swi1.u2)
    annotation (Line(points={{-298,210},{-280,210},{-280,-20},{-242,-20}},
      color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-298,0},{-260,0},{-260,-12},{-242,-12}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-298,-40},{-260,-40},{-260,-28},{-242,-28}},
      color={0,0,127}));
  connect(con1.y,swi2. u3)
    annotation (Line(points={{-338,250},{-320,250},{-320,262},{-262,262}},
      color={0,0,127}));
  connect(sin.y,swi2. u1)
    annotation (Line(points={{-338,290},{-320,290},{-320,278},{-262,278}},
      color={0,0,127}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{-298,210},{-280,210},{-280,270},{-262,270}},
      color={255,0,255}));
  connect(con1.y, cloCouWitWse.chiLoa[2])
    annotation (Line(points={{-338,250},{-210,250},{-210,319},{-82,319}},
      color={0,0,127}));
  connect(not1.y, cloCouWitWse.uChi[1])
    annotation (Line(points={{-298,210},{-200,210},{-200,316},{-82,316}},
      color={255,0,255}));
  connect(chiSta2.y, cloCouWitWse.uChi[2])
    annotation (Line(points={{-338,180},{-200,180},{-200,316},{-82,316}},
      color={255,0,255}));
  connect(wseSta.y, cloCouWitWse.uWse)
    annotation (Line(points={{-338,150},{-190,150},{-190,313},{-82,313}},
      color={255,0,255}));
  connect(towFanSpe3.y, cloCouWitWse.uFanSpe)
    annotation (Line(points={{-298,120},{-180,120},{-180,310},{-82,310}},
      color={0,0,127}));
  connect(chiSup.y,add2. u1)
    annotation (Line(points={{-338,90},{-320,90},{-320,76},{-262,76}},
      color={0,0,127}));
  connect(ram1.y,add2. u2)
    annotation (Line(points={{-338,50},{-320,50},{-320,64},{-262,64}},
      color={0,0,127}));
  connect(add2.y, cloCouWitWse.TChiWatSup)
    annotation (Line(points={{-238,70},{-170,70},{-170,307},{-82,307}},
      color={0,0,127}));
  connect(chiWatSupSet.y, cloCouWitWse.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{-160,-110},{-160,304},{-82,304}},
      color={0,0,127}));
  connect(plaCap.y, cloCouWitWse.reqPlaCap)
    annotation (Line(points={{-338,20},{-150,20},{-150,301},{-82,301}},
      color={0,0,127}));
  connect(swi1.y, cloCouWitWse.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-20},{-140,-20},{-140,298},{-82,298}},
      color={0,0,127}));
  connect(hpTowSpe2.y, cloCouWitWse.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-60},{-140,-60},{-140,298},{-82,298}},
      color={0,0,127}));
  connect(booRep.y, cloCouWitWse.uTow)
    annotation (Line(points={{-178,-80},{-130,-80},{-130,295},{-82,295}},
      color={255,0,255}));
  connect(or3.y, cloCouWitWse.uPla)
    annotation (Line(points={{-238,-140},{-120,-140},{-120,289},{-82,289}},
      color={255,0,255}));
  connect(add3.y, cloCouWitWse.TConWatRet)
    annotation (Line(points={{-278,-180},{-110,-180},{-110,286},{-82,286}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, cloCouWitWse.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{-100,-220},{-100,283},{-82,283}},
      color={0,0,127}));
  connect(swi2.y, cloCouWitWse.chiLoa[1])
    annotation (Line(points={{-238,270},{-210,270},{-210,319},{-82,319}},
      color={0,0,127}));
  connect(swi2.y, lesCouWitWse.chiLoa[1])
    annotation (Line(points={{-238,270},{-40,270},{-40,319},{98,319}},
      color={0,0,127}));
  connect(con1.y, lesCouWitWse.chiLoa[2])
    annotation (Line(points={{-338,250},{-40,250},{-40,319},{98,319}},
      color={0,0,127}));
  connect(not1.y, lesCouWitWse.uChi[1])
    annotation (Line(points={{-298,210},{-30,210},{-30,316},{98,316}},
      color={255,0,255}));
  connect(chiSta2.y, lesCouWitWse.uChi[2])
    annotation (Line(points={{-338,180},{-20,180},{-20,316},{98,316}},
      color={255,0,255}));
  connect(wseSta.y, lesCouWitWse.uWse)
    annotation (Line(points={{-338,150},{-10,150},{-10,313},{98,313}},
      color={255,0,255}));
  connect(towFanSpe3.y, lesCouWitWse.uFanSpe)
    annotation (Line(points={{-298,120},{0,120},{0,310},{98,310}},
      color={0,0,127}));
  connect(add2.y, lesCouWitWse.TChiWatSup)
    annotation (Line(points={{-238,70},{10,70},{10,307},{98,307}},
      color={0,0,127}));
  connect(chiWatSupSet.y, lesCouWitWse.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{20,-110},{20,304},{98,304}},
      color={0,0,127}));
  connect(plaCap.y, lesCouWitWse.reqPlaCap)
    annotation (Line(points={{-338,20},{30,20},{30,301},{98,301}},
      color={0,0,127}));
  connect(swi1.y, lesCouWitWse.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-20},{40,-20},{40,298},{98,298}},
      color={0,0,127}));
  connect(hpTowSpe2.y, lesCouWitWse.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-60},{40,-60},{40,298},{98,298}},
      color={0,0,127}));
  connect(booRep.y, lesCouWitWse.uTow)
    annotation (Line(points={{-178,-80},{50,-80},{50,295},{98,295}},
      color={255,0,255}));
  connect(or3.y, lesCouWitWse.uPla)
    annotation (Line(points={{-238,-140},{60,-140},{60,289},{98,289}},
      color={255,0,255}));
  connect(add3.y, lesCouWitWse.TConWatRet)
    annotation (Line(points={{-278,-180},{70,-180},{70,286},{98,286}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, lesCouWitWse.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{80,-220},{80,283},{98,283}},
      color={0,0,127}));
  connect(add1.y, lesCouWitWse.TConWatSup)
    annotation (Line(points={{-278,-260},{90,-260},{90,281},{98,281}},
      color={0,0,127}));
  connect(not1.y, cloCouNoWse.uChi[1])
    annotation (Line(points={{-298,210},{140,210},{140,316},{278,316}},
      color={255,0,255}));
  connect(chiSta2.y, cloCouNoWse.uChi[2])
    annotation (Line(points={{-338,180},{140,180},{140,316},{278,316}},
      color={255,0,255}));
  connect(towFanSpe3.y, cloCouNoWse.uFanSpe)
    annotation (Line(points={{-298,120},{150,120},{150,310},{278,310}},
      color={0,0,127}));
  connect(chiWatSupSet.y, cloCouNoWse.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{160,-110},{160,304},{278,304}},
      color={0,0,127}));
  connect(plaCap.y, cloCouNoWse.reqPlaCap)
    annotation (Line(points={{-338,20},{170,20},{170,301},{278,301}},
      color={0,0,127}));
  connect(swi1.y, cloCouNoWse.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-20},{180,-20},{180,298},{278,298}},
      color={0,0,127}));
  connect(hpTowSpe2.y, cloCouNoWse.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-60},{180,-60},{180,298},{278,298}},
      color={0,0,127}));
  connect(booRep.y, cloCouNoWse.uTow)
    annotation (Line(points={{-178,-80},{190,-80},{190,295},{278,295}},
      color={255,0,255}));
  connect(or3.y, cloCouNoWse.uPla)
    annotation (Line(points={{-238,-140},{200,-140},{200,289},{278,289}},
      color={255,0,255}));
  connect(add3.y, cloCouNoWse.TConWatRet)
    annotation (Line(points={{-278,-180},{210,-180},{210,286},{278,286}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, cloCouNoWse.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{220,-220},{220,283},{278,283}},
      color={0,0,127}));
  connect(not1.y, or4.u1) annotation (Line(points={{-298,210},{-280,210},{-280,-80},
          {-262,-80}}, color={255,0,255}));
  connect(chiSta2.y, or4.u2) annotation (Line(points={{-338,180},{-286,180},{-286,
          -88},{-262,-88}}, color={255,0,255}));
  connect(wseSta.y, or3.u2) annotation (Line(points={{-338,150},{-292,150},{-292,
          -148},{-262,-148}}, color={255,0,255}));
  connect(or4.y, or3.u1) annotation (Line(points={{-238,-80},{-230,-80},{-230,-100},
          {-270,-100},{-270,-140},{-262,-140}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2019, by Jianjun Hu:<br/>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-340},{400,340}})));
end Controller;
