within Buildings.Fluid.HeatExchangers.Validation;
model EvaporatorCondenser "Test model for the evaporator or condenser model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";

  Buildings.HeatTransfer.Sources.FixedTemperature ref(T=283.15)
    "Refrigerant temperature"
    annotation (Placement(transformation(extent={{-64,-60},{-44,-40}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFlo
    "Heat flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=0.1,
    use_m_flow_in=true,
    T=323.15) "Flow source"
    annotation (Placement(transformation(extent={{-44,-10},{-24,10}})));

  Modelica.Fluid.Sources.FixedBoundary sin(
    redeclare package Medium = Medium,
    p=0,
    nPorts=1) "Sink"
         annotation (Placement(transformation(extent={{78,-10},{58,10}})));

  Buildings.Fluid.HeatExchangers.EvaporatorCondenser eva(
    redeclare package Medium = Medium,
    m_flow(start=0.1),
    dp(start=10),
    UA=100,
    dp_nominal=0,
    tau=5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal) "Evaporator"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Blocks.Sources.Ramp m_flow(
    duration=100,
    height=9*m_flow_nominal,
    offset=m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState) "Temperature sensor"
    annotation (Placement(transformation(extent={{24,-10},{44,10}})));
equation
  connect(ref.port, heaFlo.port_a)
    annotation (Line(points={{-44,-50},{-37,-50},{-30,-50}}, color={191,0,0}));
  connect(heaFlo.port_b, eva.port_ref)
    annotation (Line(points={{-10,-50},{0,-50},{0,-6}},  color={191,0,0}));
  connect(sou.ports[1], eva.port_a)
    annotation (Line(points={{-24,0},{-10,0}}, color={0,127,255}));
  connect(m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-67,8},{-44,8}}, color={0,0,127}));
  connect(eva.port_b, senTem.port_a)
    annotation (Line(points={{10,0},{18,0},{24,0}}, color={0,127,255}));
  connect(senTem.port_b, sin.ports[1])
    annotation (Line(points={{44,0},{52,0},{58,0}}, color={0,127,255}));
  annotation (    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/EvaporatorCondenser.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=100),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.EvaporatorCondenser\">
Buildings.Fluid.HeatExchangers.EvaporatorCondenser</a> model.
</p>
<p>
The fluid flow rate is increased from <i>m&#775; = 0.01 kg/s</i> to
<i>m&#775; = 0.10 kg/s</i> over 100 seconds. As a result, the heat exchanger
effectiveness and the fluid temperature difference in the heat exchanger
decrease.
</p>
</html>", revisions="<html>
<ul>
<li>
October 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end EvaporatorCondenser;
