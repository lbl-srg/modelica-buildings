within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
partial model TwoPort_N
  "Partial model interface for a two port component with neutral cable"

  Terminal4_p terminal_p "Electric terminal side p"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Terminal4_n terminal_n "Electric terminal side n"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  annotation (Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Added model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
Interface model for an AC three-phase unbalanced component with two ports
and with neutral cable.
</p>
</html>"));
end TwoPort_N;
