within Buildings.Utilities.Math.Functions.Examples;
model Polynomial
  extends Modelica.Icons.Example;
  Real x "Function value";
equation
  x=Buildings.Utilities.Math.Functions.polynomial(x=time^3-2, a={2, 4, -4, 5});

 annotation(experiment(StartTime=0, StopTime=4, Tolerance=1E-6),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/Polynomial.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example verifies the correct implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.polynomial\">
Buildings.Utilities.Math.Functions.polynomial</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2016, by Michael Wetter:<br/>
Renamed example and removed derivative computation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/602\">issue 602</a>.
</li>
<li>
April 22, 2016, by Michael Wetter:<br/>
Changed accuarcy test in assertion to use the relative error because the
magnitude of <code>x</code> is <i>1E6</i> and hence testing an absolute
error is too stringent.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/510\">Buildings, issue 510</a>.
</li>
<li>
August 17, 2015 by Michael Wetter:<br/>
Updated regression test to have slope that is different from one.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Polynomial;
