within Buildings.Controls.OBC.Utilities.BaseClasses;
block RelayHalfPeriodRatio
  "Calculates the half period ratio of a response from a relay controller"

  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        tOn
    "Connector for setpoint input signal"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput                        tOff
    "Connector for setpoint input signal"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Min tmin "The minimum value of tOn and tOff"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretmin
    "Check if both tOn and tOff are both larger than 0"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant                        minLen(final k=0)
    "Minimum value for the horizon length"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOnSample(y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sampling tOn when the tuning period ends"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOffSample(y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Sampling tOff when the tuning period ends"
    annotation (Placement(transformation(extent={{0,-60},{20,-80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tminSample
    "Sampling the tmin when tmin is larger than 0"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gretminChange
    "Checking if either tOn or tOff changes after they both becomes positive"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Min mintOntOff "The smaller one between tOn and tOff"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxtOntOff "The larger one between tOn and tOff"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide halfPeriodRatioCal "Calculating the half period ratio"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput halfPeriodRatio
    "Connector for a output signal of the half period ratio"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(tmin.u1, tOn) annotation (Line(points={{-82,36},{-92,36},{-92,60},{-120,
          60}},      color={0,0,127}));
  connect(tmin.u2, tOff) annotation (Line(points={{-82,24},{-94,24},{-94,-60},{-120,
          -60}},    color={0,0,127}));
  connect(tmin.y, gretmin.u1)
    annotation (Line(points={{-58,30},{-42,30}}, color={0,0,127}));
  connect(minLen.y, gretmin.u2) annotation (Line(points={{-58,-10},{-48,-10},{-48,
          22},{-42,22}}, color={0,0,127}));
  connect(tOnSample.u, tOn)
    annotation (Line(points={{-2,60},{-120,60}}, color={0,0,127}));
  connect(tOffSample.u, tOff) annotation (Line(points={{-2,-70},{-94,-70},{-94,-60},
          {-120,-60}}, color={0,0,127}));
  connect(tOnSample.trigger, tOffSample.trigger) annotation (Line(points={{10,48},
          {10,26},{-12,26},{-12,-40},{10,-40},{10,-58}}, color={255,0,255}));
  connect(tminSample.u, gretmin.u1) annotation (Line(points={{-2,0},{-8,0},{-8,52},
          {-48,52},{-48,30},{-42,30}}, color={0,0,127}));
  connect(gretminChange.u1, gretmin.u1) annotation (Line(points={{-42,-40},{-86,
          -40},{-86,16},{-52,16},{-52,30},{-42,30}}, color={0,0,127}));
  connect(tminSample.y, gretminChange.u2) annotation (Line(points={{22,0},{22,-56},
          {-42,-56},{-42,-48}}, color={0,0,127}));
  connect(gretmin.y, tminSample.trigger) annotation (Line(points={{-18,30},{-10,
          30},{-10,-18},{10,-18},{10,-12}}, color={255,0,255}));
  connect(gretminChange.y, tOffSample.trigger)
    annotation (Line(points={{-18,-40},{10,-40},{10,-58}}, color={255,0,255}));
  connect(tOnSample.y, maxtOntOff.u1) annotation (Line(points={{22,60},{30,60},{
          30,66},{38,66}}, color={0,0,127}));
  connect(maxtOntOff.u2, tOffSample.y) annotation (Line(points={{38,54},{28,54},
          {28,-70},{22,-70}}, color={0,0,127}));
  connect(mintOntOff.u2, tOffSample.y) annotation (Line(points={{38,-76},{28,-76},
          {28,-70},{22,-70}}, color={0,0,127}));
  connect(mintOntOff.u1, maxtOntOff.u1) annotation (Line(points={{38,-64},{30,-64},
          {30,66},{38,66}}, color={0,0,127}));
  connect(maxtOntOff.y, halfPeriodRatioCal.u1) annotation (Line(points={{62,60},
          {72,60},{72,20},{52,20},{52,6},{58,6}}, color={0,0,127}));
  connect(halfPeriodRatioCal.u2, mintOntOff.y) annotation (Line(points={{58,-6},
          {52,-6},{52,-50},{70,-50},{70,-70},{62,-70}}, color={0,0,127}));
  connect(halfPeriodRatioCal.y, halfPeriodRatio)
    annotation (Line(points={{82,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the half-period ratio of the responses from a relay controller, <i>&rho;</i>, by</p>
<p>&rho; = max(t<sub>on</sub>,t<sub>off</sub>)/ min(t<sub>on</sub>,t<sub>off</sub>) </p>
<p>where <i>t<sub>on</sub></i> and <i>t<sub>on</sub></i> are the length of the On period and the Off period, respectively.</p>
</html>"));
end RelayHalfPeriodRatio;
