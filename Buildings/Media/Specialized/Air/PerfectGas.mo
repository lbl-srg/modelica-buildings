within Buildings.Media.Specialized.Air;
package PerfectGas "Model for air as a perfect gas"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="Moist air unsaturated perfect gas",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     reference_T=273.15,
     reference_p=101325,
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2},
     AbsolutePressure(start=p_default),
     Temperature(start=T_default));

  extends Modelica.Icons.Package;

  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";

  redeclare record extends ThermodynamicState(
    p(start=p_default),
    T(start=T_default),
    X(start=X_default)) "ThermodynamicState record for moist air"
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(
      nominal={0.01},
      each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    final standardOrderComponents=true

    /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence.
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */)
  protected
    constant Modelica.Units.SI.MolarMass[2] MMX={steam.MM,dryair.MM}
      "Molar masses of components";

    MassFraction X_steam "Mass fraction of steam water";
    MassFraction X_air "Mass fraction of air";
  equation
    assert(T >= 200.0, "
In "   + getInstanceName() + ": Temperature T exceeded its minimum allowed value of -73.15 degC (200 Kelvin)
as required from medium model \"" + mediumName + "\".");
    assert(T <= 423.15, "
In "   + getInstanceName() + ": Temperature T exceeded its maximum allowed value of 150 degC (423.15 Kelvin)
as required from medium model \"" + mediumName + "\".");

    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    X_steam  = Xi[Water];
    X_air    = 1-Xi[Water];

    h = (T - reference_T)*dryair.cp * (1 - Xi[Water]) +
        ((T-reference_T) * steam.cp + h_fg) * Xi[Water];

    R_s = dryair.R*(1 - X_steam) + steam.R*X_steam;
    //
    u =h - R_s*T;
    d =p/(R_s*T);
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is negligible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;
  end BaseProperties;

  function Xsaturation = Modelica.Media.Air.MoistAir.Xsaturation
    "Steam water mass fraction of saturation boundary in kg_water/kg_moistair"
  annotation (
    Inline=true);
  redeclare function setState_pTX
    "Thermodynamic state as function of p, T and composition X"
      extends Modelica.Media.Air.MoistAir.setState_pTX;
  annotation (
    Inline=true);
  end setState_pTX;

  redeclare function setState_phX
    "Thermodynamic state as function of p, h and composition X"
  extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction X[:] "Mass fractions";
  output ThermodynamicState state;
  algorithm
  state := if size(X,1) == nX then
         ThermodynamicState(p=p,T=temperature_phX(p,h,X),X=X) else
        ThermodynamicState(p=p,T=temperature_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
    annotation (
  Inline=true,
  Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
</html>"));
  end setState_phX;

  redeclare function setState_dTX
    "Thermodynamic state as function of d, T and composition X"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input MassFraction X[:]=reference_X "Mass fractions";
  output ThermodynamicState state "Thermodynamic state";
  algorithm
  state := if size(X, 1) == nX then ThermodynamicState(
        p=d*({steam.R,dryair.R}*X)*T,
        T=T,
        X=X) else ThermodynamicState(
        p=d*({steam.R,dryair.R}*cat(
          1,
          X,
          {1 - sum(X)}))*T,
        T=T,
        X=cat(
          1,
          X,
          {1 - sum(X)}));
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
  The thermodynamic state record
  is computed from density d, temperature T and composition X.
</html>"));
  end setState_dTX;

redeclare function extends gasConstant "Gas constant"
algorithm
    R_s := dryair.R*(1 - state.X[Water]) + steam.R*state.X[Water];
  annotation (
    Inline=true);
end gasConstant;

function saturationPressureLiquid
    "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

  extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature Tsat "saturation temperature";
    output Modelica.Units.SI.AbsolutePressure psat "saturation pressure";
  // This function is declared here explicitly, instead of referencing the function in its
  // base class, since otherwise Dymola 7.3 does not find the derivative for the model
  // Buildings.Fluid.Sensors.Examples.MassFraction
algorithm
  psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=Buildings.Media.Specialized.Air.PerfectGas.saturationPressureLiquid_der,
    Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
end saturationPressureLiquid;

function saturationPressureLiquid_der
    "Time derivative of saturationPressureLiquid"

  extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature Tsat "Saturation temperature";
  input Real dTsat(unit="K/s") "Saturation temperature derivative";
  output Real psat_der(unit="Pa/s") "Saturation pressure";

algorithm
  psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

  annotation (
    smoothOrder=5,
    Inline=true,
Documentation(info="<html>
Derivative function of
<a href=\"modelica://Buildings.Media.Specialized.Air.PerfectGas.saturationPressureLiquid\">
Buildings.Media.Specialized.Air.PerfectGas.saturationPressureLiquid</a>
</html>"));
end saturationPressureLiquid_der;

  function sublimationPressureIce =
      Modelica.Media.Air.MoistAir.sublimationPressureIce
    "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned"
  annotation (
    Inline=true);
  function sublimationPressureIce_der =
      Modelica.Media.Air.MoistAir.sublimationPressureIce_der
    "Derivative function for 'sublimationPressureIce'"
  annotation (
    Inline=true);
redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

algorithm
  psat := Buildings.Utilities.Math.Functions.regStep(
            y1=saturationPressureLiquid(Tsat),
            y2=sublimationPressureIce(Tsat),
            x=Tsat-273.16,
            x_small=1.0);
  annotation (
    Inline=true,
    smoothOrder=5);
end saturationPressure;

 redeclare function extends pressure "Gas pressure"
 algorithm
  p := state.p;
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</html>"));
 end pressure;

 redeclare function extends temperature "Gas temperature"
 algorithm
  T := state.T;
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</html>"));
 end temperature;

 redeclare function extends density "Gas density"
 algorithm
  d := state.p/(gasConstant(state)*state.T);
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
Density is computed from pressure, temperature and composition in the thermodynamic state record applying the ideal gas law.
</html>"));
 end density;

 redeclare function extends specificEntropy
    "Specific entropy (liquid part neglected, mixing entropy included)"
 algorithm
  s := s_pTX(
        state.p,
        state.T,
        state.X);
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
Specific entropy is calculated from the thermodynamic state record, assuming ideal gas behavior and including entropy of mixing. Liquid or solid water is not taken into account, the entire water content X[1] is assumed to be in the vapor state (relative humidity below 1.0).
</html>"));
 end specificEntropy;

 redeclare function extends enthalpyOfVaporization
    "Enthalpy of vaporization of water"
 algorithm
  r0 := h_fg;
  annotation (
    Inline=true);
 end enthalpyOfVaporization;

function HeatCapacityOfWater
    "Specific heat capacity of water (liquid only) which is constant"
    extends Modelica.Icons.Function;
    input Temperature T;
    output SpecificHeatCapacity cp_fl;
algorithm
    cp_fl := cpWatLiq;
  annotation (
    Inline=true);
end HeatCapacityOfWater;

redeclare replaceable function extends enthalpyOfLiquid
    "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"

algorithm
  h := (T - reference_T)*cpWatLiq;
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfLiquid);
end enthalpyOfLiquid;

replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of liquid enthalpy";
algorithm
  der_h := cpWatLiq*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfLiquid;

redeclare function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-reference_T) * steam.cp + enthalpyOfVaporization(T);
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfCondensingGas);
end enthalpyOfCondensingGas;

replaceable function der_enthalpyOfCondensingGas
    "Derivative of enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := steam.cp*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfCondensingGas;

redeclare function enthalpyOfNonCondensingGas
    "Enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "enthalpy";
algorithm
  h := enthalpyOfDryAir(T);
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfNonCondensingGas);
end enthalpyOfNonCondensingGas;

