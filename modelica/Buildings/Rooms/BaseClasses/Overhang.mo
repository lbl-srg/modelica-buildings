within Buildings.Rooms.BaseClasses;
record Overhang "Record for window overhang"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Length w "Overhang width";
  parameter Modelica.SIunits.Length gap "Gap between window and overhang";
  parameter Modelica.SIunits.Length dep "Overhang depth";
  final parameter Boolean haveOverhang= w > 0 or gap > 0 or dep > 0
    "Flag, true if the window has an overhang";

  annotation (
Documentation(info="<html>
<p>
This record is used for declaring and propagating 
parameters for window overhangs.
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
March 5, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end Overhang;
