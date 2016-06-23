within Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses;
record TemperatureDifference "Record for temperature difference"
  extends Modelica.Icons.Record;
  parameter Real r_dT[:](each min=0, each final unit="1")
   "Normalized temperature difference, e.g., temperature difference at user-selected operating points divided by nominal temperature difference. Must be positive.";
  parameter Real f[size(r_dT, 1)](each min=0, each final unit="1")
    "Normalized performance factor at these flow rates";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe the normalized
temperature difference (fixme: explain how the normalization should be done)
versus the change in the rate of heating or cooling.
</p>
<p>
The normalized temperature difference <code>r_dT</code> must be strictly increasing, i.e.,
<code>r_dT[i] &lt; r_dT[i+1]</code>.
Both vectors, <code>r_V</code> and <code>f</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 13, 2016, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 20, 2016, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureDifference;
