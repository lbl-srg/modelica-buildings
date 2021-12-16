within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block DiffuseIsotropic
  "Diffuse solar irradiation on a tilted surface with an isotropic model"
  extends Modelica.Blocks.Icons.Block;
  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.Units.SI.Angle til(displayUnit="deg") "Surface tilt angle";

  Modelica.Blocks.Interfaces.RealInput HDifHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2")
    "Horizontal diffuse solar radiation"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput HGloHor(quantity=
        "RadiantEnergyFluenceRate", unit="W/m2") "Horizontal global radiation"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealOutput HGroDifTil(final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2")
    "Diffuse solar irradiation on a tilted surface from the ground"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput HSkyDifTil(final quantity="RadiantEnergyFluenceRate",
      final unit="W/m2")
    "Diffuse solar irradiation on a tilted surface from the sky"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
protected
  Real til_c "Cosine of tilt angle";
equation
  til_c = Modelica.Math.cos(til);
  HSkyDifTil = 0.5*HDifHor*(1 + til_c);
  HGroDifTil = 0.5*HGloHor*rho*(1 - til_c);
  annotation (
    defaultComponentName="HDifTilIso",
    Documentation(info="<html>
<p>
This component computes the hemispherical diffuse irradiation on a tilted surface.
The irradiation is composed of the diffuse horizontal solar irradiation and the irradiation
that has been reflected by the ground. Both components are adjusted to take into account
the tilt of the receiving surface.
</p>
<h4>References</h4>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</html>", revisions="<html>
<ul>
<li>
June 6, 2012, by Wangda Zuo:<br/>
Separated the contributions from the sky and the ground.
</li>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end DiffuseIsotropic;
