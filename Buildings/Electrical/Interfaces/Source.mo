within Buildings.Electrical.Interfaces;
model Source "Partial model of a generic source."
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.OnePhase constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Boolean potentialReference = true
    "Serve as potential root for the reference angle theta"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false
    "Serve as definite root for the reference angle theta"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  Modelica.Units.SI.Power S[PhaseSystem.n]=PhaseSystem.phasePowers_vi(terminal.v,
      terminal.i) "Complex power S[1] = P, S[2]= Q";
  Modelica.Units.SI.Angle phi=PhaseSystem.phase(terminal.v) - PhaseSystem.phase(
      -terminal.i) "Phase shift with respect to reference angle";
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(
    redeclare final replaceable package PhaseSystem = PhaseSystem)
    "Generalized terminal"
    annotation (Placement(transformation(extent={{92,-8},{108,8}})));
protected
  function j = PhaseSystem.j;
equation
  if potentialReference then
      if definiteReference then
        Connections.root(terminal.theta);
      else
        Connections.potentialRoot(terminal.theta);
      end if;
  end if;
  annotation ( Documentation(revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Updated documentation for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/427\">issue 427</a>.
</li>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included into the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generic source.
</p>
<p>
In case the phase system has <code>PhaseSystem.m &gt; 0</code> and
thus the connectors are over determined,
the source can be selected to serve as reference point.
The parameters <code>potentialReference</code> and <code>definiteReference</code>
are used to define if the source model should be selected as source for
the reference angles <code>theta</code> or not.
More information about overdetermined connectors can be found
in <a href=\"#Olsson2008\">Olsson Et Al. (2008)</a>.
</p>

<h4>References</h4>
<p>
<a name=\"Olsson2008\"/>
Hans Olsson, Martin Otter, Sven Erik Mattson and Hilding Elmqvist.<br/>
<a href=\"http://elib-v3.dlr.de/55892/1/otter2008-modelica-balanced-models.pdf\">
Balanced Models in Modelica 3.0 for Increased Model Quality</a>.<br/>
Proc. of the 7th Modelica Conference, Bielefeld, Germany, March 2008.
</p>
</html>"));
end Source;