replaceable function der_enthalpyOfNonCondensingGas
    "Derivative of enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := der_enthalpyOfDryAir(T, der_T);
  annotation (
    Inline=true);
end der_enthalpyOfNonCondensingGas;

redeclare replaceable function extends enthalpyOfGas
    "Enthalpy of gas mixture per unit mass of gas mixture"
algorithm
  h := enthalpyOfCondensingGas(T)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;

replaceable function enthalpyOfDryAir
    "Enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm
  h := (T - reference_T)*dryair.cp;
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfDryAir);
end enthalpyOfDryAir;

replaceable function der_enthalpyOfDryAir
    "Derivative of enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of dry air enthalpy";
algorithm
  der_h := dryair.cp*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfDryAir;

redeclare replaceable function extends specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure"
algorithm
  cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
    annotation(derivative=der_specificHeatCapacityCp);
end specificHeatCapacityCp;

replaceable function der_specificHeatCapacityCp
    "Derivative of specific heat capacity of gas mixture at constant pressure"
    input ThermodynamicState state;
    input ThermodynamicState der_state;
    output Real der_cp(unit="J/(kg.K.s)");
algorithm
  der_cp := (steam.cp-dryair.cp)*der_state.X[Water];
  annotation (
    Inline=true);
end der_specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
  annotation (
    Inline=true,
    derivative=der_specificHeatCapacityCv);
