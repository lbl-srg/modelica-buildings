within Buildings.HeatTransfer.Convection.Functions;
package HeatFlux "Correlations for convective heat flux"
  annotation (Documentation(info="<html>
This package contains functions for the convective heat transfer.
Input into the functions is the temperature difference between 
the solid and the fluid. 
The functions compute the convective heat flux, rather than the 
convective heat transfer coefficient.
The reason is that the convective heat transfer coefficient
is not differentiable around zero for certain flow configurations,
such as buoyancy driven flow at a horizontal surface. However, the
product of convective heat transfer coefficient times temperature 
difference is differentiable around zero.
</html>", revisions="<html>
<ul>
<li>
March 8 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatFlux;
