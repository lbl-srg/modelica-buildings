within Buildings.Fluid.Movers.BaseClasses.Euler;
function initialTable
  "Function for constructing an initial look-up table"
  extends Modelica.Icons.Function;
  output Real tab[:,:]=zeros(12,12) "Output table";

algorithm
  for i in 2:12 loop
    tab[1,i]:=i;
    tab[i,1]:=i;
  end for;

  annotation(Documentation(info="<html>
<p>
This function assigns initial values to look-up tables in
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables\">
Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables</a>.
This function is useful when the look-up table must both
</p>
<ul>
<li>
have a fixed size so that it can be used as a component of a function output
</li>
<li>
and comply with the format requirements of
<a href=\"modelica://Modelica.Blocks.Tables.CombiTable2D\">
Modelica.Blocks.Tables.CombiTable2D</a>
even when it is not used.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
November 22, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end initialTable;
