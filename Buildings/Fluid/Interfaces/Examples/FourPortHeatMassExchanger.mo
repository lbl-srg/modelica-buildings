within Buildings.Fluid.Interfaces.Examples;
model FourPortHeatMassExchanger
  "FourPortHeatMassExchanger example model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Buildings.Fluid.Interfaces.FourPortHeatMassExchanger fouPor(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    tau1=1,
    tau2=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   "Four port heat mass exchanger"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));


  Sources.Boundary_pT sin(nPorts=2, redeclare package Medium = Medium)
    "Mass flow sink"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Sources.MassFlowSource_T sou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Sources.MassFlowSource_T sou2(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=1,
    T=283.15) "Mass flow source"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp ram_T(
    height=10,
    offset=273.15,
    duration=5) "Temperature ramp"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Sources.Ramp ram_m_flow(
    height=-2,
    offset=1,
    duration=5) "Mass flow rate ramp"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(sin.ports[1], fouPor.port_b2) annotation (Line(points={{-40,-28},{-20,
          -28},{-20,4},{-10,4}}, color={0,127,255}));
  connect(fouPor.port_b1, sin.ports[2]) annotation (Line(points={{10,16},{24,16},
          {24,-32},{-40,-32}}, color={0,127,255}));
  connect(sou1.ports[1], fouPor.port_a1) annotation (Line(points={{-40,10},{-20,
          10},{-20,16},{-10,16}}, color={0,127,255}));
  connect(sou2.ports[1], fouPor.port_a2) annotation (Line(points={{40,10},{20,
          10},{20,4},{10,4}}, color={0,127,255}));
  connect(ram_m_flow.y, sou1.m_flow_in) annotation (Line(points={{-69,40},{-66,
          40},{-66,18},{-62,18}}, color={0,0,127}));
  connect(ram_T.y, sou1.T_in) annotation (Line(points={{-69,0},{-66,0},{-66,14},
          {-62,14}},     color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>
This example model demonstrates the used of the
<a href=\"modelica://Buildings.Fluid.Interfaces.FourPortHeatMassExchanger\">FourPortHeatMassExchanger</a> model.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=5),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/FourPortHeatMassExchanger.mos"
        "Simulate and plot"));
end FourPortHeatMassExchanger;
