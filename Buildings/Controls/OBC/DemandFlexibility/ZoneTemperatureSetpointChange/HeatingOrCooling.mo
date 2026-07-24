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
  parameter Real samPerSetCha(
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
  CDL.Logical.Not            enaOneZon[nZon] if nZon == 1
    "When there is only one zone in a building, always enable setpoint change for this zone"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
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
  connect(zonQua.disFla, enaOneZon.u)
    annotation (Line(points={{-58,130},{58,130}}, color={255,0,255}));
  connect(enaOneZon.y, zonCon.uEna) annotation (Line(points={{82,130},{100,130},
          {100,-100},{118,-100}}, color={255,0,255}));
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
certain zones based on the difference between the current zone temperature and the
current zone temperature setpoint, and finally executes the setpoint change by
outputting new setpoints.
</p>
<h4>Zone Qualification</h4>
<p>
This block contains a <code>ZoneQualification</code> sub-block to check whether each
zone is qualified for setpoint change.
</p>
<p>
Several conditions are used to determine that a zone is qualified, including:
</p>
<ul>
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
</ul>
<p>
Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneQualification\">ZoneQualification</a>
sub-block for more details on how each of these conditions is defined. Note that if
the zone control variant parameter <code>zonConVar</code> in this block has a value
of Variant <i>3</i> or Variant <i>4</i>, the use-demand-control parameter
<code>use_demCon</code> within the <code>ZoneQualification</code> sub-block (not
accessible in this block) will be set to <code>true</code>. Otherwise, the
<code>use_demCon</code> parameter will be set to <code>false</code>. As a result, if
the zone control variant is not Variant <i>3</i> or Variant <i>4</i>, the condition
above that checks electricity demand of the building will not be considered for zone
qualification. Refer also to the “Zone Control Variant” section later in this
documentation for more information on what each zone control variant does.
</p>
<h4>Zone Prioritization</h4>

<p>
This block contains a <code>ZonePrioritization</code> sub-block to prioritize
setpoint change for certain zones based on the difference between the current zone
temperature <code>TCurZon</code> and the current zone temperature setpoint
<code>TCurZonSet</code>.
</p>
<p>
Zone temperature difference, an internal variable, is defined as the current zone
temperature (<code>TCurZon</code>) minus the current zone temperature setpoint
(<code>TCurZonSet</code>). <code>airConMod = true</code> represents the heating mode,
whereas <code>airConMod = false</code> represents the cooling mode. The zone
temperature setpoint input variable <code>TCurZonSet</code> must represent a heating
setpoint when the air conditioning mode <code>airConMod = true</code>, and it must
represent a cooling setpoint when <code>airConMod = false</code>.
</p>
<p>
The parameter <code>nSel</code> represents the number of zones to select for the
setpoint changer operation at each setpoint change sampling period
<code>samPerSetCha</code>. For the heating mode (<code>airConMod = true</code>),
the <code>nSel</code> zones with the smallest zone temperature difference will be
selected, and thus will be prioritized for the setpoint change operation. For the
cooling mode (<code>airConMod = false</code>), the <code>nSel</code> zones with the
largest zone temperature difference will be selected for the setpoint change
operation.
</p>
<p>
Information from the <code>ZoneQualification</code> sub-block about whether a zone
is qualified for the setpoint change operation will be passed to the
<code>ZonePrioritization</code> sub-block. Any zones that are disqualified,
determined by the <code>ZoneQualification</code> sub-block, will not participate in
the ranking of the zone temperature difference to select the <code>nSel</code> zones
in the <code>ZonePrioritization</code> sub-block, even if these zones have the
largest or the smallest zone temperature difference. Only the qualified zones will
be ranked, and the <code>nSel</code> zones with the largest or the smallest zone
temperature difference from only the qualified zones will be selected. In the end,
the disqualified zones will never be selected for the setpoint change operation by
the <code>ZonePrioritization</code> sub-block. 
</p>
<p>
Keep in mind that only the <code>nSel</code> zones being selected, rather than all
zones that are qualified by the <code>ZoneQualification</code> sub-block, will go
through the setpoint change operation.
</p>
<p>
Note that if the number of zones <code>nZon</code> is equal to <i>1</i>, the
<code>ZonePrioritization</code> sub-block will not be run in order to save
computation memory. Instead, this <i>1</i> zone will be selected for the setpoint
change operation by default, unless the <code>ZoneQualification</code> sub-block
decides that this zone should be disqualified for the setpoint change operation.
</p>
<p>
Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZonePrioritization\">ZonePrioritization</a>
sub-block for more details on how the prioritization works.
</p>
<h4>Zone Control</h4>
<p>
This block contains a <code>ZoneControl</code> sub-block to execute the setpoint
change by outputting new setpoints.
</p>
<p>
The input variable <code>TCurZonSet</code> in this block represents the current
value of the temperature setpoint. The output variable <code>TComZonSet</code> in
this block commands the temperature setpoint to take on a new value.
<code>TCurZonSet</code> and <code>TComZonSet</code> must represent heating setpoints
when <code>airConMod = true</code>, and they must represent cooling setpoints when
<code>airConMod = false</code>.
</p>
<p>
The demand flexibility mode <code>demFleMod</code> in this block can take values of
<i>0</i> (pre-cool or pre-heat mode), <i>1</i> (default mode), <i>2</i> (load-shed
mode), and <i>3</i> (load-rebound mode). The input variables <code>TPreTarSet</code>,
<code>TDefSet</code>, and <code>TSheTarSet</code> in this block must take on
reasonable values. For example, <code>TPreTarSet &gt; TDefSet &gt; TSheTarSet</code>
must hold if the air conditioning system is in the heating mode
(<code>airConMod = true</code>), and
<code>TPreTarSet &lt; TDefSet &lt; TSheTarSet</code> must hold if the air
conditioning system is in the cooling mode (<code>airConMod = false</code>). 
</p>
<p>
The <code>ZoneControl</code> sub-block executes the setpoint change operation only
for the <code>nSel</code> zones that are selected by the
<code>ZonePrioritization</code> sub-block. Refer to the documentation of the
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Subsequences.ZoneControl\">ZoneControl</a>
sub-block for a detailed description of how the setpoint change is executed under
different demand flexibility modes (<code>demFleMod</code>) and different air
conditioning modes (<code>airConMod</code>). A summary of this setpoint change
operation is that, for each demand flexibility mode, a minimum and a maximum zone
setpoint bounds are defined. When a zone is one of the <code>nSel</code> zones being
selected for setpoint change at each setpoint change sampling period
<code>samPerSetCha</code>, the temperature setpoint for this zone is increased or
decreased by one step (<code>TComZonSet = TCurZonSet + one step</code>), provided
that it is within the minimum and maximum zone setpoint bounds. When a zone is not
one of the <code>nSel</code> zones being selected, the temperature setpoint for this
zone will stay constant, neither increasing nor decreasing
(<code>TComZonSet = TCurZonSet</code>). Within each demand flexibility mode, the zone
temperature setpoint change will only have one direction, either increasing
or decreasing. The zone temperature setpoint change will change direction
only when the demand flexibility mode is changed.
</p>
<p>
Note that if the zone control variant parameter <code>zonConVar</code> in this block
has a value of Variant <i>1</i>, the incremental (or multiple-step) setpoint change
flag parameter <code>incSetCha</code> within the <code>ZoneControl</code> sub-block
(not accessible in this block) will be set to <code>false</code>. Otherwise, the
<code>incSetCha</code> parameter will be set to <code>true</code>. Refer also to
the “Zone Control Variant” section later in this documentation for more information
on what each zone control variant does.
</p>
<p>
Note that the output <code>TComZonSet</code> in this block is intended to be
received by a downstream temperature setpoint controller, which will process the
setpoint change and pass its new setpoint back to the input <code>TCurZonSet</code>
in this block, completing a full control loop.
</p>
<h4>Aggregated Behaviors</h4>
<p>
The parameter <code>samPerSetCha</code> is a setpoint change sampling period, which
specifies the time interval on how often the setpoint change operation is executed.
</p>
<p>
In the <code>ZoneQualification</code> sub-block, if the electricity demand of the
building is lower than the electricity demand threshold during the load-shed demand
flexibility mode for Variant <i>3</i> or Variant <i>4</i>, all zones in the building
will be disqualified for setpoint change. Thus, the zone temperature setpoints will
stay at the current value. Then, the zone temperatures can reach the zone
temperature setpoints, turning on air conditioning. This will increase the
electricity demand of the building, eventually making the electricity demand higher
than the electricity demand threshold and causing most zones to be qualified for
setpoint change. The zone temperature setpoints will then change, away from the zone
temperatures, thus turning off air conditioning and reducing the electricity demand
of the building. This completes one cycling period of zone control.
</p>
<p>
In the <code>ZoneQualification</code> sub-block, another qualifying condition for
zone temperature setpoint change is that the zone temperature is close enough to the
zone temperature setpoint during the load-shed demand flexibility mode. If the zone
temperature is not close enough to the zone temperature setpoint for a zone, this
zone will be disqualified for the setpoint change, and the zone temperature setpoint
will stay constant. This is designed to make the zone temperature setpoint during
the load-shed mode change value only when necessary and not deviate too far, thereby
minimizing occupant thermal discomfort.
</p>
<p>
In the <code>ZoneQualification</code> sub-block, the last qualifying condition for
zone temperature setpoint change is that the zone temperature setpoint has not
reached a temperature setpoint limit that is imposed by the respective demand
flexibility mode. Based on the <code>ZonePrioritization</code> sub-block and the
<code>ZoneControl</code> sub-block, only the <code>nSel</code> zones with the largest
or the smallest zone temperature difference will be selected for the setpoint change
operation. Here, there is a chance that the zone temperature setpoint of a zone has
reached a temperature setpoint limit, but this zone is still one of the
<code>nSel</code> zones with the largest or the smallest zone temperature difference.
This qualifying condition helps disqualify this zone immediately and lets other
zones be selected as part of the <code>nSel</code> zones. Without this qualifying
condition, this zone will continue to be one of the <code>nSel</code> selected zones.
The zone temperature setpoint of this zone will receive the signal to further change
its value, but because the temperature setpoint limit has reached, the zone
temperature setpoint could only take the value of the temperature setpoint limit.
Thus, the <code>ZonePrioritization</code> sub-block will get stuck by always
selecting this zone for setpoint change, without moving on to other zones.
</p>
<p>
Based on the <code>ZonePrioritization</code> sub-block and the
<code>ZoneControl</code> sub-block, the <code>nSel</code> qualified zones with the
largest or the smallest zone temperature difference will be selected for the
setpoint change operation. This in turn changes the value of <code>TComZonSet</code>
and <code>TCurZonSet</code>, thus the zone temperature difference itself is changed.
This has different implications during different demand flexibility modes
(<code>demFleMod</code>) and different air conditioning modes
(<code>airConMod</code>). Below is a table that summarizes these different
implications:
</p>
<table border=1>
<tr>
<th>demFleMod</th>
<th>airConMod</th>
<th>Implications of zone temperature difference</th>
</tr>
<tr>
<td>0</td>
<td>true</td>
<td>Setpoint change will cause the zone temperature difference to be even more
negative, making a zone to continuously be selected for setpoint change until the
zone setpoint has reached an upper limit. This makes the zones with the largest
pre-heat energy consumption to be selected first, while letting a few zones complete
pre-heating first before the next zones start pre-heating. This makes the total
electricity demand of all zones flatter with fewer spikes.</td>
</tr>
<tr>
<td>0</td>
<td>false</td>
<td>Setpoint change will cause the zone temperature difference to be even more
positive, making a zone to continuously be selected for setpoint change until the
zone setpoint has reached a lower limit. This makes the zones with the largest
pre-cool energy consumption to be selected first, while letting a few zones complete
pre-cooling first before the next zones start pre-cooling. This makes the total
electricity demand of all zones flatter with fewer spikes.</td>
</tr>
<tr>
<td>2</td>
<td>true</td>
<td>Setpoint change will cause the zone temperature difference to be more positive,
making way for other zones to be selected for setpoint change. This will result in
the zone temperature difference across all zones to have similar, and hopefully
positive, values. Thus, the maximum amount of the electricity demand of the building
will be reduced.</td>
</tr>
<tr>
<td>2</td>
<td>false</td>
<td>Setpoint change will cause the zone temperature difference to be more negative,
making way for other zones to be selected for setpoint change. This will result in
the zone temperature difference across all zones to have similar, and hopefully
negative, values. Thus, the maximum amount of the electricity demand of the building
will be reduced.</td>
</tr>
<tr>
<td>3</td>
<td>true</td>
<td>Setpoint change will cause the zone temperature difference to be even more
negative, making a zone to continuously be selected for setpoint change until the
zone setpoint has reached an upper limit. This makes the zones with the largest
load-rebound energy consumption to be selected first, while letting a few zones
complete load-rebound first before the next zones start load-rebound. This makes the
total electricity demand of all zones flatter with fewer spikes.</td>
</tr>
<tr>
<td>3</td>
<td>false</td>
<td>Setpoint change will cause the zone temperature difference to be even more
positive, making a zone to continuously be selected for setpoint change until the
zone setpoint has reached a lower limit. This makes the zones with the largest
load-rebound energy consumption to be selected first, while letting a few zones
complete load-rebound first before the next zones start load-rebound. This makes the
total electricity demand of all zones flatter with fewer spikes.</td>
</tr>
</table>
<h4>Zone Control Variant</h4>
<p>
The zone control variant parameter <code>zonConVar</code> in this block can have
<i>4</i> different values, from Variant <i>1</i> through Variant <i>4</i>. These
<i>4</i> different variants represent different flavors of zone setpoint change. Each
variant is described below:
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
