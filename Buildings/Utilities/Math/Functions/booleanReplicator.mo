within Buildings.Utilities.Math.Functions;
function booleanReplicator "Replicates Boolean signals"
  extends Modelica.Icons.Function;
  input Integer nout=1 "Number of outouts";
  input Boolean u "Boolean input signal";
  output Boolean y[nout] "Boolean output signals";

algorithm
  y :=fill(u, nout);

  annotation (Documentation(info="<html>
<p>This function replicates the boolean input signal to an array of <code>nout</code> identical output signals. </p>
</html>", revisions="<html>
<ul>
<li>November 28, 2013, by Marcus Fuchs:<br/>
Implementation based on Kaustubh Phalak&apos;s block
<a href=\"modelica://Buildings.Utilities.Math.BooleanReplicator\">
Buildings.Utilities.Math.BooleanReplicator</a>.
</li>
</ul>
</html>"));
end booleanReplicator;
