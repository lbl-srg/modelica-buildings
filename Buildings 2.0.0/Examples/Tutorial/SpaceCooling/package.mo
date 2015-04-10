within Buildings.Examples.Tutorial;
package SpaceCooling "Package with example for how to build a model for space cooling"
  extends Modelica.Icons.ExamplesPackage;




annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for
how to build a system model for space cooling
as shown in the figure below. The temperautures correspond to design conditions
that will be used to size the components. The room heat capacity has been increased
by a factor of three to approximate the thermal storage effect of furniture and building constructions.
</p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SpaceCooling/schematics.png\"/>
</p>
<p>
The model consists of
</p>
<ol>
<li>
a room with a cooling load due to internal heat gains and due to conductive heat gains from the environment,
</li>
<li>
a fresh air supply with a heat recovery, a cooling coil and a fan. The fan is operating continuously at full speed.
The room air temperature is controlled by a controller that switches the water flow rate through the coil on and
off with a dead-band of <i>1</i> Kelvin.
</li>
</ol>
<p>
To explain the implementation of this model, the model has been created in the following three stages:
</p>
<ol>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System1\">Buildings.Examples.Tutorial.SpaceCooling.System1</a>
implements the room model without air supply.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System2\">Buildings.Examples.Tutorial.SpaceCooling.System2</a>
implements the air supply with open-loop control.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">Buildings.Examples.Tutorial.SpaceCooling.System3</a>
adds closed-loop control.
</li>
</ol>
</html>"));
end SpaceCooling;
