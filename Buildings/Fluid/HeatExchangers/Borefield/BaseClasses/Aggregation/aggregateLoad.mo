within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Aggregation;
function aggregateLoad
  extends Interface.partialAggFunction;

  input Integer[q_max] rArr;
  input Real QNew "New load element";
  input Real[q_max,p_max] QAggOld
    "Aggregated load matrix form the previous time step";
  input Integer[q_max,p_max] nuMat "number of pulse at the end of each cells";

  output Real[q_max,p_max] QAggNew "New aggregated load matrix";

protected
  Integer q_pre;
  Integer p_pre;
  Real QShiPreCell "load from the previous cell";

algorithm
  for q in 1:q_max loop
    for p in 1:p_max loop
      if p == 1 and q == 1 then
        QShiPreCell := QNew;   //New load
      else
        (q_pre,p_pre) := BaseClasses.previousCellIndex(
          q_max=q_max,
          p_max=p_max,
          q=q,
          p=p);
        QShiPreCell := QAggOld[q_pre, p_pre];
      end if;

      //Load from previous cell
      //new load at QAgg[q,p] = initial load in the cell + shifted load from the previous cell, spread over the width of the cell
      //                                                     - one block of the initial load on the cell (which is going to the next cell).
      QAggNew[q, p] := QAggOld[q, p] + (QShiPreCell - QAggOld[q, p])/rArr[q];

    end for;
  end for;

    annotation (Documentation(info="<html>
    <p>Update the aggregation load matrix by shifting the previous load deeper in the matrix and by inserting the new load QNew.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end aggregateLoad;
