within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
partial model PartialSource_N "Partial model for a three phases AC unbalanced voltage source
  with neutral cable"

  OnePhase.Basics.Ground ground "Ground reference"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Interfaces.Terminal4_p terminal
    "Connector for three phases unbalanced systems with neutral cable"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
equation

  connect(ground.terminal, terminal.phase[4]) annotation (Line(
      points={{20,-40},{20,0},{100,0}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation ( Documentation(info="<html>
<p>
This model is a partial class extended by three phases unbalanced
voltage sources that have a neutral cable.
</p>
<p>
The neutral cable is connected to the ground reference.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialSource_N;
