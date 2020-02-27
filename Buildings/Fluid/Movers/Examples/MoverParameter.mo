within Buildings.Fluid.Movers.Examples;
model MoverParameter
  "Example model of movers using a parameter for setting the stage"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=2
    "Nominal mass flow rate";

  FlowControlled_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    massFlowRates={0,0.5,1}*m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump with m_flow input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=4) "Fluid source"
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=4) "Fluid sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  SpeedControlled_y pump_y(
    redeclare package Medium = Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        speeds_rpm=1800*{0,0.5,1}, constantSpeed_rpm=1800),
    use_inputFilter=false,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump with normalised speed input"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per,
    use_inputFilter=false,
    heads={0,0.5,1}*dp_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump with pressure head input"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal)
    "Pressure drop component for avoiding singular system"
    annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  SpeedControlled_Nrpm pump_Nrpm(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to4 per(
        speeds_rpm={0,1000,2000}, constantSpeed_rpm=2000),
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump with speed input"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  parameter Modelica.Units.SI.PressureDifference dp_nominal=10000
    "Nominal pressure raise";
equation
  connect(sou.ports[1], pump_m_flow.port_a) annotation (Line(
      points={{-60,3},{-60,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_b, sin.ports[1]) annotation (Line(
      points={{10,0},{60,0},{60,3}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_a, pump_dp.port_b)
    annotation (Line(points={{26,-80},{18,-80},{10,-80}}, color={0,127,255}));
  connect(pump_y.port_b, sin.ports[2])
    annotation (Line(points={{10,-40},{60,-40},{60,1}}, color={0,127,255}));
  connect(res.port_b, sin.ports[3])
    annotation (Line(points={{46,-80},{60,-80},{60,-1}}, color={0,127,255}));
  connect(pump_dp.port_a, sou.ports[2])
    annotation (Line(points={{-10,-80},{-60,-80},{-60,1}}, color={0,127,255}));
  connect(pump_y.port_a, sou.ports[3]) annotation (Line(points={{-10,-40},{-20,-40},
          {-60,-40},{-60,-1}}, color={0,127,255}));
  connect(sou.ports[4], pump_Nrpm.port_a) annotation (Line(points={{-60,-3},{-60,
          -3},{-60,34},{-60,40},{-10,40}}, color={0,127,255}));
  connect(pump_Nrpm.port_b, sin.ports[4]) annotation (Line(points={{10,40},{24,40},
          {60,40},{60,-3}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/MoverParameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of a <code>Parameter</code>
set point for a mover model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 17, 2016, by Michael Wetter:<br/>
Updated parameter names for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/396\">#396</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
August 24, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(Tolerance=1e-06, StopTime=1));
end MoverParameter;
