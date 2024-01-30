within Buildings.Fluid.Chillers.ModularReversible.Validation.BaseClasses;
partial model PartialModularComparison
  "Partial model for comparison to the Carnot model"
  extends Buildings.Fluid.HeatPumps.ModularReversible.Validation.Comparative.BaseClasses.PartialComparison(
    m1_flow_nominal=chi.mCon_flow_nominal,
    m2_flow_nominal=chi.mEva_flow_nominal,
    sou1(nPorts=1),
    sin2(nPorts=1),
    sou2(nPorts=1),
    sin1(nPorts=1));

  ModularReversible chi(
    redeclare final package MediumCon = Medium1,
    redeclare final package MediumEva = Medium2,
    QCoo_flow_nominal=-QUse_flow_nominal,
    final y_nominal=1,
    redeclare final model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    final use_rev=false,
    final use_intSafCtr=false,
    final tauCon=tau1,
    final TCon_nominal=TCon_nominal,
    final dTCon_nominal=dTCon_nominal,
    final dpCon_nominal=dp1_nominal,
    final use_conCap=false,
    final CCon=0,
    final GConOut=0,
    final GConIns=0,
    final tauEva=tau2,
    final TEva_nominal=TEva_nominal,
    final dTEva_nominal=dTEva_nominal,
    final dpEva_nominal=dp2_nominal,
    final use_evaCap=false,
    final CEva=0,
    final GEvaOut=0,
    final GEvaIns=0,
    final TCon_start=T1_start,
    final TEva_start=T2_start,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Modular chiller model"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

equation
  connect(chi.port_a1, sou1.ports[1])
    annotation (Line(points={{-8,6},{-40,6}},  color={0,127,255}));
  connect(chi.port_b2, sin2.ports[1]) annotation (Line(points={{-8,-6},{-32,-6},{
          -32,-30},{-40,-30}}, color={0,127,255}));
  connect(chi.port_a2, sou2.ports[1])
    annotation (Line(points={{12,-6},{40,-6}}, color={0,127,255}));
  connect(chi.port_b1, sin1.ports[1])
    annotation (Line(points={{12,6},{36,6},{36,30},{60,30}}, color={0,127,255}));
  connect(chi.ySet, uCom.y) annotation (Line(points={{-9.2,2},{-34,2},{-34,50},{
          -39,50}},          color={0,0,127}));

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
Partial model to have consistent parameterization of the
modular reversible model approaches.
</p>
</html>"));
end PartialModularComparison;
