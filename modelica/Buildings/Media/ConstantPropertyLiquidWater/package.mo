package ConstantPropertyLiquidWater 
  extends Modelica.Media.Water.ConstantPropertyLiquidWater;
import SI = Modelica.SIunits;


  annotation (Documentation(info="<HTML>
<p>
This medium model is identical to 
<a href=\"Modelica:Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>, except that the 
density is constant.
</p>
</HTML>", revisions="<html>
<ul>
<li>
March 19, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));


 redeclare replaceable function extends density "return constant density" 
 algorithm 
    d := d_const;
 end density;
end ConstantPropertyLiquidWater;
