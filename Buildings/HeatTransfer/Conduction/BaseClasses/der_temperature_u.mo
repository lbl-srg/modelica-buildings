within Buildings.HeatTransfer.Conduction.BaseClasses;
function der_temperature_u
  "Computes the derivative of the temperature of a phase change material with respect to specific internal energy"
  input Modelica.SIunits.Temperature TSol "Solidus Temperature";
  input Modelica.SIunits.Temperature TLiq "Liquidus Temeprature";
  input Modelica.SIunits.SpecificInternalEnergy LHea
    "Latent heat of phase-change";
  input Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
  input Boolean ensureMonotonicity
    "Set to true to force derivatives dT/du to be monotone, false is the usual usage which typically gives higher accuracy";
  output Modelica.SIunits.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSup]
    "Support points for derivatives";
  output Modelica.SIunits.Temperature Td[Buildings.HeatTransfer.Conduction.nSup]
    "Support points for derivatives";
  output Real dT_du[Buildings.HeatTransfer.Conduction.nSup](fixed=false, unit="kg.K2/J")
    "Derivatives dT/du at the support points";
protected
  parameter Real scale=0.999 "Used to place points on the phase transition";
  parameter Modelica.SIunits.Temperature Tm1=TSol+(1-scale)*(TLiq-TSol);
  parameter Modelica.SIunits.Temperature Tm2=TSol+scale*(TLiq-TSol);
algorithm
  assert(TLiq > TSol, "TLiq has to be larger than TSol.");
  // Get the derivative values at the support points
  ud:={c*scale*TSol,c*TSol,c*Tm1 + LHea*(Tm1 - TSol)/(TLiq - TSol),c*Tm2 + LHea
    *(Tm2 - TSol)/(TLiq - TSol),c*TLiq + LHea,c*(TLiq + TSol*(1 - scale)) +
    LHea};
  Td:={scale*TSol,TSol,Tm1,Tm2,TLiq,TLiq + TSol*(1 - scale)};
  dT_du := Buildings.Utilities.Math.Functions.splineDerivatives(
      x=ud,
      y=Td,
      ensureMonotonicity=ensureMonotonicity);
  annotation(smoothOrder=1,
      Documentation(info="<html>
<p>
fixme: add documentation.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 19, 2013 by Armin Teskeredzic:<br>
First implementation.
</li>
</ul>
</html>"));
end der_temperature_u;
