within Buildings.Templates.Plants.Chillers.Components.ChillerGroups;
model Compression
  "Group of compression chillers"
  extends Buildings.Templates.Plants.Chillers.Components.Interfaces.PartialChillerGroup;
  Buildings.Templates.Components.Chillers.Compression chi[nChi](
    redeclare each final package MediumChiWat=MediumChiWat,
    redeclare each final package MediumCon=MediumCon,
    each final allowFlowReversal1=allowFlowReversalSou,
    each final allowFlowReversal2=allowFlowReversal,
    each final typ=typ,
    each final have_switchover=have_switchover,
    each final use_TChiWatSupForCtl=use_TChiWatSupForCtl,
    final dat=datChi,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Chiller"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90)));
  // CW isolation valve
  Buildings.Templates.Components.Actuators.Valve valConWatChiIso[nChi](
    redeclare each final package Medium=MediumCon,
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
    annotation(Placement(transformation(extent={{-150,110},{-170,130}})));
  // CHW isolation valve
  // In case of series chillers, the following component is configured as
  // a fixed pressure drop and the last element represents the unique balancing valve.
  Buildings.Templates.Components.Actuators.Valve valChiWatChiIsoPar[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final typ=if typArrChi ==
      Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Parallel
      then typValChiWatChiIso
      else Buildings.Templates.Components.Types.Valve.None,
    each final allowFlowReversal=allowFlowReversal,
    final dat=datValChiWatChiIsoPar,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    "Chiller CHW isolation valve - Parallel chillers"
    annotation(Placement(transformation(extent={{160,110},{180,130}})));
  Buildings.Templates.Components.Actuators.Valve valChiWatChiIsoSer[nChi](
    redeclare each final package Medium=MediumChiWat,
    each final typ=typValChiWatChiIsoSer,
    each final allowFlowReversal=allowFlowReversal,
    each final dat=datValChiWatChiIso,
    each final use_strokeTime=use_strokeTime,
    each final strokeTime=strokeTime,
    each final init=init,
    each final y_start=y_start,
    each final from_dp=from_dp,
    each final linearized=linearized)
    if typArrChi ==
      Buildings.Templates.Plants.Chillers.Types.ChillerArrangement.Series
    "Chiller CHW isolation valve - Series chillers"
    annotation(Placement(transformation(extent={{10,10},{-10,-10}},
      rotation=270,
      origin={140,0})));
  // Sensors
  // CW and CHW temperatures are taken from the fluid volume or medium stream
  // for representative value near zero flow.
  // This is needed for e.g. chiller head pressure control where the
  // CW isolation valve may be modulated down to 0 %.
  Modelica.Blocks.Sources.RealExpression TConWatChiRet[nChi](
    y(each final unit="K", each displayUnit="degC")=chi.chi.con.T)
    if have_senTConWatChiRet
    "Chiller CW return temperature"
    annotation(Placement(transformation(extent={{-90,90},{-70,110}})));
  Modelica.Blocks.Sources.RealExpression TChiWatChiSup[nChi](
    y(each final unit="K", each displayUnit="degC")=chi.chi.eva.T)
    if have_senTChiWatChiSup
    "Chiller CHW supply temperature"
    annotation(Placement(transformation(extent={{90,90},{70,110}})));
  Modelica.Blocks.Sources.RealExpression TConWatChiSup[nChi](
    y(each final unit="K", each displayUnit="degC")=chi.chi.senTConIn.y)
    if have_senTConWatChiSup
    "Chiller CW supply temperature"
    annotation(Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.RealExpression TChiWatChiRet[nChi](
    y(each final unit="K", each displayUnit="degC")=chi.chi.senTEvaIn.y)
    if have_senTChiWatChiRet
    "Chiller CHW return temperature"
    annotation(Placement(transformation(extent={{90,70},{70,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.HeadPressure.Subsequences.ControlLoop ctlHea[nChi](
    final minChiLif=dTLifChi_min,
    each final k=kCtlHea,
    each final Ti=TiCtlHea)
    if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      and typCtlHea ==
        Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByChiller
    "Chiller head pressure control"
    annotation(Placement(transformation(extent={{70,30},{90,50}})));
equation
  connect(valChiWatChiIsoPar.port_b, ports_bChiWat)
    annotation(Line(points={{180,120},{200,120}},
      color={0,127,255}));
  connect(valConWatChiIso.port_b, ports_bCon)
    annotation(Line(points={{-170,120},{-200,120}},
      color={0,127,255}));
  connect(ports_aChiWat, valChiWatChiIsoSer.port_a)
    annotation(Line(points={{200,-100},{140,-100},{140,-10}},
      color={0,127,255}));
  connect(busValConWatChiIso, valConWatChiIso.bus)
    annotation(Line(points={{-80,160},{-160,160},{-160,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, valChiWatChiIsoPar.bus)
    annotation(Line(points={{80,160},{170,160},{170,130}},
      color={255,204,51},
      thickness=0.5));
  connect(busValChiWatChiIso, valChiWatChiIsoSer.bus)
    annotation(Line(points={{80,160},{120,160},{120,0},{130,0}},
      color={255,204,51},
      thickness=0.5));
  connect(busChi, chi.bus)
    annotation(Line(points={{0,160},{-10,160},{-10,0}},
      color={255,204,51},
      thickness=0.5));
  connect(valChiWatChiIsoSer.port_b, valChiWatChiIsoPar.port_a)
    annotation(Line(points={{140,10},{140,120},{160,120}},
      color={0,127,255}));
  connect(chi.port_b1, valConWatChiIso.port_a)
    annotation(Line(points={{-6,-10},{-40,-10},{-40,120},{-150,120}},
      color={0,127,255}));
  connect(chi.port_b2, valChiWatChiIsoPar.port_a)
    annotation(Line(points={{6,10},{20,10},{20,120},{160,120}},
      color={0,127,255}));
  connect(TChiWatChiSup.y, busChi.TChiWatSup)
    annotation(Line(points={{69,100},{0,100},{0,160}},
      color={0,0,127}));
  connect(TConWatChiRet.y, busChi.TConWatRet)
    annotation(Line(points={{-69,100},{0,100},{0,160}},
      color={0,0,127}));
  connect(chi.port_a1, ports_aCon)
    annotation(Line(points={{-6,10},{-20,10},{-20,-100},{-200,-100}},
      color={0,127,255}));
  connect(chi.port_a2, ports_aChiWat)
    annotation(Line(points={{6,-10},{20,-10},{20,-100},{200,-100}},
      color={0,127,255}));
  connect(TConWatChiSup.y, busChi.TConWatSup)
    annotation(Line(points={{-69,80},{0,80},{0,160}},
      color={0,0,127}));
  connect(TChiWatChiRet.y, busChi.TChiWatRet)
    annotation(Line(points={{69,80},{0,80},{0,160}},
      color={0,0,127}));
  connect(TConWatChiRet.y, ctlHea.TConWatRet)
    annotation(Line(points={{-69,100},{-60,100},{-60,40},{68,40},{68,40}},
      color={0,0,127}));
  connect(TChiWatChiSup.y, ctlHea.TChiWatSup)
    annotation(Line(points={{69,100},{60,100},{60,32},{68,32}},
      color={0,0,127}));
  connect(busChi.y1_actual, ctlHea.uHeaPreEna)
    annotation(Line(points={{0,160},{40,160},{40,48},{68,48}},
      color={255,204,51},
      thickness=0.5));
  connect(ctlHea.yHeaPreCon, busChi.yCtlHea)
    annotation(Line(points={{92,40},{100,40},{100,140},{6,140},{6,160},{0,160}},
      color={0,0,127}));
annotation(defaultComponentName="chi",
  Documentation(
    info="<html>
<p>This model represents a group of compression chillers.</p>
<p>Modeling features and limitations:</p>
<ul>
  <li>
    The chillers have the same type (compression chiller). However, the
    chiller parameters such as the design capacity and CHW flow rate may be
    different from one unit to another. Modeling different performance curves
    is also possible, see the documentation of
    <a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup\">
      Buildings.Templates.Plants.Chillers.Components.Data.ChillerGroup</a> for
    further details.
  </li>
  <li>
    Same type of cooling fluid (air or water) for all chillers. This is a hard
    and final limitation considering the use of multiple-ports connectors that
    require a unique medium model.
  </li>
  <li>
    Same type of CW (and CHW) isolation valve for all chillers. Hence, only
    the same type of head pressure control for all chillers is supported (as
    the latter conditions the former).
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
</html>",
    revisions="<html>
<ul>
  <li>
    November 18, 2022, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end Compression;
