within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model OnOff
  "Controlls if the Safety constraints for on-time, off-time, and cycle rate"
  extends BaseClasses.PartialSafety;
  parameter Boolean use_minOnTime=true
    "=false to ignore minimum on-time constraint"
    annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minOnTime(displayUnit="min")
    "Minimum on-time"
    annotation (Dialog(enable=use_minOnTime));
  parameter Boolean use_minOffTime=true
    "=false to ignore minimum off time constraint"
    annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.Time minOffTime(displayUnit="min")
    "Minimum off time"
     annotation (Dialog(enable=use_minOffTime));
  parameter Boolean use_maxCycRat=true
    "=false to ignore maximal cycle rate constraint"
    annotation(choices(checkBox=true));
  parameter Integer maxCycRat "Maximum cycle rate"
    annotation (Dialog(enable=use_maxCycRat));
  parameter Boolean onOffMea_start=true
    "Start value for the on-off signal of the device, true for on";
  parameter Real ySet_small
    "Threshold for relative speed for the device to be considered on";
  parameter Real ySetRed=ySet_small
    "Reduced relative compressor speed to allow longer on-time";
  Modelica.Blocks.Logical.Hysteresis ySetOn(
    final pre_y_start=onOffMea_start,
    final uHigh=ySet_small,
    final uLow=ySet_small/2) "=true if device is set on"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Routing.BooleanPassThrough isAblToTurOff(
    y(start=true, fixed=true))
    "=true if the device is allowed to turn off, else false"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Logical.Pre preOnOff(final pre_u_start=onOffMea_start)
    "On off signal of previous time step"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.CycleRateBoundary
    cycRatBou(final maxCycRat=maxCycRat, final delTim=3600) if use_maxCycRat
    "Check cycle rate violations"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.OnPastThreshold locTimCtr(
   final minOnTime=minOffTime) if use_minOffTime
    "Check if device should be locked"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Logical.Not notIsOn "=true if device is off"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.OnPastThreshold runTimCtr(
      final minOnTime=minOnTime) if use_minOnTime "Check if device needs to run"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Modelica.Blocks.Logical.And andIsAblToTurOn(
    y(start=true, fixed=true))
    "=false to lock the device off"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));

  Modelica.Blocks.Sources.BooleanConstant booConstCycRat(final k=true)
    if not use_maxCycRat "Constant value for disabled option"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Modelica.Blocks.Sources.BooleanConstant booConstLocTim(final k=true)
    if not use_minOffTime "Constant value for disabled option"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.BooleanConstant booConstRunTim(final k=true)
    if not use_minOnTime "Constant value for disabled option"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Logical.Not notSetOn "Device is not set to turn on"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.Blocks.Logical.And andTurOff
    "Check if device is on and is set to be turned off"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Logical.And andTurOn
    "Check if device is off and is set to be turned on"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Modelica.Blocks.Logical.And andStaOn
    "=true if the device is on and wants to stay on"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.And andStaOff
    "=true if the device is off and wants to stay off"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  BaseClasses.OnOffFuzzyLogic onOffFuzLog(ySetRed=ySetRed)
    "Fuzzy logic to device for output"
    annotation (Placement(transformation(extent={{74,-20},{114,20}})));
