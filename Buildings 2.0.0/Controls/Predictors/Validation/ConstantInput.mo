within Buildings.Controls.Predictors.Validation;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends
    Buildings.Controls.Predictors.Validation.BaseClasses.PartialSimpleTestCase;
  Modelica.Blocks.Sources.Constant PCon(k=1) "Measured power consumption"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(PCon.y, integrator.u) annotation (Line(
      points={{-69,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{1,-30},{12,-30},{12,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
  experiment(StopTime=5270400),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Validation/ConstantInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Controls.Predictors.Validation.ConstantInputDayOfAdjustment\">
Buildings.Controls.Predictors.Validation.ConstantInputDayOfAdjustment</a>,
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
</html>"));
end ConstantInput;
