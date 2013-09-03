within Districts.Electrical.AC.ThreePhasesBalanced.Lines.Examples;
model AClineConversion
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=15000,
    Phi=0.5235987755983)
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Line line(
    P_nominal=15000,
    V_nominal=15000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35(),
    l=150)
    annotation (Placement(transformation(extent={{-70,0},{-50,20}})));
  Conversion.ACACConverter AcAc_1(                            eta=0.9,
      conversionFactor=380/15000)
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Line line1(
    P_nominal=10000,
    V_nominal=380,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35(),
    l=200)
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  Loads.InductiveLoadP
               loadRL(
    P_nominal=5000,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=220)
    annotation (Placement(transformation(extent={{70,62},{90,82}})));
  Line line2(
    P_nominal=10000,
    V_nominal=380,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35(),
    l=400)
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Loads.InductiveLoadP
               loadRL1(
    P_nominal=5000,
    V_nominal=380,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Loads.CapacitiveLoadP
               loadRC(
    P_nominal=5000,
    V_nominal=380,
    mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Conversion.ACDCConverter AcDc(eta=0.9, conversionFactor=120/15000)
    "Transformer"
    annotation (Placement(transformation(extent={{-2,-54},{18,-34}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=0.5,
    startTime=0.3)
    annotation (Placement(transformation(extent={{80,-54},{60,-34}})));
  DC.Loads.Conductor loadDC(
    mode=Districts.Electrical.Types.Assumption.VariableZ_y_input,
    P_nominal=2000,
    V_nominal=120)
    annotation (Placement(transformation(extent={{24,-54},{44,-34}})));
  Conversion.ACACConverter AcAc_2(eta=0.9, conversionFactor=220/380)
    annotation (Placement(transformation(extent={{18,62},{38,82}})));
  Line line3(
    P_nominal=10000,
    V_nominal=380,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35(),
    l=400)
    annotation (Placement(transformation(extent={{46,62},{66,82}})));
equation
  connect(V.terminal, line.terminal_n) annotation (Line(
      points={{-80,10},{-70,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, AcAc_1.terminal_n)        annotation (Line(
      points={{-50,10},{-40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(AcAc_1.terminal_p, line1.terminal_n)        annotation (Line(
      points={{-20,10},{-6,10}},
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
  connect(AcDc.terminal_p, loadDC.terminal)       annotation (Line(
      points={{18,-44},{24,-44}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ramp.y, loadDC.y) annotation (Line(
      points={{59,-44},{44,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AcAc_2.terminal_n, line2.terminal_n) annotation (Line(
      points={{18,72},{18,10},{24,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(AcAc_2.terminal_p, line3.terminal_n) annotation (Line(
      points={{38,72},{46,72}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, loadRL.terminal) annotation (Line(
      points={{66,72},{70,72}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, AcDc.terminal_n) annotation (Line(
      points={{-50,10},{-50,-44},{-2,-44}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics));
end AClineConversion;
