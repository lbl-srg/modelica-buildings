within Buildings.Fluid.HeatExchangers.BaseClasses;
model HNatCyl
  "Calculates the convection coefficient for natural convection around a cylinder"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Partial medium model to be replaced with specific medium";
  parameter Modelica.SIunits.Diameter ChaLen
    "Characteristic length of the cylinder";
  Modelica.SIunits.ThermalConductivity kFlu "Thermal conductivity of the fluid";
  Modelica.SIunits.NusseltNumber Nusselt
    "Nusselt number for the current conditions";

  Modelica.Blocks.Interfaces.RealInput TSur
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TFlu
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput h(unit = "W/(m2.K)")
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput Ra
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Pr
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Real Num "Numerator of the fraction in the Nusselt number calculation";
  Real Den "Denominator of the fraction in the Nusselt number calculation";

equation
  kFlu = Medium.thermalConductivity(
    Medium.setState_pTX(
    p=  Medium.p_default,
    T=  TFlu,
    X=  Medium.X_default));
  Num = (0.387*Buildings.Utilities.Math.Functions.smoothMax(Ra,1,0.1)^(1/6));
  Den = ((1+(0.559/Pr)^(9/16))^(8/27));
  h = (0.6+Num/Den)^2 * kFlu/ChaLen;
  Nusselt = (0.6+Num/Den)^2;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            Documentation(info="<html>
            <p>
            This model calculates the convection coefficient (h) for natural convection from a cylinder submerged in fluid. h is calcualted using Eq 9.34 from the referenced text.
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            Nu<sub>D</sub> = (0.6 + (0.387*Ra<sub>D</sub>^(1/6))/(1+(0.559*Pr)^(9/16))^(8/27))^2);
            </p>
            <p>
            Where Nu<sub>D</sub> is the Nusselt number, Ra<sub>D</sub> is the Rayleigh number and Pr is the Prandtl number.<br>
            This correclation is accurate for Ra<sub>D</sub> less than 10^12.
            </p>
            <p>
            h is then calculated from the Nusselt number. The equation is
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            h = Nu<sub>D</sub>*k/D
            </p>
            <p>
            where k is the thermal conductivity of the fluid and D is the diameter of the submerged cylinder.
            </p>
            <h4>References</h4>
            <p>
            Fundamentals of Heat and Mass Transfer (Fourth Edition), Frank Incropera and David DeWitt, John Wiley and Sons, 1996
            </p>  
            <h4>Revisions</h4>
            <ul>
            <li>
            February 26, 2013 by Peter Grant <br>
            First implementation
            </li>
            </ul>
            </html>"));
end HNatCyl;
