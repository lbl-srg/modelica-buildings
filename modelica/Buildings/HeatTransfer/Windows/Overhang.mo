within Buildings.HeatTransfer.Windows;
model Overhang
  "Block to calculate the fraction of window area shaded by a window overhang"
  import Buildings;
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialShade_weatherBus;

  // Overhang dimensions
  parameter Modelica.SIunits.Length wid
    "Overhang width (measured horizontally and parallel to wall plane)"
    annotation(Dialog(tab="General",group="Overhang"));
  parameter Modelica.SIunits.Length dep
    "Overhang depth (measured perpendicular to the wall plane)"
    annotation(Dialog(tab="General",group="Overhang"));
  parameter Modelica.SIunits.Length gap
    "Distance between window upper edge and overhang lower edge"
    annotation(Dialog(tab="General",group="Overhang"));

// Other calculation variables
protected
  Buildings.HeatTransfer.Windows.BaseClasses.Overhang ove(
    final wid=wid,
    final dep=dep,
    final gap=gap,
    final winHt=winHt,
    final winWid=winWid) "Window overhang"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(ove.frc, frc)          annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, ove.verAzi)             annotation (Line(
      points={{21,50},{40,50},{40,4},{58,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ove.frc, frc)    annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(weaBus.sol.alt, ove.alt) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-4},{58,-4}},
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
This block calculates the fraction of the total window area that is shaded by an overhang.
The overhang is symmetrically placed above the window, and its length must be
equal or greater than the window width.
The figure below shows the parameters.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/Overhang.png\" border=\"1\">
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
