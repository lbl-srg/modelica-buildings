within Buildings.Media.Specialized.Water;
package TemperatureDependentDensity
  "Package with model for liquid water with temperature-dependent density"
   extends Modelica.Media.Interfaces.PartialPureSubstance(
     mediumName="WaterDetailed",
     p_default=300000,
     reference_p=300000,
     reference_T=273.15,
     reference_X={1},
     final singleState=true,
     ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.T,
     AbsolutePressure(start=p_default),
     Temperature(start=T_default));
   extends Modelica.Icons.Package;

  redeclare record FluidConstants =
    Modelica.Media.Interfaces.Types.Basic.FluidConstants (
    each chemicalFormula="H2O",
    each structureFormula="H2O",
    each casRegistryNumber="7732-18-5",
    each iupacName="oxidane",
    each molarMass=MM_const);

  redeclare record extends ThermodynamicState "Thermodynamic state variables"
    Temperature T(start=T_default) "Temperature of medium";
    AbsolutePressure p(start=p_default) "Pressure of medium";
  end ThermodynamicState;

  constant Modelica.SIunits.SpecificHeatCapacity cp_const = 4184
    "Specific heat capacity at constant pressure";

  redeclare model extends BaseProperties(
     preferredMediumStates=true) "Base properties"
  equation
    h = (T - reference_T)*cp_const;
    u = h-reference_p/d;
    d = density(state);
    state.T = T;
    state.p = p;
    R=Modelica.Constants.R;
    MM=MM_const;
    annotation(Documentation(info="<html>
    <p>
    Base properties of the medium.
    </p>
</html>"));
  end BaseProperties;

redeclare function extends density "Return the density"
algorithm
  d := smooth(1,
    if state.T < 278.15 then
      -0.042860825*state.T + 1011.9695761
    elseif state.T < 373.15 then
      0.000015009*state.T^3 - 0.01813488505*state.T^2 + 6.5619527954075*state.T
      + 254.900074971947
    else
     -0.7025109*state.T + 1220.35045233);
  annotation (
  smoothOrder=1,
  Inline=true,
Documentation(info="<html>
<p>
This function computes the density as a function of temperature.
</p>
<h4>Implementation</h4>
<p>
The function is based on the IDA implementation in <code>therpro.nmf</code>, which
implements
</p>
<pre>
d := 1000.12 + 1.43711e-2*T_degC -
 5.83576e-3*T_degC^2 + 1.5009e-5*T_degC^3;
 </pre>
<p>
This has been converted to Kelvin, which resulted in the above expression.
In addition, below 5 &deg;C and above 100 &deg;C, the density is replaced
by a linear function to avoid inflection points.
This linear extension is such that the density is once continuously differentiable.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation, based on the IDA implementation in <code>therpro.nmf</code>,
but converted from Celsius to Kelvin and linearly extended.
</li>
</ul>
</html>"));
end density;

redeclare function extends dynamicViscosity "Return the dynamic viscosity"
algorithm
  eta := density(state)*kinematicViscosity(state.T);
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the dynamic viscosity.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end dynamicViscosity;

redeclare function extends specificEnthalpy "Return the specific enthalpy"
algorithm
  h := (state.T - reference_T)*cp_const;
annotation (
  smoothOrder=5,
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific enthalpy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEnthalpy;

function enthalpyOfLiquid "Return the specific enthalpy of liquid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";
algorithm
  h := (T - reference_T)*cp_const;
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfLiquid,
Documentation(info="<html>
<p>
This function computes the specific enthalpy of liquid water.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end enthalpyOfLiquid;

redeclare function extends specificInternalEnergy
    "Return the specific enthalpy"
algorithm
  u := specificEnthalpy(state) - reference_p/density(state);
annotation (
  smoothOrder=5,
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific internal energy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificInternalEnergy;

redeclare function extends specificEntropy "Return the specific entropy"
  extends Modelica.Icons.Function;
algorithm
  s := cv_const*Modelica.Math.log(state.T/reference_T);
  annotation (
    Inline=true,
    Documentation(info="<html>
<p>
This function computes the specific entropy.
</p>
<p>
To obtain the state for a given pressure, entropy and mass fraction, use
<a href=\"modelica://Buildings.Media.Air.setState_psX\">
Buildings.Media.Air.setState_psX</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEntropy;

redeclare function extends specificGibbsEnergy
    "Return the specific Gibbs energy"
  extends Modelica.Icons.Function;
algorithm
  g := specificEnthalpy(state) - state.T*specificEntropy(state);
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific Gibbs energy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificGibbsEnergy;

redeclare function extends specificHelmholtzEnergy
    "Return the specific Helmholtz energy"
  extends Modelica.Icons.Function;
algorithm
  f := specificInternalEnergy(state) - state.T*specificEntropy(state);
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific Helmholtz energy.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificHelmholtzEnergy;

redeclare function extends isentropicEnthalpy "Return the isentropic enthalpy"
algorithm
  h_is := specificEnthalpy(setState_psX(
            p=p_downstream,
            s=specificEntropy(refState),
            X={1}));
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific enthalpy for
an isentropic state change from the temperature
that corresponds to the state <code>refState</code>
to <code>reference_T</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isentropicEnthalpy;

redeclare function extends isobaricExpansionCoefficient
    "Return the isobaric expansion coefficient"
algorithm
    beta := -smooth(0,
    if state.T < 278.15 then
      0.042860825*(0.042860825*state.T - 1011.9695761)/(-0.042860825*state.T +
      1011.9695761)^2
    elseif state.T < 373.15 then
      (4.5027e-5*state.T^2 - 0.0362697701*state.T + 6.5619527954075)/
        (1.5009e-5*state.T^3 - 0.01813488505*state.T^2 + 6.5619527954075*state.T + 254.900074971947)
    else
       0.7025109*(0.7025109*state.T - 1220.35045233)/(-0.7025109*state.T +
       1220.35045233)^2);
        // Symbolic conversion of degC to Kelvin
//        ((4.5027e-05)*T_degC^2 - 0.01167152*state.T +
//               3.202446788)/((1.5009e-05)*T_degC^3 - 0.00583576*T_degC^2 +
//               0.0143711*state.T + 996.194534035)
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the isobaric expansion coefficient,
</p>
<p align=\"center\" style=\"font-style:italic;\">
&beta;<sub>p</sub> = - 1 &frasl; v &nbsp; (&part; v &frasl; &part; T)<sub>p</sub>,
</p>
<p>
where
<i>v</i> is the specific volume,
<i>T</i> is the temperature and
<i>p</i> is the pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isobaricExpansionCoefficient;

redeclare function extends isothermalCompressibility
    "Return the isothermal compressibility factor"
algorithm
  kappa := 0;
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the isothermal compressibility coefficient,
which is zero as this medium is incompressible.
The isothermal compressibility is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
&kappa;<sub>T</sub> = - 1 &frasl; v &nbsp; (&part; v &frasl; &part; p)<sub>T</sub>,
</p>
<p>
where
<i>v</i> is the specific volume,
<i>T</i> is the temperature and
<i>p</i> is the pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isothermalCompressibility;

redeclare function extends density_derp_T
    "Return the partial derivative of density with respect to pressure at constant temperature"
algorithm
  ddpT := 0;
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the partial derivative of density
with respect to pressure at constant temperature,
which is zero as the medium is incompressible.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_derp_T;

redeclare function extends density_derT_p
    "Return the partial derivative of density with respect to temperature at constant pressure"
algorithm
  ddTp := if state.T < 278.15 then
            -0.042860825
          elseif state.T < 373.15 then
            (0.0000450270000000000*state.T^2 - 0.0362697701000000*state.T +
            6.56195279540750)
          else
           -0.7025109;
  annotation (
  smoothOrder=1,
  Inline=true,
  Documentation(info=
                   "<html>
<p>
This function computes the derivative of density with respect to temperature
at constant pressure.
</p>
</html>", revisions=
"<html>
<ul>
<li>
August 17, 2015, by Michael Wetter:<br/>
Removed dublicate entry of <code>smooth</code> and <code>smoothOrder</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation, based on the IDA implementation in <code>therpro.nmf</code>,
but converted from Celsius to Kelvin.
</li>
</ul>
</html>"));
end density_derT_p;

redeclare function extends density_derX
    "Return the partial derivative of density with respect to mass fractions at constant pressure and temperature"
algorithm
  dddX := fill(0, nX);
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the partial derivative of density
with respect to mass fraction,
which is zero as the medium is a single substance.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_derX;

redeclare replaceable function extends specificHeatCapacityCp
    "Return the specific heat capacity at constant pressure"
algorithm
  cp := cp_const;
  annotation (
    Inline=true,
    derivative=der_specificHeatCapacityCp,
Documentation(info="<html>
<p>
This function returns the specific heat capacity at constant pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Return the specific heat capacity at constant volume"
algorithm
  cv := cv_const;
  annotation (
    Inline=true,
    derivative=der_specificHeatCapacityCp,
Documentation(info="<html>
<p>
This function computes the specific heat capacity at constant volume.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificHeatCapacityCv;

redeclare function extends thermalConductivity
    "Return the thermal conductivity"
algorithm
  lambda :=0.6065*(-1.48445 + 4.12292*(state.T/298.15) - 1.63866*(state.T/298.15)^2);
  annotation (
    Inline=true,
    Documentation(info="<html>
<p>
This function returns the thermal conductivity.
The expression is obtained from Ramires et al. (1995).
</p>
<h4>References</h4>
<p>
Ramires, Maria L. V. and Nieto de Castro, Carlos A. and Nagasaka, Yuchi
and Nagashima, Akira and Assael, Marc J. and Wakeham, William A.
Standard Reference Data for the Thermal Conductivity of Water.
<i>Journal of Physical and Chemical Reference Data</i>, 24, p. 1377-1381, 1995.
<a href=\"http://dx.doi.org/10.1063/1.555963\">DOI:10.1063/1.555963</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end thermalConductivity;

redeclare function extends pressure "Return the pressure"
algorithm
    p := state.p;
annotation (
  Inline=true,
  smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressure;

redeclare function extends temperature "Return the temperature"
algorithm
    T := state.T;
annotation (
  Inline=true,
  smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperature;

redeclare function extends molarMass "Return the molar mass"
algorithm
    MM := MM_const;
  annotation (
    Inline=true,
    smoothOrder=99,
    Documentation(info="<html>
<p>
This function returns the molar mass,
which is assumed to be constant.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end molarMass;

redeclare function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
algorithm
    assert(false,
      "Pressure can not be computed from temperature and density for an incompressible fluid!");
end setState_dTX;

redeclare function extends setState_phX
    "Return the thermodynamic state as function of pressure p, specific enthalpy h and composition X or Xi"
algorithm
  state := ThermodynamicState(p=p, T=reference_T + h/cp_const);
  annotation (
    Inline=true,
    smoothOrder=99,
    Documentation(info="<html>
<p>
This function returns the thermodynamic state for a given pressure,
specific enthalpy and composition.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_phX;

redeclare function extends setState_pTX
    "Return the thermodynamic state as function of p, T and composition X or Xi"
algorithm
    state := ThermodynamicState(p=p, T=T);
annotation (
  smoothOrder=99,
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the thermodynamic state for a given pressure,
temperature and composition.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_pTX;

redeclare function extends setState_psX
    "Return the thermodynamic state as function of p, s and composition X or Xi"
algorithm
  // The temperature is obtained from symbolic solving the
  // specificEntropy function for T, i.e.,
  // s := cv_const*Modelica.Math.log(state.T/reference_T)
  state := ThermodynamicState(p=p, T=reference_T * Modelica.Math.exp(s/cv_const));
  annotation (
    Inline=true,
    Documentation(info="<html>
<p>
This function returns the thermodynamic state based on pressure,
specific entropy and mass fraction.
</p>
<p>
The state is computed by symbolically solving
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity.specificEntropy\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity.specificEntropy</a>
for temperature.
  </p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_psX;

//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Equipment models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.
protected
  final constant Modelica.SIunits.SpecificHeatCapacity cv_const = cp_const
    "Specific heat capacity at constant volume";

  constant Modelica.SIunits.VelocityOfSound a_const=1484
    "Constant velocity of sound";
  constant Modelica.SIunits.MolarMass MM_const=0.018015268 "Molar mass";

replaceable function der_specificHeatCapacityCp
    "Return the derivative of the specific heat capacity at constant pressure"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state";
  input ThermodynamicState der_state "Derivative of thermodynamic state";
  output Real der_cp(unit="J/(kg.K.s)") "Derivative of specific heat capacity";
algorithm
  der_cp := 0;
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the derivative of the specific heat capacity
at constant pressure with respect to the state.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_specificHeatCapacityCp;

replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of liquid enthalpy";
algorithm
  der_h := cp_const*der_T;
annotation (
  Inline=true,
  Documentation(info=
"<html>
<p>
This function computes the temperature derivative of the enthalpy of liquid water
per unit mass.
</p>
</html>", revisions=
"<html>
<ul>
<li>
December 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_enthalpyOfLiquid;

function kinematicViscosity "Return the kinematic viscosity"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.Temperature T "Temperature";
  output Modelica.SIunits.KinematicViscosity kinVis "Kinematic viscosity";
algorithm
  kinVis := smooth(1,
  if T < 278.15 then
    -(4.63023776563e-08)*T + 1.44011135763e-05
  else
    1.0e-6*Modelica.Math.exp(
      -(7.22111000000000e-7)*T^3 + 0.000809102858950000*T^2
      - 0.312920238272193*T + 40.4003044106506));

annotation (
  Inline=true,
  smoothOrder=1,
  Documentation(info="<html>
<p>
This function computes the kinematic viscosity as a function of temperature.
</p>
<h4>Implementation</h4>
<p>
The function is based on the IDA implementation in <code>therpro.nmf</code>.
The original equation is
</p>
<pre>
kinVis :=1E-6*Modelica.Math.exp(0.577449 - 3.253945e-2*T_degC + 2.17369e-4*
      T_degC^2 - 7.22111e-7*T_degC^3);
      </pre>
<p>
This has been converted to Kelvin, which resulted in the above expression.
In addition, at 5 &deg;C the kinematic viscosity is linearly extrapolated
to avoid a large gradient at very low temperatures.
We selected the same point for the linearization as we used for the density,
as the density and the kinematic viscosity are combined in
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity.dynamicViscosity\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity.dynamicViscosity</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 11, 2016 by Michael Wetter:<br/>
Corrected wrong hyperlink in documentation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/450\">issue 450</a>.
</li>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation, based on the IDA implementation in <code>therpro.nmf</code>,
but converted from Celsius to Kelvin.
</li>
</ul>
</html>"));
end kinematicViscosity;

annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models liquid water.
</p>
<p>
The mass density is computed using a 3rd order polynomial, which yields the
density as a function of temperature as shown in the figure below. Note, however,
that computing density as a function of temperature can lead to considerably
slower computing time compared to using
<a href=\"modelica://Buildings.Media.Water\">
Buildings.Media.Water</a>
in which the density is a constant. We therefore recommend to use
<a href=\"modelica://Buildings.Media.Water\">
Buildings.Media.Water</a>
for typical building energy simulations.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Water/plotRho.png\" border=\"1\"
alt=\"Mass density as a function of temperature\"/>
</p>
<p>
For the specific heat capacities at constant pressure and at constant volume,
a constant value of <i>4184</i> J/(kg K), which corresponds to <i>20</i>&deg;C
is used.
The figure below shows the relative error of the specific heat capacity that
is introduced by this simplification.
Using a constant value for the specific heat capacity allows to compute
temperature from enthalpy without having to solve an implicit equation,
and therefore leads to faster simulation.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Water/plotCp.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>


<p>
Thermal conductivity is calculated as a function of temperature as shown in the figure below.
The correlation used to calculate the thermal conductivity is
</p>

<p align=\"center\" style=\"font-style:italic;\">
&lambda;(T) = &lambda;(298.15 K) &sdot; (-1.48445+4.12292&sdot;(T/298.15)-1.63866&sdot;(T/298.15)<sup>2</sup>),
</p>
<p>
where <i>&lambda;(298.15 K) = 0.6065</i>  W/(m &sdot; K) is the adopted standard value
of the thermal conductivity of water at <i>298.15</i> K and <i>0.1</i> MPa.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Water/plotLambda.png\" border=\"1\"
alt=\"Thermal conductivity as a function of temperature\"/>
</p>

<p>
Dynamic viscosity is calculated as the product of density and kinematic viscosity,
both temperature dependent. However, the kinematic viscosity
has its own temperature dependent correlation, implemented at
<a href=\"modelica://Buildings.Media.Specialized.Water.TemperatureDependentDensity.kinematicViscosity\">
Buildings.Media.Specialized.Water.TemperatureDependentDensity.kinematicViscosity</a>.
Results of the kinematic viscosity as a function of temperature are shown in the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Water/plotkinVis.png\" border=\"1\"
alt=\"Kinematic viscosity as a function of temperature\"/>
</p>

<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Phase changes are not modeled.
</p>
</html>", revisions="<html>
<ul>
<li>
July 7, 2016, by Carles Ribas Tugores:<br/>
Correct Documentation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/487\">#487</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Set <code>AbsolutePressure(start=p_default)</code>
and <code>Temperature(start=T_default)</code>
to have to have conistent start values.
See also revision notes of
<a href=\"modelica://Buildings.Media.Water\">
Buildings.Media.Water</a>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
May 1, 2015, by Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
<li>
February 25, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect</code> attribute on pressure as this caused
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>
to fail with the error message
\"differentiated if-then-else was not continuous\".
</li>
<li>
February 3, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect.prefer</code> for temperature.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/160\">#160</a>.
</li>
<li>
October 15, 2014, by Michael Wetter:<br/>
Renamed from <code>Buildings.Media.Water</code> to
<code>Buildings.Media.Water.Detailed</code> to allow addition of
<code>Buildings.Media.Water.Simple</code>.
</li>
<li>
September 12, 2014, by Michael Wetter:<br/>
Set <code>T(start=T_default)</code> and <code>p(start=p_default)</code> in the
<code>ThermodynamicState</code> record. Setting the start value for
<code>T</code> is required to avoid an error due to conflicting start values
when checking <a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
Buildings.Examples.VAVReheat.ClosedLoop</a> in pedantic mode.
</li>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
        graphics={
        Polygon(
          points={{16,-28},{32,-42},{26,-48},{10,-36},{16,-28}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Polygon(
          points={{10,34},{26,44},{30,36},{14,26},{10,34}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{-82,52},{24,-54}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Ellipse(
          extent={{22,82},{80,24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Ellipse(
          extent={{20,-30},{78,-88}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={95,95,95}),
        Text(
          extent={{-64,88},{-42,58}},
          lineColor={255,0,0},
          textString="T")}));
end TemperatureDependentDensity;
