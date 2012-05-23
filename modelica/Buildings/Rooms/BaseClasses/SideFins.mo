within Buildings.Rooms.BaseClasses;
record SideFins "Record for window side fins"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Length h "Sidefins height";
  parameter Modelica.SIunits.Length dep "Sidefins depth";
  parameter Modelica.SIunits.Length gap "Gap between window and side fins";
  final parameter Boolean haveSideFins= h > 0 or dep > 0 or gap > 0
    "Flag, true if the window has side fins" annotation (Evaluate=true);

  annotation (
Documentation(info="<html>
<p>
This record is used for declaring and propagating
parameters for window side fins.
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
March 5, 2012, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

end SideFins;
