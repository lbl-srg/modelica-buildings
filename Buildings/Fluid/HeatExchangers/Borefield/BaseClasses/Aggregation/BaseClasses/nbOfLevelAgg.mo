within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.BaseClasses;
function nbOfLevelAgg
  "Calculate the number of level necessary to aggregate the whole load and set the value of v_max, q_max and rArr"

  input Integer n_max "nb of load step to aggreagate";
  input Integer p_max "number of cells by level";
  output Integer q_max "number of levels";
  output Integer v_max "nb of pulse covered by aggregation";

protected
  Integer i_lev;
algorithm
  v_max := 0;
  i_lev := 0;

  while v_max < n_max and i_lev < 100 loop
    v_max := v_max + integer(2^i_lev)*p_max;
    i_lev := i_lev + 1;
  end while;

  assert(i_lev < 100,
    "Too many or zero levels. Increase the nbOfCells by levels");

  q_max := i_lev;

    annotation (Documentation(info="<html>
    <p>Calculate the number of level necessary to aggregate the whole load and set the value of v_max, q_max and rArr.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end nbOfLevelAgg;
