within Buildings.ThermalZones.ISO13790.BaseClasses;
model OpaqueElements
  parameter Integer n;
  parameter Real AWal[:] "Area of external walls";
  parameter Real ARoo "Area of roof";
  parameter Real UWal "U-value of external walls";
  parameter Real URoo "U-value of roof";
  parameter Real surTil[:] "Tilt angle of surfaces";
  parameter Real surAzi[:] "Azimuth angle of surfaces";
  parameter Real eps=0.9 "Emissivity of external surface";
  parameter Real alp=0.6 "Absorption coefficient";
  parameter Real surRes=0.04 "External surface heat resistance";

  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[n](
  final til=surTil,
  final azi=surAzi)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain solRadOpa[n](final k=AWal*alp*UWal*surRes)
    "Solar radiation on vertical opaque surfaces"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Modelica.Blocks.Interfaces.RealOutput y "Solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil [n](
  final til=surTil,
  final azi=surAzi)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Add irrOpa[n]
    "Total of direct and diffuse radiation on surface"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Add addOpa[n](each k2=-1)
    "Total of direct and diffuse radiation on vertical surfaces"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Gain theRadOpa[n](each k=5*eps*11*0.5)
    "Extra thermal radiation through walls"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Modelica.Blocks.Math.Add irrRoo
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Math.Gain solRadRoo(final k=ARoo*alp*URoo*surRes)
    "Solar radiation on roof"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Math.Gain theRadRoo(final k=5*eps*11*1)
    "Extra thermal radiation through roof"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Modelica.Blocks.Math.Add addRoo(k2=-1)
    "Total of direct and diffuse radiation on the roof"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=n)
    annotation (Placement(transformation(extent={{48,44},{60,56}})));
  Modelica.Blocks.Math.Add addTot
    "Total of direct and diffuse radiation on the south facade"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
protected
  Modelica.Blocks.Sources.RealExpression facOpa[n](y=UWal*AWal*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTilRoo(til=0, azi=
       0) annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilRof(til=0, azi=0)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
protected
  Modelica.Blocks.Sources.RealExpression facRoo(y=URoo*ARoo*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
equation
  for i in 1:n loop
  connect(weaBus,HDifTil[i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,30},{-80,30}},
      color={255,204,51},
      thickness=0.5));
  end for;

  for i in 1:n loop
  connect(weaBus,HDirTil[i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,70},{-80,70}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(HDirTil.H, irrOpa.u1) annotation (Line(points={{-59,70},{-50,70},{-50,
          76},{-42,76}}, color={0,0,127}));
  connect(HDifTil.H, irrOpa.u2) annotation (Line(points={{-59,30},{-48,30},{-48,
          64},{-42,64}}, color={0,0,127}));

  connect(irrOpa.y, solRadOpa.u)
    annotation (Line(points={{-19,70},{-12,70}}, color={0,0,127}));
  connect(HDirTilRoo.H, irrRoo.u1) annotation (Line(points={{-59,-30},{-50,-30},
          {-50,-24},{-42,-24}}, color={0,0,127}));
  connect(HDifTilRof.H, irrRoo.u2) annotation (Line(points={{-59,-70},{-48,-70},
          {-48,-36},{-42,-36}}, color={0,0,127}));
  connect(HDirTilRoo.weaBus, weaBus) annotation (Line(
      points={{-80,-30},{-90,-30},{-90,0},{-100,0}},
      color={255,204,51},
      thickness=0.5));
  connect(HDifTilRof.weaBus, weaBus) annotation (Line(
      points={{-80,-70},{-90,-70},{-90,0},{-100,0}},
      color={255,204,51},
      thickness=0.5));
  connect(irrRoo.y, solRadRoo.u)
    annotation (Line(points={{-19,-30},{-12,-30}}, color={0,0,127}));
  connect(facRoo.y, theRadRoo.u)
    annotation (Line(points={{-19,-80},{-12,-80}}, color={0,0,127}));
  connect(addOpa.y, multiSum.u)
    annotation (Line(points={{41,50},{48,50}}, color={0,0,127}));
  connect(solRadOpa.y, addOpa.u1) annotation (Line(points={{11,70},{14,70},{14,
          56},{18,56}},
                    color={0,0,127}));
  connect(theRadRoo.y, addRoo.u2) annotation (Line(points={{11,-80},{14,-80},{
          14,-56},{18,-56}},
                          color={0,0,127}));
  connect(solRadRoo.y, addRoo.u1) annotation (Line(points={{11,-30},{14,-30},{
          14,-44},{18,-44}},
                          color={0,0,127}));
  connect(addTot.y, y)
    annotation (Line(points={{93,0},{110,0}}, color={0,0,127}));
  connect(addRoo.y, addTot.u2) annotation (Line(points={{41,-50},{64,-50},{64,-6},
          {70,-6}}, color={0,0,127}));
  connect(multiSum.y, addTot.u1) annotation (Line(points={{61.02,50},{64,50},{64,
          6},{70,6}}, color={0,0,127}));
  connect(facOpa.y, theRadOpa.u)
    annotation (Line(points={{-19,20},{-12,20}}, color={0,0,127}));
  connect(theRadOpa.y, addOpa.u2) annotation (Line(points={{11,20},{14,20},{14,
          44},{18,44}},
                    color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-34,88},{-84,38}},
          lineColor={255,255,0},
          lineThickness=0.5,
          fillColor={244,125,35},
          fillPattern=FillPattern.Sphere),                        Rectangle(
    extent={{-84,28},{-64,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,28},{-4,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,28},{56,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,28},{88,-6}},       fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{34,-12},{88,-46}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),  Rectangle(
    extent={{-26,-12},{28,-46}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-12},{-32,-46}},      fillColor = {255, 213, 170},
   fillPattern =  FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-84,-52},{-64,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{-58,-52},{-4,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{2,-52},{56,-86}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}), Rectangle(
    extent={{62,-52},{88,-84}},      fillColor = {255, 213, 170},
   fillPattern = FillPattern.Solid, lineColor = {175, 175, 175}),
        Text(
          extent={{-110,148},{112,116}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the heat flow by solar gains through each opaque building element <i>k</i>. The heat flow is given by
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>sol,k</sub> =F<sub>sh,k </sub>I<sub>sol,k </sub> &alpha;<sub>k</sub> R<sub>se</sub> U<sub>k</sub>
A<sub>k</sub> - F<sub>f</sub> &Phi;<sub>r,k</sub>
</p>
<p>
where <i>F<sub>sh,k</sub></i> is the shading reduction factor, <i>I<sub>sol,k</sub></i> is the solar irradiance
per square meter of surface area, <i>&alpha;<sub>k</sub></i> is the dimensionless absportion coefficient for solar radiation of the opaque element,
<i>R<sub>se</sub></i> is the external surface heat resistance of the opaque element in (m K/W), and <i>A<sub>k</sub></i> is the area of the opaque element.
</p>
<p>
The form factor between the building element and the sky <i>F<sub>f</sub></i> is set to 1 for roofs and 0.5 for external walls. The extra heat flow due to
thermal radiation to the sky is given by
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>r,k</sub> =h<sub>r</sub> &#916;T<sub>sky</sub> R<sub>se</sub> U<sub>k</sub> A<sub>k</sub>
</p>
<p>
where <i>h<sub>r</sub></i> is the external radiative heat transfer coefficent
which is approximated as 5 &epsilon; W/m<sup>2</sup>K (where &epsilon; is the emissivity for
the thermal radiation of the external surface), and &#916;T<sub>sky</sub> is
the average temperature difference between the external air temperature and the
apparent sky temperature.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end OpaqueElements;
