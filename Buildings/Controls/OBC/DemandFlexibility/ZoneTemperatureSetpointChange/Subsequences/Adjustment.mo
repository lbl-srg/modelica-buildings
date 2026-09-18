within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block Adjustment "Zone setpoint adjustment"

  parameter Real dTShe(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-shed mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Real dTReb(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-rebound mode (positive value)"
    annotation (Dialog(enable = use_mulSteSetCha));
  parameter Boolean use_mulSteSetCha
    "If true, there are multiple smaller and incremental setpoint change steps for the load-shed mode and the load-rebound mode; if false, there is a single setpoint change step";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-180},{-200,-140}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna
    "True: enable setpoint change"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Less lesTPreTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the pre-heat target temperature setpoint is less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSheTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the load-shed target temperature setpoint is greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesTPreTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the pre-heat target temperature setpoint is no less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-140},{40,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreTSheTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the load-shed target temperature setpoint is no greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTPreTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the pre-cool target temperature setpoint is greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSheTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the load-shed target temperature setpoint is less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-260},{-20,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreTPreTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the pre-cool target temperature setpoint is no greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-220},{40,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesTSheTarSet
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the load-shed target temperature setpoint is no less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-260},{40,-240}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarHeaSet(
    message="Error: the pre-heat target temperature setpoint must be greater than or equal to the default temperature setpoint during the heating mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the pre-heat target temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarHeaSet(
    message="Error: the load-shed target temperature setpoint must be less than or equal to the default temperature setpoint during the heating mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the load-shed target heating temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{80,-180},{100,-160}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarCooSet(
    message="Error: the pre-cool target temperature setpoint must be less than or equal to the default temperature setpoint during the cooling mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the pre-cool target temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarCooSet(
    message="Error: the load-shed target temperature setpoint must be greater than or equal to the default temperature setpoint during the cooling mode.")
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the load-shed target cooling temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{80,-260},{100,-240}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaPre(
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    final use_mulSteSetCha=false)
    "Setpoint change logic for the pre-cool or the pre-heat mode"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaShe(
    final setChaDel=dTShe,
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-shed mode"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaReb(
    final setChaDel=dTReb,
    final ascSet=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating,
    final use_mulSteSetCha=use_mulSteSetCha)
    "Setpoint change logic for the load-rebound mode"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode zonSetSelByMod(
    final use_pre=true)
    "Output the corresponding commanded zone temperature setpoint value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiPre
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during pre-cool or pre-heat"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiShe
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-shed"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiReb
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-rebound"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAirConMod(
    final k=airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating)
    "Constant for the air conditioning mode; true for heating, false for cooling"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
