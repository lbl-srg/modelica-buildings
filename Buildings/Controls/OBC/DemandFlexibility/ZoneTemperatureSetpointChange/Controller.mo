within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange;
block Controller
  "Controller for zone heating or cooling temperature setpoint change"

  parameter Real dTPre(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Setpoint change delta for the pre-cool or the pre-heat mode (positive value)"
    annotation (Dialog(enable=zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
      group="Temperature setpoint parameters"));
  parameter Real dTShe(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-shed mode (positive value)"
    annotation (Dialog(enable=zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
      group="Temperature setpoint parameters"));
  parameter Real dTReb(
    min=0,
    start=1,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-rebound mode (positive value)"
    annotation (Dialog(enable=zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
      group="Temperature setpoint parameters"));
  parameter Real dT_small(
    min=0,
    unit="K",
    displayUnit="K")=0.1
    "A small temperature delta, used to reduce the effects of rounding errors when comparing the current zone temperature setpoint to the target setpoints"
    annotation (Dialog(tab="Advanced", group="Temperature setpoint parameters"));
  parameter Real dTSheThr(
    min=0,
    unit="K",
    displayUnit="K")
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)"
    annotation (Dialog(group="Temperature setpoint parameters"));
  parameter Real PBuiRedDifMin(
    final unit="W",
    final start=1,
    final quantity="Power",
    final min=0)
    "Minimum difference between the electricity demand reduction target and the actual reduction"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
      group="Electricity demand parameters"));
  parameter Real PBuiRedTarCon(
    final unit="W",
    final start=0,
    final quantity="Power",
    final min=0)
    "Constant target electricity demand reduction of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3,
      group="Electricity demand parameters"));
  parameter Real PBuiRed_nominal(
    final unit="W",
    final start=1,
    final quantity="Power",
    final min=0)
    "Nominal electricity demand reduction of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
      group="Electricity demand parameters"));
  parameter Real PBuiRedHys(
    final unit="W",
    final quantity="Power",
    final min=0)=0.05*PBuiRed_nominal
    "Hysteresis for the electricity demand reduction of the building"
    annotation (Dialog(tab="Advanced", group="Hysteresis"));
  parameter Real setChaWaiTim(
    min=0,
    unit="s")
    "Sampling period for the setpoint change";
  parameter Real TPreTarSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Pre-cool or pre-heat target temperature setpoint";
  parameter Real TSheTarSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Load-shed target temperature setpoint";
  parameter Real TDefSet[nZon](
    final unit=fill("K", nZon),
    displayUnit=fill("degC", nZon),
    final quantity=fill("ThermodynamicTemperature", nZon))
    "Default temperature setpoint";
  parameter Boolean occStaInt
    "Intended occupancy status; true to indicate that this block is used to control the occupied setpoints; false to control the unoccupied setpoints";
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Integer nSel(min=1, max=nZon)
    "Number of zones to select for prioritization";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode airConMod
    "Air conditioning mode";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant zonConVar
    "Zone control variant, from Variant 1 through Variant 4";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZon[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-380,-160},{-340,-120}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-380,-200},{-340,-160}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRedTarVar(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Variable target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-380,-40},{-340,0}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRed(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Electricity demand reduction of the building (baseline demand minus actual demand)"
    annotation (Placement(transformation(extent={{-380,-100},{-340,-60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput                        uQua[nZon]
    "True if the zone is qualified for zone temperature setpoint change"
    annotation (Placement(transformation(extent={{-380,100},{-340,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput occSta
    "Occupancy status; true: occupied; false: unoccupied" annotation (Placement(
        transformation(extent={{-380,180},{-340,220}}), iconTransformation(
          extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-380,-240},{-340,-200}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{340,-160},{380,-120}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Not not1[nZon] if nZon == 1
    "When there is only one zone in a building, skip zone prioritization"
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nZon]
    "The zone is not qualified for zone temperature setpoint change based on external fault rules"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3[nZon]
    "If any one of the three conditions is true, disable a zone from zone prioritization and zone setpoint change"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4[nZon]
    "If any one of the four conditions is true, disable a zone from zone prioritization and zone setpoint change"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5[nZon]
    "If any one of the five conditions is true, disable a zone from zone prioritization and zone setpoint change"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2[nZon]
    "If any one of the two conditions is true, disable a zone from zone prioritization and zone setpoint change"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    "The occupancy status is not the same as the intended occupancy status"
    annotation (Placement(transformation(extent={{-240,180},{-220,200}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conOccStaInt(k=occStaInt)
    "Boolean constant for the intended occupancy status"
    annotation (Placement(transformation(extent={{-300,140},{-280,160}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand eleDem(
    PBuiRedDifMin=PBuiRedDifMin,
    PBuiRed_nominal=PBuiRed_nominal,
    PBuiRedHys=PBuiRedHys)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Block that compares electricity demand reduction and its target"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonHea[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dTZonCoo[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Zone temperature difference during the cooling mode"
    annotation (Placement(transformation(extent={{-280,40},{-260,60}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold lesDTZon[nZon](final t=fill(
        dTSheThr, nZon), final h=fill(dTSheThr*0.5, nZon))
    "The zone temperature difference is less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesDTZon[nZon]
    "The zone temperature difference is no less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntShe(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-180,10},{-160,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRepShe(final
      nout=nZon) "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Logical.And andDTZonLoaShe[nZon]
    "The zone temperature difference is equal or greater than the load-shed mode zone temperature difference threshold, and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conPBuiRedTar(final k=
        PBuiRedTarCon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
    "A constant for the target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repPBuiShe(final
      nout=nZon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Repeat the flag of needing electricity demand shed as a vector"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant conNotEleDem[nZon](final k=
        fill(true, nZon))
    if zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      and zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "When the electricity demand check is disabled, output true in place of the electricity demand check logic"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nZon]
    "True if no electricity demand reduction is needed"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound
    lowUppBou(
    final dTSheThr=dTSheThr,
    final dT_small=dT_small,
    final airConMod=airConMod,
    final nZon=nZon,
    TPreTarSet=TPreTarSet,
    TSheTarSet=TSheTarSet,
    TDefSet=TDefSet) "Zone setpoint lower and upper bound"
    annotation (Placement(transformation(extent={{-20,-118},{0,-82}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Prioritization
    zonPri(
    final nZon=nZon,
    final airConMod=airConMod)
    if nZon > 1
    "The zone prioritization logic block"
    annotation (Placement(transformation(extent={{180,-140},{200,-120}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment
    zonSetAdj[nZon](
    final dTPre=fill(dTPre, nZon),
    final dTShe=fill(dTShe, nZon),
    final dTReb=fill(dTReb, nZon),
    TPreTarSet={TPreTarSet[i] for i in 1:nZon},
    TDefSet={TDefSet[i] for i in 1:nZon},
    TSheTarSet={TSheTarSet[i] for i in 1:nZon},
    final airConMod=fill(airConMod, nZon),
    final use_mulSteSetCha=fill(zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
        nZon)) "The zone setpoint adjustment logic block"
    annotation (Placement(transformation(extent={{240,-180},{260,-160}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSetCha[nZon](
    final samplePeriod=fill(setChaWaiTim,nZon))
    "Sampling block for the setpoint change"
    annotation (Placement(transformation(extent={{300,-150},{320,-130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repDemFleMod(
    final nout=nZon)
    "Repeat the demand flexibility mode as a vector"
    annotation (Placement(transformation(extent={{-240,-230},{-220,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conNSel(
    final k=nSel)
    if nZon>1
    "A constant for the number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(final nout=nZon)
    "Repeat the boolean scalar"
    annotation (Placement(transformation(extent={{-200,180},{-180,200}})));
equation
  connect(TCurZon, dTZonHea.u1) annotation (Line(points={{-360,-140},{-320,-140},
          {-320,96},{-282,96}},  color={0,0,127}));
  connect(TCurZon, dTZonCoo.u2) annotation (Line(points={{-360,-140},{-320,-140},
          {-320,44},{-282,44}},  color={0,0,127}));
  connect(TCurZonSet, dTZonHea.u2) annotation (Line(points={{-360,-180},{-300,-180},
          {-300,84},{-282,84}},  color={0,0,127}));
  connect(TCurZonSet, dTZonCoo.u1) annotation (Line(points={{-360,-180},{-300,-180},
          {-300,56},{-282,56}},  color={0,0,127}));
  connect(dTZonHea.y, lesDTZon.u) annotation (Line(points={{-258,90},{-200,90},{
          -200,60},{-162,60}},    color={0,0,127}));
  connect(dTZonCoo.y, lesDTZon.u) annotation (Line(points={{-258,50},{-200,50},{
          -200,60},{-162,60}},    color={0,0,127}));
  connect(lesDTZon.y, notLesDTZon.u)
    annotation (Line(points={{-138,60},{-122,60}}, color={255,0,255}));
  connect(notLesDTZon.y, andDTZonLoaShe.u1) annotation (Line(points={{-98,60},{-80,
          60},{-80,50},{-62,50}},
                                color={255,0,255}));
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-360,-220},{-260,-220},
          {-260,20},{-182,20}},            color={255,127,0}));
  connect(demFleMod, repDemFleMod.u)
    annotation (Line(points={{-360,-220},{-242,-220}},
                                                     color={255,127,0}));
  connect(demFleMod, lowUppBou.demFleMod) annotation (Line(points={{-360,-220},{
          -260,-220},{-260,-89.2},{-22,-89.2}},color={255,127,0}));
  connect(conIntShe.y, intEquShe.u2) annotation (Line(points={{-218,-10},{-200,-10},
          {-200,12},{-182,12}},        color={255,127,0}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-158,20},{-122,20}}, color={255,0,255}));
  connect(booScaRepShe.y, andDTZonLoaShe.u2) annotation (Line(points={{-98,20},{
          -80,20},{-80,42},{-62,42}},     color={255,0,255}));
  connect(TCurZon, zonPri.TZon) annotation (Line(points={{-360,-140},{-320,-140},
          {-320,-128},{178,-128}},
                             color={0,0,127}));
  connect(TCurZonSet, zonPri.TZonSet) annotation (Line(points={{-360,-180},{-70,
          -180},{-70,-132},{178,-132}},
                              color={0,0,127}));
  connect(TCurZonSet, lowUppBou.TZonSet) annotation (Line(points={{-360,-180},{-70,
          -180},{-70,-110.8},{-22,-110.8}},
                                        color={0,0,127}));
  connect(TCurZonSet, zonSetAdj.TCurZonSet) annotation (Line(points={{-360,-180},
          {-70,-180},{-70,-176},{238,-176}},
                                           color={0,0,127}));
  connect(repDemFleMod.y, zonSetAdj.demFleMod) annotation (Line(points={{-218,-220},
          {140,-220},{140,-170},{238,-170}},
                                          color={255,127,0}));
  connect(conNSel.y, zonPri.nSel) annotation (Line(points={{82,-150},{100,-150},
          {100,-136},{178,-136}},
                        color={255,127,0}));
  connect(PBuiRedTarVar, eleDem.PBuiRedTar) annotation (Line(points={{-360,-20},
          {-280,-20},{-280,-44},{-122,-44}}, color={0,0,127}));
  connect(PBuiRed, eleDem.PBuiRed) annotation (Line(points={{-360,-80},{-280,-80},
          {-280,-56},{-122,-56}}, color={0,0,127}));
  connect(conPBuiRedTar.y, eleDem.PBuiRedTar) annotation (Line(points={{-158,-10},
          {-140,-10},{-140,-44},{-122,-44}},
                                  color={0,0,127}));
  connect(eleDem.need_PBuiShe, repPBuiShe.u) annotation (Line(points={{-98,-50},
          {-82,-50}},                     color={255,0,255}));
  connect(repPBuiShe.y, not3.u) annotation (Line(points={{-58,-50},{-22,-50}},
                                               color={255,0,255}));
  connect(conNotEleDem.y, not3.u) annotation (Line(points={{-58,-10},{-40,-10},{
          -40,-50},{-22,-50}},
                             color={255,0,255}));
  connect(andDTZonLoaShe.y,or3. u2) annotation (Line(points={{-38,50},{-20,50},{
          -20,92},{-2,92}},     color={255,0,255}));
  connect(or3.y,or4. u1)
    annotation (Line(points={{22,100},{40,100},{40,50},{58,50}},
                                                       color={255,0,255}));
  connect(not3.y,or4. u2) annotation (Line(points={{2,-50},{40,-50},{40,42},{58,
          42}},          color={255,0,255}));
  connect(or4.y,or5. u1) annotation (Line(points={{82,50},{100,50},{100,10},{118,
          10}},     color={255,0,255}));
  connect(lowUppBou.reach_lowUppBou,or5. u2) annotation (Line(points={{2,-100},{
          60,-100},{60,2},{118,2}},  color={255,0,255}));
  connect(or5.y, zonPri.disFla) annotation (Line(points={{142,10},{160,10},{160,
          -124},{178,-124}},     color={255,0,255}));
  connect(or5.y, not1.u) annotation (Line(points={{142,10},{160,10},{160,-50},{178,
          -50}},             color={255,0,255}));
  connect(not1.y, zonSetAdj.uEna) annotation (Line(points={{202,-50},{220,-50},{
          220,-164},{238,-164}}, color={255,0,255}));
  connect(zonPri.yEna, zonSetAdj.uEna) annotation (Line(points={{202,-130},{220,
          -130},{220,-164},{238,-164}},
                                  color={255,0,255}));
  connect(zonSetAdj.TComZonSet, samSetCha.u) annotation (Line(points={{262,-170},
          {280,-170},{280,-140},{298,-140}},
                                       color={0,0,127}));
  connect(samSetCha.y, TComZonSet)
    annotation (Line(points={{322,-140},{360,-140}},
                                               color={0,0,127}));
  connect(occSta, xor.u1) annotation (Line(points={{-360,200},{-280,200},{-280,190},
          {-242,190}},
                 color={255,0,255}));
  connect(conOccStaInt.y, xor.u2) annotation (Line(points={{-278,150},{-260,150},
          {-260,182},{-242,182}}, color={255,0,255}));
  connect(xor.y, booScaRep.u) annotation (Line(points={{-218,190},{-202,190}},
                                            color={255,0,255}));
  connect(booScaRep.y,or2. u1) annotation (Line(points={{-178,190},{-160,190},{-160,
          170},{-102,170}},                 color={255,0,255}));
  connect(uQua, not2.u)
    annotation (Line(points={{-360,120},{-222,120}}, color={255,0,255}));
  connect(not2.y,or2. u2) annotation (Line(points={{-198,120},{-160,120},{-160,162},
          {-102,162}},                 color={255,0,255}));
  connect(or2.y,or3. u1) annotation (Line(points={{-78,170},{-20,170},{-20,100},
          {-2,100}},  color={255,0,255}));
  annotation (defaultComponentName="zonTemSetCon",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-140},{100,140}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,180},{100,140}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-340,-240},{340,240}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
November 24, 2026, by Weiping Huang:<br/>
Reorganized the graphical layout of the diagram layer: aligned all blocks on
the diagram grid and redrew the connection lines with orthogonal routing.
</li>
<li>
July 17, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block performs zone temperature setpoint change for either the heating
(<code>airConMod = Heating</code>) or the cooling (<code>airConMod = Cooling</code>)
setpoints of all zones in a building. This block first checks whether a
zone is enabled for setpoint change, then prioritizes setpoint change for certain
zones based on the difference between the current zone temperature and the current
zone temperature setpoint, and finally executes the setpoint change operation by
outputting new setpoints.
</p>
<h4>Parameter Definitions</h4>
<p>
The zone control variant parameter <code>zonConVar</code> in this block can have
<i>4</i> different values based on enumeration, from Variant <i>1</i> through
Variant <i>4</i>. Refer to the documentation of
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant\">
Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant</a>
for more information on these <i>4</i> variants.
</p>
<p>
The demand flexibility mode input <code>demFleMod</code> can be: <i>0</i> (pre-cool
or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed mode), or <i>3</i>
(load-rebound mode).
</p>
<p>
The input current setpoint <code>TCurZonSet</code> and the commanded setpoint
<code>TComZonSet</code> must be heating setpoints if the sequence is used for
heating mode and they must be cooling setpoints if it is used for cooling mode.
</p>
<p>
The internal variable zone temperature difference <code>dTZon</code> is defined as
the current zone temperature <code>TCurZon</code> minus the current zone temperature
setpoint <code>TCurZonSet</code> in the heating mode, and as
<code>TCurZonSet</code> minus <code>TCurZon</code> in the cooling mode.
</p>
<h4>Zone Enablement</h4>
<p>
Several conditions are used to determine whether a zone is enabled for zone prioritization
and zone setpoint adjustment:
</p>
<ol>
<li>
The actual occupancy status <code>occSta</code> is the same as the intended occupancy status
<code>occStaInt</code>.
</li>
<li>
The specific zone is qualified for the setpoint change operation, indicated by having
<code>uQua = true</code>. Value of <code>uQua</code> can be supplied externally by
<a href=\"Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Qualification</a>.
</li>
<li>
<code>demFleMod ≠ 2</code>, or, <code>demFleMod = 2</code> and <code>dTZon &lt; dTSheThr</code>,
where <code>dTZon</code> is the zone temperature difference (<code>dTZon = TZon - TZonSet</code>
in the heating mode and <code>dTZon = TZonSet - TZon</code> in the cooling mode).
</li>
<li>
If <code>zonConVar</code> has a value of Variant <i>3</i> or Variant <i>4</i>, the electricity
demand reduction of the building, where the zone is located, has not met a demand reduction target.
Refer to <a href=\"Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand\">
Buildings.Controls.OBC.DemandFlexibility.Generic.ElectricityDemand</a>
for more detailed description.
</li>
<li>
The zone temperature setpoint of a zone has not reached a lower or an upper bound. Refer to
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound</a>
for more detailed description.
</li>
</ol>
<h4>Zone Prioritization</h4>
<p>
For all zones that are enabled for setpoint change, this block ranks the enabled
zones based on the zone temperature difference <code>dTZon</code>, then prioritizes
<code>nSel</code> enabled zones with the smallest <code>dTZon</code> to execute the
setpoint change operation. Thus, the setpoint change operation will only be executed
for zones that are both enabled and prioritized. Refer to
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Prioritization\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Prioritization</a>
for more detailed description.
</p>
<p>
If the number of zones <code>nZon</code> is equal to <i>1</i>, zone prioritization
will not be necessary. The setpoint change operation will be executed for this
single zone as long as this zone is enabled for such operation.
</p>
<h4>Zone Setpoint Adjustment</h4>
<p>
This block executes setpoint change by outputting new setpoints. Refer to
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment</a>
for more detailed description.
</p>
<p>
Note that if <code>zonConVar</code> has a value of Variant <i>1</i>, the
multiple-step setpoint change flag parameter <code>use_mulSteSetCha</code> within
the zone setpoint adjustment subsequence will be <code>false</code>. Otherwise, the
<code>use_mulSteSetCha</code> will be <code>true</code>.
</p>
<h4>Aggregated Behaviors</h4>
<p>
The parameter <code>setChaWaiTim</code> is the setpoint change wait time, which
specifies the time interval at which the setpoint change operation is executed.
</p>
<p>
In the zone enablement subsequence, one condition to enable setpoint change is that
the zone temperature setpoint has not reached a setpoint limit that is imposed by the
respective demand flexibility mode. Since the setpoint change operation will only be
executed for <code>nSel</code> enabled zones with the smallest <code>dTZon</code>,
there is a chance that the zone temperature setpoint of a zone has reached a
temperature setpoint limit, but this zone still has one of the smallest
<code>dTZon</code> values. This zone enablement condition helps remove this zone
from the list of enabled zones and lets other zones become the <code>nSel</code>
enabled zones. Without this zone enablement condition, this block will get stuck by
always prioritizing this zone for setpoint change without moving on to other zones,
even though this zone can no longer change its setpoint past the setpoint limit.
</p>
<p>
Since the setpoint change operation is executed for the <code>nSel</code> enabled
zones with the smallest <code>dTZon</code>, it changes the values of
<code>TComZonSet</code> and <code>TCurZonSet</code>, and thus <code>dTZon</code>
itself changes. This has different implications during different demand flexibility modes
(<code>demFleMod</code>). Below is a table that summarizes these different
implications:
</p>
<table summary=\"summary\" border=\"1\">
<tr>
<th>demFleMod</th>
<th>Implications of zone temperature difference</th>
</tr>
<tr>
<td>0</td>
<td>Setpoint adjustment makes <code>dTZon</code> more negative, so the controller
continues selecting the same zone until its setpoint reaches the pre-heat or pre-cool
limit. This selects zones with the largest pre-heat or pre-cool energy consumption
potential first and flattens the total electricity demand across zones.</td>
</tr>
<tr>
<td>2</td>
<td>Setpoint adjustment makes <code>dTZon</code> more positive, so the controller
selects other zones for setpoint change. This results in <code>dTZon</code> having
similar, and hopefully positive, values across all zones. Thus, this reduces the
peak electricity demand of the building.
</td>
</tr>
<tr>
<td>3</td>
<td>Setpoint adjustment makes <code>dTZon</code> more negative, so the controller
continues selecting the same zone until its setpoint reaches the load-rebound limit.
This selects zones with the largest load-rebound energy consumption potential first
and flattens the total electricity demand across zones.</td>
</tr>
</table>
</html>"));
end Controller;