end specificHeatCapacityCv;

replaceable function der_specificHeatCapacityCv
    "Derivative of specific heat capacity of gas mixture at constant volume"
    input ThermodynamicState state;
    input ThermodynamicState der_state;
    output Real der_cv(unit="J/(kg.K.s)");
algorithm
  der_cv := (steam.cv-dryair.cv)*der_state.X[Water];
  annotation (
    Inline=true);
end der_specificHeatCapacityCv;

redeclare function extends dynamicViscosity "dynamic viscosity of dry air"
algorithm
  eta := 1.85E-5;
  annotation (
    Inline=true);
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity of dry air as a polynomial in the temperature"
algorithm
  lambda :=Modelica.Math.Polynomials.evaluate({(-4.8737307422969E-008),
      7.67803133753502E-005,0.0241814385504202},
      Modelica.Units.Conversions.to_degC(state.T));
  annotation (
    Inline=true);
end thermalConductivity;

redeclare function extends specificEnthalpy "Specific enthalpy"
algorithm
  h := specificEnthalpy_pTX(state.p, state.T, state.X);
  annotation (
    Inline=true);
end specificEnthalpy;

redeclare replaceable function specificEnthalpy_pTX "Specific enthalpy"
  extends Modelica.Icons.Function;
    input Modelica.Units.SI.Pressure p "Pressure";
    input Modelica.Units.SI.Temperature T "Temperature";
    input Modelica.Units.SI.MassFraction X[:] "Mass fractions of moist air";
    output Modelica.Units.SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";

  protected
    Modelica.Units.SI.SpecificEnthalpy hDryAir "Enthalpy of dry air";
algorithm
  hDryAir := (T - reference_T)*dryair.cp;
  h := hDryAir * (1 - X[Water]) +
       ((T-reference_T) * steam.cp + h_fg) * X[Water];
  annotation(smoothOrder=5,
             Inline=true,
             inverse(T=temperature_phX(p, h, X)));
end specificEnthalpy_pTX;

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := specificEnthalpy_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T;
  annotation (
    Inline=true);
end specificInternalEnergy;

redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
  extends Modelica.Icons.Function;
algorithm
  g := specificEnthalpy_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
  annotation (
    Inline=true);
end specificGibbsEnergy;

redeclare function extends specificHelmholtzEnergy "Specific Helmholtz energy"
  extends Modelica.Icons.Function;
algorithm
  f := specificEnthalpy_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T - state.T*specificEntropy(state);
  annotation (
    Inline=true);
end specificHelmholtzEnergy;

