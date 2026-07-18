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
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput disFla[nZon]
    "Flags to disqualify certain zones from zone temperature comparison; true to disqualify a zone"
    annotation (Placement(transformation(extent={{260,20},{300,60}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon]
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
                                                   annotation (Placement(
        transformation(extent={{-300,20},{-260,60}}),   iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet[nZon]
    "Pre-cool or pre-heat target temperature setpoint" annotation (Placement(
        transformation(extent={{-300,-100},{-260,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet[nZon]
    "Load-shed target temperature setpoint" annotation (Placement(
        transformation(extent={{-300,-180},{-260,-140}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet[nZon] "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-300,-260},{-260,-220}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiThr if use_demCon
    "Threshold for the electricity demand of the building"        annotation (
      Placement(transformation(extent={{-300,200},{-260,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBui if use_demCon "Electricity demand of the building"
                                                               annotation (
      Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1[nZon]
    annotation (Placement(transformation(extent={{60,280},{80,300}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nZon]
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3[nZon]
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre(h=PBuiHys) if use_demCon
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if use_demCon
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 if use_demCon
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=nZon) if use_demCon
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nZon](final k=fill(true,
        nZon))                                                                      if not use_demCon
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract                        dTZon[nZon] "Zone temperature difference"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesThr[nZon](final t=fill(dTSheThr, nZon), final h=
        fill(dTSheHys, nZon))
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nZon]
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nZon]
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep2(nout=nZon)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nZon](final k=fill(1, nZon)) if airConMod
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1[nZon](final k=fill(-1, nZon)) if not airConMod
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1[nZon](final h=fill(0.1*TResInt, nZon))
                               if airConMod
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Less les1[nZon](final h=fill(0.1*TResInt, nZon))
                            if not airConMod
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Less les2[nZon](final h=fill(0.1*TResInt, nZon))
                            if airConMod
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre2[nZon](final h=fill(0.1*TResInt, nZon))
                               if not airConMod
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre3[nZon](final h=fill(0.1*TResInt, nZon))
                               if airConMod
    annotation (Placement(transformation(extent={{-60,-240},{-40,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Less les3[nZon](final h=fill(0.1*TResInt, nZon))
                            if not airConMod
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParPre1[nZon](final p=fill(-0.99
        *TResInt, nZon))                                                          if airConMod
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParPre2[nZon](final p=fill(0.99
        *TResInt, nZon))                                                         if not airConMod
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParShe1[nZon](final p=fill(0.99
        *TResInt, nZon))                                                         if airConMod
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParShe2[nZon](final p=fill(-0.99
        *TResInt, nZon))                                                          if not airConMod
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParReb1[nZon](final p=fill(-0.99
        *TResInt, nZon))                                                          if airConMod
    annotation (Placement(transformation(extent={{-140,-260},{-120,-240}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParReb2[nZon](final p=fill(0.99
        *TResInt, nZon))                                                         if not airConMod
    annotation (Placement(transformation(extent={{-140,-300},{-120,-280}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nZon]
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nZon]
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And and5[nZon]
    annotation (Placement(transformation(extent={{20,-260},{40,-240}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=nZon)
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep3(nout=nZon)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4[nZon]
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5[nZon]
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        conIntShe(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                        intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                        intEquPre if use_pre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        conIntPre(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    if use_pre
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant                        conIntReb(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal                        intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(or1.y, or2.u1) annotation (Line(points={{82,290},{100,290},{100,170},{
          118,170}},
        color={255,0,255}));
  connect(or2.y, or3.u1) annotation (Line(points={{142,170},{200,170},{200,40},{
          218,40}},   color={255,0,255}));
  connect(or3.y, disFla) annotation (Line(points={{242,40},{280,40}},
               color={255,0,255}));
  connect(rouZonFla, or1.u1) annotation (Line(points={{-280,300},{20,300},{20,290},
          {58,290}},color={255,0,255}));
  connect(PBui, gre.u1) annotation (Line(points={{-280,260},{-240,260},{-240,250},
          {-222,250}},color={0,0,127}));
  connect(PBuiThr, gre.u2) annotation (Line(points={{-280,220},{-240,220},{-240,
          242},{-222,242}},
                      color={0,0,127}));
  connect(gre.y, not1.u)
    annotation (Line(points={{-198,250},{-102,250}},
                                                 color={255,0,255}));
  connect(not1.y, and2.u1) annotation (Line(points={{-78,250},{-22,250}},
                    color={255,0,255}));
  connect(intEquShe.y, and2.u2) annotation (Line(points={{-78,50},{-60,50},{-60,
          242},{-22,242}},
                         color={255,0,255}));
  connect(and2.y, booScaRep.u)
    annotation (Line(points={{2,250},{18,250}},
                                              color={255,0,255}));
  connect(booScaRep.y, or1.u2) annotation (Line(points={{42,250},{50,250},{50,282},
          {58,282}},color={255,0,255}));
  connect(con.y, or1.u2) annotation (Line(points={{42,210},{50,210},{50,282},{58,
          282}},
        color={255,0,255}));
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-280,40},{-180,40},
          {-180,50},{-102,50}},color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2) annotation (Line(points={{-138,30},{-120,30},
          {-120,42},{-102,42}},color={255,127,0}));
  connect(TZon, dTZon.u1) annotation (Line(points={{-280,180},{-240,180},{-240,176},
          {-222,176}},
                     color={0,0,127}));
  connect(TZonSet, dTZon.u2) annotation (Line(points={{-280,140},{-240,140},{-240,
          164},{-222,164}}, color={0,0,127}));
  connect(lesThr.y, not2.u)
    annotation (Line(points={{-78,170},{-42,170}}, color={255,0,255}));
  connect(intEquShe.y,booScaRep2. u) annotation (Line(points={{-78,50},{-42,50}},
                              color={255,0,255}));
  connect(dTZon.y, gai.u)
    annotation (Line(points={{-198,170},{-162,170}}, color={0,0,127}));
  connect(dTZon.y, gai1.u) annotation (Line(points={{-198,170},{-180,170},{-180,
          130},{-162,130}}, color={0,0,127}));
  connect(gai1.y, lesThr.u) annotation (Line(points={{-138,130},{-120,130},{-120,
          170},{-102,170}},
                      color={0,0,127}));
  connect(gai.y, lesThr.u)
    annotation (Line(points={{-138,170},{-102,170}},
                                                   color={0,0,127}));
  connect(and1.y, or2.u2) annotation (Line(points={{62,170},{80,170},{80,162},{118,
          162}}, color={255,0,255}));
  connect(not2.y, and1.u1)
    annotation (Line(points={{-18,170},{38,170}},
                                                color={255,0,255}));
  connect(booScaRep2.y, and1.u2) annotation (Line(points={{-18,50},{0,50},{0,162},
          {38,162}},color={255,0,255}));
  connect(conIntPre.y, intEquPre.u2) annotation (Line(points={{-138,70},{-120,70},
          {-120,82},{-102,82}},  color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2) annotation (Line(points={{-138,-10},{-120,-10},
          {-120,2},{-102,2}},            color={255,127,0}));
  connect(demFleMod, intEquPre.u1) annotation (Line(points={{-280,40},{-180,40},
          {-180,90},{-102,90}},  color={255,127,0}));
  connect(demFleMod, intEquReb.u1) annotation (Line(points={{-280,40},{-180,40},
          {-180,10},{-102,10}},    color={255,127,0}));
  connect(TZonSet, gre1.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -70},{-62,-70}},
                     color={0,0,127}));
  connect(TZonSet, les2.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -150},{-62,-150}},
                      color={0,0,127}));
  connect(TZonSet, les1.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -110},{-62,-110}},
                     color={0,0,127}));
  connect(TZonSet, gre2.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -190},{-62,-190}},
                      color={0,0,127}));
  connect(TZonSet, gre3.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -230},{-62,-230}},
                      color={0,0,127}));
  connect(TZonSet, les3.u1) annotation (Line(points={{-280,140},{-220,140},{-220,
          -270},{-62,-270}},
                      color={0,0,127}));
  connect(TPreTarSet, addParPre1.u) annotation (Line(points={{-280,-80},{-180,-80},
          {-180,-90},{-142,-90}},color={0,0,127}));
  connect(TPreTarSet, addParPre2.u) annotation (Line(points={{-280,-80},{-180,-80},
          {-180,-130},{-142,-130}},color={0,0,127}));
  connect(TSheTarSet, addParShe1.u) annotation (Line(points={{-280,-160},{-180,-160},
          {-180,-170},{-142,-170}},color={0,0,127}));
  connect(TSheTarSet, addParShe2.u) annotation (Line(points={{-280,-160},{-180,-160},
          {-180,-210},{-142,-210}},color={0,0,127}));
  connect(TDefSet, addParReb1.u) annotation (Line(points={{-280,-240},{-180,-240},
          {-180,-250},{-142,-250}},
                                  color={0,0,127}));
  connect(TDefSet, addParReb2.u) annotation (Line(points={{-280,-240},{-180,-240},
          {-180,-290},{-142,-290}},
                                  color={0,0,127}));
  connect(addParPre1.y, gre1.u2) annotation (Line(points={{-118,-90},{-100,-90},
          {-100,-78},{-62,-78}},
                          color={0,0,127}));
  connect(addParPre2.y, les1.u2) annotation (Line(points={{-118,-130},{-100,-130},
          {-100,-118},{-62,-118}},
                            color={0,0,127}));
  connect(addParShe1.y, les2.u2) annotation (Line(points={{-118,-170},{-100,-170},
          {-100,-158},{-62,-158}},
                            color={0,0,127}));
  connect(addParShe2.y, gre2.u2) annotation (Line(points={{-118,-210},{-100,-210},
          {-100,-198},{-62,-198}},
                            color={0,0,127}));
  connect(addParReb1.y, gre3.u2) annotation (Line(points={{-118,-250},{-100,-250},
          {-100,-238},{-62,-238}},
                            color={0,0,127}));
  connect(addParReb2.y, les3.u2) annotation (Line(points={{-118,-290},{-100,-290},
          {-100,-278},{-62,-278}},
                            color={0,0,127}));
  connect(gre1.y, and3.u2) annotation (Line(points={{-38,-70},{-20,-70},{-20,-98},
          {58,-98}}, color={255,0,255}));
  connect(les1.y, and3.u2) annotation (Line(points={{-38,-110},{-20,-110},{-20,-98},
          {58,-98}}, color={255,0,255}));
  connect(intEquPre.y, booScaRep1.u)
    annotation (Line(points={{-78,90},{-42,90}}, color={255,0,255}));
  connect(intEquReb.y, booScaRep3.u)
    annotation (Line(points={{-78,10},{-42,10}}, color={255,0,255}));
  connect(les2.y, and4.u2) annotation (Line(points={{-38,-150},{-20,-150},{-20,-178},
          {38,-178}}, color={255,0,255}));
  connect(gre2.y, and4.u2) annotation (Line(points={{-38,-190},{-20,-190},{-20,-178},
          {38,-178}}, color={255,0,255}));
  connect(booScaRep1.y, and3.u1) annotation (Line(points={{-18,90},{40,90},{40,-90},
          {58,-90}}, color={255,0,255}));
  connect(booScaRep2.y, and4.u1) annotation (Line(points={{-18,50},{20,50},{20,-170},
          {38,-170}}, color={255,0,255}));
  connect(gre3.y, and5.u2) annotation (Line(points={{-38,-230},{-20,-230},{-20,-258},
          {18,-258}}, color={255,0,255}));
  connect(les3.y, and5.u2) annotation (Line(points={{-38,-270},{-20,-270},{-20,-258},
          {18,-258}}, color={255,0,255}));
  connect(booScaRep3.y, and5.u1) annotation (Line(points={{-18,10},{0,10},{0,-250},
          {18,-250}}, color={255,0,255}));
  connect(and3.y, or4.u1)
    annotation (Line(points={{82,-90},{158,-90}}, color={255,0,255}));
  connect(and5.y, or5.u2) annotation (Line(points={{42,-250},{80,-250},{80,-198},
          {98,-198}}, color={255,0,255}));
  connect(and4.y, or5.u1) annotation (Line(points={{62,-170},{80,-170},{80,-190},
          {98,-190}}, color={255,0,255}));
  connect(or5.y, or4.u2) annotation (Line(points={{122,-190},{140,-190},{140,-98},
          {158,-98}}, color={255,0,255}));
  connect(or4.y, or3.u2) annotation (Line(points={{182,-90},{200,-90},{200,32},{
          218,32}}, color={255,0,255}));
  annotation (defaultComponentName="zonQua",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-180},{100,180}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-102,220},{98,180}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-260,-320},{260,320}},
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
