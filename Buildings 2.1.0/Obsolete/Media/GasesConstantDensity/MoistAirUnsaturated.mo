within Buildings.Obsolete.Media.GasesConstantDensity;
package MoistAirUnsaturated
  "Package with moist air model that decouples pressure and temperature and that has no liquid water"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="MoistAirPTDecoupledUnsaturated",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=true,
     reference_X={0.01,0.99},
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2});

  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";
  constant Buildings.Obsolete.Media.PerfectGases.Common.DataRecord dryair=
        Buildings.Obsolete.Media.PerfectGases.Common.SingleGasData.Air;
  constant Buildings.Obsolete.Media.PerfectGases.Common.DataRecord steam=
        Buildings.Obsolete.Media.PerfectGases.Common.SingleGasData.H2O;
  import SI = Modelica.SIunits;

  constant AbsolutePressure pStp = 101325 "Pressure for which dStp is defined";
  constant Density dStp = 1.2 "Fluid density at pressure pStp";

  redeclare record extends ThermodynamicState(
    p(start=p_default),
    T(start=T_default),
    X(start=X_default)) "ThermodynamicState record for moist air"
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    final standardOrderComponents=true)

    /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence.
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */

  protected
    constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM}
      "Molar masses of components";

  equation
    assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="
               + String(T) + " K) <= 423.15 K
