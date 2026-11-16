within Buildings.Fluid.DataCenters.Racks.FanControllers.Types;
type Strategy         = enumeration(
  OutletTemperature "Rack outlet temperature",
  Load "IT Load") "Control strategy"
  annotation (Evaluate=true,Documentation(info="<html>
<p>
Enumeration to define the fan control strategy.
The possible values are:
</p>
<ol>
<li>
OutletTemperature
</li>
<li>
Load
</li>
</ol>
</html>",revisions="<html>
<ul>
<li>
September 28, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
