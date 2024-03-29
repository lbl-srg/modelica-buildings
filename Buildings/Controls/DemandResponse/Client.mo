within Buildings.Controls.DemandResponse;
model Client "Demand response client"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  final parameter Modelica.Units.SI.Time tPeriod=24*3600
    "Period, generally one day";

  parameter Integer nSam
    "Number of samples in a day. For 1 hour sampling, set to 24";
  parameter Integer nPre(min=1) = 1
    "Number of intervals for which future load need to be predicted (set to one to only predict current time, or to nSam to predict one day)";

  parameter Integer nHis(min=1) = 10
    "Number of history terms to be stored for baseline computation";

  parameter Buildings.Controls.Predictors.Types.PredictionModel
    predictionModel=
      Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression
    "Load prediction model";

  Buildings.Controls.Interfaces.DayTypeInput typeOfDay[integer((nPre-1)/nSam)+2] "Type of day for the current and the future days for which a prediction is to be made.
    Typically, this has dimension 2 for predictions up to and including 24 hours, and 2+n for any additional day"
  annotation (
      Placement(transformation(extent={{-120,90},{-100,70}}),
        iconTransformation(extent={{-120,90},{-100,70}})));

  Modelica.Blocks.Interfaces.BooleanInput isEventDay
    "If true, this day remains an event day until midnight"
    annotation (Placement(transformation(extent={{-120,50},{-100,30}}),
        iconTransformation(extent={{-120,50},{-100,30}})));
   Modelica.Blocks.Interfaces.RealInput ECon(unit="J")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

  Modelica.Blocks.Interfaces.BooleanInput shed
    "Signal, true if load needs to be shed at the current time"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}}),
        iconTransformation(extent={{-120,-40},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealInput yShed(min=-1, max=1, unit="1")
    "Amount of load to shed. Set to 0.5 to shed 50% of load"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}}),
        iconTransformation(extent={{-120,-60},{-100,-40}})));

  Modelica.Blocks.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
  if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Outside air temperature"
   annotation (Placement(transformation(extent={{-120,-80},{-100,-60}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealInput TOutFut[nPre-1](each unit="K")
    if (predictionModel == Buildings.Controls.Predictors.Types.PredictionModel.WeatherRegression)
    "Future outside air temperatures"
    annotation (Placement(
      transformation(extent={{-120,-100},{-100,-80}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));

  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for the current time interval, taking into account yShed"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput PPreNoShe[nPre](each unit="W")
    "Predicted power consumption for the current and future time intervals, not taking into account yShed"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

protected
  OBC.CDL.Continuous.Multiply she "Outputs load taking shed signal into account"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  OBC.CDL.Routing.RealExtractor extIndRea
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  OBC.CDL.Integers.Sources.Constant conInt(k=1)
    "Outputs 1 to extract the first signal of the demand prediction array"
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  BaseClasses.BaselinePrediction comBasLin(
    final nSam=nSam,
    final nHis=nHis,
    final nPre=nPre,
    final predictionModel=predictionModel)
           "Baseline prediction"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Modelica.Blocks.Logical.Switch switch
    "Switch to select normal or shedded load"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
equation
  connect(comBasLin.ECon, ECon) annotation (Line(
      points={{-61,68},{-80,68},{-80,0},{-110,0}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(isEventDay, comBasLin.isEventDay) annotation (Line(
      points={{-110,40},{-88,40},{-88,74},{-61,74}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(comBasLin.TOut, TOut) annotation (Line(
      points={{-61,65},{-74,65},{-74,-70},{-110,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(typeOfDay, comBasLin.typeOfDay) annotation (Line(
      points={{-110,80},{-86,80},{-86,78},{-61,78}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(comBasLin.TOutFut, TOutFut) annotation (Line(
      points={{-61,61},{-72,61},{-72,-90},{-110,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  // Only PPre[1] will take into account the shedded load.
  connect(switch.y, PPre) annotation (Line(
      points={{89,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(comBasLin.PPre, PPreNoShe) annotation (Line(
      points={{-39,70},{-20,70},{-20,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch.u1, she.y)
    annotation (Line(points={{66,8},{60,8},{60,30},{52,30}}, color={0,0,127}));
  connect(yShed, she.u2) annotation (Line(points={{-110,-50},{24,-50},{24,24},{28,
          24}}, color={0,0,127}));
  connect(shed, switch.u2) annotation (Line(points={{-110,-30},{-12,-30},{-12,0},
          {66,0}}, color={255,0,255}));
  connect(comBasLin.PPre, extIndRea.u)
    annotation (Line(points={{-39,70},{-12,70}}, color={0,0,127}));
  connect(conInt.y, extIndRea.index)
    annotation (Line(points={{-10,30},{0,30},{0,58}}, color={255,127,0}));
  connect(switch.u3, extIndRea.y) annotation (Line(points={{66,-8},{20,-8},{20,70},
          {12,70}}, color={0,0,127}));
  connect(extIndRea.y, she.u1) annotation (Line(points={{12,70},{20,70},{20,36},
          {28,36}}, color={0,0,127}));
  annotation (
    Icon(graphics={
      Text(
          extent={{-70,54},{74,-64}},
          textColor={0,0,255},
          textString="DR")}),
    Documentation(info="<html>
<p>
Model for a data-driven demand response client that predicts the future load and
allows to apply a load shedding factor.
</p>
<p>
This model takes as a parameter the number of samples in a day, which is generally
<i>24</i> for one hour sampling or <i>96</i> for <i>15</i> minute sampling.
Input to the model are the consumed energy up to the current time instant,
the current temperature,
the type of the day, which may be a working day, non-working day or holiday
as defined in
<a href=\"modelica://Buildings.Controls.Types.Day\">
Buildings.Controls.Types.Day</a>,
a boolean signal that indicates whether it is an event day,
and a signal that if <code>true</code>, causes the load to be shed.
The input signal <code>yShed</code> determines how much of the load
will be shed if <code>shed=true</code>. If <code>shed=false</code>, then
this signal is ignored.
</p>
<p>
Output of the model is the prediction of the power that will be consumed
in the current sampling interval, i.e., generally in the next 1 hour or the
next 15 minutes.
If the parameter <code>nPre &gt; 1</code>, then the prediction is done
for multiple time intervals. All of these predictions can be obtained from
the output <code>PPreNoShe</code>. This output does not take into account
<code>yShed</code>.
The output <code>PPre</code> is
<code>PPre = yShed * PPreNoShe[1]</code> if <code>shed=true</code>,
otherwise it is
<code>PPre = PPreNoShe[1]</code>.
</p>
<p>
The baseline prediction is computed in
<a href=\"modelica://Buildings.Controls.Predictors.ElectricalLoad\">
Buildings.Controls.Predictors.ElectricalLoad</a>.
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Michael Wetter:<br/>
Refactored implementation to avoid an infinite event iteration in OpenModelica.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3754\">#3754</a>.
</li>
<li>
October 29, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
March 20, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Client;
