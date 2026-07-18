within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZoneControl "Zone temperature setpoint control"

  parameter Real dTShe(min=0,start=1)
    "Temperature setpoint change delta for the load-shed mode (positive value)"
    annotation (Dialog(enable = incSetCha));
  parameter Real dTReb(min=0,start=1)
    "Temperature setpoint change delta for the load-rebound mode (positive value)"
    annotation (Dialog(enable = incSetCha));
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Boolean incSetCha
    "True: the setpoint change step is incremental for the load-shed mode and the load-rebound mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-60},{-200,-20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-120},{-200,-80}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-240,20},{-200,60}}),
      iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaPre(
    final ascSet=airConMod,
    final incSetCha=false)
    "Setpoint change logic for the pre-cool or the pre-heat mode"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaShe(
    final setChaDel=dTShe,
    final ascSet=not airConMod,
    final incSetCha=incSetCha)
    "Setpoint change logic for the load-shed mode"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange setChaReb(
    final setChaDel=dTReb,
    final ascSet=airConMod,
    final incSetCha=incSetCha)
    "Setpoint change logic for the load-rebound mode"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.RealValueSelectionByMode zonSetSelByMod(
    final use_pre=true)
    "Output the corresponding commanded zone temperature setpoint value based on the demand flexibility mode"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiPre
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during pre-cool or pre-heat"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiShe
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-shed"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DoubleSwitch TSetBouSwiReb
    "Switch the maximum and minimum temperature setpoint bounds based on the air conditioning mode during load-rebound"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conAirConMod(
    final k=airConMod)
    "Constant for the air conditioning mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(uEna, setChaPre.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,176},{38,176}},
      color={255,0,255}));
  connect(uEna, setChaShe.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,-24},{38,-24}},
      color={255,0,255}));
  connect(uEna, setChaReb.uEna)
    annotation (Line(points={{-220,160},{-120,160},{-120,-124},{38,-124}},
      color={255,0,255}));
  connect(TCurZonSet, setChaPre.uCurSet)
    annotation (Line(points={{-220,40},{-100,40},{-100,172},{38,172}},
      color={0,0,127}));
  connect(TCurZonSet, setChaShe.uCurSet)
    annotation (Line(points={{-220,40},{-140,40},{-140,-28},{38,-28}},
      color={0,0,127}));
  connect(TCurZonSet, setChaReb.uCurSet)
    annotation (Line(points={{-220,40},{-140,40},{-140,-128},{38,-128}},
      color={0,0,127}));
  connect(zonSetSelByMod.y, TComZonSet)
    annotation (Line(points={{162,0},{220,0}}, color={0,0,127}));
  connect(demFleMod,zonSetSelByMod. demFleMod)
    annotation (Line(points={{-220,100},{120,100},{120,8},{138,8}},
      color={255,127,0}));
  connect(setChaPre.y,zonSetSelByMod. uPre)
    annotation (Line(points={{62,170},{80,170},{80,4},{138,4}}, color={0,0,127}));
  connect(setChaShe.y,zonSetSelByMod. uShe)
    annotation (Line(points={{62,-30},{80,-30},{80,-4},{138,-4}}, color={0,0,127}));
  connect(setChaReb.y,zonSetSelByMod. uReb)
    annotation (Line(points={{62,-130},{120,-130},{120,-8},{138,-8}},
      color={0,0,127}));
  connect(TDefSet,zonSetSelByMod. uDef)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,0},{138,0}},
      color={0,0,127}));
  connect(conAirConMod.y, TSetBouSwiPre.u2)
    annotation (Line(points={{-58,30},{-40,30},{-40,130},{-22,130}},
      color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiShe.u2)
    annotation (Line(points={{-58,30},{-40,30},{-40,-70},{-22,-70}},
      color={255,0,255}));
  connect(conAirConMod.y, TSetBouSwiReb.u2)
    annotation (Line(points={{-58,30},{-40,30},{-40,-170},{-22,-170}},
      color={255,0,255}));
  connect(TSetBouSwiPre.y1, setChaPre.uAllMaxSet)
    annotation (Line(points={{2,135},{20,135},{20,168.2},{38,168.2}},
      color={0,0,127}));
  connect(setChaPre.uAllMinSet, TSetBouSwiPre.y2)
    annotation (Line(points={{38,164},{30,164},{30,125},{2,125}}, color={0,0,127}));
  connect(TSetBouSwiShe.y1, setChaShe.uAllMaxSet)
    annotation (Line(points={{2,-65},{20,-65},{20,-31.8},{38,-31.8}},
      color={0,0,127}));
  connect(setChaShe.uAllMinSet, TSetBouSwiShe.y2)
    annotation (Line(points={{38,-36},{30,-36},{30,-75},{2,-75}}, color={0,0,127}));
  connect(TSetBouSwiReb.y1, setChaReb.uAllMaxSet)
    annotation (Line(points={{2,-165},{20,-165},{20,-131.8},{38,-131.8}},
      color={0,0,127}));
  connect(TSetBouSwiReb.y2, setChaReb.uAllMinSet)
    annotation (Line(points={{2,-175},{30,-175},{30,-136},{38,-136}},
      color={0,0,127}));
  connect(TPreTarSet, TSetBouSwiPre.u1)
    annotation (Line(points={{-220,-40},{-180,-40},{-180,136},{-22,136}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiPre.u3)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,124},{-22,124}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiShe.u1)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-64},{-22,-64}},
      color={0,0,127}));
  connect(TSheTarSet, TSetBouSwiShe.u3)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,-76},{-22,-76}},
      color={0,0,127}));
  connect(TDefSet, TSetBouSwiReb.u1)
    annotation (Line(points={{-220,-100},{-160,-100},{-160,-164},{-22,-164}},
      color={0,0,127}));
  connect(TSheTarSet, TSetBouSwiReb.u3)
    annotation (Line(points={{-220,-160},{-80,-160},{-80,-176},{-22,-176}},
      color={0,0,127}));
  annotation (defaultComponentName="zonCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
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
        extent={{-200,-200},{200,200}},
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
represents the air conditioning mode. <code>airConMod = true</code> represents the
heating mode, whereas <code>airConMod = false</code> represents the cooling mode.
<code>TCurZonSet</code> and <code>TComZonSet</code> must represent heating setpoints
when <code>airConMod = true</code>, and it must represent cooling setpoints when
<code>airConMod = false</code>.
</p>
<p>
The demand flexibility mode <code>demFleMod</code> can take values of <i>0</i>
(pre-cool or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), and
<i>3</i> (load-rebound mode). 
</p>
<p>
This block conducts a setpoint change to output the commanded zone temperature
setpoint <code>TComZonSet</code> as follows if the incremental setpoint change flag
<code>incSetCha = true</code>:
</p>
<table border=\"1\">
<tr>
<th>demFleMod</th>
<th>airConMod</th>
<th>TComZonSet if uEna=true</th>
<th>TComZonSet if uEna=false</th>
</tr>
<tr>
<td>0</td>
<td>true</td>
<td>TPreTarSet</td>
<td>min(TPreTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>0</td>
<td>false</td>
<td>TPreTarSet</td>
<td>min(TDefSet, max(TPreTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>1</td>
<td>true</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>1</td>
<td>false</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>2</td>
<td>true</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet - dTShe))</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>2</td>
<td>false</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet + dTShe))</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>true</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet + dTReb))</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>false</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet - dTReb))</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
</table>
<p>
This block conducts a setpoint change to output the commanded zone
temperature setpoint <code>TComZonSet</code> as follows if the incremental setpoint
change flag <code>incSetCha = false</code>:
</p>
<table border=\"1\">
<tr>
<th>demFleMod</th>
<th>airConMod</th>
<th>TComZonSet if uEna=true</th>
<th>TComZonSet if uEna=false</th>
</tr>
<tr>
<td>0</td>
<td>true</td>
<td>TPreTarSet</td>
<td>min(TPreTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>0</td>
<td>false</td>
<td>TPreTarSet</td>
<td>min(TDefSet, max(TPreTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>1</td>
<td>true</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>1</td>
<td>false</td>
<td>TDefSet</td>
<td>TDefSet</td>
</tr>
<tr>
<td>2</td>
<td>true</td>
<td>TSheTarSet</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>2</td>
<td>false</td>
<td>TSheTarSet</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>true</td>
<td>TDefSet</td>
<td>min(TDefSet, max(TSheTarSet, TCurZonSet))</td>
</tr>
<tr>
<td>3</td>
<td>false</td>
<td>TDefSet</td>
<td>min(TSheTarSet, max(TDefSet, TCurZonSet))</td>
</tr>
</table>
<p>
The input variables <code>TPreTarSet</code>, <code>TDefSet</code>, and
<code>TSheTarSet</code> must take on reasonable values. For example,
<code>TPreTarSet &gt; TDefSet &gt; TSheTarSet</code> must hold if the air
conditioning system is in the heating mode (<code>airConMod = true</code>), and
<code>TPreTarSet &lt; TDefSet &lt; TSheTarSet</code> must hold if the air
conditioning system is in the cooling mode (<code>airConMod = false</code>). 
</p>
<p>
Note that the output <code>TComZonSet</code> is intended to be received by a
downstream temperature setpoint controller, which will process the setpoint change
and pass its new setpoint back to the input <code>TCurZonSet</code>, completing a
full control loop.
</p>
</html>", revisions="<html>
<ul>
<li>
July 15, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end ZoneControl;
