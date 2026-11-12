within Buildings.Controls.OBC.DemandFlexibility.FanSpeedLimiting.Subsequences;
block Adjustment "Adjustment"

  parameter Real delFanSpeLimShe(
    min=0,
    start=0.5,
    unit="1")
    "Fan speed limit change amount for the load-shed mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real delFanSpeLimReb(
    min=0,
    start=0.5,
    unit="1")
    "Fan speed limit change amount for the load-rebound mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Boolean use_mulSteSetCha
    "If true, there are multiple smaller and incremental setpoint change steps for the load-shed mode and the load-rebound mode; if false, there is a single setpoint change step";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "True: enable setpoint change" annotation (Placement(transformation(extent={
            {-140,60},{-100,100}}), iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimCur(
    unit="1")
    "Current fan speed limit" annotation (Placement(transformation(extent={{
            -140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput fanSpeLimCom(
    unit="1")
    "Commanded fan speed limit" annotation (Placement(transformation(extent={{100,-20},
            {140,20}}),         iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimDef(
    unit="1")
    "Default fan speed limit" annotation (Placement(transformation(extent={{
            -140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput fanSpeLimTarShe(
    unit="1")
    "Target fan speed limit for the load-shed mode" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaShe(
    final setChaDel=delFanSpeLimShe,
    final ascSet=false,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-shed mode"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaReb(
    final setChaDel=delFanSpeLimReb,
    final ascSet=true,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-rebound mode"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode fanSpeLimSelByMod(
    final use_pre=false)
    "Output the corresponding commanded zone temperature setpoint value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Reals.Greater greFanSpeLimDef
    "Check if the target fan speed limit for the load-shed mode is greater than the default fan speed limit"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreFanSpeLimDef
    "Check if the target fan speed limit for the load-shed mode is no greater than the default fan speed limit"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesFanSpeLimDef(message="Error: the target fan speed limit for the load-shed mode must be less than or equal to the default fan speed limit.")
    "Error message for the default fan speed limit"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
equation
  connect(fanSpeLimDef, fanSpeLimSelByMod.uDef) annotation (Line(points={{-120,-40},
          {-40,-40},{-40,0},{58,0}}, color={0,0,127}));
  connect(uEna, setChaShe.uEna) annotation (Line(points={{-120,80},{-80,80},{-80,
          76},{-2,76}}, color={255,0,255}));
  connect(uEna, setChaReb.uEna) annotation (Line(points={{-120,80},{-80,80},{-80,
          -44},{-2,-44}}, color={255,0,255}));
  connect(fanSpeLimSelByMod.y, fanSpeLimCom)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(setChaShe.y, fanSpeLimSelByMod.uShe) annotation (Line(points={{22,70},
          {40,70},{40,-4},{58,-4}}, color={0,0,127}));
  connect(setChaReb.y, fanSpeLimSelByMod.uReb) annotation (Line(points={{22,-50},
          {40,-50},{40,-8},{58,-8}}, color={0,0,127}));
  connect(demFleMod, fanSpeLimSelByMod.demFleMod) annotation (Line(points={{-120,
          40},{20,40},{20,8},{58,8}}, color={255,127,0}));
  connect(fanSpeLimCur, setChaShe.uCurSet) annotation (Line(points={{-120,0},{-60,
          0},{-60,72},{-2,72}}, color={0,0,127}));
  connect(fanSpeLimCur, setChaReb.uCurSet) annotation (Line(points={{-120,0},{-60,
          0},{-60,-48},{-2,-48}}, color={0,0,127}));
  connect(fanSpeLimDef, setChaReb.uAllMaxSet) annotation (Line(points={{-120,-40},
          {-40,-40},{-40,-51.8},{-2,-51.8}}, color={0,0,127}));
  connect(fanSpeLimDef, setChaShe.uAllMaxSet) annotation (Line(points={{-120,-40},
          {-40,-40},{-40,68.2},{-2,68.2}}, color={0,0,127}));
  connect(fanSpeLimTarShe, setChaReb.uAllMinSet) annotation (Line(points={{-120,
          -80},{-30,-80},{-30,-56},{-2,-56}}, color={0,0,127}));
  connect(fanSpeLimTarShe, setChaShe.uAllMinSet) annotation (Line(points={{-120,
          -80},{-30,-80},{-30,64},{-2,64}}, color={0,0,127}));
  connect(greFanSpeLimDef.y, notGreFanSpeLimDef.u)
    annotation (Line(points={{2,-110},{18,-110}}, color={255,0,255}));
  connect(notGreFanSpeLimDef.y, assMesFanSpeLimDef.u)
    annotation (Line(points={{42,-110},{58,-110}}, color={255,0,255}));
  connect(fanSpeLimTarShe, greFanSpeLimDef.u1) annotation (Line(points={{-120,-80},
          {-30,-80},{-30,-110},{-22,-110}}, color={0,0,127}));
  connect(fanSpeLimDef, greFanSpeLimDef.u2) annotation (Line(points={{-120,-40},
          {-40,-40},{-40,-118},{-22,-118}}, color={0,0,127}));
  annotation (defaultComponentName="adj",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2},
        extent={{-100,-140},{100,120}})),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block changes the fan speed limit based on the
change enabling signal input and the demand flexibility mode.
</p>
<p>
The input <code>fanSpeLimCur</code> represents the current value of the
fan speed limit and the output <code>fanSpeLimCom</code> is the
commanded fan speed limit.
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>1</i> (default mode),
<i>2</i> (load-shed mode), or <i>3</i> (load-rebound mode).
</p>
<p>
This block conducts a fan speed limit change to output the commanded fan speed limit
<code>fanSpeLimCom</code> as follows if the multiple-step setpoint change flag
<code>use_mulSteSetCha = true</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>fanSpeLimCom if uEna=true</th>
<th>fanSpeLimCom if uEna=false</th>
</tr>
<tr>
<tr>
<td>1</td>
<td>fanSpeLimDef</td>
<td>fanSpeLimDef</td>
</tr>
<tr>
<td>2</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur - delFanSpeLimShe))</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur))</td>
</tr>
<tr>
<td>3</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur + delFanSpeLimReb))</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur))</td>
</tr>
</table>
<p>
This block conducts a fan speed limit change to output the commanded fan speed limit
<code>fanSpeLimCom</code> as follows if the multiple-step setpoint change flag
<code>use_mulSteSetCha = false</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>fanSpeLimCom if uEna=true</th>
<th>fanSpeLimCom if uEna=false</th>
</tr>
<tr>
<td>1</td>
<td>fanSpeLimDef</td>
<td>fanSpeLimDef</td>
</tr>
<tr>
<td>2</td>
<td>fanSpeLimTarShe</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur))</td>
</tr>
<tr>
<td>3</td>
<td>fanSpeLimDef</td>
<td>min(fanSpeLimDef, max(fanSpeLimTarShe, fanSpeLimCur))</td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
<code>fanSpeLimDef &gt;= fanSpeLimTarShe</code> must hold.
</li>
<li>
The output <code>fanSpeLimCom</code> is intended to be received by a
downstream fan controller, which will process the fan speed limit change
and pass its new fan speed limit back to the input <code>fanSpeLimCur</code>, completing a
full control loop.
</li>
<li>
Within each demand flexibility mode, the changes of both
<code>fanSpeLimCur</code> and <code>fanSpeLimCom</code> will occur in only one direction:
either increasing or decreasing. The direction can only change when the
demand flexibility mode changes.
</li>
</ul>
</html>"));
end Adjustment;
