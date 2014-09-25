within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.Interface;
partial function partialAggFunction
  extends Modelica.Icons.Function;

  input Integer q_max "Number of aggregation levels";
  input Integer p_max "Number of cells by level";
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
