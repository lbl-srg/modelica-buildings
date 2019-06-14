within Buildings.Fluid.FixedResistances.Examples;
model Pipe "Test of a pipe with multiple segments"
  extends Modelica.Icons.Example;

  replaceable package Medium = Buildings.Media.Water;

  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=2*pip.dp_nominal,
    offset=101325 - pip.dp_nominal) annotation (Placement(transformation(extent={{-80,-2},
            {-60,18}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=273.15 + 50,
    nPorts=2) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=2,
    use_p_in=false,
    p(displayUnit="Pa") = 101325)
              annotation (Placement(transformation(extent={{102,-10},{82,10}})));

  HeatTransfer.Sources.FixedTemperature TEnv(T=263.15)
    annotation (Placement(transformation(extent={{-38,30},{-18,50}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    thicknessIns=0.01,
    lambdaIns=0.01,
    m_flow_nominal=10,
    redeclare package Medium = Medium,
    length=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  HeatTransfer.Sources.FixedTemperature TEnv1[10](each T=263.15)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    thicknessIns=0.01,
    lambdaIns=0.01,
    m_flow_nominal=10,
    redeclare package Medium = Medium,
    length=10,
    useMultipleHeatPorts=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=pip.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=pip.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
equation

  connect(P.y, sou.p_in) annotation (Line(points={{-59,8},{-50.5,8},{-50.5,8},{
          -42,8}},
                color={0,0,127}));
  connect(sou.ports[1], pip.port_a) annotation (Line(
      points={{-20,2},{-10,2},{-10,30},{-5.55112e-16,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEnv.port, pip.heatPort) annotation (Line(
      points={{-18,40},{10,40},{10,35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[2], pip1.port_a) annotation (Line(
      points={{-20,-2},{-10,-2},{-10,-30},{-5.55112e-16,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEnv1.port, pip1.heatPorts) annotation (Line(
      points={{-20,-40},{10,-40},{10,-35}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pip.port_b, senTem.port_a) annotation (Line(
      points={{20,30},{30,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, sin.ports[1]) annotation (Line(
      points={{50,30},{70,30},{70,2},{82,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip1.port_b, senTem1.port_a) annotation (Line(
      points={{20,-30},{30,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.port_b, sin.ports[2]) annotation (Line(
      points={{50,-30},{70,-30},{70,-2},{82,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(assEqu.u1, senTem.T) annotation (Line(
      points={{78,76},{72,76},{72,76},{40,76},{40,41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem1.T, assEqu.u2) annotation (Line(
      points={{40,-19},{40,0},{60,0},{60,64},{78,64}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{140,
            100}})),
experiment(Tolerance=1e-6, StopTime=120),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/Pipe.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of a pipe model.
Both pipe models have the same mass flow rates and temperatures.
Otherwise, the <code>assert</code> block would terminate the simulation.
</p>
<p>
The model on the top is connected to the ambient with one heat port,
whereas the model at the bottom uses a vector of heat ports.
Since they are all connected to the same temperature, they
result in the same energy balance for the medium that flows
through the pipe.
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
February 22, 2012 by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
February 12, 2012 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pipe;
