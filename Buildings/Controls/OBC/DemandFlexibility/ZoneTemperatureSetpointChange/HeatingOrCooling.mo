within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange;
block HeatingOrCooling
  "Zone heating or cooling temperature setpoint change"

  parameter Real dTShe(
    min=0,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-shed mode (positive value)";
  parameter Real dTReb(
    min=0,
    unit="K",
    displayUnit="K")
    "Temperature setpoint change delta for the load-rebound mode (positive value)";
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
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
      or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4));
  parameter Real PBuiThrCon(
    min=0,
    start=1,
    unit="W")
    "Constant threshold for the electricity demand of the building"
    annotation (Dialog(enable = zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3));
  parameter Real TResInt(
    min=0,
    unit="K",
    displayUnit="K")
    "Temperature resolution interval used by an external zone temperature controller";
  parameter Real setChaWaiTim(
    min=0,
    unit="s")
    "Sampling period for the setpoint change";
  parameter Boolean airConMod
    "Air conditioning mode; true for the heating mode, false for the cooling mode";
  parameter Integer nZon(min=1)
    "Number of zones in the building";
  parameter Integer nSel(min=1)
    "Number of zones to select for prioritization";
  parameter Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant zonConVar
    "Zone control variant, from Variant 1 through Variant 4";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZon[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Current zone temperature"
    annotation (Placement(transformation(extent={{-260,20},{-220,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCurZonSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Current zone temperature setpoint from the external setpoint controller"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TPreTarSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Pre-cool or pre-heat target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-100},{-220,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSheTarSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Load-shed target temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-140},{-220,-100}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDefSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Default temperature setpoint"
    annotation (Placement(transformation(extent={{-260,-180},{-220,-140}}),
        iconTransformation(extent={{-140,-180},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBuiThrVar(
    final unit="W",
    final quantity="Power")
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4
    "Variable threshold for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput PBui(
    final unit="W",
    final quantity="Power")
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TComZonSet[nZon](
    each final unit="K",
    each displayUnit="degC",
    each final quantity="ThermodynamicTemperature")
    "Commanded zone temperature setpoint to the external setpoint controller to change the current temperature setpoint"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.BooleanPassThrough enaOneZon[nZon] if nZon == 1
    "When there is only one zone in a building, always enable setpoint change for this zone"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not notEna[nZon] if nZon > 1
    "Zones are not enabled to participate in zone temperature comparison and zone prioritization"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
protected
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneEnable
    zonEna(
    final dTSheThr=dTSheThr,
    final dTSheHys=dTSheHys,
    final PBuiHys=PBuiHys,
    final TResInt=TResInt,
    final airConMod=airConMod,
    final use_demCon=zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
         or zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_4,
    final nZon=nZon) "The zone enablement logic block"
    annotation (Placement(transformation(extent={{-80,112},{-60,148}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization
    zonPri(
    final nZon=nZon,
    final airConMod=airConMod)
    if nZon > 1
    "The zone prioritization logic block"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl zonCon[nZon](
    final dTShe=fill(dTShe, nZon),
    final dTReb=fill(dTReb, nZon),
    final airConMod=fill(airConMod, nZon),
    final use_mulSteSetCha=fill(zonConVar <> Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_1, nZon))
    "The zone control logic block"
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conPBuiThr(
    final k=PBuiThrCon)
    if zonConVar == Buildings.Controls.OBC.DemandFlexibility.Types.ZoneControlVariant.Variant_3
    "A constant threshold value for the electricity demand of the building"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
equation
  connect(zonPri.yEna, zonCon.uEna)
    annotation (Line(points={{82,90},{100,90},{100,-100},{118,-100}},
      color={255,0,255}));
  connect(samSetCha.y, TComZonSet)
    annotation (Line(points={{202,0},{240,0}}, color={0,0,127}));
  connect(zonCon.TComZonSet, samSetCha.u)
    annotation (Line(points={{142,-110},{160,-110},{160,0},{178,0}},
      color={0,0,127}));
  connect(rouZonFla,zonEna. rouZonFla)
    annotation (Line(points={{-240,160},{-200,160},{-200,146},{-82,146}},
      color={255,0,255}));
  connect(PBui,zonEna. PBui)
    annotation (Line(points={{-240,120},{-200,120},{-200,142},{-82,142}},
      color={0,0,127}));
  connect(PBuiThrVar,zonEna. PBuiThr)
    annotation (Line(points={{-240,80},{-150,80},{-150,138},{-82,138}},
      color={0,0,127}));
  connect(TCurZon,zonEna. TZon)
    annotation (Line(points={{-240,40},{-140,40},{-140,134},{-82,134}},
      color={0,0,127}));
  connect(TCurZonSet,zonEna. TZonSet)
    annotation (Line(points={{-240,0},{-130,0},{-130,130},{-82,130}},
      color={0,0,127}));
  connect(demFleMod,zonEna. demFleMod)
    annotation (Line(points={{-240,-40},{-120,-40},{-120,126},{-82,126}},
      color={255,127,0}));
  connect(TPreTarSet,zonEna. TPreTarSet)
    annotation (Line(points={{-240,-80},{-110,-80},{-110,122},{-82,122}},
      color={0,0,127}));
  connect(TSheTarSet,zonEna. TSheTarSet)
    annotation (Line(points={{-240,-120},{-100,-120},{-100,118},{-82,118}},
      color={0,0,127}));
  connect(TDefSet,zonEna. TDefSet)
    annotation (Line(points={{-240,-160},{-90,-160},{-90,114},{-82,114}},
      color={0,0,127}));
  connect(TCurZon, zonPri.TZon)
    annotation (Line(points={{-240,40},{-140,40},{-140,92},{58,92}},
      color={0,0,127}));
  connect(TCurZonSet, zonPri.TZonSet)
    annotation (Line(points={{-240,0},{-130,0},{-130,88},{58,88}},
                                                                 color={0,0,127}));
  connect(demFleMod, repDemFleMod.u)
    annotation (Line(points={{-240,-40},{-42,-40}},
      color={255,127,0}));
  connect(repDemFleMod.y, zonCon.demFleMod)
    annotation (Line(points={{-18,-40},{80,-40},{80,-104},{118,-104}},
      color={255,127,0}));
  connect(TCurZonSet, zonCon.TCurZonSet)
    annotation (Line(points={{-240,0},{-130,0},{-130,-108.2},{118,-108.2}},
      color={0,0,127}));
  connect(TPreTarSet, zonCon.TPreTarSet)
    annotation (Line(points={{-240,-80},{-110,-80},{-110,-112},{118,-112}},
      color={0,0,127}));
  connect(TSheTarSet, zonCon.TSheTarSet)
    annotation (Line(points={{-240,-120},{-100,-120},{-100,-116},{118,-116}},
      color={0,0,127}));
  connect(TDefSet, zonCon.TDefSet)
    annotation (Line(points={{-240,-160},{-90,-160},{-90,-120},{118,-120}},
      color={0,0,127}));
  connect(conNSel.y, zonPri.nSel)
    annotation (Line(points={{22,50},{40,50},{40,84},{58,84}}, color={255,127,0}));
  connect(conPBuiThr.y,zonEna. PBuiThr)
    annotation (Line(points={{-158,110},{-150,110},{-150,138},{-82,138}},
      color={0,0,127}));
  connect(enaOneZon.y, zonCon.uEna)
    annotation (Line(points={{82,130},{100,130},{100,-100},{118,-100}},
      color={255,0,255}));
  connect(zonEna.enaFla, notEna.u)
    annotation (Line(points={{-58,130},{-40,130},{-40,110},{-22,110}},
      color={255,0,255}));
  connect(notEna.y, zonPri.disFla)
    annotation (Line(points={{2,110},{40,110},{40,96},{58,96}}, color={255,0,255}));
  connect(enaOneZon.u, zonEna.enaFla)
    annotation (Line(points={{58,130},{-58,130}}, color={255,0,255}));
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
This block performs zone temperature setpoint change for either the heating or the
cooling setpoints of all zones, in a building. This block first checks whether a
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
The demand flexibility mode parameter <code>demFleMod</code> can take values of
<i>0</i> (pre-cool or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed
mode), and <i>3</i> (load-rebound mode).
</p>
<p>
The input variable <code>TCurZonSet</code> represents the current value of the
temperature setpoint. The output variable <code>TComZonSet</code> commands the
temperature setpoint to take on a new value. The parameter <code>airConMod</code>
represents the air conditioning mode. <code>airConMod = true</code> represents the
heating mode, whereas <code>airConMod = false</code> represents the cooling mode.
<code>TCurZonSet</code> and <code>TComZonSet</code> must represent heating setpoints
when <code>airConMod = true</code>, and they must represent cooling setpoints when
<code>airConMod = false</code>.
</p>
<p>
Zone temperature difference <code>dTZon</code>, an internal variable, is defined as
the current zone temperature <code>TCurZon</code> minus the current zone temperature
setpoint <code>TCurZonSet</code> during the heating mode
(<code>airConMod = true</code>). On the other hand, <code>dTZon</code> is defined as
<code>TCurZonSet</code> minus <code>TCurZon</code> during the cooling mode
(<code>airConMod = false</code>). 
</p>
<h4>Zone Enablement</h4>
<p>
This block checks whether each zone is enabled for setpoint change. Refer to the
documentation of the sub-block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneEnable\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneEnable</a>
for a more detailed description.
</p>
<p>
Note that if <code>zonConVar</code> has a value of Variant <i>3</i> or Variant
<i>4</i>, the use-demand-control parameter <code>use_demCon</code> within the
<code>ZoneEnable</code> sub-block (not accessible in this block) will be set to
<code>true</code>. Otherwise, the <code>use_demCon</code> parameter will be set to
<code>false</code>.
</p>
<h4>Zone Prioritization</h4>
<p>
This block prioritizes setpoint change for certain zones based on the difference
between the current zone temperature <code>TCurZon</code> and the current zone
temperature setpoint <code>TCurZonSet</code> for each zone. Refer to the
documentation of the sub-block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization</a>
for a more detailed description.
</p>
<p>
Information from the <code>ZoneEnable</code> sub-block about whether a zone is
enabled for the setpoint change operation is passed to the
<code>ZonePrioritization</code> sub-block. If the number of zones <code>nZon</code>
is equal to <i>1</i>, the <code>ZonePrioritization</code> sub-block will not be run
in order to save computation memory. Instead, this <i>1</i> zone will be selected
for the setpoint change operation by default, unless the <code>ZoneEnable</code>
sub-block decides that this zone should be disabled for the setpoint change
operation.
</p>
<h4>Zone Control</h4>
<p>
This block executes the setpoint change opeartion by outputting new setpoints. Refer
to the documentation of the sub-block
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl\">
Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl</a>
for a more detailed description.
</p>
<p>
The setpoint change operation will only be executed for zones that are both “enabled”
and “prioritized” for such operation. Information from the
<code>ZonePrioritization</code> sub-block about whether a zone is both enabled and
prioritized for the setpoint change operation is passed to the
<code>ZoneControl</code> sub-block. Note that if <code>zonConVar</code> has a value
of Variant <i>1</i>, the multiple-step setpoint change flag parameter
<code>use_mulSteSetCha</code> within the <code>ZoneControl</code> sub-block (not
accessible in this block) will be set to <code>false</code>. Otherwise, the
<code>use_mulSteSetCha</code> parameter will be set to <code>true</code>.
</p>
<h4>Aggregated Behaviors</h4>
<p>
The parameter <code>setChaWaiTim</code> is the setpoint change wait time, which
specifies the time interval on how often the setpoint change operation is executed.
</p>
<p>
In the <code>ZoneEnable</code> sub-block, one of the conditions to enable zone
temperature setpoint change is that the zone temperature setpoint has not reached a
temperature setpoint limit that is imposed by the respective demand flexibility mode.
Based on the <code>ZonePrioritization</code> sub-block and the
<code>ZoneControl</code> sub-block, only the <code>nSel</code> zones with the
smallest <code>dTZon</code> will be selected for the setpoint change operation. Here,
there is a chance that the zone temperature setpoint of a zone has reached a
temperature setpoint limit, but this zone is still one of the <code>nSel</code>
zones with the smallest <code>dTZon</code>. This zone enablement condition helps
disable this zone immediately and lets other zones be selected as part of the
<code>nSel</code> zones. Without this zone enablement condition, the
<code>ZonePrioritization</code> sub-block will get stuck by always selecting this
zone for setpoint change without moving on to other zones, even though this zone can
no longer change its setpoint past the setpoint limit.
</p>
<p>
Based on the <code>ZonePrioritization</code> sub-block and the
<code>ZoneControl</code> sub-block, the <code>nSel</code> enabled zones with the
smallest <code>dTZon</code> will be selected for the setpoint change operation. This
in turn changes the value of <code>TComZonSet</code> and <code>TCurZonSet</code>,
thus <code>dTZon</code> itself is changed. This has different implications during
different demand flexibility modes (<code>demFleMod</code>). Below is a table that
summarizes these different implications:
</p>
<table border=1>
<tr>
<th>demFleMod</th>
<th>Implications of zone temperature difference</th>
</tr>
<tr>
<td>0</td>
<td>Setpoint change will cause <code>dTZon</code> to be more negative, making a zone
to continuously be selected for setpoint change until the zone setpoint has reached
the pre-heat or pre-cool setpoint limit. This makes the zones with the largest
pre-heat or pre-cool energy consumption potential to be selected first, while zones
with a smaller energy consumption potential will be selected later. This makes the
total electricity demand of all zones flatter with fewer spikes.</td>
</tr>
<td>2</td>
<td>Setpoint change will cause the <code>dTZon</code> to be more positive, making
way for other zones to be selected for setpoint change. This will result in the
<code>dTZon</code> across all zones to have similar, and hopefully positive, values.
Thus, the maximum amount of the electricity demand of the building will be reduced.
</td>
</tr>
<td>3</td>
<td>Setpoint change will cause <code>dTZon</code> to be more negative, making a zone
to continuously be selected for setpoint change until the zone setpoint has reached
the load-rebound setpoint limit. This makes the zones with the largest load-rebound
energy consumption potential to be selected first, while zones with a smaller energy
consumption potential will be selected later. This makes the total electricity
demand of all zones flatter with fewer spikes.</td>
</tr>
</table>
</html>"));
end HeatingOrCooling;
