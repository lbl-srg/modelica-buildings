within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointReset.Subsequences;
block Adjustment "Adjustment"

  parameter Real dTChiSetShe(
    min=0,
    start=0.5,
    final unit="K",
    displayUnit="K")
    "Chilled water temperature setpoint change amount for the load-shed mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real dTChiSetReb(
    min=0,
    start=0.5,
    final unit="K",
    displayUnit="K")
    "Chilled water temperature setpoint change amount for the load-rebound mode (positive value)"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetCur(
    final unit="K",
    displayUnit="degC")
    "Current chilled water temperature setpoint" annotation (Placement(transformation(extent={{
            -140,-20},{-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TChiSetCom(
    final unit="K",
    displayUnit="degC") "Commanded chilled water temperature setpoint"
                                                   annotation (Placement(transformation(extent={{100,-20},
            {140,20}}),         iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetDef(
    final unit="K",
    displayUnit="degC")
    "Default chilled water temperature setpoint" annotation (Placement(transformation(extent={{
            -140,-60},{-100,-20}}), iconTransformation(extent={{-140,-60},{-100,
            -20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiSetTarShe(
    final unit="K",
    displayUnit="degC")
    "Target chilled water temperature setpoint for the load-shed mode" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaShe(
    final setChaDel=dTChiSetShe,
    final ascSet=true,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-shed mode"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaReb(
    final setChaDel=dTChiSetReb,
    final ascSet=false,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-rebound mode"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode TChiSetSelByMod(
    final use_pre=false)
    "Output the corresponding commanded chilled water temperature setpoint value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Reals.Less lesTChiSetDef
    "Check if the target chilled water temperature setpoint during the load-shed mode is less than the default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesTChiSetDef
    "Check if the target chilled water temperature setpoint during the load-shed mode is no less than the default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTChiSetDef(message="Error: the target chilled water temperature setpoint during the load-shed mode must be greater than or equal to the default chilled water temperature setpoint.")
    "Error message for the default chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
equation
  connect(TChiSetDef, TChiSetSelByMod.uDef) annotation (Line(points={{-120,-40},
          {-30,-40},{-30,0},{58,0}}, color={0,0,127}));
  connect(uEna, setChaShe.uEna) annotation (Line(points={{-120,80},{-80,80},{-80,
          76},{-2,76}}, color={255,0,255}));
  connect(uEna, setChaReb.uEna) annotation (Line(points={{-120,80},{-80,80},{-80,
          -44},{-2,-44}}, color={255,0,255}));
  connect(TChiSetSelByMod.y, TChiSetCom)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(setChaShe.y, TChiSetSelByMod.uShe) annotation (Line(points={{22,70},
          {40,70},{40,-4},{58,-4}}, color={0,0,127}));
  connect(setChaReb.y, TChiSetSelByMod.uReb) annotation (Line(points={{22,-50},
          {40,-50},{40,-8},{58,-8}}, color={0,0,127}));
  connect(demFleMod, TChiSetSelByMod.demFleMod) annotation (Line(points={{-120,
          40},{20,40},{20,8},{58,8}}, color={255,127,0}));
  connect(TChiSetCur, setChaShe.uCurSet) annotation (Line(points={{-120,0},{-60,
          0},{-60,72},{-2,72}}, color={0,0,127}));
  connect(TChiSetCur, setChaReb.uCurSet) annotation (Line(points={{-120,0},{-60,
          0},{-60,-48},{-2,-48}}, color={0,0,127}));
  connect(lesTChiSetDef.y, notLesTChiSetDef.u)
    annotation (Line(points={{2,-110},{18,-110}}, color={255,0,255}));
  connect(notLesTChiSetDef.y, assMesTChiSetDef.u)
    annotation (Line(points={{42,-110},{58,-110}}, color={255,0,255}));
  connect(TChiSetDef, setChaReb.uAllMinSet) annotation (Line(points={{-120,-40},
          {-30,-40},{-30,-56},{-2,-56}}, color={0,0,127}));
  connect(TChiSetDef, setChaShe.uAllMinSet) annotation (Line(points={{-120,-40},
          {-30,-40},{-30,64},{-2,64}}, color={0,0,127}));
  connect(TChiSetTarShe, setChaShe.uAllMaxSet) annotation (Line(points={{-120,-80},
          {-40,-80},{-40,68.2},{-2,68.2}}, color={0,0,127}));
  connect(TChiSetTarShe, setChaReb.uAllMaxSet) annotation (Line(points={{-120,-80},
          {-40,-80},{-40,-51.8},{-2,-51.8}}, color={0,0,127}));
  connect(TChiSetTarShe, lesTChiSetDef.u1) annotation (Line(points={{-120,-80},{
          -40,-80},{-40,-110},{-22,-110}}, color={0,0,127}));
  connect(TChiSetDef, lesTChiSetDef.u2) annotation (Line(points={{-120,-40},{-30,
          -40},{-30,-118},{-22,-118}}, color={0,0,127}));
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
October 27, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block changes the chilled water temperature setpoint based on the
change enabling signal input and the demand flexibility mode.
</p>
<p>
The input <code>TChiSetCur</code> represents the current value of the
chilled water temperature setpoint and the output <code>TChiSetCom</code> is the
commanded chilled water temperature setpoint.
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>1</i> (default mode),
<i>2</i> (load-shed mode), or <i>3</i> (load-rebound mode).
</p>
<p>
This block conducts a chilled water setpoint change to output the commanded chilled water temperature
setpoint <code>TChiSetCom</code> as follows if the multiple-step setpoint change flag
<code>use_mulSteSetCha = true</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>TChiSetCom if uEna=true</th>
<th>TChiSetCom if uEna=false</th>
</tr>
<tr>
<tr>
<td>1</td>
<td>TChiSetDef</td>
<td>TChiSetDef</td>
</tr>
<tr>
<td>2</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur + dTChiSetShe))</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur))</td>
</tr>
<tr>
<td>3</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur - dTChiSetReb))</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur))</td>
</tr>
</table>
<p>
This block conducts a chilled water setpoint change to output the commanded chilled water temperature
setpoint <code>TChiSetCom</code> as follows if the multiple-step setpoint change flag
<code>use_mulSteSetCha = false</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>TChiSetCom if uEna=true</th>
<th>TChiSetCom if uEna=false</th>
</tr>
<tr>
<td>1</td>
<td>TChiSetDef</td>
<td>TChiSetDef</td>
</tr>
<tr>
<td>2</td>
<td>TChiSetTarShe</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur))</td>
</tr>
<tr>
<td>3</td>
<td>TChiSetDef</td>
<td>min(TChiSetTarShe, max(TChiSetDef, TChiSetCur))</td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
<code>TChiSetDef &lt;= TChiSetTarShe</code> must hold.
</li>
<li>
The output <code>TChiSetCom</code> is intended to be received by a
downstream temperature setpoint controller, which will process the setpoint change
and pass its new setpoint back to the input <code>TChiSetCur</code>, completing a
full control loop.
</li>
<li>
Within each demand flexibility mode, the changes of both
<code>TChiSetCur</code> and <code>TChiSetCom</code> will occur in only one direction:
either increasing or decreasing. The direction can only change when the
demand flexibility mode changes.
</li>
</ul>
</html>"));
end Adjustment;
