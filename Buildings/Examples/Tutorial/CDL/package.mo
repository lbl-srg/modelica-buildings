within Buildings.Examples.Tutorial;
package CDL "Package with examples for how to implement a control sequence using CDL"
  extends Modelica.Icons.ExamplesPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for how to
implement control sequences using the Control Description Language (CDL).
The CDL is described at
<a href=\"https://obc.lbl.gov\">obc.lbl.gov</a> and elementary building blocks are
available at
<a href=\"modelica://Buildings.Controls.OBC.CDL\">
Buildings.Controls.OBC.CDL</a>.
</p>
<p>
The example starts with an open-loop model of a boiler, a simple room and a radiator.
In subsequent steps, controllers are added, starting with open loop control and then closed loop control.
The tutorial also demonstrates how to add open loop validation tests for the controllers.
At the end, you should be able to implement, document and test your own controllers.
</p>
<p>
The figure below shows the system architecture and the control charts.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/CDL/schematics.png\"/>
</p>
<p>
The controls intent is as follows:
</p>
<ol>
<li>
<p>
The overall system shall be switched on if the outdoor temperature is below
<i>16</i>&deg;C and, in addition, the room temperature is below
<i>20</i>&deg;C.
It shall be switched off if either the outdoor temperature is above
<i>17</i>&deg;C or the room temperature is above
<i>21</i>&deg;C.
</p>
</li>
<li>
<p>
The boiler shall have on/off control that regulates its temperature
between <i>70</i>&deg;C and <i>90</i>&deg;C.
</p>
</li>
<li>
<p>
The three-way valve at the boiler return shall be modulated with a PI controller
to track a return water temperature of <i>60</i>&deg;C.
</p>
</li>
<li>
<p>
The heating water supply temperature to the room shall be regulated with a PI controller
to be <i>50</i>&deg;C if the room temperature is <i>19</i>&deg;C,
and <i>21</i>&deg;C if the room temperature is <i>21</i>&deg;C.
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
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System1\">
Buildings.Examples.Tutorial.CDL.System1</a>
we connected constant control signals to the open loop model that is the starting point for this tutorial.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System2\">
Buildings.Examples.Tutorial.CDL.System2</a>
we implemented four distinct controllers, which are all open loop but have the correct control input and output connectors.
These controllers will be refined in the next steps.
This determines the control architecture.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System3\">
Buildings.Examples.Tutorial.CDL.System3</a>
we implemented the controller that regulates the return water temperature to its setpoint.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System4\">
Buildings.Examples.Tutorial.CDL.System4</a>
we implemented the controller that switches the boiler on and off.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System5\">
Buildings.Examples.Tutorial.CDL.System5</a>
we implemented the controller that switches the whole system on and off.
</li>
<li>
In
<a href=\"modelica://Buildings.Examples.Tutorial.CDL.System6\">
Buildings.Examples.Tutorial.CDL.System6</a>
we implemented the controller that tracks the room temperature set point.
</li>
</ol>
</html>"));
end CDL;
