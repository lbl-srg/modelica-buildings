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
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet[nZon](
    final unit=fill("K",nZon),
    displayUnit=fill("degC",nZon),
    final quantity=fill("ThermodynamicTemperature",nZon))
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  CDL.Logical.Not not1[nZon] if nZon == 1
    "When there is only one zone in a building, skip zone prioritization"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Generic.ElectricityDemand eleDem(
    PBuiRedDifMin=PBuiRedDifMin,
    PBuiRed_nominal=PBuiRed_nominal,
    PBuiRedHys=PBuiRedHys)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRedTarVar(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Variable target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-306,178},{-266,218}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiRed(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Electricity demand reduction of the building (baseline demand minus actual demand)"
    annotation (Placement(transformation(extent={{-308,128},{-268,168}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.BooleanInput                        uQua[nZon]
    "True if the zone is qualified for zone temperature setpoint change"
    annotation (Placement(transformation(extent={{-184,318},{-144,358}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  CDL.Logical.Not not2[nZon]
    annotation (Placement(transformation(extent={{-98,330},{-78,350}})));
  CDL.Logical.Not not3[nZon]
    annotation (Placement(transformation(extent={{-80,176},{-60,196}})));
  CDL.Logical.Or or2[nZon]
    annotation (Placement(transformation(extent={{-22,310},{-2,330}})));
  CDL.Logical.Or or1[nZon]
    annotation (Placement(transformation(extent={{4,256},{24,276}})));
  CDL.Logical.Or or3[nZon]
    annotation (Placement(transformation(extent={{68,216},{88,236}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound
    lowUppBou(
    final dTSheThr=dTSheThr,
    final dT_small=dT_small,
    final airConMod=airConMod,
    final use_demCon=zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
         or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
    final nZon=nZon) "Zone setpoint lower and upper bound"
    annotation (Placement(transformation(extent={{-80,112},{-60,148}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Prioritization
    zonPri(
    final nZon=nZon,
    final airConMod=airConMod)
    if nZon > 1
    "The zone prioritization logic block"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.Adjustment
    zonSetAdj[nZon](
    final dTPre=fill(dTPre, nZon),
    final dTShe=fill(dTShe, nZon),
    final dTReb=fill(dTReb, nZon),
    final airConMod=fill(airConMod, nZon),
    final use_mulSteSetCha=fill(zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1,
        nZon)) "The zone setpoint adjustment logic block"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSetCha[nZon](
    final samplePeriod=fill(setChaWaiTim,nZon))
    "Sampling block for the setpoint change"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repDemFleMod(
    final nout=nZon)
    "Repeat the demand flexibility mode as a vector"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conNSel(
    final k=nSel)
    if nZon>1
    "A constant for the number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Reals.LessThreshold                        lesDTZon[nZon](final t=fill(
        dTSheThr, nZon), final h=fill(dTSheThr*0.5, nZon))
    "The zone temperature difference is less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-240,286},{-220,306}})));
  CDL.Reals.Subtract                        dTZonHea[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Heating
    "Zone temperature difference during the heating mode"
    annotation (Placement(transformation(extent={{-320,306},{-300,326}})));
  CDL.Reals.Subtract                        dTZonCoo[nZon]
    if airConMod == Buildings.Controls.OBC.DemandFlexibility.Types.AirConditioningMode.Cooling
    "Zone temperature difference during the cooling mode"
    annotation (Placement(transformation(extent={{-320,266},{-300,286}})));
  CDL.Logical.Not                        notLesDTZon[nZon]
    "The zone temperature difference is no less than the load-shed mode zone temperature difference threshold"
    annotation (Placement(transformation(extent={{-180,286},{-160,306}})));
  CDL.Logical.And                        andDTZonLoaShe[nZon]
    "The zone temperature difference is equal or greater than the load-shed mode zone temperature difference threshold, and the system is in the load-shed mode"
    annotation (Placement(transformation(extent={{-78,286},{-58,306}})));
  CDL.Reals.Sources.Constant                        conPBuiRedTar(final k=
        PBuiRedTarCon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
    "A constant for the target electricity demand reduction of the building"
    annotation (Placement(transformation(extent={{-240,200},{-220,220}})));
  CDL.Integers.Sources.Constant                        conIntShe(final k=
        Buildings.Controls.OBC.DemandFlexibility.Types.DemandFlexibilityModes.loadShed)
    "Integer constant for the load-shed mode"
    annotation (Placement(transformation(extent={{-190,234},{-170,254}})));
  CDL.Integers.Equal                        intEquShe
    "Check whether it is the load-shed mode"
    annotation (Placement(transformation(extent={{-138,242},{-118,262}})));
protected
  CDL.Routing.BooleanScalarReplicator                        booScaRepShe(final
      nout=nZon)     "Repeat the boolean scalar for being in the load-shed mode"
    annotation (Placement(transformation(extent={{-104,242},{-84,262}})));
  CDL.Logical.Sources.Constant                        conNotEleDem[nZon](final k=
        fill(true, nZon))
    if zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      and zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "When the electricity demand check is disabled, output true in place of the electricity demand check logic"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));
  CDL.Routing.BooleanScalarReplicator                        repPBuiShe(final
      nout=nZon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Repeat the flag of needing electricity demand shed as a vector"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
equation
  connect(zonPri.yEna, zonSetAdj.uEna) annotation (Line(points={{82,90},{100,90},
          {100,-101.667},{118,-101.667}}, color={255,0,255}));
  connect(samSetCha.y, TComZonSet)
    annotation (Line(points={{202,0},{240,0}}, color={0,0,127}));
  connect(zonSetAdj.TComZonSet, samSetCha.u) annotation (Line(points={{142,-110},
          {160,-110},{160,0},{178,0}}, color={0,0,127}));
  connect(TCurZonSet, lowUppBou.TZonSet) annotation (Line(points={{-240,0},{-130,
          0},{-130,130},{-82,130}}, color={0,0,127}));
  connect(demFleMod, lowUppBou.demFleMod) annotation (Line(points={{-240,-40},{-120,
          -40},{-120,126},{-82,126}}, color={255,127,0}));
  connect(TPreTarSet, lowUppBou.TPreTarSet) annotation (Line(points={{-240,-80},
          {-110,-80},{-110,122},{-82,122}}, color={0,0,127}));
  connect(TSheTarSet, lowUppBou.TSheTarSet) annotation (Line(points={{-240,-120},
          {-100,-120},{-100,118},{-82,118}}, color={0,0,127}));
  connect(TDefSet, lowUppBou.TDefSet) annotation (Line(points={{-240,-160},{-90,
          -160},{-90,114},{-82,114}}, color={0,0,127}));
  connect(TCurZon, zonPri.TZon)
    annotation (Line(points={{-240,40},{-140,40},{-140,92},{58,92}},
      color={0,0,127}));
  connect(TCurZonSet, zonPri.TZonSet)
    annotation (Line(points={{-240,0},{-130,0},{-130,88},{58,88}}, color={0,0,127}));
  connect(demFleMod, repDemFleMod.u)
    annotation (Line(points={{-240,-40},{-42,-40}},
      color={255,127,0}));
  connect(repDemFleMod.y, zonSetAdj.demFleMod) annotation (Line(points={{-18,-40},
          {80,-40},{80,-105},{118,-105}}, color={255,127,0}));
  connect(TCurZonSet, zonSetAdj.TCurZonSet) annotation (Line(points={{-240,0},{-130,
          0},{-130,-108.5},{118,-108.5}},      color={0,0,127}));
  connect(TPreTarSet, zonSetAdj.TPreTarSet) annotation (Line(points={{-240,-80},
          {-110,-80},{-110,-111.667},{118,-111.667}}, color={0,0,127}));
  connect(TSheTarSet, zonSetAdj.TSheTarSet) annotation (Line(points={{-240,-120},
          {-100,-120},{-100,-115},{118,-115}}, color={0,0,127}));
  connect(TDefSet, zonSetAdj.TDefSet) annotation (Line(points={{-240,-160},{-90,
          -160},{-90,-118.333},{118,-118.333}}, color={0,0,127}));
  connect(conNSel.y, zonPri.nSel)
    annotation (Line(points={{22,50},{40,50},{40,84},{58,84}}, color={255,127,0}));
  connect(not1.y, zonSetAdj.uEna) annotation (Line(points={{82,130},{100,130},{
          100,-101.667},{118,-101.667}},
                                     color={255,0,255}));
  connect(dTZonHea.y,lesDTZon. u)
    annotation (Line(points={{-298,316},{-260,316},{-260,296},{-242,296}},
      color={0,0,127}));
  connect(dTZonCoo.y,lesDTZon. u)
    annotation (Line(points={{-298,276},{-260,276},{-260,296},{-242,296}},
      color={0,0,127}));
  connect(lesDTZon.y,notLesDTZon. u)
    annotation (Line(points={{-218,296},{-182,296}},
                                                   color={255,0,255}));
  connect(notLesDTZon.y,andDTZonLoaShe. u1)
    annotation (Line(points={{-158,296},{-80,296}},
                                                  color={255,0,255}));
  connect(PBuiRedTarVar, eleDem.PBuiRedTar) annotation (Line(points={{-286,198},
          {-246,198},{-246,156},{-202,156}}, color={0,0,127}));
  connect(PBuiRed, eleDem.PBuiRed) annotation (Line(points={{-288,148},{-248,148},
          {-248,144},{-202,144}}, color={0,0,127}));
  connect(TCurZon, dTZonHea.u1) annotation (Line(points={{-240,40},{-356,40},{-356,
          48},{-460,48},{-460,322},{-322,322}}, color={0,0,127}));
  connect(TCurZon, dTZonCoo.u2) annotation (Line(points={{-240,40},{-350,40},{-350,
          8},{-452,8},{-452,270},{-322,270}}, color={0,0,127}));
  connect(TCurZonSet, dTZonHea.u2) annotation (Line(points={{-240,0},{-402,0},{-402,
          310},{-322,310}}, color={0,0,127}));
  connect(TCurZonSet, dTZonCoo.u1) annotation (Line(points={{-240,0},{-388,0},{-388,
          282},{-322,282}}, color={0,0,127}));
  connect(conPBuiRedTar.y, eleDem.PBuiRedTar) annotation (Line(points={{-218,210},
          {-218,156},{-202,156}},          color={0,0,127}));
  connect(conIntShe.y,intEquShe. u2)
    annotation (Line(points={{-168,244},{-140,244}},
      color={255,127,0}));
  connect(intEquShe.y, booScaRepShe.u)
    annotation (Line(points={{-116,252},{-106,252}}, color={255,0,255}));
  connect(booScaRepShe.y, andDTZonLoaShe.u2) annotation (Line(points={{-82,252},
          {-84,252},{-84,288},{-80,288}}, color={255,0,255}));
  connect(demFleMod, intEquShe.u1) annotation (Line(points={{-240,-40},{-240,107},
          {-140,107},{-140,252}}, color={255,127,0}));
  connect(eleDem.need_PBuiShe,repPBuiShe. u)
    annotation (Line(points={{-178,150},{-158,150},{-158,160},{-132,160}},
                                                 color={255,0,255}));
  connect(uQua, not2.u) annotation (Line(points={{-164,338},{-134,338},{-134,
          340},{-100,340}}, color={255,0,255}));
  connect(repPBuiShe.y, not3.u) annotation (Line(points={{-108,160},{-96,160},{
          -96,186},{-82,186}}, color={255,0,255}));
  connect(conNotEleDem.y, not3.u) annotation (Line(points={{-148,200},{-116,200},
          {-116,186},{-82,186}}, color={255,0,255}));
  connect(not2.y, or2.u1) annotation (Line(points={{-76,340},{-52,340},{-52,320},
          {-24,320}}, color={255,0,255}));
  connect(andDTZonLoaShe.y, or2.u2) annotation (Line(points={{-56,296},{-40,296},
          {-40,312},{-24,312}}, color={255,0,255}));
  connect(or2.y, or1.u1) annotation (Line(points={{0,320},{2,320},{2,266},{2,
          266}}, color={255,0,255}));
  connect(not3.y, or1.u2) annotation (Line(points={{-58,186},{-28,186},{-28,258},
          {2,258}}, color={255,0,255}));
  connect(or1.y, or3.u1) annotation (Line(points={{26,266},{46,266},{46,226},{
          66,226}}, color={255,0,255}));
  connect(lowUppBou.reach_lowUppBou, or3.u2) annotation (Line(points={{-58,130},
          {6,130},{6,218},{66,218}}, color={255,0,255}));
  connect(or3.y, zonPri.disFla) annotation (Line(points={{90,226},{74,226},{74,
          96},{58,96}}, color={255,0,255}));
  connect(or3.y, not1.u) annotation (Line(points={{90,226},{90,148},{44,148},{
          44,132},{58,132},{58,130}}, color={255,0,255}));
  annotation (defaultComponentName="zonTemSetCon",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-180},{100,180}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-180},{100,180}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,222},{100,182}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-220,-180},{220,180}},
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
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
This block checks whether each zone is enabled for setpoint change. Refer to
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.LowerUpperBound</a>
for more detailed description.
</p>
<p>
Note that if <code>zonConVar</code> has a value of Variant <i>3</i> or Variant
<i>4</i>, the use-demand-control parameter <code>use_demCon</code> of the zone
enablement subsequence will be <code>true</code>. Otherwise, <code>use_demCon</code>
will be <code>false</code>.
</p>
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
<p>
Unprocessed
</p>
<h4>Condition 3</h4>
<p>
Condition <i>3</i> is met if any of the following holds, where <code>dTZon</code>
is the zone temperature difference (<code>dTZon = TZon - TZonSet</code> in the
heating mode and <code>dTZon = TZonSet - TZon</code> in the cooling mode):
</p>
<ul>
<li>
<code>demFleMod ≠ 2</code>
</li>
<li>
or, <code>demFleMod = 2</code> and <code>dTZon &lt; dTSheThr</code>
</li>
</ul>
</html>"));
end Controller;
