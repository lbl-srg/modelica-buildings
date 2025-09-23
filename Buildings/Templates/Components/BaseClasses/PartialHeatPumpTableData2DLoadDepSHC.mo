within Buildings.Templates.Components.BaseClasses;
partial model PartialHeatPumpTableData2DLoadDepSHC
  "Interface for simultaneous heating and cooling (SHC) air-to-water heat pump
  using load-dependent 2D table data"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump;

  parameter Integer nUni=1
    "Number of modules";

  Buildings.Templates.Components.Controls.StatusEmulator y1_actual
    "Compute heat pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,120})));

  Buildings.Fluid.Sensors.MassFlowRate mChiHeaWat_flow(
    redeclare final package Medium = MediumHeaWat)
    "CHW/HW mass flow rate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TChiHeaWatEnt(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=max(mChiWat_flow_nominal,mHeaWat_flow_nominal))
    "CHW/HW entering temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TChiHeaWatLvg(
    redeclare final package Medium=MediumHeaWat,
    final m_flow_nominal=max(mChiWat_flow_nominal,mHeaWat_flow_nominal))
    "CHW/HW leaving temperature"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TSouEnt(
    redeclare final package Medium = MediumSou,
    final m_flow_nominal=mSouHea_flow_nominal)
    "Source fluid entering temperature"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TSouLvg(
    redeclare final package Medium = MediumSou,
    final m_flow_nominal=mSouHea_flow_nominal)
    "Source fluid leaving temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-20})));

  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC hp(
    redeclare final package MediumCon = MediumHeaWat,
    redeclare final package MediumEva = MediumSou,
    dTEva_nominal=QCoo_flow_nominal/dat.cpChiWat_default/mChiWat_flow_nominal,
    nUni=nUni,
    use_preDro=false,
    dpHw_nominal(displayUnit="Pa") = dpHeaWat_nominal,
    dpChw_nominal(displayUnit="Pa") = dpChiWat_nominal,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    QHeaShc_flow_nominal=QHea_flow_nominal,
    QCooShc_flow_nominal=QCoo_flow_nominal,
    dat=dat.perSHC,
    final allowFlowReversalCon=allowFlowReversal,
    final allowFlowReversalEva=allowFlowReversalSou,
    final dTCon_nominal=QHea_flow_nominal/dat.cpHeaWat_default/
        mHeaWat_flow_nominal,
    final energyDynamics=energyDynamics,
    final mCon_flow_nominal=mHeaWat_flow_nominal,
    final mEva_flow_nominal=mChiWat_flow_nominal,
    final show_T=show_T,
    use_conCap=false,
    use_evaCap=false,
    TConHea_nominal=THeaWatSup_nominal,
    TEvaHea_nominal=TSouHea_nominal,
    TConCoo_nominal=TChiWatSup_nominal,
    TEvaCoo_nominal=TSouCoo_nominal)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));

