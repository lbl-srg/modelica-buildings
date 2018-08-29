within Buildings.Controls.Predictors.Examples;
model BESTEST "This example applies the load prediction to a BESTEST model"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600;
  ElectricalLoad preReg(predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Load prediction based on regression"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  Sources.DayType dayType(days={Buildings.Controls.Types.Day.WorkingDay})
    "Day type, set to use always the same day as BESTEST case 600 has no weekly schedule"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Sources.BooleanConstant storeResults
    "Boolean signal to store the results for the regression"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
  Modelica.Blocks.Math.Add preErr(k1=1/4000, k2=-1/4000)
    "Prediction error, normalized by peak power"
    annotation (Placement(transformation(extent={{200,0},{220,20}})));
equation
  connect(dayType.y, preReg.typeOfDay) annotation (Line(
      points={{141,70},{154,70},{154,30},{158,30}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(storeResults.y, preReg.storeHistory) annotation (Line(
      points={{141,40},{150,40},{150,25},{158,25}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(EHea.y, preReg.ECon) annotation (Line(
      points={{-11.6,40},{32,40},{32,20},{158,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, preReg.TOut) annotation (Line(
      points={{4,-88},{80,-88},{80,14},{158,14}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(preErr.u2, gaiHea.y) annotation (Line(
      points={{198,4},{100,4},{100,34},{-49.6,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preErr.u1, preReg.PPre[1]) annotation (Line(
      points={{198,16},{190,16},{190,20},{181,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(extent={{-100,-100},{240,100}},
          preserveAspectRatio=false), graphics),
    experiment(
      StopTime=2.6784e+06,
      Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/Predictors/Examples/BESTEST.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example applies the load prediction to the heating load of
BESTEST case 600.
On the right hand side of the model is the load prediction.
It is configured to compute a regression based on the outdoor temperature.
The output of the load prediction is compared with the actual
heating power. This comparison is done in the block
<code>preErr</code> which outputs the prediction error,
normalized by the roughly the maximum heating power.
</p>
<p>
The figure below shows the predicted and simulated heating power, and the
normalized prediction error.
</p>
<p align=\"center\">
<img alt=\"Result comparison\"
  src=\"modelica://Buildings/Resources/Images/Controls/Predictors/Examples/BESTEST.png\" border=\"1\" />
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BESTEST;
