within Buildings.HeatTransfer.Windows.BaseClasses;
block SideFins
  "For a window with side fins, outputs the fraction of the area that is sun exposed"
  extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput alt(quantity="Angle",
                                           unit="rad",
                                           displayUnit="deg")
    "Solar altitude angle (angle between sun ray and horizontal surface)"
  annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput verAzi(quantity="Angle",
                                              unit="rad",
                                              displayUnit="deg")
    "Angle between projection of sun's rays and normal to vertical surface"
  annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput fraSun(final min=0,
                                               final max=1,
                                               final unit="1")
    "Fraction of window area exposed to the sun"
  annotation (Placement(transformation(extent={{100,-10},{120,10}})));
// Side fin dimensions
  parameter Modelica.SIunits.Length h
    "Side fin height (measured vertically and parallel to wall plane)"
    annotation(Dialog(tab="General",group="Side fin"));
  parameter Modelica.SIunits.Length dep
    "Side fin depth (measured perpendicular to the wall plane)"
    annotation(Dialog(tab="General",group="Side fin"));
  parameter Modelica.SIunits.Length gap
    "Distance between window upper edge and side fin"
    annotation(Dialog(tab="General",group="Side fin"));
// Window dimensions
  parameter Modelica.SIunits.Length hWin "Window height"
    annotation(Dialog(tab="General",group="Window"));
  parameter Modelica.SIunits.Length wWin "Window width"
    annotation(Dialog(tab="General",group="Window"));
// Other calculation variables
protected
  final parameter Modelica.SIunits.Length tempHght[4]=
                  {h, h - hWin, h, h - hWin}
    "Height of rectangular sections used for superposition";
  final parameter Modelica.SIunits.Length tempWdth[4]=
                  {gap + wWin,gap + wWin,gap, gap}
    "Width of rectangular sections used for superpositions; c1,c2 etc";
  final parameter Modelica.SIunits.Length deltaL=wWin/100
    "Fraction of window dimension over which min-max functions are smoothened";
  final parameter Modelica.SIunits.Area AWin=hWin*wWin "Window area";
  Modelica.SIunits.Length x1[4]
    "Horizontal distance between side fin and point where shadow line and window lower edge intersects";
  Modelica.SIunits.Length x2
    "Horizontal distance between side fin and shadow corner";
  Modelica.SIunits.Length x3[4] "Window width";
  Modelica.SIunits.Length y1[4] "Window height";
  Modelica.SIunits.Length y2
    "Vertical distance between window upper edge and shadow corner";
  Modelica.SIunits.Length y3[4]
    "Vertical distance between window upper edge and point where shadow line and window side edge intersects";
  Modelica.SIunits.Area area[4]
    "Shaded areas of the sections used in superposition";
  Modelica.SIunits.Area shdArea "Shaded area";
  Modelica.SIunits.Area crShdArea "Final value of shaded area";
  Modelica.SIunits.Area crShdArea1
    "Shaded area, corrected for the sun behind the surface/wall";
  Modelica.SIunits.Area crShdArea2
    "Shaded area, corrected for the sun below horizon";
  Modelica.SIunits.Length minX[4];
  Modelica.SIunits.Length minY[4];
  Modelica.SIunits.Length minX2X3[4];
  Modelica.SIunits.Length minY2Y3[4];
  Real delta=1e-6 "Small number to avoid division by zero";
  Real tanLambda
    "Tangent of angle between horizontal and sun ray projection on vertical wall";
  Real verAzi_t;
  Real lambda_t;
  Real verAzi_c;
  Real alt_t;
