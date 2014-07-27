within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.BaseClasses;
function cellWidth
  " Calculates the width of the cell of each level. The width increase exponential with base 2 "
  extends Interface.partialAggFunction;

  output Integer[q_max] rArr "width of cell at each level";

algorithm
  for i in 1:q_max loop
    rArr[i] := integer(2^(i - 1));
  end for;

    annotation (Documentation(info="<html>
    <p>Calculates the width of the cell of each level. The width increase exponential with base 2.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end cellWidth;
