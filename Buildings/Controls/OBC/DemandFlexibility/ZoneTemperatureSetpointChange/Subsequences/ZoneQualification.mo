within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block ZoneQualification "Zone qualification"

  parameter Real dTSheThr(
    min=0,
    unit="K",
    displayUnit="K")
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)";
  parameter Real dTSheHys(
    min=0,
    unit="K",
    displayUnit="K")
    "Hysteresis for the temperature difference during the load-shed mode";
  parameter Real PBuiHys(
    min=0,
    start=1,
    unit="W")
    "Hysteresis for the electricity demand of the building"
    annotation (Dialog(enable = use_demCon));
  parameter Real TResInt(
    min=0,
    unit="K",
    displayUnit="K")
    "Temperature resolution interval used by an external zone temperature controller";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Boolean use_demCon
    "True: use demand-based control";
  parameter Integer nZon(min=1)
    "Number of zones in the building";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-300,120},{-260,160}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-300,-100},{-260,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{-300,-180},{-260,-140}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-300,-260},{-260,-220}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiThr(
    final unit="W",
    final quantity="Power")
    if use_demCon
    "Threshold for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-300,200},{-260,240}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBui(
    final unit="W",
    final quantity="Power")
    if use_demCon
    "Electricity demand of the building"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput disFla[nZon]
    "Flags to disqualify certain zones from zone temperature comparison; true to disqualify a zone"
    annotation (Placement(transformation(extent={{260,20},{300,60}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Or orCon12[nZon]
    "Condition 1 or Condition 2 is not met"
    annotation (Placement(transformation(extent={{60,280},{80,300}})));
  Buildings.Controls.OBC.CDL.Logical.Or orCon123[nZon]
    "Condition 1, Condition 2, or Condition 3 is not met"
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or orCon1234[nZon]
    "Condition 1, Condition 2, Condition 3, or Condition 4 is not met"
    annotation (Placement(transformation(extent={{220,30},{240,50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater grePBui(
    final h=PBuiHys)
    if use_demCon
    "Check whether the building electricity demand is greater than the building electricity demand threshold"
    annotation (Placement(transformation(extent={{-220,240},{-200,260}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGrePBui if use_demCon
    "Check whether the building electricity demand is no greater than the building electricity demand threshold"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Logical.And andPBuiLoaShe if use_demCon
    "Building electricity demand is less than a threshold and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepCon2(
    final nout=nZon)
    if use_demCon
    "Scaling a boolean scalar that indicates Condition 2 is not met"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conDisCon2[nZon](final k=
        fill(false, nZon))
    if not use_demCon
    "When logic for Condition 2 is disabled, output false in place of the Condition 2 logic"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZon[nZon]
    "Zone temperature difference"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesDTZon[nZon](
    final t=fill(dTSheThr,nZon),
    final h=fill(dTSheHys,nZon))
    "The zone temperature difference is less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesDTZon[nZon]
    "The zone temperature difference is no less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Logical.And andDTZonLoaShe[nZon]
    "The zone temperature difference is more than the load-shed mode zone temperature difference threshold, and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(
    final nout=nZon) "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter posValDTZon[nZon](
    final k=fill(1,nZon))
    if airConMod
    "Use the positive value of the zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-160,160},{-140,180}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter negValDTZon[nZon](
    final k=fill(-1,nZon))
    if not airConMod
    "Use the negative value of the zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetPreHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod
    "The zone heating temperature setpoint is greater than the pre-heat target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetPreCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if not airConMod
    "The zone cooling temperature setpoint is less than the pre-cool target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetSheHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod
    "The zone heating temperature setpoint is less than the load-shed heating target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetSheCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if not airConMod
    "The zone cooling temperature setpoint is greater than the load-shed cooling target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetRebHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod
    "The zone heating temperature setpoint is greater than the default heating temperature setpoint during the load-rebound mode, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-240},{-40,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetRebCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if not airConMod
    "The zone cooling temperature setpoint is less than the default cooling temperature setpoint during the load-rebound mode, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-280},{-40,-260}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntPreHea[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if airConMod
    "Subtract 0.99 times the temperature resolution interval during the pre-heat mode"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntPreCoo[nZon](
    final p=fill(0.99*TResInt,nZon))
    if not airConMod
    "Add 0.99 times the temperature resolution interval during the pre-cool mode"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntSheHea[nZon](
    final p=fill(0.99*TResInt,nZon))
    if airConMod
    "Add 0.99 times the temperature resolution interval during the heating load-shed mode"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntSheCoo[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if not airConMod
    "Subtract 0.99 times the temperature resolution interval during the cooling load-shed mode"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntRebHea[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if airConMod
    "Subtract 0.99 times the temperature resolution interval during the heating load-rebound mode"
    annotation (Placement(transformation(extent={{-140,-260},{-120,-240}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntRebCoo[nZon](
    final p=fill(0.99*TResInt,nZon))
    if not airConMod
    "Add 0.99 times the temperature resolution interval during the cooling load-rebound mode"
    annotation (Placement(transformation(extent={{-140,-300},{-120,-280}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTPreTarSet[nZon]
    "In the pre-cool or pre-heat mode, the zone temperature setpoint has reached the pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTSheTarSet[nZon]
    "In the load-shed mode, the zone temperature setpoint has reached the load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{40,-180},{60,-160}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTDefSet[nZon]
    "In the load-rebound mode, the zone temperature setpoint has reached the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-260},{40,-240}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepPre(
    final nout=nZon)
    "Repeat the boolean scalar for being in the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepReb(
    final nout=nZon) "Repeat the boolean scalar for being in the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or orCon4[nZon] "Condition 4 is not met"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaTSheTarSetTDefSet[nZon]
    "The zone temperature setpoint has either reached the load-shed target temperature setpoint during the load-shed mode, or reached the default temperature setpoint during the load-rebound mode"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquPre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntPre(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
equation
  connect(orCon12.y, orCon123.u1)
    annotation (Line(points={{82,290},{100,290},{100,170},{118,170}},
      color={255,0,255}));
  connect(orCon123.y, orCon1234.u1)
    annotation (Line(points={{142,170},{200,170},{200,40},{218,40}},
      color={255,0,255}));
  connect(orCon1234.y, disFla)
    annotation (Line(points={{242,40},{280,40}}, color={255,0,255}));
  connect(rouZonFla, orCon12.u1)
    annotation (Line(points={{-280,300},{20,300},{20,290},{58,290}},
      color={255,0,255}));
  connect(PBui, grePBui.u1)
    annotation (Line(points={{-280,260},{-240,260},{-240,250},{-222,250}},
      color={0,0,127}));
  connect(PBuiThr, grePBui.u2)
    annotation (Line(points={{-280,220},{-240,220},{-240,242},{-222,242}},
      color={0,0,127}));
  connect(grePBui.y, notGrePBui.u)
    annotation (Line(points={{-198,250},{-102,250}}, color={255,0,255}));
  connect(notGrePBui.y, andPBuiLoaShe.u1)
    annotation (Line(points={{-78,250},{-22,250}}, color={255,0,255}));
  connect(intEquShe.y, andPBuiLoaShe.u2)
    annotation (Line(points={{-78,50},{-60,50},{-60,242},{-22,242}},
      color={255,0,255}));
  connect(andPBuiLoaShe.y, booScaRepCon2.u)
    annotation (Line(points={{2,250},{18,250}}, color={255,0,255}));
  connect(booScaRepCon2.y, orCon12.u2)
    annotation (Line(points={{42,250},{50,250},{50,282},{58,282}},
      color={255,0,255}));
  connect(conDisCon2.y, orCon12.u2)
    annotation (Line(points={{42,210},{50,210},{50,282},{58,282}},
      color={255,0,255}));
  connect(demFleMod, intEquShe.u1)
    annotation (Line(points={{-280,40},{-180,40},{-180,50},{-102,50}},
      color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2)
    annotation (Line(points={{-138,30},{-120,30},{-120,42},{-102,42}},
      color={255,127,0}));
  connect(TZon, dTZon.u1)
    annotation (Line(points={{-280,180},{-240,180},{-240,176},{-222,176}},
      color={0,0,127}));
  connect(TZonSet, dTZon.u2)
    annotation (Line(points={{-280,140},{-240,140},{-240,164},{-222,164}},
      color={0,0,127}));
  connect(lesDTZon.y, notLesDTZon.u)
    annotation (Line(points={{-78,170},{-42,170}}, color={255,0,255}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-78,50},{-42,50}}, color={255,0,255}));
  connect(dTZon.y, posValDTZon.u)
    annotation (Line(points={{-198,170},{-162,170}}, color={0,0,127}));
  connect(dTZon.y, negValDTZon.u)
    annotation (Line(points={{-198,170},{-180,170},{-180,130},{-162,130}},
      color={0,0,127}));
  connect(negValDTZon.y, lesDTZon.u)
    annotation (Line(points={{-138,130},{-120,130},{-120,170},{-102,170}},
      color={0,0,127}));
  connect(posValDTZon.y, lesDTZon.u)
    annotation (Line(points={{-138,170},{-102,170}}, color={0,0,127}));
  connect(andDTZonLoaShe.y, orCon123.u2)
    annotation (Line(points={{62,170},{80,170},{80,162},{118,162}},
      color={255,0,255}));
  connect(notLesDTZon.y, andDTZonLoaShe.u1)
    annotation (Line(points={{-18,170},{38,170}}, color={255,0,255}));
  connect(booScaRepShe.y, andDTZonLoaShe.u2)
    annotation (Line(points={{-18,50},{0,50},{0,162},{38,162}}, color={255,0,255}));
  connect(conIntPre.y, intEquPre.u2)
    annotation (Line(points={{-138,70},{-120,70},{-120,82},{-102,82}},
      color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2)
    annotation (Line(points={{-138,-10},{-120,-10},{-120,2},{-102,2}},
      color={255,127,0}));
  connect(demFleMod, intEquPre.u1)
    annotation (Line(points={{-280,40},{-180,40},{-180,90},{-102,90}},
      color={255,127,0}));
  connect(demFleMod, intEquReb.u1)
    annotation (Line(points={{-280,40},{-180,40},{-180,10},{-102,10}},
      color={255,127,0}));
  connect(TZonSet, greTSetPreHea.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-70},{-62,-70}},
      color={0,0,127}));
  connect(TZonSet, lesTSetSheHea.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-150},{-62,-150}},
      color={0,0,127}));
  connect(TZonSet, lesTSetPreCoo.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-110},{-62,-110}},
      color={0,0,127}));
  connect(TZonSet, greTSetSheCoo.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-190},{-62,-190}},
      color={0,0,127}));
  connect(TZonSet, greTSetRebHea.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-230},{-62,-230}},
      color={0,0,127}));
  connect(TZonSet, lesTSetRebCoo.u1)
    annotation (Line(points={{-280,140},{-220,140},{-220,-270},{-62,-270}},
      color={0,0,127}));
  connect(TPreTarSet, subTResIntPreHea.u)
    annotation (Line(points={{-280,-80},{-180,-80},{-180,-90},{-142,-90}},
      color={0,0,127}));
  connect(TPreTarSet, addTResIntPreCoo.u)
    annotation (Line(points={{-280,-80},{-180,-80},{-180,-130},{-142,-130}},
      color={0,0,127}));
  connect(TSheTarSet, addTResIntSheHea.u)
    annotation (Line(points={{-280,-160},{-180,-160},{-180,-170},{-142,-170}},
      color={0,0,127}));
  connect(TSheTarSet, subTResIntSheCoo.u)
    annotation (Line(points={{-280,-160},{-180,-160},{-180,-210},{-142,-210}},
      color={0,0,127}));
  connect(TDefSet, subTResIntRebHea.u)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-250},{-142,-250}},
      color={0,0,127}));
  connect(TDefSet, addTResIntRebCoo.u)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-290},{-142,-290}},
      color={0,0,127}));
  connect(subTResIntPreHea.y, greTSetPreHea.u2)
    annotation (Line(points={{-118,-90},{-100,-90},{-100,-78},{-62,-78}},
      color={0,0,127}));
  connect(addTResIntPreCoo.y, lesTSetPreCoo.u2)
    annotation (Line(points={{-118,-130},{-100,-130},{-100,-118},{-62,-118}},
      color={0,0,127}));
  connect(addTResIntSheHea.y, lesTSetSheHea.u2)
    annotation (Line(points={{-118,-170},{-100,-170},{-100,-158},{-62,-158}},
      color={0,0,127}));
  connect(subTResIntSheCoo.y, greTSetSheCoo.u2)
    annotation (Line(points={{-118,-210},{-100,-210},{-100,-198},{-62,-198}},
      color={0,0,127}));
  connect(subTResIntRebHea.y, greTSetRebHea.u2)
    annotation (Line(points={{-118,-250},{-100,-250},{-100,-238},{-62,-238}},
      color={0,0,127}));
  connect(addTResIntRebCoo.y, lesTSetRebCoo.u2)
    annotation (Line(points={{-118,-290},{-100,-290},{-100,-278},{-62,-278}},
      color={0,0,127}));
  connect(greTSetPreHea.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,-70},{-20,-70},{-20,-98},{58,-98}},
      color={255,0,255}));
  connect(lesTSetPreCoo.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,-110},{-20,-110},{-20,-98},{58,-98}},
      color={255,0,255}));
  connect(intEquPre.y, booScaRepPre.u)
    annotation (Line(points={{-78,90},{-42,90}}, color={255,0,255}));
  connect(intEquReb.y, booScaRepReb.u)
    annotation (Line(points={{-78,10},{-42,10}}, color={255,0,255}));
  connect(lesTSetSheHea.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-150},{-20,-150},{-20,-178},{38,-178}},
      color={255,0,255}));
  connect(greTSetSheCoo.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-190},{-20,-190},{-20,-178},{38,-178}},
      color={255,0,255}));
  connect(booScaRepPre.y, reaTPreTarSet.u1)
    annotation (Line(points={{-18,90},{40,90},{40,-90},{58,-90}},
      color={255,0,255}));
  connect(booScaRepShe.y, reaTSheTarSet.u1)
    annotation (Line(points={{-18,50},{20,50},{20,-170},{38,-170}},
      color={255,0,255}));
  connect(greTSetRebHea.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-230},{-20,-230},{-20,-258},{18,-258}},
      color={255,0,255}));
  connect(lesTSetRebCoo.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-270},{-20,-270},{-20,-258},{18,-258}},
      color={255,0,255}));
  connect(booScaRepReb.y, reaTDefSet.u1)
    annotation (Line(points={{-18,10},{0,10},{0,-250},{18,-250}},
      color={255,0,255}));
  connect(reaTPreTarSet.y, orCon4.u1)
    annotation (Line(points={{82,-90},{158,-90}}, color={255,0,255}));
  connect(reaTDefSet.y, orReaTSheTarSetTDefSet.u2)
    annotation (Line(points={{42,-250},{80,-250},{80,-198},{98,-198}},
      color={255,0,255}));
  connect(reaTSheTarSet.y, orReaTSheTarSetTDefSet.u1)
    annotation (Line(points={{62,-170},{80,-170},{80,-190},{98,-190}},
      color={255,0,255}));
  connect(orReaTSheTarSetTDefSet.y, orCon4.u2)
    annotation (Line(points={{122,-190},{140,-190},{140,-98},{158,-98}},
      color={255,0,255}));
  connect(orCon4.y, orCon1234.u2)
    annotation (Line(points={{182,-90},{200,-90},{200,32},{218,32}},
      color={255,0,255}));
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
The electricity demand of the building where the zone is located is higher than an
electricity demand threshold during the load-shed demand flexibility mode.
</li>
<li>
The zone temperature is close enough to the zone temperature setpoint during the
load-shed demand flexibility mode.
</li>
<li>
The zone temperature setpoint has not reached a temperature setpoint limit that is
imposed by the respective demand flexibility mode.
</li>
</ol>
<p>
If any one of the above conditions is not met for a zone, the disqualified zone flag
<code>disFla</code> for that zone will be set to <code>true</code>. Otherwise,
<code>disFla</code> is set to <code>false</code>.
</p>
<p>
The parameter <code>airConMod</code> represents the air conditioning mode.
<code>airConMod = true</code> represents the heating mode, whereas
<code>airConMod = false</code> represents the cooling mode. The demand flexibility
mode <code>demFleMod</code> can take values of <i>0</i> (pre-cool or pre-heat mode),
<i>1</i> (default mode), <i>2</i> (load-shed mode), and <i>3</i> (load-rebound mode). 
</p>
<p>
Zone temperature difference, an internal variable, is defined as the zone
temperature (<code>TZon</code>) minus the zone temperature setpoint
(<code>TZonSet</code>). The zone temperature setpoint input variable
<code>TZonSet</code> must represent a heating setpoint when
<code>airConMod = true</code>, and it must represent a cooling setpoint when
<code>airConMod = false</code>.
</p>
<p>
The input variables <code>TPreTarSet</code>, <code>TDefSet</code>, and
<code>TSheTarSet</code> must represent reasonable values within a range. For example,
<code>TPreTarSet &gt; TDefSet &gt; TSheTarSet</code> must hold if the air
conditioning system is in the heating mode (<code>airConMod = true</code>), and
<code>TPreTarSet &lt; TDefSet &lt; TSheTarSet</code> must hold if the air
conditioning system is in the cooling mode (<code>airConMod = false</code>).
</p>
<p>
Below is a detailed discussion of each of the 4 conditions. 
</p>
<h4>Condition 1</h4>
<p>
When the rogue zone flag input <code>rouZonFla</code> is true for a specific zone,
this zone is a rogue zone. Therefore, this zone is not qualified to participate in
the zone temperature comparison. Hence, <code>disFla = true</code> for this zone.
Otherwise, another condition needs to be not met for <code>disFla</code> to become
<code>true</code>. 
</p>
<h4>Condition 2</h4>
<p>
When the electricity demand of the building is lower than the electricity demand
threshold minus a hysteresis (<code>PBui  &lt;= PBuiThr - PBuiHys</code>), and the
demand flexibility mode <code>demFleMod = 2</code> (load-shed mode), all zones in
the building will have <code>disFla = true</code>. When the electricity demand of
the building is higher than the electricity demand threshold
(<code>PBui &gt; PBuiThr</code>), or <code>demFleMod</code> has any other value
except <i>2</i>, another condition needs to be not met for <code>disFla</code> to
become <code>true</code>. This electricity demand condition is considered only if
the flag of using demand-based control <code>use_demCon</code> is true. 
</p>
<h4>Condition 3</h4>
<p>
If the zone temperature setpoint <code>TZonSet</code> and the zone temperature
<code>TZon</code> meet any one of the following equations, this zone will have
<code>disFla = true</code>. Note that <code>dTSheThr</code> is the zone temperature
difference threshold, and <code>dTSheHys</code> is the zone temperature difference
hysteresis.
</p>
<ul>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 2</code>, and
<code>TZon - TZonSet &gt;=  dTSheThr + dTSheHys</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 2</code>, and
<code>-(TZon - TZonSet) &gt;=  dTSheThr + dTSheHys</code>
</li>
</ul>
<p>
If the zone temperature setpoint <code>TZonSet</code> and the zone temperature
<code>TZon</code> meet any one of the following equations, another condition needs
to be not met for <code>disFla</code> to become <code>true</code>:
</p>
<ul>
<li>
<code>demFleMod ≠ 2</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 2</code>, and
<code>TZon - TZonSet &lt;  dTSheThr</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 2</code>, and
<code>-(TZon - TZonSet) &lt;  dTSheThr</code>
</li>
</ul>
<h4>Condition 4</h4>
<p>
If the zone temperature setpoint <code>TZonSet</code> of a zone meets any one of the
following equations, this zone will have <code>disFla = true</code>. Since the
presence of a temperature resolution from the external temperature setpoint
controller will make <code>TZonSet</code> only take a finite set of discrete values,
the temperature resolution interval <code>TResInt</code> is used in the following
equations. <code>0.99 * TResInt</code> is used to prevent unexpected behaviors from
higher-level logic blocks under edge-case operations, while being less than
<code>1 * TResInt</code> to achieve the same behaviors as the case where
<code>TResInt</code> were not used under non-edge-case operations. On the other hand,
<code>0.5 * TResInt</code> is used as a hysteresis value:
</p>
<ul>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &gt; TPreTarSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &lt; TSheTarSet + 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &gt; TDefSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &lt; TPreTarSet + 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &gt; TSheTarSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &lt; TDefSet + 0.99 * TResInt</code>
</li>
</ul>
<p>
If the zone temperature setpoint <code>TZonSet</code> of a zone meets any one of the
following conditions, another condition needs to be not met for <code>disFla</code>
to become <code>true</code>:
</p>
<ul>
<li>
<code>demFleMod = 1</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &lt; TPreTarSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &gt; TSheTarSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = true</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &lt; TDefSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &gt; TPreTarSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &lt; TSheTarSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = false</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &gt; TDefSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
</ul>
</html>"));
end ZoneQualification;
