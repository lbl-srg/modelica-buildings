within Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses;
record AirFlow "Record for primary air parameters"
  extends Modelica.Icons.Record;
  parameter Real r_V[:](each min=0, each final unit="1")
    "Normalized air volume flow rate at user-selected operating points";
  parameter Real f[size(r_V, 1)](each min=0, each final unit="1")
    "Normalized performance factor at these flow rates";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe the air volume flow rate versus
the change in the rate of heating or cooling.
</p>
<p>
The normamlized volume flow rate <code>r_V</code> must be strictly increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
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
end AirFlow;
