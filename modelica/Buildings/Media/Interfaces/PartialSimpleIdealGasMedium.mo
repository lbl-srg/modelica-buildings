within Buildings.Media.Interfaces;
partial package PartialSimpleIdealGasMedium
  "Medium model of Ideal gas with constant cp and cv. All other quantities, e.g. transport properties, are constant."

  extends Modelica.Media.Interfaces.PartialPureSubstance(singleState=false);

  import SI = Modelica.SIunits;
  constant SpecificHeatCapacity cp_const
    "Constant specific heat capacity at constant pressure";
  constant SpecificHeatCapacity cv_const= cp_const - R_gas
    "Constant specific heat capacity at constant volume";
  constant SpecificHeatCapacity R_gas "medium specific gas constant";
  constant MolarMass MM_const "Molar mass";
  constant DynamicViscosity eta_const "Constant dynamic viscosity";
  constant ThermalConductivity lambda_const "Constant thermal conductivity";
  constant Temperature T_min "Minimum temperature valid for medium model";
  constant Temperature T_max "Maximum temperature valid for medium model";
  constant Temperature T0= reference_T "Zero enthalpy temperature";

  redeclare record extends ThermodynamicState
    "Thermodynamic state of ideal gas"
    AbsolutePressure p "Absolute pressure of medium";
    Temperature T "Temperature of medium";
  end ThermodynamicState;

  redeclare record extends FluidConstants "fluid constants"
  end FluidConstants;

  redeclare replaceable model extends BaseProperties(
          T(stateSelect=StateSelect.prefer)) "Base properties of ideal gas"
  equation
        assert(T >= T_min and T <= T_max, "
Temperature T (= "   + String(T) + " K) is not
in the allowed range ("   + String(T_min) + " K <= T <= " + String(T_max)
           + " K)
required from medium model \""   + mediumName + "\".
");
    h = specificEnthalpy_pTX(p,T,X);
    u = h-R*T;
    R = R_gas;
    d = p/(R*T);
    MM = MM_const;
    state.T = T;
    state.p = p;
        annotation (Documentation(info="<HTML>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
</p>
</HTML>"));
  end BaseProperties;

  redeclare function setState_pTX
    "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p,T=T);
    annotation(Documentation(info="<html></html>"));
  end setState_pTX;

  redeclare function setState_phX
    "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p,T=T0+h/cp_const);
    annotation(Documentation(info="<html></html>"));
  end setState_phX;

  redeclare replaceable function setState_psX
    "Return thermodynamic state from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p,T=Modelica.Math.exp(s/cp_const + Modelica.Math.log(T0))
                                + R_gas*Modelica.Math.log(p/reference_p));
    annotation(Documentation(info="<html></html>"));
  end setState_psX;

  redeclare replaceable function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=d*R_gas*T,T=T);
    annotation(Documentation(info="<html></html>"));
  end setState_dTX;

  redeclare function extends pressure "Return pressure of ideal gas"

  algorithm
    p := state.p;
    annotation(Documentation(info="<html></html>"));
  end pressure;

  redeclare function extends temperature "Return temperature of ideal gas"

  algorithm
    T := state.T;
    annotation(Documentation(info="<html></html>"));
  end temperature;

  redeclare replaceable function extends density "Return density of ideal gas"
  algorithm
    d := state.p/(R_gas*state.T);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
      extends Modelica.Icons.Function;
  algorithm
    h := cp_const*(state.T-T0);
    annotation(Documentation(info="<html></html>"));
  end specificEnthalpy;

  redeclare function extends specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    u := (cp_const-R_gas)*(state.T-T0);
    annotation(Documentation(info="<html></html>"));
  end specificInternalEnergy;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy"
      extends Modelica.Icons.Function;
  algorithm
    s := cp_const*Modelica.Math.log(state.T/T0) - R_gas*Modelica.Math.log(state.p/reference_p);
    annotation(Documentation(info="<html></html>"));
  end specificEntropy;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
  algorithm
    g := cp_const*(state.T-T0) - state.T*specificEntropy(state);
    annotation(Documentation(info="<html></html>"));
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
  algorithm
    f := (cp_const-R_gas)*(state.T-T0) - state.T*specificEntropy(state);
    annotation(Documentation(info="<html></html>"));
  end specificHelmholtzEnergy;

  redeclare function extends dynamicViscosity "Return dynamic viscosity"

  algorithm
    eta := eta_const;
    annotation(Documentation(info="<html></html>"));
  end dynamicViscosity;

  redeclare function extends thermalConductivity "Return thermal conductivity"

  algorithm
    lambda := lambda_const;
    annotation(Documentation(info="<html></html>"));
  end thermalConductivity;

  redeclare function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure"

  algorithm
    cp := cp_const;
    annotation(Documentation(info="<html></html>"));
  end specificHeatCapacityCp;

  redeclare function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume"

  algorithm
    cv := cv_const;
    annotation(Documentation(info="<html></html>"));
  end specificHeatCapacityCv;

  redeclare function extends isentropicExponent "Return isentropic exponent"

  algorithm
    gamma := cp_const/cv_const;
    annotation(Documentation(info="<html></html>"));
  end isentropicExponent;

  redeclare function extends velocityOfSound "Return velocity of sound "

  algorithm
    a := sqrt(cp_const/cv_const*R_gas*state.T);
    annotation(Documentation(info="<html></html>"));
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
    annotation(Documentation(info="<html></html>"));
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
    annotation(Documentation(info="<html></html>"));
  end temperature_phX;

  redeclare function density_phX "Return density from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[nX] "Mass fractions";
    output Density d "density";
  algorithm
    d := density(setState_phX(p,h,X));
    annotation(Documentation(info="<html></html>"));
  end density_phX;

  annotation (Documentation(info="<html>
This package is identical to <a href=\"Modelica:Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>
except that the functions.
<code>density</code>,
<code>specificEntropy</code> and <code>setState_dTX</code> are declared as <code>replaceable</code>.
This is required for the implementation of 
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.SimpleAir\">
Buildings.Media.GasesPTDecoupled.SimpleAir</a>.
</html>", revisions="<html>
<ul>
<li>
February 18, 2010, by Michael Wetter:<br>
In <a href=\"modelica://Buildings.Media.Interfaces.PartialSimpleIdealGasMedium.setState_psX\">
setState_psX</a>, replaced
<code>reference_T</code> with <code>T0</code> because enthalpy is defined as zero at <code>T0</code>.
</li>
<li>
January 12, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PartialSimpleIdealGasMedium;
