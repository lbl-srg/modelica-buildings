within Buildings.Electrical.Interfaces;
partial model ResistiveLoad "Partial model of a resistive load"
  extends Load;

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 14, 2015, by Marco Bonvini:<br/>
Created model to solve problems related to OpenModelica as described
in issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/415\">#415</a>.<br/>
OpenModelica cannot determine the value
<code>PhaseSystem.n</code> when models like
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Resistive\">
Buildings.Electrical.AC.OnePhase.Loads.Resistive</a>
inherit directly from
<a href=\"modelica://Buildings.Electrical.Interfaces.LoadBuildings.Electrical.Interfaces.Load\">
Buildings.Electrical.Interfaces.LoadBuildings.Electrical.Interfaces.Load</a>.<br/>
The same problem does not happen with models like
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Capacitive\">
Buildings.Electrical.AC.OnePhase.Loads.Capacitive</a> or
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Inductive\">
Buildings.Electrical.AC.OnePhase.Loads.Inductive</a> since they inherit
from a different model.<br/>
For such a reason this interface for resistive load model has been
added to the library.
</li>
</ul>
</html>", info="<html>
<p>
This is a model of a generic resistive load. This model is an extension of the base load model
<a href=\"modelica://Buildings.Electrical.Interfaces.Load\">
Buildings.Electrical.Interfaces.Load</a>.
</p>
</html>"));
end ResistiveLoad;
