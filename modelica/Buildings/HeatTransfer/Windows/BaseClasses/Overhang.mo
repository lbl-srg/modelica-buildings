within Buildings.HeatTransfer.Windows.BaseClasses;
block Overhang
  "For a window with an overhang, outputs the fraction of the area that is sun exposed"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.RealInput verAzi(quantity="Angle", unit="rad", displayUnit="deg")
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
  parameter Modelica.SIunits.Angle lat "Latitude";

  parameter Modelica.SIunits.Angle azi(displayUnit="deg")
    "Surface azimuth; azi= -90 degree East; azi= 0 degree South";

// Overhang dimensions
  parameter Modelica.SIunits.Length wR
    "Overhang width on right hand side from window vertical centerline"
    annotation(Dialog(tab="General",group="Overhang"));
  parameter Modelica.SIunits.Length wL
    "Overhang width on left hand side from window vertical centerline"
    annotation(Dialog(tab="General",group="Overhang"));
  parameter Modelica.SIunits.Length dep
    "Overhang depth (measured perpendicular to the wall plane)"
    annotation(Dialog(tab="General",group="Overhang"));
  parameter Modelica.SIunits.Length gap
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(tab="General",group="Overhang"));
// Window dimensions
  parameter Modelica.SIunits.Length hWin "Window height"
    annotation(Dialog(tab="General",group="Window"));
  parameter Modelica.SIunits.Length wWin "Window width"
    annotation(Dialog(tab="General",group="Window"));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
   annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));

protected
  final parameter Modelica.SIunits.Area AWin= hWin*wWin "Window area";
  Modelica.SIunits.Length tempHght[4]
    "Height rectangular sections used for superposition";
  Modelica.SIunits.Length tempWdth[4]
    "Width of rectangular sections used for superpositions";
  Modelica.SIunits.Length del_L
    "Fraction of window dimension over which min-max functions are smoothened";
  Modelica.SIunits.Length x1
    "Horizontal distance between window side edge and shadow corner";
  Modelica.SIunits.Length x2[4]
    "Horizontal distance between window side edge and point where shadow line and window lower edge intersects";
  Modelica.SIunits.Length y1
    "Vertical distance between overhang and shadow lower edge";
  Modelica.SIunits.Length y2[4]
    "Window height (vertical distance corresponding to x2)";
  Real shdwTrnglRtio "ratio of y1 and x1";
  Modelica.SIunits.Area area[4]
    "Shaded areas of the sections used in superposition";
  Modelica.SIunits.Area shdArea "Shaded area calculated from equations";
  Modelica.SIunits.Area crShdArea "Final value for shaded area";
  Modelica.SIunits.Area crShdArea1
    "Corrected for the sun behind the surface/wall";
  Modelica.SIunits.Area crShdArea2 "Corrected for the sun below horizon";
public
  BoundaryConditions.SolarGeometry.BaseClasses.SolarAzimuth           solAzi(lat=lat)
    "Solar azimuth"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

algorithm
    assert((wR+wL) == 0 or (wR >= wWin/2),  "Overhang must cover complete window
    Received overhang width on right hand side (wR) = " + String(wR) + "
             half window width (wWin/2) = " + String(wWin/2));
    assert((wR+wL) == 0 or  (wL >= wWin/2), "Overhang must cover complete window
    Received overhang width on left hand side (wL) = " + String(wL) + "
             half window width (wWin/2) = " + String(wWin/2));
  del_L := wWin/100;

//Temporary height and widths are for the areas below the overhang
//These areas are used in superposition
 if (solAzi.solAzi-azi)<0.00 then
   tempWdth[1] :=(2*wR + wWin)/2;
   tempWdth[2] :=(2*wR - wWin)/2;
   tempWdth[3] :=(2*wR - wWin)/2;
   tempWdth[4] :=(2*wR + wWin)/2;

 else
   tempWdth[1] :=(2*wL + wWin)/2;
   tempWdth[2] :=(2*wL - wWin)/2;
   tempWdth[3] :=(2*wL - wWin)/2;
   tempWdth[4] :=(2*wL + wWin)/2;
 end if;

  for i in 1:4 loop
    tempHght[i] :=gap + mod((i - 1), 2)*hWin;
  end for;

equation
  // if dep=0, then the equation
  //   y1*Modelica.Math.cos(verAzi) = dep*Modelica.Math.tan(alt);
  // is singular. Hence, we treat this special case with an
  // if-then construct.
  // This also increases computing efficiency in
  // Buildings.Rooms.BaseClasses.Shade in case the window has no overhang.

  if dep > Modelica.Constants.eps then
    y1*Modelica.Math.cos(verAzi) = dep*Modelica.Math.tan(alt);
    x1 = dep*Modelica.Math.tan(verAzi);
    shdwTrnglRtio*x1 = y1;
    for i in 1:4 loop
      y2[i] = tempHght[i];
      x2[i]*y1 = x1*tempHght[i];
      area[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=y1,
        x2=y2[i],
          deltaX=del_L)*tempWdth[i] - (Buildings.Utilities.Math.Functions.smoothMin(
        y1,
        tempHght[i],
        del_L)*Buildings.Utilities.Math.Functions.smoothMin(
        x1=x2[i],
        x2=y1,
        deltaX=del_L)/2) + Buildings.Utilities.Math.Functions.smoothMax(
        x1=shdwTrnglRtio*(Buildings.Utilities.Math.Functions.smoothMin(
          x1=x1,
          x2=x2[i],
          deltaX=del_L) - tempWdth[i]),
        x2=0,
        deltaX=del_L)*Buildings.Utilities.Math.Functions.smoothMax(
        x1=(Buildings.Utilities.Math.Functions.smoothMin(
          x1=x1,
          x2=x2[i],
          deltaX=del_L) - tempWdth[i]),
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
      points={{-102,5.55112e-16},{-88,5.55112e-16},{-88,-6},{-62,-6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.sol.zen, solAzi.zen) annotation (Line(
      points={{-102,5.55112e-16},{-79,5.55112e-16},{-79,6},{-62,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.sol.dec, solAzi.decAng) annotation (Line(
      points={{-102,5.55112e-16},{-92,5.55112e-16},{-92,1.22125e-15},{-82,
          1.22125e-15},{-82,6.66134e-16},{-62,6.66134e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
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
of the window but overhang should completely cover the window (i.e.,
<code>wR &gt; wWin/2</code> and 
<code>wL &gt; wWin/2</code>). 
<code>wR</code> and <code>wL</code> should always be measured from the window vertical center-line. 
</p>
<p>
The surface azimuth <code>azi</code> is as defined in 
<a href=\"modelica://Buildings.HeatTransfer.Types.Azimuth\">
Buildings.HeatTransfer.Types.Azimuth</a>.
</p>
<h4>Implementation</h4>
<p>
The method of super position is used to calculate the window shaded area. 
The area below the overhang is divided as shown in the figure. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/OverhangSuperPosition.png\" border=\"1\">
</p>
<p>
Dimensional variables used in code for the rectangle <i>DEGI, AEGH, CFGI</i> and <i>BFGH</i>
are shown in the figure below:
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/OverhangVariables.png\" border=\"1\" width=275 height=357>
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
May 7, 2012, by Kaustubh Phalak:<br>
Modified for use of asymmetrical overhang.
</li>
<li>
Feb 23, 2012, by Michael Wetter:<br>
Revised implementation.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end Overhang;
