within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block ZenithAngle "Zenith angle"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput solHouAng(quantity="Angle", unit="rad")
    "Solar hour angle"
    annotation (Placement(transformation(extent={{-140,-68},{-100,-28}})));
  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Solar declination angle"
    annotation (Placement(transformation(extent={{-142,34},{-102,74}}),
        iconTransformation(extent={{-140,34},{-100,74}})));
  Modelica.Blocks.Interfaces.RealOutput zen(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Zenith angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput lat(
    quantity="Angle",
    unit="rad",
    displayUnit="deg") "Latitude"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
equation
  zen =  Modelica.Math.acos(Modelica.Math.cos(lat)*Modelica.Math.cos(decAng)*
    Modelica.Math.cos(solHouAng) + Modelica.Math.sin(lat)*Modelica.Math.sin(
    decAng)) "(A4.8)";
  annotation (
    defaultComponentName="zen",
    Documentation(info="<html>
<p>
This component computes the zenith angle, which is the angle between the earth surface normal and the sun's beam.
Input are the solar hour angle and the declination angle.
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
January 5, 2015, by Michael Wetter:<br/>
Updated comment of the input connector as this is used in the weather bus connector.
This is for
issue <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">376</a>.
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
            100}}), graphics={
        Bitmap(extent={{-86,-88},{94,92}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/ZenithAngle.png"),
                              Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-98,62},{-46,46}},
          textColor={0,0,127},
          textString="decAng"),
        Text(
          extent={{-98,-40},{-22,-58}},
          textColor={0,0,127},
          textString="solHouAng")}));
end ZenithAngle;
