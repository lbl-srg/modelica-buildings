within Districts.Electrical.AC.AC3ph.Conversion.Examples;
model ACACConverter
  import Districts;
  extends Modelica.Icons.Example;
  Districts.Electrical.AC.AC3ph.Conversion.ACACConverter trasformer(
      conversionFactor=380/15000, eta=0.9)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Districts.Electrical.AC.AC3ph.Sources.FixedVoltage V(
    f=50,
    Phi=0,
    V(displayUnit="kV") = 15000)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.5,
    startTime=0.3)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Districts.Electrical.AC.AC3ph.Loads.LoadRL loadRL(mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
      P_nominal=12000)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
equation
  connect(V.terminal, trasformer.terminal_n) annotation (Line(
      points={{-60,10},{-10,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(trasformer.terminal_p, loadRL.terminal) annotation (Line(
      points={{10,10},{20,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, loadRL.y) annotation (Line(
      points={{59,10},{40,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end ACACConverter;
