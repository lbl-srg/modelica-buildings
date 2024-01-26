within Buildings.Templates.Plants.Components;
package Controls
  "Control blocks"
  annotation (
    Documentation(
      info="<html>
<p>
This package contains control blocks that comply with the CDL specification:
<a href=\\\"modelica://https://obc.lbl.gov/specification/cdl.html\\\">
https://obc.lbl.gov/specification/cdl.html</a>.
</p>
</html>"),
    Icon(
      graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
          origin={10.0,10.0},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}}),
        Ellipse(
          origin={10.0,10.0},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10.0,10.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10.0,10.0},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end Controls;
