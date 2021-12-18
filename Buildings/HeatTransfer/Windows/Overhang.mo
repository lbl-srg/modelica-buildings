within Buildings.HeatTransfer.Windows;
model Overhang
  "For a window with an overhang, outputs the fraction of the window area exposed to the sun"
  extends Buildings.ThermalZones.Detailed.BaseClasses.Overhang;
  extends Buildings.HeatTransfer.Windows.BaseClasses.PartialShade_weatherBus;
  parameter Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth; azi= -90 degree East; azi= 0 South";
  // Overhang dimensions
protected
  Buildings.HeatTransfer.Windows.BaseClasses.Overhang ove(
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
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solAlt, ove.alt) annotation (Line(
      points={{-100,5.55112e-16},{-12,5.55112e-16},{-12,-4},{-2,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation ( Icon(graphics={Bitmap(extent={{-92,92},{92,-92}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BaseClasses/Overhang.png")}),
defaultComponentName="ove",
Documentation(info="<html>
<p>
For a window with an overhang, this model outputs the fraction of
the area that is exposed to the sun.
The models can also be used for doors with an overhang.
</p>
<p>
The overhang can be asymmetrical (i.e. wR &ne; wL is allowed)
about the vertical centerline of the window. However, the
overhang must completely cover the window,
i.e., <code>wL &ge; 0</code> and <code>wR &ge; 0</code>.
<code>wL</code> and <code>wR</code> must be measured from the respective corner
of the window.
</p>
<p>
The figure below shows the parameters.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/Overhang.png\" />
</p>

<p>
The surface azimuth <code>azi</code> is as defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>.
</p>

<h4>Limitations</h4>
<p>
The model assumes that</p>
<ul>
<li>
the overhang is at least as wide as the window, i.e.,
<i>w<sub>L</sub> &ge; 0</i> and
<i>w<sub>R</sub> &ge; 0</i>, and
</li>
<li>
the overhang is horizontal.
</li>
</ul>

<h4>Implementation</h4>
<p>
The implementation is explained in
<a href=\"modelica://Buildings.HeatTransfer.Windows.BaseClasses.Overhang\">
Buildings.HeatTransfer.Windows.BaseClasses.Overhang</a>.
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
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of <code>wL</code> and <code>wR</code> to be
measured from the corner of the window instead of the centerline.
This allows changing the window width without having to adjust the
overhang parameters.
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
end Overhang;
