within Buildings.Templates.Components.HeatPumps;
model WaterToWaterReversible
  "Reversible water-to-water heat pump - Modular model"
  extends Buildings.Templates.Components.Interfaces.PartialHeatPumpModular(
    hp(safCtrPar(
        use_minOnTime=false,
        use_minOffTime=false,
        use_maxCycRat=false), redeclare model RefrigerantCycleHeatPumpCooling
        = Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D
          (redeclare
            Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
            iceFacCal, final datTab=dat.modCoo)),
    final typ=Buildings.Templates.Components.Types.HeatPump.WaterToWater,
    final is_rev=true,
    redeclare
      Buildings.Templates.Components.HeatPumps.Controls.IdealModularReversibleTableData2D
      ctl(hea(
        final cpCon=cpHeaWat_default,
        final cpEva=cpSou_default,
        final dTCon_nominal=hp.refCyc.refCycHeaPumHea.dTCon_nominal,
        final PEle_nominal=hp.refCyc.refCycHeaPumHea.PEle_nominal,
        final dTEva_nominal=hp.refCyc.refCycHeaPumHea.dTEva_nominal,
        final scaFac=hp.refCyc.refCycHeaPumHea.scaFac,
        final mEva_flow_nominal=hp.refCyc.refCycHeaPumHea.mEva_flow_nominal,
        final useInHeaPum=hp.refCyc.refCycHeaPumHea.useInHeaPum,
        final extrapolation=hp.refCyc.refCycHeaPumHea.extrapolation,
        final QHeaNoSca_flow_nominal=hp.refCyc.refCycHeaPumHea.QHeaNoSca_flow_nominal,

        final datTab=hp.refCyc.refCycHeaPumHea.datTab,
        final y_nominal=hp.refCyc.refCycHeaPumHea.y_nominal,
        final mCon_flow_nominal=hp.refCyc.refCycHeaPumHea.mCon_flow_nominal,
        final QHea_flow_nominal=hp.refCyc.refCycHeaPumHea.QHea_flow_nominal,
        final smoothness=hp.refCyc.refCycHeaPumHea.smoothness,
        final TEva_nominal=hp.refCyc.refCycHeaPumHea.TEva_nominal,
        final TCon_nominal=hp.refCyc.refCycHeaPumHea.TCon_nominal), coo(
        final cpCon=cpSou_default,
        final cpEva=cpChiWat_default,
        final QCooNoSca_flow_nominal=hp.refCyc.refCycHeaPumCoo.QCooNoSca_flow_nominal,

        final dTCon_nominal=hp.refCyc.refCycHeaPumCoo.dTCon_nominal,
        final PEle_nominal=hp.refCyc.refCycHeaPumCoo.PEle_nominal,
        final dTEva_nominal=hp.refCyc.refCycHeaPumCoo.dTEva_nominal,
        final scaFac=hp.refCyc.refCycHeaPumCoo.scaFac,
        final extrapolation=hp.refCyc.refCycHeaPumCoo.extrapolation,
        final QCoo_flow_nominal=hp.refCyc.refCycHeaPumCoo.QCoo_flow_nominal,
        final datTab=hp.refCyc.refCycHeaPumCoo.datTab,
        final useInChi=hp.refCyc.refCycHeaPumCoo.useInChi,
        final mEva_flow_nominal=hp.refCyc.refCycHeaPumCoo.mEva_flow_nominal,
        final y_nominal=hp.refCyc.refCycHeaPumCoo.y_nominal,
        final mCon_flow_nominal=hp.refCyc.refCycHeaPumCoo.mCon_flow_nominal,
        final smoothness=hp.refCyc.refCycHeaPumCoo.smoothness,
        final TEva_nominal=hp.refCyc.refCycHeaPumCoo.TEva_nominal,
        final TCon_nominal=hp.refCyc.refCycHeaPumCoo.TCon_nominal)));

equation
  connect(port_aSou, TSouEnt.port_a)
    annotation (Line(points={{80,-140},{80,-20},{40,-20}},color={0,127,255}));
  annotation (
    defaultComponentName="hp",
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
end WaterToWaterReversible;
