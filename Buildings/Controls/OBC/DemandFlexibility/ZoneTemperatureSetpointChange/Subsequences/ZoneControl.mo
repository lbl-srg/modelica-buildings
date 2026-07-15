within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZoneControl "Zone control"
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna "True: enable setpoint change"
    annotation (
      Placement(transformation(extent={{-240,80},{-200,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TPreTarSet
    "Pre-cool or pre-heat target temperature setpoint"
                                             annotation (Placement(
        transformation(extent={{-240,-40},{-200,0}}),    iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TDefSet
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,-2},{-100,38}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        TSheTarSet
    "Load-shed target temperature setpoint"
                                    annotation (Placement(transformation(extent={{-240,
            -120},{-200,-80}}),        iconTransformation(extent={{-140,-80},{
            -100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Generic.SetpointChange setChaPre(final ascSet=airConMod, final incSetCha=
        false)
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Generic.SetpointChange setChaShe(
    final setChaDel=dTShe,
    final ascSet=not airConMod,
    final incSetCha=incSetCha)
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Generic.SetpointChange setChaReb(
    final setChaDel=dTReb,
    final ascSet=airConMod,
    final incSetCha=incSetCha)
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Generic.RealValueSelectionByMode reaValSelByMod(final use_pre=true)
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  CDL.Reals.Switch swi3
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  CDL.Reals.Switch swi4
    annotation (Placement(transformation(extent={{-40,-160},{-20,-140}})));
  CDL.Reals.Switch swi5
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));
protected
  CDL.Logical.Sources.Constant conAirConMod(final k=airConMod)
    "Constant for air conditioning mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(uEna, setChaPre.uEna) annotation (Line(points={{-220,100},{-180,100},
          {-180,156},{38,156}}, color={255,0,255}));
  connect(uEna, setChaShe.uEna) annotation (Line(points={{-220,100},{-119,100},
          {-119,-24},{38,-24}}, color={255,0,255}));
  connect(uEna, setChaReb.uEna) annotation (Line(points={{-220,100},{-119,100},
          {-119,-124},{38,-124}}, color={255,0,255}));
  connect(TCurZonSet, setChaPre.uCurSet) annotation (Line(points={{-220,20},{
          -100,20},{-100,152},{38,152}}, color={0,0,127}));
  connect(TCurZonSet, setChaShe.uCurSet) annotation (Line(points={{-220,20},{
          -140,20},{-140,-28},{38,-28}}, color={0,0,127}));
  connect(TCurZonSet, setChaReb.uCurSet) annotation (Line(points={{-220,20},{
          -140,20},{-140,-128},{38,-128}}, color={0,0,127}));
  connect(reaValSelByMod.y, TComZonSet)
    annotation (Line(points={{162,0},{220,0}}, color={0,0,127}));
  connect(demFleMod, reaValSelByMod.demFleMod) annotation (Line(points={{-220,
          60},{120,60},{120,8},{138,8}}, color={255,127,0}));
  connect(setChaPre.y, reaValSelByMod.uPre) annotation (Line(points={{62,150},{
          80,150},{80,4},{138,4}}, color={0,0,127}));
  connect(setChaShe.y, reaValSelByMod.uShe) annotation (Line(points={{62,-30},{
          80,-30},{80,-4},{138,-4}}, color={0,0,127}));
  connect(setChaReb.y, reaValSelByMod.uReb) annotation (Line(points={{62,-130},
          {120,-130},{120,-8},{138,-8}}, color={0,0,127}));
  connect(TDefSet, reaValSelByMod.uDef) annotation (Line(points={{-220,-60},{
          -160,-60},{-160,0},{138,0}}, color={0,0,127}));
  connect(conAirConMod.y, swi.u2) annotation (Line(points={{-58,30},{-50,30},{
          -50,130},{-42,130}}, color={255,0,255}));
  connect(conAirConMod.y, swi1.u2) annotation (Line(points={{-58,30},{-20,30},{
          -20,90},{-2,90}}, color={255,0,255}));
  connect(swi.y, setChaPre.uAllMaxSet) annotation (Line(points={{-18,130},{0,
          130},{0,148.2},{38,148.2}}, color={0,0,127}));
  connect(swi1.y, setChaPre.uAllMinSet) annotation (Line(points={{22,90},{30,90},
          {30,144},{38,144}}, color={0,0,127}));
  connect(swi2.y, setChaShe.uAllMaxSet) annotation (Line(points={{-18,-50},{0,
          -50},{0,-31.8},{38,-31.8}}, color={0,0,127}));
  connect(swi3.y, setChaShe.uAllMinSet) annotation (Line(points={{22,-90},{30,
          -90},{30,-36},{38,-36}}, color={0,0,127}));
  connect(swi4.y, setChaReb.uAllMaxSet) annotation (Line(points={{-18,-150},{0,
          -150},{0,-131.8},{38,-131.8}}, color={0,0,127}));
  connect(swi5.y, setChaReb.uAllMinSet) annotation (Line(points={{22,-190},{30,
          -190},{30,-136},{38,-136}}, color={0,0,127}));
  connect(conAirConMod.y, swi2.u2) annotation (Line(points={{-58,30},{-50,30},{
          -50,-50},{-42,-50}}, color={255,0,255}));
  connect(conAirConMod.y, swi3.u2) annotation (Line(points={{-58,30},{-50,30},{
          -50,-90},{-2,-90}}, color={255,0,255}));
  connect(conAirConMod.y, swi4.u2) annotation (Line(points={{-58,30},{-50,30},{
          -50,-150},{-42,-150}}, color={255,0,255}));
  connect(conAirConMod.y, swi5.u2) annotation (Line(points={{-58,30},{-50,30},{
          -50,-190},{-2,-190}}, color={255,0,255}));
  connect(TPreTarSet, swi.u1) annotation (Line(points={{-220,-20},{-170,-20},{
          -170,138},{-42,138}}, color={0,0,127}));
  connect(TDefSet, swi1.u1) annotation (Line(points={{-220,-60},{-160,-60},{
          -160,98},{-2,98}}, color={0,0,127}));
  connect(TPreTarSet, swi1.u3) annotation (Line(points={{-220,-20},{-170,-20},{
          -170,82},{-2,82}}, color={0,0,127}));
  connect(TDefSet, swi.u3) annotation (Line(points={{-220,-60},{-160,-60},{-160,
          122},{-42,122}}, color={0,0,127}));
  annotation (defaultComponentName="zonCon",
    Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}),                                  graphics={Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Text(
      extent={{-100,140},{100,100}},
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
</html>"));
end ZoneControl;
