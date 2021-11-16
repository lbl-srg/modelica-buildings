within Buildings.Fluid.FixedResistances.Examples;
model PlugFlowPipeDiscretized "Simple example of discretized plug flow pipe"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  parameter Integer nSeg=10 "Number of pipe segments";

  Modelica.Blocks.Sources.Ramp Tin(
    height=20,
    duration=0,
    offset=273.15 + 50,
    startTime=100) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized pip(
    redeclare package Medium = Medium,
    nSeg=nSeg,
    dh=0.1,
    totLen=100,
    dIns=0.05,
    kIns=0.028,
    m_flow_nominal=10,
    thickness=0.0032,
    initDelay=true,
    T_start_in=fill(323.15, nSeg)) "Pipe segments"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature
    bou[nSeg](T={283.15 + 2 * i for i in 1:nSeg})
    "Boundary temperature"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=10)
              "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(Tin.y, sou.T_in)
    annotation (Line(points={{-71,4},{-62,4}}, color={0,0,127}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{50,0},{62,0}}, color={0,127,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(bou.port, pip.heatPorts)
    annotation (Line(points={{-20,70},{10,70},{10,10}}, color={191,0,0}));
  connect(pip.port_b, senTemOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PlugFlowPipeDiscretized.mos"
        "Simulate and Plot"),
    experiment(StopTime=1000, Tolerance=1e-006),
    Documentation(info="<html>
<p>Basic test of model
<a href=\"modelica://Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized\">
Buildings.Fluid.FixedResistances.PlugFlowPipeDiscretized</a>.
This test includes an inlet temperature step under a constant mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
July 9, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlugFlowPipeDiscretized;
