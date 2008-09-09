  partial package PartialSimpleIdealGasMedium 
    "Medium model of Ideal gas with constant cp and cv. All other quantities, e.g. transport properties, are constant." 
    
    extends Modelica.Media.Interfaces.PartialPureSubstance(final singleState=false,final 
        reducedX =                                                                 true);
    
    import SI = Modelica.SIunits;

          annotation (Documentation(info="<HTML>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
</p>
<p>
This partial package is identical to 
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a> but it fixes two bugs
in the original implementation. Namely, in the functions
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium.specificEnthalpy\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium.specificEnthalpy</a>
and
<a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium.specificInternalEnergy\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium.specificInternalEnergy</a>
the computation of the enthalpy or internal energy does not use the reference temperature
<tt>T0</tt>. With this implementation, initial states of fluid volumes can be far away from
the steady-state value because of this inconsistent implementation. Because these two functions
are not <tt>replaceable</tt>, we needed to make a copy of the whole package,
and reimplement these functions.
When the <tt>Buildings</tt> library is upgraded to
to Modelica 3.0.0, it should be safe to remove this package as the bug is fixed
since Modelica 3.0.0 (but not in Modelica 2.2.2).
</HTML>", revisions="<html>
<ul>
<li>
September 4, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

    constant SpecificHeatCapacity cp_const 
      "Constant specific heat capacity at constant pressure";
    constant SpecificHeatCapacity cv_const= cp_const/R_gas 
      "Constant specific heat capacity at constant volume";
    constant SpecificHeatCapacity R_gas "medium specific gas constant";
    constant MolarMass MM_const "Molar mass";
    constant DynamicViscosity eta_const "Constant dynamic viscosity";
    constant ThermalConductivity lambda_const "Constant thermal conductivity";
    constant Temperature T_min "Minimum temperature valid for medium model";
    constant Temperature T_max "Maximum temperature valid for medium model";
    constant Temperature T0= reference_T "Zero enthalpy temperature";
    
    redeclare replaceable record extends ThermodynamicState 
      "thermodynamic state" 
      AbsolutePressure p "Absolute pressure of medium";
      Temperature T "Temperature of medium";
    end ThermodynamicState;
    
    redeclare replaceable model extends BaseProperties(
            T(stateSelect=StateSelect.prefer)) "Base properties" 
    equation 
          assert(T >= T_min and T <= T_max, "
Temperature T (= "     + String(T) + " K) is not
in the allowed range ("     + String(T_min) + " K <= T <= " + String(T_max)
             + " K)
required from medium model \""     + mediumName + "\".
");
      h = specificEnthalpy_pTX(p,T,X);
      u = h-R*T;
      R = R_gas;
      d = p/(R*T);
      MM = MM_const;
      state.T = T;
      state.p = p;
      
    end BaseProperties;
    
    redeclare function setState_pTX 
      "Return thermodynamic state from p, T, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input Temperature T "Temperature";
      input MassFraction X[:] = fill(0,0) "Mass fractions";
      output ThermodynamicState state;
    algorithm 
      state := ThermodynamicState(p=p,T=T);
    end setState_pTX;
    
    redeclare function setState_phX 
      "Return thermodynamic state from p, h, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction X[:] = fill(0,0) "Mass fractions";
      output ThermodynamicState state;
    algorithm 
      state := ThermodynamicState(p=p,T=T0+h/cp_const);
    end setState_phX;
    
    redeclare replaceable function setState_psX 
      "Return thermodynamic state from p, s, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEntropy s "Specific entropy";
      input MassFraction X[:] = fill(0,0) "Mass fractions";
      output ThermodynamicState state;
    algorithm 
      state := ThermodynamicState(p=p,T=Modelica.Math.exp(s/cp_const + Modelica.Math.log(reference_T))
                                  + R_gas*Modelica.Math.log(p/reference_p));
    end setState_psX;
    
    redeclare function setState_dTX 
      "Return thermodynamic state from d, T, and X or Xi" 
      extends Modelica.Icons.Function;
      input Density d "density";
      input Temperature T "Temperature";
      input MassFraction X[:] = fill(0,0) "Mass fractions";
      output ThermodynamicState state;
    algorithm 
      state := ThermodynamicState(p=d*R_gas*T,T=T);
    end setState_dTX;
    
    redeclare function extends pressure "return pressure of ideal gas" 
    algorithm 
      p := state.p;
    end pressure;
    
    redeclare function extends temperature "return temperature of ideal gas" 
    algorithm 
      T := state.T;
    end temperature;
    
    redeclare function extends density "return density of ideal gas" 
    algorithm 
      d := state.p/(R_gas*state.T);
    end density;
    
    redeclare function extends specificEnthalpy "Return specific enthalpy" 
        extends Modelica.Icons.Function;
    algorithm 
      h := cp_const*(state.T-T0); // this is one of the bug fixes
    end specificEnthalpy;
    
    redeclare function extends specificInternalEnergy 
      "Return specific internal energy" 
      extends Modelica.Icons.Function;
    algorithm 
      u := cp_const*(state.T-T0) - R_gas*state.T; // this is one of the bug fixes
    end specificInternalEnergy;
    
    redeclare function extends specificEntropy "Return specific entropy" 
        extends Modelica.Icons.Function;
    algorithm 
      s := cp_const*Modelica.Math.log(state.T/T0) - R_gas*Modelica.Math.log(state.p/reference_p);
    end specificEntropy;
    
    redeclare function extends specificGibbsEnergy 
      "Return specific Gibbs energy" 
      extends Modelica.Icons.Function;
    algorithm 
      g := cp_const*state.T - state.T*specificEntropy(state);
    end specificGibbsEnergy;
    
    redeclare function extends specificHelmholtzEnergy 
      "Return specific Helmholtz energy" 
      extends Modelica.Icons.Function;
    algorithm 
      f := cp_const*state.T - R_gas*state.T - state.T*specificEntropy(state);
    end specificHelmholtzEnergy;
    
    redeclare function extends dynamicViscosity 
      "Return dya_constnamic viscosity" 
    algorithm 
      eta := eta_const;
    end dynamicViscosity;
    
    redeclare function extends thermalConductivity 
      "Return thermal conductivity" 
    algorithm 
      lambda := lambda_const;
    end thermalConductivity;
    
    redeclare function extends specificHeatCapacityCp 
      "Return specific heat capacity at constant pressure" 
    algorithm 
      cp := cp_const;
    end specificHeatCapacityCp;
    
    redeclare function extends specificHeatCapacityCv 
      "Return specific heat capacity at constant volume" 
    algorithm 
      cv := cv_const;
    end specificHeatCapacityCv;
    
    redeclare function extends isentropicExponent "Return isentropic exponent" 
    algorithm 
      gamma := cp_const/cv_const;
    end isentropicExponent;
    
    redeclare function extends velocityOfSound "Velocity of sound " 
    algorithm 
      a := sqrt(cp_const/cv_const*R_gas*state.T);
    end velocityOfSound;
    
    redeclare function specificEnthalpy_pTX 
      "Return specific enthalpy from p, T, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input Temperature T "Temperature";
      input MassFraction X[nX] "Mass fractions";
      output SpecificEnthalpy h "Specific enthalpy at p, T, X";
    algorithm 
      h := cp_const*(T-T0);
    end specificEnthalpy_pTX;
    
    redeclare function temperature_phX 
      "Return temperature from p, h, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction X[nX] "Mass fractions";
      output Temperature T "Temperature";
    algorithm 
      T := h/cp_const + T0;
    end temperature_phX;
    
    redeclare function density_phX "Return density from p, h, and X or Xi" 
      extends Modelica.Icons.Function;
      input AbsolutePressure p "Pressure";
      input SpecificEnthalpy h "Specific enthalpy";
      input MassFraction X[nX] "Mass fractions";
      output Density d "density";
    algorithm 
      d := density(setState_phX(p,h,X));
    end density_phX;
    
  end PartialSimpleIdealGasMedium;