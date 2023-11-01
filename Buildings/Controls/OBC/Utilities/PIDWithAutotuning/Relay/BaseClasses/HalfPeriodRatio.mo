within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses;
block HalfPeriodRatio
  "Calculate the half period ratio of a response from a relay controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the off period"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
    iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput TunEnd
    "True: the tuning process ends"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput rho
    "Real signal of the half period ratio"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOnSam(
    final y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Block that samples tOn when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler tOffSam(
    final y_start=Buildings.Controls.OBC.CDL.Constants.eps)
    "Block that samples tOff when the tuning period ends"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Min mintOntOff
    "Block that finds the smaller one between the length for the on period and the length for the off period"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxtOntOff
    "Block that finds the larger one between the length for the on period and the length for the off period"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide halPerRat
    "Block that calculates the half period ratio"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(tOnSam.u, tOn)
    annotation (Line(points={{-82,80},{-120,80}}, color={0,0,127}));
  connect(tOffSam.u, tOff)
    annotation (Line(points={{-82,-70},{-120,-70}}, color={0,0,127}));
  connect(tOnSam.y, maxtOntOff.u1) annotation (Line(points={{-58,80},{-52,80},{
          -52,46},{-22,46}},
                         color={0,0,127}));
  connect(maxtOntOff.u2, tOffSam.y) annotation (Line(points={{-22,34},{-40,34},
          {-40,-70},{-58,-70}},color={0,0,127}));
  connect(mintOntOff.u2, tOffSam.y) annotation (Line(points={{-22,-26},{-40,-26},
          {-40,-70},{-58,-70}}, color={0,0,127}));
  connect(maxtOntOff.y, halPerRat.u1) annotation (Line(points={{2,40},{32,40},{
          32,6},{38,6}},
                      color={0,0,127}));
  connect(halPerRat.u2, mintOntOff.y) annotation (Line(points={{38,-6},{10,-6},{
          10,-20},{2,-20}}, color={0,0,127}));
  connect(halPerRat.y, rho) annotation (Line(points={{62,0},{102,0},{102,0},{120,
          0}}, color={0,0,127}));
  connect(tOnSam.y, mintOntOff.u1)
    annotation (Line(points={{-58,80},{-52,80},{-52,
          46},{-28,46},{-28,-14},{-22,-14}},
          color={0,0,127}));
  connect(tOnSam.trigger, TunEnd)
    annotation (Line(points={{-70,68},{-70,0},{-120,0}}, color={255,0,255}));
  connect(tOffSam.trigger, TunEnd)
    annotation (Line(points={{-70,-58},{-70,0},{-120,0}}, color={255,0,255}));
  annotation (defaultComponentName = "halPerRat",
        Diagram(
           coordinateSystem(
           extent={{-100,-100},{100,100}})),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),                                      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
This block calculates the half-period ratio of the output from a relay controller.
</p>
<p align=\"center\" style=\"font-style:italic;\">
&rho; = max(t<sub>on</sub>,t<sub>off</sub>)/ min(t<sub>on</sub>,t<sub>off</sub>),
</p>
<p>
where <code>t<sub>on</sub></code> and <code>t<sub>off</sub></code> are the
lengths of the on period and the off period, respectively.
An On period is defined as the period when the relay switch output of the relay controller is
<code>true</code>.
Likewise, an Off period is defined as the period when the relay switch output is <code>false</code>.
See details of the relay switch output in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Controller</a>.
</p>

<h4>References</h4>
<p>Josefin Berner (2017)
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University. </p>
</html>"));
end HalfPeriodRatio;
