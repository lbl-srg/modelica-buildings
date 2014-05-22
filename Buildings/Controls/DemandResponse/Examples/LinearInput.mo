within Buildings.Controls.DemandResponse.Examples;
model LinearInput
  "Demand response client with actual power consumption being linear in the temperature"
  extends
    Buildings.Controls.DemandResponse.Examples.BaseClasses.PartialSimpleTestCase(
      baseLoad(predictionModel=Buildings.Controls.DemandResponse.Types.PredictionModel.WeatherRegression));
  Modelica.Blocks.Sources.Ramp   TOut(
    offset=283.15,
    y(unit="K", displayUnit="degC"),
    height=10,
    duration=1.8144e+06) "Outside temperature"
    annotation (Placement(transformation(extent={{-92,-80},{-72,-60}})));
  Modelica.Blocks.Sources.Constant POffSet(k=1) "Offset for power"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
  Modelica.Blocks.Math.Add add(k2=0.2)
    annotation (Placement(transformation(extent={{-30,-36},{-10,-16}})));
  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Math.Add err(k2=-1) "Prediction error"
    annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
  Modelica.Blocks.Discrete.Sampler sampler(samplePeriod=tSample)
    "Sampler to turn PCon into a piece-wise constant signal. This makes it easier to verify the results"
    annotation (Placement(transformation(extent={{0,-36},{20,-16}})));
equation
  connect(TOut.y, baseLoad.TOut) annotation (Line(
      points={{-71,-70},{32,-70},{32,-6},{38,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(POffSet.y, add.u1) annotation (Line(
      points={{-69,-20},{-32,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.u, TOut.y) annotation (Line(
      points={{-62,-40},{-66,-40},{-66,-70},{-71,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(baseLoad.PPre, err.u1) annotation (Line(
      points={{61,0},{64,0},{64,-24},{68,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sampler.u) annotation (Line(
      points={{-9,-26},{-2,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler.y, baseLoad.PCon) annotation (Line(
      points={{21,-26},{28,-26},{28,8.88178e-16},{38,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sampler.y, err.u2) annotation (Line(
      points={{21,-26},{44,-26},{44,-36},{68,-36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(to_degC.y, add.u2) annotation (Line(
      points={{-39,-40},{-36,-40},{-36,-32},{-32,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  experiment(StopTime=1.8144e+06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/DemandResponse/Examples/LinearInput.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is identical to 
<a href=\"modelica://Buildings.Controls.DemandResponse.Examples.SineInput\">
Buildings.Controls.DemandResponse.Examples.SineInput</a>,
except that the input <code>client.PCon</code> is linear in the temperature.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the baseline prediction model based on a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end LinearInput;
