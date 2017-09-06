within Buildings.Media.Refrigerants;
package R410A "Refrigerant R410A"
  extends Modelica.Icons.VariantsPackage;

  final constant Modelica.SIunits.AbsolutePressure pCri = 4926.1e3
    "Critical pressure";
  final constant Modelica.SIunits.SpecificEntropy R = 114.55
    "Gas constant for use in Martin-Hou equation of state";
  final constant Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature";

  final constant Modelica.SIunits.Temperature T_min = 173.15
    "Minimum temperature for correlated properties";


function dPressureVap_dSpecificVolume_Tv
  "Derivative of the Martin-Hou equation of state with regards to specific volume"

  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Real dpdv(
    final unit="Pa.kg/m3")
     "Derivative of pressure with regards to specific volume";

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

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Modelica.SIunits.SpecificVolume v_abs
    "Smoothed specific volume";

  parameter Integer n = size(A, 1);

algorithm

  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  dpdv := -R*T/(v_abs-b)^2;
  for i in 1:n loop
    dpdv := dpdv - (i+1)*(A[i] + B[i]*T + C[i]*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+2);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the derivative of the Martin-Hou equation of for R410A
state with regards to specific volume.
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
November 30, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end dPressureVap_dSpecificVolume_Tv;


function dPressureVap_dTemperature_Tv
  "Derivative of the Martin-Hou equation of state with regards to temperature"

  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Real dpdT(
    final unit="Pa/K")
     "Derivative of pressure with regards to temperature";

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

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Modelica.SIunits.SpecificVolume v_abs
    "Smoothed specific volume";

  parameter Integer n = size(A, 1);

algorithm

  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  dpdT := R/(v_abs-b);
  for i in 1:n loop
    dpdT := dpdT + (B[i] - C[i]*k/TCri*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+1);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the derivative of the Martin-Hou equation of for R410A
state with regards to temperature.
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
November 30, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end dPressureVap_dTemperature_Tv;


function dSpecificVolumeVap_pT
  "Function that calculates the Jacobian of specific volume R410A vapor based on pressure and temperature"
  input Modelica.SIunits.AbsolutePressure p
    "Pressure of refrigerant vapor";
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Real dp(
    final unit="Pa/s")
    "Delta of pressure of refrigerant vapor";
  input Real dT(
    final unit="K/s")
    "Delta of temperature of refrigerant";
  output Real dv(
    final unit="m3/(kg.s)")
    "Delta of specific volume of refrigerant";

protected
  Real dpdT(
    final unit="Pa/K")
     "Derivative of pressure with regards to temperature";

  Real dpdv(
    final unit="Pa.kg/m3")
     "Derivative of pressure with regards to specific volume";

  Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";

algorithm

  v := Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT(p,T);
  dpdT := Buildings.Media.Refrigerants.R410A.dPressureVap_dTemperature_Tv(T,v);
  dpdv := Buildings.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T,v);

  dv := dp/dpdv + dT*(dpdT/dpdv);

annotation (preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the derivatives of
<a href=\"modelica://Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT\">
Buildings.Media.Refrigerants.R410A.specificVolumeVap_pT</a>
</p>
</html>", revisions="<html>
<ul>
<li>
November 30, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end dSpecificVolumeVap_pT;

function enthalpySatLiq_T
  "Function that calculates the enthalpy of saturated liquid R410A based on temperature"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  output Modelica.SIunits.SpecificEnthalpy h
    "Specific enthalpy of saturated liquid refrigerant";

protected
  final Real a[:] = {221.1749, -514.9668, -631.625, -262.2749, 1052.0, 1596.0}
    "Coefficients for polynomial equation";

  final Real x0 = 0.5541498
    "x0 for saturation pressure of liquid refrigerant";

  final Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3)^(1/3) - x0;
  // Pressure of saturated liquid refrigerant
  h := 1000*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x);

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the enthalpy of saturated liquid R410A based on
temperature.
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
end enthalpySatLiq_T;

function enthalpySatVap_T
  "Function that calculates the specific enthalpy of saturated R410A vapor based on temperature"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  output Modelica.SIunits.SpecificEnthalpy h
    "Specific enthalpy of saturated liquid refrigerant";

protected
  final Real a[:] = {406.0598, -34.78156, 262.8079, 223.8549, -1162.627, 570.6635}
    "Coefficients for polynomial equation";

  final Real x0 = 0
    "x0 for saturation pressure of liquid refrigerant";

  final Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Real x
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3)^(1/3) - x0;
  // Pressure of saturated liquid refrigerant
  h := 1000*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x);

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific enthalpy of saturated R410A vapor based
on temperature.
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
end enthalpySatVap_T;

function isentropicExponentVap_Tv
  "Function that calculates the isentropic exponent of R410A vapor based on temperature and specific volume"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Modelica.SIunits.IsentropicExponent k
    "Specific isobaric heat capacity";

protected
  Modelica.SIunits.SpecificHeatCapacity cp
    "Specific isobaric heat capacity";

  Modelica.SIunits.SpecificHeatCapacity cv
    "Specific isochoric heat capacity";

algorithm
  // Evaluate the specific isobaric and isochoric heat capacities
  cp := Buildings.Media.Refrigerants.R410A.specificIsobaricHeatCapacityVap_Tv(T, v);
  cv := Buildings.Media.Refrigerants.R410A.specificIsochoricHeatCapacityVap_Tv(T, v);

  k := cp / cv;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the isentropic exponent of R410A vapor based on temperature and specific volume. The isentropic exponent is equal to the ratio of specific heat capacities:
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = c<sub>p</sub>/c<sub>v</sub>
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
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end isentropicExponentVap_Tv;

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
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3) - x0;
  // Pressure of saturated liquid refrigerant
  p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
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
</html>", revisions="<html>
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
    "Independent variable";

