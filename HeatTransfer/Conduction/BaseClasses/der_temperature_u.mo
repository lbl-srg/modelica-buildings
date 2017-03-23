within Buildings.HeatTransfer.Conduction.BaseClasses;
function der_temperature_u
  "Computes the derivative of the temperature of a phase change material with respect to specific internal energy"
  input Buildings.HeatTransfer.Data.Solids.Generic material
    "Material properties";
  output Modelica.SIunits.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  output Modelica.SIunits.Temperature Td[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  output Real dT_du[Buildings.HeatTransfer.Conduction.nSupPCM](fixed=false, unit="kg.K2/J")
    "Derivatives dT/du at the support points";
protected
  parameter Real scale=0.999 "Used to place points on the phase transition";
  parameter Modelica.SIunits.Temperature Tm1=material.TSol+(1-scale)*(material.TLiq-material.TSol);
  parameter Modelica.SIunits.Temperature Tm2=material.TSol+scale*(material.TLiq-material.TSol);
algorithm
  assert(Buildings.HeatTransfer.Conduction.nSupPCM == 6,
    "The material must have exactly 6 support points for the u(T) relation.");
  assert(material.TLiq > material.TSol,
    "TLiq has to be larger than TSol.");
  // Get the derivative values at the support points
  ud:={material.c*scale*material.TSol,
       material.c*material.TSol,
       material.c*Tm1 + material.LHea*(Tm1 - material.TSol)/(material.TLiq - material.TSol),
       material.c*Tm2 + material.LHea*(Tm2 - material.TSol)/(material.TLiq - material.TSol),
       material.c*material.TLiq + material.LHea,
       material.c*(material.TLiq + material.TSol*(1 - scale)) + material.LHea};
  Td:={scale*material.TSol,
       material.TSol,
       Tm1,
       Tm2,
       material.TLiq,
       material.TLiq + material.TSol*(1 - scale)};
  dT_du := Buildings.Utilities.Math.Functions.splineDerivatives(
      x=ud,
      y=Td,
      ensureMonotonicity=material.ensureMonotonicity);
  annotation(smoothOrder=1,
      Documentation(info="<html>
<p>
This function computes at the support points <i>T<sub>d</sub></i> the derivatives
<i>dT/du</i> of the cubic hermite spline approximation to the 
temperature vs. specific internal energy relation.
These derivatives are then used by the function
<a href=\"modelica://Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u\">
Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u</a>
to compute for a given specific internal energy the temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 9, 2013, by Michael Wetter:<br/>
Revised implementation to use new data record.
</li>
<li>
January 19, 2013, by Armin Teskeredzic:<br/>
First implementations.
</li>
</ul>
</html>"));
end der_temperature_u;
