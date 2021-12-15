within Buildings.Controls.Predictors.Validation.BaseClasses;
partial model PartialSimpleTestCase
  "Partial base class for simple test case of base load prediction"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Time tPeriod=24*3600 "Period";
  parameter Modelica.Units.SI.Time tSample=3600 "Sampling period";
  parameter Integer nPre(min=1) = 12 "Number of time steps to predict";
  ElectricalLoad baseLoad(
      final nPre=nPre,
      use_dayOfAdj=false,
      predictionModel=Buildings.Controls.Predictors.Types.PredictionModel.Average)
    "Baseload prediction"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Sources.BooleanPulse tri(
    width=4/24*100/7,
    period=7*tPeriod,
    startTime=1.5*tPeriod) "Sample trigger"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Sources.DayType dayType(nout=2)
    "Outputs the type of the day for each hour where load is to be predicted"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Logical.Not notEventDay
    "Output true if it is not an event day"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  // The Sampler is reimplemented to avoid in Dymola 2016 the translation warning
  // for the models in the parent package:
  //   The initial conditions for variables of type Boolean are not fully specified.
  //   Dymola has selected default initial conditions.
  //   Assuming fixed default start value for the discrete non-states:
  //     ...firstTrigger(start = false)
  //     ...
protected
  block Sampler
    extends Modelica.Blocks.Discrete.Sampler(
      firstTrigger(start=false, fixed=true));
  end Sampler;
equation
  connect(tri.y, notEventDay.u) annotation (Line(
      points={{-19,80},{-2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(notEventDay.y, baseLoad.storeHistory) annotation (Line(
      points={{21,80},{44,80},{44,5},{58,5}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(dayType.y, baseLoad.typeOfDay) annotation (Line(
      points={{-19,40},{18,40},{18,10},{58,10}},
      color={0,127,0},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
Partial base class to build test for the load prediction.
</p>
<p>
This model has been added to the library to verify and demonstrate the correct implementation
of the load prediction model based on a simple input scenario.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2015 by Michael Wetter:<br/>
Implemented <code>Sampler</code> to avoid a translation warning
because <code>Sampler.firstTrigger</code> does not set the <code>fixed</code>
attribute in MSL 3.2.1.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialSimpleTestCase;
