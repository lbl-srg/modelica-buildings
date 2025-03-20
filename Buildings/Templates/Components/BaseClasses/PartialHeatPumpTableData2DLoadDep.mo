within Buildings.Templates.Components.BaseClasses;
partial model PartialHeatPumpTableData2DLoadDep
  "Interface for heat pump using load-dependent 2D table data"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump;

  Controls.StatusEmulator y1_actual
    "Compute heat pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,120})));
  Fluid.Sensors.MassFlowRate mChiHeaWat_flow(redeclare final package Medium =
        MediumHeaWat) "CHW/HW mass flow rate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatEnt(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW entering temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatLvg(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW leaving temperature"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Fluid.Sensors.TemperatureTwoPort TSouEnt(
    redeclare final package Medium = MediumSou, final m_flow_nominal=
        mSouHea_flow_nominal) "Source fluid entering temperature"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Fluid.Sensors.TemperatureTwoPort TSouLvg(
    redeclare final package Medium = MediumSou,
    final m_flow_nominal=
        mSouHea_flow_nominal) "Source fluid leaving temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-20})));
  Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep hp(
    redeclare final package MediumCon = MediumHeaWat,
    redeclare final package MediumEva = MediumSou,
    final datHea=dat.perHea,
    final datCoo=dat.perCoo,
    final use_rev=is_rev,
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
  connect(TSouLvg.port_a, hp.port_b2) annotation (Line(points={{-20,-20},{-20,-12},
          {-10,-12}}, color={0,127,255}));
  connect(TSouEnt.port_b, hp.port_a2)
    annotation (Line(points={{20,-20},{20,-12},{10,-12}}, color={0,127,255}));
  connect(y1_actual.y1_actual, bus.y1_actual)
    annotation (Line(points={{40,132},{40,156},{0,156},{0,160}},
                                                         color={255,0,255}));
  connect(bus.y1, hp.on) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-6},{-12.2,-6}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1Hea, hp.hea) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-8},{-12.2,-8}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TSet, hp.TSet) annotation (Line(
      points={{0,160},{0,20},{-20,20},{-20,-4},{-12.2,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(hp.on, y1_actual.y1) annotation (Line(points={{-12.2,-6},{-14,-6},{-14,
          12},{40,12},{40,108}}, color={255,0,255}));
  annotation (
  defaultComponentName="heaPum",
  Documentation(info="<html>
<p>
This is the base class for heat pump models where the capacity
and input power are computed by interpolating manufacturer data
along the condenser entering or leaving temperature, the 
evaporator entering or leaving temperature and the part load ratio.
Toggling the Boolean parameter <code>is_rev</code> enables
representing either a non-reversible (heating-only) heat pump or a
reversible heat pump.
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDep</a>,
which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Heat pump on/off command signal: <code>y1</code>,
DO signal, with a dimensionality of zero
</li>
<li>For reversible heat pumps only (<code>is_rev=true</code>),
heat pump operating mode command signal: <code>y1Hea</code>,
DO signal, with a dimensionality of zero<br/>
Set <code>y1Hea=true</code> for heating mode,
<code>y1Hea=false</code> for cooling mode.
</li>
<li>
Heat pump supply temperature setpoint: <code>TSet</code>,
AO signal, with a dimensionality of zero<br/>
For reversible heat pumps, the setpoint value must be
switched externally between HW and CHW supply temperature.
</li>
<li>
Heat pump status: <code>y1_actual</code>,
DI signal, with a dimensionality of zero
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialHeatPumpTableData2DLoadDep;
