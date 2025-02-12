within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences;
block MappingWithoutWSE
  "Equipment setpoints when chiller head pressure control is enabled, for plants without waterside economizer"
  parameter Boolean have_fixSpeConWatPum = true
    "Flag: true=fixed speed condenser water pumps, false=variable speed condenser water pumps";
  parameter Real minTowSpe = 0.1
    "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe = 0.1 "Minimum condenser water pump speed"
    annotation (Dialog(enable=not have_fixSpeConWatPum));
  parameter Real minHeaPreValPos = 0.1 "Minimum head pressure control valve position"
    annotation (Dialog(enable=have_fixSpeConWatPum));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon(
    final min=0,
    final max=1,
    final unit="1")
    "Chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-200,70},{-160,110}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput desConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final unit="1",
    final min=0,
    final max=1) "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{160,10},{200,50}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final unit="1",
    final min=0,
    final max=1) if have_fixSpeConWatPum
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{160,-60},{200,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    final unit="1",
    final min=0,
    final max=1) if not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{160,-120},{200,-80}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Line maxCooTowSpeSet
    "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hpTowMaxSpe(
    final k=minTowSpe)
    "Minimum allowable tower speed"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Line lin
    "Head pressure control valve position, or condenser water pump speed"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal1(final k=0.5)
    "Constant value"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpeVal(
    final k=1) if have_fixSpeConWatPum "Fully open valve position"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one2(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minValPos(
    final k=minHeaPreValPos) if have_fixSpeConWatPum
    "Minimum head pressure control valve position"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch the setpoint to 0 if the head pressure control loop is disabled"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minPumSpe(
    final k=minConWatPumSpe) if not have_fixSpeConWatPum
    "Minimum condenser water pump speed"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch the setpoint to 0 if the head pressure control loop is disabled"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
equation
  connect(zer.y, maxCooTowSpeSet.x1)
    annotation (Line(points={{-18,120},{40,120},{40,98},{58,98}}, color={0,0,127}));
  connect(one.y, maxCooTowSpeSet.f1)
    annotation (Line(points={{-98,120},{-80,120},{-80,94},{58,94}}, color={0,0,127}));
  connect(hal.y, maxCooTowSpeSet.x2)
    annotation (Line(points={{-38,50},{-20,50},{-20,86},{58,86}}, color={0,0,127}));
  connect(hpTowMaxSpe.y, maxCooTowSpeSet.f2)
    annotation (Line(points={{22,50},{40,50},{40,82},{58,82}},color={0,0,127}));
  connect(uHeaPreCon, maxCooTowSpeSet.u)
    annotation (Line(points={{-180,90},{58,90}}, color={0,0,127}));
  connect(hal1.y, lin.x1)
    annotation (Line(points={{22,0},{40,0},{40,-32},{58,-32}}, color={0,0,127}));
  connect(fulOpeVal.y, lin.f1)
    annotation (Line(points={{-38,0},{-20,0},{-20,-36},{58,-36}}, color={0,0,127}));
  connect(minValPos.y, lin.f2)
    annotation (Line(points={{22,-70},{40,-70},{40,-48},{58,-48}},
      color={0,0,127}));
  connect(one2.y, lin.x2)
    annotation (Line(points={{-98,-70},{-80,-70},{-80,-44},{58,-44}},
      color={0,0,127}));
  connect(uHeaPreCon, lin.u)
    annotation (Line(points={{-180,90},{-100,90},{-100,-40},{58,-40}},
      color={0,0,127}));
  connect(uHeaPreEna, swi.u2)
    annotation (Line(points={{-180,-100},{118,-100}}, color={255,0,255}));
  connect(lin.y, swi.u1)
    annotation (Line(points={{82,-40},{100,-40},{100,-92},{118,-92}}, color={0,0,127}));
  connect(swi.y, yConWatPumSpeSet)
    annotation (Line(points={{142,-100},{180,-100}}, color={0,0,127}));
  connect(desConWatPumSpe, lin.f1)
    annotation (Line(points={{-180,10},{-140,10},{-140,-36},{58,-36}},
      color={0,0,127}));
  connect(minPumSpe.y, lin.f2)
    annotation (Line(points={{-38,-70},{-20,-70},{-20,-48},{58,-48}},
      color={0,0,127}));
  connect(swi.y, yHeaPreConVal)
    annotation (Line(points={{142,-100},{150,-100},{150,-40},{180,-40}}, color={0,0,127}));
  connect(uHeaPreEna, swi1.u2)
    annotation (Line(points={{-180,-100},{90,-100},{90,30},{118,30}},
      color={255,0,255}));
  connect(maxCooTowSpeSet.y, swi1.u1)
    annotation (Line(points={{82,90},{100,90},{100,38},{118,38}},
      color={0,0,127}));
  connect(swi1.y, yMaxTowSpeSet)
    annotation (Line(points={{142,30},{180,30}},  color={0,0,127}));
  connect(zero.y, swi.u3) annotation (Line(points={{22,-130},{110,-130},{110,-108},
          {118,-108}}, color={0,0,127}));
  connect(zero.y, swi1.u3) annotation (Line(points={{22,-130},{110,-130},{110,22},
          {118,22}}, color={0,0,127}));
