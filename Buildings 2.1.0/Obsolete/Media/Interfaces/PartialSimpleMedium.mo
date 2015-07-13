within Buildings.Obsolete.Media.Interfaces;
partial package PartialSimpleMedium
  "Medium model with linear dependency of u, h from temperature. Most other quantities are constant."

  extends Modelica.Media.Interfaces.PartialPureSubstance(
        ThermoStates=Buildings.Obsolete.Media.Interfaces.Choices.IndependentVariables.pT,
        final singleState=true,
        reference_p=p0,
        p_default=p0);

  import SI = Modelica.SIunits;
  constant SpecificHeatCapacity cp_const
    "Constant specific heat capacity at constant pressure";
  constant SpecificHeatCapacity cv_const
    "Constant specific heat capacity at constant volume";
  constant Density d_const "Constant density";
  constant DynamicViscosity eta_const "Constant dynamic viscosity";
  constant ThermalConductivity lambda_const "Constant thermal conductivity";
  constant VelocityOfSound a_const "Constant velocity of sound";
  constant Temperature T_min "Minimum temperature valid for medium model";
  constant Temperature T_max "Maximum temperature valid for medium model";
  constant Temperature T0=reference_T "Zero enthalpy temperature";
  constant MolarMass MM_const "Molar mass";

  constant FluidConstants[nS] fluidConstants "fluid constants";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    AbsolutePressure p(start=p_default) "Absolute pressure of medium";
    Temperature T(start=T_default) "Temperature of medium";
  end ThermodynamicState;

  constant Modelica.SIunits.AbsolutePressure p0 = 3E5
    "Reference pressure for default medium pressure";

  redeclare replaceable model extends BaseProperties(
     p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default))
    "Base properties"
  equation
        assert(T >= T_min and T <= T_max, "
Temperature T (= "   + String(T) + " K) is not
in the allowed range ("   + String(T_min) + " K <= T <= " + String(T_max)
           + " K)
required from medium model \""   + mediumName + "\".
");

        // h = cp_const*(T-T0);
    h = specificEnthalpy_pTX(p,T,X);
    u = cv_const*(T-T0);
    // original equation d = d_const;
    d = d_const;
    R = 0;
    MM = MM_const;
    state.T = T;
    state.p = p;
        annotation (Documentation(info="<html>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
</p>
</html>"));
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
    state := ThermodynamicState(p=p,T=Modelica.Math.exp(s/cp_const + Modelica.Math.log(T0)))
      "here the incompressible limit is used, with cp as heat capacity";
  end setState_psX;

  redeclare function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "density";
    input Temperature T "Temperature";
    input MassFraction X[:]=reference_X "Mass fractions";
    output ThermodynamicState state "thermodynamic state record";
  algorithm
    assert(false,"pressure can not be computed from temperature and density for an incompressible fluid!");
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

  redeclare function extends dynamicViscosity "Return dynamic viscosity"

  algorithm
    eta := eta_const;
  end dynamicViscosity;

  redeclare function extends thermalConductivity "Return thermal conductivity"

  algorithm
    lambda := lambda_const;
  end thermalConductivity;

  redeclare function extends pressure "Return pressure"

  algorithm
    p := state.p;
  end pressure;

  redeclare function extends temperature "Return temperature"

  algorithm
    T := state.T;
  end temperature;

  redeclare function extends density "Return density"

  algorithm
    d := d_const;
  end density;

  redeclare function extends specificEnthalpy "Return specific enthalpy"

  algorithm
    h := cp_const*(state.T-T0);
  end specificEnthalpy;

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
    a := a_const;
  end velocityOfSound;

  redeclare function specificEnthalpy_pTX
    "Return specific enthalpy from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[nX] "Mass fractions";
    output SpecificEnthalpy h "Specific enthalpy";
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
    T := T0 + h/cp_const;
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

  annotation (Documentation(info="<html>
<p>
This medium model is almost identical to
<a href=\"modelica://Modelica.Media.Interfaces.PartialSimpleMedium\">
Modelica.Media.Interfaces.PartialSimpleMedium</a>.
However, it had to be introduced to allow setting the start attribute
for the <code>ThermodynamicState</code>. This is required to avoid
an error if
<a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
Buildings.Examples.VAVReheat.ClosedLoop</a>
is translated in the pedantic mode.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2014, by Michael Wetter:<br/>
Removed option to model water as a compressible medium as
this option was not useful.<br/>
Added again<pre>
BaseProperties(
    T(stateSelect=if preferredMediumStates then StateSelect.prefer else
                       StateSelect.default),
    p(stateSelect=if preferredMediumStates then StateSelect.prefer else
                       StateSelect.default))
</pre>
as this leads to a different state selection in the Annex 60 test case
with shorter computing time.<br/>
Introduced the attributes
<code>T(start=T_default)</code> and
<code>p(start=p_default)</code> in the
<code>ThermodynamicState</code> record. Setting the start value for
<code>T</code> is required to avoid an error due to
conflicting start values when translating
<a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
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
September 12, 2014, by Michael Wetter:<br/>
Set <code>T(start=T_default)</code> and <code>p(start=p_default)</code> in the
<code>ThermodynamicState</code> record. Setting the start value for
<code>T</code> is required to avoid an error due to conflicting start values
when checking <a href=\"modelica://Buildings.Examples.VAVReheat.ClosedLoop\">
Buildings.Examples.VAVReheat.ClosedLoop</a> in pedantic mode.
</li>
<li>
August 3, 2011, by Michael Wetter:<br/>
Fixed bug in function <code>density</code>, which always returned <code>d_const</code>, regardless
of the constant <code>constantDensity</code>.
</li>
<li>
August 1, 2011, by Michael Wetter:<br/>
Fixed bug in assignment of <code>singleState</code>.
</li>
<li>
September 13, 2010, by Michael Wetter:<br/>
Set default values and reference pressure.
</li>
<li>
February 18, 2010, by Michael Wetter:<br/>
In <a href=\"modelica://Buildings.Obsolete.Media.Interfaces.PartialSimpleMedium.setState_psX\">
setState_psX</a>, replaced
<code>reference_T</code> with <code>T0</code> because enthalpy is defined as zero at <code>T0</code>.
</li>
<li>
October 2, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialSimpleMedium;
