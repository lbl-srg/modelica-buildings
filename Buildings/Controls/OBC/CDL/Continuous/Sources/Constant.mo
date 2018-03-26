within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Constant "Output constant signal of type Real"
  parameter Real k "Constant output value";

  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = k;
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-40},{100,40}}),   graphics={
        Rectangle(
        extent={{-100,-40},{100,40}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,-20},{92,20}},
          lineColor={0,0,0},
          textString="%k")}),
    Documentation(info="<html>
<p>
Block that outputs a constant signal <code>y = k</code>,
where <code>k</code> is a real-valued parameter.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Constant.png\"
     alt=\"Constant.png\" />
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-40},{100,40}})));
end Constant;
