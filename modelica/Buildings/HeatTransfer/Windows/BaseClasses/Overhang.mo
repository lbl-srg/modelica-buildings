within Buildings.HeatTransfer.Windows.BaseClasses;
block Overhang
  "Block to calculate the fraction of window area shaded by an overhang"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.RealInput alt(quantity="Angle", unit="rad", displayUnit="deg")
    "Solar altitude angle (angle between sun ray and horizontal surface)"
  annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));    //beta
  Modelica.Blocks.Interfaces.RealInput verAzi(quantity="Angle", unit="rad", displayUnit="deg")
    "Wall solar azimuth angle (angle between projection of sun's rays and normal to vertical surface)"
  annotation (Placement(transformation(extent={{-140,20},{-100,60}})));       //gamma
  Modelica.Blocks.Interfaces.RealOutput frc(min=0, max=1)
    "Fraction of window area shaded by overhang"
  annotation (Placement(transformation(extent={{100,-10},{120,10}})));
// Overhang dimensions
  parameter Modelica.SIunits.Length wid
    "Overhang width (measured horizontally and parallel to wall plane)"
    annotation(Dialog(tab="General",group="Overhang"));            //d (remove after documentation)
  parameter Modelica.SIunits.Length dep
    "Overhang depth (measured perpendicular to the wall plane)"
    annotation(Dialog(tab="General",group="Overhang"));            //b
  parameter Modelica.SIunits.Length gap
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(tab="General",group="Overhang"));           //e
// Window dimensions
  parameter Modelica.SIunits.Length winHt "Window height"
    annotation(Dialog(tab="General",group="Window"));              //a
  parameter Modelica.SIunits.Length winWid "Window width"
    annotation(Dialog(tab="General",group="Window"));                        //c
// Other calculation variables
protected
  final parameter Modelica.SIunits.Area winArea= winHt*winWid "Window area";
  parameter Modelica.SIunits.Length tempHght[4](fixed=false)
    "Height rectangular sections used for superposition";
  parameter Modelica.SIunits.Length tempWdth[4](fixed=false)
    "Width of rectangular sections used for superpositions";
  parameter Modelica.SIunits.Length del_L(fixed=false)
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
initial algorithm
  assert(wid >= winWid, "Overhang must be at least as wide as the window.
  Received wid    = " + String(wid) + "
           winWid = " + String(winWid));
  del_L := winWid/100;
//Temporary height and widths are for the areas below the overhang
//These areas are used in superposition
  for i in 1:4 loop
    tempHght[i] := gap + mod((i - 1), 2)*winHt;
  end for;
  tempWdth[1] := (wid + winWid)/2;
  tempWdth[2] := (wid - winWid)/2;
  tempWdth[3] := (wid - winWid)/2;
  tempWdth[4] := (wid + winWid)/2;
equation
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
//correction case: Sun not in front of the wall
  crShdArea1 = Buildings.Utilities.Math.Functions.spliceFunction(
    pos=shdArea,
    neg=1,
    x=(Modelica.Constants.pi/2)-verAzi,
    deltax=0.01);
//correction case: Sun not above horizon
  crShdArea2 = Buildings.Utilities.Math.Functions.spliceFunction(
    pos=shdArea,
    neg=1,
    x=alt,
    deltax=0.01);
  crShdArea=Buildings.Utilities.Math.Functions.smoothMax(x1=crShdArea1,
                                                         x2=crShdArea2,
                                                         deltaX=0.01);
  frc = crShdArea/winArea;

  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="overhang",
Documentation(info="<html>
<p>
This component calculates the fraction of total window area 
shaded by an overhang.
This models can also be used for doors with an overhang. 
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
<li>the overhang is placed symmetrically about the 
window vertical center-line,
</li>
<li> 
the overhang length is greater than or equal to the window width, and
</li>
<li>
the overhang is horizontal.
</li>
</ul>
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
Dimensional variables used in code for the rectangle <i>DEGI, AEGD, CFGI</i> and <i>BFGH</i>
are shown in the figure below:
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/OverhangVariables.png\" border=\"1\" width=275 height=357>
</p>
<p>
The rectangles <i>DEGI, AEGD, CFGI</i> and <i>BFGH</i> have the same geometric configuration 
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
