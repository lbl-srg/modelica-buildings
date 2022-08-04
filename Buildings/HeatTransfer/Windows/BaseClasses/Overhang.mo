within Buildings.HeatTransfer.Windows.BaseClasses;
block Overhang
  "For a window with an overhang, outputs the fraction of the area that is sun exposed"
  extends Modelica.Blocks.Icons.Block;
  extends Buildings.ThermalZones.Detailed.BaseClasses.Overhang;

  Modelica.Blocks.Interfaces.RealInput verAzi(
    quantity="Angle",
    unit="rad",
    displayUnit="deg")
    "Wall solar azimuth angle (angle between projection of sun's rays and normal to vertical surface)"
  annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

   Modelica.Blocks.Interfaces.RealInput alt(
     quantity="Angle",
     unit="rad",
     displayUnit="deg") "Altitude angle"
  annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput fraSun(final min=0,
                                               final max=1,
                                               final unit="1")
    "Fraction of window area exposed to the sun"
  annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  parameter Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth; azi= -90 degree East; azi= 0 degree South";

// Window dimensions
  parameter Modelica.Units.SI.Length hWin "Window height"
    annotation (Dialog(tab="General", group="Window"));
  parameter Modelica.Units.SI.Length wWin "Window width"
    annotation (Dialog(tab="General", group="Window"));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data"
   annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));

protected
  constant Modelica.Units.SI.Angle delSolAzi=0.005
    "Half-width of transition interval between left and right formulation for overhang";

  final parameter Modelica.Units.SI.Area AWin=hWin*wWin "Window area";
  parameter Modelica.Units.SI.Length tmpH[4](each fixed=false)
    "Height rectangular sections used for superposition";
  Modelica.Units.SI.Length w
    "Either wL or wR, depending on the sun relative to the wall azimuth";
  Modelica.Units.SI.Length tmpW[4]
    "Width of rectangular sections used for superpositions";
  Modelica.Units.SI.Length del_L=wWin/100
    "Fraction of window dimension over which min-max functions are smoothened";
  Modelica.Units.SI.Length x1
    "Horizontal distance between window side edge and shadow corner";
  Modelica.Units.SI.Length x2[4]
    "Horizontal distance between window side edge and point where shadow line and window lower edge intersects";
  Modelica.Units.SI.Length y1
    "Vertical distance between overhang and shadow lower edge";
  Modelica.Units.SI.Length y2[4]
    "Window height (vertical distance corresponding to x2)";
  Real shdwTrnglRtio "Ratio of y1 and x1";
  Modelica.Units.SI.Area area[4]
    "Shaded areas of the sections used in superposition";
  Modelica.Units.SI.Area shdArea "Shaded area calculated from equations";
  Modelica.Units.SI.Area crShdArea "Final value for shaded area";
  Modelica.Units.SI.Area crShdArea1
    "Corrected for the sun behind the surface/wall";
  Modelica.Units.SI.Area crShdArea2 "Corrected for the sun below horizon";

  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth solAzi
    "Solar azimuth"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

