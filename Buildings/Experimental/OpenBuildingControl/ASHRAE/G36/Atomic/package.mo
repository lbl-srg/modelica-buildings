within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
package Atomic
annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),      Rectangle(
            extent={{-60,60},{60,-60}},
            lineColor={0,0,127},
            lineThickness=0.5)}),
  Documentation(info="<html>
<p>
This package contains atomic control sequences from
ASHRAE Guideline 36 (G36). The sequences are created using CDL basic blocks:
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL\">
Buildings.Experimental.OpenBuildingControl.CDL</a>.
</p>
<p>
The atomic sequences can be used for composing sequences in package
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Composite</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 10, 2017, by Milica Grahovac:<br/>
First revision.
</li>
<li>
July 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Atomic;
