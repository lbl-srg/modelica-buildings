within Buildings.Media.Refrigerants;
package R410A "Refrigerant R410A"
  extends Modelica.Icons.VariantsPackage;

  final constant Modelica.SIunits.SpecificEntropy R = 114.55
    "Gas constant for use in Martin-Hou equation of state";

  final constant Modelica.SIunits.Temperature TCri = 345.25
    "Critical temperature";

  final constant Modelica.SIunits.Temperature T_min = 173.15
    "Minimum temperature for correlated properties";

  final constant Modelica.SIunits.AbsolutePressure pCri = 4926.1e3
    "Critical pressure";

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
R410A by the Martin-Hou equation of state, part I:
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
