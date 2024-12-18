within Buildings.ThermalZones.ISO13790.BaseClasses;
model GlazedElements "Solar gains through glazed elements"
  parameter Integer n;
  parameter Modelica.Units.SI.Area AWin[:] "Area of windows";
  parameter Real coeFac[:] "Coefficient of g-factor reduction";
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer UWin "U-value of windows";
  parameter Modelica.Units.SI.Angle surTil[:] "Tilt angle of surfaces";
  parameter Modelica.Units.SI.Angle surAzi[:] "Azimuth angle of surfaces";
  parameter Real eps=0.9 "Emissivity of external surface";
  parameter Modelica.Units.SI.ThermalInsulance surRes=0.04 "External surface heat resistance";
  parameter Real gFac "Energy transmittance of glazings";
  parameter Real winFra "Frame fraction of windows";
  parameter Real shaRedFac(
    final min=0,
    final unit="1")= 1 "Shading reduction factor";

  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-120,-20},{-80,20}}), iconTransformation(extent=
           {{-110,-10},{-90,10}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[n](
  final til=surTil,
  final azi=surAzi)
    "Direct solar irradiation on surface"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Gain solRad[n](final k=AWin*gFac*shaRedFac*(1 - winFra))
    "Solar radiation trasmitted through windows"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Interfaces.RealOutput solRadWin
    "Solar radiation through windows"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[n](
  final til=surTil,
  final azi=surAzi)
    "Diffuse solar irradiation on surface"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Math.Gain theRadWin[n](each k=5*eps*11*0.5)
    "Extra thermal radiation through windows"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Math.Add addWin[n](each k2=-1)
    "Total solar gains through windows"
    annotation (Placement(transformation(extent={{40,-16},{60,4}})));
  Modelica.Blocks.Math.Product HDirAng[n]
    "Direct solar irradiation considering incident angle of surface"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Utilities.Math.Polynomial polynomial[n](each a=coeFac)
    "Ratio of direct solar irradiation considering incident angle of surface"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
protected
  Modelica.Blocks.Math.Add irr[n]
    "Total of direct and diffuse radiation on surface"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Math.MultiSum multiSum(nu=n) "Sum of all orientations"
    annotation (Placement(transformation(extent={{74,-6},{86,6}})));

protected
  Modelica.Blocks.Sources.RealExpression facWin[n](y=UWin*AWin*surRes) "factor"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation
  for i in 1:n loop
  connect(weaBus,HDifTil[i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,-30},{-80,-30}},
      color={255,204,51},
      thickness=0.5));
  end for;

  for i in 1:n loop
  connect(weaBus,HDirTil[i].weaBus) annotation (Line(
      points={{-100,0},{-90,0},{-90,30},{-80,30}},
      color={255,204,51},
      thickness=0.5));
  end for;
  connect(multiSum.y, solRadWin)
    annotation (Line(points={{87.02,0},{110,0}}, color={0,0,127}));

  connect(irr.y, solRad.u)
    annotation (Line(points={{-19,0},{-10,0}},
                                            color={0,0,127}));
  connect(facWin.y,theRadWin. u)
    annotation (Line(points={{-19,-50},{-2,-50}},color={0,0,127}));
  connect(theRadWin.y, addWin.u2) annotation (Line(points={{21,-50},{30,-50},{30,
          -12},{38,-12}}, color={0,0,127}));
  connect(addWin.y, multiSum.u)
    annotation (Line(points={{61,-6},{68,-6},{68,0},{74,0}}, color={0,0,127}));
  connect(solRad.y, addWin.u1)
    annotation (Line(points={{13,0},{38,0}}, color={0,0,127}));
  connect(HDirTil.H, HDirAng.u2) annotation (Line(points={{-59,30},{-30,30},{-30,
          44},{-2,44}}, color={0,0,127}));
  connect(HDifTil.H, irr.u2) annotation (Line(points={{-59,-30},{-50,-30},{-50,-6},
          {-42,-6}}, color={0,0,127}));
  connect(HDirAng.y, irr.u1) annotation (Line(points={{21,50},{30,50},{30,20},{-50,
          20},{-50,6},{-42,6}}, color={0,0,127}));
  connect(HDirTil.inc, polynomial.u) annotation (Line(points={{-59,26},{-50,26},
          {-50,70},{-42,70}}, color={0,0,127}));
  connect(polynomial.y, HDirAng.u1) annotation (Line(points={{-19,70},{-10,70},
          {-10,56},{-2,56}}, color={0,0,127}));
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
where <i>F<sub>sh,k</sub></i> is the shading reduction factor which is set to 1 by default, 
<i>I<sub>sol,k</sub></i> is the solar irradiance
per square meter of surface area, <i>g<sub>fac</sub></i> is the total solar energy transmittance of the trasparent
element, <i>F<sub>frame</sub></i> is the frame area fraction, and <i>A<sub>win,k</sub></i> is the overall area of 
the glazed element in square meters.
</p>
<p>
Additionally, an extra heat flow is modeled to represent the thermal radiation emitted towards the sky as
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Phi;<sub>r,k</sub> =h<sub>r</sub> &#916;T<sub>sky</sub> R<sub>se</sub> U<sub>k</sub> A<sub>k</sub>
</p>
<p>
where <i>h<sub>r</sub></i> is the external radiative heat transfer coefficient
which is approximated as 5 &epsilon; W/m<sup>2</sup>K (where &epsilon; is the emissivity for
the thermal radiation of the external surface), and &#916;T<sub>sky</sub> is
the average temperature difference between the external air temperature and the
apparent sky temperature.
</p>
</html>", revisions="<html><ul>
<li>
May 15, 2024, by Alessandro Maccarini:<br/>
Added the parameter <code>coeFac</code> in order to vary the g-factor as a function of the incident angle of the surface.
</li>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end GlazedElements;
