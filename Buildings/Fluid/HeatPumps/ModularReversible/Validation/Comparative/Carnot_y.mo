within Buildings.Fluid.HeatPumps.ModularReversible.Validation.Comparative;
model Carnot_y "Example using the Carnot model approach"
  extends BaseClasses.PartialComparison(
    m1_flow_nominal=heaPum.m1_flow_nominal,
    m2_flow_nominal=heaPum.m2_flow_nominal,
    sin2(nPorts=1),
    sou2(nPorts=1),
    sin1(nPorts=1),
    sou1(nPorts=1));
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.Carnot_y heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    etaCarnot_nominal=etaCarnot_nominal,
    TCon_nominal=TCon_nominal,
    TEva_nominal=TEva_nominal,
    tau1=tau1,
    tau2=tau2,
    P_nominal=QUse_flow_nominal/heaPum.COP_nominal,
    dTEva_nominal=-dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    use_eta_Carnot_nominal=false,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    T1_start=T1_start,
    T2_start=T2_start) "Heat pump model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(sin2.ports[1], heaPum.port_b2) annotation (Line(points={{-40,-30},{-16,
          -30},{-16,-6},{-10,-6}}, color={0,127,255}));
  connect(heaPum.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-6},{40,-6}},color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1])
    annotation (Line(points={{10,6},{36,6},{36,30},{60,30}},color={0,127,255}));
  connect(heaPum.port_a1, sou1.ports[1])
    annotation (Line(points={{-10,6},{-40,6}}, color={0,127,255}));
  connect(heaPum.y, uCom.y)
    annotation (Line(points={{-12,9},{-12,50},{-39,50}}, color={0,0,127}));

  annotation (experiment(Tolerance=1e-6, StopTime=3600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Validation/Comparative/Carnot_y.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Validation case for <a href=\"modelica://Buildings.Fluid.Chillers.Carnot_y\">
Buildings.Fluid.Chillers.Carnot_y</a>, duplicate of the example
<a href=\"modelica://Buildings.Fluid.Chillers.Examples.Carnot_y\">
Buildings.Fluid.Chillers.Examples.Carnot_y</a>.
</p>
</html>"));
end Carnot_y;
