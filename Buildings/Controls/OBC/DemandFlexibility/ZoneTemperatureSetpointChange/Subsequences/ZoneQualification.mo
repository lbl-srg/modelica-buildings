within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZoneQualification "Zone qualification"

  parameter Real dTSheThr(min=0)
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)";
  parameter Real dTSheHys(min=0)
    "Hysteresis for the temperature difference during the load-shed mode";
  parameter Real PBuiHys(min=0,start=1)
    "Hysteresis for the electricity demand of the building"
    annotation (Dialog(enable = use_demCon));
  parameter Real TResInt(min=0)
    "Temperature resolution interval used by an external zone temperature controller";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Boolean use_demCon
    "True: use demand-based control";
  parameter Integer nZon(min=1)
    "Number of zones in the building";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon] "Zone temperature"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.BooleanOutput disFla[nZon]
    "Flags to disqualify certain zones from zone temperature comparison; true to disqualify a zone"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Interfaces.RealInput TZonSet[nZon]
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
                                                   annotation (Placement(
        transformation(extent={{-220,-60},{-180,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.BooleanInput rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-220,140},{-180,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  CDL.Interfaces.RealInput TPreTarSet[nZon]
    "Pre-cool or pre-heat target temperature setpoint" annotation (Placement(
        transformation(extent={{-220,-220},{-180,-180}}),iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput TSheTarSet[nZon]
    "Load-shed target temperature setpoint" annotation (Placement(
        transformation(extent={{-220,-300},{-180,-260}}), iconTransformation(
          extent={{-140,-180},{-100,-140}})));
  CDL.Interfaces.RealInput TDefSet[nZon] "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-220,-260},{-180,-220}}),
        iconTransformation(extent={{-140,-142},{-100,-102}})));
  CDL.Interfaces.RealInput PBuiThr if use_demCon
    "Threshold for the electricity demand of the building"        annotation (
      Placement(transformation(extent={{-220,60},{-180,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput PBui if use_demCon "Electricity demand of the building"
                                                               annotation (
      Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  CDL.Logical.Or or1[nZon]
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  CDL.Logical.Or or2[nZon]
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  CDL.Logical.Or or3[nZon]
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  CDL.Reals.Greater gre(h=PBuiHys) if use_demCon
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Logical.Not not1 if use_demCon
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  CDL.Logical.And and2 if use_demCon
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  CDL.Routing.BooleanScalarReplicator booScaRep(nout=nZon) if use_demCon
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  CDL.Logical.Sources.Constant con[nZon](k=fill(true, nZon)) if not use_demCon
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  CDL.Reals.Subtract                        dTZon[nZon] "Zone temperature difference"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  CDL.Reals.LessThreshold lesThr[nZon](final t=fill(dTSheThr, nZon), final h=
        fill(dTSheHys, nZon))
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Logical.Not not2[nZon]
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Logical.And and1[nZon]
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nZon)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  CDL.Reals.MultiplyByParameter gai[nZon](final k=fill(1, nZon)) if airConMod
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  CDL.Reals.MultiplyByParameter gai1[nZon](final k=fill(-1, nZon)) if not airConMod
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  CDL.Reals.Greater gre1[nZon](h=0.1*TResInt)
                               if airConMod
    annotation (Placement(transformation(extent={{46,-66},{66,-46}})));
  CDL.Reals.Less les1[nZon](h=0.1*TResInt)
                            if not airConMod
    annotation (Placement(transformation(extent={{46,-106},{66,-86}})));
  CDL.Reals.Less les2[nZon](h=0.1*TResInt)
                            if airConMod
    annotation (Placement(transformation(extent={{48,-154},{68,-134}})));
  CDL.Reals.Greater gre2[nZon](h=0.1*TResInt)
                               if not airConMod
    annotation (Placement(transformation(extent={{46,-188},{66,-168}})));
  CDL.Reals.Greater gre3[nZon](h=0.1*TResInt)
                               if airConMod
    annotation (Placement(transformation(extent={{48,-236},{68,-216}})));
  CDL.Reals.Less les3[nZon](h=0.1*TResInt)
                            if not airConMod
    annotation (Placement(transformation(extent={{48,-268},{68,-248}})));
  CDL.Reals.AddParameter addParPre1[nZon](p=-0.99*TResInt) if airConMod
    annotation (Placement(transformation(extent={{-8,-86},{12,-66}})));
  CDL.Reals.AddParameter addParPre2[nZon](p=0.99*TResInt) if not airConMod
    annotation (Placement(transformation(extent={{-8,-126},{12,-106}})));
  CDL.Reals.AddParameter addParShe1[nZon](p=0.99*TResInt) if airConMod
    annotation (Placement(transformation(extent={{-10,-172},{10,-152}})));
  CDL.Reals.AddParameter addParShe2[nZon](p=-0.99*TResInt) if not airConMod
    annotation (Placement(transformation(extent={{-10,-206},{10,-186}})));
  CDL.Reals.AddParameter addParReb1[nZon](p=-0.99*TResInt) if airConMod
    annotation (Placement(transformation(extent={{-4,-254},{16,-234}})));
  CDL.Reals.AddParameter addParReb2[nZon](p=0.99*TResInt) if not airConMod
    annotation (Placement(transformation(extent={{-6,-288},{14,-268}})));
protected
  CDL.Integers.Sources.Constant                        conIntShe(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Integers.Equal                        intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  CDL.Integers.Equal                        intEquPre if use_pre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  CDL.Integers.Sources.Constant                        conIntPre(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    if use_pre
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  CDL.Integers.Sources.Constant                        conIntReb(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  CDL.Integers.Equal                        intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
equation
  connect(or1.y, or2.u1) annotation (Line(points={{82,150},{90,150},{90,-30},{98,
          -30}},
        color={255,0,255}));
  connect(or2.y, or3.u1) annotation (Line(points={{122,-30},{132,-30},{132,-90},
          {138,-90}}, color={255,0,255}));
  connect(or3.y, disFla) annotation (Line(points={{162,-90},{170,-90},{170,0},{200,
          0}}, color={255,0,255}));
  connect(rouZonFla, or1.u1) annotation (Line(points={{-200,160},{20,160},{20,150},
          {58,150}},color={255,0,255}));
  connect(PBui, gre.u1) annotation (Line(points={{-200,120},{-140,120},{-140,110},
          {-122,110}},color={0,0,127}));
  connect(PBuiThr, gre.u2) annotation (Line(points={{-200,80},{-140,80},{-140,102},
          {-122,102}},color={0,0,127}));
  connect(gre.y, not1.u)
    annotation (Line(points={{-98,110},{-82,110}},
                                                 color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{-58,110},{-22,110}},
                    color={255,0,255}));
  connect(intEquShe.y, and2.u2) annotation (Line(points={{-58,-90},{-50,-90},{-50,
          102},{-22,102}},
                         color={255,0,255}));
  connect(and2.y, booScaRep.u)
    annotation (Line(points={{2,110},{18,110}},
                                              color={255,0,255}));
  connect(booScaRep.y, or1.u2) annotation (Line(points={{42,110},{50,110},{50,142},
          {58,142}},color={255,0,255}));
  connect(con.y, or1.u2) annotation (Line(points={{42,70},{50,70},{50,142},{58,142}},
        color={255,0,255}));
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-200,-40},{-160,-40},
          {-160,-90},{-82,-90}},
                               color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2) annotation (Line(points={{-118,-110},{-100,
          -110},{-100,-98},{-82,-98}},
                               color={255,127,0}));
  connect(TZon, dTZon.u1) annotation (Line(points={{-200,40},{-170,40},{-170,36},
          {-162,36}},color={0,0,127}));
  connect(TZonSet, dTZon.u2) annotation (Line(points={{-200,0},{-170,0},{-170,24},
          {-162,24}},       color={0,0,127}));
  connect(lesThr.y, not2.u)
    annotation (Line(points={{-58,30},{-42,30}},   color={255,0,255}));
  connect(intEquShe.y, booScaRep1.u) annotation (Line(points={{-58,-90},{-50,-90},
          {-50,-10},{-42,-10}},
                              color={255,0,255}));
  connect(dTZon.y, gai.u)
    annotation (Line(points={{-138,30},{-122,30}},   color={0,0,127}));
  connect(dTZon.y, gai1.u) annotation (Line(points={{-138,30},{-130,30},{-130,-10},
          {-122,-10}},      color={0,0,127}));
  connect(gai1.y, lesThr.u) annotation (Line(points={{-98,-10},{-90,-10},{-90,30},
          {-82,30}},  color={0,0,127}));
  connect(gai.y, lesThr.u)
    annotation (Line(points={{-98,30},{-82,30}},   color={0,0,127}));
  connect(and1.y, or2.u2) annotation (Line(points={{42,30},{60,30},{60,-38},{98,
          -38}}, color={255,0,255}));
  connect(not2.y, and1.u1)
    annotation (Line(points={{-18,30},{18,30}}, color={255,0,255}));
  connect(booScaRep1.y, and1.u2) annotation (Line(points={{-18,-10},{0,-10},{0,22},
          {18,22}}, color={255,0,255}));
  connect(conIntPre.y, intEquPre.u2) annotation (Line(points={{-118,-70},{-100,-70},
          {-100,-58},{-82,-58}}, color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2) annotation (Line(points={{-118,-150},{-100,
          -150},{-100,-138},{-82,-138}}, color={255,127,0}));
  connect(demFleMod, intEquPre.u1) annotation (Line(points={{-200,-40},{-160,-40},
          {-160,-50},{-82,-50}}, color={255,127,0}));
  connect(demFleMod, intEquReb.u1) annotation (Line(points={{-200,-40},{-160,-40},
          {-160,-130},{-82,-130}}, color={255,127,0}));
  connect(TZonSet, gre1.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-56},
          {44,-56}}, color={0,0,127}));
  connect(TZonSet, les2.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-144},
          {46,-144}}, color={0,0,127}));
  connect(TZonSet, les1.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-96},
          {44,-96}}, color={0,0,127}));
  connect(TZonSet, gre2.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-178},
          {44,-178}}, color={0,0,127}));
  connect(TZonSet, gre3.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-226},
          {46,-226}}, color={0,0,127}));
  connect(TZonSet, les3.u1) annotation (Line(points={{-200,0},{-46,0},{-46,-258},
          {46,-258}}, color={0,0,127}));
  connect(TPreTarSet, addParPre1.u) annotation (Line(points={{-200,-200},{-104,-200},
          {-104,-76},{-10,-76}}, color={0,0,127}));
  connect(TPreTarSet, addParPre2.u) annotation (Line(points={{-200,-200},{-104,-200},
          {-104,-116},{-10,-116}}, color={0,0,127}));
  connect(TSheTarSet, addParShe1.u) annotation (Line(points={{-200,-280},{-106,-280},
          {-106,-162},{-12,-162}}, color={0,0,127}));
  connect(TSheTarSet, addParShe2.u) annotation (Line(points={{-200,-280},{-105,-280},
          {-105,-196},{-12,-196}}, color={0,0,127}));
  connect(TDefSet, addParReb1.u) annotation (Line(points={{-200,-240},{-102,-240},
          {-102,-244},{-6,-244}}, color={0,0,127}));
  connect(TDefSet, addParReb2.u) annotation (Line(points={{-200,-240},{-104,-240},
          {-104,-278},{-8,-278}}, color={0,0,127}));
  connect(addParPre1.y, gre1.u2) annotation (Line(points={{14,-76},{30,-76},{30,
          -64},{44,-64}}, color={0,0,127}));
  connect(addParPre2.y, les1.u2) annotation (Line(points={{14,-116},{30,-116},{30,
          -104},{44,-104}}, color={0,0,127}));
  connect(addParShe1.y, les2.u2) annotation (Line(points={{12,-162},{30,-162},{30,
          -152},{46,-152}}, color={0,0,127}));
  connect(addParShe2.y, gre2.u2) annotation (Line(points={{12,-196},{30,-196},{30,
          -186},{44,-186}}, color={0,0,127}));
  connect(addParReb1.y, gre3.u2) annotation (Line(points={{18,-244},{34,-244},{34,
          -234},{46,-234}}, color={0,0,127}));
  connect(addParReb2.y, les3.u2) annotation (Line(points={{16,-278},{32,-278},{32,
          -266},{46,-266}}, color={0,0,127}));
  annotation (defaultComponentName="zonPri",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-180},{100,180}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-102,220},{98,180}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
