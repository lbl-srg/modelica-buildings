within Buildings.Fluid.HeatExchangers.ActiveBeams.Data.BaseClasses;
record TemperatureDifference "Record for temperature difference"
  extends Modelica.Icons.Record;
  parameter Real r_dT[:](each min=0, each final unit="1")
   "Normalized temperature difference, e.g., temperature difference at
 user-selected operating points divided by nominal temperature difference.
 Must be positive.";
  parameter Real f[size(r_dT, 1)](each min=0, each final unit="1")
    "Normalized performance factor at these normalized temperature differences";

  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe the normalized
temperature difference
versus the change in the rate of heating or cooling.
The normalized temperature difference is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
r<sub>&#916;T</sub><sup>i</sup>=
&#916;T<sup>i</sup> &frasl; &#916;T<sub>nominal</sub>
=
(T<sub>w</sub><sup>i</sup>-T<sub>z</sub>)
&frasl;
(T<sub>w,nominal</sub>-T<sub>z</sub>),
</p>
<p>
where
<i>T<sub>w</sub><sup>i</sup></i> is the water inlet temperature,
<i>T<sub>z</sub></i> is the zone air temperature and
<i>T<sub>w,nominal</sub></i> is the nominal water inlet temperature.
</p>
<p>
The normalized temperature difference <i>r<sub>&#916;T</sub></i> must be strictly increasing, i.e.,
<i>r<sub>&#916;T</sub><sup>i</sup> &lt; r<sub>&#916;T</sub><sup>i+1</sup></i>.
Both vectors, <i>r<sub>&#916;T</sub></i> and <i>f</i>
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
