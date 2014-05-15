within Buildings.Electrical.Interfaces;
partial model PartialBaseTwoPort "Partial model of a generic two port system"

  replaceable Buildings.Electrical.Interfaces.BaseTerminal terminal_n
    annotation (Placement(transformation(extent={{-108,-8},{-92,8}})));
  replaceable Buildings.Electrical.Interfaces.BaseTerminal terminal_p
    annotation (Placement(transformation(extent={{92,-8},{108,8}})));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
</ul>
</html>"));
end PartialBaseTwoPort;
