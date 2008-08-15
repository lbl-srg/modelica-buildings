package MoistAir 
  "Package with moist air model that decouples pressure and temperature" 
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="MoistAirPTDecoupled",
     substanceNames={"water", "air"},
     final reducedX=true,
     final singleState=false,
     reference_X={0.01,0.99},
     fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                       Modelica.Media.IdealGases.Common.FluidData.N2});
  
  annotation (preferedView="info", Documentation(info="<HTML>
<p>
This is a medium model that is identical to 
<a href=\"Modelica:Buildings.Media.PerfectGases.MoistAir\">
Buildings.Media.PerfectGases.MoistAir</a>, except the 
equation <tt>d = p/(R*T)</tt> has been replaced with 
<tt>d/dStp = p/pStp</tt> where 
<tt>pStd</tt> and <tt>dStp</tt> are constants for a reference
temperature and density.
</p>
<p>
This new formulation often leads to smaller systems of nonlinear equations 
because pressure and temperature are decoupled, at the expense of accuracy.
</p>
</HTML>", revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br>
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
    
    MassFraction X_liquid "Mass fraction of liquid water";
    MassFraction X_steam "Mass fraction of steam water";
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
    X_liquid = max(Xi[Water] - X_sat, 0.0);
    X_steam  = Xi[Water]-X_liquid;
    X_air    = 1-Xi[Water];
    
    h = specificEnthalpy_pTX(p,T,Xi);
    R = dryair.R*(1 - X_steam/(1 - X_liquid)) + steam.R*X_steam/(1 - X_liquid);
    //                
    u = h - R*T;
    //    d = p/(R*T);
    d*pStp = p*dStp;
    
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
     extends Buildings.Media.PerfectGases.MoistAir.setState_phX;
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
  psat := Utilities.spliceFunction(saturationPressureLiquid(Tsat),sublimationPressureIce(Tsat),Tsat-273.16,1.0);
end saturationPressure;
  
 redeclare function pressure "Gas pressure" 
    extends Buildings.Media.PerfectGases.MoistAir.pressure;
 end pressure;
  
 redeclare function temperature "Gas temperature" 
    extends Buildings.Media.PerfectGases.MoistAir.temperature;
 end temperature;
  
 redeclare function density "Gas density" 
    extends Buildings.Media.PerfectGases.MoistAir.density;
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
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of liquid enthalpy";
algorithm 
  der_h := 4186;
end der_enthalpyOfLiquid;
  
redeclare function enthalpyOfCondensingGas 
    "Enthalpy of steam per unit mass of steam" 
  extends Modelica.Icons.Function;
    
  annotation(smoothOrder=5, derivative=der_enthalpyOfCondensingGas);
  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm 
  h := (T-273.15) * steam.cp + enthalpyOfVaporization(T);
end enthalpyOfCondensingGas;
  
replaceable function der_enthalpyOfCondensingGas 
    "Derivative of enthalpy of steam per unit mass of steam" 
  extends Modelica.Icons.Function;
  input Temperature T "temperature";
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of steam enthalpy";
algorithm 
  der_h := steam.cp;
end der_enthalpyOfCondensingGas;
  
redeclare replaceable function extends enthalpyOfGas 
    "Enthalpy of gas mixture per unit mass of gas mixture" 
algorithm 
  h := enthalpyOfCondensingGas(T)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
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
  input Temperature der_T "temperature derivative";
  output SpecificHeatCapacity der_h "derivative of dry air enthalpy";
algorithm 
  der_h := dryair.cp;
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
algorithm 
  lambda := Polynomials_Temp.evaluate({(-4.8737307422969E-008), 7.67803133753502E-005, 0.0241814385504202},
   Cv.to_degC(state.T));
end thermalConductivity;
  
function h_pTX 
    "Compute specific enthalpy from pressure, temperature and mass fraction" 
  extends Buildings.Media.PerfectGases.MoistAir.h_pTX;
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
  input SpecificEnthalpy h "specific enthalpy";
  input MassFraction[:] X "mass fractions of composition";
  output Temperature T "temperature";
  protected 
package Internal 
      "Solve h(data,T) for T with given h (use only indirectly via temperature_phX)" 
  extends Modelica.Media.Common.OneNonLinearEquation;
  redeclare record extends f_nonlinear_Data 
        "Data to be passed to non-linear function" 
    extends Buildings.Media.PerfectGases.Common.DataRecord;
  end f_nonlinear_Data;
      
  redeclare function extends f_nonlinear 
  algorithm 
      y := h_pTX(p,x,X);
  end f_nonlinear;
      
  // Dummy definition has to be added for current Dymola
  redeclare function extends solve 
  end solve;
end Internal;
    
algorithm 
 /* The function call below has been changed from 
      Internal.solve(h, 200, 6000, p, X[1:nXi], steam);
    to  
      Internal.solve(h, 200, 6000, p, X, steam);
    The reason is that when running the problem
       Buildings.Media.PerfectGases.Examples.MoistAirComparison
    then an assertion is triggered because the vector X had the wrong
    dimension. The above example verifies that T(h(T)) = T.
 */
  T := Internal.solve(h, 200, 6000, p, X, steam);
end T_phX;
  
  package Utilities "Utility functions" 
    function spliceFunction 
        input Real pos;
        input Real neg;
        input Real x;
        input Real deltax=1;
        output Real out;
        annotation (derivative=spliceFunction_der);
    protected 
        Real scaledX;
        Real scaledX1;
        Real y;
    algorithm 
        scaledX1 := x/deltax;
        scaledX := scaledX1*Modelica.Math.asin(1);
        if scaledX1 <= -0.999999999 then
          y := 0;
        elseif scaledX1 >= 0.999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
        end if;
        out := pos*y + (1 - y)*neg;
    end spliceFunction;
    
    function spliceFunction_der 
        input Real pos;
        input Real neg;
        input Real x;
        input Real deltax=1;
        input Real dpos;
        input Real dneg;
        input Real dx;
        input Real ddeltax=0;
        output Real out;
    protected 
        Real scaledX;
        Real scaledX1;
        Real dscaledX1;
        Real y;
    algorithm 
        scaledX1 := x/deltax;
        scaledX := scaledX1*Modelica.Math.asin(1);
        dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
        if scaledX1 <= -0.99999999999 then
          y := 0;
        elseif scaledX1 >= 0.9999999999 then
          y := 1;
        else
          y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
        end if;
        out := dpos*y + (1 - y)*dneg;
        if (abs(scaledX1) < 1) then
          out := out + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
            Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
            scaledX))^2;
        end if;
    end spliceFunction_der;
    
  end Utilities;
end MoistAir;
