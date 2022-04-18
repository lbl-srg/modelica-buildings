within Buildings.Experimental.DHC.Plants.Steam.BaseClasses.Examples;
model BoilerPolynomial
  "Example model for the steam boiler with a polynomial efficiency curve"
  extends Modelica.Icons.Example;

  // Medium declarations
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - port_a (inlet)";
  package MediumSte = Buildings.Media.Steam
     "Steam medium - port_b (oulet)";

  // Nominal conditions
  parameter Modelica.Units.SI.AbsolutePressure p_nominal = 300000
    "Nominal pressure";
  parameter Modelica.Units.SI.Temperature T_nominal=
    MediumSte.saturationTemperature(p_nominal)
    "Nominal saturation temperature";
  parameter Modelica.Units.SI.Power Q_flow_nominal = 50000 "Nominal power";
  parameter Modelica.Units.SI.SpecificEnthalpy dh_nominal=
    MediumSte.specificEnthalpy(
      MediumSte.setState_pTX(p=p_nominal, T=T_nominal, X=MediumSte.X_default))
    "Nominal change in enthalpy";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    Q_flow_nominal/dh_nominal/2
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Modelica.Blocks.Sources.TimeTable y(
    table=[0,0; 1200,1; 1200,0; 2000,0; 2000,1; 3600,1])
    "Load ratio"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumSte,
    p(displayUnit="bar") = 300000,
    T=423.15,
    nPorts=2)
    "Sink"
    annotation (Placement(transformation(extent={{60,-20},{40,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumWat,
    p=300000 + dp_nominal,
    T=303.15,
    nPorts=2)
    "Source"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Experimental.DHC.Plants.Steam.BaseClasses.BoilerPolynomial boiDyn(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    dp_nominal=dp_nominal)
    "Steam boiler with dynamic balance"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Experimental.DHC.Plants.Steam.BaseClasses.BoilerPolynomial boiSte(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=Q_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    dp_nominal=dp_nominal)
    "Steam boiler with steady state balance"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
equation
  connect(TAmb.port, boiDyn.heatPort)
    annotation (Line(points={{-20,50},{-10,50},{-10,-2.8}},
                                                          color={191,0,0}));
  connect(y.y, boiDyn.y)
    annotation (Line(points={{-59,50},{-50,50},{-50,-2},{-22,-2}},
                   color={0,0,127}));
  connect(sou.ports[1], boiSte.port_a)
    annotation (Line(points={{-60,-11},{-50,-11},{-50,-50},{-20,-50}},
                                   color={0,127,255}));
  connect(boiDyn.port_a, sou.ports[2]) annotation (Line(points={{-20,-10},{-60,
          -10},{-60,-9}}, color={0,127,255}));
  connect(boiSte.port_b, sin.ports[1]) annotation (Line(points={{0,-50},{30,-50},
          {30,-11},{40,-11}}, color={0,127,255}));
  connect(boiDyn.port_b, sin.ports[2])
    annotation (Line(points={{0,-10},{40,-10},{40,-9}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Steam/BaseClasses/Examples/BoilerPolynomial.mos"
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
end BoilerPolynomial;
