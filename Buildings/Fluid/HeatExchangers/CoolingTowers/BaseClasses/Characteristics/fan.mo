within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;
record fan "Record for fan power consumption"
  extends Modelica.Icons.Record;
  parameter Real r_V[:](each min=0, each unit="1")
    "Volumetric flow rate divided by nominal flow rate at user-selected operating points";
  parameter Real r_P[size(r_V,1)](each max=1)
    "Fan relative power consumption at these flow rates such that r_P = 1 for r_V=1";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe normalized volume flow rate versus
normalized fan power consumption.
The normalized volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
Both vectors, <code>r_V</code> and <code>r_P</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 4, 2016, by Michael Wetter:<br/>
Changed <code>eta</code> to <code>r_P</code> for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/522\">
issue 522</a>.
</li>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end fan;
