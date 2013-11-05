within Buildings.Electrical.AC.ThreePhasesBalanced.Lines.Examples;
model ACline
  extends Modelica.Icons.Example;
  Sources.FixedVoltage V_1(
    Phi=0,
    f=60,
    V=15000)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Loads.InductiveLoadP
               load_1(                mode=Types.Assumption.FixedZ_steady_state,
    P_nominal=155000,
    V_nominal=15000)                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,70})));
  Line line1(
    commercialCable_low=Transmission.LowVoltageCables.Cu50(),
    P_nominal=200000,
    V_nominal=15000,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    commercialCable_med=
        Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_30(),

    voltageLevel=Buildings.Electrical.Types.VoltageLevel.Medium,
    l=2000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,70})));
  Sources.FixedVoltage V_2(
    Phi=0,
    f=60,
    V=15000)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Loads.InductiveLoadP load_2(
    mode=Types.Assumption.FixedZ_steady_state,
    P_nominal=155000,
    V_nominal=15000)                  annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,10})));
  Line line2(
    P_nominal=200000,
    V_nominal=15000,
    mode=Buildings.Electrical.Types.CableMode.commercial,
    commercialCable_med=
        Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_30(),

    voltageLevel=Buildings.Electrical.Types.VoltageLevel.Low,
    commercialCable_low=Buildings.Electrical.Transmission.LowVoltageCables.Cu10
        (),
    l=2000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,10})));
equation
  connect(line1.terminal_p,load_1. terminal) annotation (Line(
      points={{20,70},{40,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_p, load_2.terminal) annotation (Line(
      points={{20,10},{40,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(V_1.terminal, line1.terminal_n) annotation (Line(
      points={{-60,70},{0,70}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(line2.terminal_n, V_2.terminal) annotation (Line(
      points={{0,10},{-60,10}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),        graphics));
end ACline;
