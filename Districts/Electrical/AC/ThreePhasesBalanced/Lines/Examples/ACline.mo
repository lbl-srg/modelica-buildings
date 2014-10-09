within Districts.Electrical.AC.ThreePhasesBalanced.Lines.Examples;
model ACline
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Line line(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    l=250,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,70})));
  Loads.InductiveLoadP
               loadRL(                mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=380,
    P_nominal=5000)                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,70})));
  Line line1(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    l=250,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,70})));
  Sources.FixedVoltage V1(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Line line2(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu35(),
    l=500)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,30})));
  Loads.InductiveLoadP
               loadRL1(               mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=380,
    P_nominal=5000)                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  Line line3(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    l=500,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25())
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,40})));
  Sources.FixedVoltage V2(
    f=50,
    V=380,
    Phi=0)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Line line4(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    l=250,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu50())
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-30})));
  Loads.InductiveLoadP
               loadRL2(
                      P_nominal=2500, mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=380)                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-30})));
  Line line5(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25(),
    l=250)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-30})));
  Loads.InductiveLoadP
               loadRL3(
                      P_nominal=2500, mode=Districts.Electrical.Types.Assumption.FixedZ_steady_state,
    V_nominal=380)                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  Line line6(
    V_nominal=380,
    P_nominal=5000,
    mode=Districts.Electrical.Types.CableMode.commercial,
    commercialCable=Districts.Electrical.Transmission.CommercialCables.Cu25(),
    l=250)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,0})));
equation
  connect(line.terminal_n, V.terminal) annotation (Line(
      points={{-40,70},{-60,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line.terminal_p, line1.terminal_n) annotation (Line(
      points={{-20,70},{0,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line1.terminal_p, loadRL.terminal) annotation (Line(
      points={{20,70},{40,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_n, V1.terminal)
                                       annotation (Line(
      points={{-20,30},{-60,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, loadRL1.terminal) annotation (Line(
      points={{0,30},{40,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V1.terminal, line3.terminal_n) annotation (Line(
      points={{-60,30},{-40,30},{-40,40},{-20,40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line3.terminal_p, loadRL1.terminal) annotation (Line(
      points={{0,40},{20,40},{20,30},{40,30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_n, V2.terminal)
                                       annotation (Line(
      points={{-40,-30},{-60,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line4.terminal_p, line5.terminal_n) annotation (Line(
      points={{-20,-30},{0,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line5.terminal_p, loadRL2.terminal) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_p, loadRL3.terminal) annotation (Line(
      points={{20,0},{40,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line6.terminal_n, line5.terminal_n) annotation (Line(
      points={{0,0},{-20,0},{-20,-30},{-5.55112e-16,-30}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics));
end ACline;
