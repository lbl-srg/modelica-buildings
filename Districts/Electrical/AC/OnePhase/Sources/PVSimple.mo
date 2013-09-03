within Districts.Electrical.AC.OnePhase.Sources;
model PVSimple
  import Districts;
  extends Districts.Electrical.Interfaces.PartialPV(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.OnePhase, redeclare
      Interfaces.Terminal_p terminal);

  parameter Real pf(min=0, max=1) = 0.9 "Power factor"
    annotation (Dialog(group="AC-Conversion"));
  parameter Real eta_DCAC(min=0, max=1) = 0.9 "Efficiency of DC/AC conversion"
    annotation (Dialog(group="AC-Conversion"));
  Modelica.Blocks.Math.Gain gain_DCAC(k=eta_DCAC) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={12,0})));
protected
  replaceable Districts.Electrical.AC.OnePhase.Loads.CapacitiveLoadP load(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
      pf=pf) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(load.terminal, terminal) annotation (Line(
      points={{-40,0},{-100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(solarPower.y, gain_DCAC.u) annotation (Line(
      points={{70,0},{24,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain_DCAC.y, load.Pow) annotation (Line(
      points={{1,0},{-20,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end PVSimple;
