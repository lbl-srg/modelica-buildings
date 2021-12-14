within Buildings.Fluid.Examples.Performance;
model Example5
  "Example 5 model of Modelica code that is inefficiently compiled into C-code"
  extends Modelica.Icons.Example;
  parameter Boolean efficient = false
  annotation(Evaluate=true);

  parameter Real[3] a = 1:3;
  parameter Real b=sum(a);

  Real c;
initial equation
  c=0;

equation
  der(c) = sin(time)*(if efficient then b else sum(a));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          textColor={0,0,255},
          textString="See code")}),
    experiment(Tolerance=1e-6, StopTime=20),
    Documentation(revisions="<html>
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
</html>", info="<html>
<p>
This example illustrates the impact of
Modelica code formulations on the C-code.
</p>
<p>
Compare the C-code in dsmodel.c when setting the parameter
<code>efficient</code> to <code>true</code> or <code>false</code>
and when adding <code>annotation(Evaluate=true)</code> to the parameter <code>efficient</code>.
</p>
<p>
This produces:
</p>
<h4>Efficient = false and Evaluate = false</h4>
<pre>
helpvar[0] = sin(Time);
F_[0] = helpvar[0]*(IF DP_[0] THEN W_[0] ELSE DP_[1]+DP_[2]+DP_[3]);
</pre>
<h4>Efficient = false and Evaluate = true</h4>
<pre>
helpvar[0] = sin(Time);
F_[0] = helpvar[0]*(DP_[0]+DP_[1]+DP_[2]);
</pre>
<h4>Efficient = true and Evaluate = true</h4>
<pre>
helpvar[0] = sin(Time);
F_[0] = helpvar[0]*W_[1];
</pre>
<p>
The last option requires much less operations to be performed and is therefore more efficient.
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
</html>"), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/Example5.mos"
        "Simulate and plot"));
end Example5;
