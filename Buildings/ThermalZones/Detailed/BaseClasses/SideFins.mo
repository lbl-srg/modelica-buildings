within Buildings.ThermalZones.Detailed.BaseClasses;
record SideFins "Record for window side fins"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Length h(min=0)
    "Height of side fin that extends above window, measured from top of window"
    annotation (Dialog(tab="General", group="Side fin"));
  parameter Modelica.Units.SI.Length dep(min=0)
    "Side fin depth (measured perpendicular to the wall plane)"
    annotation (Dialog(tab="General", group="Side fin"));
  parameter Modelica.Units.SI.Length gap(min=0)
    "Distance between side fin and window edge"
    annotation (Dialog(tab="General", group="Side fin"));

  final parameter Boolean haveSideFins= dep > Modelica.Constants.eps
    "Flag, true if the window has side fins" annotation (Evaluate=true);

  annotation (
Documentation(info="<html>
<p>
This record declares parameters for window side fins.
</p>
<p>
See
<a href=\"modelica://Buildings.HeatTransfer.Windows.SideFins\">
Buildings.HeatTransfer.Windows.SideFins</a>
for an explanation of the parameters, and
for the assumptions and limitations
of the model for side fins.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2012, by Michael Wetter:<br/>
Changed definitions of side fin height <code>h</code> to be
measured from the top of the window.
This allows changing the window height without having to adjust the
side fin parameters.
</li>
<li>
May 21, 2012, by Kaustubh Phalak:<br/>
Removed <code>gap &gt; 0</code> as a necessary condition. There can be a side fin with no gap.
</li>
<li>
March 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end SideFins;
