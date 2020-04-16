within Buildings.Media;
package Steam "Package with model for ideal steam"
  extends Modelica.Media.Water.IdealSteam(
     mediumName="steam",
     reference_T=273.15,
     reference_p=101325,
     AbsolutePressure(start=p_default),
     Temperature(start=T_default));

  extends Modelica.Icons.Package;

  replaceable function saturationState_p
    "Return saturation property record from pressure"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output SaturationProperties sat "Saturation property record";
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Returns the saturation state for given pressure. This relation is
    valid in the region of <i>273.16</i> to <i>647.096</i> K (<i>613.3</i> to <i>22,049,100</i> Pa).
    </p>
    <p>
    To compute the saturation temperature, the function uses
    </p>
    <p align=\"center\" style=\"font-style:italic;\">
    T = a<sub>1</sub> + a<sub>2</sub> ln(p) + a<sub>3</sub> ln(p)<sup>2</sup> +
    a<sub>4</sub> ln(p)<sup>3</sup> + a<sub>5</sub> ln(p)<sup>4</sup> + a<sub>6</sub> ln(p)<sup>5</sup>,
    </p>
    <p>
    where temperature <i>T</i> is in units Kelvin, pressure <i>p</i> is in units Pa, and <i>a<sub>1</sub></i>
    through <i>a<sub>6</sub></i> are regression coefficients.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Michael Wetter:<br/>
Renamed function so it has a similar name as
<a href=\"modelica://Buildings.Media.Steam.saturationTemperature\">
Buildings.Media.Steam.saturationTemperature</a>.
</li>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationState_p;

  replaceable function saturationTemperature
    "Return saturation temperature (K) from a given pressure (Pa)"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    output Temperature T   "Saturation temperature";
  protected
    Real a[:] = {2.2830066E+02,1.1893913E+00,5.2484699E-01,1.2416857E-01,
      -1.3714779E-02,5.5702047E-04}
      "Coefficients";
  algorithm
    T := a[1] + a[2]*log(p) + a[3]*log(p)^2 + a[4]*log(p)^3 +
      a[5]*log(p)^4 + a[6]*log(p)^5  "Saturation temperature";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Saturation temperature is computed from pressure. This relation is
    valid in the region of <i>273.16</i> to <i>647.096</i> K (<i>613.3</i> to <i>22,049,100</i> Pa).
    </p>
    <p>
    The function has the following form:
    </p>
    <p align=\"center\" style=\"font-style:italic;\">
    T = a<sub>1</sub> + a<sub>2</sub> ln(p) + a<sub>3</sub> ln(p)<sup>2</sup> +
    a<sub>4</sub> ln(p)<sup>3</sup> + a<sub>5</sub> ln(p)<sup>4</sup> + a<sub>6</sub> ln(p)<sup>5</sup>
    </p>
    <p>
    where temperature <i>T</i> is in units Kelvin, pressure <i>p</i> is in units Pa, and <i>a<sub>1</sub></i>
    through <i>a<sub>6</sub></i> are regression coefficients.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationTemperature;

  replaceable function densityOfSaturatedLiquid_sat
    "Return density of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dl "Density of saturated liquid";
  protected
    Real m[:] = {1/3,2/3,5/3,16/3,43/3,110/3} "Powers in equation (2)";
    Real b[:] = {1.99274064,1.09965342,-0.510839303,-1.75493479,-45.5170352,-6.74694450e5}
      "Coefficients in equation (2)";
    Real tau = 1 - sat.Tsat/Tcritical  "Temperature expression";
  algorithm
    dl := dcritical*(1 + b[1]*tau^m[1] + b[2]*tau^m[2] + b[3]*tau^m[3] +
      b[4]*tau^m[4] + b[5]*tau^m[5] + b[6]*tau^m[6])
      "Density of saturated liquid, equation (2)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Density of saturated liquid is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end densityOfSaturatedLiquid_sat;

  replaceable function densityOfSaturatedVapor_sat
    "Return density of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Density dv "Density of saturated vapor";
  protected
    Real m[:] = {2/6,4/6,8/6,18/6,37/6,71/6}  "Powers in equation (3)";
    Real c[:] = {-2.03150240,-2.68302940,-5.38626492,-17.2991605,-44.7586581,-63.9201063}
      "Coefficients in equation (3)";
    Real tau = 1 - sat.Tsat/Tcritical  "Temperature expression";
  algorithm
    dv := dcritical*exp(c[1]*tau^m[1] + c[2]*tau^m[2] + c[3]*tau^m[3] +
      c[4]*tau^m[4] + c[5]*tau^m[5] + c[6]*tau^m[6])
      "Density of saturated vapor, equation (3)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Density of saturated vapor is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end densityOfSaturatedVapor_sat;

  replaceable function enthalpyOfSaturatedLiquid_sat
    "Return specific enthalpy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hl "Boiling curve specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dl = densityOfSaturatedLiquid_sat(sat)  "Saturated liquid density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real a = auxiliaryAlpha_sat(sat)  "Value for alpha";
  algorithm
    hl := a - exp(r1)*pcritical*(r2+r1*tau)/(dl*tau)
      "Saturated liquid enthalpy, derived from equation (6)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of saturated liquid is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end enthalpyOfSaturatedLiquid_sat;

  replaceable function enthalpyOfSaturatedVapor_sat
    "Return specific enthalpy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hv "Dew curve specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor_sat(sat)  "Saturated vapor density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real a = auxiliaryAlpha_sat(sat)  "Value for alpha";
  algorithm
    hv := a - exp(r1)*pcritical*(r2+r1*tau)/(dv*tau)
      "Saturated vapor enthalpy, derived from equation (7)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of saturated vapor is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end enthalpyOfSaturatedVapor_sat;

  replaceable function enthalpyOfVaporization_sat
    "Return enthalpy of vaporization of water as a function of temperature T"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEnthalpy hlv "Vaporization enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor_sat(sat)  "Saturated vapor density";
    Density dl = densityOfSaturatedLiquid_sat(sat)  "Saturated liquid density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real a = auxiliaryAlpha_sat(sat)  "Value for alpha";

  algorithm
    hlv := exp(r1)*pcritical*(r2+r1*tau)/tau * (1/dl-1/dv)
      "Difference of equations (7) and (6)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Enthalpy of vaporization of water is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Michael Wetter:<br/>
