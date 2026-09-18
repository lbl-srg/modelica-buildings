within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences;
block Enable "Zone enablement"

  parameter Real dTSheThr(
    min=0,
    unit="K",
    displayUnit="K")
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)"
    annotation (Dialog(group="Temperature setpoint parameters"));
  parameter Real dTSheHys(
    min=0,
    unit="K",
    displayUnit="K")
    "Hysteresis for the temperature difference during the load-shed mode"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real PBuiHys(
    min=0,
    start=1,
    unit="W")=0.05*PBui_nominal
    "Hysteresis for the electricity demand of the building"
    annotation (Dialog(enable = use_demCon, tab="Advanced", group="Hysteresis"));
  parameter Real PBui_nominal(
    min=0,
    start=1,
    unit="W")
    "Nominal electricity demand of the building"
    annotation (Dialog(enable = use_demCon, group="Electricity demand parameters"));
  parameter Real TResInt(
    min=0,
    unit="K",
    displayUnit="K")
    "Temperature resolution interval used by an external zone temperature controller"
    annotation (Dialog(group="Temperature setpoint parameters"));
  parameter Boolean use_demCon
    "True: use demand-based control"
    annotation (Dialog(group="Electricity demand parameters"));
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Zone temperature setpoint, can be either a heating setpoint or a cooling setpoint, depending on the air conditioning mode"
    annotation (Placement(transformation(extent={{-300,200},{-260,240}}),
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
    annotation (Placement(transformation(extent={{-300,280},{-260,320}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBui(
    final unit="W",
    final quantity="Power")
    if use_demCon
    "Electricity demand of the building"
    annotation (Placement(transformation(extent={{-300,320},{-260,360}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-300,360},{-260,400}}),
      iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-300,100},{-260,140}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput enaFla[nZon]
    "Flags to enable certain zones for the setpoint change operation; true to enable a zone"
    annotation (Placement(transformation(extent={{260,10},{300,50}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.And andCon12[nZon] "Both Condition 1 and Condition 2 are met"
    annotation (Placement(transformation(extent={{60,360},{80,380}})));
  Buildings.Controls.OBC.CDL.Logical.And andCon123[nZon]
    "All Condition 1, Condition 2, and Condition 3 are met"
    annotation (Placement(transformation(extent={{120,240},{140,260}})));
  Buildings.Controls.OBC.CDL.Logical.And andCon1234[nZon]
    "All Condition 1, Condition 2, Condition 3, or Condition 4 are met"
    annotation (Placement(transformation(extent={{220,20},{240,40}})));
  Buildings.Controls.OBC.CDL.Reals.Greater grePBui(
    final h=PBuiHys)
    if use_demCon
    "Check whether the building electricity demand is greater than the building electricity demand threshold"
    annotation (Placement(transformation(extent={{-220,320},{-200,340}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGrePBui if use_demCon
    "Check whether the building electricity demand is no greater than the building electricity demand threshold"
    annotation (Placement(transformation(extent={{-160,320},{-140,340}})));
  Buildings.Controls.OBC.CDL.Logical.And andPBuiLoaShe if use_demCon
    "Building electricity demand is less than a threshold and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{-60,320},{-40,340}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepCon2(
    final nout=nZon)
    if use_demCon
    "Scaling a boolean scalar that indicates Condition 2 is met"
    annotation (Placement(transformation(extent={{20,320},{40,340}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conDisCon2[nZon](
    final k=fill(true, nZon))
    if not use_demCon
    "When logic for Condition 2 is disabled, output true in place of the Condition 2 logic"
    annotation (Placement(transformation(extent={{20,280},{40,300}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesDTZon[nZon](
    final t=fill(dTSheThr,nZon),
    final h=fill(dTSheHys,nZon))
    "The zone temperature difference is less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesDTZon[nZon]
    "The zone temperature difference is no less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-40,240},{-20,260}})));
  Buildings.Controls.OBC.CDL.Logical.And andDTZonLoaShe[nZon]
    "The zone temperature difference is equal or greater than the load-shed mode zone temperature difference threshold, and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{20,240},{40,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(
    final nout=nZon) "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetPreHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is greater than the pre-heat target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetPreCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is less than the pre-cool target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetSheHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is less than the load-shed heating target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetSheCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is greater than the load-shed cooling target temperature setpoint, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSetRebHea[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "The zone heating temperature setpoint is greater than the default heating temperature setpoint during the load-rebound mode, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSetRebCoo[nZon](
    final h=fill(0.5*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "The zone cooling temperature setpoint is less than the default cooling temperature setpoint during the load-rebound mode, taking into account of the temperature resolution"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntPreHea[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Subtract 0.99 times the temperature resolution interval during the pre-heat mode"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntPreCoo[nZon](
    final p=fill(0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Add 0.99 times the temperature resolution interval during the pre-cool mode"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntSheHea[nZon](
    final p=fill(0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Add 0.99 times the temperature resolution interval during the heating load-shed mode"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntSheCoo[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Subtract 0.99 times the temperature resolution interval during the cooling load-shed mode"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subTResIntRebHea[nZon](
    final p=fill(-0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Subtract 0.99 times the temperature resolution interval during the heating load-rebound mode"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addTResIntRebCoo[nZon](
    final p=fill(0.99*TResInt,nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Add 0.99 times the temperature resolution interval during the cooling load-rebound mode"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTPreTarSet[nZon]
    "In the pre-cool or pre-heat mode, the zone temperature setpoint has reached the pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTSheTarSet[nZon]
    "In the load-shed mode, the zone temperature setpoint has reached the load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And reaTDefSet[nZon]
    "In the load-rebound mode, the zone temperature setpoint has reached the default temperature setpoint"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepPre(
    final nout=nZon)
    "Repeat the boolean scalar for being in the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepReb(
    final nout=nZon) "Repeat the boolean scalar for being in the load-rebound mode"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheReb[nZon]
    "The zone temperature setpoint has reached a setpoint limit during the load-shed mode and the load-rebound mode"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquPre
    "Check whether it is the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntPre(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.preCondition)
    "Integer constant for the pre-cool or pre-heat mode"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntReb(
    final k=Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadRebound)
    "Integer constant for the load-rebound mode"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquReb
    "Check whether it is the load-rebound mode"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not notRouZon[nZon]
    "True if the corresponding zone is not a rogue zone, indicating that Condition 1 is met"
    annotation (Placement(transformation(extent={{-160,370},{-140,390}})));
  Buildings.Controls.OBC.CDL.Logical.Not notAndPBuiLoaShe if use_demCon
    "Building electricity demand is more than a threshold, or the system is not in the load-shed mode"
    annotation (Placement(transformation(extent={{-20,320},{0,340}})));
  Buildings.Controls.OBC.CDL.Logical.Not notAndDTZonLoaShe[nZon]
    "The zone temperature difference is less than the load-shed mode zone temperature difference threshold, or the system is not in the load-shed mode, indicating that Condition 3 is met"
    annotation (Placement(transformation(extent={{60,240},{80,260}})));
  Buildings.Controls.OBC.CDL.Logical.Or orReaLimSheDefPre[nZon]
    "The zone temperature setpoint has reached a setpoint limit during the load-shed mode, the load-rebound mode, or the pre-heat or pre-cool mode."
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not con4[nZon]
    "The zone temperature setpoint has not reached a setpoint limit, or the system is at the default demand flexibility mode, indicating that Condition 4 is met"
    annotation (Placement(transformation(extent={{180,-20},{200,0}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonHea[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-180,260},{-160,280}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonCoo[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Zone temperature difference during the cooling mode"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTPreTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the pre-heat target temperature setpoint is less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTSheTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the load-shed target temperature setpoint is greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-300},{-100,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesTPreTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the pre-heat target temperature setpoint is no less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-260},{-40,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreTSheTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Check if the load-shed target temperature setpoint is no greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-300},{-40,-280}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greTPreTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the pre-cool target temperature setpoint is greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-340},{-100,-320}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesTSheTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the load-shed target temperature setpoint is less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-380},{-100,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreTPreTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the pre-cool target temperature setpoint is no greater than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-340},{-40,-320}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesTSheTarSet[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Check if the load-shed target temperature setpoint is no less than the default temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-380},{-40,-360}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarHeaSet[nZon](message=
        fill("Error: the pre-heat target temperature setpoint must be greater than or equal to the default temperature setpoint during the heating mode.",
        nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the pre-heat target temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{0,-260},{20,-240}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarHeaSet[nZon](message=
        fill("Error: the load-shed target temperature setpoint must be less than or equal to the default temperature setpoint during the heating mode.",
        nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Error message for the load-shed target heating temperature setpoint during the heating mode"
    annotation (Placement(transformation(extent={{0,-300},{20,-280}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTPreTarCooSet[nZon](message=
        fill("Error: the pre-cool target temperature setpoint must be less than or equal to the default temperature setpoint during the cooling mode.",
        nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the pre-cool target temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{0,-340},{20,-320}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesTSheTarCooSet[nZon](message=
        fill("Error: the load-shed target temperature setpoint must be greater than or equal to the default temperature setpoint during the cooling mode.",
        nZon))
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Error message for the load-shed target cooling temperature setpoint during the cooling mode"
    annotation (Placement(transformation(extent={{0,-380},{20,-360}})));
equation
  connect(andCon12.y, andCon123.u1)
    annotation (Line(points={{82,370},{100,370},{100,250},{118,250}},
      color={255,0,255}));
  connect(andCon123.y, andCon1234.u1)
    annotation (Line(points={{142,250},{200,250},{200,30},{218,30}},
      color={255,0,255}));
  connect(andCon1234.y, enaFla)
    annotation (Line(points={{242,30},{280,30}}, color={255,0,255}));
  connect(PBui, grePBui.u1)
    annotation (Line(points={{-280,340},{-240,340},{-240,330},{-222,330}},
      color={0,0,127}));
  connect(PBuiThr, grePBui.u2)
    annotation (Line(points={{-280,300},{-240,300},{-240,322},{-222,322}},
      color={0,0,127}));
  connect(grePBui.y, notGrePBui.u)
    annotation (Line(points={{-198,330},{-162,330}}, color={255,0,255}));
  connect(notGrePBui.y, andPBuiLoaShe.u1)
    annotation (Line(points={{-138,330},{-62,330}},color={255,0,255}));
  connect(intEquShe.y, andPBuiLoaShe.u2)
    annotation (Line(points={{-78,130},{-70,130},{-70,322},{-62,322}},
      color={255,0,255}));
  connect(booScaRepCon2.y, andCon12.u2)
    annotation (Line(points={{42,330},{50,330},{50,362},{58,362}},
      color={255,0,255}));
  connect(conDisCon2.y, andCon12.u2)
    annotation (Line(points={{42,290},{50,290},{50,362},{58,362}},
      color={255,0,255}));
  connect(demFleMod, intEquShe.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,130},{-102,130}},
      color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2)
    annotation (Line(points={{-138,110},{-120,110},{-120,122},{-102,122}},
      color={255,127,0}));
  connect(TZon, dTZonHea.u1)
    annotation (Line(points={{-280,260},{-240,260},{-240,276},{-182,276}},
      color={0,0,127}));
  connect(TZonSet, dTZonHea.u2)
    annotation (Line(points={{-280,220},{-200,220},{-200,264},{-182,264}},
      color={0,0,127}));
  connect(lesDTZon.y, notLesDTZon.u)
    annotation (Line(points={{-78,250},{-42,250}}, color={255,0,255}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-78,130},{-42,130}}, color={255,0,255}));
  connect(notLesDTZon.y, andDTZonLoaShe.u1)
    annotation (Line(points={{-18,250},{18,250}}, color={255,0,255}));
  connect(booScaRepShe.y, andDTZonLoaShe.u2)
    annotation (Line(points={{-18,130},{0,130},{0,242},{18,242}},
      color={255,0,255}));
  connect(conIntPre.y, intEquPre.u2)
    annotation (Line(points={{-138,150},{-120,150},{-120,162},{-102,162}},
      color={255,127,0}));
  connect(conIntReb.y, intEquReb.u2)
    annotation (Line(points={{-138,70},{-120,70},{-120,82},{-102,82}},
      color={255,127,0}));
  connect(demFleMod, intEquPre.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,170},{-102,170}},
      color={255,127,0}));
  connect(demFleMod, intEquReb.u1)
    annotation (Line(points={{-280,120},{-180,120},{-180,90},{-102,90}},
      color={255,127,0}));
  connect(TZonSet, greTSetPreHea.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,10},{-62,10}},
      color={0,0,127}));
  connect(TZonSet, lesTSetSheHea.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,-70},{-62,-70}},
      color={0,0,127}));
  connect(TZonSet, lesTSetPreCoo.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,-30},{-62,-30}},
      color={0,0,127}));
  connect(TZonSet, greTSetSheCoo.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,-110},{-62,-110}},
      color={0,0,127}));
  connect(TZonSet, greTSetRebHea.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,-150},{-62,-150}},
      color={0,0,127}));
  connect(TZonSet, lesTSetRebCoo.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,-190},{-62,-190}},
      color={0,0,127}));
  connect(TPreTarSet, subTResIntPreHea.u)
    annotation (Line(points={{-280,-80},{-180,-80},{-180,-10},{-142,-10}},
      color={0,0,127}));
  connect(TPreTarSet, addTResIntPreCoo.u)
    annotation (Line(points={{-280,-80},{-180,-80},{-180,-50},{-142,-50}},
      color={0,0,127}));
  connect(TSheTarSet, addTResIntSheHea.u)
    annotation (Line(points={{-280,-160},{-180,-160},{-180,-90},{-142,-90}},
      color={0,0,127}));
  connect(TSheTarSet, subTResIntSheCoo.u)
    annotation (Line(points={{-280,-160},{-180,-160},{-180,-130},{-142,-130}},
      color={0,0,127}));
  connect(TDefSet, subTResIntRebHea.u)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-170},{-142,-170}},
      color={0,0,127}));
  connect(TDefSet, addTResIntRebCoo.u)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-210},{-142,-210}},
      color={0,0,127}));
  connect(subTResIntPreHea.y, greTSetPreHea.u2)
    annotation (Line(points={{-118,-10},{-100,-10},{-100,2},{-62,2}},
      color={0,0,127}));
  connect(addTResIntPreCoo.y, lesTSetPreCoo.u2)
    annotation (Line(points={{-118,-50},{-100,-50},{-100,-38},{-62,-38}},
      color={0,0,127}));
  connect(addTResIntSheHea.y, lesTSetSheHea.u2)
    annotation (Line(points={{-118,-90},{-100,-90},{-100,-78},{-62,-78}},
      color={0,0,127}));
  connect(subTResIntSheCoo.y, greTSetSheCoo.u2)
    annotation (Line(points={{-118,-130},{-100,-130},{-100,-118},{-62,-118}},
      color={0,0,127}));
  connect(subTResIntRebHea.y, greTSetRebHea.u2)
    annotation (Line(points={{-118,-170},{-100,-170},{-100,-158},{-62,-158}},
      color={0,0,127}));
  connect(addTResIntRebCoo.y, lesTSetRebCoo.u2)
    annotation (Line(points={{-118,-210},{-100,-210},{-100,-198},{-62,-198}},
      color={0,0,127}));
  connect(greTSetPreHea.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,10},{-20,10},{-20,-18},{58,-18}},
      color={255,0,255}));
  connect(lesTSetPreCoo.y, reaTPreTarSet.u2)
    annotation (Line(points={{-38,-30},{-20,-30},{-20,-18},{58,-18}},
      color={255,0,255}));
  connect(intEquPre.y, booScaRepPre.u)
    annotation (Line(points={{-78,170},{-42,170}}, color={255,0,255}));
  connect(intEquReb.y, booScaRepReb.u)
    annotation (Line(points={{-78,90},{-42,90}}, color={255,0,255}));
  connect(lesTSetSheHea.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-70},{-20,-70},{-20,-98},{38,-98}},
      color={255,0,255}));
  connect(greTSetSheCoo.y, reaTSheTarSet.u2)
    annotation (Line(points={{-38,-110},{-20,-110},{-20,-98},{38,-98}},
      color={255,0,255}));
  connect(booScaRepPre.y, reaTPreTarSet.u1)
    annotation (Line(points={{-18,170},{40,170},{40,-10},{58,-10}},
      color={255,0,255}));
  connect(booScaRepShe.y, reaTSheTarSet.u1)
    annotation (Line(points={{-18,130},{20,130},{20,-90},{38,-90}},
      color={255,0,255}));
  connect(greTSetRebHea.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-150},{-20,-150},{-20,-178},{18,-178}},
      color={255,0,255}));
  connect(lesTSetRebCoo.y, reaTDefSet.u2)
    annotation (Line(points={{-38,-190},{-20,-190},{-20,-178},{18,-178}},
      color={255,0,255}));
  connect(booScaRepReb.y, reaTDefSet.u1)
    annotation (Line(points={{-18,90},{0,90},{0,-170},{18,-170}},
      color={255,0,255}));
  connect(reaTDefSet.y, orReaLimSheReb.u2)
    annotation (Line(points={{42,-170},{80,-170},{80,-118},{98,-118}},
      color={255,0,255}));
  connect(reaTSheTarSet.y, orReaLimSheReb.u1)
    annotation (Line(points={{62,-90},{80,-90},{80,-110},{98,-110}},
      color={255,0,255}));
  connect(rouZonFla, notRouZon.u)
    annotation (Line(points={{-280,380},{-162,380}}, color={255,0,255}));
  connect(andPBuiLoaShe.y, notAndPBuiLoaShe.u)
    annotation (Line(points={{-38,330},{-22,330}}, color={255,0,255}));
  connect(notAndPBuiLoaShe.y, booScaRepCon2.u)
    annotation (Line(points={{2,330},{18,330}}, color={255,0,255}));
  connect(andDTZonLoaShe.y, notAndDTZonLoaShe.u)
    annotation (Line(points={{42,250},{58,250}}, color={255,0,255}));
  connect(notAndDTZonLoaShe.y, andCon123.u2)
    annotation (Line(points={{82,250},{90,250},{90,242},{118,242}},
      color={255,0,255}));
  connect(reaTPreTarSet.y, orReaLimSheDefPre.u1)
    annotation (Line(points={{82,-10},{120,-10},{120,-30},{138,-30}},
      color={255,0,255}));
  connect(orReaLimSheReb.y, orReaLimSheDefPre.u2)
    annotation (Line(points={{122,-110},{130,-110},{130,-38},{138,-38}},
      color={255,0,255}));
  connect(con4.y, andCon1234.u2)
    annotation (Line(points={{202,-10},{210,-10},{210,22},{218,22}},
      color={255,0,255}));
  connect(orReaLimSheDefPre.y, con4.u)
    annotation (Line(points={{162,-30},{170,-30},{170,-10},{178,-10}},
      color={255,0,255}));
  connect(notRouZon.y, andCon12.u1)
    annotation (Line(points={{-138,380},{-40,380},{-40,370},{58,370}},
      color={255,0,255}));
  connect(TZonSet, dTZonCoo.u1)
    annotation (Line(points={{-280,220},{-200,220},{-200,236},{-182,236}},
      color={0,0,127}));
  connect(TZon, dTZonCoo.u2)
    annotation (Line(points={{-280,260},{-240,260},{-240,224},{-182,224}},
      color={0,0,127}));
  connect(dTZonHea.y, lesDTZon.u)
    annotation (Line(points={{-158,270},{-120,270},{-120,250},{-102,250}},
      color={0,0,127}));
  connect(dTZonCoo.y, lesDTZon.u)
    annotation (Line(points={{-158,230},{-120,230},{-120,250},{-102,250}},
      color={0,0,127}));
  connect(lesTPreTarSet.y,notLesTPreTarSet. u)
    annotation (Line(points={{-98,-250},{-62,-250}},color={255,0,255}));
  connect(greTSheTarSet.y,notGreTSheTarSet. u)
    annotation (Line(points={{-98,-290},{-62,-290}},color={255,0,255}));
  connect(lesTSheTarSet.y,notLesTSheTarSet. u)
    annotation (Line(points={{-98,-370},{-62,-370}},color={255,0,255}));
  connect(greTPreTarSet.y,notGreTPreTarSet. u)
    annotation (Line(points={{-98,-330},{-62,-330}},color={255,0,255}));
  connect(notLesTPreTarSet.y,assMesTPreTarHeaSet. u)
    annotation (Line(points={{-38,-250},{-2,-250}},color={255,0,255}));
  connect(notGreTSheTarSet.y,assMesTSheTarHeaSet. u)
    annotation (Line(points={{-38,-290},{-2,-290}},color={255,0,255}));
  connect(notGreTPreTarSet.y,assMesTPreTarCooSet. u)
    annotation (Line(points={{-38,-330},{-2,-330}},color={255,0,255}));
  connect(notLesTSheTarSet.y,assMesTSheTarCooSet. u)
    annotation (Line(points={{-38,-370},{-2,-370}},color={255,0,255}));
  connect(TDefSet, lesTPreTarSet.u2)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-258},{-122,-258}},
      color={0,0,127}));
  connect(TDefSet, greTSheTarSet.u2)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-298},{-122,-298}},
      color={0,0,127}));
  connect(TDefSet, greTPreTarSet.u2)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-338},{-122,-338}},
      color={0,0,127}));
  connect(TDefSet, lesTSheTarSet.u2)
    annotation (Line(points={{-280,-240},{-180,-240},{-180,-378},{-122,-378}},
      color={0,0,127}));
  connect(TPreTarSet, lesTPreTarSet.u1)
    annotation (Line(points={{-280,-80},{-240,-80},{-240,-250},{-122,-250}},
      color={0,0,127}));
  connect(TPreTarSet, greTPreTarSet.u1)
    annotation (Line(points={{-280,-80},{-240,-80},{-240,-330},{-122,-330}},
      color={0,0,127}));
  connect(TSheTarSet, greTSheTarSet.u1)
    annotation (Line(points={{-280,-160},{-220,-160},{-220,-290},{-122,-290}},
      color={0,0,127}));
  connect(TSheTarSet, lesTSheTarSet.u1)
    annotation (Line(points={{-280,-160},{-220,-160},{-220,-370},{-122,-370}},
      color={0,0,127}));
  annotation (defaultComponentName="zonEna",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-180},{100,180}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-102,220},{98,180}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-260,-400},{260,400}},
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
This block serves to determine whether a zone is enabled to participate in the
setpoint change operation.
</p>
<p>
The parameter <code>airConMod</code> represents the air conditioning mode.
<code>airConMod = Heating</code> represents the heating mode, whereas
<code>airConMod = Cooling</code> represents the cooling mode. The demand flexibility
mode parameter <code>demFleMod</code> can take values of <i>0</i> (pre-cool or
pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), and <i>3</i>
(load-rebound mode).
</p>
<p>
The zone temperature setpoint input variable <code>TZonSet</code> must represent a
heating setpoint when <code>airConMod = Heating</code>, and it must represent a cooling
setpoint when <code>airConMod = Cooling</code>. The input variables
<code>TPreTarSet</code>, <code>TDefSet</code>, and <code>TSheTarSet</code> must
represent specific sets of values. For example, <code>TPreTarSet &gt;= TDefSet &gt;=
TSheTarSet</code> must hold if the air conditioning system is in the heating mode
(<code>airConMod = Heating</code>), and <code>TPreTarSet &lt;= TDefSet &lt;=
TSheTarSet</code> must hold if the air conditioning system is in the cooling mode
(<code>airConMod = Cooling</code>).
</p>
<p>
The following <i>4</i> conditions are used to determine if a zone should be enabled
to participate in the setpoint change operation. Only if all <i>4</i> conditions are
met for a zone, the enabled flag <code>enaFla</code> for that zone will be set to
<code>true</code>. If any one of the above conditions is not met,
<code>enaFla</code> will be set to <code>false</code>. If the parameter
<code>use_demCon</code> is <code>false</code>, Condition <i>2</i> is not used.
Otherwise, Condition <i>2</i> is used.
</p>
<p>
Below is a detailed discussion of each of the <i>4</i> conditions:
</p>
<h4>Condition 1</h4>
<p>
When the rogue zone flag input <code>rouZonFla</code> is true for a specific zone,
this zone is a rogue zone. Therefore, this zone is not enabled to participate in
the zone temperature comparison. Hence, <code>enaFla = false</code> for this zone.
</p>
<h4>Condition 2</h4>
<p>
If the electricity demand of the building <code>PBui</code> and the electricity
demand <code>PBuiThr</code> meet any one of the following equations, this zone will
have <code>enaFla = false</code>. Note that <code>PBuiHys</code> is the electricity
demand hysteresis, with a default value of <code>0.05 * PBui_nominal</code>:
</p>
<ul>
<li>
<code>demFleMod = 2</code>, and <code>PBui  &lt;= PBuiThr - PBuiHys</code>
</li>
</ul>
<p>
If the electricity demand of the building <code>PBui</code> and the electricity
demand <code>PBuiThr</code> meet any one of the following equations, Condition
<i>2</i> is met:
</p>
<ul>
<li>
<code>demFleMod ≠ 2</code>
</li>
<li>
<code>demFleMod = 2</code>, and <code>PBui  &gt; PBuiThr</code>
</li>
</ul>
<h4>Condition 3</h4>
<p>
Zone temperature difference <code>dTZon</code>, an internal variable, is defined as
the zone temperature <code>TZon</code> minus the zone temperature setpoint
<code>TZonSet</code> during the heating mode (<code>airConMod = Heating</code>). On the
other hand, <code>dTZon</code> is defined as <code>TZonSet</code> minus
<code>TZon</code> during the cooling mode (<code>airConMod = Cooling</code>).
</p>
<p>
If <code>dTZon</code> meets the following equation, this zone will have
<code>enaFla = false</code>. Note that <code>dTSheThr</code> is the zone temperature
difference threshold, and <code>dTSheHys</code> is the zone temperature difference
hysteresis:
</p>
<ul>
<li>
<code>demFleMod = 2</code> and <code>dTZon &gt;=  dTSheThr + dTSheHys</code>
</li>
</ul>
<p>
If <code>dTZon</code> meets any one of the following equations, Condition <i>3</i>
is met:
</p>
<ul>
<li>
<code>demFleMod ≠ 2</code>
</li>
<li>
<code>demFleMod = 2</code> and <code>dTZon &lt;  dTSheThr</code>
</li>
</ul>
<h4>Condition 4</h4>
<p>
If the zone temperature setpoint <code>TZonSet</code> of a zone meets any one of the
following equations, this zone will have <code>enaFla = false</code>. Since the
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
<code>airConMod = Heating</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &gt; TPreTarSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = Heating</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &lt; TSheTarSet + 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = Heating</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &gt; TDefSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &lt; TPreTarSet + 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &gt; TSheTarSet - 0.99 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &lt; TDefSet + 0.99 * TResInt</code>
</li>
</ul>
<p>
If the zone temperature setpoint <code>TZonSet</code> of a zone meets any one of the
following conditions, Condition <i>4</i> is met:
</p>
<ul>
<li>
<code>demFleMod = 1</code>
</li>
<li>
<code>airConMod = Heating</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &lt; TPreTarSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = Heating</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &gt; TSheTarSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = Heating</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &lt; TDefSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 0</code>, and
<code>TZonSet &gt; TPreTarSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 2</code>, and
<code>TZonSet &lt; TSheTarSet - 0.99 * TResInt - 0.5 * TResInt</code>
</li>
<li>
<code>airConMod = Cooling</code>, and <code>demFleMod = 3</code>, and
<code>TZonSet &gt; TDefSet + 0.99 * TResInt + 0.5 * TResInt</code>
</li>
</ul>
</html>"));
end Enable;
