within Buildings.Electrical.Interfaces;
record PartialPluggableUnbalanced "Partial interface for unbalanced loads"
  parameter Boolean plugPhase1 = true "If true, phase 1 is connected";
  parameter Boolean plugPhase2 = true "If true, phase 2 is connected";
  parameter Boolean plugPhase3 = true "If true, phase 3 is connected";
  annotation (Documentation(info="<html>
<p>
This record contains a set of parameters that are used when
modeling three-phase unbalanced systems. The record contains three boolean flags
that are used to determine which of the three-phase are connected to the network.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Changed <code>PlugPhase*</code> to <code>plugPhase*</code>.
</li>
<li>
June 4, 2014, by Marco Bonvini:<br/>
Added the information section.
</li>
</ul>
</html>"));
end PartialPluggableUnbalanced;
