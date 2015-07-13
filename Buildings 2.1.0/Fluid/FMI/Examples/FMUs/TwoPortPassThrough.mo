within Buildings.Fluid.FMI.Examples.FMUs;
block TwoPortPassThrough
  "FMU declaration for a block that simply passes all the inputs to the outputs"
   extends Buildings.Fluid.FMI.TwoPort(
     redeclare replaceable package Medium = Buildings.Media.Air);

equation
  connect(inlet, outlet) annotation (Line(
      points={{-110,0},{-2,0},{-2,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
  Documentation(info="<html>
<p>
This example demonstrates how to export an FMU
that simply passes all its inputs to its outputs.
Such an FMU could for example be used in a block diagram as a place-holder
for another FMU that provides an actual implementation of a component.
</p>
</html>", revisions="<html>
<ul>
<li>
April 16, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/TwoPortPassThrough.mos"
        "Export FMU"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={Line(
          points={{-100,0}},
          color={0,0,255},
          smooth=Smooth.None), Line(
          points={{-100,0},{100,0}},
          color={0,0,255},
          smooth=Smooth.None)}));
end TwoPortPassThrough;
