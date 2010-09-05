within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block DiffuseSolarIrradiationIsotropic
  "Diffuse solar irradiation on a tilted surface with an isotropic model"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle tilAng(displayUnit="deg")
    "Surface tilt angle";

  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal diffuse solar radiation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2") "Horizontal global radiation"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealOutput HDifTil(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Diffuse solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real tilAng_c "Cosine of tilt angle";

equation
  tilAng_c = Modelica.Math.cos(tilAng);
  HDifTil = 0.5*HDifHor*(1 + tilAng_c) + 0.5*HGloHor*rho*(1 - tilAng_c);
  annotation (
    defaultComponentName="HDifTilIso",
    Documentation(info="<HTML>
<p>
This component computes the Hemispherical diffuse irradiation on a tilted surface by using an isotropic model. It is the summation of diffuse solar irradiation and radiation reflected by the ground.
</p>
<h4>References</h4>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end DiffuseSolarIrradiationIsotropic;
