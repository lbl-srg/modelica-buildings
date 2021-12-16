within Buildings.Media.Refrigerants.R410A;
function specificVolumeVap_pT
  "Function that calculates the specific volume R410A vapor based on pressure and temperature"
  input Modelica.Units.SI.AbsolutePressure p "Pressure of refrigerant vapor";
  input Modelica.Units.SI.Temperature T "Temperature of refrigerant";
  output Modelica.Units.SI.SpecificVolume v "Specific volume of refrigerant";

protected
  Modelica.Units.SI.SpecificVolume dv "Error on specific volume of refrigerant";

  Modelica.Units.SI.Pressure dp "Error on pressure of refrigerant";

  Real dpdv( final unit = "(Pa.kg)/m3") "Partial derivative dp/dv";

  Integer m "Counter";

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
November 8, 2020, by Michael Wetter:<br/>
Removed non-used parameters.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1414\">#1414</a>.
</li>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificVolumeVap_pT;
