within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block Adjustment "Zone setpoint adjustment"

  parameter Real dTPre(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Setpoint change delta for the pre-cool or the pre-heat mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real dTShe(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Setpoint change delta for the load-shed mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real dTReb(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Setpoint change delta for the load-rebound mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real TPreTarSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Pre-cool or pre-heat target temperature setpoint";
  parameter Real TDefSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Default temperature setpoint";
  parameter Real TSheTarSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Load-shed target temperature setpoint";
  parameter Boolean use_mulSteSetCha
    "If true, there are multiple smaller and incremental setpoint change steps for the pre-cool/pre-heat mode, the load-shed mode, and the load-rebound mode; if false, there is a single setpoint change step";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conTDefSet(k=TDefSet)
    "Constant for the default temperature setpoint" annotation (Placement(
        transformation(extent={{-180,-30},{-160,-10}}),
                                                      iconTransformation(extent
          ={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Commanded zone temperature setpoint"
    annotation (Placement(transformation(extent={{200,-120},{240,-80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=TPreTarSet >= TDefSet) if airConMod ==
    Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check whether the pre-heat target temperature setpoint is greater than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{120,140},{140,160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(k=TSheTarSet <= TDefSet) if airConMod ==
    Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check whether the load-shed target temperature setpoint is less than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(k=TPreTarSet <= TDefSet) if airConMod ==
    Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check whether the pre-cool target temperature setpoint is less than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3(k=TSheTarSet >= TDefSet) if airConMod ==
    Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check whether the load-shed target temperature setpoint is greater than or equal to the default tempearture setpoint"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
protected
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarHeaSet(
    message="Error: the pre-heat target temperature setpoint must be greater than or equal to the default temperature setpoint during the heating mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the pre-heat target temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{160,140},{180,160}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarHeaSet(
    message="Error: the load-shed target temperature setpoint must be less than or equal to the default temperature setpoint during the heating mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the load-shed target heating temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarCooSet(
    message="Error: the pre-cool target temperature setpoint must be less than or equal to the default temperature setpoint during the cooling mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the pre-cool target temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{160,60},{180,80}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarCooSet(
    message="Error: the load-shed target temperature setpoint must be greater than or equal to the default temperature setpoint during the cooling mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the load-shed target cooling temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{160,20},{180,40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaPre(
    final setChaDel=dTPre,
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the pre-cool or the pre-heat mode"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaShe(
    final setChaDel=dTShe,
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-shed mode"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaReb(
    final setChaDel=dTReb,
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-rebound mode"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode zonSetSelByMod(
    final use_pre=true)
    "Output the corresponding commanded zone temperature setpoint value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiPre(u1=
        TPreTarSet, u2=TDefSet)
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during pre-cool or pre-heat"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiShe(u1=
        TDefSet, u2=TSheTarSet)
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-shed"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiReb(u1=
        TDefSet, u2=TSheTarSet)
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-rebound"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAirConMod(
    final k=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating)
    "Constant for the air conditioning mode; true for heating, false for cooling"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
equation
  connect(uEna, setChaPre.uEna)
    annotation (Line(points={{-220,60},{-120,60},{-120,116},{38,116}},
      color={255,0,255}));
  connect(uEna, setChaShe.uEna)
    annotation (Line(points={{-220,60},{-120,60},{-120,-44},{38,-44}},
      color={255,0,255}));
  connect(uEna, setChaReb.uEna)
    annotation (Line(points={{-220,60},{-120,60},{-120,-104},{38,-104}},
      color={255,0,255}));
  connect(TCurZonSet, setChaPre.uCurSet) annotation (Line(points={{-220,-60},{-100,
          -60},{-100,112},{38,112}},color={0,0,127}));
  connect(TCurZonSet, setChaShe.uCurSet) annotation (Line(points={{-220,-60},{-140,
          -60},{-140,-48},{38,-48}},
                                  color={0,0,127}));
  connect(TCurZonSet, setChaReb.uCurSet) annotation (Line(points={{-220,-60},{-140,
          -60},{-140,-108},{38,-108}},
                                    color={0,0,127}));
  connect(zonSetSelByMod.y, TComZonSet)
    annotation (Line(points={{162,-20},{192,-20},{192,-100},{220,-100}},
                                                                 color={0,0,127}));
  connect(demFleMod,zonSetSelByMod. demFleMod)
    annotation (Line(points={{-220,0},{120,0},{120,-12},{138,-12}},
      color={255,127,0}));
  connect(setChaPre.y,zonSetSelByMod. uPre)
    annotation (Line(points={{62,110},{80,110},{80,-16},{138,-16}},
                                                                  color={0,0,127}));
  connect(setChaShe.y,zonSetSelByMod. uShe)
    annotation (Line(points={{62,-50},{80,-50},{80,-24},{138,-24}},
                                                                color={0,0,127}));
  connect(setChaReb.y,zonSetSelByMod. uReb)
    annotation (Line(points={{62,-110},{120,-110},{120,-28},{138,-28}},
      color={0,0,127}));
  connect(conAirConMod.y, TSetBouSwiPre.u) annotation (Line(points={{-58,50},{-40,
          50},{-40,70},{-22,70}},        color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiShe.u) annotation (Line(points={{-58,50},{-40,
          50},{-40,-90},{-22,-90}},    color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiReb.u) annotation (Line(points={{-58,50},{-40,
          50},{-40,-150},{-22,-150}},    color={255,0,255}));
  connect(TSetBouSwiPre.y1, setChaPre.uAllMaxSet)
    annotation (Line(points={{2,75},{20,75},{20,108.2},{38,108.2}},
      color={0,0,127}));
  connect(setChaPre.uAllMinSet, TSetBouSwiPre.y2)
    annotation (Line(points={{38,104},{30,104},{30,65},{2,65}},   color={0,0,127}));
  connect(TSetBouSwiShe.y1, setChaShe.uAllMaxSet)
    annotation (Line(points={{2,-85},{20,-85},{20,-51.8},{38,-51.8}},
      color={0,0,127}));
  connect(setChaShe.uAllMinSet, TSetBouSwiShe.y2)
    annotation (Line(points={{38,-56},{30,-56},{30,-95},{2,-95}},
                                                            color={0,0,127}));
  connect(TSetBouSwiReb.y1, setChaReb.uAllMaxSet)
    annotation (Line(points={{2,-145},{20,-145},{20,-111.8},{38,-111.8}},
      color={0,0,127}));
  connect(TSetBouSwiReb.y2, setChaReb.uAllMinSet)
    annotation (Line(points={{2,-155},{30,-155},{30,-116},{38,-116}},
      color={0,0,127}));
  connect(con.y, assMesTPreTarHeaSet.u)
    annotation (Line(points={{142,150},{158,150}}, color={255,0,255}));
  connect(con1.y, assMesTSheTarHeaSet.u)
    annotation (Line(points={{142,110},{158,110}}, color={255,0,255}));
  connect(con2.y, assMesTPreTarCooSet.u) annotation (Line(points={{142,70},{158,
          70}},                       color={255,0,255}));
  connect(con3.y, assMesTSheTarCooSet.u)
    annotation (Line(points={{142,30},{158,30}},   color={255,0,255}));
  connect(conTDefSet.y, zonSetSelByMod.uDef)
    annotation (Line(points={{-158,-20},{138,-20}},
                                                  color={0,0,127}));
  annotation (defaultComponentName="zonSetAdj",
    Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Text(
      extent={{-100,160},{100,120}},
      textColor={0,0,255},
      textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-200,-180},{200,180}},
        grid={2,2})),
    Documentation(info="<html>
<p>
This block changes a single temperature setpoint based on the
change enabling signal input and the demand flexibility mode.
</p>
<p>
The input <code>TCurZonSet</code> represents the current value of the
temperature setpoint and the output <code>TComZonSet</code> is the
new temperature setpoint.
If the sequence is used for the heating mode (<code>airConMod = Heating</code>), the
<code>TCurZonSet</code> and <code>TComZonSet</code> must be the heating setpoints.
If the sequence is used for the cooling mode (<code>airConMod = Cooling</code>), the
<code>TCurZonSet</code> and <code>TComZonSet</code> must be the cooling setpoints.
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>0</i>
(pre-cool or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), or
<i>3</i> (load-rebound mode).
</p>
<p>
This block conducts a setpoint change to output the commanded zone temperature
setpoint <code>TComZonSet</code> as follows if the multiple-step setpoint change flag
<code>use_mulSteSetCha = true</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>airConMod</th>
<th>TComZonSet if uEna=true</th>
<th>TComZonSet if uEna=false</th>
</tr>
<tr>
<td>0</td>
<td>Heating</td>
<td>min(TPreTarSet, max(TDefSet, TCurZonSet+dTPre))</td>
<td>min(TPreTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>0</td>
<td>Cooling</td>
<td>min(TDefSet, max(TPreTarSet, TCurZonSet-dTPre))</td>
<td>min(TDefSet, max(TPreTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>1</td>
<td>Heating</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>1</td>
<td>Cooling</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>2</td>
<td>Heating</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet - dTShe))</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>2</td>
<td>Cooling</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet + dTShe))</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>Heating</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet + dTReb))</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>Cooling</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet - dTReb))</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
</table>
<p>
This block conducts a setpoint change to output the commanded zone
temperature setpoint <code>TComZonSet</code> as follows if the multiple-step
setpoint change flag <code>use_mulSteSetCha = false</code>:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>airConMod</th>
<th>TComZonSet if uEna=true</th>
<th>TComZonSet if uEna=false</th>
</tr>
<tr>
<td>0</td>
<td>Heating</td>
<td>TPreTarSet</td>
<td>min(TPreTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>0</td>
<td>Cooling</td>
<td>TPreTarSet</td>
<td>min(TDefSet, max(TPreTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>1</td>
<td>Heating</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>1</td>
<td>Cooling</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>2</td>
<td>Heating</td>
<td>TSheTarSet</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>2</td>
<td>Cooling</td>
<td>TSheTarSet</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>Heating</td>
<td>TDefSet</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>Cooling</td>
<td>TDefSet</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li>
<code>TPreTarSet &gt;= TDefSet &gt;= TSheTarSet</code> must hold if the air
conditioning system is in the heating mode (<code>airConMod = Heating</code>), and
<code>TPreTarSet &lt;= TDefSet &lt;= TSheTarSet</code> must hold if the air
conditioning system is in the cooling mode (<code>airConMod = Cooling</code>).
</li>
<li>
The output <code>TComZonSet</code> is intended to be received by a
downstream temperature setpoint controller, which will process the setpoint change
and pass its new setpoint back to the input <code>TCurZonSet</code>, completing a
full control loop.
</li>
<li>
Within each demand flexibility mode, the changes of both
<code>TCurZonSet</code> and <code>TComZonSet</code> will occur in only one direction:
either increasing or decreasing. The direction can only change when the
demand flexibility mode changes.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Adjustment;