equation
  connect(uEna, setChaPre.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,256},{38,256}},
      color={255,0,255}));
  connect(uEna, setChaShe.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,56},{38,56}},
      color={255,0,255}));
  connect(uEna, setChaReb.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,-44},{38,-44}},
      color={255,0,255}));
  connect(TCurZonSet, setChaPre.uCurSet)
    annotation (Line(points={{-220,40},{-100,40},{-100,252},{38,252}},
      color={0,0,127}));
  connect(TCurZonSet, setChaShe.uCurSet)
    annotation (Line(points={{-220,40},{-140,40},{-140,52},{38,52}},
      color={0,0,127}));
  connect(TCurZonSet, setChaReb.uCurSet)
    annotation (Line(points={{-220,40},{-140,40},{-140,-48},{38,-48}},
      color={0,0,127}));
  connect(zonSetSelByMod.y, TComZonSet)
    annotation (Line(points={{162,80},{192,80},{192,0},{220,0}}, color={0,0,127}));
  connect(demFleMod,zonSetSelByMod. demFleMod)
    annotation (Line(points={{-220,100},{120,100},{120,88},{138,88}},
      color={255,127,0}));
  connect(setChaPre.y,zonSetSelByMod. uPre)
    annotation (Line(points={{62,250},{80,250},{80,84},{138,84}}, color={0,0,127}));
  connect(setChaShe.y,zonSetSelByMod. uShe)
    annotation (Line(points={{62,50},{80,50},{80,76},{138,76}}, color={0,0,127}));
  connect(setChaReb.y,zonSetSelByMod. uReb)
    annotation (Line(points={{62,-50},{120,-50},{120,72},{138,72}},
      color={0,0,127}));
  connect(TDefSet,zonSetSelByMod. uDef)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,80},{138,80}},
      color={0,0,127}));
  connect(conAirConMod.y, TSetBouSwiPre.u2)
    annotation (Line(points={{-58,150},{-40,150},{-40,210},{-22,210}},
      color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiShe.u2)
    annotation (Line(points={{-58,150},{-40,150},{-40,10},{-22,10}},
      color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiReb.u2)
    annotation (Line(points={{-58,150},{-40,150},{-40,-90},{-22,-90}},
      color={255,0,255}));
  connect(TSetBouSwiPre.y1, setChaPre.uAllMaxSet)
    annotation (Line(points={{2,215},{20,215},{20,248.2},{38,248.2}},
      color={0,0,127}));
  connect(setChaPre.uAllMinSet, TSetBouSwiPre.y2)
    annotation (Line(points={{38,244},{30,244},{30,205},{2,205}}, color={0,0,127}));
  connect(TSetBouSwiShe.y1, setChaShe.uAllMaxSet)
    annotation (Line(points={{2,15},{20,15},{20,48.2},{38,48.2}},
      color={0,0,127}));
  connect(setChaShe.uAllMinSet, TSetBouSwiShe.y2)
    annotation (Line(points={{38,44},{30,44},{30,5},{2,5}}, color={0,0,127}));
  connect(TSetBouSwiReb.y1, setChaReb.uAllMaxSet)
    annotation (Line(points={{2,-85},{20,-85},{20,-51.8},{38,-51.8}},
      color={0,0,127}));
  connect(TSetBouSwiReb.y2, setChaReb.uAllMinSet)
    annotation (Line(points={{2,-95},{30,-95},{30,-56},{38,-56}},
      color={0,0,127}));
  connect(TPreTarSet, TSetBouSwiPre.u1)
    annotation (Line(points={{-220,-40},{-180,-40},{-180,216},{-22,216}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiPre.u3)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,204},{-22,204}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiShe.u1)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,16},{-22,16}},
      color={0,0,127}));
  connect(TSheTarSet, TSetBouSwiShe.u3)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,4},{-22,4}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiReb.u1)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-84},{-22,-84}},
      color={0,0,127}));
  connect(TSheTarSet, TSetBouSwiReb.u3)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,-96},{-22,-96}},
      color={0,0,127}));
  connect(TPreTarSet, lesTPreTarSet.u1)
    annotation (Line(points={{-220,-40},{-180,-40},{-180,-130},{-42,-130}},
      color={0,0,127}));
  connect(TDefSet, lesTPreTarSet.u2)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-138},{-42,-138}},
      color={0,0,127}));
  connect(lesTPreTarSet.y, notLesTPreTarSet.u)
    annotation (Line(points={{-18,-130},{18,-130}}, color={255,0,255}));
  connect(greTSheTarSet.y, notGreTSheTarSet.u)
    annotation (Line(points={{-18,-170},{18,-170}}, color={255,0,255}));
  connect(lesTSheTarSet.y, notLesTSheTarSet.u)
    annotation (Line(points={{-18,-250},{18,-250}}, color={255,0,255}));
  connect(TPreTarSet, greTPreTarSet.u1)
    annotation (Line(points={{-220,-40},{-180,-40},{-180,-210},{-42,-210}},
      color={0,0,127}));
  connect(TDefSet, greTPreTarSet.u2)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-218},{-42,-218}},
      color={0,0,127}));
  connect(greTPreTarSet.y, notGreTPreTarSet.u)
    annotation (Line(points={{-18,-210},{18,-210}}, color={255,0,255}));
  connect(notLesTPreTarSet.y, assMesTPreTarHeaSet.u)
    annotation (Line(points={{42,-130},{78,-130}}, color={255,0,255}));
  connect(notGreTSheTarSet.y, assMesTSheTarHeaSet.u)
    annotation (Line(points={{42,-170},{78,-170}}, color={255,0,255}));
  connect(notGreTPreTarSet.y, assMesTPreTarCooSet.u)
    annotation (Line(points={{42,-210},{78,-210}}, color={255,0,255}));
  connect(notLesTSheTarSet.y, assMesTSheTarCooSet.u)
    annotation (Line(points={{42,-250},{78,-250}}, color={255,0,255}));
  connect(TDefSet, greTSheTarSet.u2)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-178},{-42,-178}},
      color={0,0,127}));
  connect(TDefSet, lesTSheTarSet.u2)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-258},{-42,-258}},
      color={0,0,127}));
  connect(TSheTarSet, greTSheTarSet.u1)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,-170},{-42,-170}},
      color={0,0,127}));
  connect(TSheTarSet, lesTSheTarSet.u1)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,-250},{-42,-250}},
      color={0,0,127}));
  annotation (defaultComponentName="zonSetAdj",
    Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{100,120}},
        grid={2,2}), graphics={Rectangle(
          extent={{-100,-120},{100,120}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Text(
      extent={{-100,160},{100,120}},
      textColor={0,0,255},
      textString="%name")}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-200,-280},{200,280}},
        grid={2,2})),
    Documentation(info="<html>
<p>
This block serves to change a single temperature setpoint based on the setpoint
change enabling signal input and the demand flexibility mode.
</p>
<p>
The input variable <code>TCurZonSet</code> represents the current value of the
temperature setpoint. The output variable <code>TComZonSet</code> commands the
temperature setpoint to take on a new value. The parameter <code>airConMod</code>
represents the air conditioning mode. <code>airConMod = Heating</code> represents the
heating mode, whereas <code>airConMod = Cooling</code> represents the cooling mode.
<code>TCurZonSet</code> and <code>TComZonSet</code> must represent heating setpoints
when <code>airConMod = Heating</code>, and they must represent cooling setpoints when
<code>airConMod = Cooling</code>.
</p>
<p>
The demand flexibility mode <code>demFleMod</code> can take values of <i>0</i>
(pre-cool or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), and
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
The input variables <code>TPreTarSet</code>, <code>TDefSet</code>, and
<code>TSheTarSet</code> must take on specific sets of values. For example,
<code>TPreTarSet &gt;= TDefSet &gt;= TSheTarSet</code> must hold if the air
conditioning system is in the heating mode (<code>airConMod = Heating</code>), and
<code>TPreTarSet &lt;= TDefSet &lt;= TSheTarSet</code> must hold if the air
conditioning system is in the cooling mode (<code>airConMod = Cooling</code>). 
</p>
<p>
Note that the output <code>TComZonSet</code> is intended to be received by a
downstream temperature setpoint controller, which will process the setpoint change
and pass its new setpoint back to the input <code>TCurZonSet</code>, completing a
full control loop.
</p>
<p>
Also note that within each demand flexibility mode, the changes in setpoint values of
<code>TCurZonSet</code> and <code>TComZonSet</code> will have only one direction:
either increasing or decreasing. The setpoint values change direction only when the
demand flexibility mode is changed.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Adjustment;
