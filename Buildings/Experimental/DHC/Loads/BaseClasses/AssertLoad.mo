within Buildings.Experimental.DHC.Loads.BaseClasses;
block AssertLoad
  "Block that checks whether the time averaged load is met"

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Nominal heat flow rate";
  parameter Modelica.SIunits.Time perAve = 60
    "Period for time average";
  parameter Real tol = 2E-2
    "Tolerance as a ratio to the nominal heat flow rate";
  constant Modelica.SIunits.Time perIniIgn = 3600
    "Initial period during which unmet load is ignored";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QReq_flow(final unit="W")
    "Required heat flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QAct_flow(
    final unit="W")
    "Actual heat flow rate"
    annotation (Placement(transformation(extent={{-140,-80},
    {-100,-40}}), iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaReq_flow(
    final delta=perAve) "Time average"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k2=-1)
    "Compute difference"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Compute absolute value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=tol*abs(Q_flow_nominal))
    "Compare within tolerance"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert ass(
    u(start=true, fixed=true),
    message="In " + getInstanceName() + ": The time averaged load difference " +
    "exceeds the threshold.")
    "Yield warning"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Modelica.Blocks.Sources.BooleanExpression boolExp(
    y=time - startTime < perIniIgn)
    "Check if model elapsed time is lower than initial period"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or  or2
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
protected
  parameter Real startTime(fixed=false);
initial equation
  startTime = time;
equation
  connect(add2.y, QAveHeaReq_flow.u)
    annotation (Line(points={{-48,0},{-42,0}}, color={0,0,127}));
  connect(QReq_flow, add2.u1) annotation (Line(points={{-120,60},{-80,60},{-80,6},
          {-72,6}}, color={0,0,127}));
  connect(QAct_flow, add2.u2) annotation (Line(points={{-120,-60},{-80,-60},{-80,
          -6},{-72,-6}}, color={0,0,127}));
  connect(QAveHeaReq_flow.y, abs1.u)
    annotation (Line(points={{-18,0},{-12,0}},
                                             color={0,0,127}));
  connect(abs1.y, lesThr.u)
    annotation (Line(points={{12,0},{18,0}}, color={0,0,127}));
  connect(lesThr.y, or2.u2) annotation (Line(points={{42,0},{50,0},{50,-8},{58,-8}},
        color={255,0,255}));
  connect(boolExp.y, or2.u1) annotation (Line(points={{21,40},{54,40},{54,0},{58,
          0}}, color={255,0,255}));
  connect(or2.y, ass.u) annotation (Line(points={{82,0},{90,0},{90,-20},{40,-20},
          {40,-40},{58,-40}}, color={255,0,255}));
  annotation (
    defaultComponentName="assLoa",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                 Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-112},{150,-152}},
          textString="%name",
          lineColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block yields a warning if the time averaged absolute value
of the difference between a required heat flow rate and its actual 
value exceeds a threshold.
No warning is yielded as long as the model elapsed time is lower than
the constant <code>perIniIgn = 3600</code> s.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end AssertLoad;
