within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics;
record PerformanceCurve_TempDiff "Record for temperature difference"
  extends Modelica.Icons.Record;
  // fixme: is this always bigger than zero, for heating and for cooling?
  //        The comment should say what difference it is, such as roo air minus entering water temperature.
  parameter Real r_T[:](each min=0, each final unit="1")
    "fixme: How is T normalized? Normalized temperature difference at user-selected operating points";
  parameter Real ModFactor[size(r_T, 1)](each min=0, each final unit="1")
    "Normalized performance factor at these flow rates";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
efficiency.
The volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
Both vectors, <code>r_V</code> and <code>eta</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCurve_TempDiff;
