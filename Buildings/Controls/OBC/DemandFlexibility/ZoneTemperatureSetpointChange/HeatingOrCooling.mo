within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange;
block HeatingOrCooling
  "Zone heating or cooling temperature setpoint change"

  parameter Real dTShe(min=0)
    "Temperature setpoint change delta for the load-shed mode (positive value)";
  parameter Real dTReb(min=0)
    "Temperature setpoint change delta for the load-rebound mode (positive value)";
  parameter Real dTSheThr(min=0)
    "Threshold of temperature difference to trigger setpoint change during the load-shed mode (positive value)";
  parameter Real dTSheHys(min=0)
    "Hysteresis for the temperature difference during the load-shed mode";
  parameter Real PBuiHys(min=0,start=1)
    "Hysteresis for the electricity demand of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4));
  parameter Real PBuiThrCon(min=0,start=1)
    "Constant threshold for the electricity demand of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3));
  parameter Real TResInt(min=0)
    "Temperature resolution interval used by an external zone temperature controller";
  parameter Real samPerSetCha(min=0)
    "Sampling period for the setpoint change";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Integer nSel(min=1)
    "Number of zones to select for prioritization";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant zonConVar
    "Zone control variant, from Variant 1 through Variant 4";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZon[nZon]
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet[nZon]
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet[nZon]
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet[nZon]
    "Load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet[nZon]
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiThrVar
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Variable threshold for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBui
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Electricity demand of the building"
    annotation (Placement(transformation(extent={{-260,100},{-220,140}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput rouZonFla[nZon]
    "Flags for rogue zones; true if the corresponding zone is a rogue zone"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
        iconTransformation(extent={{-140,140},{-100,180}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput demFleMod
    "Demand flexibility mode; 0 = pre-cool or pre-heat, 1 = default, 2 = load-shed, 3 = load-rebound"
    annotation (Placement(transformation(extent={{-260,-60},{-220,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet[nZon]
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification zonQua(
    final dTSheThr=dTSheThr,
    final dTSheHys=dTSheHys,
    final PBuiHys=PBuiHys,
    final TResInt=TResInt,
    final airConMod=airConMod,
    final use_demCon=zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
    final nZon=nZon)
    "The zone qualification logic block"
    annotation (Placement(transformation(extent={{-80,112},{-60,148}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization
    zonPri(final nZon=nZon, final airConMod=airConMod) if nZon > 1
    "The zone prioritization logic block"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl zonCon[nZon](
    final dTShe=fill(dTShe, nZon),
    final dTReb=fill(dTReb, nZon),
    final airConMod=fill(airConMod, nZon),
    final incSetCha=fill(zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1, nZon))
    "The zone control logic block"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler samSetCha[nZon](
    final samplePeriod=fill(samPerSetCha,nZon))
    "Sampling block for the setpoint change"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator repDemFleMod(
    final nout=nZon)
    "Repeat the demand flexibility mode as a vector"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conNSel(
    final k=nSel)
    if nZon>1
    "A constant for the number of zones to select for prioritization"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conPBuiThr(
    final k=PBuiThrCon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
    "A constant threshold value for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaOneZon[nZon](
    final k=fill(true, nZon))
    if nZon == 1
    "When there is only one zone in a building, always enable setpoint change for this zone"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(zonQua.disFla, zonPri.disFla)
    annotation (Line(points={{-58,130},{-40,130},{-40,96},{58,96}},
      color={255,0,255}));
  connect(zonPri.yEna, zonCon.uEna)
    annotation (Line(points={{82,90},{100,90},{100,-100},{118,-100}},
      color={255,0,255}));
  connect(samSetCha.y, TComZonSet)
    annotation (Line(points={{202,0},{240,0}}, color={0,0,127}));
  connect(zonCon.TComZonSet, samSetCha.u)
    annotation (Line(points={{142,-110},{160,-110},{160,0},{178,0}},
      color={0,0,127}));
  connect(rouZonFla, zonQua.rouZonFla)
    annotation (Line(points={{-240,160},{-200,160},{-200,146},{-82,146}},
      color={255,0,255}));
  connect(PBui, zonQua.PBui)
    annotation (Line(points={{-240,120},{-200,120},{-200,142},{-82,142}},
      color={0,0,127}));
  connect(PBuiThrVar, zonQua.PBuiThr)
    annotation (Line(points={{-240,80},{-150,80},{-150,138},{-82,138}},
      color={0,0,127}));
  connect(TCurZon, zonQua.TZon)
    annotation (Line(points={{-240,40},{-140,40},{-140,134},{-82,134}},
      color={0,0,127}));
  connect(TCurZonSet, zonQua.TZonSet)
    annotation (Line(points={{-240,0},{-130,0},{-130,130},{-82,130}},
      color={0,0,127}));
  connect(demFleMod, zonQua.demFleMod)
    annotation (Line(points={{-240,-40},{-120,-40},{-120,126},{-82,126}},
      color={255,127,0}));
  connect(TPreTarSet, zonQua.TPreTarSet)
    annotation (Line(points={{-240,-80},{-110,-80},{-110,122},{-82,122}},
      color={0,0,127}));
  connect(TSheTarSet, zonQua.TSheTarSet)
    annotation (Line(points={{-240,-120},{-100,-120},{-100,118},{-82,118}},
      color={0,0,127}));
  connect(TDefSet, zonQua.TDefSet)
    annotation (Line(points={{-240,-160},{-90,-160},{-90,114},{-82,114}},
      color={0,0,127}));
  connect(TCurZon, zonPri.TZon)
    annotation (Line(points={{-240,40},{-140,40},{-140,92},{58,92}},
      color={0,0,127}));
  connect(TCurZonSet, zonPri.TZonSet)
    annotation (Line(points={{-240,0},{-40,0},{-40,88},{58,88}}, color={0,0,127}));
  connect(demFleMod, repDemFleMod.u)
    annotation (Line(points={{-240,-40},{-120,-40},{-120,-50},{-42,-50}},
      color={255,127,0}));
  connect(repDemFleMod.y, zonCon.demFleMod)
    annotation (Line(points={{-18,-50},{80,-50},{80,-104},{118,-104}},
      color={255,127,0}));
  connect(TCurZonSet, zonCon.TCurZonSet)
    annotation (Line(points={{-240,0},{60,0},{60,-108.2},{118,-108.2}},
      color={0,0,127}));
  connect(TPreTarSet, zonCon.TPreTarSet)
    annotation (Line(points={{-240,-80},{40,-80},{40,-112},{118,-112}},
      color={0,0,127}));
  connect(TSheTarSet, zonCon.TSheTarSet)
    annotation (Line(points={{-240,-120},{80,-120},{80,-116},{118,-116}},
      color={0,0,127}));
  connect(TDefSet, zonCon.TDefSet)
    annotation (Line(points={{-240,-160},{100,-160},{100,-120},{118,-120}},
      color={0,0,127}));
  connect(conNSel.y, zonPri.nSel)
    annotation (Line(points={{22,50},{40,50},{40,84},{58,84}}, color={255,127,0}));
  connect(conPBuiThr.y, zonQua.PBuiThr)
    annotation (Line(points={{-158,110},{-150,110},{-150,138},{-82,138}},
      color={0,0,127}));
  connect(enaOneZon.y, zonCon.uEna)
    annotation (Line(points={{82,50},{100,50},{100,-100},{118,-100}},
      color={255,0,255}));
  annotation (defaultComponentName="heaOrCoo",
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
This block performs zone setpoint change for either heating setpoints of all zones,
or cooling setpoints of all zones, in a building. This block first checks whether
each zone is qualified for setpoint change, then prioritizes setpoint change for
certain zones based on the difference between the current zone setpoint and the
current zone temperature, and finally executes the setpoint change by outputting new
setpoints.
</p>
<p>
Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification\">
ZoneQualification</a> block for conditions that qualify a zone for setpoint change.
Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization\">
ZonePrioritization</a> block for how different zones are prioritized to perform
setpoint change. Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl\">
ZoneControl</a> block for how setpoint change is executed.
</p>
<p>
The parameter <code>samPerSetCha</code> is a setpoint change sampling period, which
specifies the time interval on how often the setpoint change operation is executed.
</p>
<p>
There are <i>4</i> different variants of zone setpoint change. Each variant is
described below:
</p>
<ul>
<li>
Variant <i>1</i> is single setpoint adjustment, where a zone changes its setpoint
towards a setpoint limit in a single step. However, the single-step setpoint change
can still be done a few zones at a time, rather than all zones changing setpoints at
once. This variant does not take into account the electricity demand of the building.
</li>
<li>
Variant <i>2</i> is ratcheted setpoint adjustment, where a zone changes its setpoint
towards a setpoint limit in multiple small steps. This ratcheted multiple-step
setpoint change can also be done a few zones at a time, rather than all zones
changing setpoints at once. This provides an additional degree of freedom for the
setpoint change. This variant does not take into account the electricity demand of
the building.
</li>
<li>
Variant <i>3</i> is ratcheted setpoint adjustment with a constant electricity demand
target. This is similar to Variant <i>2</i>, except that the electricity demand of
the building needs to be higher than a constant electricity demand target in order
to execute setpoint change during the load-shed demand flexibility mode.
</li>
<li>
Variant <i>4</i> is ratcheted setpoint adjustment with a varying electricity demand
target. This is similar to Variant <i>2</i>, except that the electricity demand of
the building needs to be higher than a variable electricity demand target in order
to execute setpoint change during the load-shed demand flexibility mode.
</li>
</ul>
</html>"));
end HeatingOrCooling;
