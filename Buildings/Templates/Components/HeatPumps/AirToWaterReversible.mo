within Buildings.Templates.Components.HeatPumps;
model AirToWaterReversible
  "Reversible air-to-water heat pump"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPumpModular(
    redeclare final package MediumSou=Buildings.Media.Air,
    heaPum(
      redeclare model RefrigerantCycleHeatPumpCooling=Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D(
        redeclare Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
        final datTab=dat.datTabCoo)),
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWater,
    final typMod=Buildings.Templates.Components.Types.HeatPumpModel.ModularTableData2D,
    final is_rev=true,
    final allowFlowReversalSou=false,
    redeclare Buildings.Templates.Components.HeatPumps.Controls.IdealModularReversibleTableData2D ctl(
      hea(
        final dTCon_nominal=heaPum.refCyc.refCycHeaPumHea.dTCon_nominal,
        final PEle_nominal=heaPum.refCyc.refCycHeaPumHea.PEle_nominal,
        final dTEva_nominal=heaPum.refCyc.refCycHeaPumHea.dTEva_nominal,
        final scaFac=heaPum.refCyc.refCycHeaPumHea.scaFac,
        final mEva_flow_nominal=heaPum.refCyc.refCycHeaPumHea.mEva_flow_nominal,
        final cpEva=heaPum.refCyc.refCycHeaPumHea.cpEva,
        final useInHeaPum=heaPum.refCyc.refCycHeaPumHea.useInHeaPum,
        final extrapolation=heaPum.refCyc.refCycHeaPumHea.extrapolation,
        final cpCon=heaPum.refCyc.refCycHeaPumHea.cpCon,
        final QHeaNoSca_flow_nominal=heaPum.refCyc.refCycHeaPumHea.QHeaNoSca_flow_nominal,
        final datTab=heaPum.refCyc.refCycHeaPumHea.datTab,
        final y_nominal=heaPum.refCyc.refCycHeaPumHea.y_nominal,
        final mCon_flow_nominal=heaPum.refCyc.refCycHeaPumHea.mCon_flow_nominal,
        final QHea_flow_nominal=heaPum.refCyc.refCycHeaPumHea.QHea_flow_nominal,
        final smoothness=heaPum.refCyc.refCycHeaPumHea.smoothness,
        final TEva_nominal=heaPum.refCyc.refCycHeaPumHea.TEva_nominal,
        final TCon_nominal=heaPum.refCyc.refCycHeaPumHea.TCon_nominal),
      coo(
        final QCooNoSca_flow_nominal=heaPum.refCyc.refCycHeaPumCoo.QCooNoSca_flow_nominal,
        final dTCon_nominal=heaPum.refCyc.refCycHeaPumCoo.dTCon_nominal,
        final PEle_nominal=heaPum.refCyc.refCycHeaPumCoo.PEle_nominal,
        final dTEva_nominal=heaPum.refCyc.refCycHeaPumCoo.dTEva_nominal,
        final scaFac=heaPum.refCyc.refCycHeaPumCoo.scaFac,
        final cpEva=heaPum.refCyc.refCycHeaPumCoo.cpEva,
        final extrapolation=heaPum.refCyc.refCycHeaPumCoo.extrapolation,
        final cpCon=heaPum.refCyc.refCycHeaPumCoo.cpCon,
        final QCoo_flow_nominal=heaPum.refCyc.refCycHeaPumCoo.QCoo_flow_nominal,
        final datTab=heaPum.refCyc.refCycHeaPumCoo.datTab,
        final useInChi=heaPum.refCyc.refCycHeaPumCoo.useInChi,
        final mEva_flow_nominal=heaPum.refCyc.refCycHeaPumCoo.mEva_flow_nominal,
        final y_nominal=heaPum.refCyc.refCycHeaPumCoo.y_nominal,
        final mCon_flow_nominal=heaPum.refCyc.refCycHeaPumCoo.mCon_flow_nominal,
        final smoothness=heaPum.refCyc.refCycHeaPumCoo.smoothness,
        final TEva_nominal=heaPum.refCyc.refCycHeaPumCoo.TEva_nominal,
        final TCon_nominal=heaPum.refCyc.refCycHeaPumCoo.TCon_nominal)));
  Fluid.Sources.MassFlowSource_WeatherData souAir(
    redeclare final package Medium=MediumAir,
    final use_m_flow_in=true,
    nPorts=1)
    "Air flow source"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=-90,
      origin={50,-60})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mAir_flow(
    final k=mSouHea_flow_nominal)
    "Air mass flow rate"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={80,-40})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1Rea
    "Convert on/off command into real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=-90,
      origin={80,40})));
equation
  connect(bus.y1, y1Rea.u)
    annotation (Line(points={{0,100},{0,60},{80,60},{80,52}},color={255,204,51},thickness=0.5));
  connect(y1Rea.y, mAir_flow.u)
    annotation (Line(points={{80,28},{80,-28}},color={0,0,127}));
  connect(mAir_flow.y, souAir.m_flow_in)
    annotation (Line(points={{80,-52},{80,-80},{58,-80},{58,-70}},color={0,0,127}));
  connect(busWea, souAir.weaBus)
    annotation (Line(points={{-60,100},{-60,96},{-96,96},{-96,-70},{50.2,-70}},
      color={255,204,51},thickness=0.5));
  connect(souAir.ports[1], TSouEnt.port_a)
    annotation (Line(points={{50,-50},{50,-40},{40,-40}},color={0,127,255}));
  annotation (
    defaultComponentName="heaPum",
    Documentation(
      info="<html>
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
end AirToWaterReversible;
