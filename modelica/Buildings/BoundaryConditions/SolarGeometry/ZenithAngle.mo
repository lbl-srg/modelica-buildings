within Buildings.BoundaryConditions.SolarGeometry;
block ZenithAngle "Zenith angle"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  Modelica.Blocks.Interfaces.RealInput cloTim(unit="s",
    quantity="Time") "Clock time"
                       annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Zenith angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zenAng(final lat=lat)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
equation
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-39,6.10623e-16},{-32,6.10623e-16},{-32,-14},{-22,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-39,-40},{-32,-40},{-32,-25.4},{-22,-25.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, zenAng.decAng) annotation (Line(
      points={{41,30},{50,30},{50,5.4},{58,5.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, solHouAng.solTim) annotation (Line(
      points={{1,-20},{18,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, zenAng.solHouAng) annotation (Line(
      points={{41,-20},{50,-20},{50,-4.8},{58,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenAng.zenAng, y) annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eqnTim.nDay,cloTim)  annotation (Line(
      points={{-62,6.66134e-16},{-76.5,6.66134e-16},{-76.5,1.77636e-15},{-91,
          1.77636e-15},{-91,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloTim, decAng.nDay) annotation (Line(
      points={{-120,1.11022e-15},{-92,1.11022e-15},{-92,30},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloTim, locTim.cloTim) annotation (Line(
      points={{-120,1.11022e-15},{-92,1.11022e-15},{-92,-40},{-62,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="zenAng",
    Documentation(info="<HTML>
<p>
This component computes the zenith angle, which is the angle between the earth surface normal and the sun's beam.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 17, 2010, by Wangda Zuo:<br>
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
end ZenithAngle;
