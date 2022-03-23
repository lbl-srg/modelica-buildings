within Buildings.Electrical.AC.ThreePhasesBalanced.MotorDrive.ThermoFluid.Examples;
model Pump "This example shows how to use the heat pump with mechanical interface"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Torque tau=0.05
    "Provided torque";
  parameter Modelica.Units.SI.Inertia JLoad=0.01 "Load inertia";

  Modelica.Mechanics.Rotational.Sources.ConstantTorque torSou(tau_constant=tau)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(          redeclare package Medium =
        Medium, nPorts=1)
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  ThermoFluid.Pump Pum(
    pum(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
  redeclare package Medium = Medium, redeclare
      Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to6 per)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(sou1.ports[1], res1.port_a)
    annotation (Line(points={{-60,0},{-48,0}},     color={0,127,255}));
  connect(Pum.port_b, sin1.ports[1])
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(res1.port_b, Pum.port_a)
    annotation (Line(points={{-28,0},{-10,0}}, color={0,127,255}));
  connect(torSou.flange, Pum.shaft)
    annotation (Line(points={{-60,70},{0,70},{0,10}}, color={0,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/MotorDrive/ThermoFluid/Examples/Pump.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>Example that simulates a pump using the torque as input signal.</p>
</html>",
      revisions="<html>
<ul>
<li>6 March 2019, 
    by Yangyang Fu:<br/>
      First implementation.</li>
</ul>
</html>"));
end Pump;
