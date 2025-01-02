within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Examples;
model Pump "This example shows how to use the heat pump with mechanical interface"
  extends Modelica.Icons.Example;
  package MediumW = Buildings.Media.Water;

  parameter Modelica.Units.SI.Torque tau=15
    "Provided torque";
  parameter Modelica.Units.SI.Inertia JLoad=0.01 "Load inertia";

  Modelica.Mechanics.Rotational.Sources.ConstantTorque torSou(tau_constant=tau)
    "Torque input"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(redeclare package Medium = MediumW,
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = MediumW,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = MediumW,
    m_flow_nominal=1.2,
    dp_nominal=2000) "Resistance"
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.ThermoFluid.Pump pum(
    pum(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    redeclare package Medium = MediumW,
    redeclare
      Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine50slash150dash4slash2 per)
    "Pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(sou.ports[1], res.port_a) annotation (Line(points={{-60,0},{-48,0}},
          color={0,127,255}));
  connect(pum.port_b, sin.ports[1]) annotation (Line(points={{10,0},{40,0}},
          color={0,127,255}));
  connect(res.port_b, pum.port_a) annotation (Line(points={{-28,0},{-10,0}},
          color={0,127,255}));
  connect(torSou.flange,pum. shaft) annotation (Line(points={{-20,70},{0,70},
          {0,10}}, color={0,0,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Loads/MotorDrive/ThermoFluid/Examples/Pump.mos"
        "Simulate and plot"),
        Documentation(info="<html>
<p>
Example that simulates a pump using the torque as input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 6, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pump;
