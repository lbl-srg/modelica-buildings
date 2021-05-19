within Buildings.Fluid.Humidifiers.Validation;
model SprayAirWasher_X
  "Model that demonstrates the spray air washer model, configured as steady-state"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = m_flow_nominal * 0.004
    "Maximum humidification water mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=180,origin={110,0})));

  replaceable Buildings.Fluid.Humidifiers.SprayAirWasher_X hum(
    mWatMax_flow=mWat_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
      constrainedby Buildings.Fluid.Humidifiers.SprayAirWasher_X(
        redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal,
        dp_nominal=6000,
        show_T=true) "Humidifier with capacity limitation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Sources.CombiTimeTable XSet(
    tableOnFile=false,
    table=[
      0.0,   0.01;
      1*180, 0.012;
      2*180, 0.015;
      3*180, 0.01;
      4*180, 0.008;
      5*180, 0.004;
      6*180, 0.01],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Set point for humidity"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Fluid.Sensors.MassFractionTwoPort senHum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Mass fraction sensor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(sou1.ports[1], hum.port_a)
    annotation (Line(points={{-40,0},{-10,0},{20,0}},      color={0,127,255}));
  connect(XSet.y[1], hum.X_w) annotation (Line(points={{-19,50},{0,50},{0,6},{18,
          6}},       color={0,0,127}));
  connect(hum.port_b, senHum.port_a)
    annotation (Line(points={{40,0},{60,0}},     color={0,127,255}));
  connect(senHum.port_b, sin.ports[1]) annotation (Line(points={{80,0},{92,0},{
          100,0},{100,1.11022e-15}},              color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}})),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/SprayAirWasher_X.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that validates the use of a spray air washer
configured as a steady-state model with limits on the maximum water mass flow rate
that is added to the air stream.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2021, by Michael Wetter:<br/>
Reformulated constraint of replaceable model to avoid access of
component that is not in constraining type.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1473\">IBPSA, #1473</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1080,
      Tolerance=1e-6));
end SprayAirWasher_X;
