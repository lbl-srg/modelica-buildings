within Buildings.Examples.Tutorial;
package Boiler "Package with example for how to build a model for boiler with a heating load"
  extends Modelica.Icons.ExamplesPackage;








annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains examples with step-by-step instructions for how to build
a system model for a boiler with a heat load as shown in the figure below.
The pressure drops of the individual flow branches and the temperatures correspond to design conditions.
The heating system shall be designed to provide <i>20</i> kW, which is the load
needed at <i>-10</i>&deg;C outdoor temperature.
This load already takes into account the heat required for air infiltration and
ventilation.
Using this load and the temperatures shown in the schematic drawing,
the nominal mass flow rates of the individual flow branches should be computed.
From <i>8:00</i> to <i>18:00</i>, there is an internal heat gain of <i>4</i>kW,
which should not be accounted for when sizing the system.
</p>
<p>
The room volume is <i>180</i>m<sup>3</sup>.
To approximate the thermal storage effect of furniture and building constructions,
the heat capacity of the room should be increased by a factor of three.
(Modeling a detailed room heat transfer as implemented in
<a href=\"modelica://Buildings.Rooms\">
Buildings.Rooms</a> is out of scope for this tutorial.)
</p>
<p>
The space heating shall be switched on if the outdoor temperature is below
<i>16</i>&deg;C and the room temperature is below
<i>20</i>&deg;C.
It shall be switched off if either the outdoor temperature is above
<i>17</i>&deg;C or the room temperature is above
<i>21</i>&deg;C.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/Tutorial/Boiler/schematics.png\"/>
</p>
<p>
The model consists of
</p>
<ol>
<li>
a room with a heating load, approximated as steady-state heat transfer with the environment,
</li>
<li>
a heating loop with a constant bypass and a three-way valve, which is modulated to track the room temperature set point, and
</li>
<li>
a boiler loop with constant mass flow rate, boiler on/off control and control valve
to ensure a minimum return water temperature.
</li>
</ol>
<p>
To explain the implementation of this model, the model has been created in the following stages:
</p>
<ol>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System1\">
Buildings.Examples.Tutorial.Boiler.System1</a>
implements the room model without any heating.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System2\">
Buildings.Examples.Tutorial.Boiler.System2</a>
adds a radiator that is fed with water at a constant temperature and flow rate.
The pump is switched on and off depending on the room temperature.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System3\">
Buildings.Examples.Tutorial.Boiler.System3</a>
adds the boiler circuit with open loop control for the boiler and the mixing valves.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System4\">
Buildings.Examples.Tutorial.Boiler.System4</a>
adds closed loop control for the boiler and the pumps.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System5\">
Buildings.Examples.Tutorial.Boiler.System5</a>
adds closed loop control for the two valves.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System6\">
Buildings.Examples.Tutorial.Boiler.System6</a>
replaces the constant outdoor temperature with weather data from a file,
and changes the valve control from P-control to PI-control.
</li>
<li>
<a href=\"modelica://Buildings.Examples.Tutorial.Boiler.System7\">
Buildings.Examples.Tutorial.Boiler.System7</a>
replaces the boiler and pump control using a state machine.
</li>
</ol>
</html>"));
end Boiler;