redeclare replaceable function temperature_phX
    "Compute temperature from specific enthalpy and mass fraction"
    extends Modelica.Icons.Function;
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
algorithm
  T := reference_T + (h - h_fg * X[Water])
       /((1 - X[Water])*dryair.cp + X[Water] * steam.cp);
  annotation(smoothOrder=5,
             Inline=true,
             inverse(h=specificEnthalpy_pTX(p, T, X)),
             Documentation(info="<html>
Temperature as a function of specific enthalpy and species concentration.
The pressure is input for compatibility with the medium models, but the temperature
is independent of the pressure.
</html>"));
end temperature_phX;
//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Equipment models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.
protected
  record GasProperties
    "Coefficient data record for properties of perfect gases"
    extends Modelica.Icons.Record;

    Modelica.Units.SI.MolarMass MM "Molar mass";
    Modelica.Units.SI.SpecificHeatCapacity R "Gas constant";
    Modelica.Units.SI.SpecificHeatCapacity cp
      "Specific heat capacity at constant pressure";
    Modelica.Units.SI.SpecificHeatCapacity cv=cp - R
      "Specific heat capacity at constant volume";
    annotation (
      preferredView="info",
      Documentation(info="<html>
<p>
This data record contains the coefficients for perfect gases.
</p>
</html>", revisions="<html>
<ul>
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
September 12, 2014, by Michael Wetter:<br/>
Corrected the wrong location of the <code>preferredView</code>
and the <code>revisions</code> annotation.
</li>
<li>
November 21, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end GasProperties;
  // In the assignments below, we compute cv as OpenModelica
  // cannot evaluate cv=cp-R as defined in GasProperties.
  constant GasProperties dryair(
    R=Modelica.Media.IdealGases.Common.SingleGasesData.Air.R_s,
    MM=Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM,
    cp=Buildings.Utilities.Psychrometrics.Constants.cpAir,
    cv=Buildings.Utilities.Psychrometrics.Constants.cpAir - Modelica.Media.IdealGases.Common.SingleGasesData.Air.R_s)
    "Dry air properties";
  constant GasProperties steam(
    R=Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R_s,
    MM=Modelica.Media.IdealGases.Common.SingleGasesData.H2O.MM,
    cp=Buildings.Utilities.Psychrometrics.Constants.cpSte,
    cv=Buildings.Utilities.Psychrometrics.Constants.cpSte - Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R_s)
    "Steam properties";

  constant Real k_mair =  steam.MM/dryair.MM "Ratio of molar weights";

  constant Modelica.Units.SI.SpecificEnergy h_fg=Buildings.Utilities.Psychrometrics.Constants.h_fg
    "Latent heat of evaporation of water";

  constant Modelica.Units.SI.SpecificHeatCapacity cpWatLiq=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of liquid water";

  function s_pTX = Modelica.Media.Air.MoistAir.s_pTX
    "Return specific entropy of moist air as a function of pressure p, temperature T and composition X (only valid for phi<1)";
  function s_pTX_der = Modelica.Media.Air.MoistAir.s_pTX_der
    "Return specific entropy of moist air as a function of pressure p, temperature T and composition X (only valid for phi<1)";
  annotation(preferredView="info", Documentation(info="<html>
<p>
This package contains a <i>thermally perfect</i> model of moist air.
</p>
<p>
A medium is called thermally perfect if
</p>
<ul>
<li>
it is in thermodynamic equilibrium,
</li><li>
it is chemically not reacting, and
</li><li>
internal energy and enthalpy are functions of temperature only.
</li>
</ul>
<p>
In addition, this medium model is <i>calorically perfect</i>, i.e., the
specific heat capacities at constant pressure <i>c<sub>p</sub></i>
and constant volume <i>c<sub>v</sub></i> are both constant (Bower 1998).
</p>
<p>
This medium uses the ideal gas law
</p>
<p align=\"center\" style=\"font-style:italic;\">
&rho; = p &frasl;(R T),
</p>
<p>
where
<i>&rho;</i> is the density,
<i>p</i> is the pressure,
<i>R</i> is the gas constant and
<i>T</i> is the temperature.
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C and no water vapor is present.
</p>
<p>
Note that for typical building simulations, the media
<a href=\"modelica://Buildings.Media.Air\">Buildings.Media.Air</a>
should be used as it leads generally to faster simulation.
</p>
<h4>References</h4>
<p>
Bower, William B. <i>A primer in fluid mechanics: Dynamics of flows in one
space dimension</i>. CRC Press. 1998.
</p>
</html>", revisions="<html>
<ul>
<li>
September 9, 2022, by Michael Wetter:<br/>
Set nominal attribute for <code>BaseProperties.Xi</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1634\">#1634</a>.
</li>
<li>
October 26, 2018, by Filip Jorissen and Michael Wetter:<br/>
Now printing different messages if temperature is above or below its limit,
and adding instance name as JModelica does not print the full instance name in the assertion.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">#1045</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
November 13, 2014, by Michael Wetter:<br/>
Removed <code>phi</code> and removed non-required computations.
</li>
<li>
March 29, 2013, by Michael Wetter:<br/>
Added <code>final standardOrderComponents=true</code> in the
<code>BaseProperties</code> declaration. This avoids an error
when models are checked in Dymola 2014 in the pedenatic mode.
</li>
<li>
April 12, 2012, by Michael Wetter:<br/>
Added keyword <code>each</code> to <code>Xi(stateSelect=...)</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br/>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Added function <code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug with temperature offset in <code>T_phX</code>.
</li>
<li>
August 18, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(
          extent={{-78,78},{-34,34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-18,86},{26,42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{48,58},{92,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-22,32},{22,-12}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{36,-32},{80,-76}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-36,-30},{8,-74}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120}),
        Ellipse(
          extent={{-90,-6},{-46,-50}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={120,120,120})}));
end PerfectGas;
