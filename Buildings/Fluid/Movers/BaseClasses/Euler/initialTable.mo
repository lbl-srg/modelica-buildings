within Buildings.Fluid.Movers.BaseClasses.Euler;
function initialTable
  "Function for constructing an initial look-up table"
  extends Modelica.Icons.Function;
  input Integer n "Dimension of table (n by n) including headers";
  output Real tab[:,:]=zeros(n,n) "Output table";

algorithm
  for i in 1:(n-1) loop
    tab[1,i+1]:=i;
    tab[i+1,1]:=i;
  end for;

  annotation(Documentation(info="<html>
<p>
This function assigns initial values to look-up tables that comply with
the format requirements of <code>CombiTable2D</code>.
</p>
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
