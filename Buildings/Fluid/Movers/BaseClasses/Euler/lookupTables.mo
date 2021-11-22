within Buildings.Fluid.Movers.BaseClasses.Euler;
record lookupTables
  "Record for efficiency and power curves computed with Euler number"
  extends Modelica.Icons.Record;
  parameter Real eta[11,11](each min=0, each max=1)=
    Buildings.Fluid.Movers.BaseClasses.Euler.initialTable(11)
    "Look-up table for mover efficiency";
  parameter Real P[11,11](each min=0)=
    Buildings.Fluid.Movers.BaseClasses.Euler.initialTable(11)
    "Look-up table for mover power";

  annotation (
Documentation(info="<html>
<p>
Record for both efficiency and power look-up tables computed from the Euler number.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 29, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end lookupTables;
