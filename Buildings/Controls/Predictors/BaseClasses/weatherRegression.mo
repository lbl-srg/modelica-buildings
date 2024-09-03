within Buildings.Controls.Predictors.BaseClasses;
function weatherRegression "Linear weather regression model"
  extends partialBaselinePrediction;
  input Modelica.Units.SI.Temperature TCur "Current temperature";
  input Modelica.Units.SI.Temperature T[:]
    "Vector of temperatures of each interval of the current time of day";
protected
  Modelica.Units.SI.Temperature TAve "Average temperature";
  Modelica.Units.SI.Power PAve "Average power";
 Real den(unit="K2") "Denominator";
 Real a "Intercept";
 Real b "Slope";
algorithm
    if k == 0 then
      y := 0;
    else
      TAve :=sum(T[i] for i in 1:k)/k;
      PAve :=sum(P[i] for i in 1:k)/k;
      den := sum((T[i]-TAve)^2 for i in 1:k);
      if den > Modelica.Constants.eps then
        b := sum((T[i]-TAve)*(P[i]-PAve) for i in 1:k)/den;
      else
        b := 0;
      end if;
      a := PAve - b * TAve;
      y := a + b*TCur;
    end if;

  annotation (Documentation(info="<html>
<p>
Function that predicts the current load using a linear regression model.
The load is assumed to be linear in the temperature.
The argument <i>k</i> determines how many data points will
be used for the regression. This is needed as during the
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
end weatherRegression;
