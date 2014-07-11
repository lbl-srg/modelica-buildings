within Buildings.Controls.DemandResponse.Examples.Validation.BaseClasses;
partial model PartialSimpleTestCase
  "Partial base class for simple test case of base load prediction"
  extends Modelica.Icons.Example;
  // fixme: scaling factor for easier debugging
  parameter Modelica.SIunits.Time tPeriod = 24*3600 "Period";
  parameter Modelica.SIunits.Time tSample = 3600 "Sampling period";
  BaselinePrediction baseLoad(predictionModel=Buildings.Controls.DemandResponse.Types.PredictionModel.WeatherRegression,
      use_dayOfAdj=false) "Baseload prediction"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.BooleanPulse  tri(
    width=4/24*100/7,
    period=7*tPeriod,
    startTime=1.5*tPeriod) "Sample trigger"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Sources.DayType dayType "Outputs the type of the day"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(dayType.y, baseLoad.typeOfDay) annotation (Line(
      points={{-19,10},{38,10}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(baseLoad.isEventDay, tri.y) annotation (Line(
      points={{38,5},{0,5},{0,50},{-19,50}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
Partial base class to build test for the load prediction.
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
end PartialSimpleTestCase;
