within Districts.Electrical.Interfaces;
partial model PartialSource
  replaceable package PhaseSystem =
      Districts.Electrical.PhaseSystems.OnePhase
       constrainedby Districts.Electrical.PhaseSystems.PartialPhaseSystem
    "Phase system"
    annotation (choicesAllMatching=true);
  function j = PhaseSystem.j;
  Modelica.SIunits.Power S[PhaseSystem.n] = PhaseSystem.phasePowers_vi(terminal.v, terminal.i);
  Modelica.SIunits.Angle phi = PhaseSystem.phase(terminal.v) - PhaseSystem.phase(-terminal.i);
  parameter Boolean potentialReference = true "serve as potential root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  parameter Boolean definiteReference = false "serve as definite root"
     annotation (Evaluate=true, Dialog(group="Reference Parameters"));
  replaceable Districts.Electrical.Interfaces.Terminal terminal(redeclare
      package PhaseSystem =
        PhaseSystem) "Generalised terminal"
    annotation (Placement(transformation(extent={{92,-8},{108,8}})));
equation
  if PhaseSystem.m > 0 then
    if potentialReference then
      if definiteReference then
        Connections.root(terminal.theta);
      else
        Connections.potentialRoot(terminal.theta);
      end if;
    end if;
  end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PartialSource;
