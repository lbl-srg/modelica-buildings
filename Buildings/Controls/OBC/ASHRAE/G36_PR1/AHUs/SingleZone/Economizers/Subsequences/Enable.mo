within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.Economizers.Subsequences;
block Enable
  "Single zone VAV AHU economizer enable/disable switch"

  parameter Boolean use_enthalpy = true
    "Set to true to evaluate outdoor air (OA) enthalpy in addition to temperature"
    annotation(Dialog(group="Conditional"));
  parameter Modelica.SIunits.TemperatureDifference delTOutHis=1
    "Delta between the temperature hysteresis high and low limit"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis"));
  parameter Modelica.SIunits.SpecificEnergy delEntHis=1000
    "Delta between the enthalpy hysteresis high and low limits"
    annotation(Evaluate=true, Dialog(tab="Advanced", group="Hysteresis", enable = use_enthalpy));
  parameter Real retDamPhyPosMax(
    final min=0,
    final max=1,
    final unit="1") = 1
    "Physically fixed maximum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));
  parameter Real retDamPhyPosMin(
    final min=0,
    final max=1,
    final unit="1") = 0
    "Physically fixed minimum position of the return air damper"
    annotation(Evaluate=true, Dialog(tab="Commissioning", group="Physical damper position limits"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-220,250},{-180,290}}),
    iconTransformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-220,170},{-180,210}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-220,210},{-180,250}}),
      iconTransformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
    final unit="J/kg",
    final quantity="SpecificEnergy") if use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-220,130},{-180,170}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMin(
    final unit="1",
    final min=0,
    final max=1)
    "Minimum outdoor air damper position, get from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPosMax(
    final unit="1",
    final min=0,
    final max=1)
    "Maximum outdoor air damper position, get from damper position limits sequence"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan on/off status signal"
    annotation (Placement(transformation(extent={{-220,90},{-180,130}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Zone state status signal"
    annotation (Placement(transformation(extent={{-220,-30},{-180,10}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
    "Freeze protection stage status signal"
    annotation (Placement(transformation(extent={{-220,30},{-180,70}}),
      iconTransformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPosMax(
    final min=0,
    final max=1,
    final unit="1")
    "Maximum outdoor air damper position"
    annotation (Placement(transformation(extent={{180,-150},{200,-130}}),
      iconTransformation(extent={{100,28},{140,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMin(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Minimum return air damper position"
    annotation (Placement(transformation(extent={{180,-250},{200,-230}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPosMax(
    final min=retDamPhyPosMin,
    final max=retDamPhyPosMax,
    final unit="1")
    "Maximum return air damper position"
     annotation (Placement(transformation(
      extent={{180,-220},{200,-200}}), iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Logical.And3 andEnaDis
    "Logical and that checks freeze protection stage and zone state"
     annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    trueHoldDuration=600) "10 min on/off delay"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));

protected
  final parameter Modelica.SIunits.Temperature TOutHigLimCutHig = 0
    "Hysteresis high limit cutoff";
  final parameter Real TOutHigLimCutLow = TOutHigLimCutHig - delTOutHis
    "Hysteresis low limit cutoff";
  final parameter Modelica.SIunits.SpecificEnergy hOutHigLimCutHig = 0
    "Hysteresis block high limit cutoff";
  final parameter Real hOutHigLimCutLow = hOutHigLimCutHig - delEntHis
    "Hysteresis block low limit cutoff";

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant entSubst(
    final k=false) if not use_enthalpy
    "Deactivates outdoor air enthalpy condition if there is no enthalpy sensor"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMinSig(
    final k=retDamPhyPosMin)
    "Physically fixed minimum position of the return air damper"
    annotation (Placement(transformation(extent={{-140,-258},{-120,-238}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant retDamPhyPosMaxSig(
    final k=retDamPhyPosMax)
    "Physically fixed maximum position of the return air damper. This is the initial condition of the return air damper"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutTem(
    final uHigh=TOutHigLimCutHig,
    final uLow=TOutHigLimCutLow)
    "Outdoor air temperature hysteresis for both fixed and differential dry bulb temperature cutoff conditions"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysOutEnt(
    final uLow=hOutHigLimCutLow,
    final uHigh=hOutHigLimCutHig) if use_enthalpy
    "Outdoor air enthalpy hysteresis for both fixed and differential enthalpy cutoff conditions"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k2=-1) if use_enthalpy
    "Add block that determines the difference between hOut and hOutCut"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1(final k2=-1)
    "Add block that determines difference the between TOut and TOutCut"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
  Buildings.Controls.OBC.CDL.Logical.Switch outDamSwitch "Set maximum OA damper position to minimum at disable (after time delay)"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Switch minRetDamSwitch
    "Keep minimum RA damper position at physical maximum for a short time period after disable"
    annotation (Placement(transformation(extent={{40,-250},{60,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Nor nor1 "Logical nor"
    annotation (Placement(transformation(extent={{-40,200},{-20,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not that starts the timer at disable signal "
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and checks supply fan status"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages.stage0)
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates.heating)
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Logical block to check if the freeze protection is deactivated"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Negation for check of freeze protection status"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));

equation
  connect(outDamSwitch.y, yOutDamPosMax)
    annotation (Line(points={{61,-140},{61,-140},{190,-140}}, color={0,0,127}));
  connect(TOut, add1.u1)
    annotation (Line(points={{-200,270},{-160,270},{-160,256},{-142,256}},color={0,0,127}));
  connect(TOutCut, add1.u2)
    annotation (Line(points={{-200,230},{-160,230},{-160,244},{-142,244}},color={0,0,127}));
  connect(add1.y, hysOutTem.u)
    annotation (Line(points={{-119,250},{-102,250}}, color={0,0,127}));
  connect(hOut, add2.u1)
    annotation (Line(points={{-200,190},{-160,190},{-160,176},{-142,176}},color={0,0,127}));
  connect(hOutCut, add2.u2)
    annotation (Line(points={{-200,150},{-160,150},{-160,164},{-142,164}}, color={0,0,127}));
  connect(add2.y, hysOutEnt.u)
    annotation (Line(points={{-119,170},{-102,170}}, color={0,0,127}));
  connect(hysOutTem.y, nor1.u1)
    annotation (Line(points={{-79,250},{-60,250},{-60,210},{-42,210}},
    color={255,0,255}));
  connect(hysOutEnt.y, nor1.u2)
    annotation (Line(points={{-79,170},{-60,170},{-60,202},{-42,202}},  color={255,0,255}));
  connect(entSubst.y, nor1.u2)
    annotation (Line(points={{-79,200},{-60,200},{-60,202},{-42,202}},
    color={255,0,255}));
  connect(uOutDamPosMin, outDamSwitch.u1)
    annotation (Line(points={{-200,-160},{-120,-160},{-60,-160},{-60,-132},{38,-132}},
    color={0,0,127}));
  connect(uOutDamPosMax, outDamSwitch.u3)
    annotation (Line(points={{-200,-130},{-80,-130},{-80,-148},{38,-148}}, color={0,0,127}));
  connect(nor1.y, truFalHol.u)
    annotation (Line(points={{-19,210},{-1,210}}, color={255,0,255}));
  connect(andEnaDis.y, not2.u)
    annotation (Line(points={{61,40},{72,40},{72,-20},{-20,-20},{-20,-60},{-12,-60}},
    color={255,0,255}));
  connect(minRetDamSwitch.y, yRetDamPosMin)
    annotation (Line(points={{61,-240},{100,-240},{146,-240},{190,-240}}, color={0,0,127}));
  connect(truFalHol.y, and1.u1)
    annotation (Line(points={{21,210},{30,210},{30,130},{-10,130},{-10,110},{-2,110}},
    color={255,0,255}));
  connect(and1.y, andEnaDis.u1)
    annotation (Line(points={{21,110},{21,110},{30,110},{30,48},{38,48}}, color={255,0,255}));
  connect(uSupFan, and1.u2)
    annotation (Line(points={{-200,110},{-102,110},{-102,102},{-2,102}}, color={255,0,255}));
  connect(retDamPhyPosMaxSig.y, minRetDamSwitch.u1)
    annotation (Line(points={{-119,-210},{-4,-210},{-4,-232},{38,-232}}, color={0,0,127}));
  connect(retDamPhyPosMinSig.y, minRetDamSwitch.u3)
    annotation (Line(points={{-119,-248},{0,-248},{38,-248}}, color={0,0,127}));
  connect(retDamPhyPosMaxSig.y, yRetDamPosMax)
    annotation (Line(points={{-119,-210},{190,-210}}, color={0,0,127}));
  connect(not2.y, minRetDamSwitch.u2)
    annotation (Line(points={{11,-60},{16,-60},{16,-240},{38,-240}}, color={255,0,255}));
  connect(not2.y, outDamSwitch.u2)
    annotation (Line(points={{11,-60},{28,-60},{28,-140},{38,-140}}, color={255,0,255}));
  connect(conInt.y,intEqu. u2)
    annotation (Line(points={{-99,40},{-92,40},{-92,52},{-82,52}}, color={255,127,0}));
  connect(conInt1.y,intEqu1. u2)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,-8},{-82,-8}}, color={255,127,0}));
  connect(intEqu1.y,not3. u)
    annotation (Line(points={{-59,0},{-46,0}}, color={255,0,255}));
  connect(uZonSta, intEqu1.u1)
    annotation (Line(points={{-200,-10},{-140,-10},{-140,0},{-82,0}}, color={255,127,0}));
  connect(uFreProSta, intEqu.u1)
    annotation (Line(points={{-200,50},{-140,50},{-140,60},{-82,60}}, color={255,127,0}));
  connect(intEqu.y, andEnaDis.u2)
    annotation (Line(points={{-59,60},{-10,60},{-10,40},{38,40}}, color={255,0,255}));
  connect(not3.y, andEnaDis.u3)
    annotation (Line(points={{-23,0},{8,0},{8,32},{38,32}}, color={255,0,255}));
    annotation (
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
          extent={{-170,142},{158,104}},
          lineColor={0,0,127},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-280},{180,280}}), graphics={
        Rectangle(
          extent={{-170,-44},{170,-274}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,16},{172,-36}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-168,76},{172,24}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,136},{170,84}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-170,274},{170,144}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                     Text(
          extent={{102,168},{178,156}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Outdoor air
conditions"),                        Text(
          extent={{100,70},{264,48}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Freeze protection -
disable if stage1
and above"),                         Text(
          extent={{100,-34},{214,-86}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Damper position
limit assignments"),                 Text(
          extent={{102,16},{206,-22}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Zone state -
disable if
heating"),                           Text(
          extent={{100,102},{182,92}},
          lineColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="Supply fan status")}),
    Documentation(info="<html>
<p>
This is a single zone VAV AHU economizer enable/disable sequence
based on ASHRAE G36 PART5.5 and PART5.A.17. Additional
conditions included in the sequence are:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.FreezeProtectionStages</a> (PART5.9),
</li>
<li>
Supply fan status <code>TSupFan</code> (PART5.4.d),
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.ZoneStates</a> (PART5.3.b).
</li>
</ul>
<p>
The economizer is disabled whenever the outdoor air conditions
exceed the economizer high limit setpoint.
This sequence allows for all device types listed in
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
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/AHUs/EconEnableDisableStateMachineChartSingleZone.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
July 06, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Enable;
