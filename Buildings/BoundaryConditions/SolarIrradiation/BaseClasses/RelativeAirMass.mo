within Buildings.BoundaryConditions.SolarIrradiation.BaseClasses;
block RelativeAirMass "Relative air mass"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput alt(
    quantity="Length",
    unit="m") "location altitude" annotation (Placement(transformation(extent={{-140,40},
            {-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput zen(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Zenith angle of the sun beam"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput relAirMas "Relative air mass"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Real zenLim "Zenith angle bounded from above by 90 degree";
  Real zenDeg "Zenith angle in degree";
equation
  zenLim = Buildings.Utilities.Math.Functions.smoothMin(
    zen,
    Modelica.Constants.pi/2,
    0.01);
  zenDeg = zenLim*180/Modelica.Constants.pi;
  relAirMas = exp(-0.0001184*alt)/(Modelica.Math.cos(zenLim) + 0.15*(93.9 - zenDeg)^(-1.253));
  annotation (
    defaultComponentName="relAirMas",
    Documentation(info="<html>
<p>
This component computes the relative air mass for sky brightness.
</p>
<h4>References</h4>
<p>
R. Perez (1999).
<i>Fortran Function irrpz.f</i>,
Emailed by R. Perez to F.C. Winkelmann on May 21, 1999.
</p>
</html>", revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
May 2, 2021, by Ettore Zanetti:
Introduced altitude attenuation for relative air mass calculation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, issue 1477</a>.
</li>
<li>
April 27, 2018, by Michael Wetter:<br/>
Corrected <code>displayUnit</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/912\">IBPSA, issue 912</a>.
</li>
<li>
July 07, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end RelativeAirMass;
