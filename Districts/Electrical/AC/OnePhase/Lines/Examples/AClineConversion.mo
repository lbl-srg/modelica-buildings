within Districts.Electrical.AC.OnePhase.Lines.Examples;
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
    mode=Districts.Electrical.Types.Assumption.FixedZ_dynamic,
    P_nominal=1500,
    linear=true)
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Line line1(
    V_nominal=380,
    P_nominal=3500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25(),
    l=200)
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Conversion.ACACConverter ACAC(
    conversionFactor=220/380,
    eta=0.9,
    ground_1=true)
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Line line2(
    V_nominal=220,
    P_nominal=3500,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25(),
    l=200)
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));
  Conversion.ACDCConverter ACDC(conversionFactor=60/380, eta=0.9)
    annotation (Placement(transformation(extent={{-28,-40},{-8,-20}})));
  DC.Loads.Conductor                        load(
    P_nominal=200,
    mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    V_nominal=60,
    linear=true)                                          annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={42,-30})));
  Modelica.Blocks.Sources.Ramp pow(
    duration=0.5,
    startTime=0.2,
    offset=-200,
    height=5200)
    annotation (Placement(transformation(extent={{78,-40},{58,-20}})));
  DC.Lines.Line line(
    l=200,
    P_nominal=1000,
    V_nominal=60,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.PvcAl25())
    annotation (Placement(transformation(extent={{2,-40},{22,-20}})));
equation
  connect(E.terminal, line1.terminal_n) annotation (Line(
      points={{-80,6.66134e-16},{-70,6.66134e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, ACAC.terminal_n)          annotation (Line(
      points={{-50,0},{-28,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(ACAC.terminal_p, line2.terminal_n)          annotation (Line(
      points={{-8,0},{2,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, load1.terminal) annotation (Line(
      points={{22,0},{32,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(pow.y, load.Pow) annotation (Line(
      points={{57,-30},{52,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ACDC.terminal_p, line.terminal_n) annotation (Line(
      points={{-8,-30},{2,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line.terminal_p, load.terminal) annotation (Line(
      points={{22,-30},{32,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, ACDC.terminal_n) annotation (Line(
      points={{-80,0},{-76,0},{-76,-30},{-28,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AClineConversion;
