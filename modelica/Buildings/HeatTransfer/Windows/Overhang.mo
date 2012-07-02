within Buildings.HeatTransfer.Windows;
model Overhang
  "For a window with an overhang, outputs the fraction of the window area exposed to the sun"
  import Buildings;
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialShade_weatherBus;
  parameter Modelica.SIunits.Angle lat(displayUnit="deg") "Latitude";
  parameter Modelica.SIunits.Angle azi(displayUnit="deg")
    "Surface azimuth; azi= -90 degree East; azi= 0 South";
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
protected
  Buildings.HeatTransfer.Windows.BaseClasses.Overhang ove(
    final lat=lat,
    final azi=azi,
    final wR=wR,
    final wL=wL,
    final dep=dep,
    final gap=gap,
    final hWin=hWin,
    final wWin=wWin) "Window overhang"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(ove.fraSun, fraSun)          annotation (Line(
      points={{21,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, ove.verAzi)             annotation (Line(
      points={{-39,-50},{-20,-50},{-20,4},{-2,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ove.fraSun, product.u2) annotation (Line(
      points={{21,6.10623e-16},{40,6.10623e-16},{40,54},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus, ove.weaBus) annotation (Line(
      points={{-100,5.55112e-16},{-75.05,5.55112e-16},{-75.05,1.16573e-15},{
          -50.1,1.16573e-15},{-50.1,6.10623e-16},{-0.2,6.10623e-16}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.sol.alt, ove.alt) annotation (Line(
      points={{-100,5.55112e-16},{-12,5.55112e-16},{-12,-4},{-2,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (Diagram(graphics), Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="ove",
Documentation(info="<html>
<p>
For a window with an overhang, this block outputs the fraction of 
the area that is exposed to the sun.
This models can also be used for doors with an overhang. 
</p>
<p>
The overhang can be asymmetrical (i.e. wR &ne; wL is allowed) about the vertical centerline of the window but 
overhang should completely cover the window (i.e. wR &gt; wWin/2 and wL &gt; wWin/2). 
wR and wL should always be measured from window vertical center-line. <br>
The figure below shows the parameters.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/Overhang.png\"width=\"480\" height=\"496\"  border=\"1\">
</p>
<p>
The surface azimuth <code>azi</code> is as defined in 
<a href=\"modelica://Buildings.HeatTransfer.Types.Azimuth\">
Buildings.HeatTransfer.Types.Azimuth</a>.
</p>
<h4>Limitations</h4>
<p>
The model assumes that the overhang completely covers the window, and that the overhang is horizontal.
</p>
<h4>Implementation</h4>
<p>
The detailed calculation method is explained in 
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Overhang\">
Buildings.HeatTransfer.Windows.BaseClasses.Overhang</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br>
Revised implementation.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br>
First implementation. 
</li>
</ul>
</html>"));
end Overhang;
