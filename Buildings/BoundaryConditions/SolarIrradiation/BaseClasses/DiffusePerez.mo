within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block DiffusePerez
  "Hemispherical diffuse irradiation on a tilted surface with Perez's anisotropic model"
  extends Modelica.Blocks.Icons.Block;
  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt angle";
  Modelica.Blocks.Interfaces.RealInput briCof1 "Brightening Coeffcient F1"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput briCof2 "Brightening Coeffcient F2"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Diffuse horizontal solar radiation"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2") "Global horizontal radiation"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealInput zen(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Zenith angle of the sun beam"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput incAng(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Solar incidence angle on the surface"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));

  Modelica.Blocks.Interfaces.RealOutput HGroDifTil(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surface from the ground"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput HSkyDifTil(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Hemispherical diffuse solar irradiation on a tilted surface from the sky"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
protected
  Real a;
  Real b;
  constant Real bMin=Modelica.Math.cos(Modelica.Constants.pi*85/180)
    "Lower bound for b";
equation
  a = Buildings.Utilities.Math.Functions.smoothMax(
    0,
    Modelica.Math.cos(incAng),
    0.01);
  b = Buildings.Utilities.Math.Functions.smoothMax(
    bMin,
    Modelica.Math.cos(zen),
    0.01);
  HSkyDifTil = HDifHor*(0.5*(1 - briCof1)*(1 + Modelica.Math.cos(til)) +
    briCof1*a/b + briCof2*Modelica.Math.sin(til));
  HGroDifTil = HGloHor*0.5*rho*(1 - Modelica.Math.cos(til));

  annotation (
    defaultComponentName="HDifTil",
    Documentation(info="<html>
<p>
This component computes the hemispherical diffuse irradiation on a tilted surface by using an anisotropic model proposed by Perez.
</p>
<h4>References</h4>
<ul>
<li>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</li>
<li>
R. Perez, R. Seals, P. Ineichen, R. Stewart and D. Menicucci (1987).
<i>A New Simplified Version of the Perez Diffuse Irradiance Model for Tilted Surface</i>,
Solar Energy, 39(3): 221-231.
</li>
<li>
R. Perez, P. Ineichen, R. Seals, J. Michalsky and R. Stewart (1990).
<i>Modeling Dyalight Availability and Irradiance Componets From Direct and Global Irradiance</i>,
Solar Energy, 44(5):271-289.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 27, 2018, by Michael Wetter:<br/>
Corrected <code>displayUnit</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/912\">IBPSA, issue 912</a>.
</li>
<li>
June 6, 2012, by Wangda Zuo:<br/>
Separated the contribution from the sky and the ground.
</li>
</ul>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-48,74},{-100,86}},
          textColor={0,0,127},
          textString="HGloHor"),
        Text(
          extent={{-50,44},{-102,56}},
          textColor={0,0,127},
          textString="HDifHor"),
        Text(
          extent={{-50,14},{-102,26}},
          textColor={0,0,127},
          textString="briCof1"),
        Text(
          extent={{-50,-16},{-102,-4}},
          textColor={0,0,127},
          textString="briCof2"),
        Text(
          extent={{-50,-46},{-102,-34}},
          textColor={0,0,127},
          textString="zen"),
        Text(
          extent={{-52,-76},{-104,-64}},
          textColor={0,0,127},
          textString="incAng")}));
end DiffusePerez;
