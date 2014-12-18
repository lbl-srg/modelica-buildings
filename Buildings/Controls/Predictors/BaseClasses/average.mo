within Buildings.Controls.Predictors.BaseClasses;
function average "Average of past 10 days"
  extends partialBaselinePrediction;
algorithm
    if k == 0 then
      y := 0;
    else
      y :=sum(P[i] for i in 1:k)/k;
    end if;

  annotation (Documentation(info="<html>
<p>
Function that predicts the current load using the average of the previous loads.
The argument <i>k</i> determines how many data points will
be used to compute the average. This is needed as during the
start of the simulation, the complete history is not yet built up.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end average;
