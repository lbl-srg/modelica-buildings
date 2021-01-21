within Buildings.Media.Refrigerants.R410A;
function specificVolumeVap_pT
  "Function that calculates the specific volume R410A vapor based on pressure and temperature"
  input Modelica.SIunits.AbsolutePressure p
    "Pressure of refrigerant vapor";
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  output Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";

protected
  Modelica.SIunits.SpecificEntropy R = 114.55
    "Refrigerant gas constant for Martin-Hou equation of state";

  Real A[:] = {-1.721781e2, 2.381558e-1, -4.329207e-4, -6.241072e-7}
    "Coefficients A for Martin-Hou equation of state";

  Real B[:] = {1.646288e-1, -1.462803e-5, 0, 1.380469e-9}
    "Coefficients B for Martin-Hou equation of state";

  Real C[:] = {-6.293665e3, 1.532461e1, 0, 1.604125e-4}
    "Coefficients C for Martin-Hou equation of state";

  Real b = 4.355134e-4
    "Coefficient b for Martin-Hou equation of state";

  Real k = 5.75
    "Coefficient K for Martin-Hou equation of state";

  Modelica.SIunits.SpecificVolume dv
    "Error on specific volume of refrigerant";

  Modelica.SIunits.Pressure dp
    "Error on pressure of refrigerant";

  Real dpdv( final unit = "(Pa.kg)/m3");

  Integer m;

  parameter Integer n = size(A, 1);

algorithm

  // Initial guess of specific volume
  v := R*T/p + b;
  dv := 1e99;
  m := 0;
  while abs(dv/v) > 1e-10 loop
    assert(m < 1E3,
      "Failed to converge in Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT");
    m := m + 1;

    // Evaluate first derivative of pressure w.r.t. specific volume
    dpdv := Buildings.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T, v);
    // Error on pressure
    dp := p - Buildings.Media.Refrigerants.R410A.pressureVap_Tv(T, v);
    // Corresponding linear adjustment of specific volume
    dv := dp/dpdv;
    v := v + dv;

end while;

annotation (derivative=Buildings.Media.Refrigerants.R410A.dSpecificVolumeVap_pT,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific volume R410A vapor based on pressure and
temperature. The specific volume is evaluated iteratively by succesive
evaluations of the vapor pressure.
</p>
<p>
The initial guess is estimated by the first term in the Martin-Hou equation of
state.
</p>
<h4>References</h4>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificVolumeVap_pT;
