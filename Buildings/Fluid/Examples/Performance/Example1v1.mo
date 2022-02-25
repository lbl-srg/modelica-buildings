within Buildings.Fluid.Examples.Performance;
model Example1v1 "Example 1 model without mixing volume"
  extends Buildings.Fluid.Examples.Performance.BaseClasses.Example1(
      allowFlowReversal(k=false), from_dp(k=true));

equation
  for i in 1:nRes.k loop
    connect(res[i].port_b, val.port_3) annotation (Line(
      points={{90,30},{100,30},{100,-10},{20,-10},{20,20}},
      color={0,127,255}));
  end for;
  annotation (experiment(
      Tolerance=1e-6, StopTime=20),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,
            100}}), graphics={Ellipse(
          extent={{66,0},{74,-8}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}),
    Documentation(info="<html>
<p>
This model demonstrates the impact of the <code>allowFlowReversal</code>
and <code>from_dp</code> parameters on the sizes of nonlinear algebraic loops.
The user can change the parameter value in the respective
<code>BooleanConstant</code> blocks and rerun the simulation to compare the performance.
The results are also demonstrated below for <code>nRes.k = 20</code>,
the number of parallel branches, which contain one pressure drop element each.
</p>
<p>
These results were generated using Dymola 2015FD01 64 bit on Ubuntu 14.04.
</p>
<h4>Default case:</h4>
<p>
<code>AllowFlowReversal = true</code> and <code>from_dp = false</code>
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21, <b>46</b>}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19, <b>22</b>}
</p>
<h4>Change 1: </h4>
<p>
<code>AllowFlowReversal = false</code> and <code>from_dp = false</code>
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19}
</p>
<h4>Change 2: </h4>
<p>
<code>AllowFlowReversal = false</code> and <code>from_dp = true</code>
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, <b>1</b>}
</p>
<p>
These changes also have a significant impact on the computational speed.
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
simulateModel(\"Buildings.Fluid.Examples.Performance.Example1v1(allowFlowReversal.k=true, from_dp.k=false)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example1v1\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example1v2(from_dp.k=true, allowFlowReversal.k=true)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example1v2\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example1v1(allowFlowReversal.k=false, from_dp.k=false)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example1v1\");<br/>
simulateModel(\"Buildings.Fluid.Examples.Performance.Example1v1(allowFlowReversal.k=false, from_dp.k=true)\", stopTime=10000, numberOfIntervals=10, method=\"dassl\", resultFile=\"Example1v1\");<br/>
createPlot(id=1, position={15, 10, 592, 421}, range={0.0, 10000.0, -0.01, 0.35}, autoscale=false, grid=true);<br/>
plotExpression(apply(Example1v1[end-2].CPUtime), false, \"Default case\", 1);<br/>
plotExpression(apply(Example1v2[end].CPUtime), false, \"Adding dummy states\", 1);<br/>
plotExpression(apply(Example1v1[end-1].CPUtime), false, \"allowFlowReversal=false\", 1);<br/>
plotExpression(apply(Example1v1[end].CPUtime), false, \"allowFlowReversal=false, from_dp=true\", 1);<br/>
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
</html>", revisions="<html>
<ul>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/Example1v1.mos"
        "Simulate and plot"));
end Example1v1;