July 16, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block serves to determine whether a zone is qualified to participate in the
zone temperature comparison. 
</p>
<p>
Several conditions are used to determine that a zone is qualified, including:
</p>
<ol>
<li>
A zone is not a rogue zone.
</li>
<li>
The electricity demand of the building where the zone is located
is higher than an electricity demand threshold during the load-shed demand flexibility mode.
</li>
<li>
The zone temperature is close enough to the zone temperature
setpoint during the load-shed demand flexibility mode.
</li>
<li>
The zone temperature setpoint has not reached a temperature
setpoint limit that is imposed by the respective demand flexibility mode.
</li>
</ol>
<p>
If any one of the above conditions is not met for a zone, the disqualified
zone flag disFla for that zone will be set to true. Otherwise, disFla is set to false.
</p>
<p>
The parameter airConMod represents the air conditioning mode. airConMod = true
represents the heating mode, whereas airConMod = false represents the
cooling mode. The demand flexibility mode demFleMod can take values of
0 (pre-cool or pre-heat mode), 1 (default mode), 2 (load-shed mode), and 3 (load-rebound mode). 
</p>
<p>
Zone temperature difference, an internal variable, is defined as the
zone temperature (TZon) minus the zone temperature setpoint (TZonSet).
The zone temperature setpoint input variable TZonSet must represent a
heating setpoint when airConMod = true, and it must represent a cooling
setpoint when airConMod = false.
</p>
<p>
The input variables TPreTarSet, TDefSet, and TSheTarSet must represent
reasonable values within a range. For example, TPreTarSet &gt; TDefSet &gt; TSheTarSet
must hold if the air conditioning system is in the heating mode (airConMod = true),
and TPreTarSet &lt; TDefSet &lt; TSheTarSet must hold if the air conditioning
system is in the cooling mode (airConMod = false).
</p>
<p>
Below is a detailed discussion of each of the 4 conditions. 
</p>
<h4>Condition 1</h4>
<p>
When the rogue zone flag input rouZonFla is true for a specific zone, this
zone is a rogue zone. Therefore, this zone is not qualified to participate in
the zone temperature comparison. Hence, disFla = true for this zone. Otherwise,
another condition needs to be not met for disFla to become true. 
</p>
<h4>Condition 2</h4>
<p>
When the electricity demand of the building is lower than the electricity demand
threshold minus a hysteresis (PBui  &lt;= PBuiThr - PBuiHys), and the demand
flexibility mode demFleMod = 2 (load-shed mode), all zones in the building will
have disFla = true. When the electricity demand of the building is higher than
the electricity demand threshold (PBui &gt; PBuiThr), or demFleMod has any other
value except 2, another condition needs to be not met for disFla to become true.
This electricity demand condition is considered only if the flag of using
demand-based control use_demCon is true. 
</p>
<h4>Condition 3</h4>
<p>
If the zone temperature setpoint TZonSet and the zone temperature TZon meet any one of the following equations, this zone will have disFla = true. Note that dTSheThr is the zone temperature difference threshold, and dTSheHys is the zone temperature difference hysteresis.
</p>
<ul>
<li>
airConMod = true, and demFleMod = 2, and TZon - TZonSet &gt;=  dTSheThr + dTSheHys
</li>
<li>
airConMod = false, and demFleMod = 2, and - (TZon - TZonSet) &gt;=  dTSheThr + dTSheHys
</li>
</ul>
<p>
If the zone temperature setpoint TZonSet and the zone temperature TZon meet any one of the following equations, another condition needs to be not met for disFla to become true:
</p>
<ul>
<li>
demFleMod ≠ 2
</li>
<li>
airConMod = true, and demFleMod = 2, and TZon - TZonSet &lt;  dTSheThr
</li>
<li>
airConMod = false, and demFleMod = 2, and - (TZon - TZonSet) &lt;  dTSheThr
</li>
</ul>
<h4>Condition 4</h4>
<p>
If the zone temperature setpoint TZonSet of a zone meets any one of the following equations, this zone will have disFla = true. Since the presence of a temperature resolution from the external temperature setpoint controller will make TZonSet only take a finite set of discrete values, the temperature resolution interval TResInt is used in the following equations. 0.99 * TResInt is used to prevent unexpected behaviors from higher-level logic blocks under edge-case operations, while being less than 1 * TResInt to achieve the same behaviors as the case where TResInt were not used under non-edge-case operations. On the other hand, 0.1 * TResInt is used as a hysteresis value:
</p>
<ul>
<li>
airConMod = true, and demFleMod = 0, and TZonSet &gt; TPreTarSet - 0.99 * TResInt
</li>
<li>
airConMod = true, and demFleMod = 2, and TZonSet &lt; TSheTarSet + 0.99 * TResInt
</li>
<li>
airConMod = true, and demFleMod = 3, and TZonSet &gt; TDefSet - 0.99 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 0, and TZonSet &lt; TPreTarSet + 0.99 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 2, and TZonSet &gt; TSheTarSet - 0.99 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 3, and TZonSet &lt; TDefSet + 0.99 * TResInt
</li>
</ul>
<p>
If the zone temperature setpoint TZonSet of a zone meets any one of the following conditions, another condition needs to be not met for disFla to become true:
</p>
<ul>
<li>
demFleMod = 1
</li>
<li>
airConMod = true, and demFleMod = 0, and TZonSet &lt; TPreTarSet - 0.99 * TResInt - 0.1 * TResInt
</li>
<li>
airConMod = true, and demFleMod = 2, and TZonSet &gt; TSheTarSet + 0.99 * TResInt + 0.1 * TResInt
</li>
<li>
airConMod = true, and demFleMod = 3, and TZonSet &lt; TDefSet - 0.99 * TResInt - 0.1 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 0, and TZonSet &gt; TPreTarSet + 0.99 * TResInt + 0.1 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 2, and TZonSet &lt; TSheTarSet - 0.99 * TResInt - 0.1 * TResInt
</li>
<li>
airConMod = false, and demFleMod = 3, and TZonSet &gt; TDefSet + 0.99 * TResInt + 0.1 * TResInt
</li>
</ul>
</html>"));
end ZoneQualification;
