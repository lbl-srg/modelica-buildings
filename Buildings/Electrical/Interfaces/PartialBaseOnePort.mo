within Buildings.Electrical.Interfaces;
model PartialBaseOnePort "Model of a generic one port component"

  replaceable Buildings.Electrical.Interfaces.BaseTerminal terminal
    "Generalized terminal"
    annotation (Placement(transformation(extent={{-8,92},{8,108}}),
      iconTransformation(extent={{-8,92},{8,108}})));
  annotation (Documentation(revisions="<html>
<ul>
<li>
October 15, 2021, by Mingzhe Liu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model declares connector for electrical components using one terminal.
</p>
</html>"));
end PartialBaseOnePort;
