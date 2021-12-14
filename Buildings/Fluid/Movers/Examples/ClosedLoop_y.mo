within Buildings.Fluid.Movers.Examples;
model ClosedLoop_y "Flow machine with feedback control"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";

  Modelica.Blocks.Sources.Pulse y(
    offset=0.25,
    startTime=0,
    amplitude=0.5,
    period=15*60) "Input signal"
                 annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=2) annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan(
      redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Fan"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.Continuous.LimPID conPID(
    Td=1,
    k=0.5,
    Ti=15) annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Math.Gain gain1(k=1/m_flow_nominal)
    annotation (Placement(transformation(extent={{-22,70},{-2,90}})));
equation
  connect(sou.ports[1], senMasFlo.port_a) annotation (Line(
      points={{-62,22},{-52,22},{-52,50},{-40,50}},
      color={0,127,255}));
  connect(senMasFlo.port_b, dp1.port_a) annotation (Line(
      points={{-20,50},{-5.55112e-16,50}},
      color={0,127,255}));
  connect(dp1.port_b, fan.port_a) annotation (Line(
      points={{20,50},{40,50}},
      color={0,127,255}));
  connect(fan.port_b, dp2.port_a) annotation (Line(
      points={{60,50},{80,50}},
      color={0,127,255}));
  connect(dp2.port_b, sou.ports[2]) annotation (Line(
      points={{100,50},{110,50},{110,18},{-62,18}},
      color={0,127,255}));
  connect(senMasFlo.m_flow, gain1.u) annotation (Line(
      points={{-30,61},{-30,80},{-24,80}},
      color={0,0,127}));
  connect(gain1.y, conPID.u_m) annotation (Line(
      points={{-1,80},{10,80},{10,98}},
      color={0,0,127}));
  connect(y.y, conPID.u_s) annotation (Line(
      points={{-59,110},{-2,110}},
      color={0,0,127}));
  connect(conPID.y, fan.y) annotation (Line(
      points={{21,110},{50,110},{50,62}},
      color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Documentation(info="<html>
<p>
This example demonstrates the use of a fan with closed loop control.
The fan is controlled to track a required mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/ClosedLoop_y.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end ClosedLoop_y;
