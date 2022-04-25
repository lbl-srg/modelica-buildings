within Buildings.Fluid.Movers.BaseClasses.Characteristics;
record efficiencyParameters_yMot
  "Record for efficiency parameters vs. motor part load ratio"
  extends Modelica.Icons.Record;
  parameter Real y[:](each min=0)
    "Part load ratio, y = PEle/PEle_nominal";
  parameter Modelica.Units.SI.Efficiency eta[size(y, 1)](each max=1)
    "Fan or pump efficiency at these part load ratios";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe efficiency versus part load ratio.
This is used a method to describe the motor efficiency <code>etaMot</code>.
The PLR <code>y</code> must be increasing, i.e.,
<code>y[i] &lt; y[i+1]</code>.
Both vectors, <code>y</code> and <code>eta</code>
must have the same size.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 2, 2022, by Hongxiang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end efficiencyParameters_yMot;
