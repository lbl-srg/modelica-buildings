within Buildings.Fluid.Boilers.Examples;
model BoilerSteamTwoPort "Test model"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Interfaces.PartialWaterPhaseChange(
    pSatHig = 110000,
    redeclare package MediumWat = Buildings.Media.Water (
      T_max = 273.15+300));

  parameter Modelica.SIunits.Power Q_flow_nominal = 3000 "Nominal power";
  parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumSte,
    nPorts=2,
    p(displayUnit="Pa") = pSatHig,
    T=333.15) "Sink"
    annotation (Placement(transformation(extent={{90,-68},{70,-48}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    nPorts=2,
    redeclare package Medium = MediumWat,
    p=pSatHig+dp_nominal,
    T=303.15)
    annotation (Placement(transformation(extent={{-80,-68},{-60,-48}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,
        1; 3600,1])
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Fluid.Boilers.BoilerSteamTwoPort boi1(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    pSatHig=pSatHig,
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal = m_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Boiler"
    annotation (Placement(transformation(extent={{0,-2},{20,18}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Fluid.Boilers.BoilerSteamTwoPort boi2(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    pSatHig=pSatHig,
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal = m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue()) "Boiler"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(sou.ports[1], boi1.port_a) annotation (Line(
      points={{-60,-56},{-36,-56},{-36,8},{0,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], boi2.port_a) annotation (Line(
      points={{-60,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(
      points={{0,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(
      points={{20,8},{40,8},{40,-56},{70,-56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, boi1.y) annotation (Line(
      points={{-59,-20},{-50,-20},{-50,16},{-2,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y.y, boi2.y) annotation (Line(
      points={{-59,-20},{-50,-20},{-50,-52},{-22,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAmb.port, boi1.heatPort)
    annotation (Line(points={{-40,50},{10,50},{10,15.2}}, color={191,0,0}));
  connect(TAmb.port, boi2.heatPort)
    annotation (Line(points={{-40,50},{-10,50},{-10,-52.8}}, color={191,0,0}));
  annotation (             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerSteamTwoPort.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
This example demonstrates the open loop response of the boiler
model for a control signal that is first a ramp from <i>0</i>
to <i>1</i>, followed by a step that switches the boilers off and
then on again.
The instances of the boiler models are parameterized
so that <code>boi1</code> is a dynamic model and
<code>boi2</code> is a steady-state model.
</html>", revisions="<html>
</html>"));
end BoilerSteamTwoPort;
