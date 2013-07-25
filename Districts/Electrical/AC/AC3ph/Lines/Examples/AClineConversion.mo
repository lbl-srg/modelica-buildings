within Districts.Electrical.AC.AC3ph.Lines.Examples;
model AClineConversion
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    Phi=0,
    V=15000)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Line line(
    l=2000,
    P_nominal=15000,
    V_nominal=15000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Conversion.ACACConverter aCACConverter(conversionFactor=15000/380, eta=
        0.9)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Line line1(
    l=2000,
    P_nominal=10000,
    V_nominal=380,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  Loads.InductiveLoadP
               loadRL(
    P_nominal=5000,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    V_nominal=380)
    annotation (Placement(transformation(extent={{36,20},{56,40}})));
  Line line2(
    l=2000,
    P_nominal=10000,
    V_nominal=380,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35())
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Loads.InductiveLoadP
               loadRL1(
    P_nominal=5000,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    V_nominal=380)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Loads.CapacitiveLoadP
               loadRC(
    P_nominal=5000,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    V_nominal=380)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
equation
  connect(V.terminal, line.terminal_n) annotation (Line(
      points={{-80,10},{-70,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, aCACConverter.terminal_n) annotation (Line(
      points={{-50,10},{-40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(aCACConverter.terminal_p, line1.terminal_n) annotation (Line(
      points={{-20,10},{-6,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, loadRL.terminal) annotation (Line(
      points={{14,10},{20,10},{20,30},{36,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, line2.terminal_n) annotation (Line(
      points={{14,10},{24,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, loadRL1.terminal) annotation (Line(
      points={{44,10},{60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, loadRC.terminal) annotation (Line(
      points={{44,10},{52,10},{52,-20},{60,-20}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent=
            {{-100,-100},{100,100}}), graphics));
end AClineConversion;