initial algorithm
  assert(h == 0 or h >= hWin, "Sidefins must be at least as high as the window.
  Received h    = " + String(h) + "
           hWin = " + String(hWin));
equation
  // This if-then construct below increases computing efficiency in
  // Buildings.HeatTransfer.Windows.Shade in case the window has no overhang.
  if h > Modelica.Constants.eps then
  //avoiding division by zero
    lambda_t = Buildings.Utilities.Math.Functions.smoothMax(
      x1=tanLambda,
      x2=delta,
      deltaX=delta/10);
    verAzi_t = Buildings.Utilities.Math.Functions.smoothMax(
      x1=Modelica.Math.tan(verAzi),
      x2=delta,
      deltaX=delta/10);
    verAzi_c = Buildings.Utilities.Math.Functions.smoothMax(
      x1=Modelica.Math.cos(verAzi),
      x2=delta,
      deltaX=delta/10);
    alt_t = Buildings.Utilities.Math.Functions.smoothMax(
      x1=Modelica.Math.tan(alt),
      x2=delta,
      deltaX=delta/10);
    tanLambda = alt_t / verAzi_t;
    y2 = dep*alt_t/verAzi_c;
    x2 = dep*verAzi_t;
    for i in 1:4 loop
      x1[i] = tempHght[i]/lambda_t;
      x3[i] = tempWdth[i];
      y1[i] = tempHght[i];
      y3[i] = tempWdth[i]*lambda_t;
      minX2X3[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=x2,
        x2=x3[i],
        deltaX=deltaL);
      minX[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=x1[i],
        x2=minX2X3[i],
        deltaX=deltaL);
      minY2Y3[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=y2,
        x2=y3[i],
        deltaX=deltaL);
      minY[i] = Buildings.Utilities.Math.Functions.smoothMin(
        x1=y1[i],
        x2=minY2Y3[i],
        deltaX=deltaL);
      area[i] = tempHght[i]*minX[i] - minX[i]*minY[i]/2;
    end for;
  //by superposition
    shdArea = area[1] + area[4] - area[2] - area[3];
    // The corrections below ensure that the shaded area is 1 if the
    // sun is below the horizon or behind the wall.
    // This correction is not required (because the direct solar irradiation
    // will be zero in this case), but it leads to more realistic time series
    // of this model.
  //correction case: Sun not in front of the wall
    crShdArea1 = Buildings.Utilities.Math.Functions.spliceFunction(
       pos=shdArea,
       neg=AWin,
       x=(Modelica.Constants.pi/2)-verAzi,
       deltax=0.01);
  //correction case: Sun below horizon
    crShdArea2 = Buildings.Utilities.Math.Functions.spliceFunction(
       pos=shdArea,
       neg=AWin,
       x=alt,
       deltax=0.01);
    crShdArea=Buildings.Utilities.Math.Functions.smoothMax(
       x1=crShdArea1,
       x2=crShdArea2,
       deltaX=0.0001*AWin);
    fraSun = 1-crShdArea/AWin;
  else
    lambda_t = 0;
    verAzi_t = 0;
    verAzi_c = 0;
    alt_t =    0;
    tanLambda = 0;
    y2 = 0;
    x2 = 0;
    for i in 1:4 loop
      x1[i] = 0;
      x3[i] = 0;
      y1[i] = 0;
      y3[i] = 0;
      minX2X3[i] = 0;
      minX[i]    = 0;
      minY2Y3[i] = 0;
      minY[i]    = 0;
      area[i]    = 0;
    end for;
    shdArea = 0;
    crShdArea1 = 0;
    crShdArea2 = 0;
    crShdArea  = 0;
    fraSun     = 0;
  end if;
  annotation ( Diagram(graphics), Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/SideFins.png")}),
defaultComponentName="fin",
Documentation(info="<html>
<p>
For a window with side fins, this block outputs the fraction of 
the area that is exposed to the sun.
This models can also be used for doors with side fins. 
</p>
<p>
Input to this block are the 
wall solar azimuth angle and the altitude angle of the sun. 
These angles can be calculated using blocks from the package
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.BaseClasses\">
Buildings.BoundaryConditions.SolarGeometry.BaseClasses</a>. 
</p>
<h4>Limitations</h4>
<p>
The model assumes that 
<ul>
<li>
the side fins are placed symmetrically to the left and right of the window,
</li>
<li> 
the top of the side fins must be at an equal or greater height than the window, and
</li>
<li>
the bottom of the side fins must be at an equal or lower height than the 
bottom of the window.
</li>
</ul> 
</p>
<h4>
Implementation
</h4>
<p>
The method of super position is used to calculate the shaded area of the window. 
The area besides the side fin is divided as shown in the figure below. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/SideFinsSuperPosition.png\" border=\"1\">
</p>
<p>
Variables used in the code for the rectangle <i>AEGI, BEGH, DFGI</i> and <i>CFGH</i> are shown in figure below. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/SideFinsVariables.png\" border=\"1\" width=325 height=290>
</p>
<p>
The rectangles <i>AEGI, BEGH, DFGI</i> and <i>CFGH</i>  have the same geometric configuration 
with respect to the side fin.
Thus, the same algorithm is used to calculate the shaded portion in these areas. 
A single equation in the <code>for</code> loop improves the total calculation time, 
as compared to <code>if-then-else</code> 
conditions, considering the various shapes of the shaded portions.
To find the shaded area in the window <i>ABCD</i>, the shaded portion of 
<i>BEGH</i> and <i>DFGI</i> is subtracted from <i>AEGI</i> and <i>CFGH</i>.
This shaded area of the window is then divided by the total window area 
to calculate the shaded fraction of the window. 
</p>
</html>",
revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br>
Revised implementation.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end SideFins;
