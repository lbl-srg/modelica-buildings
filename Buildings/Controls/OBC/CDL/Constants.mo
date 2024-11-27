within Buildings.Controls.OBC.CDL;
package Constants
  "Package with constants"
  // Machine dependent constants
  final constant Real eps=1E-15
    "Biggest number such that 1.0 + eps = 1.0";
  final constant Real small=1E-37
    "Smallest number such that small and -small are representable on the machine";
  final constant Real pi=2*Modelica.Math.asin(1.0)
    "Constant number pi, 3.14159265358979";
  annotation (
    Documentation(
      info="<html>
<p>
This package provides often needed constants.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 12, 2024, by Michael Wetter:<br/>
Changed <code>small</code> to <i>1E-37</i>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3695\">issue 3695</a>.
</li>
<li>
March 27, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={-9.2597,25.6673},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{48.017,11.336},{48.017,11.336},{10.766,11.336},{-25.684,10.95},{-34.944,-15.111},{-34.944,-15.111},{-32.298,-15.244},{-32.298,-15.244},{-22.112,0.168},{11.292,0.234},{48.267,-0.097},{48.267,-0.097}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={-19.9923,-8.3993},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{3.239,37.343},{3.305,37.343},{-0.399,2.683},{-16.936,-20.071},{-7.808,-28.604},{6.811,-22.519},{9.986,37.145},{9.986,37.145}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={23.753,-11.5422},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-10.873,41.478},{-10.873,41.478},{-14.048,-4.162},{-9.352,-24.8},{7.912,-24.469},{16.247,0.27},{16.247,0.27},{13.336,0.071},{13.336,0.071},{7.515,-9.983},{-3.134,-7.271},{-2.671,41.214},{-2.671,41.214}},
          smooth=Smooth.Bezier),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end Constants;
