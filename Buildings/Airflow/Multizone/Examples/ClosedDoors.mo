within Buildings.Airflow.Multizone.Examples;
model ClosedDoors "Model with three closed doors"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Specialized.Air.PerfectGas;

  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooAB(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  Buildings.Fluid.MixingVolumes.MixingVolume volA(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volB(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow PrescribedHeatFlow1
    annotation (Placement(transformation(extent={{4,40},{24,60}})));
  Modelica.Blocks.Sources.Sine Sine1(freqHz=1/3600) annotation (Placement(
        transformation(extent={{-68,40},{-48,60}})));
  Modelica.Blocks.Math.Gain Gain1(k=100) annotation (Placement(transformation(
          extent={{-28,40},{-8,60}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volC(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=4,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooAC(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Modelica.Blocks.Sources.Constant yDoor(k=0) "Input signal for door opening"
                                             annotation (Placement(
        transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooBC(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    forceErrorControlOnFlow=true) "Discretized door"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
equation
  connect(Gain1.y, PrescribedHeatFlow1.Q_flow)
    annotation (Line(points={{-7,50},{4,50}}, color={0,0,255}));
  connect(Sine1.y, Gain1.u)
    annotation (Line(points={{-47,50},{-30,50}}, color={0,0,255}));
  connect(yDoor.y, dooAB.y)
                           annotation (Line(points={{-39,-80},{-34,-80},{-34,-20},
          {9,-20}},      color={0,0,255}));
  connect(yDoor.y, dooAC.y)
                           annotation (Line(points={{-39,-80},{-34,-80},{-34,-50},
          {9,-50}},      color={0,0,255}));
  connect(yDoor.y, dooBC.y)
    annotation (Line(points={{-39,-80},{-16,-80},{9,-80}},
                                                         color={0,0,255}));
  connect(PrescribedHeatFlow1.port, volB.heatPort) annotation (Line(
      points={{24,50},{40,50}},
      color={191,0,0}));
  connect(volC.ports[1], dooAC.port_b1) annotation (Line(
      points={{77,-40},{76,-40},{76,-44},{74,-44},{74,-44},{30,-44}},
      color={0,127,255}));
  connect(volC.ports[2], dooAC.port_a2) annotation (Line(
      points={{79,-40},{78,-40},{78,-56},{30,-56}},
      color={0,127,255}));
  connect(volC.ports[3], dooBC.port_b1) annotation (Line(
      points={{81,-40},{80,-40},{80,-74},{30,-74}},
      color={0,127,255}));
  connect(volC.ports[4], dooBC.port_a2) annotation (Line(
      points={{83,-40},{82,-40},{82,-86},{30,-86}},
      color={0,127,255}));
  connect(volB.ports[1], dooAB.port_b1) annotation (Line(
      points={{47,40},{47,14},{46,14},{46,-14},{30,-14}},
      color={0,127,255}));
  connect(volB.ports[2], dooAB.port_a2) annotation (Line(
      points={{49,40},{49,-26},{30,-26}},
      color={0,127,255}));
  connect(volB.ports[3], dooBC.port_a1) annotation (Line(
      points={{51,40},{50,40},{50,0},{-18,0},{-18,-74},{10,-74}},
      color={0,127,255}));
  connect(volB.ports[4], dooBC.port_b2) annotation (Line(
      points={{53,40},{53,2},{-20,2},{-20,-86},{10,-86}},
      color={0,127,255}));
  connect(volA.ports[1], dooAC.port_b2) annotation (Line(
      points={{-73,-5.55112e-16},{-72.6667,-5.55112e-16},{-72.6667,-56},{10,-56}},
      color={0,127,255}));
  connect(volA.ports[2], dooAC.port_a1) annotation (Line(
      points={{-71,-5.55112e-16},{-71,-44},{10,-44}},
      color={0,127,255}));
  connect(volA.ports[3], dooAB.port_b2) annotation (Line(
      points={{-69,-5.55112e-16},{-72,-5.55112e-16},{-72,-26},{10,-26}},
      color={0,127,255}));
  connect(volA.ports[4], dooAB.port_a1) annotation (Line(
      points={{-67,-5.55112e-16},{-67,-14},{10,-14}},
      color={0,127,255}));
  annotation (
experiment(Tolerance=1e-006, StopTime=7200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ClosedDoors.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model consists of three volumes that are connected among
each other through three doors that all have the same geometry.
All doors are closed, but they are not air-tight.
Heat is added and removed from <code>volB</code> which induces
a small air flow through the doors.
</p>
<p>
This model uses
<a href=\"modelica://Buildings.Media.Specialized.Air.PerfectGas\">
Buildings.Media.Specialized.Air.PerfectGas</a>
as the medium because
<a href=\"modelica://Buildings.Media.Air\">
Buildings.Media.Air</a>
does not account for expansion if air the air is heated.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ClosedDoors;
