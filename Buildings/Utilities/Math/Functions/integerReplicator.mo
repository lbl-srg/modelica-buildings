within Buildings.Utilities.Math.Functions;
function integerReplicator "Replicates integer signals"
  extends Modelica.Icons.Function;
  input Integer nout "Number of outputs";
  input Integer u "Integer input signal";
  output Integer y[nout] "Integer output signals";

algorithm
  y :=fill(u, nout);

  annotation (Documentation(info="<html>
<p>This function replicates the integer input signal to an array of
<code>nout</code> identical output signals. </p>
</html>", revisions="<html>
<ul>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
Implementation based on Kaustubh Phalak&apos;s block
<a href=\"modelica://Buildings.Utilities.Math.IntegerReplicator\">
Buildings.Utilities.Math.IntegerReplicator</a>.
</li>
</ul>
</html>"));
end integerReplicator;
