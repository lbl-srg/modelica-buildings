within Buildings.Controls.DemandResponse.Examples;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends SineInput(redeclare Modelica.Blocks.Sources.Constant PCon(k=1));
  annotation (
  experiment(StopTime=1.8144e+06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/ConstantInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to 
<a href=\"modelica://Buildings.Controls.DemandResponse.Examples.SineInput\">
Buildings.Controls.DemandResponse.Examples.SineInput</a>,
except that the input <code>client.PCon</code> is a constant signal.
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
end ConstantInput;
