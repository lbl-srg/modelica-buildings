within Buildings.Media.Antifreeze.Functions;
package EthyleneGlycolWater
  "Package with model for ethylene glycol - water with constant properties"
  extends Modelica.Icons.Package;

  constant Modelica.Units.SI.MassFraction X_a_min=0.
    "Minimum allowed mass fraction of ethylene glycol in water";
  constant Modelica.Units.SI.MassFraction X_a_max=0.6
    "Maximum allowed mass fraction of ethylene glycol in water";

record PropertyCoefficients
  "Polynomial coefficients to evaluate fluid properties"
  extends Modelica.Icons.Record;

  Modelica.Units.SI.MassFraction X_a_ref "Reference mass fraction";
  Modelica.Units.SI.Temperature T_ref "Reference temperature";
  parameter Integer nX_a "Order of polynomial in x";
  Integer nT[nX_a] "Order of polynomial in y";
  parameter Integer nTot "Total number of coefficients";
  Real a_d[nTot] "Polynomial coefficients for density";
  Real a_eta[nTot] "Polynomial coefficients for dynamic viscosity";
  Real a_Tf[nTot] "Polynomial coefficients for fusion temperature";
  Real a_cp[nTot] "Polynomial coefficients for specific heat capacity";
  Real a_lambda[nTot] "Polynomial coefficients for thermal conductivity";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Record that is used by media packages in
<a href=\"modelica://Buildings.Media.Antifreeze\">
Buildings.Media.Antifreeze</a> to implement the thermophysical properties
based on Melinder (2010).
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>", revisions="<html>
<ul>
<li>
May 11, 2018, by Michael Wetter:
Added documentation.
</li>
</ul>
</html>"));
end PropertyCoefficients;
  // Coefficients for evaluation of physical properties
  constant PropertyCoefficients proCoe(
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

  function density_TX_a
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
        proCoe.a_d);

    annotation (
    Documentation(info="<html>
  <p>
  Density of ethylene antifreeze-water mixture at specified mass fraction
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

  function dynamicViscosity_TX_a
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

  function fusionTemperature_TX_a
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

  function polynomialProperty
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

  function prandtlNumber_TX_a
    "Evaluate Prandtl number of antifreeze-water mixture"
      extends Modelica.Icons.Function;
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    input Modelica.Units.SI.MassFraction X_a "Mass fraction of antifreeze";
    output Modelica.Units.SI.ThermalConductivity Pr
      "Prandtl number of antifreeze-water mixture";
  algorithm
    Pr := dynamicViscosity_TX_a(T=T, X_a=X_a) * specificHeatCapacityCp_TX_a(T=T, X_a=X_a) /
      thermalConductivity_TX_a(T=T, X_a=X_a);

  annotation (
  Documentation(info="<html>
<p>
Prandtl number of antifreeze-water mixture at specified mass fraction and
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
April 17, 2026 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end prandtlNumber_TX_a;

  function specificHeatCapacityCp_TX_a
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

  function thermalConductivity_TX_a
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

  function volumeToMassFraction
    "Returns the mass fraction of the mixture for a given volume fraction"
    extends Modelica.Icons.Function;

    input Real phi(
      final min=0,
      max=1,
      final unit="1") "Volume fraction of the mixture";
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    output Modelica.Units.SI.SpecificVolume y(
      min=X_a_min,
      max=X_a_max) "Mass fraction of the mixture";

  protected
    constant Real delta = 0.01 "Small increment for numerical differentiation";
    Modelica.Units.SI.Density dWat "Mass density of water";
    Modelica.Units.SI.Density dGly "Mass density of glycol";
    Modelica.Units.SI.Density phiRhoGly "Fraction of mass density of glycol";
    Modelica.Units.SI.Density dMix "Mass density of the mixture";

  algorithm
    dWat := density_TX_a(T=T, X_a=0);

    // The density function is only valid for mass fractions up to X_a_max,
    // so we use linear extrapolation to get the density of glycol at X_a=1
    dGly := density_TX_a(T=T, X_a=X_a_max) + (1.0-X_a_max) * (density_TX_a(T=T, X_a=X_a_max)-density_TX_a(T=T, X_a=X_a_max-delta)) / delta;

    phiRhoGly := phi * dGly;

    dMix := phiRhoGly + (1-phi) * dWat;

    y := phiRhoGly / dMix;

  annotation (
  Documentation(info="<html>
<p>
Conversion from volume fraction to mass fraction of antifreeze-water mixture at specified temperature.
</p>
<h4>Implementation</h4>
<p>
The density function is only valid for mass fractions up to <code>X_a_max</code>.
Therefore, linear extrapolation, using the slope of the density function at <code>X_a_max</code>,
is used to get the density of glycol at <code>X_a=1</code>.
</p>
</html>",   revisions="<html>
<ul>
<li>
April 16, 2026 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end volumeToMassFraction;

annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models ethylene glycol - water mixtures.
</p>
<p>
These functions are identical with the ones in
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
See therefore the documentation of that package.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2026, by Michael Wetter:<br/>
First implementation based on
<a href=\"modelica://Buildings.Media.Antifreeze.EthyleneGlycolWater\">
Buildings.Media.Antifreeze.EthyleneGlycolWater</a>.
</li>
</ul>
</html>"));
end EthyleneGlycolWater;
