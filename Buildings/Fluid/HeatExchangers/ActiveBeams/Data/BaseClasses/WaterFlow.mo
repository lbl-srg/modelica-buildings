within Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses;
record WaterFlow "Record for water parameters"
  extends Modelica.Icons.Record;
  parameter Real r_V[:](each min=0, each final unit="1")
    "Normalized water volume flow rate at user-selected operating points";
  parameter Real f[size(r_V, 1)](each min=0, each unit="1")
    "Normalized performance factor at these flow rates";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe the water volume flow rate versus
the change in the rate of heating or cooling.
</p>
<p>
The normamlized volume flow rate <i>r<sub>V</sub></i> must be strictly increasing, i.e.,
<i>r<sub>V</sub><sup>i</sup> &lt; r<sub>V</sub><sup>i+1</sup></i>.
Both vectors, <i>r<sub>V</sub></i> and <i>f</i>
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
end WaterFlow;
