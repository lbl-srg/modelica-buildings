within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block Declination "Declination angle"
  extends Modelica.Blocks.Icons.Block;
public
  Modelica.Blocks.Interfaces.RealInput nDay(quantity="Time", unit="s")
    "One-based day number in seconds"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput decAng(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Declination angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  decAng = Modelica.Math.asin(-sin(23.45*2*Modelica.Constants.pi/360)*
    Modelica.Math.cos((nDay/86400 + 10)*2*Modelica.Constants.pi/365.25))
    "(A4.5)";
  annotation (
    defaultComponentName="decAng",
    Documentation(info="<html>
<p>
This component computes the solar declinatino, which is
the angle between the equatorial plane and the solar beam.
</p>
</html>", revisions="<html>
<ul>
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