algorithm
  // Independent variable
  x := Buildings.Utilities.Math.Functions.smoothMax(1-T/TCri, 1e-4, 5e-3) - x0;
  // Pressure of saturated refrigerant vapor
  p := pCri*Modelica.Math.exp(TCri/T*Buildings.Utilities.Math.Functions.polynomial(a = a, x = x));

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
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
</html>", revisions="<html>
<ul>
<li>
October 17, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressureSatVap_T;


function pressureVap_Tv
"Function that calculates the pressure R410A vapor based on temperature and specific volume"
input Modelica.SIunits.Temperature T
   "Temperature of refrigerant";
input Modelica.SIunits.SpecificVolume v
   "Specific volume of refrigerant";
output Modelica.SIunits.AbsolutePressure p
   "Pressure of refrigerant vapor";

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

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  Modelica.SIunits.SpecificVolume v_abs
    "Smoothed specific volume";

  parameter Integer n = size(A, 1);

algorithm

  v_abs := Buildings.Utilities.Math.Functions.smoothMax(v, 1.01*b, 0.01*b);

  p := R*T/(v_abs-b);
  for i in 1:n loop
    p := p + (A[i] + B[i]*T + C[i]*Modelica.Math.exp(-k*T/TCri))/(v_abs - b)^(i+1);
  end for;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the pressure R410A vapor based on temperature and
specific volume. The pressure is calculated from the Martin-Hou equation of
state.
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
end pressureVap_Tv;


function specificIsobaricHeatCapacityVap_Tv
  "Function that calculates the specific isobaric heat capacity of R410A vapor based on temperature and specific volume"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Modelica.SIunits.SpecificHeatCapacity cp
    "Specific isobaric heat capacity";

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

  Real dpdT
    "First derivative w.r.t. temperature of the Martin-Hou equation";

  Real dpdv
    "First derivative w.r.t. specific volume of the Martin-Hou equation";

  Modelica.SIunits.SpecificHeatCapacity cv
    "Specific isochoric heat capacity";

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  parameter Integer n = size(A, 1);

algorithm

  cv := Buildings.Media.Refrigerants.R410A.specificIsochoricHeatCapacityVap_Tv(T, v);
  dpdT := Buildings.Media.Refrigerants.R410A.dPressureVap_dTemperature_Tv(T,v);
  dpdv := Buildings.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T,v);

  cp := cv - T * dpdT^2 / dpdv;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific isobaric heat capacity (<i>c<sub>p</sub></i>) of R410A vapor based on temperature and specific volume.
</p>
<p>
The specific isobaric heat capacity is evaluated from the partial derivatives of the Martin-Hou equation of state.
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
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificIsobaricHeatCapacityVap_Tv;


function specificIsochoricHeatCapacityVap_Tv
  "Function that calculates the specific isochoric heat capacity of R410A vapor
  based on temperature and specific volume"
  input Modelica.SIunits.Temperature T
    "Temperature of refrigerant";
  input Modelica.SIunits.SpecificVolume v
    "Specific volume of refrigerant";
  output Modelica.SIunits.SpecificHeatCapacity cv
    "Specific isochoric heat capacity";

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

  Real a[:] = {2.676087e-1, 2.115353e-3, -9.848184e-7, 6.493781e-11}
    "Coefficients for ideal gas specific isobaric heat capacity";

  Real integral_of_d2pdT2
    "Integral over v of the second derivative w.r.t. temperature of the Martin-Hou equation";

  Modelica.SIunits.SpecificHeatCapacity cpo
    "Ideal gas specific isobaric heat capacity";

  Modelica.SIunits.SpecificHeatCapacity cvo
    "Ideal gas specific isochoric heat capacity";

  Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature of refrigerant";

  parameter Integer n = size(A, 1);

algorithm
  // Ideal gas isobaric heat capacity from polynomial equation
  cpo := 1.0e3*Buildings.Utilities.Math.Functions.polynomial(a = a, x = T);
  cvo := cpo - R;

  // Integral of second derivative of pressure w.r.t. temperature
  integral_of_d2pdT2 := 0.0;
  for i in 1:n loop
    integral_of_d2pdT2 := integral_of_d2pdT2 + C[i]*Modelica.Math.exp(-k*T/TCri)/(i*(v - b)^(i));
  end for;
  integral_of_d2pdT2 := integral_of_d2pdT2 * (k/TCri)^2;

  cv := cvo - T * integral_of_d2pdT2;

annotation (smoothOrder=1,
preferredView="info",Documentation(info="<HTML>
<p>
Function that calculates the specific isochoric heat capacity
(<i>c<sub>v</sub></i>) of R410A vapor based on temperature and specific volume.
</p>
<p>
The specific isochoric heat capacity is evaluated from the partial derivatives
of the Martin-Hou equation of state.
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
<p>
Thermodynamic properties of DuPont Suva 410A:
<a href=\"https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf\">
https://www.chemours.com/Refrigerants/en_US/assets/downloads/h64423_Suva410A_thermo_prop_si.pdf
</a>
</p>
</html>", revisions="<html>
<ul>
<li>
October 31, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificIsochoricHeatCapacityVap_Tv;



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
    dpdv := Buildings.Media.Refrigerants.R410A.dPressureVap_dSpecificVolume_Tv(T,v);
    // Error on pressure
    dp := p - Buildings.Media.Refrigerants.R410A.pressureVap_Tv(T,v);
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
