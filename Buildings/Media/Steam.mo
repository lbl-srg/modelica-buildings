within Buildings.Media;
package Steam
  "Package with model for region 2 (steam) water according to IF97 standard"
  extends Buildings.Media.Interfaces.PartialPureSubstanceWithSaturation(
    redeclare replaceable record FluidConstants =
        Modelica.Media.Interfaces.Types.TwoPhase.FluidConstants,
    mediumName="WaterIF97_R2pT",
    substanceNames={"water"},
    singleState=false,
    SpecificEnthalpy(
      start=1.0e5,
      nominal=5.0e5),
    Density(
      start=150,
      nominal=500),
    AbsolutePressure(
      start=p_default,
      nominal=10e5,
      min=611.657,
      max=100e6),
    Temperature(
      start=T_default,
      nominal=500,
      min=273.15,
      max=2273.15),
    T_default=Modelica.SIunits.Conversions.from_degC(100));
  extends Modelica.Icons.Package;
  constant FluidConstants[1] fluidConstants=Modelica.Media.Water.waterConstants
    "Constant data for water";
  redeclare record extends ThermodynamicState
    "Thermodynamic state"
    SpecificEnthalpy h "Specific enthalpy";
    Density d "Density";
    Temperature T "Temperature";
    AbsolutePressure p "Pressure";
  end ThermodynamicState;
  constant Integer region=2
    "Region of IF97, if known, zero otherwise";
  constant Integer phase=1 "1 for one-phase";
  redeclare replaceable model extends BaseProperties(
    T(stateSelect= if preferredMediumStates then StateSelect.prefer
        else StateSelect.default),
    p(stateSelect= if preferredMediumStates then StateSelect.prefer
        else StateSelect.default))
    "Base properties (p, d, T, h, u, R, MM, sat) of water"
  initial equation
    Modelica.Utilities.Streams.print(
      "Warning:\n  In " + getInstanceName() +
      ": This model is a beta version and is not fully validated yet.");
  equation
    // Temperature and pressure values must be within acceptable max & min bounds
    assert(T >= 273.15,
      "In "+getInstanceName()+": Temperature T exceeded its minimum allowed value of 0 degC (273.15 Kelvin)
      as required from medium model \""+mediumName+"\".");
    assert(T <= 1073.15,
      "In "+getInstanceName()+": Temperature T exceeded its maximum allowed value of 800 degC (1073.15 Kelvin)
      as required from medium model \""+mediumName+"\".");
    assert(p <= 100E6,
      "In "+getInstanceName()+": Pressure p exceeded its maximum allowed value of 100 MPa
      as required from medium model \""+mediumName+"\".");
    // Medium must be in a vapor state. A 2% error is deemed acceptable to account for numerical noise.
    assert(T >= saturationTemperature(p)*0.98,
      "In "+getInstanceName()+": The fluid is in a liquid state, which violates the requirements for 
       medium model \""+mediumName+"\".");
    MM=fluidConstants[1].molarMass;
    h=specificEnthalpy_pT(p,T);
    d=density_pT(p,T);
    u=h-p/d;
    R=Modelica.Constants.R/fluidConstants[1].molarMass;
    h=state.h;
    p=state.p;
    T=state.T;
    d=state.d;
  end BaseProperties;

  redeclare replaceable function density_ph
    "Computes density as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Density d "Density";
  algorithm
    d := rho_ph(p,h);
    annotation (Inline=true);
  end density_ph;

  redeclare replaceable function temperature_ph
    "Computes temperature as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Temperature T "Temperature";
  algorithm
    T := T_ph(p,h);
    annotation (Inline=true);
  end temperature_ph;

  redeclare replaceable function temperature_ps
    "Compute temperature from pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Temperature T "Temperature";
  algorithm
    T := Modelica.Media.Water.IF97_Utilities.T_ps(p,s);
    annotation (Inline=true);
  end temperature_ps;

  redeclare replaceable function density_ps
    "Computes density as a function of pressure and specific enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output Density d "Density";
  algorithm
    d := Modelica.Media.Water.IF97_Utilities.rho_ps(p,s);
    annotation (Inline=true);
  end density_ps;

  redeclare replaceable function pressure_dT
    "Computes pressure as a function of density and temperature"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output AbsolutePressure p "Pressure";
  algorithm
    p := Modelica.Media.Water.IF97_Utilities.p_dT(d,T);
    annotation (Inline=true);
  end pressure_dT;

  redeclare replaceable function specificEnthalpy_dT
    "Computes specific enthalpy as a function of density and temperature"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := Modelica.Media.Water.IF97_Utilities.h_dT(d,T);
    annotation (Inline=true);
  end specificEnthalpy_dT;

  redeclare replaceable function specificEnthalpy_pT
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := h_pT(p,T);
    annotation (Inline=true);
  end specificEnthalpy_pT;

  redeclare replaceable function specificEnthalpy_ps
    "Computes specific enthalpy as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEntropy s "Specific entropy";
    output SpecificEnthalpy h "Specific enthalpy";
  algorithm
    h := Modelica.Media.Water.IF97_Utilities.h_ps(p,s);
    annotation (Inline=true);
  end specificEnthalpy_ps;

  redeclare replaceable function density_pT
    "Computes density as a function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output Density d "Density";
  algorithm
    d := rho_pT(p,T);
    annotation (Inline=true);
  end density_pT;

  redeclare replaceable function extends dynamicViscosity
    "Return dynamic viscosity"
  algorithm
    eta := Modelica.Media.Water.IF97_Utilities.dynamicViscosity(
      state.d,
      state.T,
      state.p,
      phase);
    annotation (Inline=true);
  end dynamicViscosity;

  redeclare replaceable function extends thermalConductivity
    "Return thermal conductivity"
  algorithm
    lambda := Modelica.Media.Water.IF97_Utilities.thermalConductivity(
      state.d,
      state.T,
      state.p,
      phase);
    annotation (Inline=true);
  end thermalConductivity;

  redeclare replaceable function extends pressure
    "Return pressure"
  algorithm
    p := state.p;
    annotation (Inline=true);
  end pressure;

  redeclare replaceable function extends temperature
    "Return temperature"
  algorithm
    T := state.T;
    annotation (Inline=true);
  end temperature;

  redeclare replaceable function extends density
    "Return density"
  algorithm
    d := state.d;
    annotation (Inline=true);
  end density;

  redeclare replaceable function extends specificEnthalpy
    "Return specific enthalpy"
  algorithm
    h := state.h;
    annotation (Inline=true);
  end specificEnthalpy;

  redeclare replaceable function extends specificInternalEnergy
    "Return specific internal energy"
  algorithm
    u := state.h-state.p/state.d;
    annotation (Inline=true);
  end specificInternalEnergy;

  redeclare replaceable function extends specificEntropy
    "Return specific entropy"
  algorithm
    s := s_pT(
      state.p,
      state.T);
    annotation (Inline=true);
  end specificEntropy;

  redeclare replaceable function extends specificGibbsEnergy
    "Return specific Gibbs energy"
  algorithm
    g := state.h-state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificGibbsEnergy;

  redeclare replaceable function extends specificHelmholtzEnergy
    "Return specific Helmholtz energy"
  algorithm
    f := state.h-state.p/state.d-state.T*specificEntropy(state);
    annotation (Inline=true);
  end specificHelmholtzEnergy;

  redeclare replaceable function extends specificHeatCapacityCp
    "Return specific heat capacity at constant pressure"
  algorithm
    cp := cp_pT(
      state.p,
      state.T);
    annotation (Inline=true);
  end specificHeatCapacityCp;

  redeclare replaceable function extends specificHeatCapacityCv
    "Return specific heat capacity at constant volume"
  algorithm
    cv := cv_pT(
      state.p,
      state.T);
    annotation (Inline=true);
  end specificHeatCapacityCv;

  redeclare function extends density_derh_p
    "Density derivative by specific enthalpy"
  algorithm
    ddhp := Modelica.Media.Water.IF97_Utilities.ddhp(
      state.p,
      state.h,
      phase,
      region);
    annotation (Inline=true);
  end density_derh_p;

  redeclare function extends density_derp_h
    "Density derivative by pressure"
  algorithm
    ddph := Modelica.Media.Water.IF97_Utilities.ddph(
      state.p,
      state.h,
      phase,
      region);
    annotation (Inline=true);
  end density_derp_h;

  redeclare replaceable function extends isentropicExponent
    "Return isentropic exponent"
  algorithm
    gamma := Modelica.Media.Water.IF97_Utilities.isentropicExponent_pT(
      state.p,
      state.T,
      region);
    annotation (Inline=true);
  end isentropicExponent;

  redeclare replaceable function extends isothermalCompressibility
    "Isothermal compressibility of water"
  algorithm
    kappa := Modelica.Media.Water.IF97_Utilities.kappa_pT(
      state.p,
      state.T,
      region);
    annotation (Inline=true);
  end isothermalCompressibility;

  redeclare replaceable function extends isobaricExpansionCoefficient
    "Isobaric expansion coefficient of water"
  algorithm
    beta := Modelica.Media.Water.IF97_Utilities.beta_pT(
      state.p,
      state.T,
      region);
  end isobaricExpansionCoefficient;

  redeclare replaceable function extends isentropicEnthalpy
    "Compute h(s,p)"
  algorithm
    h_is := Modelica.Media.Water.IF97_Utilities.isentropicEnthalpy(
      p_downstream,
      specificEntropy(refState),0);
    annotation (Inline=true);
  end isentropicEnthalpy;

  redeclare replaceable function extends molarMass
    "Return the molar mass of the medium"
  algorithm
    MM := fluidConstants[1].molarMass;
  end molarMass;
  // Saturation state functions
  redeclare replaceable function extends saturationTemperature
    "Return saturation temperature"
  algorithm
    T := Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tsat(p);
    annotation (Inline=true);
  end saturationTemperature;

  redeclare replaceable function extends enthalpyOfSaturatedLiquid
    "Return enthalpy of saturated liquid"
  algorithm
    hl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.hl_p(sat.psat);
    annotation (Inline=true);
  end enthalpyOfSaturatedLiquid;

  redeclare replaceable function extends enthalpyOfSaturatedVapor
    "Return enthalpy of saturated vapor"
  algorithm
    hv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.hv_p(sat.psat);
    annotation (Inline=true);
  end enthalpyOfSaturatedVapor;

  redeclare replaceable function extends enthalpyOfVaporization
    "Return enthalpy of vaporization"
  algorithm
    hlv := enthalpyOfSaturatedVapor(sat)-
      enthalpyOfSaturatedLiquid(sat);
    annotation (Inline=true);
  end enthalpyOfVaporization;

  redeclare replaceable function extends entropyOfSaturatedLiquid
    "Return entropy of saturated liquid"
  algorithm
    sl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.sl_p(
      sat.psat);
    annotation (
      Inline=true);
  end entropyOfSaturatedLiquid;

  redeclare replaceable function extends entropyOfSaturatedVapor
    "Return entropy of saturated vapor"
  algorithm
    sv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.sv_p(sat.psat);
    annotation (Inline=true);
  end entropyOfSaturatedVapor;

  redeclare replaceable function extends entropyOfVaporization
    "Return entropy of vaporization"
  algorithm
    slv := entropyOfSaturatedVapor(sat)-
      entropyOfSaturatedLiquid(sat);
    annotation (Inline=true);
  end entropyOfVaporization;

  redeclare replaceable function extends densityOfSaturatedLiquid
    "Return density of saturated liquid"
  algorithm
    dl := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhol_p(sat.psat)
    annotation (Inline=true);
  end densityOfSaturatedLiquid;

  redeclare replaceable function extends densityOfSaturatedVapor
    "Return density of saturated vapor"
  algorithm
    dv := Modelica.Media.Water.IF97_Utilities.BaseIF97.Regions.rhov_p(sat.psat)
    annotation (Inline=true);
  end densityOfSaturatedVapor;
  // Set state functions
  redeclare function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
  algorithm
    state := ThermodynamicState(
      d=density_pT(p,T),
      T=T,
      h=specificEnthalpy_pT(p,T),
      p=p);
    annotation (Inline=true);
  end setState_pTX;

  redeclare function extends setState_phX
    "Return thermodynamic state as function of p, h and composition X or Xi"
  algorithm
    state := ThermodynamicState(
      d=density_ph(p,h),
      T=temperature_ph(p,h),
      h=h,
      p=p);
    annotation (Inline=true);
  end setState_phX;

  redeclare function extends setState_psX
    "Return thermodynamic state as function of p, s and composition X or Xi"
  algorithm
    state := ThermodynamicState(
      d=density_ps(p,s),
      T=temperature_ps(p,s),
      h=specificEnthalpy_ps(p,s),
      p=p);
    annotation (Inline=true);
  end setState_psX;

  redeclare function extends setState_dTX
    "Return thermodynamic state as function of d, T and composition X or Xi"
  algorithm
    state := ThermodynamicState(
      d=d,
      T=T,
      h=specificEnthalpy_dT(d,T),
      p=pressure_dT(d,T));
    annotation (Inline=true);
  end setState_dTX;

  redeclare function extends setSmoothState
    "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
    extends Modelica.Icons.Function;
    import Modelica.Media.Common.smoothStep;
    input Real x "m_flow or dp";
    input ThermodynamicState state_a "Thermodynamic state if x > 0";
    input ThermodynamicState state_b "Thermodynamic state if x < 0";
    input Real x_small(min=0)
      "Smooth transition in the region -x_small < x < x_small";
    output ThermodynamicState state
      "Smooth thermodynamic state for all x (continuous and differentiable)";
  algorithm
    state := ThermodynamicState(
      p=smoothStep(x,state_a.p,state_b.p,x_small),
      h=smoothStep(x,state_a.h,state_b.h,x_small),
      d=density_ph(smoothStep(x,state_a.p,state_b.p,x_small),
        smoothStep(x,state_a.h,state_b.h,x_small)),
      T=temperature_ph(smoothStep(x,state_a.p,state_b.p,x_small),
        smoothStep(x,state_a.h,state_b.h,x_small)));
    annotation (
      Inline=true,
      Documentation(
        info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    state = <strong>if</strong> x &gt; 0 <strong>then</strong> state_a <strong>else</strong> state_b;
</pre>
<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>
<pre>
   state := <strong>smooth</strong>(1, <strong>if</strong> x &gt;  x_small <strong>then</strong> state_a <strong>else</strong>
                      <strong>if</strong> x &lt; -x_small <strong>then</strong> state_b <strong>else</strong> f(state_a, state_b));
</pre>
<p>
This is performed by applying function <strong>Media.Common.smoothStep</strong>(..)
on every element of the thermodynamic state record.
</p>
<p>
If <strong>mass fractions</strong> X[:] are approximated with this function then this can be performed
for all <strong>nX</strong> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(state.X) = 1, provided sum(state_a.X) = sum(state_b.X) = 1.
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise state.X is either state_a.X or state_b.X):
</p>
<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>
<p>
or
</p>
<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>
<p>
Summing all mass fractions together results in
</p>
<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>
</html>"));
  end setSmoothState;

  redeclare replaceable function extends saturationState
    "Return saturation property record from pressure"
  algorithm
    sat.psat := p;
    sat.Tsat := saturationTemperature(p);
    annotation (
      smoothOrder=2,
      Documentation(
        info="<html>
    <p>
    Returns the saturation state for given pressure. This relation is
    valid in the region of <i>0</i> to <i>800</i> C (<i>0</i> to <i>100</i> MPa).
    This corresponds to Region 2 of the IAPWS-IF97 water medium models.
    </p>
</html>",
        revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
  end saturationState;
//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Models generally have no need to access them.
// Therefore, they are made protected. This also allows to redeclare the
// medium model with another medium model that does not provide an
// implementation of these classes.
protected
  function rho_pT
    "Density as function or pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output Density rho "Density";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    g := g2(p,T);
    rho := p/(R*T*g.pi*g.gpi);
    annotation (
      smoothOrder=2,
      Inline=true);
  end rho_pT;

  function h_pT
    "Specific enthalpy as function or pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEnthalpy h "Specific enthalpy";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    g := g2(p,T);
    h := R*T*g.tau*g.gtau;
    annotation (
      smoothOrder=2,
      Inline=true);
  end h_pT;

  function s_pT
    "Specific entropy as function or pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificEntropy s "Specific entropy";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    g := g2(p,T);
    s := R*(g.tau*g.gtau-g.g);
    annotation (
      smoothOrder=2,
      Inline=true);
  end s_pT;

  function cp_pT
    "Specific heat capacity at constant pressure as function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificHeatCapacity cp "Specific heat capacity";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Integer error
      "Error flag for inverse iterations";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    g := g2(p,T);
    cp :=-R*g.tau*g.tau*g.gtautau;
    annotation (
      smoothOrder=2,
      Inline=true);
  end cp_pT;

  function cv_pT
    "Specific heat capacity at constant volume as function of pressure and temperature"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    output SpecificHeatCapacity cv "Specific heat capacity";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Integer error
      "Error flag for inverse iterations";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    g := g2(p,T);
    cv := R*(-g.tau*g.tau*g.gtautau+((g.gpi-g.tau*g.gtaupi)*(g.gpi-g.tau*g.gtaupi)/g.gpipi));
    annotation (
      smoothOrder=2,
      Inline=true,
      LateInline = true,
      Documentation(info="<html>
<p>
Specific heat at constant volume is computed from temperature and
<code>p_default</code> using the IAPWS-IF97 relationship via the Gibbs
free energy for region 2.
</p>
</html>", revision=
         "<html>
<ul>
<li>
December 6, 2020, by Michael Wetter:<br/>
Added <code>LateInline=true</code>.
This is required for OCT-r17595_JM-r14295, otherwise
<a href=\"modelica://Buildings.Media.Examples.SteamDerivativeCheck\">
Buildings.Media.Examples.SteamDerivativeCheck</a>
does not translate.
</li>
</ul>
</html>"));
  end cv_pT;

  function T_ph
    "Temperature as function or pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Temperature T "Temperature";
  algorithm
    // Region 2 properties
    T := tph2(p,h);
    annotation (
      smoothOrder=2,
      Inline=true);
  end T_ph;

  function rho_ph
    "Density as function or pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output Density rho "Density";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Temperature T
      "Temperature";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    T := T_ph(p,h);
    g := g2(p,T);
    rho := p/(R*T*g.pi*g.gpi);
    annotation (
      smoothOrder=2,
      Inline=true);
  end rho_ph;

  function s_ph
    "Specific entropy as function or pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output SpecificEntropy s "Specific entropy";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Temperature T
      "Temperature";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    T := T_ph(p,h);
    g := g2(p,T);
    s := R*(g.tau*g.gtau-g.g);
    annotation (
      smoothOrder=2,
      Inline=true);
  end s_ph;

  function cp_ph
    "Specific heat capacity at constant pressure as function of pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output SpecificHeatCapacity cp "Specific heat capacity";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Temperature T
      "Temperature";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    T := T_ph(p,h);
    g := g2(p,T);
    cp :=-R*g.tau*g.tau*g.gtautau;
    annotation (
      smoothOrder=2,
      Inline=true);
  end cp_ph;

  function cv_ph
    "Specific heat capacity at constant volume as function of pressure and enthalpy"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthalpy";
    output SpecificHeatCapacity cv "Specific heat capacity";
  protected
    Modelica.Media.Common.GibbsDerivs g
      "Dimensionless Gibbs function and derivatives w.r.t. pi and tau";
    SpecificHeatCapacity R
      "Specific gas constant of water vapor";
    Temperature T
      "Temperature";
  algorithm
    R := Modelica.Media.Water.IF97_Utilities.BaseIF97.data.RH2O;
    // Region 2 properties
    T := T_ph(p,h);
    g := g2(p,T);
    cv := R*(-g.tau*g.tau*g.gtautau+((g.gpi-g.tau*g.gtaupi)*(g.gpi-g.tau*g.gtaupi)/g.gpipi));
    annotation (
      smoothOrder=2,
      Inline=true);
  end cv_ph;

  function tph2
    "Reverse function for region 2: T(p,h)"
    extends Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.tph2;
    annotation (
      smoothOrder=1,
      Inline=true);
  end tph2;

  function g2
    "Gibbs function for region 2: g(p,T)"
    extends Modelica.Media.Water.IF97_Utilities.BaseIF97.Basic.g2;
    annotation (
      smoothOrder=1,
      Inline=true);
  end g2;
  annotation (
    Documentation(
      info="<html>
<p><b><span style=\"font-size: 11pt; color: #ff0000;\">This model is a 
beta version and is not fully validated yet. </span></b></p>
<p>This steam model based on IF97 formulations can be utilized for 
water systems and components that require vapor phase (regeion 2, 
quality = 1). This model design is largely copied from <a 
href=\"modelica://Modelica.Media.Water.WaterIF97_R2pT\">Modelica.Media.Water.WaterIF97_R2pT</a>, with the following main differences: </p>
<ol>
<li>Only the functions related to region 2 are included.</li>
<li>Automatic differentiation is provided for all thermodynamic property functions.</li>
<li>The implementation is generally simplier in order to increase the 
likelyhood of more efficient simulations. </li>
</ol>
<p>Thermodynamic properties are formulated from the International 
Association for the Properties of Water and Steam (IAPWS) 1997 
forumulations for water and steam. The thermodynamic regions as 
determiend by IAPWS-IF97 are as follows: </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Media/Steam/SteamIF97Region2.PNG\" 
alt=\"IF97 Water Steam Region 2\"/> </p>
<h4>Limitations </h4>
<ul>
<li>The properties are valid in Region 2 shown above. The valid temperature 
range is <i>0 C &le; T &le; 800 C</i>, and the valid pressure range 
is <i>0 MPa &le; p &le; 100 MPa</i>. </li>
<li>When phase change is required, this model is to be used in combination 
with the <a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a> 
media model for incompressible liquid water for the liquid phase (quality = 0). </li>
<li>The two-phase region 3 (e.g., mixed liquid and vapor), high temperature 
region 5, and liquid region 1 are not included in this medium model. </li>
</ul>
<h4>Applications </h4>
<p>For numerical robustness, applications of this medium model assume the 
pressure, and hence the saturation pressure, is constant throughout the 
simulation. This is done to improve simulation performance by decoupling 
the pressure drop and energy balance calculations. </p>
<h4>References </h4>
<p>W. Wagner et al., &ldquo;The IAPWS industrial formulation 1997 for the 
thermodynamic properties of water and steam,&rdquo; <i>J. Eng. Gas Turbines 
Power</i>, vol. 122, no. 1, pp. 150&ndash;180, 2000. </p>
</html>",
      revisions="<html>
<ul>
<li>
May 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Line(
          points={{50,30},{30,10},{50,-10},{30,-30}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{10,30},{-10,10},{10,-10},{-10,-30}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-30,30},{-50,10},{-30,-10},{-50,-30}},
          color={0,0,0},
          smooth=Smooth.Bezier)}));
end Steam;
