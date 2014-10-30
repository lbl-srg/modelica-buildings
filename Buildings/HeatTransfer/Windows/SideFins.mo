within Buildings.HeatTransfer.Windows;
model SideFins
  "For a window with side fins, outputs the fraction of the window area exposed to the sun"
  extends Buildings.Rooms.BaseClasses.SideFins;
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialShade_weatherBus;
  Buildings.HeatTransfer.Windows.BaseClasses.SideFins fin(
    final dep=dep,
    final h=h,
    final gap=gap,
    final hWin=hWin,
    final wWin=wWin) "Window side fins"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(fin.fraSun, fraSun)          annotation (Line(
      points={{21,0},{88.25,0},{88.25,1.16573e-015},{95.5,1.16573e-015},{95.5,0},
          {110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(walSolAzi.verAzi, fin.verAzi)            annotation (Line(
      points={{-39,-50},{-20,-50},{-20,4},{-2,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.solAlt, fin.alt) annotation (Line(
      points={{-100,0},{-80,0},{-80,-4},{-2,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fin.fraSun, product.u2) annotation (Line(
      points={{21,0},{40,0},{40,54},{58,54}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation ( Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/SideFins.png")}),
            defaultComponentName="fin",
            Documentation(info="<html>
<p>
For a window with side fins, this model outputs the fraction of
the area that is exposed to the sun.
The model calculates the fraction of the window area that is exposed to the sun.
The side fins are symmetrically placed above the vertical window centerline,
and its height must be equal or greater than the window height.
This models can also be used for doors with side fins.
The figure below shows the parameters. The parameter <code>h</code> is measured
from the top of the window to the top of the side fins.
Side fins are assumed to extend at least to the lower edge of the window.
(Any portion of the side fin below the window edge does not cast
as shadow on the window anyway.)
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/SideFins.png\" />
</p>
<p>
The parameter <code>h</code> is measured
from the top of the window to the top of the side fins.
The side fin must extend at least to the bottom of the window.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/WindowSideFinsExtendedSideFin.png\" />
</p>
<h4>Limitations</h4>
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

<h4>Implementation</h4>
<p>
The detailed calculation method is explained in
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.SideFins\">
Buildings.HeatTransfer.Windows.BaseClasses.SideFins</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of side fin height <code>h</code> to be
measured from the top of the window.
This allows changing the window height without having to adjust the
side fin parameters.
</li>
<li>
February 25, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br/>
First implementation.
</li>
</ul>
</html>"));
end SideFins;
