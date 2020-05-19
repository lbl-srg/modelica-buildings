within Buildings.Fluid.CHPs.BaseClasses.Types;
type Mode = enumeration(
    Off "Plant completely turned off",
    StandBy "Plant ready to run but not producing heat/electricity",
    PumpOn "Pump starts to run",
    WarmUp "Warm-up mode",
    Normal "Normal operating mode",
    CoolDown "Cool-down before going to stand-by or off mode")
  "Enumeration for operation mode types"
annotation (
  Documentation(info="<html>
<p>
Enumeration for the type of modes.
The possible values are:
</p>
<ol>
<li>
Off
</li>
<li>
StandBy
</li>
<li>
PumpOn
</li>
<li>
WarmUp
</li>
<li>
Normal
</li>
<li>
CoolDown
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
June 18, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
