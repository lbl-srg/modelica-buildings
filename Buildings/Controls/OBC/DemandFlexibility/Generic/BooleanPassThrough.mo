within Buildings.Controls.OBC.DemandFlexibility.Generic;
block BooleanPassThrough "Pass a Boolean signal through without modification"

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
  "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
equation
  connect(u, y)
    annotation (Line(points={{-120,0},{120,0}}, color={255,0,255}));
  annotation (defaultComponentName="booPasThr",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
August 18, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Passes a Boolean signal through without modification.
</p>
</html>"));
end BooleanPassThrough;
