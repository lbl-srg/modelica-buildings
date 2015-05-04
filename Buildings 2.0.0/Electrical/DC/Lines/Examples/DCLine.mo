within Buildings.Electrical.DC.Lines.Examples;
model DCLine "Example model to test the DC lines"
  extends Modelica.Icons.Example;
  Line line(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=100) "Transmission line"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Sources.ConstantVoltage E(V=50) "Voltage source"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Line line1(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=100) "Transmission line"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Line line2(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=100) "Transmission line"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));
  Loads.Conductor load1(mode=Types.Load.VariableZ_y_input,
    V_nominal=50,
    linearized=false,
    P_nominal=-50) "Variable load"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Loads.Conductor load2(
    V_nominal=50,
    linearized=false,
    P_nominal=-150) "Load"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Loads.Conductor load3(
    V_nominal=50,
    linearized=false,
    P_nominal=-200) "Load"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Sources.Ramp varLoad(
    height=0.8,
    duration=0.5,
    offset=0.2,
    startTime=0.3) "Load consumption profile"
    annotation (Placement(transformation(extent={{96,0},{76,20}})));
equation
  connect(E.terminal, line.terminal_n) annotation (Line(
      points={{-60,10},{-4.44089e-16,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, line1.terminal_n) annotation (Line(
      points={{-60,10},{-30,10},{-30,-10},{0,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, line2.terminal_n) annotation (Line(
      points={{-60,10},{-30,10},{-30,-30},{0,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load1.terminal, line.terminal_p) annotation (Line(
      points={{40,10},{20,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line1.terminal_p, load2.terminal) annotation (Line(
      points={{20,-10},{40,-10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line2.terminal_p, load3.terminal) annotation (Line(
      points={{20,-30},{40,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad.y, load1.y) annotation (Line(
      points={{75,10},{60,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(E.n, ground.p) annotation (Line(
      points={{-80,10},{-80,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1,Tolerance=1e-05),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Lines/Examples/DCLine.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is a simple test case that show how to use a line model
and parametrize it using a commercial cable.
</p>
</html>"));
end DCLine;
