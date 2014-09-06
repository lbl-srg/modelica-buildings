within Buildings.Controls.DemandResponse.Examples.Validation.BaseClasses;
partial model PartialSimpleTestCase
  "Partial base class for simple test case of base load prediction"
  extends Modelica.Icons.Example;
  // fixme: scaling factor for easier debugging
  parameter Modelica.SIunits.Time tPeriod = 24*3600 "Period";
  parameter Modelica.SIunits.Time tSample = 3600 "Sampling period";
  parameter Integer nPre(min=1) = 12 "Number of time steps to predict";
  BaselinePrediction baseLoad(
      final nPre=nPre,
      use_dayOfAdj=false,
      predictionModel=Buildings.Controls.DemandResponse.Types.PredictionModel.Average)
    "Baseload prediction"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.BooleanPulse tri(
    width=4/24*100/7,
    period=7*tPeriod,
    startTime=1.5*tPeriod) "Sample trigger"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Sources.DayType dayType[nPre]
    "Outputs the type of the day for each hour where load is to be predicted"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(dayType.y, baseLoad.typeOfDay) annotation (Line(
      points={{-19,40},{40,40},{40,10},{58,10}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(tri.y, baseLoad.isEventDay) annotation (Line(
      points={{-19,80},{44,80},{44,5},{58,5}},
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
