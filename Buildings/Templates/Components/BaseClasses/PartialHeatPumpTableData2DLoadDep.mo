within Buildings.Templates.Components.BaseClasses;
partial model PartialHeatPumpTableData2DLoadDep
  "Interface for heat pump using load-dependent 2D table data"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump;
  Controls.StatusEmulator y1_actual
    "Compute heat pump status"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={40,120})));
  Fluid.Sensors.MassFlowRate mHeaWat_flow(
    redeclare final package Medium=MediumHeaWat)
    "HW mass flow rate"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatEnt(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=max(mChiWat_flow_nominal, mHeaWat_flow_nominal))
    "HW entering temperature"
    annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sensors.TemperatureTwoPort THeaWatLvg(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=max(mChiWat_flow_nominal, mHeaWat_flow_nominal))
    "HW leaving temperature"
    annotation(Placement(transformation(extent={{70,-10},{90,10}})));
  Fluid.Sensors.TemperatureTwoPort TSouEnt(
    redeclare final package Medium=MediumSou,
    final m_flow_nominal=mSouHea_flow_nominal)
    "Source fluid entering temperature"
    annotation(Placement(transformation(extent={{40,-50},{20,-30}})));
  Fluid.Sensors.TemperatureTwoPort TSouLvg(
    redeclare final package Medium=MediumSou,
    final m_flow_nominal=mSouHea_flow_nominal)
    "Source fluid leaving temperature"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={-30,-40})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep hp(
    redeclare final package MediumCon=MediumHeaWat,
    redeclare final package MediumEva=MediumSou,
    final datHea=dat.perHea,
    final datCoo=dat.perCoo,
    final P_min=dat.P_min,
    final use_rev=typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TConHea_nominal=THeaWatSup_nominal,
    final TEvaHea_nominal=TSouHea_nominal,
    final TConCoo_nominal=TChiWatSup_nominal,
    final TEvaCoo_nominal=TSouCoo_nominal,
    final allowFlowReversalCon=allowFlowReversal,
    final allowFlowReversalEva=allowFlowReversalSou,
    final dTCon_nominal=THeaWatSup_nominal - THeaWatRet_nominal,
    dTEva_nominal=0,
    final dpCon_nominal=if have_dpChiHeaWat then dpHeaWat_nominal else 0,
    final dpEva_nominal=if have_dpSou then dpSouHea_nominal else 0,
    final energyDynamics=energyDynamics,
    final mCon_flow_nominal=mHeaWat_flow_nominal,
    final mEva_flow_nominal=mSouHea_flow_nominal,
    final show_T=show_T,
    use_conCap=false,
    use_evaCap=false)
    if not typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    "Heat pump"
    annotation(Placement(transformation(extent={{-10,-16},{10,4}})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC shc(
    redeclare final package MediumCon=MediumHeaWat,
    redeclare final package MediumEva=MediumChiWat,
    final P_min=dat.P_min,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final QHeaShc_flow_nominal=abs(dat.capHeaShc_nominal),
    final QCooShc_flow_nominal=-abs(dat.capCooShc_nominal),
    final dat=dat.perShc,
    final TConHea_nominal=THeaWatSup_nominal,
    final TEvaHea_nominal=TSouHea_nominal,
    final TConCoo_nominal=TChiWatSup_nominal,
    final TEvaCoo_nominal=TSouCoo_nominal,
    final allowFlowReversalCon=allowFlowReversal,
    final allowFlowReversalEva=allowFlowReversalSou,
    final dTCon_nominal=THeaWatSup_nominal - THeaWatRet_nominal,
    final dTEva_nominal=TChiWatSup_nominal - TChiWatRet_nominal,
    final energyDynamics=energyDynamics,
    final dpHw_nominal=if have_dpChiHeaWat then dpHeaWat_nominal else 0,
    final dpChw_nominal=if have_dpChiHeaWat then dpChiWat_nominal else 0,
    final mCon_flow_nominal=mHeaWat_flow_nominal,
    final mEva_flow_nominal=mChiWat_flow_nominal,
    final show_T=show_T,
    use_conCap=false,
    use_evaCap=false)
    if typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    "Polyvalent (SHC) unit"
    annotation(Placement(transformation(extent={{-12,56},{8,76}})));
  Routing.PassThroughFluid pas(redeclare final package Medium=MediumSou)
    if typ == Buildings.Templates.Components.Types.HeatPump.AirToWater and
    typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    "Direct fluid pass through in case of air-source SHC unit"
    annotation(Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or onHeaOrCoo if typMod == Buildings.Templates.Components.Types.HeatPumpCapability.Polyvalent
    "Commanded on in cooling or heating mode"
    annotation (Placement(transformation(extent={{-12,90},{8,110}})));
equation
  connect(port_a, mHeaWat_flow.port_a)
    annotation(Line(points={{-100,0},{-90,0}},
      color={0,127,255}));
  connect(mHeaWat_flow.port_b, THeaWatEnt.port_a)
    annotation(Line(points={{-70,0},{-60,0}},
      color={0,127,255}));
  connect(THeaWatLvg.port_b, port_b)
    annotation(Line(points={{90,0},{100,0}},
      color={0,127,255}));
  connect(TSouLvg.port_b, port_bSou)
    annotation(Line(points={{-40,-40},{-80,-40},{-80,-140}},
      color={0,127,255}));
  connect(THeaWatEnt.port_b, hp.port_a1)
    annotation(Line(points={{-40,0},{-10,0}},
      color={0,127,255}));
  connect(hp.port_b1, THeaWatLvg.port_a)
    annotation(Line(points={{10,0},{70,0}},
      color={0,127,255}));
  connect(TSouLvg.port_a, hp.port_b2)
    annotation(Line(points={{-20,-40},{-20,-12},{-10,-12}},
      color={0,127,255}));
  connect(TSouEnt.port_b, hp.port_a2)
    annotation(Line(points={{20,-40},{20,-12},{10,-12}},
      color={0,127,255}));
  connect(y1_actual.y1_actual, bus.y1_actual)
    annotation(Line(points={{40,132},{40,156},{0,156},{0,160}},
      color={255,0,255}));
  connect(bus.y1, hp.on)
    annotation(Line(points={{0,160},{0,140},{-20,140},{-20,-8},{-12,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Hea, hp.hea)
    annotation(Line(points={{0,160},{0,140},{-20,140},{-20,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.THeaWatSet, hp.THwSet)
    annotation(Line(points={{0,160},{0,140},{-20,140},{-20,-2},{-12,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TChiWatSet, hp.TChwSet)
    annotation(Line(points={{0,160},{0,140},{-20,140},{-20,-6},{-12,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.on, y1_actual.y1)
    annotation(Line(points={{-12,-8},{-14,-8},{-14,12},{40,12},{40,108}},
      color={255,0,255}));
  connect(shc.port_b1, THeaWatLvg.port_a)
    annotation(Line(points={{8,72},{20,72},{20,0},{70,0}},
      color={0,127,255}));
  connect(THeaWatEnt.port_b, shc.port_a1)
    annotation(Line(points={{-40,0},{-40,72},{-12,72}},
      color={0,127,255}));
  connect(shc.port_b2, port_bChiWat)
    annotation(Line(points={{-12,60},{-60,60},{-60,60},{-100,60}},
      color={0,127,255}));
  connect(port_aChiWat, shc.port_a2)
    annotation(Line(points={{100,60},{8,60}},
      color={0,127,255}));
  connect(busWea, shc.weaBus)
    annotation(Line(points={{-40,-140},{-60,-140},{-60,76},{-2,76}},
      color={255,204,51},
      thickness=0.5));
  connect(TSouEnt.port_b, pas.port_a)
    annotation(Line(points={{20,-40},{10,-40}},
      color={0,127,255}));
  connect(pas.port_b, TSouLvg.port_a)
    annotation(Line(points={{-10,-40},{-20,-40}},
      color={0,127,255}));
  connect(bus.THeaWatSet, shc.THwSet) annotation (Line(
      points={{0,160},{0,140},{-20,140},{-20,70},{-14,70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TChiWatSet, shc.TChwSet) annotation (Line(
      points={{0,160},{0,140},{-20,140},{-20,66},{-14,66}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Hea, shc.onHea) annotation (Line(
      points={{0,160},{0,140},{-20,140},{-20,64},{-14,64}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Coo, shc.onCoo) annotation (Line(
      points={{0,160},{0,140},{-20,140},{-20,62},{-14,62}},
      color={255,204,51},
      thickness=0.5));
  connect(onHeaOrCoo.y, y1_actual.y1)
    annotation (Line(points={{10,100},{40,100},{40,108}}, color={255,0,255}));
  connect(shc.onHea, onHeaOrCoo.u1) annotation (Line(points={{-14,64},{-18,64},
          {-18,100},{-14,100}}, color={255,0,255}));
  connect(shc.onCoo, onHeaOrCoo.u2) annotation (Line(points={{-14,62},{-16,62},
          {-16,92},{-14,92}}, color={255,0,255}));
annotation(defaultComponentName="heaPum",
  Documentation(
    info="<html>
<p>
  This is the base class for heat pump models where the capacity and input
  power are computed by interpolating manufacturer data along the condenser
  entering or leaving temperature, the evaporator entering or leaving
  temperature and the part load ratio. Toggling the Boolean parameter
  <code>typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible</code> enables representing either a non-reversible
  (heating-only) heat pump or a reversible heat pump.
</p>
<p>
  This model is a wrapper for
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
    Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>,
  which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>The following input and output points are available.</p>
<ul>
  <li>
    Heat pump on/off command signal: <code>y1</code>, DO signal, with a
    dimensionality of zero
  </li>
  <li>
    For reversible heat pumps only (<code>typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible</code>), heat pump
    operating mode command signal: <code>y1Hea</code>, DO signal, with a
    dimensionality of zero<br />
    Set <code>y1Hea=true</code> for heating mode, <code>y1Hea=false</code> for
    cooling mode.
  </li>
<li>
Heat pump HW supply temperature setpoint: <code>THeaWatSet</code>,
AO signal, with a dimensionality of zero
</li>
<li>For reversible heat pumps only (<code>typMod==Buildings.Templates.Components.Types.HeatPumpCapability.Reversible</code,
Heat pump CHW supply temperature setpoint: <code>TChiWatSet</code>,
AO signal, with a dimensionality of zero
</li>
  <li>
    Heat pump status: <code>y1_actual</code>, DI signal, with a dimensionality
    of zero
  </li>
</ul>
</html>",
    revisions="<html>
<ul>
<li>
March 23, 2026, by Antoine Gautier:<br/>
Refactored with two separate connectors
for HW and CHW temperature setpoints.<br/>
This is for
<a href=\\\"https://github.com/lbl-srg/modelica-buildings/issues/4507\\\">#4507</a>.
</li>
  <li>
    March 21, 2025, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end PartialHeatPumpTableData2DLoadDep;
