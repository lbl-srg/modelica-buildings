within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function factorial "Calculates the factorial value of the input"
  input Integer j;
  output Integer f;
algorithm
  f := 1;
  for i in 1:j loop
    f := f*i;
  end for;
annotation (Documentation(info="<html>
<p>
This function computes <i>y = j!</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end factorial;
