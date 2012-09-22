within Buildings.Fluid.HeatExchangers.DXCoils.Data;
package PerformanceCurves "Package with sevral performance curves"


  annotation (Documentation(info="<html>
This package contains default performance curves for cooling capacity and EIR 
of DX cooling coil. Using default coefficents for coils (when coefficient 
for actual coil are not available) will not affect accuracy significantly 
(Griffith B., Pless S., Talbert B., Deru M., and Torcellini P.; 2003). 
These coefficients are obtained from example files of EnergyPlus 7.1.
<h4>
References
</h4>
<p>
B. Griffith, S. Pless, B. Talbert, M. Deru, and P. Torcellini (2003).
<i>'DX Coil Performance Curves' in Energy Design Analysis and Evaluation of a 
Proposed Air Rescue and Fire Fighting Administration Building for Teterboro Airport</i>. 
National Renewable Energy Laboratory, p. 63. 
</p>
</html>",
revisions="<html>
<ul>
<li>
July 23, 2012 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end PerformanceCurves;
