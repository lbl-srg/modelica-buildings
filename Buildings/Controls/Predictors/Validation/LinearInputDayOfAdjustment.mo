within Buildings.Controls.Predictors.Validation;
model LinearInputDayOfAdjustment
  "Demand response client with constant input for actual power consumption"
  extends Buildings.Controls.Predictors.Validation.LinearInput(
     baseLoad(use_dayOfAdj=true));

  annotation (
  experiment(StopTime=5270400),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Validation/LinearInputDayOfAdjustment.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Controls.Predictors.Validation.LinearInput\">
Buildings.Controls.Predictors.Validation.LinearInput</a>,
except that the demand respond client is configured to use the day-of adjustment.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the baseline prediction model based on a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LinearInputDayOfAdjustment;
