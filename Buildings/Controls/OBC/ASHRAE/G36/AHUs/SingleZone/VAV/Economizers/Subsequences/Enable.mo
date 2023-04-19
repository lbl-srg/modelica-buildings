within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Economizers.Subsequences;
block Enable
  "Single zone VAV AHU economizer enable/disable switch"

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air (OA) enthalpy in addition to temperature"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Conditional"));
  parameter Real delTOutHys(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real delEntHys(
    final unit="J/kg",
    final quantity="SpecificEnergy")=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Real retDamPhy_max(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhy_min(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation (__cdl(ValueInReference=false),
                Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,250},{-180,290}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temperature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Zone state status signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam_max(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position, get from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam_min(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum outdoor air damper position, get from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDam_max(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-160},{220,-120}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam_max(
    final min=retDamPhy_min,
    final max=retDamPhy_max,
    final unit="1")
    "Maximum return air damper position"
    annotation (Placement(transformation(extent={{180,-230},{220,-190}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDam_min(
    final min=retDamPhy_min,
    final max=retDamPhy_max,
    final unit="1")
    "Minimum return air damper position"
    annotation (Placement(transformation(extent={{180,-260},{220,-220}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andEnaDis
    "Logical and that checks freeze protection stage and zone state"
     annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{120,210},{140,230}})));

protected
  final parameter Real TOutHigLimCutHig(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference") = 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHys
    "Hysteresis low limit cutoff";
  final parameter Real hOutHigLimCutHig(
    final unit="J/kg",
    final quantity="SpecificEnergy") = 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHys
    "Hysteresis block low limit cutoff";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant entSubst(
    final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-60,190},{-40,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyMin(
    final k=retDamPhy_min)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-140,-258},{-120,-238}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyMax(
    final k=retDamPhy_max)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutTem(
    final uHigh=TOutHigLimCutHig,
    final uLow=TOutHigLimCutLow)
    "Outdoor air temperature hysteresis for fixed or differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutEnt(
    final uLow=hOutHigLimCutLow,
    final uHigh=hOutHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for fixed or differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2 if use_enthalpy
    "Add block that determines the difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Add block that determines difference the between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch maxOutDam
    "Set maximum OA damper position to minimum at disable (after time delay)"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch minRetDam
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical not that starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and checks supply fan status"
    annotation (Placement(transformation(extent={{4,100},{24,120}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages.stage0)
    "Freeze protection stage 0"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.heating)
    "Heating zone state"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Negation for check of freeze protection status"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if either the temperature or the enthalpy condition is satisfied"
    annotation (Placement(transformation(extent={{40,210},{60,230}})));

equation
  connect(maxOutDam.y, yOutDam_max)
    annotation (Line(points={{62,-140},{200,-140}}, color={0,0,127}));
  connect(TOut, sub1.u1)
    annotation (Line(points={{-200,270},{-160,270},{-160,256},{-142,256}},color={0,0,127}));
  connect(TCut, sub1.u2) annotation (Line(points={{-200,230},{-160,230},{-160,244},
          {-142,244}}, color={0,0,127}));
  connect(sub1.y, hysOutTem.u)
    annotation (Line(points={{-118,250},{-102,250}}, color={0,0,127}));
  connect(hOut, sub2.u1)
    annotation (Line(points={{-200,190},{-160,190},{-160,176},{-142,176}},color={0,0,127}));
  connect(hCut, sub2.u2) annotation (Line(points={{-200,150},{-160,150},{-160,164},
          {-142,164}}, color={0,0,127}));
  connect(sub2.y, hysOutEnt.u)
    annotation (Line(points={{-118,170},{-102,170}}, color={0,0,127}));
  connect(uOutDam_min, maxOutDam.u1) annotation (Line(points={{-200,-160},{-60,-160},
          {-60,-132},{38,-132}}, color={0,0,127}));
  connect(uOutDam_max, maxOutDam.u3) annotation (Line(points={{-200,-130},{-80,-130},
          {-80,-148},{38,-148}}, color={0,0,127}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{62,40},{72,40},{72,-20},{-20,-20},{-20,-60},{-12,-60}},
        color={255,0,255}));
  connect(minRetDam.y, yRetDam_min)
    annotation (Line(points={{62,-240},{200,-240}}, color={0,0,127}));
  connect(truFalHol.y, and1.u1)
    annotation (Line(points={{142,220},{164,220},{164,130},{-26,130},{-26,110},{2,110}},
        color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{26,110},{30,110},{30,48},{38,48}}, color={255,0,255}));
  connect(u1SupFan, and1.u2) annotation (Line(points={{-200,110},{-102,110},{-102,
          102},{2,102}}, color={255,0,255}));
  connect(retDamPhyMax.y, minRetDam.u1) annotation (Line(points={{-118,-210},
          {-4,-210},{-4,-232},{38,-232}}, color={0,0,127}));
  connect(retDamPhyMin.y, minRetDam.u3)
    annotation (Line(points={{-118,-248},{38,-248}}, color={0,0,127}));
  connect(retDamPhyMax.y, yRetDam_max)
    annotation (Line(points={{-118,-210},{200,-210}}, color={0,0,127}));
  connect(not2.y, minRetDam.u2) annotation (Line(points={{12,-60},{16,-60},{16,-240},
          {38,-240}}, color={255,0,255}));
  connect(not2.y, maxOutDam.u2) annotation (Line(points={{12,-60},{28,-60},{28,-140},
          {38,-140}}, color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-98,40},{-92,40},{-92,52},{-82,52}}, color={255,127,0}));
  connect(conInt1.y,intEqu1. u2)
    annotation (Line(points={{-98,-20},{-90,-20},{-90,-8},{-82,-8}}, color={255,127,0}));
  connect(intEqu1.y,not3. u)
    annotation (Line(points={{-58,0},{-46,0}}, color={255,0,255}));
  connect(uZonSta, intEqu1.u1)
    annotation (Line(points={{-200,0},{-82,0}}, color={255,127,0}));
  connect(uFreProSta, intEqu.u1)
    annotation (Line(points={{-200,60},{-82,60}}, color={255,127,0}));
  connect(intEqu.y, andEnaDis.u2)
    annotation (Line(points={{-58,60},{-10,60},{-10,40},{38,40}}, color={255,0,255}));
  connect(not3.y, andEnaDis.u3)
    annotation (Line(points={{-22,0},{8,0},{8,32},{38,32}}, color={255,0,255}));
  connect(hysOutTem.y, or2.u1)
    annotation (Line(points={{-78,250},{-20,250},{-20,220},{38,220}},
                                                  color={255,0,255}));
  connect(hysOutEnt.y, or2.u2) annotation (Line(points={{-78,170},{0,170},{0,212},
          {38,212}}, color={255,0,255}));
  connect(entSubst.y, or2.u2) annotation (Line(points={{-38,200},{0,200},{0,212},
          {38,212}}, color={255,0,255}));
  connect(or2.y, truFalHol.u) annotation (Line(points={{62,220},{118,220}},
                      color={255,0,255}));
annotation (
  defaultComponentName = "enaDis",
  Icon(graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,60},{80,60}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-76,-60},{0,-60},{0,60}},
          color={0,0,127},
          thickness=0.5),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-280},{180,280}}), graphics={
        Rectangle(
          extent={{-170,-44},{170,-274}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,16},{170,-36}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,76},{170,24}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,136},{170,84}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,274},{172,144}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{96,176},{148,156}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Outdoor air
conditions"),                        Text(
          extent={{100,70},{264,48}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection -
disable if stage1
and above"),                         Text(
          extent={{100,-46},{166,-80}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments"),                 Text(
          extent={{102,16},{206,-22}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state -
disable if
heating"),                           Text(
          extent={{100,102},{182,92}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
    Documentation(info="<html>
<p>
This is a single zone VAV AHU economizer enable/disable sequence
based on Section 5.18.7 and Section 5.1.17 of ASHRAE Guideline 36, May 2020. Additional
conditions included in the sequence are:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeProtectionStages</a>,
</li>
<li>
Supply fan status <code>u1SupFan</code>,
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates</a>.
</li>
</ul>
<p>
The economizer is disabled whenever the outdoor air conditions
exceed the economizer high limit cutoff setpoint plus the hysteresis low limit parameter
(<code>TOutHigLimCutLow</code> or <code>hOutHigLimCutLow</code>) as shown in the figure.
And the economizer is enabled whenever the outdoor air conditions are below the economizer
high limit cutoff setpoint plus the hysteresis high limit parameter (<code>TOutHigLimCutHig</code> or 
<code>hOutHigLimCutHig</code>). This sequence allows for all device types listed in
ASHRAE 90.1-2013 and Title 24-2013.
</p>
<p>
In addition, the economizer is disabled without a delay whenever any of the
following is <code>true</code>:
</p>
<ul>
<li>supply fan is off,
</li>
<li>
zone state is <code>heating</code>,
</li>
<li>
freeze protection stage is not <code>0</code>.
</li>
</ul>
<p>
The following state machine chart illustrates the transitions between enabling and disabling:
</p>
<p align=\"center\">
<img alt=\"Image of economizer enable-disable state machine chart\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/Economizers/Subsequences/Enable.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
August 1, 2020, by Jianjun Hu:<br/>
Updated according to ASHRAE G36, May 2020.
</li>
<li>
July 30, 2019, by Kun Zhang:<br/>
Added the option to allow fixed plus differential dry bulb temperature cutoff.
</li>
<li>
July 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable;
