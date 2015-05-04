within Buildings.Obsolete.Media.PerfectGases;
package MoistAir
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="Moist air perfect gas",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2});

  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair =  steam.MM/dryair.MM "Ratio of molar weights";
  constant Buildings.Obsolete.Media.PerfectGases.Common.DataRecord dryair=
        Buildings.Obsolete.Media.PerfectGases.Common.SingleGasData.Air;
  constant Buildings.Obsolete.Media.PerfectGases.Common.DataRecord steam=
        Buildings.Obsolete.Media.PerfectGases.Common.SingleGasData.H2O;
  import SI = Modelica.SIunits;

  // Min and max values, used for Brent's algorithm in T_hpX
  constant Modelica.SIunits.Temperature TMin = 200 "Minimum temperature";
  constant Modelica.SIunits.Temperature TMax = 400 "Maximum temperature";

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

    MassFraction X_liquid "Mass fraction of liquid water";
    MassFraction X_steam "Mass fraction of steam water";
    MassFraction X_air "Mass fraction of air";
    MassFraction X_sat
      "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
    AbsolutePressure p_steam_sat "Partial saturation pressure of steam";

  equation
    assert(T >= TMin and T <= TMax, "
Temperature T is not in the allowed range " + String(TMin) + " <= (T ="
               + String(T) + " K) <= " + String(TMax) + " K
required from medium model \""     + mediumName + "\".");
    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    p_steam_sat = min(saturationPressure(T),0.999*p);
    X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
      "Water content at saturation with respect to actual water content";
    X_liquid = max(Xi[Water] - X_sat, 0.0);
    X_steam  = Xi[Water]-X_liquid;
    X_air    = 1-Xi[Water];

    h = specificEnthalpy_pTX(p,T,Xi);
    R = dryair.R*(1 - X_steam/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);
    //
    u = h - R*T;
    d = p/(R*T);
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;

  end BaseProperties;

  function Xsaturation = Modelica.Media.Air.MoistAir.Xsaturation
    "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";

  redeclare function setState_pTX
    "Thermodynamic state as function of p, T and composition X"
      extends Modelica.Media.Air.MoistAir.setState_pTX;
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
        ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
    annotation (Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
This function needed to be reimplemented in order for the medium model to use
the implementation of <code>T_phX</code> provided by this package as opposed to the
implementation provided by its parent package.
</html>"));
  end setState_phX;

  redeclare function setState_dTX
    "Thermodynamic state as function of d, T and composition X"
     extends Modelica.Media.Air.MoistAir.setState_dTX;
  end setState_dTX;

  redeclare function gasConstant
    "Gas constant (computation neglects liquid fraction)"
     extends Modelica.Media.Air.MoistAir.gasConstant;
  end gasConstant;

function saturationPressureLiquid
    "Return saturation pressure of water as a function of temperature T in the range of 273.16 to 373.16 K"

  extends Modelica.Icons.Function;
  input SI.Temperature Tsat "saturation temperature";
  output SI.AbsolutePressure psat "saturation pressure";
algorithm
  psat := 611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719));
  annotation(Inline=false,smoothOrder=5,derivative=saturationPressureLiquid_der,
    Documentation(info="<html>
Saturation pressure of water above the triple point temperature is computed from temperature. It's range of validity is between
273.16 and 373.16 K. Outside these limits a less accurate result is returned.
</html>"));
end saturationPressureLiquid;

function saturationPressureLiquid_der
    "Time derivative of saturationPressureLiquid"

  extends Modelica.Icons.Function;
  input SI.Temperature Tsat "Saturation temperature";
  input Real dTsat(unit="K/s") "Saturation temperature derivative";
  output Real psat_der(unit="Pa/s") "Saturation pressure";
algorithm
  psat_der:=611.657*Modelica.Math.exp(17.2799 - 4102.99/(Tsat - 35.719))*4102.99*dTsat/(Tsat - 35.719)/(Tsat - 35.719);

  annotation(Inline=false,smoothOrder=5,
    Documentation(info="<html>
Derivative function of <a href=modelica://Modelica.Media.Air.MoistAir.saturationPressureLiquid>saturationPressureLiquid</a>
</html>"));
end saturationPressureLiquid_der;

  function sublimationPressureIce =
      Modelica.Media.Air.MoistAir.sublimationPressureIce
    "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned"
    annotation(Inline=false,smoothOrder=5,derivative=Modelica.Media.Air.MoistAir.sublimationPressureIce_der);

redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

algorithm
  psat := Buildings.Utilities.Math.Functions.spliceFunction(
                                                  saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
  annotation(Inline=false,smoothOrder=5);
end saturationPressure;

 redeclare function pressure "Gas pressure"
    extends Modelica.Media.Air.MoistAir.pressure;
 end pressure;

 redeclare function temperature "Gas temperature"
    extends Modelica.Media.Air.MoistAir.temperature;
 end temperature;

 redeclare function density "Gas density"
    extends Modelica.Media.Air.MoistAir.density;
 end density;

 redeclare function specificEntropy
    "Specific entropy (liquid part neglected, mixing entropy included)"
    extends Modelica.Media.Air.MoistAir.specificEntropy;
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
  h := (T-273.15) * steam.cp + enthalpyOfVaporization(T);
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

redeclare function enthalpyOfNonCondensingGas
    "Enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "enthalpy";
algorithm
  h := enthalpyOfDryAir(T);
  annotation(smoothOrder=5, derivative=der_enthalpyOfNonCondensingGas);
end enthalpyOfNonCondensingGas;

replaceable function der_enthalpyOfNonCondensingGas
    "Derivative of enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Real der_T "temperature derivative";
  output Real der_h "derivative of steam enthalpy";
algorithm
  der_h := der_enthalpyOfDryAir(T, der_T);
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

redeclare replaceable function extends specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure"
algorithm
  cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
  annotation(smoothOrder=5);
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
  annotation(smoothOrder=5);
end specificHeatCapacityCv;

redeclare function extends dynamicViscosity "dynamic viscosity of dry air"
algorithm
  eta := 1.85E-5;
end dynamicViscosity;

redeclare function extends thermalConductivity
    "Thermal conductivity of dry air as a polynomial in the temperature"
algorithm
  lambda := Modelica.Media.Incompressible.TableBased.Polynomials_Temp.evaluate(
               {(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
               Modelica.SIunits.Conversions.to_degC(state.T));
end thermalConductivity;

function h_pTX
    "Compute specific enthalpy from pressure, temperature and mass fraction"
  extends Modelica.Icons.Function;
  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[:] "Mass fractions of moist air";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";

  protected
  SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
  SI.MassFraction x_sat "steam water mass fraction of saturation boundary";
  SI.MassFraction X_liquid "mass fraction of liquid water";
  SI.MassFraction X_steam "mass fraction of steam water";
  SI.MassFraction X_air "mass fraction of air";
  SI.SpecificEnthalpy hDryAir "Enthalpy of dry air";
algorithm
  p_steam_sat :=saturationPressure(T);
  x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
  X_liquid :=max(X[Water] - x_sat/(1 + x_sat), 0.0);
  X_steam  :=X[Water] - X_liquid;
  X_air    :=1 - X[Water];

/* THIS DOES NOT WORK --------------------------
  h := enthalpyOfDryAir(T) * X_air +
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
--------------------------------- */

/* THIS WORKS!!!! +++++++++++++++++++++
  h := (T - 273.15)*dryair.cp * X_air +
       Modelica.Media.Air.MoistAir.enthalpyOfCondensingGas(T) * X_steam + enthalpyOfLiquid(T)*X_liquid;
 +++++++++++++++++++++*/

  hDryAir := (T - 273.15)*dryair.cp;
  h := hDryAir * X_air +
       ((T-273.15) * steam.cp + 2501014.5) * X_steam +
       (T - 273.15)*4186*X_liquid;
  annotation(Inline=false,smoothOrder=1);
end h_pTX;

redeclare function extends specificEnthalpy "Specific enthalpy"
algorithm
  h := h_pTX(state.p, state.T, state.X);
end specificEnthalpy;

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T;
end specificInternalEnergy;

redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
  extends Modelica.Icons.Function;
algorithm
  g := h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
end specificGibbsEnergy;

redeclare function extends specificHelmholtzEnergy "Specific Helmholtz energy"
  extends Modelica.Icons.Function;
algorithm
  f := h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T - state.T*specificEntropy(state);
end specificHelmholtzEnergy;

function T_phX "Compute temperature from specific enthalpy and mass fraction"
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction X[:] "Mass fractions of composition";
  output Temperature T "Temperature";

  protected
package Internal
      "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)"
  extends Modelica.Media.Common.OneNonLinearEquation;

  redeclare record extends f_nonlinear_Data
        "Data to be passed to non-linear function"
    extends Modelica.Media.IdealGases.Common.DataRecord;
  end f_nonlinear_Data;

  redeclare function extends f_nonlinear
  algorithm
      y := h_pTX(p,x,X);
  end f_nonlinear;

  // Dummy definition has to be added for current Dymola
  redeclare function extends solve
  end solve;
end Internal;
  protected
constant Modelica.Media.IdealGases.Common.DataRecord steam=
              Modelica.Media.IdealGases.Common.SingleGasesData.H2O;
  protected
 SI.AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
 SI.MassFraction x_sat "steam water mass fraction of saturation boundary";

algorithm
  T := 273.15 + (h - 2501014.5 * X[Water])/((1 - X[Water])*dryair.cp + X[Water] *
     Buildings.Obsolete.Media.PerfectGases.Common.SingleGasData.H2O.cp);
  // check for saturation
  p_steam_sat :=saturationPressure(T);
  x_sat    :=k_mair*p_steam_sat/(p - p_steam_sat);
  // If the state is in the fog region, then the above equation is not valid, and
  // T is computed by inverting h_pTX(), which is much more costly.
  // For Buildings.Fluid.HeatExchangers.Examples.WetEffectivenessNTUPControl, the
  // computation above reduces the computing time by about a factor of 2.
  if (X[Water] > x_sat/(1 + x_sat)) then
     T := Internal.solve(h, TMin, TMax, p, X[1:nXi], steam);
  end if;
    annotation (Documentation(info="<html>
Temperature is computed from pressure, specific enthalpy and composition via numerical inversion of function <a href=modelica://Modelica.Media.Air.MoistAir.h_pTX>h_pTX</a>.
</html>"));
end T_phX;

  annotation (preferredView="info", Documentation(info="<html>
<p>
This is a medium model that is similar to
<a href=\"modelica://Modelica.Media.Air.MoistAir\">
Modelica.Media.Air.MoistAir</a> but it is a perfect gas, i.e.,
it has a constant specific heat capacity.
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
February 22, 2010, by Michael Wetter:<br/>
Changed <code>T_phX</code> to first compute <code>T</code>
in closed form assuming no saturation. Then, a check is done to determine
whether the state is in the fog region. If the state is in the fog region,
then <code>Internal.solve</code> is called. This new implementation
can lead to significantly shorter computing
time in models that frequently call <code>T_phX</code>.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug that lead to run-time error in <code>T_phX</code>.
</li>
<li>
January 13, 2010, by Michael Wetter:<br/>
Added function <code>enthalpyOfNonCondensingGas</code> and its derivative.
</li>
<li>
January 13, 2010, by Michael Wetter:<br/>
Fixed implementation of derivative functions.
</li>
<li>
October 12, 2009, by Michael Wetter:<br/>
Added annotation for analytic derivative for functions
<code>saturationPressureLiquid</code> and <code>sublimationPressureIce</code>.
<li>
August 28, 2008, by Michael Wetter:<br/>
Referenced <code>spliceFunction</code> from package
<a href=\"modelica://Buildings.Utilities.Math\">Buildings.Utilities.Math</a>
to avoid duplicate code.
</li>
<li>
May 8, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MoistAir;
