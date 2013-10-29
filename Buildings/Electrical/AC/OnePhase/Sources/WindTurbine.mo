within Buildings.Electrical.AC.OnePhase.Sources;
model WindTurbine
  import Buildings;
  extends Buildings.Electrical.Interfaces.PartialWindTurbine(redeclare package
      PhaseSystem = Buildings.Electrical.PhaseSystems.OnePhase, redeclare
      Interfaces.Terminal_p terminal);
  parameter Real pf(min=0, max=1) = 0.9 "Power factor"
    annotation (Dialog(group="AC-Conversion"));
  parameter Real eta_DCAC(min=0, max=1) = 0.9 "Efficiency of DC/AC conversion"
    annotation (Dialog(group="AC-Conversion"));
  replaceable Buildings.Electrical.AC.OnePhase.Loads.CapacitiveLoadP load(mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
      pf=pf) annotation (Placement(transformation(extent={{12,-10},{32,10}})));
  Modelica.Blocks.Math.Gain gain_DCAC(k=eta_DCAC) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={52,0})));
equation
  connect(load.terminal, terminal) annotation (Line(
      points={{12,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(gain_DCAC.y, load.Pow) annotation (Line(
      points={{41,0},{32,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, gain_DCAC.u) annotation (Line(
      points={{13,20},{80,20},{80,0},{64,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end WindTurbine;
