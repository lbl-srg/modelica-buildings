within Districts.Electrical.AC.ThreePhasesBalanced.Conversion.Examples;
model ACACConverter
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.ThreePhasesBalanced.Conversion.ACACConverter
                                                         tra(conversionFactor=
        380/15000, eta=0.9) "Transformer"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Sources.FixedVoltage
                                                     V(
    f=50,
    Phi=0,
    V(displayUnit="kV") = 15000)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.3,
    offset=-2000,
    height=4000)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Districts.Electrical.AC.ThreePhasesBalanced.Loads.CapacitiveLoadP
    inductiveLoadP(P_nominal=2000, mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    annotation (Placement(transformation(extent={{26,0},{46,20}})));
equation
  connect(V.terminal, tra.terminal_n)        annotation (Line(
      points={{-60,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(tra.terminal_p, inductiveLoadP.terminal) annotation (Line(
      points={{10,10},{26,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, inductiveLoadP.Pow) annotation (Line(
      points={{59,10},{46,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics));
end ACACConverter;
