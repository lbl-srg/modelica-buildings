within Buildings.ThermalZones.ISO13790.BaseClasses;
model GlazedElements
  parameter Integer n;
  parameter Real AWin[:] "Area of windows";
  parameter Real surTil[:] "Tilt angle of surfaces";
  parameter Real surAzi[:] "Azimuth angle of surfaces";
  parameter Real gFac "Energy transmittance of glazings";
  parameter Real winFra "Frame fraction of windows";
  parameter Real shaRedFac(
    final min=0,
    final unit="1")= 0.9 "Shading reduction factor";

  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[n](
  final til=surTil,
  final azi=surAzi)
    "Direct solar irradiation on surface"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Math.Gain solRad[n](final k=AWin*gFac*shaRedFac*(1 - winFra))
    "Solar radiation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.RealOutput solRadWin
    "Solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[n](
  final til=surTil,
  final azi=surAzi)
    "Diffuse solar irradiation on surface"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
protected
  Modelica.Blocks.Math.Add irr[n]
    "Total of direct and diffuse radiation on surface"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.MultiSum multiSum(final nu=n) "Sum of all orientations"
    annotation (Placement(transformation(extent={{62,-6},{74,6}})));

equation
  for i in 1:n loop
  connect(weaBus,HDifTil[i].weaBus) annotation (Line(
      points={{-100,0},{-72,0},{-72,-30},{-60,-30}},
      color={255,204,51},
      thickness=0.5));
  end for;

  for i in 1:n loop
  connect(weaBus,HDirTil[i].weaBus) annotation (Line(
      points={{-100,0},{-72,0},{-72,30},{-60,30}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(solRad.y, multiSum.u)
    annotation (Line(points={{41,0},{62,0}}, color={0,0,127}));
  connect(multiSum.y, solRadWin)
    annotation (Line(points={{75.02,0},{110,0}}, color={0,0,127}));
  connect(HDirTil.H,irr. u1) annotation (Line(points={{-39,30},{-30,30},{-30,6},
          {-22,6}}, color={0,0,127}));
  connect(HDifTil.H,irr. u2) annotation (Line(points={{-39,-30},{-30,-30},{-30,-6},
          {-22,-6}}, color={0,0,127}));

  connect(irr.y, solRad.u)
    annotation (Line(points={{1,0},{18,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,88},{-84,38}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{22,88},{-18,68},{-18,-92},{22,-52},{22,88}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{-108,148},{114,116}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This model calculates the heat flow by solar gains through each glazed element <i>k</i>. The heat flow is given by 
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> =F<sub>sh,k </sub>I<sub>sol,k </sub>g<sub>fac</sub> (1-F<sub>frame</sub>) A<sub>win,k</sub>
</p>
<p>
where <i>F<sub>sh,k</sub></i> is the shading reduction factor which is set to 0.9 by deafult, 
<i>I<sub>sol,k</sub></i> is the solar irradiance
per square meter of surface area, <i>g<sub>fac</sub></i> is the total solar energy transmittance of the trasparent
element, <i>F<sub>frame</sub></i> is the frame area fraction, and <i>A<sub>win,k</sub></i> is the overall area of 
the glazed element in square meters.
The model neglects the extra heat flow due to thermal radiation to the sky from the building.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end GlazedElements;
