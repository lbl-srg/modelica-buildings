within Buildings.ThermalZones.EnergyPlus.Types;
type Verbosity = enumeration(
    Fatal "Fatal errors",
    Error "Errors",
    Warning "Warnings",
    Info "Information",
    Verbose "Verbose, including calls in initialization and shut-down",
    Debug "Output at each time step") "Enumeration for the day types" annotation (
    Documentation(info="<html>
<p>
Enumeration for the level of outputs written by EnergyPlus.
The possible values are:
</p>
<ol>
<li>
Fatal
</li>
<li>
Error
</li>
<li>
Warning
</li>
<li>
Info
</li>
<li>
Verbose
</li>
<li>
Debug
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
September 25, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 21, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
