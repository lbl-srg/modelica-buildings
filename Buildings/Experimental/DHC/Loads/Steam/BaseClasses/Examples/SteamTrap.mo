within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model SteamTrap "Example model to demonstrate the steam trap"
  extends Modelica.Icons.Example;

  package MediumWat = Buildings.Media.Water "Water medium";

  parameter Modelica.Units.SI.Temperature TSatHig=273.15+110
     "High pressure saturation temperature";
  parameter Modelica.Units.SI.Temperature TSatLow=273.15+100
     "Low pressure saturation temperature";
  parameter Modelica.Units.SI.AbsolutePressure pSat=143380
     "Saturation pressure";
  parameter Modelica.Units.SI.PressureDifference dp=pSat-101325
    "Prescribed pressure change";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=10
    "Nominal mass flow rate";

  Modelica.Blocks.Sources.Ramp ram(
    height=m_flow_nominal,
    duration(displayUnit="min") = 60,
    startTime(displayUnit="min") = 60)
    "Ramp"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    p=pSat,
    T=TSatHig,
    nPorts=1)
    "Source"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumWat,
    p=pSat - dp,
    T=TSatLow,
    nPorts=1)
    "Sink"
    annotation (Placement(transformation(extent={{90,0},{70,20}})));
  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.SteamTrap steTra(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    show_T=true)
    "Steam trap"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort hIn(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal)
    "Inflowing specific enthalpy"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort hOut(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal)
    "Outflowing specific enthalpy"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(pum.port_b, sin.ports[1])
    annotation (Line(points={{60,10},{70,10}}, color={0,127,255}));
  connect(ram.y, pum.m_flow_in)
    annotation (Line(points={{-59,70},{50,70},{50,22}}, color={0,0,127}));
  connect(sou.ports[1], hIn.port_a)
    annotation (Line(points={{-70,10},{-60,10}}, color={0,127,255}));
  connect(hIn.port_b, steTra.port_a)
    annotation (Line(points={{-40,10},{-30,10}}, color={0,127,255}));
  connect(steTra.port_b, hOut.port_a)
    annotation (Line(points={{-10,10},{0,10}}, color={0,127,255}));
  connect(hOut.port_b, pum.port_a)
    annotation (Line(points={{20,10},{40,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=180.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Steam/BaseClasses/Examples/SteamTrap.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example model demonstrates the performance of the steam trap with a ramped mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamTrap;
