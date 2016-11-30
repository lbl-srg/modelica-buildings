within Buildings.Fluid.Chillers.Compressors.Refrigerants;
package R410A "Package with functions for properties of refrigerant R410A"
  extends Modelica.Icons.VariantsPackage;

  final constant Modelica.SIunits.AbsolutePressure pCri = 4926.1e3
    "Critical pressure";
  final constant Modelica.SIunits.SpecificEntropy R = 114.55
    "Gas constant for use in Martin-Hou equation of state";
  final constant Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature";

  final constant Modelica.SIunits.Temperature T_min = 173.15
    "Minimum temperature for correlated properties";




  function pressureSatLiq_T
    "Function that calculates the pressure of saturated liquid R410A based on temperature"
    input Modelica.SIunits.Temperature T
      "Temperature of  refrigerant";
    output Modelica.SIunits.AbsolutePressure p
      "Pressure of saturated liquid refrigerant";

protected
    final Real a[:] = {-1.4376, -6.8715, -0.53623, -3.82642, -4.06875, -1.2333}
      "Coefficients for polynomial equation";

    final Real x0 = 0.2086902
      "x0 for saturation pressure of liquid refrigerant";

    final Modelica.SIunits.Temperature TCri = 345.25
      "Critical temperature of refrigerant";

    final Modelica.SIunits.AbsolutePressure pCri = 4925.1e3
      "Critical pressure of refrigerant";

    Real x
      "Independant variable";

  algorithm
    // Independant variable
    x := max(1-T/TCri, 0) - x0;
    // Pressure of saturated liquid refrigerant
    p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

  annotation (preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure of saturated liquid R410A based on temperature.
</p>
<h4>References</h4>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>",   revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
  end pressureSatLiq_T;

  function pressureSatVap_T
    "Function that calculates the pressure of saturated R410A vapor based on temperature"
    input Modelica.SIunits.Temperature T
      "Temperature of refrigerant";
    output Modelica.SIunits.AbsolutePressure p
      "Pressure of saturated refrigerant vapor";

protected
    final Real a[:] = {-1.440004, -6.865265, -0.5354309, -3.749023, -3.521484, -7.75}
      "Coefficients for polynomial equation";

    final Real x0 = 0.2086902
      "x0 for saturation pressure of refrigerant vapor";

    final Modelica.SIunits.Temperature TCri = 345.25
      "Critical temperature of refrigerant";

    final Modelica.SIunits.AbsolutePressure pCri = 4925.1e3
      "Critical pressure of refrigerant";

    Real x
      "Independant variable";

  algorithm
    // Independant variable
    x := max(1-T/TCri, 0) - x0;
    // Pressure of saturated refrigerant vapor
    p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

  annotation (preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure of saturated R410A vapor based on temperature.
</p>
<h4>References</h4>
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>",   revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
  end pressureSatVap_T;




annotation (preferredView="info",Documentation(info="<HTML>
<p>
This package contains function definitions for thermodynamic properties of R410A
based on data for commercial refrigerant Dupont Suva 410A. The methodology used
to evaluate the isentropic exponent is taken from de Monte (2002).
</p>
<h4>References</h4>
<p>
F. de Monte. (2002).
Calculation of thermodynamic properties of R407C and
R410A by the Martin–Hou equation of state — part I:
theoretical development.
<i>
International Journal of Refrigeration.
</i>
25. 306-313.
</p>
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
end R410A;
