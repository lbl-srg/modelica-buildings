within Buildings.Media;
package Air
  "Package with moist air model that decouples pressure and temperature"
  extends Modelica.Media.Interfaces.PartialCondensingGases(
     mediumName="Air",
     final substanceNames={"water", "air"},
     final reducedX=true,
     final singleState = false,
     reference_X={0.01,0.99},
     final fluidConstants = {Modelica.Media.IdealGases.Common.FluidData.H2O,
                             Modelica.Media.IdealGases.Common.FluidData.N2},
     reference_T=273.15,
     reference_p=101325,
     AbsolutePressure(start=p_default),
     Temperature(start=T_default));
  extends Modelica.Icons.Package;

  constant Integer Water=1
    "Index of water (in substanceNames, massFractions X, etc.)";
  constant Integer Air=2
    "Index of air (in substanceNames, massFractions X, etc.)";

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

  constant Modelica.Units.SI.MolarMass[2] MMX={steam.MM,dryair.MM}
    "Molar masses of components";

  constant AbsolutePressure pStp = reference_p
    "Pressure for which fluid density is defined";
  constant Density dStp = 1.2 "Fluid density at pressure pStp";

  // Redeclare ThermodynamicState to avoid the warning
  // "Base class ThermodynamicState is replaceable"
  // during model check
  redeclare record extends ThermodynamicState
    "ThermodynamicState record for moist air"
  end ThermodynamicState;
  // There must not be any stateSelect=StateSelect.prefer for
  // the pressure.
  // Otherwise, translateModel("Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ResistanceVolume")
  // will fail as Dymola does an index reduction and outputs
  //   Differentiated the equation
  //   vol.dynBal.medium.p+res.dp-inlet.p = 0.0;
  //   giving
  //   der(vol.dynBal.medium.p)+der(res.dp) = der(inlet.p);
  //
  //   The model requires derivatives of some inputs as listed below:
  //   1 inlet.m_flow
  //   1 inlet.p
  // Therefore, the statement
  //   p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
  // has been removed.
  redeclare replaceable model BaseProperties "Base properties (p, d, T, h, u, R, MM and X and Xi) of a medium"

  parameter Boolean preferredMediumStates=false
    "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  final parameter Boolean standardOrderComponents=true
    "If true, and reducedX = true, the last element of X will be computed from the other ones";

  InputAbsolutePressure p "Absolute pressure of medium";
  InputMassFraction[1] Xi(
    start=reference_X[1:1],
    nominal={0.01},
    each stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
    "Structurally independent mass fractions";
  InputSpecificEnthalpy h "Specific enthalpy of medium";
  Modelica.Media.Interfaces.Types.Density d "Density of medium";
  Modelica.Media.Interfaces.Types.Temperature T(
   stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)
   "Temperature of medium";
  Modelica.Media.Interfaces.Types.MassFraction[2] X(
    start=reference_X,
    nominal={0.01, 1})
    "Mass fractions (= (component mass)/total mass  m_i/m)";
  Modelica.Media.Interfaces.Types.SpecificInternalEnergy u
    "Specific internal energy of medium";
  Modelica.Media.Interfaces.Types.SpecificHeatCapacity R_s
    "Gas constant (of mixture if applicable)";
  Modelica.Media.Interfaces.Types.MolarMass MM
    "Molar mass (of mixture or single fluid)";
  ThermodynamicState state(
    X(nominal={0.01, 1})
    )
    "Thermodynamic state record for optional functions";

    Modelica.Units.NonSI.Temperature_degC T_degC=
        Modelica.Units.Conversions.to_degC(T) "Temperature of medium in [degC]";
    Modelica.Units.NonSI.Pressure_bar p_bar=Modelica.Units.Conversions.to_bar(p)
      "Absolute pressure of medium in [bar]";

  // Local connector definition, used for equation balancing check
  connector InputAbsolutePressure = input Modelica.Units.SI.AbsolutePressure
    "Pressure as input signal connector";
  connector InputSpecificEnthalpy = input Modelica.Units.SI.SpecificEnthalpy
    "Specific enthalpy as input signal connector";
  connector InputMassFraction = input Modelica.Units.SI.MassFraction
    "Mass fraction as input signal connector";

    // Declarations for Air only
  protected
    Modelica.Units.SI.TemperatureDifference dT(start=T_default - reference_T)
      "Temperature difference used to compute enthalpy";

  equation
    MM = 1/(X[1]/steam.MM+(X[2])/dryair.MM);

    dT = T - reference_T;
    h = dT*dryair.cp * X[2] +
       (dT * steam.cp + h_fg) * X[1];
    R_s = dryair.R*X[2] + steam.R*X[1];

    // Equation for ideal gas, from h=u+p*v and R*T=p*v, from which follows that  u = h-R*T.
    // u = h-R*T;
    // However, in this medium, the gas law is d/dStp=p/pStp, from which follows using h=u+pv that
    // u= h-p*v = h-p/d = h-pStp/dStp
    u = h-pStp/dStp;

    // In this medium model, the density depends only
    // on temperature, but not on pressure.
    //  d = p/(R*T);
    d/dStp = p/pStp;

    state.p = p;
    state.T = T;
    state.X = X;

    X[1] = Xi[1];
    X[2] = 1 - X[1];

    // Assertions to test for bounds
    assert(noEvent(X[1] >= -1.e-5) and noEvent(X[1] <= 1 + 1.e-5), "Mass fraction X[1] = " + String(X[1]) + " of substance water"
      + "\nof medium \"Buildings.Media.Air\" is not in the range 0..1");

    assert(noEvent(T >= 200.0), "In "   + getInstanceName() + ": Temperature T exceeded its minimum allowed value of -73.15 degC (200 Kelvin)
as required from medium model \"Buildings.Media.Air\".");
    assert(noEvent(T <= 423.15), "In "   + getInstanceName() + ": Temperature T exceeded its maximum allowed value of 150 degC (423.15 Kelvin)
as required from medium model \"Buildings.Media.Air\".");

  assert(noEvent(p >= 0.0), "Pressure (= " + String(p) + " Pa) of medium \"Buildings.Media.Air\" is negative\n(Temperature = " + String(T) + " K)");
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255}), Text(
          extent={{-152,164},{152,102}},
          textString="%name",
          textColor={0,0,255})}), Documentation(info="<html>
<p>
Model with basic thermodynamic properties.
</p>
<p>
This model provides equation for the following thermodynamic properties:
</p>
<table border=\"1\" cellspacing=\"0\" cellpadding=\"2\" summary=\"Thermodynamic properties\">
  <tr><td><strong>Variable</strong></td>
      <td><strong>Unit</strong></td>
      <td><strong>Description</strong></td></tr>
  <tr><td>T</td>
      <td>K</td>
      <td>temperature</td></tr>
  <tr><td>p</td>
      <td>Pa</td>
      <td>absolute pressure</td></tr>
  <tr><td>d</td>
      <td>kg/m3</td>
      <td>density</td></tr>
  <tr><td>h</td>
      <td>J/kg</td>
      <td>specific enthalpy</td></tr>
  <tr><td>u</td>
      <td>J/kg</td>
      <td>specific internal energy</td></tr>
  <tr><td>Xi[nXi]</td>
      <td>kg/kg</td>
      <td>independent mass fractions m_i/m</td></tr>
  <tr><td>R</td>
      <td>J/kg.K</td>
      <td>gas constant</td></tr>
  <tr><td>M</td>
      <td>kg/mol</td>
      <td>molar mass</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
September 22, 2020, by Michael Wetter:<br/>
First implementation based on Modelica Standard Library,
but with <code>noEvent</code> added to check of bounds.
</li>
</ul>
</html>"));
  end BaseProperties;

redeclare function density "Gas density"
  extends Modelica.Icons.Function;
  input ThermodynamicState state;
  output Density d "Density";
algorithm
  d :=state.p*dStp/pStp;
  annotation(smoothOrder=5,
  Inline=true,
  Documentation(info="<html>
Density is computed from pressure, temperature and composition in the thermodynamic state record applying the ideal gas law.
</html>"));
end density;

redeclare function extends dynamicViscosity
    "Return the dynamic viscosity of dry air"
algorithm
  eta := 4.89493640395e-08 * state.T + 3.88335940547e-06;
  annotation (
  smoothOrder=99,
  Inline=true,
Documentation(info="<html>
<p>
This function returns the dynamic viscosity.
</p>
<h4>Implementation</h4>
<p>
The function is based on the 5th order polynomial
of
<a href=\"modelica://Modelica.Media.Air.MoistAir.dynamicViscosity\">
Modelica.Media.Air.MoistAir.dynamicViscosity</a>.
However, for the typical range of temperatures encountered
in building applications, a linear function sufficies.
This implementation is therefore the above 5th order polynomial,
linearized around <i>20</i>&deg;C.
The relative error of this linearization is
<i>0.4</i>% at <i>-20</i>&deg;C,
and less then
<i>0.2</i>% between  <i>-5</i>&deg;C and  <i>+50</i>&deg;C.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 19, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end dynamicViscosity;

redeclare function enthalpyOfCondensingGas
    "Enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;

  input Temperature T "temperature";
  output SpecificEnthalpy h "steam enthalpy";
algorithm
  h := (T-reference_T) * steam.cp + h_fg;
  annotation(smoothOrder=5,
  Inline=true,
  derivative=der_enthalpyOfCondensingGas);
end enthalpyOfCondensingGas;

redeclare replaceable function extends enthalpyOfGas
    "Enthalpy of gas mixture per unit mass of gas mixture"
algorithm
  h := enthalpyOfCondensingGas(T)*X[Water]
       + enthalpyOfDryAir(T)*(1.0-X[Water]);
annotation (
  Inline=true);
end enthalpyOfGas;

redeclare replaceable function extends enthalpyOfLiquid
    "Enthalpy of liquid (per unit mass of liquid) which is linear in the temperature"
algorithm
  h := (T - reference_T)*cpWatLiq;
  annotation (
    smoothOrder=5,
    Inline=true,
    derivative=der_enthalpyOfLiquid);
end enthalpyOfLiquid;

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

redeclare function extends enthalpyOfVaporization
    "Enthalpy of vaporization of water"
algorithm
  r0 := h_fg;
  annotation (
    Inline=true);
end enthalpyOfVaporization;

redeclare function extends gasConstant
    "Return ideal gas constant as a function from thermodynamic state, only valid for phi<1"

algorithm
    R_s := dryair.R*(1 - state.X[Water]) + steam.R*state.X[Water];
  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
The ideal gas constant for moist air is computed from <a href=\"modelica://Modelica.Media.Air.MoistAir.ThermodynamicState\">thermodynamic state</a> assuming that all water is in the gas phase.
</html>"));
end gasConstant;

redeclare function extends pressure
    "Returns pressure of ideal gas as a function of the thermodynamic state record"

algorithm
  p := state.p;
  annotation (
  smoothOrder=2,
  Inline=true,
  Documentation(info="<html>
Pressure is returned from the thermodynamic state record input as a simple assignment.
</html>"));
end pressure;

redeclare function extends isobaricExpansionCoefficient
    "Isobaric expansion coefficient beta"
algorithm
  beta := 0;
  annotation (
    smoothOrder=5,
    Inline=true,
Documentation(info="<html>
<p>
This function returns the isobaric expansion coefficient at constant pressure,
which is zero for this medium.
The isobaric expansion coefficient at constant pressure is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&beta;<sub>p</sub> = - 1 &frasl; v &nbsp; (&part; v &frasl; &part; T)<sub>p</sub> = 0,
</p>
<p>
where
<i>v</i> is the specific volume,
<i>T</i> is the temperature and
<i>p</i> is the pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isobaricExpansionCoefficient;

redeclare function extends isothermalCompressibility
    "Isothermal compressibility factor"
algorithm
  kappa := -1/state.p;
  annotation (
    smoothOrder=5,
    Inline=true,
    Documentation(info="<html>
<p>
This function returns the isothermal compressibility coefficient.
The isothermal compressibility is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&kappa;<sub>T</sub> = -1 &frasl; v &nbsp; (&part; v &frasl; &part; p)<sub>T</sub>
  = -1 &frasl; p,
</p>
<p>
where
<i>v</i> is the specific volume,
<i>T</i> is the temperature and
<i>p</i> is the pressure.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isothermalCompressibility;

redeclare function extends saturationPressure
    "Saturation curve valid for 223.16 <= T <= 373.16 (and slightly outside with less accuracy)"

algorithm
  psat := Buildings.Utilities.Psychrometrics.Functions.saturationPressure(Tsat);
  annotation (
  smoothOrder=5,
  Inline=true);
end saturationPressure;

redeclare function extends specificEntropy
    "Return the specific entropy, only valid for phi<1"

  protected
    Modelica.Units.SI.MoleFraction[2] Y "Molar fraction";
algorithm
    Y := massToMoleFractions(
         state.X, {steam.MM,dryair.MM});
    s := specificHeatCapacityCp(state) * Modelica.Math.log(state.T/reference_T)
         - Modelica.Constants.R *
         sum(state.X[i]/MMX[i]*
             Modelica.Math.log(max(Y[i], Modelica.Constants.eps)*state.p/reference_p) for i in 1:2);
  annotation (
  Inline=true,
    Documentation(info="<html>
<p>
This function computes the specific entropy.
</p>
<p>
The specific entropy of the mixture is obtained from
</p>
<p align=\"center\" style=\"font-style:italic;\">
s = s<sub>s</sub> + s<sub>m</sub>,
</p>
<p>
where
<i>s<sub>s</sub></i> is the entropy change due to the state change
(relative to the reference temperature) and
<i>s<sub>m</sub></i> is the entropy change due to mixing
of the dry air and water vapor.
</p>
<p>
The entropy change due to change in state is obtained from
</p>
<p align=\"center\" style=\"font-style:italic;\">
s<sub>s</sub> = c<sub>v</sub> ln(T/T<sub>0</sub>) + R ln(v/v<sub>0</sub>) <br/>
= c<sub>v</sub> ln(T/T<sub>0</sub>) + R ln(&rho;<sub>0</sub>/&rho;)
</p>
<p>If we assume <i>&rho; = p<sub>0</sub>/(R T)</i>,
and because <i>c<sub>p</sub> = c<sub>v</sub> + R</i>,
we can write
</p>
<p align=\"center\" style=\"font-style:italic;\">
s<sub>s</sub> = c<sub>v</sub> ln(T/T<sub>0</sub>) + R ln(T/T<sub>0</sub>) <br/>
=c<sub>p</sub> ln(T/T<sub>0</sub>).
</p>
<p>
Next, the entropy of mixing is obtained from a reversible isothermal
expansion process. Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  s<sub>m</sub> = -R &sum;<sub>i</sub>( X<sub>i</sub> &frasl; M<sub>i</sub>
  ln(Y<sub>i</sub> p/p<sub>0</sub>)),
</p>
<p>
where <i>R</i> is the gas constant,
<i>X</i> is the mass fraction,
<i>M</i> is the molar mass, and
<i>Y</i> is the mole fraction.
</p>
<p>
To obtain the state for a given pressure, entropy and mass fraction, use
<a href=\"modelica://Buildings.Media.Air.setState_psX\">
Buildings.Media.Air.setState_psX</a>.
</p>
<h4>Limitations</h4>
<p>
This function is only valid for a relative humidity below 100%.
</p>
</html>", revisions="<html>
<ul>
<li>
November 27, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end specificEntropy;

redeclare function extends density_derp_T
    "Return the partial derivative of density with respect to pressure at constant temperature"
algorithm
  ddpT := dStp/pStp;
  annotation (
  Inline=true,
Documentation(info="<html>
<p>
This function returns the partial derivative of density
with respect to pressure at constant temperature.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_derp_T;

redeclare function extends density_derT_p
    "Return the partial derivative of density with respect to temperature at constant pressure"
algorithm
  ddTp := 0;

  annotation (
  smoothOrder=99,
  Inline=true,
  Documentation(info=
"<html>
<p>
This function computes the derivative of density with respect to temperature
at constant pressure.
</p>
</html>", revisions=
"<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_derT_p;

redeclare function extends density_derX
    "Return the partial derivative of density with respect to mass fractions at constant pressure and temperature"
algorithm
  dddX := fill(0, nX);
annotation (
  smoothOrder=99,
  Inline=true,
  Documentation(info="<html>
<p>
This function returns the partial derivative of density
with respect to mass fraction.
This value is zero because in this medium, density is proportional
to pressure, but independent of the species concentration.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_derX;

redeclare replaceable function extends specificHeatCapacityCp
    "Specific heat capacity of gas mixture at constant pressure"
algorithm
  cp := dryair.cp*(1-state.X[Water]) +steam.cp*state.X[Water];
    annotation (
  smoothOrder=99,
  Inline=true,
  derivative=der_specificHeatCapacityCp);
end specificHeatCapacityCp;

redeclare replaceable function extends specificHeatCapacityCv
    "Specific heat capacity of gas mixture at constant volume"
algorithm
  cv:= dryair.cv*(1-state.X[Water]) +steam.cv*state.X[Water];
  annotation (
    smoothOrder=99,
    Inline=true,
    derivative=der_specificHeatCapacityCv);
end specificHeatCapacityCv;

redeclare function setState_dTX
    "Return thermodynamic state as function of density d, temperature T and composition X"
  extends Modelica.Icons.Function;
  input Density d "Density";
  input Temperature T "Temperature";
  input MassFraction X[:]=reference_X "Mass fractions";
  output ThermodynamicState state "Thermodynamic state";

algorithm
    // Note that d/dStp = p/pStp, hence p = d*pStp/dStp
    state := if size(X, 1) == nX then
               ThermodynamicState(p=d*pStp/dStp, T=T, X=X)
             else
               ThermodynamicState(p=d*pStp/dStp,
                                  T=T,
                                  X=cat(1, X, {1 - sum(X)}));
    annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
<p>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">thermodynamic state record</a>
    is computed from density <code>d</code>, temperature <code>T</code> and composition <code>X</code>.
</p>
</html>"));
end setState_dTX;

redeclare function extends setState_phX
    "Return thermodynamic state as function of pressure p, specific enthalpy h and composition X"
algorithm
  state := if size(X, 1) == nX then
    ThermodynamicState(p=p, T=temperature_phX(p, h, X), X=X)
 else
    ThermodynamicState(p=p, T=temperature_phX(p, h, X), X=cat(1, X, {1 - sum(X)}));
  annotation (
  smoothOrder=2,
  Inline=true,
  Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">
thermodynamic state record</a> is computed from pressure p, specific enthalpy h and composition X.
</html>"));
end setState_phX;

redeclare function extends setState_pTX
    "Return thermodynamic state as function of p, T and composition X or Xi"
algorithm
    state := if size(X, 1) == nX then
                ThermodynamicState(p=p, T=T, X=X)
             else
                ThermodynamicState(p=p, T=T, X=cat(1, X, {1 - sum(X)}));
    annotation (
  smoothOrder=2,
  Inline=true,
  Documentation(info="<html>
The <a href=\"modelica://Modelica.Media.Interfaces.PartialMixtureMedium.ThermodynamicState\">
thermodynamic state record</a> is computed from pressure p, temperature T and composition X.
</html>"));
end setState_pTX;

redeclare function extends setState_psX
    "Return the thermodynamic state as function of p, s and composition X or Xi"
  protected
    Modelica.Units.SI.MassFraction[2] X_int "Mass fraction";
    Modelica.Units.SI.MoleFraction[2] Y "Molar fraction";
    Modelica.Units.SI.Temperature T "Temperature";
algorithm
    if size(X, 1) == nX then
      X_int:=X;
    else
      X_int :=cat(
        1,
        X,
        {1 - sum(X)});
    end if;
   Y := massToMoleFractions(
         X_int, {steam.MM,dryair.MM});
    // The next line is obtained from symbolic solving the
    // specificEntropy function for T.
    // In this formulation, we can set T to any value when calling
    // specificHeatCapacityCp as cp does not depend on T.
    T := 273.15 * Modelica.Math.exp((s + Modelica.Constants.R *
           sum(X_int[i]/MMX[i]*
             Modelica.Math.log(max(Y[i], Modelica.Constants.eps)) for i in 1:2))
             / specificHeatCapacityCp(setState_pTX(p=p,
                                                   T=273.15,
                                                   X=X_int)));

    state := ThermodynamicState(p=p,
                                T=T,
                                X=X_int);

annotation (
Inline=true,
Documentation(info="<html>
<p>
This function returns the thermodynamic state based on pressure,
specific entropy and mass fraction.
</p>
<p>
The state is computed by symbolically solving
<a href=\"modelica://Buildings.Media.Air.specificEntropy\">
Buildings.Media.Air.specificEntropy</a>
for temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
November 27, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end setState_psX;

redeclare replaceable function extends specificEnthalpy
    "Compute specific enthalpy from pressure, temperature and mass fraction"
algorithm
  h := (state.T - reference_T)*dryair.cp * (1 - state.X[Water]) +
       ((state.T-reference_T) * steam.cp + h_fg) * state.X[Water];
  annotation (
   smoothOrder=5,
   Inline=true);
end specificEnthalpy;

redeclare replaceable function specificEnthalpy_pTX "Specific enthalpy"
  extends Modelica.Icons.Function;
    input Modelica.Units.SI.Pressure p "Pressure";
    input Modelica.Units.SI.Temperature T "Temperature";
    input Modelica.Units.SI.MassFraction X[:] "Mass fractions of moist air";
    output Modelica.Units.SI.SpecificEnthalpy h "Specific enthalpy at p, T, X";

algorithm
  h := specificEnthalpy(setState_pTX(p, T, X));
  annotation(smoothOrder=5,
             Inline=true,
             inverse(T=temperature_phX(p, h, X)),
             Documentation(info="<html>
Specific enthalpy as a function of temperature and species concentration.
The pressure is input for compatibility with the medium models, but the specific enthalpy
is independent of the pressure.
</html>",
revisions="<html>
<ul>
<li>
April 30, 2015, by Filip Jorissen and Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
</ul>
</html>"));
end specificEnthalpy_pTX;

redeclare replaceable function extends specificGibbsEnergy
    "Specific Gibbs energy"
algorithm
  g := specificEnthalpy(state) - state.T*specificEntropy(state);
  annotation (
    Inline=true);
end specificGibbsEnergy;

redeclare replaceable function extends specificHelmholtzEnergy
    "Specific Helmholtz energy"
algorithm
  f := specificEnthalpy(state) - gasConstant(state)*state.T - state.T*specificEntropy(state);
  annotation (
    Inline=true);
end specificHelmholtzEnergy;

redeclare function extends isentropicEnthalpy "Return the isentropic enthalpy"
algorithm
  h_is := specificEnthalpy(setState_psX(
            p=p_downstream,
            s=specificEntropy(refState),
            X=refState.X));
annotation (
  Inline=true,
  Documentation(info="<html>
<p>
This function computes the specific enthalpy for
an isentropic state change from the temperature
that corresponds to the state <code>refState</code>
to <code>reference_T</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isentropicEnthalpy;

redeclare function extends specificInternalEnergy "Specific internal energy"
  extends Modelica.Icons.Function;
algorithm
  u := specificEnthalpy(state) - pStp/dStp;
  annotation (
    Inline=true);
end specificInternalEnergy;

redeclare function extends temperature
    "Return temperature of ideal gas as a function of the thermodynamic state record"
algorithm
  T := state.T;
  annotation (
  smoothOrder=2,
  Inline=true,
  Documentation(info="<html>
Temperature is returned from the thermodynamic state record input as a simple assignment.
</html>"));
end temperature;

redeclare function extends molarMass "Return the molar mass"
algorithm
    MM := 1/(state.X[Water]/MMX[Water]+(1.0-state.X[Water])/MMX[Air]);
    annotation (
Inline=true,
smoothOrder=99,
Documentation(info="<html>
<p>
This function returns the molar mass.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end molarMass;

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
</html>",
revisions="<html>
<ul>
<li>
April 30, 2015, by Filip Jorissen and Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
</ul>
</html>"));
end temperature_phX;

redeclare function extends thermalConductivity
    "Thermal conductivity of dry air as a polynomial in the temperature"
algorithm
  lambda :=Modelica.Math.Polynomials.evaluate({(-4.8737307422969E-008),
      7.67803133753502E-005,0.0241814385504202},
      Modelica.Units.Conversions.to_degC(state.T));
annotation(LateInline=true);
end thermalConductivity;
//////////////////////////////////////////////////////////////////////
// Protected classes.
// These classes are only of use within this medium model.
// Models generally have no need to access them.
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
  constant Modelica.Units.SI.SpecificEnergy h_fg=Buildings.Utilities.Psychrometrics.Constants.h_fg
    "Latent heat of evaporation of water";
  constant Modelica.Units.SI.SpecificHeatCapacity cpWatLiq=Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of liquid water";

replaceable function der_enthalpyOfLiquid
    "Temperature derivative of enthalpy of liquid per unit mass of liquid"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of liquid enthalpy";
algorithm
  der_h := cpWatLiq*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfLiquid;

function der_enthalpyOfCondensingGas
    "Derivative of enthalpy of steam per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of steam enthalpy";
algorithm
  der_h := steam.cp*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfCondensingGas;

replaceable function enthalpyOfDryAir
    "Enthalpy of dry air per unit mass of dry air"
  extends Modelica.Icons.Function;

  input Temperature T "Temperature";
  output SpecificEnthalpy h "Dry air enthalpy";
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
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of dry air enthalpy";
algorithm
  der_h := dryair.cp*der_T;
  annotation (
    Inline=true);
end der_enthalpyOfDryAir;

replaceable function der_enthalpyOfNonCondensingGas
    "Derivative of enthalpy of non-condensing gas per unit mass of steam"
  extends Modelica.Icons.Function;
  input Temperature T "Temperature";
  input Real der_T "Temperature derivative";
  output Real der_h "Derivative of steam enthalpy";
algorithm
  der_h := der_enthalpyOfDryAir(T, der_T);
  annotation (
    Inline=true);
end der_enthalpyOfNonCondensingGas;

replaceable function der_specificHeatCapacityCp
    "Derivative of specific heat capacity of gas mixture at constant pressure"
  extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    input ThermodynamicState der_state "Derivative of thermodynamic state";
    output Real der_cp(unit="J/(kg.K.s)")
      "Derivative of specific heat capacity";
algorithm
  der_cp := (steam.cp-dryair.cp)*der_state.X[Water];
  annotation (
    Inline=true);
end der_specificHeatCapacityCp;

replaceable function der_specificHeatCapacityCv
    "Derivative of specific heat capacity of gas mixture at constant volume"
  extends Modelica.Icons.Function;
    input ThermodynamicState state "Thermodynamic state";
    input ThermodynamicState der_state "Derivative of thermodynamic state";
    output Real der_cv(unit="J/(kg.K.s)")
      "Derivative of specific heat capacity";
algorithm
  der_cv := (steam.cv-dryair.cv)*der_state.X[Water];
  annotation (
    Inline=true);
end der_specificHeatCapacityCv;
  annotation(Documentation(info="<html>
<p>
This medium package models moist air using a gas law in which pressure and temperature
are independent, which often leads to significantly faster and more robust computations.
The specific heat capacities at constant pressure and at constant volume are constant.
The air is assumed to be not saturated.
</p>
<p>
This medium uses the gas law
</p>
<p align=\"center\" style=\"font-style:italic;\">
&rho;/&rho;<sub>stp</sub> = p/p<sub>stp</sub>,
</p>
<p>
where
<i>p<sub>std</sub></i> and <i>&rho;<sub>stp</sub></i> are constant reference
temperature and density, rathern than the ideal gas law
</p>
<p align=\"center\" style=\"font-style:italic;\">
&rho; = p &frasl;(R T),
</p>
<p>
where <i>R</i> is the gas constant and <i>T</i> is the temperature.
</p>
<p>
This formulation often leads to smaller systems of nonlinear equations
because equations for pressure and temperature are decoupled.
Therefore, if air inside a control volume such as room air is heated, it
does not increase its specific volume. Consequently, merely heating or cooling
a control volume does not affect the air flow calculations in a duct network
that may be connected to that volume.
Note that multizone air exchange simulation in which buoyancy drives the
air flow is still possible as the models in
<a href=\"modelica://Buildings.Airflow.Multizone\">
Buildings.Airflow.Multizone</a> compute the mass density using the function
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.density_pTX\">
Buildings.Utilities.Psychrometrics.Functions.density_pTX</a> in which density
is a function of temperature.
</p>
<p>
Note that models in this package implement the equation for the internal energy as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p<sub>stp</sub> &frasl; &rho;<sub>stp</sub>,
</p>
<p>
where
<i>u</i> is the internal energy per unit mass,
<i>h</i> is the enthalpy per unit mass,
<i>p<sub>stp</sub></i> is the static pressure and
<i>&rho;<sub>stp</sub></i> is the mass density at standard pressure and temperature.
The reason for this implementation is that in general,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  h = u + p v,
</p>
<p>
from which follows that
</p>
<p align=\"center\" style=\"font-style:italic;\">
  u = h - p v = h - p &frasl; &rho; = h - p<sub>stp</sub> &frasl; &rho;<sub>std</sub>,
</p>
<p>
because <i>p &frasl; &rho; = p<sub>stp</sub> &frasl; &rho;<sub>stp</sub></i> in this medium model.
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C and no water vapor is present.
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
September 28, 2020, by Michael Wetter:<br/>
Reformulated <code>BaseProperties</code> to avoid event-triggering assertions.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1401\">#1401</a>.
</li>
<li>
January 11, 2019 by Michael Wetter:<br/>
Reforulated assignment of <code>X_int</code> in <code>setState_psX</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1079\">#1079</a>.
</li>
<li>
October 26, 2018, by Filip Jorissen and Michael Wetter:<br/>
Now printing different messages if temperature is above or below its limit,
and adding instance name as JModelica does not print the full instance name in the assertion.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">#1045</a>.
</li>
<li>
November 4, 2016, by Michael Wetter:<br/>
Set default value for <code>dT.start</code> in base properties.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/575\">#575</a>.
</li>
<li>
June 6, 2015, by Michael Wetter:<br/>
Set <code>AbsolutePressure(start=p_default)</code> to avoid
a translation error if
<a href=\"modelica://Buildings.Fluid.Sources.Examples.TraceSubstancesFlowSource\">
Buildings.Fluid.Sources.Examples.TraceSubstancesFlowSource</a>
is translated in pedantic mode in Dymola 2016.
The reason is that pressures use <code>Medium.p_default</code> as start values,
but
<a href=\"modelica://Modelica.Media.Interfaces.Types\">
Modelica.Media.Interfaces.Types</a>
sets a default value of <i>1E-5</i>.
A similar change has been done for pressure.
This fixes
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/266\">#266</a>.
</li>
<li>
June 5, 2015, by Michael Wetter:<br/>
Added <code>stateSelect</code> attribute in <code>BaseProperties.T</code>
to allow correct use of <code>preferredMediumState</code> as
described in
<a href=\"modelica://Modelica.Media.Interfaces.PartialMedium\">
Modelica.Media.Interfaces.PartialMedium</a>.
Note that the default is <code>preferredMediumState=false</code>
and hence the same states are used as were used before.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/260\">#260</a>.
</li>
<li>
May 11, 2015, by Michael Wetter:<br/>
Removed
<code>p(stateSelect=if preferredMediumStates then StateSelect.prefer else StateSelect.default)</code>
in declaration of <code>BaseProperties</code>.
Otherwise, when models that contain a fluid volume
are exported as an FMU, their pressure would be
differentiated with respect to time. This would require
the time derivative of the inlet pressure, which is not available,
causing the translation to stop with an error.
</li>
<li>
May 1, 2015, by Michael Wetter:<br/>
Added <code>Inline=true</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/227\">
issue 227</a>.
</li>
<li>
March 20, 2015, by Michael Wetter:<br/>
Added missing term <code>state.p/reference_p</code> in function
<code>specificEntropy</code>.
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/193\">#193</a>.
</li>
<li>
February 3, 2015, by Michael Wetter:<br/>
Removed <code>stateSelect.prefer</code> for temperature.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/160\">#160</a>.
</li>
<li>
July 24, 2014, by Michael Wetter:<br/>
Changed implementation to use
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Constants\">
Buildings.Utilities.Psychrometrics.Constants</a>.
This was done to use consistent values throughout the library.
</li>
<li>
November 16, 2013, by Michael Wetter:<br/>
Revised and simplified the implementation.
</li>
<li>
November 14, 2013, by Michael Wetter:<br/>
Removed function
<code>HeatCapacityOfWater</code>
which is neither needed nor implemented in the
Modelica Standard Library.
</li>
<li>
November 13, 2013, by Michael Wetter:<br/>
Removed non-used computations in <code>specificEnthalpy_pTX</code> and
in <code>temperature_phX</code>.
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
August 3, 2011, by Michael Wetter:<br/>
Fixed bug in <code>u=h-R*T</code>, which is only valid for ideal gases.
For this medium, the function is <code>u=h-pStd/dStp</code>.
</li>
<li>
January 27, 2010, by Michael Wetter:<br/>
Fixed bug in <code>else</code> branch of function <code>setState_phX</code>
that lead to a run-time error when the constructor of this function was called.
</li>
<li>
January 22, 2010, by Michael Wetter:<br/>
Added implementation of function
<a href=\"modelica://Buildings.Media.GasesPTDecoupled.MoistAirUnsaturated.enthalpyOfNonCondensingGas\">
enthalpyOfNonCondensingGas</a> and its derivative.
</li>
<li>
January 13, 2010, by Michael Wetter:<br/>
Fixed implementation of derivative functions.
</li>
<li>
August 28, 2008, by Michael Wetter:<br/>
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
end Air;
