within Buildings.Templates.Plants.Controls.Utilities;
block TimerWithReset
  "Timer measuring the time from the time instant where the Boolean input became true"
  parameter Real t(
    final quantity="Time",
    final unit="s")=0
    "Threshold time for comparison";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input that switches timer on if true, and off if false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset
    "Reset signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Time",
    final unit="s")
    "Elapsed time"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput passed
    "True if the elapsed time is greater than threshold"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Reset input edge"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor
    "Output true if only one input is true"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=t)
    "Measuring time and check if bolean input has been true more than threshold time"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(reset, edg.u)
    annotation (Line(points={{-120,-80},{-82,-80}}, color={255,0,255}));
  connect(edg.y, xor.u2) annotation (Line(points={{-58,-80},{-20,-80},{-20,-8},{
          -2,-8}}, color={255,0,255}));
  connect(u, xor.u1)
    annotation (Line(points={{-120,0},{-2,0}}, color={255,0,255}));
  connect(xor.y, tim.u)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(tim.y, y) annotation (Line(points={{62,0},{120,0}}, color={0,0,127}));
  connect(tim.passed, passed) annotation (Line(points={{62,-8},{80,-8},{80,-80},
          {120,-80}}, color={255,0,255}));
  annotation (
    defaultComponentName="tim",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{-66,-60},{82,-60}},
          color={192,192,192}),
        Line(
          points={{-58,68},{-58,-80}},
          color={192,192,192}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90,-60},{68,-52},{68,-68},{90,-60}}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-58,90},{-66,68},{-50,68},{-58,90}}),
        Line(
          points={{-56,-60},{-38,-60},{-38,-16},{40,-16},{40,-60},{68,-60}},
          color={255,0,255}),
        Line(
          points={{-58,0},{-40,0},{40,58},{40,0},{68,0}},
          color={0,0,127}),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-64,62},{62,92}},
          textColor={0,0,0},
          textString="t=%t"),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,-73},{85,-87}},
          lineColor=DynamicSelect({235,235,235},if passed then
                                                              {0,255,0} else
                                                                           {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if passed then
                                                              {0,255,0} else
                                                                           {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 5, 2026, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
FIXME: should be replaced by 
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Generic.TimerWithReset
once issue2293_chiller_plant_seq is merged.
</html>"));
end TimerWithReset;
