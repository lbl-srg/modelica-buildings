within Buildings.Media.GasesPTDecoupled;
package MoistAirNoLiquid
  "Package with moist air model that decouples pressure and temperature and that has no liquid water"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="MoistAirPTDecoupledNoLiquid",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2});

  annotation (preferedView="info", Documentation(info="<HTML>
<p>
This is a medium model that is identical to 
<a href=\"Modelica:Buildings.Media.GasesPTDecoupled.MoistAir\">
Buildings.Media.GasesPTDecoupled.MoistAir</a>, except that
the water vapor is <b>not</b> condensing to the liquid phase if
<tt>Xi[Water] > X_sat</tt>. Instead, all water is assumed in vapor phase.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because it allows to invert the function <tt>T_phX</tt> analytically.
</p>
</HTML>", revisions="<html>
<ul>
<li>
January 13, 2010, by Michael Wetter:<br>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";
  constant Real k_mair =  steam.MM/dryair.MM "ratio of molar weights";
  constant Buildings.Media.PerfectGases.Common.DataRecord dryair=
        Buildings.Media.PerfectGases.Common.SingleGasData.Air;
  constant Buildings.Media.PerfectGases.Common.DataRecord steam=
        Buildings.Media.PerfectGases.Common.SingleGasData.H2O;
  import SI = Modelica.SIunits;

  redeclare replaceable model extends BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))

    /* p, T, X = X[Water] are used as preferred states, since only then all
     other quantities can be computed in a recursive sequence. 
     If other variables are selected as states, static state selection
     is no longer possible and non-linear algebraic equations occur.
      */
    MassFraction x_water "Mass of total water/mass of dry air";
    Real phi "Relative humidity";
    annotation(structurallyIncomplete);

  protected
    constant SI.MolarMass[2] MMX = {steam.MM,dryair.MM}
      "Molar masses of components";

    //    MassFraction X_liquid "Mass fraction of liquid water";
    //    MassFraction X_steam "Mass fraction of steam water";
    MassFraction X_air "Mass fraction of air";
    MassFraction X_sat
      "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";
    MassFraction x_sat
      "Steam water mass content of saturation boundary in kg_water/kg_dryair";
    AbsolutePressure p_steam_sat "Partial saturation pressure of steam";
   constant AbsolutePressure pStp = 101325 "Pressure for which dStp is defined";
   constant Density dStp = 1.2 "Fluid density at pressure pStp";
  equation
    assert(T >= 200.0 and T <= 423.15, "
Temperature T is not in the allowed range
200.0 K <= (T ="
               + String(T) + " K) <= 423.15 K
required from medium model \""     + mediumName + "\".");
    MM = 1/(Xi[Water]/MMX[Water]+(1.0-Xi[Water])/MMX[Air]);

    p_steam_sat = min(saturationPressure(T),0.999*p);
    X_sat = min(p_steam_sat * k_mair/max(100*Modelica.Constants.eps, p - p_steam_sat)*(1 - Xi[Water]), 1.0)
      "Water content at saturation with respect to actual water content";
    //    X_liquid = max(Xi[Water] - X_sat, 0.0);
    //    X_steam  = Xi[Water]-X_liquid;
    X_air    = 1-Xi[Water];

    h = specificEnthalpy_pTX(p,T,Xi);
    R = dryair.R*(1 - Xi[Water]) + steam.R*Xi[Water];
    //
    u = h - R*T;
    //    d = p/(R*T);
    d/dStp = p/pStp;
    /* Note, u and d are computed under the assumption that the volume of the liquid
         water is neglible with respect to the volume of air and of steam
      */
    state.p = p;
    state.T = T;
    state.X = X;

    // this x_steam is water load / dry air!!!!!!!!!!!
    x_sat    = k_mair*p_steam_sat/max(100*Modelica.Constants.eps,p - p_steam_sat);
    x_water = Xi[Water]/max(X_air,100*Modelica.Constants.eps);
    phi = p/p_steam_sat*Xi[Water]/(Xi[Water] + k_mair*X_air);
  end BaseProperties;

  function Xsaturation = Buildings.Media.PerfectGases.MoistAir.Xsaturation
    "Steam water mass fraction of saturation boundary in kg_water/kg_moistair";

  redeclare function setState_pTX
    "Thermodynamic state as function of p, T and composition X"
      extends Buildings.Media.PerfectGases.MoistAir.setState_pTX;
  end setState_pTX;

  redeclare function setState_phX
    "Thermodynamic state as function of p, h and composition X"
  extends Modelica.Icons.Function;
    annotation (Documentation(info="<html>
Function to set the state for given pressure, enthalpy and species concentration.
This function needed to be reimplemented in order for the medium model to use
the implementation of <tt>T_phX</tt> provided by this package as opposed to the 
implementation provided by its parent package.
</html>"));
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "Specific enthalpy";
  input MassFraction X[:] "Mass fractions";
  output ThermodynamicState state;
  algorithm
  state := if size(X,1) == nX then ThermodynamicState(p=p,T=T_phX(p,h,X),X=X) else 
         ThermodynamicState(p=p,T=T_phX(p,h,X), X=cat(1,X,{1-sum(X)}));
  end setState_phX;

  redeclare function setState_dTX
    "Thermodynamic state as function of d, T and composition X"
     extends Buildings.Media.PerfectGases.MoistAir.setState_dTX;
  end setState_dTX;

  redeclare function gasConstant
    "Gas constant (computation neglects liquid fraction)"
     extends Buildings.Media.PerfectGases.MoistAir.gasConstant;
  end gasConstant;

  function saturationPressureLiquid = 
      Buildings.Media.PerfectGases.MoistAir.saturationPressureLiquid
    "Saturation curve valid for 273.16 <= T <= 373.16. Outside of these limits a (less accurate) result is returned";

  function sublimationPressureIce = 
      Buildings.Media.PerfectGases.MoistAir.sublimationPressureIce
    "Saturation curve valid for 223.16 <= T <= 273.16. Outside of these limits a (less accurate) result is returned";

redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

  annotation(Inline=false,smoothOrder=5);
algorithm
  psat := Buildings.Utilities.Math.Functions.spliceFunction(
                                                  saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
end saturationPressure;

 redeclare function pressure "Gas pressure"
    extends Buildings.Media.PerfectGases.MoistAir.pressure;
 end pressure;

 redeclare function temperature "Gas temperature"
    extends Buildings.Media.PerfectGases.MoistAir.temperature;
 end temperature;

 redeclare function density "Gas density"
   extends Modelica.Icons.Function;
   input ThermodynamicState state;
   output Density d "Density";
 algorithm
  d :=state.p*1.2/101325;
 end density;

 redeclare function specificEntropy
    "Specific entropy (liquid part neglected, mixing entropy included)"
    extends Buildings.Media.PerfectGases.MoistAir.specificEntropy;
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

  annotation(smoothOrder=5, derivative=der_enthalpyOfLiquid);
algorithm
  h := (T - 273.15)*4186;
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

  annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-273.15) * steam.cp + Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.enthalpyOfVaporization(T);
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
  h := Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.enthalpyOfCondensingGas(T)*X[Water]
       + Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.enthalpyOfDryAir(T)*(1.0-X[Water]);
end enthalpyOfGas;

replaceable function enthalpyOfDryAir
    "Enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;

  annotation(smoothOrder=5, derivative=der_enthalpyOfDryAir);
  input Temperature T "temperature";
  output SpecificEnthalpy h "dry air enthalpy";
algorithm
  h := (T - 273.15)*dryair.cp;
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
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
end specificHeatCapacityCv;

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
  h := Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.h_pTX(state.p, state.T, state.X);
end specificEnthalpy;

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.h_pTX(state.p,state.T,state.X) - gasConstant(state)*state.T;
end specificInternalEnergy;

redeclare function extends specificGibbsEnergy "Specific Gibbs energy"
  extends Modelica.Icons.Function;
algorithm
  g := Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.h_pTX(state.p,state.T,state.X) - state.T*specificEntropy(state);
end specificGibbsEnergy;

redeclare function extends specificHelmholtzEnergy "Specific Helmholtz energy"
  extends Modelica.Icons.Function;
algorithm
  f := Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.h_pTX(state.p,state.T,state.X)
         - gasConstant(state)*state.T
         - state.T*Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid.specificEntropy(state);
end specificHelmholtzEnergy;

////////////////////////////////////////////////////////////////////////////
function h_pTX
    "Compute specific enthalpy from pressure, temperature and mass fraction"
  extends Modelica.Icons.Function;

  annotation(smoothOrder=5);
  input SI.Pressure p "Pressure";
  input SI.Temperature T "Temperature";
  input SI.MassFraction X[nX] "Mass fractions of moist air";
  output SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";
algorithm
  h := (T - 273.15)*dryair.cp * (1 - X[Water]) + ((T-273.15) * steam.cp + 2501014.5) * X[Water];
end h_pTX;

function T_phX "Compute temperature from specific enthalpy and mass fraction"
  extends Modelica.Icons.Function;

  annotation(smoothOrder=5);
  input AbsolutePressure p "Pressure";
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
algorithm
  T := 273.15 + (h-2501014.5 * X[Water])/(dryair.cp * (1 - X[Water])+steam.cp*X[Water]);
end T_phX;

end MoistAirNoLiquid;
