within Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups;
model Compression "Group of compression chillers"
  extends
    Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup;

  Buildings.Templates.Components.Chillers.Compression chi[nChi](
    redeclare each final package MediumChiWat=MediumChiWat,
    redeclare each final package MediumCon=MediumCon,
    each final allowFlowReversal=allowFlowReversal,
    each final typ=typChi,
    final dat=datChi,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Chiller"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, rotation=90)));

  // Sensors
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiSup[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    each final have_sen=have_senTChiWatChiSup,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chiller CHW supply temperature"
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatChiRet[nChi](
    redeclare each final package Medium=MediumChiWat,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    each final have_sen=have_senTChiWatChiRet,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chiller CHW return temperature"
    annotation (Placement(transformation(extent={{110,-110},{90,-90}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatChiSup[nChi](
    redeclare each final package Medium=MediumCon,
    final m_flow_nominal=mConChi_flow_nominal,
    each have_sen=have_senTConWatChiSup,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chiller CW supply temperature"
    annotation (Placement(transformation(extent={{-110,-110},{-90,-90}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatChiRet[nChi](
    redeclare each final package Medium=MediumCon,
    final m_flow_nominal=mConChi_flow_nominal,
    each have_sen=have_senTConWatChiRet,
    each final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell)
    "Chiller CW return temperature"
    annotation (Placement(transformation(extent={{-90,110},{-110,130}})));

  // CW isolation valve
  Buildings.Templates.Components.Valves.TwoWayModulating valConWatChiIsoMod[nChi](
    redeclare each final package Medium=MediumCon,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValConWatChiIso)
    if typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve - Modulating"
    annotation (Placement(transformation(extent={{-150,150},{-170,170}})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valConWatChiIsoTwo[nChi](
    redeclare each final package Medium = MediumCon,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValConWatChiIso,
    each final text_flip=true)
    if typValConWatChiIso==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve - Two-position"
    annotation (Placement(transformation(extent={{-150,110},{-170,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasConWatChi[nChi](
    redeclare each final package Medium=MediumCon)
    if typValConWatChiIso==Buildings.Templates.Components.Types.Valve.None
    "No chiller CW isolation valve"
    annotation (Placement(transformation(extent={{-150,90},{-170,70}})));

  // CHW isolation valve
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiWatChiIsoTwoPar[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiIso) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
     and typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Chiller CHW isolation valve - Two-position - Parallel chillers"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasChiWatChiPar[nChi](
      redeclare each final package Medium = MediumChiWat) if typValChiWatChiIso ==
    Buildings.Templates.Components.Types.Valve.None and typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "No chiller CHW isolation valve"
    annotation (Placement(transformation(extent={{130,90},{150,70}})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChiIsoModPar[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiIso) if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
     and typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel
    "Chiller CHW isolation valve - Modulating - Parallel chillers"
    annotation (Placement(transformation(extent={{130,150},{150,170}})));
  Buildings.Templates.Components.Valves.TwoWayTwoPosition valChiWatChiIsoTwoSer[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final allowFlowReversal=allowFlowReversal,
    each final dat=datValChiWatChiIso)
    if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    and typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Chiller CHW isolation valve - Two-position - Series chillers" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={140,0})));
  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatChiIsoModSer[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiIso)
    if typValChiWatChiIso == Buildings.Templates.Components.Types.Valve.TwoWayModulating
    and typArrChi==Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "Chiller CHW isolation valve - Modulating - Series chillers" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={100,0})));
  Buildings.Templates.Components.Routing.PassThroughFluid pasChiWatChiSer[nChi](
    redeclare each final package Medium = MediumChiWat)
    if typValChiWatChiIso ==Buildings.Templates.Components.Types.Valve.None
    and typArrChi == Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series
    "No chiller CHW isolation valve"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={180,0})));
equation
  /* Control point connection - start */
  connect(busChi, chi.bus);
  connect(bus.valConWatChiIso, valConWatChiIsoMod.bus);
  connect(bus.valConWatChiIso, valConWatChiIsoTwo.bus);
  connect(bus.valChiWatChiIso, valChiWatChiIsoTwoPar.bus);
  connect(bus.valChiWatChiIso, valChiWatChiIsoModPar.bus);
  connect(bus.valChiWatChiIso, valChiWatChiIsoTwoSer.bus);
  connect(bus.valChiWatChiIso, valChiWatChiIsoModSer.bus);
  /*
  HACK: The following clauses should be removed at translation if `not have_sen`
  but Dymola fails to do so.
  Hence, explicit `if then` statements are used.
  */
  if have_senTChiWatChiSup then
    connect(bus.TChiWatChiSup, TChiWatChiSup.y);
  end if;
  if have_senTChiWatChiRet then
    connect(bus.TChiWatChiRet, TChiWatChiRet.y);
  end if;
  if have_senTConWatChiSup then
    connect(bus.TConWatChiSup, TConWatChiSup.y);
  end if;
  if have_senTConWatChiRet then
    connect(bus.TConWatChiRet, TConWatChiRet.y);
  end if;
  /* Control point connection - stop */

  connect(TChiWatChiSup.port_b, valChiWatChiIsoTwoPar.port_a)
    annotation (Line(points={{110,120},{130,120}}, color={0,127,255}));
  connect(TChiWatChiSup.port_b, pasChiWatChiPar.port_a) annotation (Line(points
        ={{110,120},{120,120},{120,80},{130,80}}, color={0,127,255}));
  connect(pasChiWatChiPar.port_b, ports_bChiWat) annotation (Line(points={{150,80},
          {160,80},{160,120},{200,120}}, color={0,127,255}));
  connect(valChiWatChiIsoTwoPar.port_b, ports_bChiWat)
    annotation (Line(points={{150,120},{200,120}}, color={0,127,255}));
  connect(valConWatChiIsoTwo.port_b, ports_bCon)
    annotation (Line(points={{-170,120},{-200,120}}, color={0,127,255}));
  connect(valConWatChiIsoMod.port_b, ports_bCon) annotation (Line(points={{-170,
          160},{-180,160},{-180,120},{-200,120}}, color={0,127,255}));
  connect(pasConWatChi.port_b, ports_bCon) annotation (Line(points={{-170,80},{-180,
          80},{-180,120},{-200,120}}, color={0,127,255}));
  connect(valConWatChiIsoMod.port_a, TConWatChiRet.port_b) annotation (Line(
        points={{-150,160},{-140,160},{-140,120},{-110,120}}, color={0,127,255}));
  connect(TConWatChiRet.port_b, valConWatChiIsoTwo.port_a)
    annotation (Line(points={{-110,120},{-150,120}}, color={0,127,255}));
  connect(TConWatChiRet.port_b, pasConWatChi.port_a) annotation (Line(points={{-110,
          120},{-140,120},{-140,80},{-150,80}}, color={0,127,255}));
  connect(chi.port_b1, TConWatChiRet.port_a) annotation (Line(points={{-6,-10},{
          -40,-10},{-40,120},{-90,120}}, color={0,127,255}));
  connect(ports_aChiWat, TChiWatChiRet.port_a)
    annotation (Line(points={{200,-100},{110,-100}}, color={0,127,255}));
  connect(TChiWatChiRet.port_b, chi.port_a2) annotation (Line(points={{90,-100},
          {20,-100},{20,-10},{6,-10}}, color={0,127,255}));
  connect(TConWatChiSup.port_b, chi.port_a1) annotation (Line(points={{-90,-100},
          {-20,-100},{-20,10},{-6,10}}, color={0,127,255}));
  connect(ports_aCon, TConWatChiSup.port_a)
    annotation (Line(points={{-200,-100},{-110,-100}}, color={0,127,255}));
  connect(chi.port_b2, TChiWatChiSup.port_a) annotation (Line(points={{6,10},{20,
          10},{20,120},{90,120}}, color={0,127,255}));
  connect(TChiWatChiSup.port_b, valChiWatChiIsoModPar.port_a) annotation (Line(
        points={{110,120},{120,120},{120,160},{130,160}}, color={0,127,255}));
  connect(valChiWatChiIsoModPar.port_b, ports_bChiWat) annotation (Line(points={
          {150,160},{160,160},{160,120},{200,120}}, color={0,127,255}));
  connect(ports_aChiWat, valChiWatChiIsoTwoSer.port_a) annotation (Line(points={{200,
          -100},{180,-100},{180,-20},{140,-20},{140,-10}},
                                            color={0,127,255}));
  connect(valChiWatChiIsoTwoSer.port_b, ports_bChiWat) annotation (Line(points={{140,10},
          {140,20},{180,20},{180,120},{200,120}},          color={0,127,255}));
  connect(ports_aChiWat, valChiWatChiIsoModSer.port_a) annotation (Line(points={{200,
          -100},{180,-100},{180,-20},{100,-20},{100,-10}},      color={0,127,255}));
  connect(valChiWatChiIsoModSer.port_b, ports_bChiWat) annotation (Line(points={{100,10},
          {100,20},{180,20},{180,120},{200,120}},          color={0,127,255}));
  connect(ports_aChiWat, pasChiWatChiSer.port_a) annotation (Line(points={{200,-100},
          {180,-100},{180,-10}}, color={0,127,255}));
  connect(pasChiWatChiSer.port_b, ports_bChiWat) annotation (Line(points={{180,10},
          {180,120},{200,120}}, color={0,127,255}));
  annotation(defaultComponentName="chi", Documentation(info="<html>
<p>
This model represents a group of compression chillers.
</p>
<p>
Modeling features and limitations:
</p>
<ul>
<li>
The chillers have the same type (compression chiller).
However, the chiller parameters such as the design capacity 
and CHW flow rate may be different from one unit to another.
Modeling different performance curves is also possible, 
see the documentation of 
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Data.ChillerGroup</a>
for further details.
</li>
<li>
Same type of cooling fluid (air or water) for all chillers.
This is a hard and final limitation considering the use of multiple-ports 
connectors that require a unique medium model.
</li>
<li>
Same type of CW (and CHW) isolation valve for all chillers.
This is a technical debt that will be purged when actuator models are
refactored as container classes.<br/>
Hence, only the same type of head pressure control for all chillers is supported
(as the latter conditions the former).
</li>
<li>
The option for limiting the chiller demand is currently not modeled.
</li>
</ul>
<h4>Control points</h4>
<p>
See the documentation of
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Interfaces.PartialChillerGroup</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Compression;
