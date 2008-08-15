package ConstantPropertyLiquidWater "Package with model for liquid water with constant properties"
  extends Modelica.Media.Water.ConstantPropertyLiquidWater;
import SI = Modelica.SIunits;

  annotation (preferedView="info", Documentation(info="<HTML>
<p>
This medium model is identical to 
<a href=\"Modelica:Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>, except that it
implements the function to computes the density. This function is
not implemented in <a href=\"Modelica:Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>.
</p>
</HTML>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

 redeclare replaceable function extends density "Returns constant density" 
 algorithm 
    d := d_const;
 end density;
end ConstantPropertyLiquidWater;
