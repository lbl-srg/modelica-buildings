within Districts.Electrical.AC.AC3ph.Interfaces;
partial model PartialConversionAC3to1ph
  import Districts;
  package PhaseSystem_p = Districts.Electrical.PhaseSystems.ThreePhase_dq
    "3 Phases system: terminal p"
    annotation (choicesAllMatching=true);
  package PhaseSystem_n = Districts.Electrical.PhaseSystems.OnePhase
    "1 Phase system: terminal n"
    annotation (choicesAllMatching=true);
  Districts.Electrical.AC.AC3ph.Interfaces.Terminal_p terminal_p(redeclare
      package PhaseSystem = PhaseSystem_p) annotation (
      Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Districts.Electrical.AC.AC1ph.Interfaces.Terminal_n terminal_a(redeclare
      package PhaseSystem = PhaseSystem_n) annotation (
      Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(
          extent={{90,50},{110,70}})));
  Districts.Electrical.AC.AC1ph.Interfaces.Terminal_n terminal_b(redeclare
      package PhaseSystem = PhaseSystem_n) annotation (
      Placement(transformation(extent={{90,-10},{110,10}}), iconTransformation(
          extent={{90,-10},{110,10}})));
  Districts.Electrical.AC.AC1ph.Interfaces.Terminal_n terminal_c(redeclare
      package PhaseSystem = PhaseSystem_n) annotation (
      Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(
          extent={{90,-70},{110,-50}})));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end PartialConversionAC3to1ph;
