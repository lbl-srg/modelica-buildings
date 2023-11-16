within Buildings.Templates.Components.Controls;
block MultipleCommands
  "Block that converts command signals for multiple units"

  parameter Integer nUni(final min=1, start=1)
    "Number of units"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    "Command signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1One
    "On/Off signal: true if at least one unit is commanded On"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),  iconTransformation(
          extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnBou
    "Number of units that are commanded On, with lower bound of 1"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOn
    "Number of units that are commanded On"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nUni]
    "Convert to real"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=nUni)
    "Total"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum value"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(nin=nUni)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
equation
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(max1.y, nUniOnBou)
    annotation (Line(points={{92,-60},{120,-60}},
                                                color={0,0,127}));
  connect(mulSum.y, nUniOn) annotation (Line(points={{12,0},{120,0}},
                 color={0,0,127}));
  connect(one.y, max1.u2)
    annotation (Line(points={{42,-60},{50,-60},{50,-66},{68,-66}},
                                                             color={0,0,127}));
  connect(mulSum.y, max1.u1) annotation (Line(points={{12,0},{60,0},{60,-54},{
          68,-54}},
                color={0,0,127}));
  connect(y1, booToRea.u)
    annotation (Line(points={{-120,0},{-62,0}}, color={255,0,255}));
  connect(y1, mulOr.u) annotation (Line(points={{-120,0},{-80,0},{-80,60},{-62,60}},
        color={255,0,255}));
  connect(y1One, mulOr.y)
    annotation (Line(points={{120,60},{-38,60}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This block computes the following variables based on a Boolean array
representing the On/Off command signal for a group of multiple
units, such as parallel fans or pumps.
</p>
<ul>
<li>
The Boolean output <code>y1One</code> is <code>true</code> if at least
one element of the input array is <code>true</code>.
</li>
<li>
The real output <code>nUniOn</code> is the number of elements of
the input array that are <code>true</code> (may be zero).
</li>
<li>
The real output <code>nUniOnBou</code> is the maximum between <i>1</i>
and <code>nUniOn</code>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 15, 2023, by Michael Wetter:<br/>
Reformulated using a multi-or block.
</li>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultipleCommands;
