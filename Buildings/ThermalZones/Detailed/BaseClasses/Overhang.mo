within Buildings.ThermalZones.Detailed.BaseClasses;
record Overhang "Record for window overhang"
  extends Modelica.Icons.Record;

  parameter Modelica.Units.SI.Length wL(min=0)
    "Overhang width left to the window, measured from the window corner"
    annotation (Dialog(tab="General", group="Overhang"));
  parameter Modelica.Units.SI.Length wR(min=0)
    "Overhang width right to the window, measured from the window corner"
    annotation (Dialog(tab="General", group="Overhang"));

  parameter Modelica.Units.SI.Length dep(min=0)
    "Overhang depth (measured perpendicular to the wall plane)"
    annotation (Dialog(tab="General", group="Overhang"));
  parameter Modelica.Units.SI.Length gap(min=0)
    "Distance between window upper edge and overhang lower edge"
    annotation (Dialog(tab="General", group="Overhang"));

  final parameter Boolean haveOverhang= dep > Modelica.Constants.eps
    "Flag, true if the window has an overhang"
    annotation(Evaluate=true);

  annotation (
Documentation(info="<html>
<p>
This record declares parameters for window overhangs.
</p>
<p>
See
<a href=\"modelica://Buildings.HeatTransfer.Windows.Overhang\">
Buildings.HeatTransfer.Windows.Overhang</a>
for an explanation of the parameters, and
for the assumptions and limitations
of the overhang model.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of <code>wL</code> and <code>wR</code> to be
measured from the corner of the window instead of the centerline.
This allows changing the window width without having to adjust the
overhang parameters.
</li>
<li>
May 21, 2012, by Kaustubh Phalak:<br/>
Removed <code>gap &gt; 0</code> as a necessary condition.
There can be an overhang with no gap.
</li>
<li>
March 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end Overhang;