equation
  connect(port_a, mChiHeaWat_flow.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(mChiHeaWat_flow.port_b, TChiHeaWatEnt.port_a)
    annotation (Line(points={{-70,0},{-60,0}}, color={0,127,255}));
  connect(TChiHeaWatLvg.port_b, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(TSouLvg.port_b, port_bSou) annotation (Line(points={{-40,-20},{-80,-20},
          {-80,-140}},      color={0,127,255}));
  connect(TChiHeaWatEnt.port_b, hp.port_a1)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(hp.port_b1, TChiHeaWatLvg.port_a)
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  connect(TSouLvg.port_a, hp.port_b2) annotation (Line(points={{-20,-20},{-20,
          -12},{-10,-12}},
                      color={0,127,255}));
  connect(TSouEnt.port_b, hp.port_a2)
    annotation (Line(points={{20,-20},{20,-12},{10,-12}}, color={0,127,255}));
  connect(y1_actual.y1_actual, bus.y1_actual)
    annotation (Line(points={{40,132},{40,156},{0,156},{0,160}},
                                                         color={255,0,255}));
  connect(bus.y1, hp.on) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-8},{-12,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.THwSet, hp.THwSet) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-2},{-12,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TChwSet, hp.TChwSet) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-6},{-12,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.mode, hp.mode) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-10},{-12,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.on, y1_actual.y1) annotation (Line(points={{-12,-8},{-14,-8},{-14,
          12},{40,12},{40,108}}, color={255,0,255}));
  connect(busWea, hp.weaBus) annotation (Line(
      points={{-40,-140},{-40,22},{0,22},{0,4}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.y1HwValIsoPumPri, bus.y1HwValIsoPumPri) annotation (Line(points={{6,5},{6,
          136},{0,136},{0,160}},       color={255,0,255}));
  connect(hp.yValHwIso, bus.yValHwIso)
    annotation (Line(points={{8,5},{8,140},{0,140},{0,160}}, color={0,0,127}));
  connect(hp.y1ChwValIsoPumPri, bus.y1ChwValIsoPumPri) annotation (Line(points={{-6,-17},
          {-6,-44},{-24,-44},{-24,136},{0,136},{0,160}},          color={255,0,255}));
  connect(hp.yValChwIso, bus.yValChwIso) annotation (Line(points={{-8,-17},{-8,
          -42},{-36,-42},{-36,140},{0,140},{0,160}},
                                                color={0,0,127}));
  connect(hp.nUniShc, bus.nUniShc) annotation (Line(points={{-3,-18},{-2,-18},{
          -2,-32},{16,-32},{16,116},{0,116},{0,160}},
                                                   color={255,127,0}));
  connect(hp.nUniCoo, bus.nUniCoo) annotation (Line(points={{0,-18},{0,-32},{16,
          -32},{16,116},{0,116},{0,160}}, color={255,127,0}));
  connect(hp.nUniHea, bus.nUniHea) annotation (Line(points={{3,-18},{2,-18},{2,
          -32},{16,-32},{16,116},{0,116},{0,160}},
                                              color={255,127,0}));
  annotation (
  defaultComponentName="heaPum",
  Documentation(info="<html>
  <p>This is the base class for SHC air-to-water heat pump model where the capacity
  and input power are computed by interpolating manufacturer data along the condenser
  entering or leaving temperature, the evaporator entering or leaving temperature
  and the part load ratio. </p>
  <p>This model is a wrapper for
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC\">
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC</a>, which the
  user may refer to for the modeling assumptions. </p>
<h4>Control points</h4>
<p>The following input and output points are available. </p>
<ul>
<li>Heat pump on/off command signal: <code>y1</code>, DO signal, with a dimensionality of zero </li>
<li>Heat pump chilled water supply temperature setpoint: <code>TChwSet</code>, AO signal, with a dimensionality of zero</li>
<li>Heat pump hot water supply temperature setpoint: <code>THwSet</code>, AO signal, with a dimensionality of zero</li>
<li>Heat pump status: <code>y1_actual</code>, DI signal, with a dimensionality of zero </li>
<li>Number of modules in heating mode: <code>nUniHea</code>, AI signal, with a dimensionality of zero </li>
<li>Number of modules in cooling mode: <code>nUniCoo</code>, AI signal, with a dimensionality of zero </li>
<li>Number of modules in SHC mode: <code>nUniShc</code>, AI signal, with a dimensionality of zero </li>
<li>CHW isolation valve or primary pump signal: <code>y1ChwValIsoPumPri</code>, DI signal, with a dimensionality of nUni </li>
<li>HW isolation valve or primary pump signal: <code>y1HwValIsoPumPri</code>, DI signal, with a dimensionality of nUni </li>
<li>Equivalent CHW isolation valve signal: <code>yValChwIso</code>, AI signal, with a dimensionality of zero </li>
<li>Equivalent HW isolation valve signal: <code>yValHwIso</code>, AI signal, with a dimensionality of zero </li>

</ul>
</html>", revisions="<html>
<ul>
<li>September 1, 2025, by Xing Lu, Karthik Devaprasad:<br>First implementation. </li>
</ul>
</html>"));
end PartialHeatPumpTableData2DLoadDepSHC;
