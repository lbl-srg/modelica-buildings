within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
partial model PartialSource
  "Partial model for a three-phase AC unbalanced voltage source without neutral cable"

  Interfaces.Connection3to4_p connection3to4
    "Connection between three to four AC connectors"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  OnePhase.Basics.Ground ground "Ground reference"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Interfaces.Terminal_p terminal
    "Connector for three-phase unbalanced systems"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  connect(connection3to4.terminal3,terminal)  annotation (Line(
      points={{60,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ground.terminal,connection3to4. terminal4.phase[4]) annotation (Line(
      points={{20,-40},{20,0},{40,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This model is a partial class extended by three-phase unbalanced
voltage sources without neutral cable connection.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>"));
end PartialSource;
