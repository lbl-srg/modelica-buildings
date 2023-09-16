within Buildings.Examples.Tutorial;
package SimpleHouse "Package with example for how to build a simple building envelope with a radiator heating system and ventilation system"
extends Modelica.Icons.ExamplesPackage;

  annotation (Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for how to build a system model
for a simple house with a heating system, ventilation, and weather boundary conditions.
It serves as a demonstration case of how the <code>Buildings</code> library can be used.
</p>
<p>
The goal of this exercise is to become familiar with Modelica and the Buildings library.
Since the Buildings library components are typically used by combining several components graphically,
the use of equations falls outside of the scope of this exercise.
</p>
<p>
For this exercise you will create a model of a simple house,
consisting of a heating system, one building zone, and a ventilation model.
The exercise starts from a template file that should not produce any errors.
This file will be extended in several steps, adding complexity.
In between each step the user should be able to simulate the model,
i.e., no errors should be produced and simulation results may be compared.
<\\p>
<p>
The model has been created in the following stages:
</p>
<ol>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouseTemplate</a>
contains a weather data reader which connects the thermal resistance of the building wall
to the dry bulb temperature and serves as a template to implement the entire <code>SimpleHouse</code> model.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse1\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse1</a>
implements the building wall by adding a thermal capacity.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse2\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse2</a>
adds a window to the building wall.
It is assumed that the total injected heat through the window equals the window surface area
multiplied by the direct horizontal solar irradiance.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse3\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse3</a>
adds an air model which represents the room in the building.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse4\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse4</a>
adds heating circuit consisting of a boiler, a radiator, 
and an on/off circulation pump with a constant mass flow rate.
No controller is implemented yet, i.e. the pump and heater are always on.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse5\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse5</a>
adds a hysteresis controller for the heating circuit that uses the room temperature as an input.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse6\">
Buildings.Examples.Tutorial.SimpleHouse.SimpleHouse6</a>
adds a ventilation system consisting of a fan, a damper, a heat recovery unit,
and a hysteresis controller, that allows to perform free cooling using outside air.
</li>
</ol>
<p>
For each stage, firstly the model part is qualitatively explained.
Next, the names of the required Modelica models (from the Modelica Standard Library and/or Buildings library) are listed.
Finally, we provide high-level instructions of how to set up the model.
If these instructions are not clear immediately, have a look at the model documentation and at the type of connectors the model has,
try out some things, make an educated guess, etc.
Finally, we provide reference results that allow you to check if your implementation is correct.
Depending on the parameter values that you choose, results may differ.
<\\p>
<p>
The graphical representation of the final model is given below.
<\\p>
<p align=\"center\">
<img alt=\"Graphical representation of the final simple house model.\"
src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/SimpleHouse/simpleHouse.png\"/>
</p>
</html>"));
end SimpleHouse;