equation
  connect(preOnOff.y, cycRatBou.u) annotation (Line(points={{-79,-90},{-66,-90},{-66,
          -50},{-2,-50}},                     color={255,0,255}));
  connect(preOnOff.y, notIsOn.u) annotation (Line(points={{-79,-90},{-66,-90},{-66,
          -66},{-108,-66},{-108,-50},{-102,-50}},     color={255,0,255}));
  connect(notIsOn.y, locTimCtr.u) annotation (Line(points={{-79,-50},{-52,-50},{-52,
          -30},{-48,-30},{-48,-4},{-8,-4},{-8,20},{-2,20}},
                                color={255,0,255}));
  connect(runTimCtr.u, preOnOff.y) annotation (Line(points={{-2,100},{-66,100},{
          -66,-90},{-79,-90}}, color={255,0,255}));
  connect(locTimCtr.y, andIsAblToTurOn.u1) annotation (Line(
      points={{21,20},{26,20},{26,-10},{36,-10},{36,-60},{48,-60}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(cycRatBou.y, andIsAblToTurOn.u2) annotation (Line(
      points={{21,-50},{30,-50},{30,-68},{48,-68}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(booConstCycRat.y, andIsAblToTurOn.u2) annotation (Line(
      points={{21,-90},{32,-90},{32,-68},{48,-68}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(ySetOn.y, notSetOn.u) annotation (Line(points={{-79,70},{-74,70},{-74,
          52},{-110,52},{-110,28},{-102,28}},
                         color={255,0,255}));
  connect(notSetOn.y, andTurOff.u2) annotation (Line(points={{-79,28},{-70,28},{
          -70,2},{-42,2}},    color={255,0,255}));
  connect(preOnOff.y, andTurOff.u1) annotation (Line(points={{-79,-90},{-66,-90},
          {-66,10},{-42,10}},                   color={255,0,255}));
  connect(ySetOn.y, andTurOn.u2) annotation (Line(points={{-79,70},{-74,70},{-74,
          -98},{-42,-98}},                       color={255,0,255}));
  connect(notIsOn.y, andTurOn.u1) annotation (Line(points={{-79,-50},{-52,-50},{
          -52,-90},{-42,-90}},                      color={255,0,255}));
  connect(booConstLocTim.y, andIsAblToTurOn.u1) annotation (Line(
      points={{21,-10},{36,-10},{36,-60},{48,-60}},
      color={255,0,255},
      pattern=LinePattern.Dash));

  connect(preOnOff.u, sigBus.onOffMea) annotation (Line(points={{-102,-90},{
          -108,-90},{-108,-61},{-119,-61}},
                                       color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ySetOn.u, ySet) annotation (Line(points={{-102,70},{-114,70},{-114,0},
          {-136,0}},  color={0,0,127}));
  connect(andStaOn.u1, ySetOn.y) annotation (Line(points={{-42,50},{-58,50},{-58,
          52},{-74,52},{-74,70},{-79,70}},
                         color={255,0,255}));
  connect(andStaOn.u2, preOnOff.y) annotation (Line(points={{-42,42},{-66,42},{-66,
          -90},{-79,-90}},                   color={255,0,255}));
  connect(andStaOff.u1, notIsOn.y) annotation (Line(points={{-42,-30},{-52,-30},
          {-52,-50},{-79,-50}}, color={255,0,255}));
  connect(andStaOff.u2, notSetOn.y) annotation (Line(points={{-42,-38},{-70,-38},
          {-70,28},{-79,28}}, color={255,0,255}));
  connect(isAblToTurOff.u, runTimCtr.y) annotation (Line(points={{38,90},{28,90},
          {28,100},{21,100}}, color={255,0,255}));
  connect(booConstRunTim.y, isAblToTurOff.u) annotation (Line(points={{21,70},{28,
          70},{28,90},{38,90}}, color={255,0,255}));
  connect(onOffFuzLog.yOut, yOut)
    annotation (Line(points={{116,0},{130,0}},   color={0,0,127}));
  connect(onOffFuzLog.ySet, ySet) annotation (Line(points={{70.8,0},{56,0},{56,
          36},{-58,36},{-58,6},{-114,6},{-114,0},{-136,0}},
                                        color={0,0,127}));
  connect(onOffFuzLog.staOff, andStaOff.y) annotation (Line(points={{70.8,-6},{
          36,-6},{36,-30},{-19,-30}},
                                   color={255,0,255}));
  connect(onOffFuzLog.staOn, andStaOn.y) annotation (Line(points={{70.8,12},{42,
          12},{42,50},{-19,50}},
                             color={255,0,255}));
  connect(onOffFuzLog.isAblToTurOff, isAblToTurOff.y) annotation (Line(points={{70.8,18},
          {64,18},{64,90},{61,90}},     color={255,0,255}));
  connect(andIsAblToTurOn.y, onOffFuzLog.isAblToTurOn) annotation (Line(points={{71,-60},
          {80,-60},{80,-40},{54,-40},{54,-18},{70.8,-18}},  color={255,0,255}));
  connect(onOffFuzLog.turOff, andTurOff.y) annotation (Line(points={{70.8,6},{
          32,6},{32,40},{-12,40},{-12,10},{-19,10}},
                                                   color={255,0,255}));
  connect(onOffFuzLog.turOn, andTurOn.y) annotation (Line(points={{70.8,-12},{
          34,-12},{34,-70},{-6,-70},{-6,-90},{-19,-90}},
                                                   color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
  Checks if the <code>ySet</code> value is legal by checking if
  the device can either be turned on or off,
  depending on which state it was in. </p>
<p>The output <code>yOut</code> equals <code>ySet</code>, if the device</p>
<ul>
<li>
  is on and <code>ySet</code> is greater
  than <code>ySet_small</code></li>
<li>
  or is off and <code>ySet</code> is 0
</li>
<li>
  or is on and should turn off,
  and exceeds the minimal on-time (if active)</li>
<li>
  or is off and should turn on, and does neither
  exceed the maximal cycle rate (if active)
  nor violates the minimal off-time (if active).
</li>
</ul>
<p>
  If the device is on and should turn off, but does not exceed
  the minimal on-time (if active), <code>yOut</code>
  equals <code>min(ySet, ySetMin)</code>.
</p>
<p>
  If the device is off and should turn on, but exceeds the maximal
  cycle rate (if active) or violates the minimal
  off-time (if active), <code>yOut</code> equals 0.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})));
end OnOff;
