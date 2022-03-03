within Buildings.Fluid.Interfaces.Examples;
model ConservationEquationEvaporation
  "Model that tests the conservation equation"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange;

  Buildings.Fluid.Interfaces.ConservationEquationEvaporation dynBal(
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    p_start=101325,
    T_start=373.15,
    m_flow_nominal=0.01,
    show_T=true,
    V=0.1)
    "Conservation equation with phase change"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Fluid.Interfaces.ConservationEquationEvaporation steBal(
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    p_start=101325,
    T_start=373.15,
    m_flow_nominal=0.01,
    show_T=true,
    V=0.1)
    "Conservation equation with phase change"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.TimeTable Q_flow(startTime=0,
    table=[0,0; 900,0; 900,25000; 1800,25000; 1800,50000])
    "Heat flow rate added to the control volume"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = MediumWat,
    m_flow=0.01,
    nPorts=1)
    "Boundary condition for mass flow rate"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = MediumWat,
    m_flow=0.01,
    nPorts=1)
    "Boundary condition for mass flow rate"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumSte,
    nPorts=1,
    use_p_in=false,
    p=101325,
    T=373.15) "Sink"
    annotation (Placement(
        transformation(extent={{80,0},{60,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumSte,
    nPorts=1,
    use_p_in=false,
    p=101325,
    T=373.15) "Sink"
    annotation (Placement(
        transformation(extent={{80,-40},{60,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumSte,
    from_dp=true,
    m_flow_nominal=0.01,
    dp_nominal=100) "Flow resistance"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = MediumSte,
    from_dp=true,
    m_flow_nominal=0.01,
    dp_nominal=100) "Flow resistance"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation

  connect(Q_flow.y, dynBal.Q_flow) annotation (Line(points={{-39,70},{-30,70},{
          -30,16},{-22,16}}, color={0,0,127}));
  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{40,10},{60,10},{60,10}},
                                               color={0,127,255}));
  connect(bou.ports[1], dynBal.port_a)
    annotation (Line(points={{-40,10},{-40,10},{-20,10}}, color={0,127,255}));
  connect(dynBal.port_b, res.port_a)
    annotation (Line(points={{0,10},{20,10}}, color={0,127,255}));
  connect(steBal.port_b, res1.port_a)
    annotation (Line(points={{0,-30},{20,-30}}, color={0,127,255}));
  connect(res1.port_b, sin1.ports[1])
    annotation (Line(points={{40,-30},{60,-30}}, color={0,127,255}));
  connect(bou1.ports[1], steBal.port_a)
    annotation (Line(points={{-40,-30},{-20,-30}}, color={0,127,255}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ConservationEquationEvaporation.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Model that tests the conservation equations that are used
for the heat and mass balance.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 22, 2021, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConservationEquationEvaporation;
