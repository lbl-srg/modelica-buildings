within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses;
partial record PipeDataBaseDefinition
  "BaseClass for experimental data from the pipe test bench"
      extends Modelica.Icons.Record;
      parameter Integer n "Number of measurement data point";
      parameter Real[:, 1+n] data
    "Time in s | measure 1 | measure 2 | ... | measure n |";
      annotation(Documentation(info="<html>
<p>
Defines basic record of experimental data with <code>n</code> measured points.
The first column corresponds to <code>time</code>, further columns to measured data.
</p>
</html>",
revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
Move experiment documentation to the <a href=\"modelica://Buildings.Experimental.Pipe.Data.PipeDatauLg150801\">
specific model</a>. Add parameter <code>n</code> to facilitate use of extends clause.
</li>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add documentation about the test bench and how is conducted the experiment
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeDataBaseDefinition;
