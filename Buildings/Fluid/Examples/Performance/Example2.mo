within Buildings.Fluid.Examples.Performance;
model Example2 "Example 2 model with series pressure components"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  Fluid.Movers.FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump model with unidirectional flow"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=1)
    "Boundary for absolute pressure boundary condition"
    annotation (Placement(transformation(extent={{-100,10},{-80,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=1) "Pulse input"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FixedResistances.PressureDrop[nRes.k] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes.k})
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.BooleanConstant from_dp(k=true)
    "Block for easily changing parameter from_dp.k"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=6)
    "Number of parallel branches"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(pump_dp.port_a, bou.ports[1]) annotation (Line(
      points={{-60,0},{-80,0}},
      color={0,127,255}));

  connect(pump_dp.dp_in, pulse.y) annotation (Line(
      points={{-50.2,12},{-50.2,30},{-79,30}},
      color={0,0,127}));
  connect(res[1].port_a, pump_dp.port_b) annotation (Line(
      points={{-20,0},{-40,0}},
      color={0,127,255}));
  for i in 1:nRes.k-1 loop
    connect(res[i].port_b, res[i+1].port_a) annotation (Line(
      points={{0,0},{-20,0}},
      color={0,127,255}));
  end for;

  connect(res[nRes.k].port_b, pump_dp.port_a) annotation (Line(
      points={{0,0},{10,0},{10,-18},{-60,-18},{-60,0}},
      color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics),
    experiment(Tolerance=1e-6, StopTime=20),
    Documentation(info="<html>
<p>
This example demonstrates that the use of the parameter <code>from_dp</code>
can be important for reducing the size of algebraic loops in hydraulic
circuits with many pressure drop components connected in series and
a pump setting the pressure head.
</p>
<p>
If <code>from_dp=true</code>, we obtain: <br/>

Sizes of nonlinear systems of equations: {7}<br/>
Sizes after manipulation of the nonlinear systems: {<b>5</b>}<br/>
If <code>from_dp=false</code>, we obtain: <br/>
Sizes of nonlinear systems of equations: {7}<br/>
Sizes after manipulation of the nonlinear systems: {<b>1</b>}<br/>
</p>
<p>
This can have a large impact on computational speed.
</p>
<p>
Following script can be used in Dymola to compare the CPU times.
</p>
<p>
<code>
cpuOld=OutputCPUtime;<br/>
evaluateOld=Evaluate;<br/>
OutputCPUtime:=true;<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example2(from_dp.k=false)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example2\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example2(from_dp.k=true)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example2\");<br/>
createPlot(id=1, position={15, 10, 592, 421}, range={0.0, 10000.0, -0.01, 25}, autoscale=false, grid=true);<br/>
plotExpression(apply(Example2[end-1].CPUtime), false, \"from_dp=false\", 1);<br/>
plotExpression(apply(Example2[end].CPUtime), false, \"from_dp=true\", 1);<br/>
OutputCPUtime=cpuOld;<br/>
Evaluate=evaluateOld;<br/>
</code>
</p>
<p>
See Jorissen et al. (2015) for a discussion.
</p>
<h4>References</h4>
<ul>
<li>
Filip Jorissen, Michael Wetter and Lieve Helsen.<br/>
Simulation speed analysis and improvements of Modelica
models for building energy simulation.<br/>
Submitted: 11th Modelica Conference. Paris, France. Sep. 2015.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
May 20, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/Performance/Example2.mos"
        "Simulate and plot"));
end Example2;
