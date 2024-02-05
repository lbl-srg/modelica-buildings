within Buildings.Templates.Components.Interfaces;
model PartialHeatPumpModular
  "Interface for heat pump using modular model"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPump;

  replaceable Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible heaPum(
    redeclare final package MediumCon = MediumHeaWat,
    redeclare final package MediumEva = MediumSou,
    final QCoo_flow_nominal=QCoo_flow_nominal,
    final QHea_flow_nominal=QHea_flow_nominal,
    final TCon_nominal=THeaWatSup_nominal,
    final TEva_nominal=TSouHea_nominal,
    final allowFlowReversalCon=allowFlowReversal,
    final allowFlowReversalEva=allowFlowReversalSou,
    final dTCon_nominal=THeaWatSup_nominal - THeaWatRet_nominal,
    dTEva_nominal=0,
    final dpCon_nominal=dpHeaWat_nominal,
    final dpEva_nominal=dpSouHea_nominal,
    final energyDynamics=energyDynamics,
    final mCon_flow_nominal=mHeaWat_flow_nominal,
    final mEva_flow_nominal=mSouHea_flow_nominal,
    final show_T=show_T,
    use_conCap=false,
    use_evaCap=false,
    use_intSafCtr=true,
    redeclare replaceable parameter
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrPar
      constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic(
      tabUppHea=dat.hea.tabUppBou,
      tabLowCoo=dat.coo.tabLowBou,
      use_TUseSidOut=dat.hea.use_TConOutForOpeEnv,
      use_TAmbSidOut=dat.coo.use_TEvaOutForOpeEnv),
    final use_rev=is_rev,
    redeclare model RefrigerantCycleHeatPumpHeating =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
      redeclare Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
      final datTab=dat.hea),
    redeclare model RefrigerantCycleInertia =
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-44},{10,-24}})));

  Modelica.Blocks.Routing.BooleanPassThrough y1Hea if is_rev
    "Operating mode command: true=heating, false=cooling"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-76,60})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant y1HeaNonRev(
    final k=true) if not is_rev
    "Placeholder signal for non-reversible heat pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,60})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1_actual
    "Compute heat pump status"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,80})));
  replaceable PartialHeatPumpModularController ctl
    "Heat pump controller"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));
  Fluid.Sensors.MassFlowRate mChiHeaWat_flow(redeclare final package Medium =
        MediumHeaWat) "CHW/HW mass flow rate"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatEnt(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW entering temperature"
    annotation (Placement(transformation(extent={{-66,-10},{-46,10}})));
  Fluid.Sensors.TemperatureTwoPort TChiHeaWatLvg(redeclare final package Medium =
        MediumHeaWat, final m_flow_nominal=max(mChiWat_flow_nominal,
        mHeaWat_flow_nominal)) "CHW/HW leaving temperature"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Fluid.Sensors.TemperatureTwoPort TSouEnt(
    redeclare final package Medium = MediumSou, final m_flow_nominal=
        mSouHea_flow_nominal) "Source fluid entering temperature"
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Fluid.Sensors.TemperatureTwoPort TSouLvg(
    redeclare final package Medium = MediumSou,
    final m_flow_nominal=
        mSouHea_flow_nominal) "SOurce fluid leaving temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-24,-40})));
protected
  Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    busRef "Refrigerant machine bus" annotation (Placement(transformation(
          extent={{-20,20},{20,60}}), iconTransformation(extent={{-220,-70},{-180,
            -30}})));
equation
  connect(bus.y1Heat, y1Hea.u) annotation (Line(
      points={{0,100},{0,80},{-76,80},{-76,72}},
      color={255,204,51},
      thickness=0.5));
  connect(y1_actual.y, bus.y1_actual) annotation (Line(points={{40,92},{40,96},{
          0,96},{0,100}}, color={255,0,255}));
  connect(bus.y1, y1_actual.u) annotation (Line(
      points={{0,100},{0,60},{40,60},{40,68}},
      color={255,204,51},
      thickness=0.5));
  connect(ctl.y, heaPum.ySet) annotation (Line(
        points={{-28,20},{-20,20},{-20,-32},{-11.2,-32}}, color={0,0,127}));
  connect(ctl.y1Hea, heaPum.hea) annotation (Line(
        points={{-28,24},{-16,24},{-16,-36},{-10,-36},{-10,-35.9},{-11.1,-35.9}},
        color={255,0,255}));
  connect(y1HeaNonRev.y, ctl.u1Hea) annotation (
      Line(points={{-40,48},{-40,44},{-76,44},{-76,24},{-52,24}}, color={255,0,255}));
  connect(y1Hea.y, ctl.u1Hea)
    annotation (Line(points={{-76,49},{-76,24},{-52,24}}, color={255,0,255}));
  connect(bus.TSet, ctl.TSupSet) annotation (Line(
      points={{0.1,100.1},{0.1,80},{-60,80},{-60,20},{-52,20}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1, ctl.u1) annotation (Line(
      points={{0,100},{0,80},{-60,80},{-60,28},{-52,28}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiHeaWatEnt.port_b, heaPum.port_a1) annotation (Line(points={{-46,0},
          {-12,0},{-12,-28},{-10,-28}}, color={0,127,255}));
  connect(port_a, mChiHeaWat_flow.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(mChiHeaWat_flow.port_b, TChiHeaWatEnt.port_a)
    annotation (Line(points={{-70,0},{-66,0}}, color={0,127,255}));
  connect(heaPum.port_b1, TChiHeaWatLvg.port_a) annotation (Line(points={{10,-28},
          {12,-28},{12,0},{50,0}}, color={0,127,255}));
  connect(TChiHeaWatLvg.port_b, port_b)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(TSouEnt.port_b, heaPum.port_a2) annotation (Line(points={{20,-40},{10,
          -40}},                   color={0,127,255}));
  connect(heaPum.port_b2,TSouLvg. port_a)
    annotation (Line(points={{-10,-40},{-14,-40}}, color={0,127,255}));
  connect(busRef, ctl.bus) annotation (Line(
      points={{0,40},{-40,40},{-40,30}},
      color={255,204,51},
      thickness=0.5));
  connect(TChiHeaWatLvg.T, busRef.TConOutMea)
    annotation (Line(points={{60,11},{60,40},{0,40}}, color={0,0,127}));
  connect(TSouEnt.T, busRef.TEvaInMea)
    annotation (Line(points={{30,-29},{30,40},{0,40}}, color={0,0,127}));
  connect(TSouLvg.T, busRef.TEvaOutMea)
    annotation (Line(points={{-24,-29},{-24,40},{0,40}}, color={0,0,127}));
  connect(TChiHeaWatEnt.T, busRef.TConInMea)
    annotation (Line(points={{-56,11},{-56,40},{0,40}}, color={0,0,127}));
  connect(mChiHeaWat_flow.m_flow, busRef.mConMea_flow) annotation (Line(points=
          {{-80,11},{-80,42},{0,42},{0,40}}, color={0,0,127}));
  connect(TSouLvg.port_b, port_bSou) annotation (Line(points={{-34,-40},{-40,
          -40},{-40,-100}}, color={0,127,255}));
  annotation (
  defaultComponentName="heaPum",
  Documentation(info="<html>
<p>
This is a model for an air-to-water heat pump where the capacity
and drawn power are computed based on the equation fit method.
The model can be configured with the parameter <code>is_rev</code>
to represent either a non-reversible heat pump (heating only) or a 
reversible heat pump.
This model uses 
<a href=\\\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\\\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>,
which the user may refer to for the modeling assumptions.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Heat pump on/off command signal <code>y1</code>:
DO signal, with a dimensionality of zero
</li>
<li>For reversible heat pumps only (<code>is_rev=true</code>),
Heat pump operating mode command signal <code>y1Hea</code>:
DO signal, with a dimensionality of zero<br/>
(<code>y1Hea=true</code> for heating mode, 
<code>y1Hea=false</code> for cooling mode)
<li>
Heat pump supply temperature setpoint <code>TSet</code>:
AO signal, with a dimensionality of zero<br/>
(for reversible heat pumps, the setpoint value must be
switched externally between HW and CHW supply temperature)
</li>
<li>
Heat pump status <code>y1_actual</code>:
DI signal, with a dimensionality of zero
</li>
</ul>
</html>"));
end PartialHeatPumpModular;
