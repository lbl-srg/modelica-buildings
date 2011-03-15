within Buildings.Media;
package ConstantPropertyLiquidWater "Package with model for liquid water with constant properties"
  extends
  Buildings.Media.ConstantPropertyLiquidWater.BaseClasses.ConstantPropertyLiquidWater;
import SI = Modelica.SIunits;


 redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
  input ThermodynamicState state;
  output SpecificEnergy u "Specific internal energy";
 algorithm
   u := cv_const * (state.T-T0);
 end specificInternalEnergy;


  annotation (preferedView="info", Documentation(info="<html>
<p>
This medium model is identical to 
<a href=\"modelica://Buildings.Media.ConstantPropertyLiquidWater\">
Buildings.Media.ConstantPropertyLiquidWater</a>, except for the following
points:
<ul>
<li>
It allows computing a compressibility of the medium.
This helps breaking algebraic loops, but the system gets stiff.
The compressibility is defined by the constant <code>kappa_const</code>.
If <code>kappa_const=0</code>, then the density is constant. Otherwise,
the density is
<p align=\"center\" style=\"font-style:italic;\">
  &rho;(p) = &rho;(p0)  ( 1 + &kappa;<sub>const</sub>  (p-p<sub>0</sub>))
</i>
This equation is implemented in the base class
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a>.
</li>
<li>
It implements the function that computes the specific internal energy.
</li>
</p>
</html>", revisions="<html>
<ul>
<li>
October 2, by Michael Wetter:<br>
Changed base class to 
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a> to allow compressibility
to break algebraic equation systems (at the expense of stiffness).
</li>
<li>
September 4, 2008, by Michael Wetter:<br>
Added implementation for partial function <code>specificInternalEnergy</code>.
</li>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ConstantPropertyLiquidWater;
