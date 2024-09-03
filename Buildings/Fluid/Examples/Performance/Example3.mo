within Buildings.Fluid.Examples.Performance;
model Example3
  "Example 3 model with mixed series/parallel pressure drop components"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  Fluid.Movers.FlowControlled_m_flow pump(
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
                                               annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-10})));
  Modelica.Blocks.Sources.Pulse pulse(period=1) "Pulse input"
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));

  FixedResistances.PressureDrop[nRes.k] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) + (if mergeDp.k then 0 else
        dp_nominal) for i in 1:nRes.k}) "First pressure drop component"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.BooleanConstant mergeDp(k=true)
    "Block for easily changing parameter mergeDp.k"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  Modelica.Blocks.Sources.BooleanConstant from_dp(k=true)
    "Block for easily changing parameter from_dp.k"
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})));
  FixedResistances.PressureDrop[nRes.k] res1(
    redeclare package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    each dp_nominal=if mergeDp.k then 0 else dp_nominal)
    "Second pressure drop component"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=6)
    "Block for easily changing parameter nRes.k"
    annotation (Placement(transformation(extent={{20,-42},{40,-22}})));
equation
  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{-60,0},{-80,0}},
      color={0,127,255}));
  connect(pulse.y, pump.m_flow_in) annotation (Line(
      points={{-79,24},{-50.2,24},{-50.2,12}},
      color={0,0,127}));
  connect(res.port_b, res1.port_a) annotation (Line(
      points={{0,0},{20,0}},
      color={0,127,255}));
  for i in 1:nRes.k loop
    connect(res[i].port_a, pump.port_b) annotation (Line(
      points={{-20,0},{-40,0}},
      color={0,127,255}));
    connect(res1[i].port_b, pump.port_a) annotation (Line(
      points={{40,0},{50,0},{50,20},{-60,20},{-60,0}},
      color={0,127,255}));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -60},{60,40}}),    graphics),
    experiment(Tolerance=1e-6, StopTime=20),
    Documentation(revisions="<html>
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
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates the importance of merging
pressure drop components that are connected in series,
into one pressure drop component.
Parameter <code>mergeDp.k</code> can be used to merge two components
that are connected in series.
Parameter <code>from_dp</code> also has an influence of the computational speed.
</p>
<p>
Following script can be used in Dymola to compare the CPU times.
For this script to work, make sure that Dymola stores at least 4 results.
</p>
<p>
<code>
cpuOld=OutputCPUtime;<br/>
evaluateOld=Evaluate;<br/>
OutputCPUtime:=true;<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example3(from_dp.k=false, mergeDp.k=false, nRes.k=10)\", stopTime=1000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example3\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example3(from_dp.k=false, mergeDp.k=true, nRes.k=10)\", stopTime=1000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example3\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example3(from_dp.k=true, mergeDp.k=false, nRes.k=10)\", stopTime=1000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example3\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example3(from_dp.k=true, mergeDp.k=true, nRes.k=10)\", stopTime=1000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example3\");<br/>
createPlot(id=1, position={15, 10, 592, 421}, range={0.0, 1000.0, -0.01, 8}, autoscale=false, grid=true);<br/>
plotExpression(apply(Example3[end-3].CPUtime), false, \"from_dp=false, mergeDp=false\", 1);<br/>
plotExpression(apply(Example3[end-2].CPUtime), false, \"from_dp=false, mergeDp=true\", 1);<br/>
plotExpression(apply(Example3[end-1].CPUtime), false, \"from_dp=true, mergeDp=false\", 1);<br/>
plotExpression(apply(Example3[end].CPUtime), false, \"from_dp=true, mergeDp=true\", 1);<br/>
OutputCPUtime=cpuOld;<br/>
Evaluate=evaluateOld;</code>
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
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/Example3.mos"
        "Simulate and plot"));
end Example3;
