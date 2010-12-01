within Buildings.BoundaryConditions.SolarGeometry;
block IncidenceAngle "Solar incidence angle on a tilted surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Modelica.SIunits.Angle til "Surface tilt";
  Modelica.Blocks.Interfaces.RealInput cloTim(unit="s",
    quantity="Time") "Clock time"
                       annotation (Placement(transformation(extent={{-140,-20},
            {-100,20}}), iconTransformation(extent={{-138,-20},{-98,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{
            120,10}})));
protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarTime solTim
    "Solar time"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.EquationOfTime eqnTim
    "Equation of time"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.LocalTime locTim
    "Local time"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    final lat=lat,
    final azi=azi,
    final til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(
      points={{-39,-10},{-32,-10},{-32,-24},{-22,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(locTim.locTim, solTim.locTim) annotation (Line(
      points={{-39,-50},{-32,-50},{-32,-35.4},{-22,-35.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solTim.solTim, solHouAng.solTim) annotation (Line(
      points={{1,-30},{18,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.incAng, y) annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, incAng.decAng) annotation (Line(
      points={{41,30},{48,30},{48,5.4},{57.8,5.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
      points={{41,-30},{48,-30},{48,-4.8},{58,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloTim, eqnTim.nDay) annotation (Line(
      points={{-120,1.11022e-15},{-92,1.11022e-15},{-92,-10},{-62,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cloTim, locTim.cloTim) annotation (Line(
      points={{-120,1.11022e-15},{-92,1.11022e-15},{-92,-50},{-62,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.nDay,cloTim)  annotation (Line(
      points={{18,30},{-92,30},{-92,1.11022e-15},{-120,1.11022e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{110,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="incAng",
    Documentation(info="<HTML>
<p>
This component computes the incidence angle of direct solar radiation on a tilted surface.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 19, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end IncidenceAngle;
