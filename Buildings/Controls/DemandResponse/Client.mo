within Buildings.Controls.DemandResponse;
model Client "Demand response client"
  extends Modelica.Blocks.Icons.Block;

  final parameter Modelica.Units.SI.Time tPeriod=24*3600
    "Period, generally one day";
  final parameter Modelica.Units.SI.Time tSample=tPeriod/nSam
    "Sample period, generally 900 or 3600 seconds";
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
  Modelica.StateGraph.InitialStep initialStep(nIn=0, nOut=1)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.StateGraph.Transition transition
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  BaseClasses.BaselinePrediction comBasLin(
    final nSam=nSam,
    final nHis=nHis,
    final nPre=nPre,
    final predictionModel=predictionModel,
    nIn=3,
    nOut=1)
           "Baseline prediction"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.StateGraph.Transition t1 "State transition" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,20})));
  BaseClasses.NormalOperation norOpe(nOut=2, nIn=1)
                                             "Normal operation"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.StateGraph.TransitionWithSignal
                                 t2(enableTimer=false) "State transition"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={10,20})));
  Modelica.StateGraph.TransitionWithSignal t3 "State transition"
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        origin={-2,-30})));
  BaseClasses.ShedOperation she(nIn=1, nOut=1)
                                "Operation during load shedding"
    annotation (Placement(transformation(extent={{-10,-40},{-30,-20}})));
  Modelica.StateGraph.TransitionWithSignal
                                 t4(enableTimer=false) "State transition"
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,10})));
  Modelica.Blocks.Sources.SampleTrigger tri(period=tSample) "Sample trigger"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Logical.Switch switch
    "Switch to select normal or shedded load"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
equation
  connect(initialStep.outPort[1], transition.inPort) annotation (Line(
      points={{-59.5,80},{-34,80}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(transition.outPort, comBasLin.inPort[1]) annotation (Line(
      points={{-28.5,80},{6,80},{6,50.5},{19,50.5},{19,50.6667}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t1.inPort, comBasLin.outPort[1]) annotation (Line(
      points={{60,24},{60,50},{40.5,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t1.outPort, norOpe.inPort[1]) annotation (Line(
      points={{60,18.5},{60,-30},{41,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(comBasLin.ECon, ECon) annotation (Line(
      points={{19,48},{-64,48},{-64,36},{-94,36},{-94,4.44089e-16},{-110,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(comBasLin.PPre[1], norOpe.PCon) annotation (Line(
      points={{41,42},{80,42},{80,-38},{42,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(t2.outPort, comBasLin.inPort[2]) annotation (Line(
      points={{10,21.5},{10,50},{19,50}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t3.outPort, she.inPort[1]) annotation (Line(
      points={{-3.5,-30},{-9,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t4.inPort, she.outPort[1]) annotation (Line(
      points={{-40,6},{-40,-30},{-30.5,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(t4.outPort, comBasLin.inPort[3]) annotation (Line(
      points={{-40,11.5},{-40,50},{-20,50},{-20,49.3333},{19,49.3333}},
      color={0,0,0},
      smooth=Smooth.None));

  connect(t4.condition, tri.y) annotation (Line(
      points={{-52,10},{-66,10},{-66,20},{-69,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(t2.condition, tri.y) annotation (Line(
      points={{-2,20},{-69,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(norOpe.PPre, she.PCon) annotation (Line(
      points={{19,-38},{6,-38},{6,-39},{-8,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(norOpe.active, switch.u2) annotation (Line(
      points={{30,-41},{30,-70},{38,-70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(norOpe.outPort[1], t2.inPort) annotation (Line(
      points={{19.5,-29.75},{10,-29.75},{10,16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(norOpe.outPort[2], t3.inPort) annotation (Line(
      points={{19.5,-30.25},{12,-30.25},{12,-30},{2,-30}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(shed, t3.condition) annotation (Line(
      points={{-110,-30},{-80,-30},{-80,-10},{-2,-10},{-2,-18}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch.u1, she.PCon) annotation (Line(
      points={{38,-62},{10,-62},{10,-39},{-8,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch.u3, she.PPre) annotation (Line(
      points={{38,-78},{-40,-78},{-40,-38},{-31,-38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(isEventDay, comBasLin.isEventDay) annotation (Line(
      points={{-110,40},{-90,40},{-90,54},{19,54}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(comBasLin.TOut, TOut) annotation (Line(
      points={{19,45},{-60,45},{-60,-70},{-110,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(typeOfDay, comBasLin.typeOfDay) annotation (Line(
      points={{-110,80},{-90,80},{-90,58},{19,58}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(comBasLin.TOutFut, TOutFut) annotation (Line(
      points={{19,41},{-56,41},{-56,-90},{-110,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(yShed, she.yShed) annotation (Line(
      points={{-110,-50},{-48,-50},{-48,-14},{-6,-14},{-6,-32},{-9,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  // Only PPre[1] will take into account the shedded load.
  connect(switch.y, PPre) annotation (Line(
      points={{61,-70},{90,-70},{90,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(comBasLin.PPre, PPreNoShe) annotation (Line(
      points={{41,42},{80,42},{80,50},{110,50}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Icon(graphics={                      Text(
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
