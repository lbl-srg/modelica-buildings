within Buildings.Media;
package ConstantPropertyLiquidWater "Package with model for liquid water with constant properties"
  extends Modelica.Media.Water.ConstantPropertyLiquidWater;
import SI = Modelica.SIunits;


  annotation (preferedView="info", Documentation(info="<HTML>
<p>
This medium model is identical to 
<a href=\"Modelica:Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>, except that it
implements the function that computes the specific internal energy.
</p>
</HTML>", revisions="<html>
<ul>
<li>
September 4, 2008, by Michael Wetter:<br>
Added implementation for partial function <tt>specificInternalEnergy</tt>.
</li>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));


 redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
  input ThermodynamicState state;
  output SpecificEnergy u "Specific internal energy";
 algorithm
   u := cv_const * (state.T-T0);
 end specificInternalEnergy;
end ConstantPropertyLiquidWater;