Reformulated function to avoid computing common expressions twice.
</li>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end enthalpyOfVaporization_sat;

  replaceable function entropyOfSaturatedLiquid_sat
    "Return specific entropy of saturated liquid"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sl "Saturated liquid specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dl = densityOfSaturatedLiquid_sat(sat)  "Saturated liquid density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real phi = auxiliaryPhi_sat(sat)  "Value for phi";
  algorithm
    sl := phi - exp(r1)*pcritical*(r2 + r1*tau)/(dl*tau*sat.Tsat)
      "Saturated liquid enthalpy, derived from Equation (8)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of saturated liquid is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end entropyOfSaturatedLiquid_sat;

  replaceable function entropyOfSaturatedVapor_sat
    "Return specific entropy of saturated vapor"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy sv "Saturated vapor specific enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor_sat(sat)  "Saturated vapor density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real phi = auxiliaryPhi_sat(sat)  "Value for phi";
  algorithm
    sv := phi - exp(r1)*pcritical*(r2 + r1*tau)/(dv*tau*sat.Tsat)
      "Saturated vapor enthalpy, derived from Equation (9)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of saturated vapor is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end entropyOfSaturatedVapor_sat;

  replaceable function entropyOfVaporization_sat
    "Return entropy of vaporization of water as a function of temperature T"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output SpecificEntropy slv "Vaporization enthalpy";
  protected
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
    Density dv = densityOfSaturatedVapor_sat(sat)  "Saturated vapor density";
    Density dl = densityOfSaturatedLiquid_sat(sat)  "Saturated liquid density";
    Real r1 = expression1_sat(sat)  "Intermediate expression 1";
    Real r2 = expression2_sat(sat)  "Intermediate expression 2";
    Real phi = auxiliaryPhi_sat(sat)  "Value for phi";
  algorithm
    slv := exp(r1)*pcritical*(r2 + r1*tau)/(tau*sat.Tsat) * (1/dl-1/dv)
     "Difference of equations (8) and (9)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Entropy of vaporization of water is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Michael Wetter:<br/>
