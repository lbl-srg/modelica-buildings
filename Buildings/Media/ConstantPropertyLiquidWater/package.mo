within Buildings.Media;
package ConstantPropertyLiquidWater "Package with model for liquid water with constant properties"
  extends Buildings.Media.Interfaces.PartialSimpleMedium(
    mediumName="SimpleLiquidWater",
    cp_const=4184,
    cv_const=4184,
    d_const=995.586,
    eta_const=1.e-3,
    lambda_const=0.598,
    a_const=1484,
    T_min=Modelica.SIunits.Conversions.from_degC(-1),
    T_max=Modelica.SIunits.Conversions.from_degC(130),
    T0=273.15,
    MM_const=0.018015268,
    fluidConstants=Modelica.Media.Water.simpleWaterConstants,
    ThermoStates=Buildings.Media.Interfaces.Choices.IndependentVariables.T);


 redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
 algorithm
   u := cv_const * (state.T-T0);
 end specificInternalEnergy;


  annotation (preferredView="info", Documentation(info="<html>
This medium model is identical to 
<a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>, except for the following
points:<br/>clear

<ul>
<li>
It allows computing a compressibility of the medium.
This helps breaking algebraic loops, but the system gets stiff.
The compressibility is defined by the constant <code>kappa_const</code>.
If <code>kappa_const=0</code>, then the density is constant. Otherwise,
the density is
<p align=\"center\" style=\"font-style:italic;\">
  &rho;(p) = &rho;(p0)  ( 1 + &kappa;<sub>const</sub>  (p-p<sub>0</sub>))
</p>
This equation is implemented in the base class
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a>.
</li>
<li>
It implements the function that computes the specific internal energy.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 16, 2013, by Michael Wetter:<br/>
Changed package to extend directly from
<code>Buildings.Media.Interfaces.PartialSimpleMedium</code>
to avoid an error in OpenModelica.
</li>
<li>
August 20, 2012, by Michael Wetter:<br/>
Fixed wrong hyperlink in the documentation.
</li>
<li>
October 2, 2008, by Michael Wetter:<br/>
Changed base class to 
<a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleMedium\">
Buildings.Media.Interfaces.PartialSimpleMedium</a> to allow compressibility
to break algebraic equation systems (at the expense of stiffness).
</li>
<li>
September 4, 2008, by Michael Wetter:<br/>
Added implementation for partial function <code>specificInternalEnergy</code>.
</li>
<li>
March 19, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantPropertyLiquidWater;
