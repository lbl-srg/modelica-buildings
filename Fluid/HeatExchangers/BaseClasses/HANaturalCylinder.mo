within Buildings.Fluid.HeatExchangers.BaseClasses;
model HANaturalCylinder
  "Calculates an hA value for natural convection around a cylinder"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Partial medium model to be replaced with specific medium";
  parameter Modelica.SIunits.Diameter ChaLen
    "Characteristic length of the cylinder";

  parameter Modelica.SIunits.ThermalConductance hA_nominal(min=0)
    "Convective heat transfer coefficient"
   annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TFlu_nominal
    "Fluid temperature at hA_nominal"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TSur_nominal
    "Surface temperature at hA_nominal"
    annotation(Dialog(tab="General", group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput TSur(unit = "K")
    "Temperature of the external surface of the heat exchanger"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput TFlu(unit = "K")
    "Temperature of the fluid in the heat exchanger"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput hA(unit = "W/K")
    "hA-value of the heat exchanger"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Real h(unit="W/(m2.K)") "Convection coefficient";
protected
  parameter Real Gr_nominal(fixed=false) "Grashof number";
  parameter Real B_nominal(unit="1/K", fixed=false)
    "isobaricExpansionCoefficient";
  parameter Real nu_nominal(unit = "m2/s", fixed=false)
    "Kinematic viscosity of the medium";
  parameter Modelica.SIunits.DynamicViscosity mu_nominal(fixed=false)
    "Dynamic viscosity of the medium";
  parameter Modelica.SIunits.Density rho_nominal(fixed=false)
    "Density of the medium";

  parameter Modelica.SIunits.ThermalConductivity k_nominal(fixed=false)
    "Thermal conductivity of the fluid";

  parameter Real Ra_nominal(fixed=false) "Rayleigh number";
  parameter Real Pr_nominal(fixed=false) "Prandlt number";
  parameter Real Nusselt_nominal(fixed=false) "Nusselt number";

  parameter Real h_nominal(unit="W/(m2.K)", fixed=false)
    "Convection coefficient";
  parameter Modelica.SIunits.Area A(fixed=false)
    "Surface area, deduced from hA_nominal, fluid temperatures and characteristic length";

  Modelica.SIunits.ThermalConductivity k "Thermal conductivity of the fluid";
  Real Gr "Grashof number";
  Real B(unit="1/K") "isobaricExpansionCoefficient";
  Real nu(unit = "m2/s") "Kinematic viscosity of the medium";
  Modelica.SIunits.DynamicViscosity mu "Dynamic viscosity of the medium";
  Modelica.SIunits.Density rho "Density of the medium";
  constant Modelica.SIunits.Acceleration g= Modelica.Constants.g_n
    "Acceleration due to gravity";

  Real Ra "Rayleigh number";
  Real Pr "Prandlt number";
  Real Nusselt "Nusselt number";

function nusselt
  input Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
  input Real Pr "Prandlt number";
  input Real Ra "Rayleigh number";
  output Real Nu(min=0) "Nusselt number";
  protected
  Real num "Numerator";
  Real den "Denominator";
algorithm
  num := (0.387*Buildings.Utilities.Math.Functions.smoothMax(Ra,1,0.1)^(1/6));
  den := ((1+(0.559/Pr)^(9/16))^(8/27));
  Nu := (0.6+num/den)^2;
  annotation(smoothOrder=1);
end nusselt;

initial equation

  // Fluid properties
  mu_nominal = Buildings.Fluid.HeatExchangers.BaseClasses.dynamicViscosityWater(
        T=  0.5 * (TSur_nominal+TFlu_nominal));
  rho_nominal = Medium.density(
        Medium.setState_pTX(
          p=  Medium.p_default,
          T=  0.5*(TSur_nominal+TFlu_nominal),
          X=  Medium.X_default));
  Pr_nominal = Buildings.Fluid.HeatExchangers.BaseClasses.prandtlNumberWater(
          T=  0.5*(TSur_nominal+TFlu_nominal));

  B_nominal = Buildings.Fluid.HeatExchangers.BaseClasses.isobaricExpansionCoefficientWater(
          T=  0.5*(TSur_nominal+TFlu_nominal));
  nu_nominal = mu_nominal/rho_nominal;

  Gr_nominal = Modelica.Constants.g_n * B_nominal * (TSur_nominal -
  TFlu_nominal)*ChaLen^3/nu_nominal^2;
  Ra_nominal = Gr_nominal*Pr_nominal;
  // Convection coefficient
  k_nominal = Medium.thermalConductivity(
    Medium.setState_pTX(
    p=  Medium.p_default,
    T=  0.5*(TFlu_nominal+TSur_nominal),
    X=  Medium.X_default));
  Nusselt_nominal = nusselt(k=k_nominal, Pr=Pr_nominal, Ra=Ra_nominal);
  h_nominal = Nusselt_nominal * k_nominal/ChaLen;
  A = hA_nominal / h_nominal;
equation
  // Fluid properties
  mu = Buildings.Fluid.HeatExchangers.BaseClasses.dynamicViscosityWater(
        T=  0.5 * (TSur+TFlu));
  rho = Medium.density(
        Medium.setState_pTX(
          p=  Medium.p_default,
          T=  0.5*(TSur+TFlu),
          X=  Medium.X_default));
  Pr = Buildings.Fluid.HeatExchangers.BaseClasses.prandtlNumberWater(
          T=  0.5*(TSur+TFlu));

  B = Buildings.Fluid.HeatExchangers.BaseClasses.isobaricExpansionCoefficientWater(
          T=  0.5*(TSur+TFlu));
  nu = mu/rho;

  Gr = Modelica.Constants.g_n * B * (TSur - TFlu)*ChaLen^3/nu^2;
  Ra = Gr*Pr;
  // Convection coefficient
  k = Medium.thermalConductivity(
    Medium.setState_pTX(
    p=  Medium.p_default,
    T=  0.5*(TFlu+TSur),
    X=  Medium.X_default));
  Nusselt = nusselt(k=k, Pr=Pr, Ra=Ra);
  h = Nusselt * k/ChaLen;
  hA = h*A;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            defaultComponentName="hNat",
            Documentation(info="<html>
            <p>
            This model calculates the convection coefficient <i>h</i> for natural convection
            from a cylinder submerged in fluid. <i>h</i> is calcualted using Eq 9.34 from 
            Incropera and DeWitt (1996).
            Output of the block is the <i>hA</i> value.
            </p>
            <p>
            The Nusselt number is computed as
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            Nu<sub>D</sub> = (0.6 + (0.387 Ra<sub>D</sub><sup>(1/6)</sup>)/(1+(0.559 Pr)<sup>
            (9/16)</sup>)<sup>(8/27)</sup>)<sup>2</sup>);
            </p>
            <p>
            where <i>Nu<sub>D</sub></i> is the Nusselt number, <i>Ra<sub>D</sub></i> is the 
            Rayleigh number and 
            <i>Pr</i> is the Prandtl number.<br/>
            This correclation is accurate for <i>Ra<sub>D</sub></i> less than 10<sup>12</sup>.
            </p>
            <p>
            <i>h</i> is then calculated from the Nusselt number. The equation is
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            h = Nu<sub>D</sub> k/D
            </p>
            <p>
            where <i>k</i> is the thermal conductivity of the fluid and <i>D</i> is the diameter
            of the submerged cylinder.
            </p>
            <h4>References</h4>
            <p>
            Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera and David 
            DeWitt, John Wiley and Sons, 1996
            </p>
            </html>", revisions="<html>
<ul>
<li>
May 10, 2013 by Michael Wetter:<br/>
Revised implementation to use <code>hA_nominal</code> as a parameter, and compute the 
associated surface area <code>A</code>. This revision was required to have a consistent
computation of the the <code>hA</code> values inside and outside of the coil in the 
heat exchanger model of the water tank.
</li>
<li>
February 26, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"));
end HANaturalCylinder;
