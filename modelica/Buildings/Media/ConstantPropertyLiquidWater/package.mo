package ConstantPropertyLiquidWater 
  extends Modelica.Media.Water.ConstantPropertyLiquidWater;
  import SI = Modelica.SIunits;


  annotation (Documentation(info="<HTML>
<p>
This is a medium interface that is identical to <tt>Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</tt>, except the 
equation <tt>d = p/(R*T)</tt> has been replaced with 
<tt>d/dStp = p/pStp</tt> where <tt>pStd</tt> and <tt>dStp</tt> are constants for a reference
temperature and density.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
<p>
As for <tt>Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</tt>, the
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
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
