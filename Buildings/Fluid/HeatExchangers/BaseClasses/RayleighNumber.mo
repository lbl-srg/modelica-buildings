within Buildings.Fluid.HeatExchangers.BaseClasses;
model RayleighNumber
  "Calculates the Rayleigh number for a given fluid and characteristic length"
  extends Modelica.Blocks.Interfaces.BlockIcon;
   replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Fluid medium model";
  parameter Modelica.SIunits.Diameter ChaLen = 0.01905 "Characteristic length";
  Real Gr "Grashof number";
  Real B(unit="1/K") "isobaricExpansionCoefficient";
   Real nu(unit = "m2/s") "Kinematic viscosity of the medium";
   Modelica.SIunits.DynamicViscosity mu "Dynamic viscosity of the medium";
   Modelica.SIunits.Density rho "Density of the medium";
   Real g= Modelica.Constants.g_n "Acceleration due to gravity";

   Modelica.Blocks.Interfaces.RealInput TSur "Surface temperature of the HX"
     annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
   Modelica.Blocks.Interfaces.RealInput TFlu "Fluid temperature"
     annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

   Modelica.Blocks.Interfaces.RealOutput Ra
     annotation (Placement(transformation(extent={{100,-10},{120,10}})));

   Modelica.Blocks.Interfaces.RealOutput Pr
     annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
equation
    mu = Medium.dynamicViscosity(
        Medium.setState_pTX(
        p=  Medium.p_default,
        T=  Medium.T_default,
        X=  Medium.X_default));
    rho = Medium.density(
        Medium.setState_pTX(
        p=  Medium.p_default,
        T=  TFlu,
        X=  Medium.X_default));
    Pr = Medium.prandtlNumber(
        Medium.setState_pTX(
          p=  Medium.p_default,
          T=  TFlu,
          X=  Medium.X_default));

   B = Medium.isobaricExpansionCoefficient(
        Medium.setState_pTX(
          p=  Medium.p_default,
          T=  TFlu,
          X=  Medium.X_default));
    nu = mu/rho;

    Gr = Modelica.Constants.g_n * B * (TSur - TFlu)*ChaLen^3/nu^2;
    Ra = Gr*Pr;

annotation (
Documentation(info = "<html>
<p>
This model calculates the rayleigh number for a given fluid and characteristic length. It is calculated using Eq 9.25 in the referenced material. The equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
Ra<sub>L</sub> = Gr<sub>L</sub> * Pr * (g * B * (T<sub>S</sub> - T<sub>F</sub>)*L^3) /(&nu;*&alpha;)
</p>
<p>
where:<br>
  Ra<sub>L</sub> is the Rayleigh number, Gr<sub>L</sub> is the Grashof number, Pr is the Prandtl number, g is gravity, B is the isobaric expansion coefficient,
  T<sub>S</sub> is the temperature of the surface, T<sub>F</sub> is the temperature of the fluid, L is the characteristic length, &nu; is the kinematic viscosity
  and &alpha; is the thermal diffusivity.
</p>
<p>
The thermophysical properties are calculated using the functions of the medium specified by the user.
</p>


<h4>References</h4>
<p>
Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera and David DeWitt, John Wiley and Sons, 1996
</p>
</html>",
revisions="<html>
<h4>Revisions</h4>
<ul>
<li>
February 26, 2013 by Peter Grant <br>
First implementation
</li>
</ul>
</html>"));
end RayleighNumber;
