within Buildings.Fluid.HeatExchangers.BaseClasses;
model HNatCyl
  "Calculates the convection coefficient for natural convection around a cylinder"
  //fixme - Looks like Michael trying to replace with HANaturalCylinder (True??). If so, should delete this
  extends Modelica.Blocks.Interfaces.BlockIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Partial medium model to be replaced with specific medium";
  parameter Modelica.SIunits.Diameter ChaLen = 0.025
    "Characteristic length of the cylinder";
  Modelica.SIunits.ThermalConductivity kFlu "Thermal conductivity of the fluid";
  Modelica.SIunits.NusseltNumber Nusselt
    "Nusselt number for the current conditions";

  Modelica.Blocks.Interfaces.RealInput TSur(unit = "K")
    "Temperature of the external surface of the heat exchanger"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput TFlu(unit = "K")
    "Temperature of the fluid in the heat exchanger"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput h(unit = "W/(m2.K)")
    "Convection coefficient outside the heat exchanger"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput Ra "Rayleigh number"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput Pr "Prandlt number"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
protected
  Real Num "Numerator of the fraction in the Nusselt number calculation";
  Real Den "Denominator of the fraction in the Nusselt number calculation";

equation
  kFlu = Medium.thermalConductivity(
    Medium.setState_pTX(
    p=  Medium.p_default,
    T=  0.5*(TFlu+TSur),
    X=  Medium.X_default));
  Num = (0.387*Buildings.Utilities.Math.Functions.smoothMax(Ra,1,0.1)^(1/6));
  Den = ((1+(0.559/Pr)^(9/16))^(8/27));
  h = Nusselt * kFlu/ChaLen;
  Nusselt = (0.6+Num/Den)^2;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            defaultComponentName="hNat",
            Documentation(info="<html>
            <p>
            This model calculates the convection coefficient (<i>h</i>) for natural convection from a cylinder submerged in fluid. <i>h</i> is calcualted using Eq 9.34 from Incropera and DeWitt (1996).
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            Nu<sub>D</sub> = (0.6 + (0.387 Ra<sub>D</sub><sup>(1/6)</sup>)/(1+(0.559 Pr)<sup>(9/16)</sup>)<sup>(8/27)</sup>)<sup>2</sup>);
            </p>
            <p>
            Where <i>Nu<sub>D</sub></i> is the Nusselt number, <i>Ra<sub>D</sub></i> is the Rayleigh number and <i>Pr</i> is the Prandtl number.<br>
            This correclation is accurate for <i>Ra<sub>D</sub></i> less than 10<sup>12</sup>.
            </p>
            <p>
            <i>h</i> is then calculated from the Nusselt number. The equation is
            </p>
            <p align=\"center\" style=\"font-style:italic;\">
            h = Nu<sub>D</sub> k/D
            </p>
            <p>
            where <i>k</i> is the thermal conductivity of the fluid and <i>D</i> is the diameter of the submerged cylinder.
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
