within Districts.Electrical.AC.AC1ph.Lines.Examples;
model AClineConversion
  extends Modelica.Icons.Example;
  Sources.FixedVoltage E(      definiteReference=true,
    f=50,
    Phi=0,
    V=380)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Loads.InductiveLoadP
                 load1(
    V_nominal=220,
    P_nominal=150,
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Line line1(
    Length=2000,
    V_nominal=380,
    P_nominal=3500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25())
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Conversion.ACACConverter aCACConverter(
    conversionFactor=220/380,
    eta=0.9,
    ground_1=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Line line2(
    V_nominal=220,
    P_nominal=3500,
    Length=500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25())
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
equation
  connect(E.terminal, line1.terminal_n) annotation (Line(
      points={{-80,6.66134e-16},{-52,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, aCACConverter.terminal_n) annotation (Line(
      points={{-32,0},{-10,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(aCACConverter.terminal_p, line2.terminal_n) annotation (Line(
      points={{10,0},{26,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, load1.terminal) annotation (Line(
      points={{46,0},{60,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AClineConversion;
