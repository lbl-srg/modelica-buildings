within Buildings.Controls.OBC.ASHRAE.G36.Plants;
package Chillers "Chiller plant control sequences"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains control sequences for a chiller plant comprising a single
chiller or multiple chillers, chilled and condenser water pumps, cooling towers
and an optional water side economizer.
</p>
<p>
The control sequences are implemented based on ASHRAE Guideline36-2021.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          origin={10,10},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}}),
        Ellipse(
          origin={10,10},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10,10},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10,10},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}})}));
end Chillers;
