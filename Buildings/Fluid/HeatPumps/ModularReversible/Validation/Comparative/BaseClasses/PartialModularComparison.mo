within Buildings.Fluid.HeatPumps.ModularReversible.Validation.Comparative.BaseClasses;
partial model PartialModularComparison
  "Partial model for comparison to the Carnot model"
  extends PartialComparison(
    m1_flow_nominal=heaPum.mCon_flow_nominal,
    m2_flow_nominal=heaPum.mEva_flow_nominal,
    sou1(nPorts=1),
    sin2(nPorts=1),
    sou2(nPorts=1),
    sin1(nPorts=1));

  Buildings.Fluid.HeatPumps.ModularReversible.Modular heaPum(
    redeclare final package MediumCon = Medium1,
    redeclare final package MediumEva = Medium2,
    QHea_flow_nominal=QUse_flow_nominal,
    redeclare final model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    final use_rev=false,
    final use_intSafCtr=false,
    final tauCon=tau1,
    final TConHea_nominal=TCon_nominal,
    final dTCon_nominal=dTCon_nominal,
    final dpCon_nominal=dp1_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final tauEva=tau2,
    final TEvaHea_nominal=TEva_nominal,
    final dTEva_nominal=dTEva_nominal,
    final dpEva_nominal=dp2_nominal,
    final TConCoo_nominal=0,
    final TEvaCoo_nominal=0,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final TCon_start=T1_start,
    final TEva_start=T2_start,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Modular heat pump model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(heaPum.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,6},{-40,6}}, color={0,127,255}));
  connect(heaPum.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-32,
          -6},{-32,-30},{-40,-30}},
                                color={0,127,255}));
  connect(heaPum.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-6},{40,-6}}, color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1])
    annotation (Line(points={{10,6},{36,6},{36,30},{60,30}}, color={0,127,255}));
  connect(heaPum.ySet, uCom.y) annotation (Line(points={{-11.2,2},{-34,2},{-34,50},
          {-39,50}},             color={0,0,127}));

  annotation (
    Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model to have consitent parameterization of the
modular reversible model approaches.
</p>
</html>"));
end PartialModularComparison;
