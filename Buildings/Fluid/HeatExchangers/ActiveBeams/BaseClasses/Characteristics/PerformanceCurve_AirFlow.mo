within Buildings.Fluid.HeatExchangers.ActiveBeams.BaseClasses.Characteristics;
record PerformanceCurve_AirFlow "Record for primary air parameters"
  extends Modelica.Icons.Record;
  parameter Real Normalized_AirFlow[:](
    each min=0) "variable at user-selected operating points";
  parameter Real ModFactor[size(Normalized_AirFlow,1)](
     each min=0,
     each displayUnit="1") "modifier f at these flow rates";

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
end PerformanceCurve_AirFlow;
