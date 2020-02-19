within Buildings.Examples.Tutorial;
package ControlDescriptionLanguage "Package with example for how to build a model for boiler with a heating load"
  extends Modelica.Icons.ExamplesPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for how to
implement control sequences using the Control Description Language.
The example starts with an open-loop model of a boiler, a simple room and a radiator.
The figure below shows the system architecture and the control charts.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/schematics.png\"/>
</p>
<p>
The controls intent is as follows:
</p>
<ol>
<li>
<p>
The space heating shall be switched on if the outdoor temperature is below
<i>16</i>&deg;C and the room temperature is below
<i>20</i>&deg;C.
It shall be switched off if either the outdoor temperature is above
<i>17</i>&deg;C or the room temperature is above
<i>21</i>&deg;C.
</p>
</li>
<li>
<p>
The boiler shall have on/off control that regulates its temperature
between <i>70</i>&circ;C and <i>90</i>&circ;C.
The three-way valve at the boiler return shall be modulated with a PI controller
to track a return water temperature of <i>60</i>&circ;C.
</p>
</li>
<li>
<p>
The heating water supply temperature to the room shall be regulated with a PI controller
to be <i>50</i>&circ;C if the room temperature is <i>19</i>&circ;C,
and <i>21</i>&circ;C if the room temperature is <i>21</i>&circ;C,
</p>
</li>
</ol>
<p>
To explain the implementation of the controllers for this model, the model has been created in
the stages described below.
</p>
<ol>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System1\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System1</a>
we already implemented the open loop model that is the starting point for this tutorial.
For instructions of how to build this model, see
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler\">
Buildings.Examples.Tutorial.Boiler</a>
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System2\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System2</a>
we implement four distinct controllers, which are all open loop and will be refined in the next steps.
This will determine the control architecture.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System3\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System3</a>
we implement the controller that regulates the return water temperature to its setpoint.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System4\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System4</a>
we add the controller that switches the boiler on and off.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System5\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System5</a>
we implement the controller that switches the whole system on and off.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.ControlDescriptionLanguage.System6\">
Buildings.Examples.Tutorial.ControlDescriptionLanguage.System6</a>
we add the control that tracks the room temperature set point.
</li>
</ol>
</html>"));
end ControlDescriptionLanguage;
