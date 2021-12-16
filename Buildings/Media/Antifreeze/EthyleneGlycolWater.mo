within Buildings.Media.Antifreeze;
package EthyleneGlycolWater
  "Package with model for ethylene glycol - water with constant properties"
  extends Modelica.Media.Interfaces.PartialSimpleMedium(
    mediumName="EthyleneGlycolWater(X_a = " + String(X_a) + ", property_T = "
         + String(property_T) + ")",
    final cp_const=specificHeatCapacityCp_TX_a(T=property_T, X_a=X_a),
    final cv_const=cp_const,
    final d_const=density_TX_a(T=property_T, X_a=X_a),
    final eta_const=dynamicViscosity_TX_a(T=property_T, X_a=X_a),
    final lambda_const=thermalConductivity_TX_a(T=property_T, X_a=X_a),
    a_const=1484,
    final T_min=fusionTemperature_TX_a(T=property_T, X_a=X_a),
    T_max=Modelica.Units.Conversions.from_degC(100),
    T0=273.15,
    MM_const=(X_a/simpleEthyleneGlycolWaterConstants[1].molarMass + (1 - X_a)/
        0.018015268)^(-1),
    fluidConstants=simpleEthyleneGlycolWaterConstants,
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
    "Minimum allowed mass fraction of ethylene glycol in water";
  constant Modelica.Units.SI.MassFraction X_a_max=0.6
    "Maximum allowed mass fraction of propylene glycol in water";

  // Fluid constants based on pure Ethylene Glycol
  constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
    simpleEthyleneGlycolWaterConstants(
    each chemicalFormula="C2H6O2",
    each structureFormula="HOCH2CH2OH",
    each casRegistryNumber="107-21-1",
    each iupacName="Ethane-1,2-diol",
    each molarMass=0.062068);

  // Coefficients for evaluation of physical properties
  constant Buildings.Media.Antifreeze.BaseClasses.PropertyCoefficients proCoe(
    X_a_ref=0.308462,
    T_ref=Modelica.Units.Conversions.from_degC(31.728),
    nX_a=6,
    nT={4,4,4,3,2,1},
    nTot=18,
    a_d={1.034e3,-4.781e-1,-2.692e-3,4.725e-6,1.311e0,-6.876e-3,4.805e-5,
        1.690e-8,7.490e-5,7.855e-5,-3.995e-7,4.982e-9,-1.062e-4,1.229e-6,-1.153e-8,
        -9.623e-7,-7.221e-8,4.891e-8},
    a_eta={4.705e-1,-2.550e-2,1.782e-4,-7.669e-7,2.471e-2,-1.171e-4,1.052e-6,-1.634e-8,
        3.328e-6,-1.086e-6,-1.051e-8,-6.475e-10,1.695e-6,3.157e-9,4.063e-10,
        3.089e-8,1.831e-10,-1.865e-9},
    a_Tf={-1.525e1,-1.566e-6,-2.278e-7,2.169e-9,-8.080e-1,-1.339e-6,2.047e-08,-2.717e-11,
        -1.334e-2,6.332e-8,2.373e-10,-2.183e-12,-7.293e-5,-1.764e-9,-2.442e-11,
        1.006e-6,-7.662e-11,1.140e-9},
    a_cp={3.737e3,2.930e0,-4.675e-3,-1.389e-5,-1.799e1,1.046e-1,-4.147e-4,
        1.847e-7,-9.933e-2,3.516e-4,5.109e-6,-7.138e-8,2.610e-3,-1.189e-6,-1.643e-7,
        1.537e-5,-4.272e-7,-1.618e-6},
    a_lambda={4.720e-1,8.903e-4,-1.058e-6,-2.789e-9,-4.286e-3,-1.473e-5,
        1.059e-7,-1.142e-10,1.747e-5,6.814e-8,-3.612e-9,2.365e-12,3.017e-8,-2.412e-9,
        4.004e-11,-1.322e-09,2.555e-11,2.678e-11})
    "Coefficients for evaluation of thermo-physical properties";

  replaceable function density_TX_a
    "Evaluate density of antifreeze-water mixture"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.Density d "Density of antifreeze-water mixture";
  algorithm
    d :=polynomialProperty(
        X_a,
        T,
        proCoe.a_d)
    annotation (
    Documentation(info="<html>
  <p>
  Density of propylene antifreeze-water mixture at specified mass fraction
  and temperature, based on Melinder (2010).
  </p>
  <h4>References</h4>
  <p>
  Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
  Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
  IIR/IIF.
  </p>
  </html>",
  revisions="<html>
  <ul>
  <li>
  May 2, 2018 by Massimo Cimmino:<br/>
  First implementation.
  This function is used by
  <a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
  Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
  </li>
  </ul>
  </html>"));

  end density_TX_a;

  replaceable function dynamicViscosity_TX_a
    "Evaluate dynamic viscosity of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.DynamicViscosity eta
      "Dynamic Viscosity of antifreeze-water mixture";
  algorithm
    eta :=1e-3*exp(polynomialProperty(
        X_a,
        T,
        proCoe.a_eta));

  annotation (
  Documentation(info="<html>
<p>
Dynamic viscosity of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
May 2, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end dynamicViscosity_TX_a;

  replaceable function fusionTemperature_TX_a
    "Evaluate temperature of fusion of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.Temperature Tf
      "Temperature of fusion of antifreeze-water mixture";
  algorithm
    Tf :=Modelica.Units.Conversions.from_degC(polynomialProperty(
        X_a,
        T,
        proCoe.a_Tf));

  annotation (
  Documentation(info="<html>
<p>
Fusion temperature of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
May 2, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end fusionTemperature_TX_a;

  replaceable function polynomialProperty
    "Evaluates thermophysical property from 2-variable polynomial"
    extends Modelica.Icons.Function;

    input Real x "First independent variable";
    input Real y "Second independent variable";
    input Real a[sum(proCoe.nT)] "Polynomial coefficients";

    output Real f "Value of thermophysical property";

  protected
    Real dx;
    Real dy;
    Integer n;
  algorithm
    dx := 100*(x - proCoe.X_a_ref);
    dy := y - proCoe.T_ref;

    f := 0;
    n := 0;
    for i in 0:proCoe.nX_a - 1 loop
      for j in 0:proCoe.nT[i+1] - 1 loop
        n := n + 1;
        f := f + a[n]*dx^i*dy^j;
      end for;
    end for;
  annotation (
  Documentation(info="<html>
<p>
Evaluates a thermophysical property of a mixture, based on correlations proposed
by Melinder (2010).
</p>
<p>
The polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
f = a<sub>1</sub> (x-xm)<sup>0</sup>(y-ym)<sup>0</sup>
+ a<sub>2</sub> (x-xm)<sup>0</sup>(y-ym)<sup>1</sup>
+ ... +
a<sub>ny[1]</sub> (x-xm)<sup>0</sup>(y-ym)<sup>ny[1]-1</sup>
+ ... +
a<sub>ny[1])+1</sub> (x-xm)<sup>1</sup>(y-ym)<sup>0</sup>
+ ... +
a<sub>ny[1]+ny[2]</sub> (x-xm)<sup>1</sup>(y-ym)<sup>ny[2]-1</sup>
+ ...
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used models in
<a href=\"modelica://Buildings.Media.Antifreeze\">
Buildings.Media.Antifreeze</a>.
</li>
</ul>
</html>"));
  end polynomialProperty;

  replaceable function specificHeatCapacityCp_TX_a
    "Evaluate specific heat capacity of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.SpecificHeatCapacity cp
      "Specific heat capacity of antifreeze-water mixture";
  algorithm
    cp :=polynomialProperty(
        X_a,
        T,
        proCoe.a_cp);

  annotation (
  Documentation(info="<html>
<p>
Specific heat capacity of antifreeze-water mixture at specified mass fraction
and temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end specificHeatCapacityCp_TX_a;

  replaceable function thermalConductivity_TX_a
    "Evaluate thermal conductivity of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.ThermalConductivity lambda
      "Thermal conductivity of antifreeze-water mixture";
  algorithm
    lambda :=polynomialProperty(
        X_a,
        T,
        proCoe.a_lambda);

  annotation (
  Documentation(info="<html>
<p>
Thermal conductivity of antifreeze-water mixture at specified mass fraction and
temperature, based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>",   revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used by
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end thermalConductivity_TX_a;
annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models ethylene glycol - water mixtures.
</p>
<p>
The mass density, specific heat capacity, thermal conductivity and viscosity
are assumed constant and evaluated at a set temperature and mass fraction of
ethylene glycol within the mixture. The dependence of the four properties
are shown on the figure below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/EthyleneGlycolWaterProperties.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The accuracy of the thermophysical properties is dependent on the temperature
variations encountered during simulations.
The figure below shows the relative error of the the four properties over a
<i>10</i> &deg;C range around the temperature used to evaluate the constant
properties. The maximum errors are <i>0.8</i> % for mass density, <i>2.7</i> %
for specific heat capacity, <i>3.2</i> % for thermal conductivity and <i>160</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/EthyleneGlycolWaterError10degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The figure below shows the relative error of the the four properties over a
<i>20</i> &deg;C range around the temperature used to evaluate the constant
proepties. The maximum errors are <i>1.5</i> % for mass density, <i>5.3</i> %
for specific heat capacity, <i>5.9</i> % for thermal conductivity and <i>500</i>
% for dynamic viscosity.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Media/Antifreeze/EthyleneGlycolWaterError20degC.png\" border=\"1\"
alt=\"Relative variation of specific heat capacity with temperature\"/>
</p>
<p>
The enthalpy is computed using the convention that <i>h=0</i>
if <i>T=0</i> &deg;C.
</p>
<h4>Limitations</h4>
<p>
Density, specific heat capacity, thermal conductivity and viscosity are constant.
The ethylene glycol/water mixture is modeled as an incompressible liquid.
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
<code>Medium = Buildings.Media.Antifreeze.EthyleneGlycolWater(property_T=293.15, X_a=0.40)</code>
</p>
</html>", revisions="<html>
<ul>
<li>
August 05, 2020, by Wen HU:<br/>
First implementation.
</li>
</ul>
</html>"));
end EthyleneGlycolWater;
