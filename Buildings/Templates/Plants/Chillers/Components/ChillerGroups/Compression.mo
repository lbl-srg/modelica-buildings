within Buildings.Templates.Plants.Chillers.Components.ChillerGroups;
model Compression "Group of compression chillers"
  extends Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup;

  Buildings.Templates.Components.Chillers.Compression chi[nChi](
    redeclare each final package MediumChiWat = MediumChiWat,
    redeclare each final package MediumCon = MediumCon,
    each final allowFlowReversal1=allowFlowReversalSou,
    each final allowFlowReversal2=allowFlowReversal,
    each final typ=typ,
    each final have_switchover=have_switchover,
    each final use_TChiWatSupForCtl=use_TChiWatSupForCtl,
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
  Buildings.Templates.Components.Actuators.Valve valConWatChiIso[nChi](
    redeclare each final package Medium = MediumCon,
    each final typ=typValConWatChiIso,
    each final allowFlowReversal=allowFlowReversalSou,
    final dat=datValConWatChiIso,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    "Chiller CW isolation valve"
    annotation (Placement(transformation(extent={{-150,110},{-170,130}})));

  // CHW isolation valve
  Buildings.Templates.Components.Actuators.Valve valChiWatChiIsoPar[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final typ=typValChiWatChiIso,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiIso,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if typArr == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
    "Chiller CHW isolation valve - Parallel chillers"
    annotation (Placement(transformation(extent={{130,110},{150,130}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatChiIsoSer[nChi](
    redeclare each final package Medium = MediumChiWat,
    each final typ=typValChiWatChiIso,
    each final allowFlowReversal=allowFlowReversal,
    each final dat=datValChiWatChiIso,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if typArr == Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Chiller CHW isolation valve - Series chillers"
    annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=270,
        origin={180,0})));
equation
  /* Control point connection - start */
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

  connect(TChiWatChiSup.port_b, valChiWatChiIsoPar.port_a)
    annotation (Line(points={{110,120},{130,120}}, color={0,127,255}));
  connect(valChiWatChiIsoPar.port_b, ports_bChiWat)
    annotation (Line(points={{150,120},{200,120}}, color={0,127,255}));
  connect(valConWatChiIso.port_b, ports_bCon) annotation (Line(points={{-170,120},
          {-200,120}},                       color={0,127,255}));
  connect(valConWatChiIso.port_a, TConWatChiRet.port_b) annotation (Line(points={{-150,
          120},{-110,120}},                             color={0,127,255}));
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
  connect(ports_aChiWat, valChiWatChiIsoSer.port_a) annotation (Line(points={{200,
          -100},{180,-100},{180,-10}},                 color={0,127,255}));
  connect(valChiWatChiIsoSer.port_b, ports_bChiWat) annotation (Line(points={{180,10},
          {180,120},{200,120}},                     color={0,127,255}));
  connect(busValConWatChiIso, valConWatChiIso.bus) annotation (Line(
      points={{-80,160},{-160,160},{-160,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, valChiWatChiIsoPar.bus) annotation (Line(
      points={{80,160},{140,160},{140,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, valChiWatChiIsoSer.bus) annotation (Line(
      points={{80,160},{160,160},{160,0},{170,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi, chi.bus) annotation (Line(
      points={{0,160},{-10,160},{-10,0}},
      color={255,204,51},
      thickness=0.5));
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
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup\">
Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup</a>
for further details.
</li>
<li>
Same type of cooling fluid (air or water) for all chillers.
This is a hard and final limitation considering the use of multiple-ports 
connectors that require a unique medium model.
</li>
<li>
Same type of CW (and CHW) isolation valve for all chillers.
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
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup\">
Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup</a>.
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
