within Buildings.Media;
package Steam
  "Package with model for pure steam water vapor"
  extends Modelica.Media.Interfaces.PartialMedium(
     mediumName="steam",
     final substanceNames={"water"},
     singleState = true,
     reducedX = true,
     fixedX = true,
     FluidConstants={Modelica.Media.IdealGases.Common.FluidData.H2O},
     reference_T=273.15,
     reference_p=101325,
     reference_X={1},
     AbsolutePressure(start=p_default),
     Temperature(start=T_default),
     SpecificEnthalpy(start=2.7e6, nominal=2.7e6),
     Density(start=0.6, nominal=1),
     T_default=Modelica.SIunits.Conversions.from_degC(100),
     p_default=100000);
  extends Modelica.Icons.Package;

  redeclare record ThermodynamicState
    "Thermodynamic state variables"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

redeclare replaceable model extends BaseProperties(
    preferredMediumStates = true,
    final standardOrderComponents=true)
    "Base properties (p, d, T, h, u, R, MM) of water"
equation
    MM = steam.MM;
    h = specificEnthalpy(state);
    d = density(state);
    u = h - p/d;
    R = steam.R;
    state.p = p;
    state.T = T;
end BaseProperties;

redeclare replaceable function extends density
  "Returns density"
algorithm
  d := rho_pT(state.p, state.T);
  annotation (Inline=true, Documentation(info="<html>
<p>
Density is computed from temperature and pressure using the
IAPWS-IF97 relationship via the Gibbs free energy for region 2.
</p>
</html>"));
end density;

redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity"
algorithm
    eta := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
          d=density(state),
          T=state.T,
          p=state.p);
    annotation (Inline=true, Documentation(info="<html>
<p>
Dynamic viscosity is computed from density, temperature and pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end dynamicViscosity;

redeclare replaceable function extends molarMass
  "Return the molar mass of the medium"
algorithm
  MM := steam.MM;
    annotation (Documentation(info="<html>
<p>
Returns the molar mass.
</p>
</html>"));
end molarMass;

redeclare function extends pressure
  "Return pressure"
algorithm
  p := state.p;
    annotation (Documentation(info="<html>
<p>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</p>
</html>"));
end pressure;

replaceable function saturationPressure
  "Return saturation pressure of condensing fluid"
    extends Modelica.Icons.Function;
    input Temperature Tsat "Saturation temperature";
    output AbsolutePressure psat "Saturation pressure";
algorithm
   psat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.psat(Tsat);
 annotation (Inline=true, Documentation(info="<html>
<p>
Saturation pressure is computed from temperature
using the IAPWS-IF97 formulation.
</p>
</html>"));
end saturationPressure;

replaceable function saturationTemperature
    "Return saturation temperature"
  input AbsolutePressure psat "Saturation pressure";
  output Temperature Tsat "Saturation temperature";
algorithm
    Tsat := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(psat);
    annotation (Inline=true, Documentation(info="<html>
<p>
Saturation temperature is computed from pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end saturationTemperature;

redeclare replaceable function extends specificEnthalpy
  "Returns specific enthalpy"
  protected
    constant Real a[:] = {2.749e+06,-9118,2.752e+04} "Regression coefficients";
    constant AbsolutePressure pMean = 2.50427896656637E+05 "Mean pressure";
    constant Temperature TMean =  4.15555698340926E+02 "Mean temperature";
    constant Real pSD = 1.13236055019318E+05 "Normalization value";
    constant Real TSD = 1.32971013463839E+01 "Normalization value";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (state.p - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  h := a[1] + a[2]*pHat + a[3]*THat;
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
Returns the specific enthalpy.
</p>
<h4>Implementation</h4>
<p>
The function is based on
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT\">
Modelica.Media.Water.WaterIF97_base.specificEnthalpy_pT</a>.
However, for the typical range of temperatures and pressures
encountered in building and district energy applications,
a linear function sufficies. This implementation is therefore a linear
surface fit of the IF97 formulation <i>h(p,T)</i> in the ranges of
<i>100&deg;C &le; T &le; 160&deg;C</i> and
<i>100 kPa &le; p &le; 550</i> kPa. The fit is scaled by the dataset's
mean and standard deviation values to improve conditioning.
The largest error of this linearization is  <i>2.42 kJ/kg</i> (<i>0.09</i>%),
which occurs at <i>100.6&deg;C</i> and <i>100 kPa</i>.
The root mean square error (RMSE) is <i>0.76 kJ/kg</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEnthalpy;

redeclare replaceable function extends specificEntropy
  "Return specific entropy"
  protected
    constant Real a[:] = {7135,-252.4,70.03,40.6,4.953} "Regression coefficients";
    constant AbsolutePressure pMean = 2.50427896656637E+05 "Mean pressure";
    constant Temperature TMean =  4.15555698340926E+02 "Mean temperature";
    constant Real pSD = 1.13236055019318E+05 "Normalization value";
    constant Real TSD = 1.32971013463839E+01 "Normalization value";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (state.p - pMean)/pSD;
  THat := (state.T - TMean)/TSD;
  s := a[1] + a[2]*pHat + a[3]*THat + pHat*(a[4]*pHat + a[5]*THat);
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
Returns the specific entropy.
</p>
<h4>Implementation</h4>
<p>
The function is based on
<a href=\"modelica://Modelica.Media.Water.WaterIF97_base.specificEntropy\">
Modelica.Media.Water.WaterIF97_base.specificEntropy</a>.
However, for the typical range of temperatures and pressures
encountered in building and district energy applications,
an invertible polynomial fit sufficies. This implementation is therefore
a polynomial fit (quadratic in pressure, linear in temperature) of the
IF97 formulation <i>s(p,T)</i> in the ranges of
<i>100&deg;C &le; T &le; 160&deg;C</i> and
<i>100 kPa &le; p &le; 550 kPa</i>. The fit is scaled by the dataset's
mean and standard deviation values to improve conditioning.
The largest error of this approximation is <i>0.047 kJ/kg-K</i> (<i>0.70</i>%),
which occurs at <i>160&deg;C</i> and <i>550 kPa</i>.
The root mean square error (RMSE) is <i>12.56 J/kg-K</i>.
</p>
</html>"));
end specificEntropy;

redeclare replaceable function extends specificInternalEnergy
  "Return specific internal energy"
algorithm
  u := specificEnthalpy(state) - state.p/density(state);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the specific internal energy for a given state.
</p>
</html>"));
end specificInternalEnergy;

redeclare replaceable function extends specificHeatCapacityCp
  "Specific heat capacity at constant pressure"

protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(state.p, state.T);
  cp := -R*g.tau*g.tau*g.gtautau;
  annotation (
    smoothOrder=2,
    Inline=true,
      Documentation(info="<html>
<p>
Specific heat at constant pressure is computed from temperature and
pressure using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>"));
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
  "Specific heat capacity at constant volume"

protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := g2(state.p, state.T);
  cv := R*(-g.tau*g.tau*g.gtautau + ((g.gpi - g.tau*g.gtaupi)*(g.gpi
     - g.tau*g.gtaupi)/g.gpipi));
  annotation (
    smoothOrder=2,
    Inline=true,
    LateInline = true,
      Documentation(info="<html>
<p>
Specific heat at constant volume is computed from temperature and
pressure using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2020, by Michael Wetter:<br/>
Added <code>LateInline=true</code>.
This is required for OCT-r17595_JM-r14295, otherwise
<a href=\"modelica://Buildings.Media.Examples.SteamDerivativeCheck\">
Buildings.Media.Examples.SteamDerivativeCheck</a>
does not translate.
</li>
</ul>
</html>"));
end specificHeatCapacityCv;

redeclare replaceable function extends specificGibbsEnergy
   "Specific Gibbs energy"
algorithm
  g := specificEnthalpy(state) - state.T*specificEntropy(state);
  annotation (Inline=true);
end specificGibbsEnergy;

redeclare replaceable function extends specificHelmholtzEnergy
   "Specific Helmholtz energy"
algorithm
  f := specificEnthalpy(state) - steam.R*state.T - state.T*specificEntropy(state);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the specific Helmholtz energy for a given state.
</p>
</html>"));
end specificHelmholtzEnergy;

redeclare replaceable function extends setState_dTX
    "Return the thermodynamic state as function of d and T"
algorithm
  state := ThermodynamicState(p=pressure_dT(d,T), T=T);
annotation (Inline=true,
      Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from density <code>d</code> and temperature <code>T</code>.
</p>
</html>"));
end setState_dTX;

redeclare replaceable function extends setState_pTX
    "Return the thermodynamic state as function of p and T"
algorithm
  state := ThermodynamicState(p=p, T=T);
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p</code> and temperature <code>T</code>.
</p>
</html>"));
end setState_pTX;

redeclare replaceable function extends setState_phX
    "Return the thermodynamic state as function of p and h"
algorithm
  state := ThermodynamicState(p=p, T=temperature_ph(p,h));
annotation (Inline=true,smoothOrder=2,
      Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p</code> and specific enthalpy <code>h</code>.
</p>
</html>"));
end setState_phX;

redeclare replaceable function extends setState_psX
    "Return the thermodynamic state as function of p and s"
algorithm
  state := ThermodynamicState(p=p, T=temperature_ps(p,s));
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
is computed from pressure <code>p</code> and specific entropy <code>s</code>.
</p>
</html>"));
end setState_psX;

redeclare function extends temperature
    "Return temperature"
algorithm
  T := state.T;
    annotation (Documentation(info="<html>
<p>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</p>
</html>"));
end temperature;

redeclare replaceable function extends thermalConductivity
  "Return thermal conductivity"
algorithm
  lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
        density(state),
        state.T,
        state.p);
  annotation (Inline=true, Documentation(info="<html>
<p>
Thermal conductivity is computed from density, temperature and pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end thermalConductivity;

redeclare function extends density_derh_p
  "Density derivative by specific enthalpy"
algorithm
  ddhp := Modelica.Media.Water.IF97_Utilities.ddhp(
        p = state.p,
        h = specificEnthalpy(state),
        phase = 1,
        region = 2);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the partial derivative of density with respect
to specific enthalpy at constant pressure using the IAPWS-IF97 formulation.
</p>
</html>"));
end density_derh_p;

redeclare function extends density_derp_h
  "Density derivative by pressure"
algorithm
  ddph := Modelica.Media.Water.IF97_Utilities.ddph(
        p = state.p,
        h = specificEnthalpy(state),
        phase = 1,
        region = 2);
  annotation (Inline=true, Documentation(info="<html>
<p>
Returns the partial derivative of density with respect
to pressure at constant specific enthalpy using the IAPWS-IF97 formulation.
</p>
</html>"));
end density_derp_h;

redeclare replaceable function extends isentropicExponent
  "Return isentropic exponent"
algorithm
  gamma := Modelica.Media.Water.IF97_Utilities.isentropicExponent_pT(
        p = state.p,
        T = state.T,
        region = 2);
  annotation (Inline=true, Documentation(info="<html>
<p>
Isentropic exponent is computed from temperature and pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end isentropicExponent;

redeclare replaceable function extends isothermalCompressibility
  "Isothermal compressibility of water"
algorithm
  kappa := Modelica.Media.Water.IF97_Utilities.kappa_pT(
        p = state.p,
        T = state.T,
        region = 2);
  annotation (Inline=true, Documentation(info="<html>
<p>
Isothermal compressibility is computed from temperature and pressure
using the IAPWS-IF97 formulation.
</p>
</html>"));
end isothermalCompressibility;

redeclare replaceable function extends isobaricExpansionCoefficient
  "Isobaric expansion coefficient of water"
algorithm
  beta := Modelica.Media.Water.IF97_Utilities.beta_pT(
        p = state.p,
        T = state.T,
        region = 2);
    annotation (Documentation(info="<html>
<p>
Isobaric expansion coefficient is computed from temperature and
pressure using the IAPWS-IF97 formulation.
</p>
</html>"));
end isobaricExpansionCoefficient;

redeclare replaceable function extends isentropicEnthalpy
  "Isentropic enthalpy"
algorithm
  h_is := Modelica.Media.Water.IF97_Utilities.isentropicEnthalpy(
        p = p_downstream,
        s = specificEntropy(refState),
        phase = 0); // phase 0 means unknown
  annotation (Inline=true, Documentation(info="<html>
<p>
Isentropic enthalpy is computed using the IAPWS-IF97 formulation:
</p>
<ol>
<li> A medium is in a particular state, <code>refState</code>.</li>
<li> The enthalpy at another state <code>h_is</code> shall be computed
     under the assumption that the state transformation from <code>refState</code> to <code>h_is</code>
     is performed with a change of specific entropy <i>ds = 0</i> and the pressure of state <code>h_is</code>
     is <code>p_downstream</code> and the composition <code>X</code> upstream and downstream is assumed to be the same.</li>
</ol>
</html>"));
end isentropicEnthalpy;
//////////////////////////////////////////////////////////////////////
// Protected classes

protected
record GasProperties
  "Coefficient data record for properties of perfect gases"
  extends Modelica.Icons.Record;
  Modelica.SIunits.MolarMass MM "Molar mass";
  Modelica.SIunits.SpecificHeatCapacity R "Gas constant";
end GasProperties;
constant GasProperties steam(
  R =    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R,
  MM =   Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM)
  "Steam properties";

function g2 "Gibbs function for region 2: g(p,T)"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Pressure p "Pressure";
  input Modelica.SIunits.Temperature T "Temperature (K)";
  output Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
protected
  Real tau2 "Dimensionless temperature";
  Real[55] o "Vector of auxiliary variables";
algorithm
  g.p := p;
  g.T := T;
  g.R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
//  assert(p > 0.0,
//    "IF97 medium function g2 called with too low pressure\n" + "p = " +
//    String(p) + " Pa <=  0.0 Pa");
//  assert(p <= 100.0e6, "IF97 medium function g2: the input pressure (= "
//     + String(p) + " Pa) is higher than 100 Mpa");
//  assert(T >= 273.15, "IF97 medium function g2: the temperature (= " +
//    String(T) + " K) is lower than 273.15 K!");
//  assert(T <= 1073.15,
//    "IF97 medium function g2: the input temperature (= " + String(T) +
//    " K) is higher than the limit of 1073.15 K");
  g.pi := p/Modelica.Media.Water.IF97_Utilities.BaseIF97.data.PSTAR2;
  g.tau := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.TSTAR2/T;
  tau2 := -0.5 + g.tau;
  o[1] := tau2*tau2;
  o[2] := o[1]*tau2;
  o[3] := -0.050325278727930*o[2];
  o[4] := -0.057581259083432 + o[3];
  o[5] := o[4]*tau2;
  o[6] := -0.045996013696365 + o[5];
  o[7] := o[6]*tau2;
  o[8] := -0.0178348622923580 + o[7];
  o[9] := o[8]*tau2;
  o[10] := o[1]*o[1];
  o[11] := o[10]*o[10];
  o[12] := o[11]*o[11];
  o[13] := o[10]*o[11]*o[12]*tau2;
  o[14] := o[1]*o[10]*tau2;
  o[15] := o[10]*o[11]*tau2;
  o[16] := o[1]*o[12]*tau2;
  o[17] := o[1]*o[11]*tau2;
  o[18] := o[1]*o[10]*o[11];
  o[19] := o[10]*o[11]*o[12];
  o[20] := o[1]*o[10];
  o[21] := g.pi*g.pi;
  o[22] := o[21]*o[21];
  o[23] := o[21]*o[22];
  o[24] := o[10]*o[12]*tau2;
  o[25] := o[12]*o[12];
  o[26] := o[11]*o[12]*o[25]*tau2;
  o[27] := o[10]*o[12];
  o[28] := o[1]*o[10]*o[11]*tau2;
  o[29] := o[10]*o[12]*o[25]*tau2;
  o[30] := o[1]*o[10]*o[25]*tau2;
  o[31] := o[1]*o[11]*o[12];
  o[32] := o[1]*o[12];
  o[33] := g.tau*g.tau;
  o[34] := o[33]*o[33];
  o[35] := -0.000053349095828174*o[13];
  o[36] := -0.087594591301146 + o[35];
  o[37] := o[2]*o[36];
  o[38] := -0.0078785554486710 + o[37];
  o[39] := o[1]*o[38];
  o[40] := -0.00037897975032630 + o[39];
  o[41] := o[40]*tau2;
  o[42] := -0.000066065283340406 + o[41];
  o[43] := o[42]*tau2;
  o[44] := 5.7870447262208e-6*tau2;
  o[45] := -0.301951672367580*o[2];
  o[46] := -0.172743777250296 + o[45];
  o[47] := o[46]*tau2;
  o[48] := -0.091992027392730 + o[47];
  o[49] := o[48]*tau2;
  o[50] := o[1]*o[11];
  o[51] := o[10]*o[11];
  o[52] := o[11]*o[12]*o[25];
  o[53] := o[10]*o[12]*o[25];
  o[54] := o[1]*o[10]*o[25];
  o[55] := o[11]*o[12]*tau2;

  g.g := g.pi*(-0.00177317424732130 + o[9] + g.pi*(tau2*(-0.000033032641670203
     + (-0.000189489875163150 + o[1]*(-0.0039392777243355 + (-0.043797295650573
     - 0.0000266745479140870*o[13])*o[2]))*tau2) + g.pi*(
    2.04817376923090e-8 + (4.3870667284435e-7 + o[1]*(-0.000032277677238570
     + (-0.00150339245421480 - 0.040668253562649*o[13])*o[2]))*tau2 + g.pi
    *(g.pi*(2.29220763376610e-6*o[14] + g.pi*((-1.67147664510610e-11 + o[
    15]*(-0.00211714723213550 - 23.8957419341040*o[16]))*o[2] + g.pi*(-5.9059564324270e-18
     + o[17]*(-1.26218088991010e-6 - 0.038946842435739*o[18]) + g.pi*(o[
    11]*(1.12562113604590e-11 - 8.2311340897998*o[19]) + g.pi*(
    1.98097128020880e-8*o[15] + g.pi*(o[10]*(1.04069652101740e-19 + (-1.02347470959290e-13
     - 1.00181793795110e-9*o[10])*o[20]) + o[23]*(o[13]*(-8.0882908646985e-11
     + 0.106930318794090*o[24]) + o[21]*(-0.33662250574171*o[26] + o[21]*
    (o[27]*(8.9185845355421e-25 + (3.06293168762320e-13 -
    4.2002467698208e-6*o[15])*o[28]) + g.pi*(-5.9056029685639e-26*o[24]
     + g.pi*(3.7826947613457e-6*o[29] + g.pi*(-1.27686089346810e-15*o[30]
     + o[31]*(7.3087610595061e-29 + o[18]*(5.5414715350778e-17 -
    9.4369707241210e-7*o[32]))*g.pi)))))))))))) + tau2*(-7.8847309559367e-10
     + (1.27907178522850e-8 + 4.8225372718507e-7*tau2)*tau2))))) + (-0.0056087911830200
     + g.tau*(0.071452738814550 + g.tau*(-0.40710498239280 + g.tau*(
    1.42408197144400 + g.tau*(-4.3839511194500 + g.tau*(-9.6927686002170
     + g.tau*(10.0866556801800 + (-0.284086326077200 + 0.0212684635330700
    *g.tau)*g.tau) + Modelica.Math.log(g.pi)))))))/(o[34]*g.tau);

  g.gpi := (1.00000000000000 + g.pi*(-0.00177317424732130 + o[9] + g.pi*(
    o[43] + g.pi*(6.1445213076927e-8 + (1.31612001853305e-6 + o[1]*(-0.000096833031715710
     + (-0.0045101773626444 - 0.122004760687947*o[13])*o[2]))*tau2 + g.pi
    *(g.pi*(0.0000114610381688305*o[14] + g.pi*((-1.00288598706366e-10 +
    o[15]*(-0.0127028833928130 - 143.374451604624*o[16]))*o[2] + g.pi*(-4.1341695026989e-17
     + o[17]*(-8.8352662293707e-6 - 0.272627897050173*o[18]) + g.pi*(o[11]
    *(9.0049690883672e-11 - 65.849072718398*o[19]) + g.pi*(
    1.78287415218792e-7*o[15] + g.pi*(o[10]*(1.04069652101740e-18 + (-1.02347470959290e-12
     - 1.00181793795110e-8*o[10])*o[20]) + o[23]*(o[13]*(-1.29412653835176e-9
     + 1.71088510070544*o[24]) + o[21]*(-6.0592051033508*o[26] + o[21]*(o[
    27]*(1.78371690710842e-23 + (6.1258633752464e-12 -
    0.000084004935396416*o[15])*o[28]) + g.pi*(-1.24017662339842e-24*o[24]
     + g.pi*(0.000083219284749605*o[29] + g.pi*(-2.93678005497663e-14*o[
    30] + o[31]*(1.75410265428146e-27 + o[18]*(1.32995316841867e-15 -
    0.0000226487297378904*o[32]))*g.pi)))))))))))) + tau2*(-3.15389238237468e-9
     + (5.1162871409140e-8 + 1.92901490874028e-6*tau2)*tau2))))))/g.pi;

  g.gpipi := (-1.00000000000000 + o[21]*(o[43] + g.pi*(
    1.22890426153854e-7 + (2.63224003706610e-6 + o[1]*(-0.000193666063431420
     + (-0.0090203547252888 - 0.244009521375894*o[13])*o[2]))*tau2 + g.pi
    *(g.pi*(0.000045844152675322*o[14] + g.pi*((-5.0144299353183e-10 + o[
    15]*(-0.063514416964065 - 716.87225802312*o[16]))*o[2] + g.pi*(-2.48050170161934e-16
     + o[17]*(-0.000053011597376224 - 1.63576738230104*o[18]) + g.pi*(o[
    11]*(6.3034783618570e-10 - 460.94350902879*o[19]) + g.pi*(
    1.42629932175034e-6*o[15] + g.pi*(o[10]*(9.3662686891566e-18 + (-9.2112723863361e-12
     - 9.0163614415599e-8*o[10])*o[20]) + o[23]*(o[13]*(-1.94118980752764e-8
     + 25.6632765105816*o[24]) + o[21]*(-103.006486756963*o[26] + o[21]*(
    o[27]*(3.3890621235060e-22 + (1.16391404129682e-10 -
    0.00159609377253190*o[15])*o[28]) + g.pi*(-2.48035324679684e-23*o[24]
     + g.pi*(0.00174760497974171*o[29] + g.pi*(-6.4609161209486e-13*o[30]
     + o[31]*(4.0344361048474e-26 + o[18]*(3.05889228736295e-14 -
    0.00052092078397148*o[32]))*g.pi)))))))))))) + tau2*(-9.4616771471240e-9
     + (1.53488614227420e-7 + o[44])*tau2)))))/o[21];

  g.gtau := (0.0280439559151000 + g.tau*(-0.285810955258200 + g.tau*(
    1.22131494717840 + g.tau*(-2.84816394288800 + g.tau*(4.3839511194500
     + o[33]*(10.0866556801800 + (-0.56817265215440 + 0.063805390599210*g.tau)
    *g.tau))))))/(o[33]*o[34]) + g.pi*(-0.0178348622923580 + o[49] + g.pi
    *(-0.000033032641670203 + (-0.00037897975032630 + o[1]*(-0.0157571108973420
     + (-0.306581069554011 - 0.00096028372490713*o[13])*o[2]))*tau2 + g.pi
    *(4.3870667284435e-7 + o[1]*(-0.000096833031715710 + (-0.0090203547252888
     - 1.42338887469272*o[13])*o[2]) + g.pi*(-7.8847309559367e-10 + g.pi*
    (0.0000160454534363627*o[20] + g.pi*(o[1]*(-5.0144299353183e-11 + o[
    15]*(-0.033874355714168 - 836.35096769364*o[16])) + g.pi*((-0.0000138839897890111
     - 0.97367106089347*o[18])*o[50] + g.pi*(o[14]*(9.0049690883672e-11
     - 296.320827232793*o[19]) + g.pi*(2.57526266427144e-7*o[51] + g.pi*(
    o[2]*(4.1627860840696e-19 + (-1.02347470959290e-12 -
    1.40254511313154e-8*o[10])*o[20]) + o[23]*(o[19]*(-2.34560435076256e-9
     + 5.3465159397045*o[24]) + o[21]*(-19.1874828272775*o[52] + o[21]*(o[
    16]*(1.78371690710842e-23 + (1.07202609066812e-11 -
    0.000201611844951398*o[15])*o[28]) + g.pi*(-1.24017662339842e-24*o[27]
     + g.pi*(0.000200482822351322*o[53] + g.pi*(-4.9797574845256e-14*o[54]
     + (1.90027787547159e-27 + o[18]*(2.21658861403112e-15 -
    0.000054734430199902*o[32]))*o[55]*g.pi)))))))))))) + (
    2.55814357045700e-8 + 1.44676118155521e-6*tau2)*tau2))));

  g.gtautau := (-0.168263735490600 + g.tau*(1.42905477629100 + g.tau*(-4.8852597887136
     + g.tau*(8.5444918286640 + g.tau*(-8.7679022389000 + o[33]*(-0.56817265215440
     + 0.127610781198420*g.tau)*g.tau)))))/(o[33]*o[34]*g.tau) + g.pi*(-0.091992027392730
     + (-0.34548755450059 - 1.50975836183790*o[2])*tau2 + g.pi*(-0.00037897975032630
     + o[1]*(-0.047271332692026 + (-1.83948641732407 - 0.033609930371750*
    o[13])*o[2]) + g.pi*((-0.000193666063431420 + (-0.045101773626444 -
    48.395221739552*o[13])*o[2])*tau2 + g.pi*(2.55814357045700e-8 +
    2.89352236311042e-6*tau2 + g.pi*(0.000096272720618176*o[10]*tau2 + g.pi
    *((-1.00288598706366e-10 + o[15]*(-0.50811533571252 -
    28435.9329015838*o[16]))*tau2 + g.pi*(o[11]*(-0.000138839897890111 -
    23.3681054614434*o[18])*tau2 + g.pi*((6.3034783618570e-10 -
    10371.2289531477*o[19])*o[20] + g.pi*(3.09031519712573e-6*o[17] + g.pi
    *(o[1]*(1.24883582522088e-18 + (-9.2112723863361e-12 -
    1.82330864707100e-7*o[10])*o[20]) + o[23]*(o[1]*o[11]*o[12]*(-6.5676921821352e-8
     + 261.979281045521*o[24])*tau2 + o[21]*(-1074.49903832754*o[1]*o[10]
    *o[12]*o[25]*tau2 + o[21]*((3.3890621235060e-22 + (
    3.6448887082716e-10 - 0.0094757567127157*o[15])*o[28])*o[32] + g.pi*(
    -2.48035324679684e-23*o[16] + g.pi*(0.0104251067622687*o[1]*o[12]*o[
    25]*tau2 + g.pi*(o[11]*o[12]*(4.7506946886790e-26 + o[18]*(
    8.6446955947214e-14 - 0.00311986252139440*o[32]))*g.pi -
    1.89230784411972e-12*o[10]*o[25]*tau2))))))))))))))));

  g.gtaupi := -0.0178348622923580 + o[49] + g.pi*(-0.000066065283340406
     + (-0.00075795950065260 + o[1]*(-0.0315142217946840 + (-0.61316213910802
     - 0.00192056744981426*o[13])*o[2]))*tau2 + g.pi*(1.31612001853305e-6
     + o[1]*(-0.000290499095147130 + (-0.0270610641758664 -
    4.2701666240781*o[13])*o[2]) + g.pi*(-3.15389238237468e-9 + g.pi*(
    0.000080227267181813*o[20] + g.pi*(o[1]*(-3.00865796119098e-10 + o[15]
    *(-0.203246134285008 - 5018.1058061618*o[16])) + g.pi*((-0.000097187928523078
     - 6.8156974262543*o[18])*o[50] + g.pi*(o[14]*(7.2039752706938e-10 -
    2370.56661786234*o[19]) + g.pi*(2.31773639784430e-6*o[51] + g.pi*(o[2]
    *(4.1627860840696e-18 + (-1.02347470959290e-11 - 1.40254511313154e-7*
    o[10])*o[20]) + o[23]*(o[19]*(-3.7529669612201e-8 + 85.544255035272*o[
    24]) + o[21]*(-345.37469089099*o[52] + o[21]*(o[16]*(
    3.5674338142168e-22 + (2.14405218133624e-10 - 0.0040322368990280*o[15])
    *o[28]) + g.pi*(-2.60437090913668e-23*o[27] + g.pi*(
    0.0044106220917291*o[53] + g.pi*(-1.14534422144089e-12*o[54] + (
    4.5606669011318e-26 + o[18]*(5.3198126736747e-14 -
    0.00131362632479764*o[32]))*o[55]*g.pi)))))))))))) + (
    1.02325742818280e-7 + o[44])*tau2)));
annotation(smoothOrder = 2,
Documentation(info="<html>
<p>
This function is identical to
<a href=\"modelica://Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2\">
Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2</a>
except that
</p>
<ul>
<li>it contains the <code>smoothOrder</code> annotation, and
</li>
<li>
it removes the assertions on the temperature and pressure because the applicability of
this medium is steam heating which has medium states that are inside these values.
</li>
</ul>
<p>
The <code>smoothOrder</code> is needed for Optimica to differentiate the specific heat capacity,
which is used in
<a href=\"modelica://Buildings.Media.Examples.SteamDerivativeCheck\">
Buildings.Media.Examples.SteamDerivativeCheck</a>.
The function is differentiable except at <code>p=0</code>, which is far away from the state for which
this function is used.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end g2;

function temperature_ph
  "Return temperature from p and h, inverse function of h(p,T)"
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific Enthalpy";
    output Temperature T "Temperature";
  protected
    constant Real a[:] = {2.749e+06,-9118,2.752e+04} "Coefficients from forward function h(p,T)";
    constant Real b[:] = {-a[1]*TSD/a[3]+TMean, -a[2]*TSD/a[3], TSD/a[3]} "Regression coefficients";
    constant AbsolutePressure pMean = 2.50427896656637E+05 "Mean pressure";
    constant Temperature TMean =  4.15555698340926E+02 "Mean temperature";
    constant Real pSD = 1.13236055019318E+05 "Normalization value";
    constant Real TSD = 1.32971013463839E+01 "Normalization value";
    AbsolutePressure pHat;
algorithm
  pHat := (p - pMean)/pSD;
  T := b[1] + b[2]*pHat + b[3]*h;
annotation (Inline=true,smoothOrder=2,
      Documentation(info="<html>
<p>
Returns temperature from specific enthalpy and pressure.
</p>
<h4>Implementation</h4>
<p>
This linear approximation is the inverse or backward function of
<a href=\"modelica://Buildings.Media.Steam.specificEnthalpy\">
Buildings.Media.Steam.specificEnthalpy</a> and is numerically
consistent with that forward function.
</p>
<p>
The largest error of this linearization is  <i>1.17&deg;C</i> (<i>0.31</i>%),
which occurs at <i>100&deg;C</i> and <i>100 kPa</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2021, by Kathryn Hinkelman:<br/>
Added pressure as a variable.
</li>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperature_ph;

function temperature_ps
  "Return temperature from p and s, inverse function of s(p,T)"
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific Entropy";
    output Temperature T "Temperature";
  protected
    constant Real a[:] = {7135,-252.4,70.03,40.6,4.953} "Coefficients from forward function s(p,T)";
    constant AbsolutePressure pMean = 2.50427896656637E+05 "Mean pressure";
    constant Temperature TMean =  4.15555698340926E+02 "Mean temperature";
    constant Real pSD = 1.13236055019318E+05 "Normalization value";
    constant Real TSD = 1.32971013463839E+01 "Normalization value";
    AbsolutePressure pHat;
    Temperature THat;
algorithm
  pHat := (p - pMean)/pSD;
  THat := (s - a[1] - pHat*(a[2] + a[4]*pHat))/(a[3] + a[5]*pHat);
  T := THat*TSD + TMean;
annotation (Inline=true,smoothOrder=2,
    Documentation(info="<html>
<p>
Returns temperature from specific entropy and pressure.
</p>
<h4>Implementation</h4>
<p>
This polynomial approximation is the inverse or backward function of
<a href=\"modelica://Buildings.Media.Steam.specificEntropy\">
Buildings.Media.Steam.specificEntropy</a> and is numerically
consistent with that forward function.
</p>
<p>
The largest error of this linearization is  <i>7.70&deg;C</i> (<i>1.86</i>%),
which occurs at <i>137.4&deg;C</i> and <i>100 kPa</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2021, by Kathryn Hinkelman:<br/>
Added pressure as a variable.
</li>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperature_ps;

function rho_pT "Density as function of temperature and pressure"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input Temperature T "Temperature";
  output Density rho "Density";
  protected
  Modelica.Media.Common.GibbsDerivs g
    "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
  SpecificHeatCapacity R "Specific gas constant of water vapor";
algorithm
  R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
  // Region 2 properties
  g := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2(p, T);
  rho := p/(R*T*g.pi*g.gpi);
  annotation (
    Inline=true,
    smoothOrder=2,
    Documentation(info="<html>
<p>
Density is computed from temperature and pressure using the
IAPWS-IF97 relationship via the Gibbs free energy for region 2.
</p>
</html>"));
end rho_pT;

function pressure_dT
  "Computes pressure as a function of density and temperature"
  input Density d "Density";
  input Temperature T "Temperature";
  output AbsolutePressure p "Pressure";
algorithm
  p := Modelica.Media.Water.IF97_Utilities.BaseIF97.Inverses.pofdt125(
        d=d,
        T=T,
        reldd=1.0e-8,
        region=2);
  annotation (Inline=true);
end pressure_dT;

  annotation (Icon(graphics={
      Line(
        points={{50,30},{30,10},{50,-10},{30,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{10,30},{-10,10},{10,-10},{-10,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier),
      Line(
        points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
        color={0,0,0},
        smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This medium package models water vapor (pure steam, region 2, quality=1).
</p>
<p>
Thermodynamic properties are calculated primarily in terms of pressure
and temperature.
For thermodynamic property functions, the IAPWS-IF97 formulations are adapted,
and approximate relationships are provided for commonly used functions to improve
computational efficiency and provide backward compatability.
</p>
<p>
Detailed functions from <a href=\"modelica://Modelica.Media.Water.WaterIF97_R2pT\">
Modelica.Media.Water.WaterIF97_R2pT</a> are generally used, expect for
<a href=\"modelica://Buildings.Media.Steam.specificEnthalpy\">Buildings.Media.Steam.specificEnthalpy</a> and
<a href=\"modelica://Buildings.Media.Steam.specificEntropy\">Buildings.Media.Steam.specificEntropy</a>
(both \"forward\" functions), as well as their \"backward\" inverse functions
<a href=\"modelica://Buildings.Media.Steam.temperature_ph\">Buildings.Media.Steam.temperature_ph</a> and
<a href=\"modelica://Buildings.Media.Steam.temperature_ps\">Buildings.Media.Steam.temperature_ps</a>,
which are numerically consistent with the forward functions.
The following modifications were made relative to the
<a href=\"modelica://Modelica.Media.Water.WaterIF97_R2pT\">
Modelica.Media.Water.WaterIF97_R2pT</a> medium package:
</p>
<ol>
<li>Analytic expressions for the derivatives are provided for all thermodynamic property functions.</li>
<li>The implementation is generally simplier in order to increase the likelyhood
of more efficient simulations. </li>
</ol>
<h4>Limitations </h4>
<ul>
<li>
The valid temperature range is <i>100&deg;C &le; T &le; 160&deg;C</i>, and the valid
pressure range is <i>100 kPa &le; p &le; 550 kPa</i>.
</li>
<li>When phase change is required, this model is to be used in combination with
<a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a>
for the liquid phase (quality=0). Please note that the maximum temperature for liquid
water is <code>T_max=130&deg;C</code>. This is suitable for real-world condensate
return and boiler feedwater systems, which are typically vented to the atmosphere
with steam contained via steam traps (thus, <code>T_max=100&deg;C</code> for the
condensate or feedwater in properly functioning systems).</li>
</ul>
<h4>Applications </h4>
<p>
This model is intended for first generation district heating systems and other
steam heating processes involving low and medium pressure steam.
</p>
<h4>References </h4>
<p>W. Wagner et al., &ldquo;The IAPWS industrial formulation 1997 for the thermodynamic
properties of water and steam,&rdquo; <i>J. Eng. Gas Turbines Power</i>, vol. 122, no.
1, pp. 150&ndash;180, 2000.
</p>
</html>", revisions="<html>
<ul>
<li>
April 13, 2021, by Kathryn Hinkelman:<br/>
Changed pressure from constant to variable and reduced applicable
pressure-temperature range to improve accuracy of polynomial approximations.
</li>
<li>
October 30, 2020, by Kathryn Hinkelman:<br/>
Complete new reimplementation to eliminate numerical inefficiencies
and improve accuracy of property function calculations.
</li>
</ul>
</html>"));
end Steam;
