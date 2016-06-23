within Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses;
record TemperatureDifference "Record for temperature difference"
  extends Modelica.Icons.Record;
  // fixme: is this always bigger than zero, for heating and for cooling?
  //        The comment should say what difference it is, such as roo air minus entering water temperature.
  // answer: yes, it has to be always bigger than zero, for heating and cooling. This means that numerator and denominator must have the same sign.
  // It could be something like: Normalized temperature difference at user-selected operating points. Must be positive.
  //When calculating this value, the rated temperature difference (numerator) and the nominal temperature difference (denominator) must have the same sign.
  parameter Real r_dT[:](each min=0, each final unit="1") "fixme: How is T normalized? Normalized temperature difference at user-selected operating points.
    answer: The normalization is the same as for the other two parameters, rated value divided by nominal value";
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
