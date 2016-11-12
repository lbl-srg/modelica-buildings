within Buildings.HeatTransfer.Conduction.BaseClasses;
function der_temperature_u
  "Computes the derivative of the temperature of a phase change material with respect to specific internal energy"
  input Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
  input Modelica.SIunits.Temperature TSol
    "Solidus temperature, used only for PCM.";
  input Modelica.SIunits.Temperature TLiq
    "Liquidus temperature, used only for PCM";
  input Modelica.SIunits.SpecificInternalEnergy LHea
    "Latent heat of phase change";
  input Boolean ensureMonotonicity = false
    "Set to true to force derivatives dT/du to be monotone";

  output Modelica.SIunits.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  output Modelica.SIunits.Temperature Td[Buildings.HeatTransfer.Conduction.nSupPCM]
    "Support points for derivatives";
  output Real dT_du[Buildings.HeatTransfer.Conduction.nSupPCM](
    each fixed=false,
    each unit="kg.K2/J")
    "Derivatives dT/du at the support points";
protected
  parameter Real scale=0.999 "Used to place points on the phase transition";
  parameter Modelica.SIunits.Temperature Tm1=TSol+(1-scale)*(TLiq-TSol)
    "Support point";
  parameter Modelica.SIunits.Temperature Tm2=TSol+scale*(TLiq-TSol)
    "Support point";
algorithm
  assert(Buildings.HeatTransfer.Conduction.nSupPCM == 6,
    "The material must have exactly 6 support points for the u(T) relation.");
  assert(TLiq > TSol, "TLiq has to be larger than TSol.");
  // Get the derivative values at the support points
  ud:={c*scale*TSol,
       c*TSol,
       c*Tm1 + LHea*(Tm1 - TSol)/(TLiq - TSol),
       c*Tm2 + LHea*(Tm2 - TSol)/(TLiq - TSol),
       c*TLiq + LHea,
       c*(TLiq + TSol*(1 - scale)) + LHea};
  Td:={scale*TSol,
       TSol,
       Tm1,
       Tm2,
       TLiq,
       TLiq + TSol*(1 - scale)};
  dT_du := Buildings.Utilities.Math.Functions.splineDerivatives(
      x=ud,
      y=Td,
      ensureMonotonicity=ensureMonotonicity);
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
October 17, 2014, by Michael Wetter:<br/>
Changed the input argument from type
<code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
to the elements of this type as OpenModelica fails to translate the
model if the input to this function is a record.
</li>
<li>
October 13, 2014, by Michael Wetter:<br/>
Corrected the input argument to be an instance of
<code>Buildings.HeatTransfer.Data.BaseClasses.Material</code> rather than
<code>Buildings.HeatTransfer.Data.Solids.Generic</code>.
</li>
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
