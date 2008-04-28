model HASensibleCoil 
  "Sensible convective heat transfer model for air to water coil" 
  extends PartialHA;
annotation (Diagram,
Documentation(info="<html>
<p>
Model for sensible convective heat transfer coefficients for an air to water coil.
</p>
<p>
This model computes the convective heat transfer coefficient
for an air to water coil.
The parameters allow a user to enable or disable, individually
for each medium, the mass flow and/or the temperature dependence
of the convective heat transfer coefficients.
For a detailed explanation of the equation, see
the references below.
</p>
<h3>References</h3>
<p>
<ul>
<li>
Wetter Michael,
<A HREF=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7353\">
Simulation model finned water-air-coil without condensation</a>,
LBNL-42355,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
<li>
Wetter Michael,
<A HREF=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7352\">
Simulation model air-to-air plate heat exchanger</A>,
LBNL-42354,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
</ul>
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  
  parameter Real r(min=0, max=1)=0.5 
    "Ratio between air-side and water-side convective heat transfer coefficient";
  parameter Modelica.SIunits.ThermalConductance hA0_w(min=0)=UA0 * (r+1)/r 
    "Water side convective heat transfer coefficient" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.ThermalConductance hA0_a(min=0)=r * hA0_w 
    "Air side convective heat transfer coefficient, including fin resistance" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real n_w(min=0, max=1)=0.85 
    "Water-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Real n_a(min=0, max=1)=0.8 
    "Air-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Modelica.SIunits.Temperature T0_w=
          Modelica.SIunits.Conversions.from_degC(20) "Water temperature" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T0_a=
          Modelica.SIunits.Conversions.from_degC(20) "Air temperature" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean waterSideFlowDependent = true 
    "Set to false to make water-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean airSideFlowDependent = true 
    "Set to false to make air-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean waterSideTemperatureDependent = true 
    "Set to false to make water-side hA independent of temperature" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean airSideTemperatureDependent = true 
    "Set to false to make air-side hA independent of temperature" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
protected 
  Real x_a(min=0) 
    "Factor for air side temperature dependent variation of heat transfer coefficient";
  Real x_w(min=0) 
    "Factor for water side temperature dependent variation of heat transfer coefficient";
  Real s_w(min=0, nominal=0.01) 
    "Coefficient for temperature dependence of water side heat transfer coefficient";
  Real fm_w "Fraction of actual to nominal mass flow rate";
  Real fm_a "Fraction of actual to nominal mass flow rate";
equation 
  fm_w = if waterSideFlowDependent then 
              m_flow_1 / m0_flow_w else 1;
  fm_a = if airSideFlowDependent then 
              m_flow_2 / m0_flow_a else 1;
  s_w =  if waterSideTemperatureDependent then 
            0.014/(1+0.014*Modelica.SIunits.Conversions.to_degC(T_1)) else 
              1;
  x_w = if waterSideTemperatureDependent then 
         1 + s_w * (T_1-T0_w) else 
              1;
  x_a = if airSideTemperatureDependent then 
         1 + 4.769E-3 * (T_2-T0_a) else 
              1;
  hA_1 = x_w * Buildings.Utilities.Math.regNonZeroPower(fm_w, n_w, 0.1) * hA0_w;
  hA_2 = x_a * Buildings.Utilities.Math.regNonZeroPower(fm_a, n_a, 0.1) * hA0_a;
end HASensibleCoil;