Reformulated function to avoid computing common expressions twice.
</li>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end entropyOfVaporization_sat;
//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.

protected
    constant Modelica.SIunits.Temperature Tcritical=647.096 "Critical temperature";
    constant Modelica.SIunits.Density dcritical=322 "Critical density";
    constant Modelica.SIunits.Pressure pcritical=22.064e6 "Critical pressure";
    constant Modelica.SIunits.SpecificEnthalpy a0 = 1000
      "Auxiliary quantity for specific enthalpy";

  replaceable function vaporPressure_sat
    "Returns vapor pressure for a given temperature"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output AbsolutePressure p  "Vapor pressure";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    p := pcritical*exp(Tcritical/sat.Tsat*(a[1]*tau^n[1] + a[2]*tau^n[2] + a[3]
        *tau^n[3] + a[4]*tau^n[4]) + a[5]*tau^n[5] + a[6]*tau^n[6])
        "Equation (1) for vapor pressure";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Vapor pressure is computed from temperature in the region
    of <i>273.16</i> to <i>647.096</i> K.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end vaporPressure_sat;

  function auxiliaryAlpha_sat
    "This is auxiliary equation (4) for specific enthalpy calculations"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real a  "Alpha in equation (4)";
  protected
    Real m[:] = {-19,1,4.5,5,54.5}  "Powers in equation (4)";
    Real d_a = -1135.905627715  "Coefficient in equation (4)";
    Real d[:] = {-5.65134998e-8,2690.66631,127.287297,-135.003439,0.981825814}
      "Coefficients in equation (4) and (5)";
    Real theta = sat.Tsat / Tcritical  "Temperature ratio";
  algorithm
    a := a0*(d_a + d[1]*theta^m[1] + d[2]*theta^m[2] + d[3]*theta^m[3] +
      d[4]*theta^m[4] + d[5]*theta^m[5])  "Equation (4)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Auxiliary equation for alpha, equation (4).
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end auxiliaryAlpha_sat;

  function auxiliaryPhi_sat
    "This is auxiliary equation (5) for specific entropy calculations"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real phi  "Phi in equation (5)";
  protected
    Real m[:] = {-20,0,3.5,4,53.5}  "Powers in equation (5)";
    Real d_phi = 2319.5246  "Coefficient in equation (5)";
    Real d[:] = {-5.65134998e-8,2690.66631,127.287297,-135.003439,0.981825814}
      "Coefficients in equation (4) and (5)";
    Real a[:] = {19/20,1,9/7,5/4,109/107}  "Additional coefficients in (5)";
    Real phi0 = a0 / Tcritical  "Given reference constant";
    Real theta = sat.Tsat / Tcritical  "Temperature ratio";
  algorithm
    phi := phi0*(d_phi + a[1]*d[1]*theta^m[1] + a[2]*d[2]*log(theta) +
      a[3]*d[3]*theta^m[3] + a[4]*d[4]*theta^m[4] + a[5]*d[5]*theta^m[5])
      "Equation (5)";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Auxiliary equation for <code>phi</code>, equation (5).
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end auxiliaryPhi_sat;

  function expression1_sat
    "This expression represents ln(p/pcritical), which is used in the saturated
      enthalpy and entropy functions above"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real r1  "Expression 1";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real Tcri_Tsat = Tcritical/sat.Tsat "Ratio of critical over saturation temperature";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    r1 := Tcri_Tsat * sum(a[i] * tau^n[i] for i in 1:6);
  /*   r1 := (a[1]*Tcritical*tau^n[1])/sat.Tsat + (a[2]*Tcritical*tau^n[2])/sat.Tsat
       + (a[3]*Tcritical*tau^n[3])/sat.Tsat + (a[4]*Tcritical*tau^n[4])/sat.Tsat
       + (a[5]*Tcritical*tau^n[5])/sat.Tsat + (a[6]*Tcritical*tau^n[6])/sat.Tsat
       "Expression 1";
  */
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Intermediate expression developed based on the work by Wagner and Pruss (1993),
    which is used in calculating various saturation state properties, including
    enthalpy and entropy.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end expression1_sat;

  function expression2_sat
    "This expression is used in the saturated enthalpy and entropy functions
      above, which was formulated via evaluating the derivative dP/dT"
    extends Modelica.Icons.Function;
    input SaturationProperties sat "Saturation property record";
    output Real r2  "Expression 2";
  protected
    Real n[:] = {1,1.5,3,3.5,4,7.5} "Powers in equation (1)";
    Real a[:] = {-7.85951783,1.84408259,-11.7866497,22.6807411,-15.9618719,
        1.80122502} "Coefficients in equation (1) of [1]";
    Real tau = 1 - sat.Tsat/Tcritical "Temperature expression";
  algorithm
    r2 := sum(a[i]*n[i]*tau^n[i] for i in 1:6)
      "Expression 2";
  annotation (
    smoothOrder=2,
    Documentation(info="<html>
    <p>
    Intermediate expression developed based on the work by Wagner and Pruss (1993),
    which is used in calculating various saturation state properties, including
    enthalpy and entropy.
    </p>
    <p>
    Source: W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
    Ordinary Water Substance. Revised According to the International Temperature Scale
    of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
    Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
    <a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
    </p>
  </html>"));
  end expression2_sat;

annotation (Documentation(info="<html>
<p>
The steam model can be utilized for steam systems and components that use the
vapor phase of water (quality = 1).
</p>
<p>
States are formulated from the NASA Glenn coefficients for ideal gas \"H2O\".
Independent variables are temperature <i>T</i> and pressure <i>p</i>. Only
density is a function of <i>T</i> and <i>p</i>. All other quantities are solely a function
of T.
</p>
<p align=\"center\">
<img src=\"modelica://Modelica/Resources/Images/Media/IdealGases/SingleGases/H2O.png\"
alt=\"Specific heat of ideal steam\"/>
</p>
<h4>
Limitations
</h4>
<ul>
<li>
The properties are valid in the range: <i>200 K &le; T &le; 6000 K</i>, with the
exception of saturated state properties, which are valid in the range:
<i>273.16 K &le; T &le; 647.096 K</i>
</li>
<li>
When phase change is required, this model is to be used in combination with the
<a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a> media model for
incompressible liquid water for the liquid phase (quality = 0).
</li>
<li>
The two-phase region (e.g., mixed liquid and vapor) is not included.
</li>
<li>
This model assumes the pressure, and hence the saturation pressure,
is constant throughout the simulation.
This is done to improve simulation performance by decoupling
the pressure drop and energy balance calculations. Thus, a function for
calculating saturation pressure is not provided.
</li>
</ul>
<h4>
References
</h4>
<p>
S. Gordon and B. J. McBride, \"Computer Program for Calculation of Complex
Chemical Equilibrium Compositions and Applications: I. Analysis,\" NASA Technical
Reports, NASA-RP-1311, Cleveland, OH, 1994. Available:
<a href=\"https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19950013764.pdf\">
https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19950013764.pdf</a>.
</p>
<p>
W. Wagner and A. Pruss, \"International Equations for the Saturation Properties of
Ordinary Water Substance. Revised According to the International Temperature Scale
of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987),\" <i>J. Phys. Chem.
Ref. Data</i>, vol. 22, no. 3, pp. 783-787, 1993. doi:
<a href=\"https://doi.org/10.1063/1.555926\">10.1063/1.555926</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
March 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
      Line(
        points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{10,30},{-10,10},{10,-10},{-10,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{50,30},{30,10},{50,-10},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier)}));
end Steam;
