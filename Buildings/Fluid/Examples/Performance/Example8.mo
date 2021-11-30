within Buildings.Fluid.Examples.Performance;
model Example8 "Common subexpression elimination example"
  extends Modelica.Icons.Example;
  Real a = sin(time+1);
  Real b = sin(time+1);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          textColor={0,0,255},
          textString="See code")}),
    experiment(
      Tolerance=1e-6, StopTime=50),
    Documentation(revisions="<html>
<ul>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
June 18, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a very simple example demonstrating common subexpression elimination.
The Dymola generated <code>C-code</code> of this model is:
</p>
<pre>
W_[0] = sin(Time+1);
W_[1] = W_[0];
</pre>
<p>
Hence, the sine and addition are evaluated once only, which is more efficient.
</p>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/Example8.mos"
        "Simulate and plot"));
end Example8;
