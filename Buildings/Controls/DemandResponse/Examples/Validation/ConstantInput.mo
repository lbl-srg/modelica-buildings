within Buildings.Controls.DemandResponse.Examples.Validation;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends
    Buildings.Controls.DemandResponse.Examples.Validation.ConstantInputDayOfAdjustment(
     baseLoad(use_dayOfAdj=false));
  annotation (
  experiment(StopTime=5270400),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/Validation/ConstantInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to 
<a href=\"modelica://Buildings.Controls.DemandResponse.Examples.Validation.ConstantInputDayOfAdjustment\">
Buildings.Controls.DemandResponse.Examples.Validation.ConstantInputDayOfAdjustment</a>,
except that this model does not use any day-of adjustment for the predicted load.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the day-of adjustment for a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
July 11, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end ConstantInput;
