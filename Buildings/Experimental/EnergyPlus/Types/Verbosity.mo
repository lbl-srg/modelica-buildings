within Buildings.Experimental.EnergyPlus.Types;
type Verbosity = enumeration(
    Quiet "No output",
    Medium "Output mainly during initialization and shut-down",
    TimeStep "Output at each time step") "Enumeration for the day types" annotation (
    Documentation(info="<html>
<p>
Enumeration for the level of outputs written by EnergyPlus.
The possible values are:
</p>
<ol>
<li>
Quiet
</li>
<li>
Medium
</li>
<li>
TimeStep
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 21, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
