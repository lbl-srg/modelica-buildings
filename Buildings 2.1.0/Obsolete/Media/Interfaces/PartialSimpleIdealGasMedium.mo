within Buildings.Obsolete.Media.Interfaces;
partial package PartialSimpleIdealGasMedium
  "Medium model of Ideal gas with constant cp and cv. All other quantities, e.g., transport properties, are constant."

  extends Modelica.Media.Interfaces.PartialPureSubstance(
      ThermoStates=Buildings.Obsolete.Media.Interfaces.Choices.IndependentVariables.pT,
      singleState=false);

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
    AbsolutePressure p(start=p_default) "Absolute pressure of medium";
    Temperature T(start=T_default) "Temperature of medium";
  end ThermodynamicState;

  redeclare record extends FluidConstants "fluid constants"
  end FluidConstants;

  redeclare replaceable model extends BaseProperties
    "Base properties of ideal gas"
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
  end setState_pTX;

  redeclare function setState_phX
    "Return thermodynamic state from p, h, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p,T=temperature_phX(p, h, X));
  end setState_phX;

  redeclare replaceable function setState_psX
    "Return thermodynamic state from p, s, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    state := ThermodynamicState(p=p,T=Modelica.Math.exp(s/cp_const + Modelica.Math.log(reference_T))
                                + R_gas*Modelica.Math.log(p/reference_p));
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
  end setState_dTX;

      redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
      algorithm
    state := ThermodynamicState(p=Modelica.Media.Common.smoothStep(
            x,
            state_a.p,
            state_b.p,
            x_small), T=Modelica.Media.Common.smoothStep(
            x,
            state_a.T,
            state_b.T,
            x_small));
      end setSmoothState;

  redeclare function extends pressure "Return pressure of ideal gas"

  algorithm
    p := state.p;
  end pressure;

  redeclare function extends temperature "Return temperature of ideal gas"

  algorithm
    T := state.T;
  end temperature;

  redeclare replaceable function extends density "Return density of ideal gas"
  algorithm
    d := state.p/(R_gas*state.T);
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"
      extends Modelica.Icons.Function;
  algorithm
    h := cp_const*(state.T-T0);
  end specificEnthalpy;

  redeclare replaceable function extends specificInternalEnergy
    "Return specific internal energy"
    extends Modelica.Icons.Function;
  algorithm
    // u := (cp_const-R_gas)*(state.T-T0);
    u := cp_const*(state.T-T0) - R_gas*state.T;
  end specificInternalEnergy;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy"
      extends Modelica.Icons.Function;
  algorithm
    s := cp_const*Modelica.Math.log(state.T/T0) - R_gas*Modelica.Math.log(state.p/reference_p);
  end specificEntropy;

  redeclare function extends specificGibbsEnergy "Return specific Gibbs energy"
    extends Modelica.Icons.Function;
  algorithm
    g := cp_const*(state.T-T0) - state.T*specificEntropy(state);
  end specificGibbsEnergy;

  redeclare function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
    extends Modelica.Icons.Function;
  algorithm
    f := (cp_const-R_gas)*(state.T-T0) - state.T*specificEntropy(state);
  end specificHelmholtzEnergy;

  redeclare function extends dynamicViscosity "Return dynamic viscosity"

  algorithm
    eta := eta_const;
  end dynamicViscosity;

  redeclare function extends thermalConductivity "Return thermal conductivity"

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

  redeclare function extends velocityOfSound "Return velocity of sound "

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

  redeclare function extends isentropicEnthalpy "Return isentropic enthalpy"
  algorithm
    /*  s = cp_const*log(refState.T/T0) - R_gas*log(refState.p/reference_p)
          = cp_const*log(state.T/T0) - R_gas*log(p_downstream/reference_p)

        log(state.T) = log(refState.T) +
                       (R_gas/cp_const)*(log(p_downstream/reference_p) - log(refState.p/reference_p))
                     = log(refState.T) + (R_gas/cp_const)*log(p_downstream/refState.p)
                     = log(refState.T) + log( (p_downstream/refState.p)^(R_gas/cp_const) )
                     = log( refState.T*(p_downstream/refState.p)^(R_gas/cp_const) )
        state.T = refstate.T*(p_downstream/refstate.p)^(R_gas/cp_const)
    */
    h_is := cp_const*(refState.T*(p_downstream/refState.p)^(R_gas/cp_const) - T0);
  end isentropicEnthalpy;

  redeclare function extends isobaricExpansionCoefficient
    "Returns overall the isobaric expansion coefficient beta"
  algorithm
    /* beta = 1/v * der(v,T), with v = 1/d, at constant pressure p:
       v = R*T/p
       der(v,T) = R/p
       beta = p/(R*T)*R/p
            = 1/T
    */

    beta := 1/state.T;
  end isobaricExpansionCoefficient;

  redeclare function extends isothermalCompressibility
    "Returns overall the isothermal compressibility factor"
  algorithm
    /* kappa = - 1/v * der(v,p), with v = 1/d at constant temperature T.
       v = R*T/p
       der(v,T) = -R*T/p^2
       kappa = p/(R*T)*R*T/p^2
             = 1/p
    */
    kappa := 1/state.p;
  end isothermalCompressibility;

  redeclare function extends density_derp_T
    "Returns the partial derivative of density with respect to pressure at constant temperature"
  algorithm
    /*  d = p/(R*T)
        ddpT = 1/(R*T)
    */
    ddpT := 1/(R_gas*state.T);
  end density_derp_T;

  redeclare function extends density_derT_p
    "Returns the partial derivative of density with respect to temperature at constant pressure"
  algorithm
    /*  d = p/(R*T)
        ddpT = -p/(R*T^2)
    */
    ddTp := -state.p/(R_gas*state.T*state.T);
  end density_derT_p;

  redeclare function extends density_derX
    "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
  algorithm
    dddX := fill(0,nX);
  end density_derX;

  redeclare function extends molarMass "Returns the molar mass of the medium"
  algorithm
    MM := MM_const;
  end molarMass;
  annotation (preferredView="info",
Documentation(info="<html>
This package is identical to <a href=\"modelica://Modelica.Media.Interfaces.PartialSimpleIdealGasMedium\">
Modelica.Media.Interfaces.PartialSimpleIdealGasMedium</a>
except that the functions.
<code>density</code>,
<code>specificEntropy</code> and <code>setState_dTX</code> are declared as <code>replaceable</code>.
This is required for the implementation of
<a href=\"modelica://Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir\">
Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir</a>.
</html>", revisions="<html>
<ul>
<li>
September 12, 2014, by Michael Wetter:<br/>
Set <code>T(start=T_default)</code> and <code>p(start=p_default)</code> in the
<code>ThermodynamicState</code> record. Setting the start value for
<code>T</code> is required to avoid an error due to conflicting start values
when checking <a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
Buildings.Examples.VAVReheat.ClosedLoop</a> in pedantic mode.
</li>
<li>
September 16, 2010, by Michael Wetter:<br/>
Removed the <code>stateSelect</code> assignment in <pre>
BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else
                       StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else
                       StateSelect.default))
