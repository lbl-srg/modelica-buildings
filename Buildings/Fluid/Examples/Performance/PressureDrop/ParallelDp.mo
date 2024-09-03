within Buildings.Fluid.Examples.Performance.PressureDrop;
model ParallelDp
  "Parallel connection with prescribed pressure difference and non-optimised parameters"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  parameter Integer nRes(min=2) = 10 "Number of resistances";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true)
      "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.Pulse pulse_p(
    period=1,
    offset=Medium.p_default,
    amplitude=dp_nominal) "Pulse input for pressure"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  FixedResistances.PressureDrop[nRes] resParallel(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes},
    each from_dp=false) "Parallel pressure drop components"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure boundary condition"
      annotation (Placement(transformation(
          extent={{60,-10},{40,10}})));
equation
  connect(pulse_p.y,sou. p_in) annotation (Line(points={{-79,8},{-70,8},{-62,8}},
                     color={0,0,127}));
  for i in 1:nRes-1 loop
    connect(resParallel[i].port_a, resParallel[i + 1].port_a)
      annotation (Line(points={{-10,0},{-10,0}}, color={0,127,255}));
    connect(resParallel[i].port_b, resParallel[i + 1].port_b)
      annotation (Line(points={{10,0},{10,0}}, color={0,127,255}));
  end for;
  connect(resParallel[nRes].port_b, sin.ports[1])
    annotation (Line(points={{10,0},{10,0},{40,0}}, color={0,127,255}));
  connect(resParallel[1].port_a, sou.ports[1])
    annotation (Line(points={{-10,0},{-20,0},{-40,0}}, color={0,127,255}));

   annotation (    Documentation(revisions="<html>
<ul>
<li>
May 26, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example model that demonstrates how translation statistics
depend on the type of boundary conditions,
the parallel or series configuration of the components
and the value of parameter <code>from_dp</code>.
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/ParallelDp.mos"
        "Simulate and plot"));
end ParallelDp;