annotation (
  defaultComponentName= "heaPreConEqu",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                    graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Line(points={{-70,60},{-70,-54},{70,-54},{70,58}}, color={28,108,200}),
        Line(
          points={{-70,36},{-2,36},{70,-34}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-70,36},{-2,-30}},
          color={28,108,200},
          thickness=0.5),
        Polygon(
          points={{-70,60},{-72,56},{-68,56},{-70,60}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{70,60},{68,56},{72,56},{70,60}},
          lineColor={28,108,200},
          lineThickness=0.5,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,-54},{-2,52}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-160},{160,160}})),
  Documentation(info="<html>
<p>
Block that resets maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>,
controls head pressure control valve position <code>yHeaPreConVal</code> or 
condenser water pump speed <code>yConWatPumSpeSet</code>
for plants without water side economizers. The development follows
ASHRAE Guideline36-2021, 
section 5.20.10 Head pressure control, part 5.20.10.3, part 5.20.10.4 and 5.20.10.7.
</p>
<p>
1. For each chiller, map chiller head pressure control loop signal 
<code>uHeaPreCon</code> as follows:
</p>
<ul>
<li>
When <code>uHeaPreCon</code> changes from 0 to 50%, reset maximum cooling tower
speed setpoint <code>yMaxTowSpeSet</code> from 100% to minimum speed 
<code>minTowSpe</code>.
</li>
<li>
If the plant has fixed speed condenser water pumps (<code>have_fixSpeConWatPum</code>=true), then: 
when <code>uHeaPreCon</code> changes from 50% to 100%, reset head pressure control
valve position <code>yHeaPreConVal</code> from 100% open to 
<code>minHeaPreValPos</code>.
</li>
<li>
If the plant has variable speed condenser water pumps (<code>have_fixSpeConWatPum</code>=false), then: 
when <code>uHeaPreCon</code> changes from 50% to 100%, reset condenser water pump 
speed <code>yConWatPumSpeSet</code> from design speed for the stage <code>desConWatPumSpe</code> to 
minimum speed <code>minConWatPumSpe</code>. When the pumps are dedicated, speed
reset shall be independent for each chiller.
</li>
</ul>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/HeadControlValve_noWSE.png\"
     alt=\"HeadControlValve_noWSE.png\" />
</p>

<p>
2. When the head pressure control loop is disabled (<code>uHeaPreEna</code> = false), 
the head pressure control valve shall be closed, or the pump should be disabled; the
maximum tower speed setpoint becomes 0. 
</p>
</html>",
revisions="<html>
<ul>
<li>
January 30, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end MappingWithoutWSE;
