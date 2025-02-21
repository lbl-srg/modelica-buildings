within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Validation;
model Controller
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe
    "Tow fan speed for close coupled plants that have waterside economizer"
    annotation (Placement(transformation(extent={{-120,180},{-80,220}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe1(
    closeCoupledPlant=false)
    "Tow fan speed for less coupled plants that have waterside economizer"
    annotation (Placement(transformation(extent={{100,180},{140,220}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller
    towFanSpe2(
    have_WSE=false)
    "Tow fan speed for close coupled plants that have no waterside economizer"
    annotation (Placement(transformation(extent={{320,180},{360,220}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp speWSE(
    height=0.9,
    duration=3600)
    "Tower fan speed when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-360,150},{-340,170}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    width=0.2,
    period=3600,
    shift=-3000)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-360,50},{-340,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp plaCap(
    height=8e5,
    duration=3600,
    offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-360,20},{-340,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conSup(
    amplitude=2,
    freqHz=1/1800,
    offset=273.15 + 29) "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-360,-250},{-340,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram2(
    height=3,
    duration=3600,
    startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-290},{-340,-270}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-270},{-280,-250}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram3(
    height=3,
    duration=3600,
    startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-360,-200},{-340,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin conRet2(
    amplitude=2,
    freqHz=1/1800,
    offset=273.15 + 28) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-360,-170},{-340,-150}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3 "Add real inputs"
    annotation (Placement(transformation(extent={{-300,-190},{-280,-170}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conWatPumSpe1[2](
    height=fill(0.5, 2),
    duration=fill(3600, 2),
    startTime=fill(300, 2)) "Measured condenser water pump speed"
    annotation (Placement(transformation(extent={{-300,-230},{-280,-210}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe1(k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-320,0},{-300,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowSpe2(k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-360,-40},{-340,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant towFanSpe3(k=0.2)
    "Measured tower fan speed"
    annotation (Placement(transformation(extent={{-320,-60},{-300,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatSupSet(
    k=273.15 + 6.5)
    "Chilled water supply setpoint"
    annotation (Placement(transformation(extent={{-360,-120},{-340,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    width=0.2, period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-360,110},{-340,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-360,80},{-340,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 "Logical or"
    annotation (Placement(transformation(extent={{-260,-150},{-240,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4 "Logical or"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    nout=4) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-200,-90},{-180,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-320,110},{-300,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-320,180},{-300,200}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-240,150},{-220,170}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));

equation
  connect(ram2.y,add1. u2)
    annotation (Line(points={{-338,-280},{-320,-280},{-320,-266},{-302,-266}},
      color={0,0,127}));
  connect(conSup.y,add1. u1)
    annotation (Line(points={{-338,-240},{-320,-240},{-320,-254},{-302,-254}},
      color={0,0,127}));
  connect(wseSta.y, towFanSpe.uWse)
    annotation (Line(points={{-338,60},{-188,60},{-188,212},{-122,212}},
      color={255,0,255}));
  connect(plaCap.y, towFanSpe.reqPlaCap)
    annotation (Line(points={{-338,30},{-182,30},{-182,209},{-122,209}},
      color={0,0,127}));
  connect(towFanSpe3.y,towFanSpe.uFanSpe)
    annotation (Line(points={{-298,-50},{-170,-50},{-170,203},{-122,203}},
      color={0,0,127}));
  connect(chiWatSupSet.y, towFanSpe.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{-158,-110},{-158,194},{-122,194}},
      color={0,0,127}));
  connect(conRet2.y, add3.u1)
    annotation (Line(points={{-338,-160},{-320,-160},{-320,-174},{-302,-174}},
      color={0,0,127}));
  connect(ram3.y, add3.u2)
    annotation (Line(points={{-338,-190},{-320,-190},{-320,-186},{-302,-186}},
      color={0,0,127}));
  connect(add3.y, towFanSpe.TConWatRet)
    annotation (Line(points={{-278,-180},{-146,-180},{-146,188},{-122,188}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, towFanSpe.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{-140,-220},{-140,185},{-122,185}},
      color={0,0,127}));
  connect(wseSta.y, towFanSpe1.uWse)
    annotation (Line(points={{-338,60},{32,60},{32,212},{98,212}},
      color={255,0,255}));
  connect(plaCap.y, towFanSpe1.reqPlaCap)
    annotation (Line(points={{-338,30},{38,30},{38,209},{98,209}},
      color={0,0,127}));
  connect(towFanSpe3.y,towFanSpe1.uFanSpe)
    annotation (Line(points={{-298,-50},{50,-50},{50,203},{98,203}},
      color={0,0,127}));
  connect(chiWatSupSet.y, towFanSpe1.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{62,-110},{62,194},{98,194}},
      color={0,0,127}));
  connect(add3.y, towFanSpe1.TConWatRet)
    annotation (Line(points={{-278,-180},{74,-180},{74,188},{98,188}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, towFanSpe1.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{80,-220},{80,185},{98,185}},
      color={0,0,127}));
  connect(add1.y, towFanSpe1.TConWatSup)
    annotation (Line(points={{-278,-260},{86,-260},{86,182},{98,182}},
      color={0,0,127}));
  connect(plaCap.y, towFanSpe2.reqPlaCap)
    annotation (Line(points={{-338,30},{246,30},{246,209},{318,209}},
      color={0,0,127}));
  connect(towFanSpe3.y,towFanSpe2.uFanSpe)
    annotation (Line(points={{-298,-50},{258,-50},{258,203},{318,203}},
      color={0,0,127}));
  connect(chiWatSupSet.y, towFanSpe2.TChiWatSupSet)
    annotation (Line(points={{-338,-110},{270,-110},{270,194},{318,194}},
      color={0,0,127}));
  connect(add3.y, towFanSpe2.TConWatRet)
    annotation (Line(points={{-278,-180},{282,-180},{282,188},{318,188}},
      color={0,0,127}));
  connect(conWatPumSpe1.y, towFanSpe2.uConWatPumSpe)
    annotation (Line(points={{-278,-220},{288,-220},{288,185},{318,185}},
      color={0,0,127}));
  connect(chiSta2.y, towFanSpe.uChi[2])
    annotation (Line(points={{-338,90},{-194,90},{-194,215},{-122,215}},
      color={255,0,255}));
  connect(chiSta2.y, towFanSpe1.uChi[2])
    annotation (Line(points={{-338,90},{26,90},{26,215},{98,215}},
      color={255,0,255}));
  connect(chiSta2.y, towFanSpe2.uChi[2])
    annotation (Line(points={{-338,90},{240,90},{240,215},{318,215}},
      color={255,0,255}));
  connect(or3.y, towFanSpe.uPla)
    annotation (Line(points={{-238,-140},{-152,-140},{-152,191},{-122,191}},
      color={255,0,255}));
  connect(or3.y, towFanSpe1.uPla)
    annotation (Line(points={{-238,-140},{68,-140},{68,191},{98,191}},
      color={255,0,255}));
  connect(or3.y, towFanSpe2.uPla)
    annotation (Line(points={{-238,-140},{276,-140},{276,191},{318,191}},
      color={255,0,255}));
  connect(or3.y, booRep.u)
    annotation (Line(points={{-238,-140},{-220,-140},{-220,-80},{-202,-80}},
      color={255,0,255}));
  connect(booRep.y, towFanSpe.uTow) annotation (Line(points={{-178,-80},{-164,-80},
          {-164,200},{-122,200}}, color={255,0,255}));
  connect(booRep.y, towFanSpe1.uTow) annotation (Line(points={{-178,-80},{56,-80},
          {56,200},{98,200}}, color={255,0,255}));
  connect(booRep.y, towFanSpe2.uTow) annotation (Line(points={{-178,-80},{264,-80},
          {264,200},{318,200}}, color={255,0,255}));
  connect(chiSta1.y, not1.u)
    annotation (Line(points={{-338,120},{-322,120}}, color={255,0,255}));
  connect(not1.y, towFanSpe.uChi[1])
    annotation (Line(points={{-298,120},{-194,120},{-194,215},{-122,215}},
      color={255,0,255}));
  connect(not1.y, towFanSpe1.uChi[1])
    annotation (Line(points={{-298,120},{26,120},{26,215},{98,215}},
      color={255,0,255}));
  connect(not1.y, towFanSpe2.uChi[1])
    annotation (Line(points={{-298,120},{240,120},{240,215},{318,215}},
      color={255,0,255}));
  connect(wseSta.y, swi.u2)
    annotation (Line(points={{-338,60},{-292,60},{-292,160},{-242,160}},
      color={255,0,255}));
  connect(speWSE.y, swi.u1)
    annotation (Line(points={{-338,160},{-300,160},{-300,168},{-242,168}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-298,190},{-260,190},{-260,152},{-242,152}},
      color={0,0,127}));
  connect(swi.y, towFanSpe.uTowSpeWSE)
    annotation (Line(points={{-218,160},{-200,160},{-200,218},{-122,218}},
      color={0,0,127}));
  connect(swi.y, towFanSpe1.uTowSpeWSE)
    annotation (Line(points={{-218,160},{20,160},{20,218},{98,218}}, color={0,0,127}));
  connect(not1.y, swi1.u2)
    annotation (Line(points={{-298,120},{-280,120},{-280,-10},{-242,-10}},
      color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-298,10},{-276,10},{-276,-2},{-242,-2}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-298,190},{-260,190},{-260,-18},{-242,-18}},
      color={0,0,127}));
  connect(swi1.y, towFanSpe.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-10},{-176,-10},{-176,206},{-122,206}},
      color={0,0,127}));
  connect(hpTowSpe2.y, towFanSpe.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-30},{-176,-30},{-176,206},{-122,206}},
      color={0,0,127}));
  connect(swi1.y, towFanSpe1.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-10},{44,-10},{44,206},{98,206}},
      color={0,0,127}));
  connect(hpTowSpe2.y, towFanSpe1.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-30},{44,-30},{44,206},{98,206}},
      color={0,0,127}));
  connect(swi1.y, towFanSpe2.uMaxTowSpeSet[1])
    annotation (Line(points={{-218,-10},{252,-10},{252,206},{318,206}},
      color={0,0,127}));
  connect(hpTowSpe2.y, towFanSpe2.uMaxTowSpeSet[2])
    annotation (Line(points={{-338,-30},{252,-30},{252,206},{318,206}},
      color={0,0,127}));
  connect(not1.y, or4.u1) annotation (Line(points={{-298,120},{-280,120},{-280,-80},
          {-262,-80}}, color={255,0,255}));
  connect(chiSta2.y, or4.u2) annotation (Line(points={{-338,90},{-286,90},{-286,
          -88},{-262,-88}}, color={255,0,255}));
  connect(wseSta.y, or3.u2) annotation (Line(points={{-338,60},{-292,60},{-292,-148},
          {-262,-148}}, color={255,0,255}));
  connect(or4.y, or3.u1) annotation (Line(points={{-238,-80},{-230,-80},{-230,-100},
          {-270,-100},{-270,-140},{-262,-140}}, color={255,0,255}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/ReturnWaterTemperature/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Controller</a>.
</p>
<p>
It shows the calculations of the fan speed setpoint for the three different plants,
including the close coupled plants that have waterside economizer (<code>towFanSpe</code>),
the less coupled plants that have waterside economizer (<code>towFanSpe1</code>),
and the close coupled plants that have no waterside economizer (<code>towFanSpe2</code>).
</p>
<ul>
<li>
For the close and less coupled plants with waterside economizer,
<ul>
<li>
if the plant is not enabled, the tower fan speed setpoint is 0.
</li>
<li>
if the economizer is enabled, the fan speed setpoint equals to the
<code>uTowSpeWSE</code>.
</li>
<li>
in the period when the chiller runs only, the speed setpoint
is minium of the <code>plrTowMaxSpeSet</code>, <code>uMaxTowSpeSet</code>
and the mapped setpoint.
</li>
</ul>
</li>
<li>
For the close coupled plants without waterside economizer,
the setpoint calculation is same as the one with economizer
except there is no economizer enabled period. So when the chiller
is enabled, the setpoint equals to the
<code>plrTowMaxSpeSet</code>, <code>uMaxTowSpeSet</code>
and the mapped setpoint.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,300}})));
end Controller;