initial equation
  assert(wL >= 0,  "Overhang must cover complete window
    Received overhang width on left hand side, wL = " + String(wL));
  assert(wR >= 0,  "Overhang must cover complete window
    Received overhang width on right hand side, wR = " + String(wR));

  for i in 1:4 loop
    tmpH[i] = gap + mod((i - 1), 2)*hWin;
  end for;

equation
  // if dep=0, then the equation
  //   y1*Modelica.Math.cos(verAzi) = dep*Modelica.Math.tan(alt);
  // is singular. Hence, we treat this special case with an
  // if-then construct.
  // This also increases computing efficiency in
  // Buildings.HeatTransfer.Windows.FixedShade in case the window has no overhang.

  if haveOverhang then
    //Temporary height and widths are for the areas below the overhang
    //These areas are used in superposition
    w = Buildings.Utilities.Math.Functions.spliceFunction(
            pos=wL,
            neg=wR,
            x=solAzi.solAzi-azi,
            deltax=delSolAzi);
    tmpW[1] = w + wWin;
    tmpW[2] = w;
    tmpW[3] = w;
    tmpW[4] = w + wWin;
    y1*Modelica.Math.cos(verAzi) = dep*Modelica.Math.tan(alt);
    x1 = dep*Modelica.Math.tan(verAzi);
    shdwTrnglRtio*x1 = y1;
    for i in 1:4 loop
      y2[i] = tmpH[i];
      // For the equation below, Dymola generated the following code in MixedAirFreeResponse.
      // This led to a division by zero as y1 crosses zero. The problem occurred in an
      // FMU simulation. Therefore, we guard against division by zero when computing
      // x2[i].
      //  roo.bouConExtWin.sha[1].ove.x2[1] := roo.bouConExtWin.sha[1].ove.x1*
      //  roo.bouConExtWin.sha[1].ove.tmpH[1]/roo.bouConExtWin.sha[1].ove.y1;
      // x2[i]*y1 = x1*tmpH[i];

      x2[i] = x1*tmpH[i]/Buildings.Utilities.Math.Functions.smoothMax(
        x1=y1, x2=1E-8*hWin, deltaX=1E-9*hWin);
      area[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=y1,
        x2=y2[i],
          deltaX=del_L)*tmpW[i] - (Buildings.Utilities.Math.Functions.smoothMin(
        y1,
        tmpH[i],
        del_L)*Buildings.Utilities.Math.Functions.smoothMin(
        x1=x2[i],
        x2=y1,
        deltaX=del_L)/2) + Buildings.Utilities.Math.Functions.smoothMax(
        x1=shdwTrnglRtio*(Buildings.Utilities.Math.Functions.smoothMin(
          x1=x1,
          x2=x2[i],
          deltaX=del_L) - tmpW[i]),
        x2=0,
        deltaX=del_L)*Buildings.Utilities.Math.Functions.smoothMax(
        x1=(Buildings.Utilities.Math.Functions.smoothMin(
          x1=x1,
          x2=x2[i],
          deltaX=del_L) - tmpW[i]),
        x2=0,
        deltaX=del_L)/2;
    end for;
    shdArea = area[4] + area[3] - area[2] - area[1];
  // correction case: Sun not in front of the wall
    crShdArea1 = Buildings.Utilities.Math.Functions.spliceFunction(
      pos=shdArea,
      neg=AWin,
      x=(Modelica.Constants.pi/2)-verAzi,
      deltax=0.01);
  // correction case: Sun not above horizon
    crShdArea2 = Buildings.Utilities.Math.Functions.spliceFunction(
      pos=shdArea,
      neg=AWin,
      x=alt,
      deltax=0.01);
    crShdArea=Buildings.Utilities.Math.Functions.smoothMax(x1=crShdArea1,
                                                           x2=crShdArea2,
                                                           deltaX=0.01);
    fraSun = Buildings.Utilities.Math.Functions.smoothMin(
        x1=Buildings.Utilities.Math.Functions.smoothMax(x1=1-crShdArea/AWin,x2=0,deltaX=0.01),
        x2=1.0,
        deltaX=0.01);
  else
    w = 0;
    tmpW=fill(0.0, 4);
    y1 = 0;
    x1 = 0;
    shdwTrnglRtio = 0;
    for i in 1:4 loop
      y2[i] = 0;
      x2[i] = 0;
      area[i] = 0;
    end for;
    shdArea = 0;
    crShdArea1 = 0;
    crShdArea2 = 0;
    crShdArea  = 0;
    fraSun     = 0;
   end if;

  connect(weaBus.solTim, solAzi.solTim) annotation (Line(
      points={{-102,0},{-80,0},{-80,-4},{-62,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solZen, solAzi.zen) annotation (Line(
      points={{-102,5.55112e-16},{-80,5.55112e-16},{-80,6},{-62,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solDec, solAzi.decAng) annotation (Line(
      points={{-102,5.55112e-16},{-92,5.55112e-16},{-92,1.22125e-15},{-82,
          1.22125e-15},{-82,6.66134e-16},{-62,6.66134e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus.lat, solAzi.lat) annotation (Line(
      points={{-102,0},{-80,0},{-80,-10},{-62,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation ( Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
                              Bitmap(extent={{-114,98},{122,-94}},
fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="overhang",
Documentation(info="<html>
<p>
For a window with an overhang, this block outputs the fraction of
the area that is exposed to the sun.
This models can also be used for doors with an overhang.
</p>
<p>
Input to this block are the
wall solar azimuth angle and the altitude angle of the sun.
These angles can be calculated using blocks from the package
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses\">
Buildings.BoundaryConditions.SolarGeometry.BaseClasses</a>.
</p>
<p>
The overhang can be asymmetrical (i.e. <code>wR &ne; wL</code>)
about the vertical centerline
of the window.
The overhang must completely cover the window (i.e.,
<code>wL &ge; 0</code> and
<code>wR &ge; 0</code>).
<code>wL</code> and <code>wR</code> are measured from the left and right edge of the window.
</p>
<p>
The surface azimuth <code>azi</code> is as defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>.
</p>
<h4>Implementation</h4>
<p>
The method of super position is used to calculate the window shaded area.
The area below the overhang is divided as shown in the figure.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/OverhangSuperPosition.png\" />
</p>
<p>
Dimensional variables used in code for the rectangle <i>DEGI, AEGH, CFGI</i> and <i>BFGH</i>
are shown in the figure below:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/OverhangVariables.png\" />
</p>
<p>
The rectangles <i>DEGI, AEGH, CFGI</i> and <i>BFGH</i> have the same geometric configuration
with respect to the overhang.
Thus, the same algorithm can be used to calculate the shaded portion in these areas.
A single equation in the <code>for</code> loop improves the total calculation time,
as compared to <code>if-then-else</code>
conditions, considering the various shapes of the shaded portions.
To find the shaded area in window <i>ABCD</i>, the shaded portion of <i>AEGD</i> and <i>CFGI</i>
should be subtracted from that of <i>DEGI</i> and <i>BFGH</i>.
This shaded area of the window is then divided by the total window area
to calculate the shaded fraction of the window.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
October 28, 2014, by Michael Wetter:<br/>
Reformulated <code>shdwTrnglRtio*x1 = y1</code> to avoid a division by
zero if the model is exported as an FMU.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/234\">#234</a>.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of <code>wL</code> and <code>wR</code> to be
measured from the corner of the window instead of the centerline.
This allows changing the window width without having to adjust the
overhang parameters.
</li>
<li>
July 5, 2012, by Michael Wetter:<br/>
Revised implementation to avoid state events when horizontal projection
of the sun beam is perpendicular to window.
</li>
<li>
May 7, 2012, by Kaustubh Phalak:<br/>
Modified for use of asymmetrical overhang.
</li>
<li>
Feb 23, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end Overhang;