required from medium model \""     + mediumName + "\".");
    /*
    assert(Xi[Water] <= X_sat, "The medium model '" + mediumName + "' must not be saturated.\n"
     + "To model a saturated medium, use 'Buildings.Obsolete.Media.GasesConstantDensity.MoistAir' instead of this medium.\n"
     + " T         = " + String(T) + "\n"
     + " X_sat     = " + String(X_sat) + "\n"
     + " Xi[Water] = " + String(Xi[Water]) + "\n"
     + " phi       = " + String(phi) + "\n"
     + " p         = " + String(p));
 */
    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    h = specificEnthalpy_pTX(p,T,Xi);
    R = dryair.R*(1 - Xi[Water]) + steam.R*Xi[Water];

    // Equation for ideal gas, from h=u+p*v and R*T=p*v, from which follows that  u = h-R*T.
    // u = h-R*T;

    // However, in this medium, the gas law is d=dStp (=constant), from which follows using h=u+pv that
    // u= h-p*v = h-p/d = h-p/dStp
    u = h-p/dStp;

    d = dStp;// = p/pStp;
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;
  end BaseProperties;

  function Xsaturation = Buildings.Obsolete.Media.PerfectGases.MoistAir.Xsaturation
    "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";

  redeclare function setState_pTX
    "Thermodynamic state as function of p, T and composition X"
      extends Buildings.Obsolete.Media.PerfectGases.MoistAir.setState_pTX;
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
         ThermodynamicState(p=p,T=T_phX(p,h,X),X=X) else
        ThermodynamicState(p=p,T=T_phX(p,h,cat(1,X,{1-sum(X)})), X=cat(1,X,{1-sum(X)}));
    //    ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
    annotation (Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
This function needed to be reimplemented in order for the medium model to use
the implementation of <code>T_phX</code> provided by this package as opposed to the
implementation provided by its parent package.
</html>"));
  end setState_phX;

  redeclare function setState_dTX
    "Thermodynamic state as function of d, T and composition X"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "Thermodynamic state";
  algorithm
   ModelicaError("The function 'setState_dTX' must not be used in GasesConstantDensity as
                in this medium model, the pressure cannot be determined from the density.\n");
    state :=setState_pTX(pStp, T, X);
  end setState_dTX;

  redeclare function gasConstant
    "Gas constant (computation neglects liquid fraction)"
     extends Buildings.Obsolete.Media.PerfectGases.MoistAir.gasConstant;
  end gasConstant;

    function saturationPressureLiquid =
      Buildings.Obsolete.Media.PerfectGases.MoistAir.saturationPressureLiquid
    "Saturation curve valid for 273.16 <= T <= 373.16. Outside of these limits a (less accurate) result is returned"
    annotation(smoothOrder=5,derivative=saturationPressureLiquid_der);

  function saturationPressureLiquid_der =
      Buildings.Obsolete.Media.PerfectGases.MoistAir.saturationPressureLiquid_der
    "Saturation curve valid for 273.16 <= T <= 373.16. Outside of these limits a (less accurate) result is returned"
    annotation (Documentation(info="<html>
This function declares the first derivative of
<a href=\"modelica://Buildings.Obsolete.Media.GasesConstantDensity.MoistAir.saturationPressureLiquid\">
Buildings.Obsolete.Media.GasesConstantDensity.MoistAir.saturationPressureLiquid</a>.
It is required since otherwise, Dymola 7.3 cannot find the derivative of the inherited function
<code>saturationPressureLiquid</code>.
</html>"));

  function sublimationPressureIce =
      Buildings.Obsolete.Media.PerfectGases.MoistAir.sublimationPressureIce
    "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned";

redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

algorithm
  psat := Buildings.Utilities.Math.Functions.spliceFunction(
                                                  saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
  annotation(Inline=false,smoothOrder=5);
end saturationPressure;

 redeclare function pressure "Gas pressure"
    extends Buildings.Obsolete.Media.PerfectGases.MoistAir.pressure;
 end pressure;

 redeclare function temperature "Gas temperature"
    extends Buildings.Obsolete.Media.PerfectGases.MoistAir.temperature;
 end temperature;

 redeclare function density "Gas density"
   extends Modelica.Icons.Function;
   input ThermodynamicState state;
   output Density d "Density";
 algorithm
  d := dStp;
 end density;

 redeclare function specificEntropy
    "Specific entropy (liquid part neglected, mixing entropy included)"
    extends Buildings.Obsolete.Media.PerfectGases.MoistAir.specificEntropy;
 end specificEntropy;

 redeclare function extends enthalpyOfVaporization
    "Enthalpy of vaporization of water"
 algorithm
  r0 := 2501014.5;
 end enthalpyOfVaporization;

  function HeatCapacityOfWater
    "Specific heat capacity of water (liquid only) which is constant"
    extends Modelica.Icons.Function;
    input Temperature T;
    output SpecificHeatCapacity cp_fl;
  algorithm
    cp_fl := 4186;
  end HeatCapacityOfWater;

redeclare replaceable function extends enthalpyOfLiquid
    "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"

algorithm
  h := (T - 273.15)*4186;
  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
end enthalpyOfLiquid;

replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of liquid enthalpy";
algorithm
  der_h := 4186*der_T;
end der_enthalpyOfLiquid;

redeclare function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-273.15) * steam.cp + Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.enthalpyOfVaporization(T);
  annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
end enthalpyOfCondensingGas;

replaceable function der_enthalpyOfCondensingGas
    "Derivative of enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := steam.cp*der_T;
end der_enthalpyOfCondensingGas;

redeclare replaceable function extends enthalpyOfGas
    "Enthalpy of gas mixture per unit mass of gas mixture"
algorithm
  h := Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.enthalpyOfCondensingGas(T)*X[Water]
       + Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;

replaceable function enthalpyOfDryAir
    "Enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm
  h := (T - 273.15)*dryair.cp;
  annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
end enthalpyOfDryAir;

replaceable function der_enthalpyOfDryAir
    "Derivative of enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of dry air enthalpy";
algorithm
  der_h := dryair.cp*der_T;
end der_enthalpyOfDryAir;

redeclare function specificHeatCapacityCp =
      Buildings.Obsolete.Media.PerfectGases.MoistAir.specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure";

redeclare function specificHeatCapacityCv =
    Buildings.Obsolete.Media.PerfectGases.MoistAir.specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume";

redeclare function extends dynamicViscosity "dynamic viscosity of dry air"
algorithm
  eta := 1.85E-5;
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity of dry air as a polynomial in the temperature"
    import Modelica.Media.Incompressible.TableBased.Polynomials_Temp;
algorithm
  lambda := Polynomials_Temp.evaluate({(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
   Modelica.SIunits.Conversions.to_degC(state.T));
end thermalConductivity;

redeclare function extends specificEnthalpy "Specific enthalpy"
algorithm
  h := Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.h_pTX(state.p, state.T, state.X);
end specificEnthalpy;

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X) - state.p/dStp;
end specificInternalEnergy;

redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
  extends Modelica.Icons.Function;
algorithm
  g := Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
end specificGibbsEnergy;

redeclare function extends specificHelmholtzEnergy "Specific Helmholtz energy"
  extends Modelica.Icons.Function;
algorithm
  f := Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.h_pTX(state.p,state.T,state.X)
         - gasConstant(state)*state.T
         - state.T*Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.specificEntropy(state);
end specificHelmholtzEnergy;

////////////////////////////////////////////////////////////////////////////
function h_pTX
    "Compute specific enthalpy from pressure, temperature and mass fraction"
  extends Modelica.Icons.Function;

  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[nX] "Mass fractions of moist air";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
algorithm
 h := (T - 273.15)*dryair.cp * (1 - X[Water]) + ((T-273.15) * steam.cp + 2501014.5) * X[Water];

  annotation(smoothOrder=5);
end h_pTX;

function T_phX "Compute temperature from specific enthalpy and mass fraction"
  extends Modelica.Icons.Function;

  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
algorithm
  T := 273.15 + (h-2501014.5 * X[Water])/(dryair.cp * (1 - X[Water])+steam.cp*X[Water]);
  annotation(smoothOrder=5);
end T_phX;

redeclare function enthalpyOfNonCondensingGas
    "Enthalpy of non-condensing gas per unit mass"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "enthalpy";
algorithm
  h := enthalpyOfDryAir(T);
  annotation(smoothOrder=5, derivative=der_enthalpyOfNonCondensingGas);
end enthalpyOfNonCondensingGas;

replaceable function der_enthalpyOfNonCondensingGas
    "Derivative of enthalpy of non-condensing gas per unit mass"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := der_enthalpyOfDryAir(T, der_T);
end der_enthalpyOfNonCondensingGas;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This is a medium model that is identical to
<a href=\"modelica://Buildings.Obsolete.Media.GasesConstantDensity.MoistAir\">
Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</a>,  but
in this model, the air must not be saturated. If the air is saturated,
use the medium model
<a href=\"modelica://Buildings.Obsolete.Media.GasesConstantDensity.MoistAir\">
Buildings.Obsolete.Media.GasesConstantDensity.MoistAir</a> instead of this one.
</p>
<p>
This medium model has been added to allow an explicit computation of
the function
<code>T_phX</code> so that it is once differentiable in <code>h</code>
with a continuous derivative. This allows obtaining an analytic
expression for the Jacobian, and therefore simplifies the computation
of initial conditions that can be numerically challenging for
thermo-fluid systems.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations
because it allows to invert the function <code>T_phX</code> analytically.
</p>
</html>", revisions="<html>
<ul>
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
Added keyword <code>each</code> to <code>Xi(stateSelect=...</code>.
</li>
<li>
April 4, 2012, by Michael Wetter:<br/>
Added redeclaration of <code>ThermodynamicState</code> to avoid a warning
during model check and translation.
</li>
<li>
August 3, 2011, by Michael Wetter:<br/>
Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
For this medium, the function is <code>u=h-p/dStp</code>.
</li>
<li>
August 2, 2011, by Michael Wetter:<br/>
Fixed error in the function <code>density</code> which returned a non-constant density,
and added a call to <code>ModelicaError(...)</code> in <code>setState_dTX</code> since this
function cannot assign the medium pressure based on the density (as density is a constant
in this model).
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug in <code>else</code> branch of function <code>setState_phX</code>
that lead to a run-time error when the constructor of this function was called.
</li>
<li>
January 22, 2010, by Michael Wetter:<br/>
Added implementation of function
<a href=\"modelica://Buildings.Obsolete.Media.GasesConstantDensity.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
enthalpyOfNonCondensingGas</a> and its derivative.
<li>
January 13, 2010, by Michael Wetter:<br/>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAirUnsaturated;
