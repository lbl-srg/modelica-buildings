within Buildings.Controls.DemandResponse.Examples.Validation;
model ConstantInput
  "Demand response client with constant input for actual power consumption"
  extends
    Buildings.Controls.DemandResponse.Examples.Validation.BaseClasses.PartialSimpleTestCase;
  Modelica.Blocks.Sources.Constant PCon(k=1) "Measured power consumption"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Math.Gain gain(k=10)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Blocks.Sources.Constant TOffSet(k=293.15)
    "Offset for outside air temperature"
    annotation (Placement(transformation(extent={{-80,-96},{-60,-76}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    "Integrator to compute energy from power"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
      connect(add.u2,TOffSet. y) annotation (Line(
      points={{-2,-86},{-59,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, baseLoad.TOut) annotation (Line(
      points={{21,-80},{28,-80},{28,-6},{38,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y,add. u1) annotation (Line(
      points={{-19,-60},{-12,-60},{-12,-74},{-2,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.u,PCon. y) annotation (Line(
      points={{-42,-60},{-50,-60},{-50,-30},{-59,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PCon.y, integrator.u) annotation (Line(
      points={{-59,-30},{-22,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(integrator.y, baseLoad.ECon) annotation (Line(
      points={{1,-30},{12,-30},{12,0},{38,0}},
      color={0,0,127},
      smooth=Smooth.None));

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
