within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.Interface;
partial function partialAggFunction
  input Integer q_max "number of levels";
  input Integer p_max "number of cells by level";
    annotation (Documentation(info="<html>
    <p></p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end partialAggFunction;
