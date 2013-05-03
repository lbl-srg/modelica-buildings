within Buildings.Fluid.HeatExchangers.HeatPumps;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
This package contains models for air and water source heat pumps.
</p>
<p>
Heat pumps can be operated in heating or cooling mode. Same conventions for control signals are used in all heat pump models. 
For <i>mode</i> = 0 heat pump is off, <i>mode</i> = 1 indicates heating 
and <i>mode</i> = 2 indicates cooling operation. 
</p>
<p>
Three types of heat pumps are included in this package.
<ul>
<li>
Water to water heat pump models can be found at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater</a>.
</li>
<li>
Water to air heat pump models can be found at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir</a>.
</li>
<li>
Air to air heat pump models can be found at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir</a>.
</li>
</ul>
</p>
<p>
<h4>Dynamic start and stop of heat pump</h4>
In heat pump models of this package dynamic start and stop conditions are considered. 
When heat pump is switched on it takes time to develop pressure across evaporator and condenser. 
During this process heat pump heats up (or cools down if it is in cooling mode) to steady state value.
This leads to heat flow reduction during the start up process. 
It is also assumed that heat is completely lost to environment when heat pump is turned off. 
Therefore as the heat pump is turned off no heat is added (or extracted). 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/HeatPumps/DynamicStartStop.png\" border=\"1\"></p>
</p>
<p>
For more details refer to 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop\"> 
Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DynamicStartStop</a>.
</p>
<h4>Speed ratio deadband</h4>
<p>
While using the variable speed heat pump models deadband for speed ratio is used 
as an operational parameter.  
Deadband value along with minimum speed ratio is used to turn on or off the variable speed heat pumps.
</p>
<ul>
<li> When the heat pump was <b>off</b> and the speed ratio becomes
     greater than the value of <b>deadband + minimum speed ratio</b>, the heat pump turns
     <b>on</b>.</li>
<li> When the heat pump was <b>on</b> and the speed ratio becomes
     <b>less</b> than the value of <b>minimum speed ratio</b>, the heat pump turns
     <b>off</b>.</li>
</ul>
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/HeatPumps/Deadband.png\" border=\"1\"></p>
</p>
<h4>Coil dynamics</h4>
<p>
The dynamic effects modeled in coil are discussed in 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a> under the section Coil dynamics.
</p>
<h4>Limitations</h4>
<p>
This model has the following limitations:
</p>
<p>
<ul>
<li>
It does not account for effect of fans or pumps at respective coils.
Fans or pumps can be modeled separately using models from the package
<a href=\"modelica://Buildings.Fluid.Movers\">
Buildings.Fluid.Movers</a>.
However, if the performance curve for the energy input ratio contains electricity
use for a fan or pump, then it is reflected by the model output.
</li>
<li>
The fluid must flow from port a to port b for both sides of heat pump. 
If there is reverse flow, then no heating or cooling operation is performed and no power is consumed.
</li>
</ul>
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 10, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end UsersGuide;
