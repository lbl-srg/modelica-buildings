within Buildings.Media.Antifreeze;
package PropyleneGlycolWater
  "Package with model for propylene glycol - water with constant properties"
  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="PropyleneGlycolWater(X_a = " + String(X_a) + ", property_T = "
         + String(property_T) + ")",
    final cp_const=
      Functions.PropyleneGlycolWater.specificHeatCapacityCp_TX_a(
        T=property_T, X_a=X_a),
    final cv_const=cp_const,
    final d_const=
      Functions.PropyleneGlycolWater.density_TX_a(
        T=property_T, X_a=X_a),
    final eta_const=
      Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(
        T=property_T, X_a=X_a),
    final lambda_const=
      Functions.PropyleneGlycolWater.thermalConductivity_TX_a(T=property_T, X_a=X_a),
    a_const=1484,
    final T_min=
      Functions.PropyleneGlycolWater.fusionTemperature_TX_a(
        T=property_T, X_a=X_a),
    T_max=Modelica.Units.Conversions.from_degC(100),
    T0=273.15,
    MM_const=(X_a/simplePropyleneGlycolWaterConstants[1].molarMass + (1 - X_a)/
        0.018015268)^(-1),
    fluidConstants=simplePropyleneGlycolWaterConstants,
    p_default=300000,
    reference_p=300000,
    reference_T=273.15,
    reference_X={1},
    AbsolutePressure(start=p_default),
    Temperature(start=T_default),
    Density(start=d_const));

  constant Modelica.Units.SI.Temperature property_T
    "Temperature for evaluation of constant fluid properties";
  constant Modelica.Units.SI.MassFraction X_a
    "Mass fraction of propylene glycol in water";

  redeclare model BaseProperties "Base properties"
    Temperature T(stateSelect=
      if preferredMediumStates then StateSelect.prefer else StateSelect.default)
      "Temperature of medium";

    InputAbsolutePressure p "Absolute pressure of medium";
    InputMassFraction[nXi] Xi=fill(0, 0)
      "Structurally independent mass fractions";
    InputSpecificEnthalpy h "Specific enthalpy of medium";
    Modelica.Units.SI.SpecificInternalEnergy u
      "Specific internal energy of medium";
    Modelica.Units.SI.Density d=d_const "Density of medium";
    Modelica.Units.SI.MassFraction[nX] X={1}
      "Mass fractions (= (component mass)/total mass  m_i/m)";
    final Modelica.Units.SI.SpecificHeatCapacity R_s=0
      "Gas constant (of mixture if applicable)";
    final Modelica.Units.SI.MolarMass MM=MM_const
      "Molar mass (of mixture or single fluid)";
    ThermodynamicState state
      "Thermodynamic state record for optional functions";
    parameter Boolean preferredMediumStates=false
      "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
      annotation(Evaluate=true, Dialog(tab="Advanced"));
    final parameter Boolean standardOrderComponents=true
      "If true, and reducedX = true, the last element of X will be computed from the other ones";
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

  equation
  assert(T >= T_min, "
In "   + getInstanceName() + ": Temperature T exceeded its minimum allowed value of " + String(T_min-273.15)
    + " degC (" + String(T_min) + " Kelvin)
as required from medium model \"" + mediumName + "\".");
  assert(T <= T_max, "
In "   + getInstanceName() + ": Temperature T exceeded its maximum allowed value of " + String(T_max-273.15)
    + " degC (" + String(T_max) + " Kelvin)
as required from medium model \"" + mediumName + "\".");

  assert(X_a >= X_a_min, "
In "   + getInstanceName() + ": Mass fraction x_a exceeded its minimum allowed value of " + String(X_a_min) + "
as required from medium model \"" + mediumName + "\".");
  assert(X_a <= X_a_max, "
In "   + getInstanceName() + ": Mass fraction x_a exceeded its maximum allowed value of " + String(X_a_max) + "
as required from medium model \"" + mediumName + "\".");

    h = cp_const*(T-reference_T);
    u = h;
    state.T = T;
    state.p = p;

    annotation(Documentation(info="<html>
    <p>
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>u = cv_const*(T - reference_T)</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    Also, the model checks if the mass fraction of the mixture is within the
    allowed limits.
    </p>
</html>"));
  end BaseProperties;
protected
  constant Modelica.Units.SI.MassFraction X_a_min=0.
    "Minimum allowed mass fraction of propylene glycol in water";
  constant Modelica.Units.SI.MassFraction X_a_max=0.6
    "Maximum allowed mass fraction of propylene glycol in water";

  // Fluid constants based on pure Propylene Glycol
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simplePropyleneGlycolWaterConstants(
    each chemicalFormula="C3H8O2",
    each structureFormula="CH3CH(OH)CH2OH",
    each casRegistryNumber="57-55-6",
    each iupacName="1,2-Propylene glycol",
    each molarMass=0.07609);

annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models propylene glycol - water mixtures.
</p>
<p>
The mass density, specific heat capacity, thermal conductivity and viscosity
are assumed constant and evaluated at a set temperature and mass fraction of
propylene glycol within the mixture. The dependence of the four properties
are shown on the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterProperties.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The accuracy of the thermophysical properties is dependent on the temperature
variations encountered during simulations.
The figure below shows the relative error of the the four properties over a
<i>10</i> &deg;C range around the temperature used to evaluate the constant
properties. The maximum errors are <i>0.8</i> % for mass density, <i>1.5</i> %
for specific heat capacity, <i>3.2</i> % for thermal conductivity and <i>250</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError10degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The figure below shows the relative error of the the four properties over a
<i>20</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>1.6</i> % for mass density, <i>3.0</i> %
for specific heat capacity, <i>6.2</i> % for thermal conductivity and <i>950</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/PropyleneGlycolWaterError20degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
The propylene glycol/water mixture is modeled as an incompressible liquid.
There are no phase changes. The medium is limited to temperatures below
<i>100</i> &deg;C and mass fractions below <i>0.60</i>.
As is the case for <a href=\"modelica://Buildings.Media.Water\">Buildings.Media.Water</a>,
this medium package should not be used if
the simulation relies on the dynamic viscosity.
</p>
<h4>Typical use and important parameters</h4>
<p>
The temperature and mass fraction must be specified for the evaluation of the
constant thermophysical properties. A typical use of the package is (e.g. for
a temperature of <i>20</i> &deg;C and a mass fraction of <i>0.40</i>):
</p>
<p>
<code>Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)</code>
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2026, by Michael Wetter:<br/>
Refactored implementation to use media properties from function calls in the package
<a href=\"modelica://Buildings.Media.Antifreeze.Functions\">
Buildings.Media.Antifreeze.Functions</a> while avoiding code dublication.
</li>
<li>
October 26, 2018, by Filip Jorissen and Michael Wetter:<br/>
Now printing different messages if temperature or mass fraction is above or below its limit,
and adding instance name as JModelica does not print the full instance name in the assertion.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1045\">#1045</a>.
</li>
<li>
March 16, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end PropyleneGlycolWater;
