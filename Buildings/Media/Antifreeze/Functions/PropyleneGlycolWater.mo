within Buildings.Media.Antifreeze.Functions;
package PropyleneGlycolWater
  "Package with model for propylene glycol - water with constant properties"
  extends Modelica.Icons.Package;

  constant Modelica.Units.SI.MassFraction X_a_min=0.
    "Minimum allowed mass fraction of propylene glycol in water";
  constant Modelica.Units.SI.MassFraction X_a_max=0.6
    "Maximum allowed mass fraction of propylene glycol in water";

  // Coefficients for evaluation of physical properties
  constant Buildings.Media.Antifreeze.BaseClasses.PropertyCoefficients proCoe(
    X_a_ref=0.307031,
    T_ref=Modelica.Units.Conversions.from_degC(32.7083),
    nX_a=6,
    nT={4,4,4,3,2,1},
    nTot=18,
    a_d={1.018e3,-5.406e-1,-2.666e-3,1.347e-5,7.604e-1,-9.450e-3,5.541e-5,-1.343e-7,
        -2.498e-3,2.700e-5,-4.018e-7,3.376e-9,-1.550e-4,2.829e-6,-7.175e-9,-1.131e-6,
        -2.221e-8,2.342e-8},
    a_eta={6.837e-1,-3.045e-2,2.525e-4,-1.399e-6,3.328e-2,-3.984e-4,4.332e-6,-1.860e-8,
        5.453e-5,-8.600e-8,-1.593e-8,-4.465e-11,-3.900e-6,1.054e-7,-1.589e-9,-1.587e-8,
        4.475e-10,3.564e-9},
    a_Tf={-1.325e1,-3.820e-5,7.865e-7,-1.733e-9,-6.631e-1,6.774e-6,-6.242e-8,-7.819e-10,
        -1.094e-2,5.332e-8,-4.169e-9,3.288e-11,-2.283e-4,-1.131e-8,1.918e-10,-3.409e-6,
        8.035e-11,1.465e-8},
    a_cp={3.882e3,2.699e0,-1.659e-3,-1.032e-5,-1.304e1,5.070e-2,-4.752e-5,
        1.522e-6,-1.598e-1,9.534e-5,1.167e-5,-4.870e-8,3.539e-4,3.102e-5,-2.950e-7,
        5.000e-5,-7.135e-7,-4.959e-7},
    a_lambda={4.513e-1,7.955e-4,3.482e-8,-5.966e-9,-4.795e-3,-1.678e-5,8.941e-8,
        1.493e-10,2.076e-5,1.563e-7,-4.615e-9,9.897e-12,-9.083e-8,-2.518e-9,
        6.543e-11,-5.952e-10,-3.605e-11,2.104e-11})
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
  <a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
  Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
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
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
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
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end fusionTemperature_TX_a;

  function volumeToMassFraction
    "Returns the mass fraction of the mixture for a given volume fraction"
    extends Modelica.Icons.Function;

    input Real phi(
      final unit="1") "Volume fraction of the mixture";
    input Modelica.Units.SI.Temperature T
      "Temperature of antifreeze-water mixture";
    output Real y(
      min=X_a_min,
      max=X_a_max,
      final unit="1") "Mass fraction of the mixture";

  protected
    Modelica.SI.Units.Density dWat "Mass density of water";
    Modelica.SI.Units.Density phiRhoGly "Fraction of mass density of glycol";
    Modelica.SI.Units.Density dMix "Mass density of the mixture";
  algorithm
    dWat = density_TX_a(T=T, X_a=0);
    Modelica.Utilities.Streams.print("*** Mass density of water: " + String(dWat));
    phiRhoGly = phi * density_TX_a(T=T, X_a=1);
    Modelica.Utilities.Streams.print("*** fixme: Mass density of glycol (using extrapolation!): " + String(density_TX_a(T=T, X_a=1)));

    dMix = phiRhoGly + (1-phi) * dWat; // fixme

    y = phiRhoGly / dMix;
  end function;


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
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
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
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
  end thermalConductivity_TX_a;
annotation(preferredView="info", Documentation(info="<html>
<p>
This medium package models propylene glycol - water mixtures.
</p>
<p>
These functions are identical with the ones in
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
See therefore the documentation of that package.
</p>
</html>", revisions="<html>
<ul>
<li>
April 15, 2026, by Michael Wetter:<br/>
First implementation based on
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>.
</li>
</ul>
</html>"));
end PropyleneGlycolWater;
