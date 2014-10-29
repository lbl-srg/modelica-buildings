within Buildings.Controls.Predictors.Examples.Validation;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends
    Buildings.Controls.Predictors.Examples.Validation.BaseClasses.PartialSimpleTestCase;
  Modelica.Blocks.Sources.Constant PCon(k=1) "Measured power consumption"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  Modelica.Blocks.Math.Gain gain(k=10)
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Modelica.Blocks.Sources.Constant TOffSet(k=293.15)
    "Offset for outside air temperature"
    annotation (Placement(transformation(extent={{-88,-96},{-68,-76}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-8,-90},{12,-70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(add.u2,TOffSet. y) annotation (Line(
      points={{-10,-86},{-67,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, baseLoad.TOut) annotation (Line(
      points={{13,-80},{20,-80},{20,-6},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y,add. u1) annotation (Line(
      points={{-29,-60},{-20,-60},{-20,-74},{-10,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u,PCon. y) annotation (Line(
      points={{-52,-60},{-60,-60},{-60,-30},{-69,-30}},
      color={0,0,127},
      smooth=Smooth.None));
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
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Examples/Validation/ConstantInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to 
<a href=\"modelica://Buildings.Controls.Predictors.Examples.Validation.ConstantInputDayOfAdjustment\">
Buildings.Controls.Predictors.Examples.Validation.ConstantInputDayOfAdjustment</a>,
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end ConstantInput;