</pre>
as this is now handled in the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>. The reason for this change is
that the assignment is different for steady-state and dynamic balance.
In the previous implementation, this assignment can cause steady-state models to
be differentiated in order to obtain <code>T</code> as a state. This resulted
in some cases in large coupled systems of equations that can be avoided
if the <code>stateSelect</code> is not set to <code>StateSelect.prefer</code>
for steady-state models.
</li>
<li>
August 2, 2011, by Michael Wetter:<br/>
<ul>
<li>
Made a new copy from the Modelica Standard Library since
the Modelica Standard Library fixed a bug in computing the enthalpy, internal energy
and the relation <code>h=u+R*T</code>. The bug that was fixed was because in Modelica,
<code>h</code> and <code>u</code> are not zero at 0 Kelvin, in which case
<code>u</code> cannot be computed as <code>c_v*T</code>.
</li>
<li>
Added <code>final</code> keyword to <code>singleState = false</code> since
this medium implements density as a function of pressure.
</li>
<li>
Declared functions
<code>density</code>,
<code>specificEntropy</code> and <code>setState_dTX</code> as <code>replaceable</code>.
This is required for the implementation of
<a href=\"modelica://Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir\">
Buildings.Obsolete.Media.GasesPTDecoupled.SimpleAir</a>.
</li>
</ul>
</li>
</ul>
</html>"));
end PartialSimpleIdealGasMedium;
