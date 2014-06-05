within Buildings.Electrical.Interfaces;
record PartialPluggableUnbalanced "Partial interface for unbalanced loads"
  parameter Boolean PlugPhase1 = true "If true, phase 1 is connected";
  parameter Boolean PlugPhase2 = true "If true, phase 2 is connected";
  parameter Boolean PlugPhase3 = true "If true, phase 3 is connected";
  annotation (Documentation(info="<html>
<p>
This record contains a set of parameters that are used when
modeling 3 phases unbalanced systems. The record contains three boolean flags
that are used to determine which of the three phases are connected to the network.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2014, by Marco Bonvini:<br/>
Added the information section.
</li>
</ul>
</html>"));
end PartialPluggableUnbalanced;
