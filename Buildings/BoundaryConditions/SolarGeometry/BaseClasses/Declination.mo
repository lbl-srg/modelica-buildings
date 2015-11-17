within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block Declination "Declination angle"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput nDay(quantity="Time", unit="s")
    "One-based day number in seconds"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput decAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Declination angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  constant Real k1 = sin(23.45*2*Modelica.Constants.pi/360) "Constant";
  constant Real k2 = 2*Modelica.Constants.pi/365.25 "Constant";
equation
  decAng = Modelica.Math.asin(-k1 * Modelica.Math.cos((nDay/86400 + 10)*k2))
    "(A4.5)";
  annotation (
    defaultComponentName="decAng",
    Documentation(info="<html>
<p>
This component computes the solar declination, which is
the angle between the equatorial plane and the solar beam.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2015, by Michael Wetter:<br/>
Corrected typo in documentation.
</li>
<li>
Dec 7, 2010, by Michael Wetter:<br/>
Rewrote equation in explicit form to avoid nonlinear equations in room model.
</li>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}), Bitmap(extent={{-92,92},{92,-92}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/Declination.png")}));
end Declination;
