within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation.Examples;
function aggregateLoad
  extends Modelica.Icons.Function;

  input Integer n_max=14;
  input Integer p_max=2;
  // for n_max = 14 and p_max=2 --> q_max = 3

  input Integer q_max=BaseClasses.nbOfLevelAgg(
      n_max, p_max);

  input Modelica.SIunits.Power QNew = 2 "New load element";
  input Modelica.SIunits.Power[q_max,p_max] QAggOld = fill(1,q_max,p_max)
    "Aggregated load matrix form the previous time step";

  output Integer[q_max] rArr=
      BaseClasses.cellWidth(                             q_max, p_max);
  output Integer[q_max,p_max] nuMat=
      BaseClasses.nbPulseAtEndEachLevel(
        q_max,
        p_max,
        rArr);
  output Modelica.SIunits.Power[q_max,p_max] QMat;
algorithm
  QMat := Aggregation.aggregateLoad(
    q_max=q_max,
    p_max=p_max,
    rArr=rArr,
    nuMat=nuMat,
    QNew=QNew,
    QAggOld=QAggOld);

    annotation (Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end aggregateLoad;
