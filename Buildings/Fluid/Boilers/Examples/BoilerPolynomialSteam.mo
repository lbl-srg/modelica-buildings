within Buildings.Fluid.Boilers.Examples;
model BoilerPolynomialSteam "Test model"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange(
    p_start=300000,
    T_start=273.15+200);
  parameter Modelica.SIunits.AbsolutePressure p_nominal = 300000
    "Nominal pressure";
  parameter Modelica.SIunits.Temperature T_nominal=
    MediumSte.saturationTemperature(p_nominal)
    "Nominal saturation temperature";
  parameter Modelica.SIunits.Power Q_flow_nominal = 50000 "Nominal power";
  parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.specificEnthalpy(
      MediumSte.setState_pTX(p=p_nominal, T=T_nominal, X=MediumSte.X_default))
    "Nominal change in enthalpy";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dh_nominal/2
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumSte,
    p(displayUnit="bar") = 300000,
    T=423.15,
    nPorts=2) "Sink"
    annotation (Placement(transformation(extent={{82,-22},{62,-2}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    p=300000 + dp_nominal,
    T=303.15,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-22},{-40,-2}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb2(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Fluid.Boilers.BoilerPolynomialSteam boiDyn(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    dp_nominal=dp_nominal) "Steam boiler with dynamic balance"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.TimeTable y(
    table=[0,0; 1200,1; 1200,0; 2000,0; 2000,1; 3600,1])
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Boilers.BoilerPolynomialSteam boiSte(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    dp_nominal=dp_nominal) "Steam boiler with steady state balance"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
equation
  connect(boiDyn.port_b, sin.ports[1])
    annotation (Line(points={{20,-10},{62,-10}}, color={0,127,255}));
  connect(TAmb2.port, boiDyn.heatPort)
    annotation (Line(points={{0,50},{10,50},{10,-2.8}},   color={191,0,0}));
  connect(y.y, boiDyn.y) annotation (Line(points={{-39,50},{-30,50},{-30,-2},{
          -2,-2}}, color={0,0,127}));
  connect(sou.ports[1], boiDyn.port_a)
    annotation (Line(points={{-40,-10},{0,-10}}, color={0,127,255}));
  connect(sou.ports[2], boiSte.port_a) annotation (Line(points={{-40,-14},{-30,
          -14},{-30,-50},{0,-50}}, color={0,127,255}));
  connect(boiSte.port_b, sin.ports[2]) annotation (Line(points={{20,-50},{50,
          -50},{50,-14},{62,-14}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerPolynomialSteam.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
<p>
This example demonstrates the open loop response of the 
steam boiler model. The dynamic boiler includes a control 
signal that is first a ramp from <i>0</i> to <i>1</i>, 
followed by a step that switches the boiler off and then 
on again. The steady boiler is only dependent on the fluid
flow.
</p>
</html>", revisions="<html>
<ul>
<li>
July 23, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerPolynomialSteam;
