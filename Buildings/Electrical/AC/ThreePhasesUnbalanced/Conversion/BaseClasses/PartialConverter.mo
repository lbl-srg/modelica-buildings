within Buildings.Electrical.AC.ThreePhasesUnbalanced.Conversion.BaseClasses;
partial model PartialConverter "Partial model of a transformer"
  extends Buildings.Electrical.Icons.RefAngleConversion;
  replaceable Buildings.Electrical.Interfaces.PartialConversion
    conv1 constrainedby Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Transformer phase 1"
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
    conv2 constrainedby Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Transformer phase 2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  replaceable Buildings.Electrical.Interfaces.PartialConversion
    conv3 constrainedby Buildings.Electrical.Interfaces.PartialConversion(
    redeclare package PhaseSystem_p =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n =
        Buildings.Electrical.PhaseSystems.OnePhase,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_n terminal_n,
    redeclare Electrical.AC.OnePhase.Interfaces.Terminal_p terminal_p)
    "Transformer phase 3"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Interfaces.Terminal_n terminal_n "Electrical connector side N"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Interfaces.Terminal_p terminal_p "Electrical connector side P"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  annotation (    Documentation(revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model that represents a three-phase unbalanced
transformer without neutral cable connection.
</p>
</html>"));
end PartialConverter;
