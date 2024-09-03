within Buildings.Electrical.DC.Lines.Examples;
model DCLines
  "Example model to test the possible combinations between line and load models"
  extends Modelica.Icons.Example;
  parameter Boolean linearLoads = false
    "Flag that selects between linearized or nonlinear load models";
  parameter Real L = 10 "Length of each cable";
  Modelica.Units.SI.Power Sloads=load1.S[1] + load2.S[1] + load3.S[1] + load4.S[
      1] + load5.S[1] + load6.S[1] + load7.S[1] + load8.S[1] + load9.S[1] +
      load10.S[1] "Sum of the power consumed by the loads";
  Line line(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L,
    terminal_n(v(each start=0))) "Transmission line"
    annotation (Placement(transformation(extent={{-2,70},{18,90}})));
  Sources.ConstantVoltage E(V=50) "Voltage source"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Line line1(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-32,70},{-12,90}})));

  Line line2(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-34,30},{-14,50}})));

  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Loads.Conductor load1(mode=Types.Load.VariableZ_y_input,
    V_nominal=50,
    linearized=linearLoads,
    P_nominal=-150) "Load"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Loads.Conductor load2(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-120) "Load"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Loads.Conductor load3(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-200) "Load"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Modelica.Blocks.Sources.Trapezoid
                               varLoad1(
    offset=0.4,
    amplitude=0.6,
    rising=600,
    width=1000,
    falling=800,
    period=3600,
    startTime=1800) "Power consumption profile"
    annotation (Placement(transformation(extent={{86,30},{66,50}})));
  Loads.Conductor load4(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-120) "Load"
    annotation (Placement(transformation(extent={{30,12},{50,32}})));
  Line line3(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,30},{22,50}})));

  Line line4(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Line line5(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,12},{22,32}})));

  Line line0(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-64,70},{-44,90}})));

  Modelica.Blocks.Sources.Trapezoid
                               varLoad2(
    startTime=1800,
    amplitude=0.8,
    rising=400,
    width=1300,
    falling=900,
    period=4000,
    offset=0.1) "Power consumption profile"
    annotation (Placement(transformation(extent={{86,70},{66,90}})));
  Line line6(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-34,-10},{-14,10}})));

  Loads.Conductor load5(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-200) "Load"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Sources.Trapezoid
                               varLoad3(
    amplitude=0.7,
    rising=660,
    width=900,
    falling=300,
    period=3700,
    offset=0.3,
    startTime=200) "Power consumption profile"
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));
  Loads.Conductor load6(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-120) "Load"
    annotation (Placement(transformation(extent={{30,-28},{50,-8}})));
  Line line7(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));

  Line line8(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,-28},{22,-8}})));

  Line line9(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-34,-50},{-14,-30}})));

  Loads.Conductor load7(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-200) "Load"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Blocks.Sources.Trapezoid
                               varLoad4(
    rising=600,
    width=1000,
    falling=800,
    period=3600,
    amplitude=0.1,
    offset=0.8,
    startTime=3300) "Power consumption profile"
    annotation (Placement(transformation(extent={{86,-50},{66,-30}})));
  Loads.Conductor load8(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-120) "Load"
    annotation (Placement(transformation(extent={{30,-68},{50,-48}})));
  Line line10(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,-50},{22,-30}})));

  Line line11(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,-68},{22,-48}})));

  Line line12(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{-34,-90},{-14,-70}})));

  Loads.Conductor load9(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-200) "Load"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Modelica.Blocks.Sources.Trapezoid
                               varLoad5(
    falling=800,
    amplitude=0.5,
    rising=800,
    width=800,
    period=3000,
    offset=0.5,
    startTime=0) "Power consumption profile"
    annotation (Placement(transformation(extent={{86,-90},{66,-70}})));
  Loads.Conductor load10(
    V_nominal=50,
    mode=Types.Load.VariableZ_y_input,
    linearized=linearLoads,
    P_nominal=-120) "Load"
    annotation (Placement(transformation(extent={{30,-108},{50,-88}})));
  Line line13(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=L) "Transmission line"
    annotation (Placement(transformation(extent={{2,-90},{22,-70}})));

  Line line14(
    P_nominal=500,
    V_nominal=50,
    mode=Types.CableMode.commercial,
    commercialCable=Transmission.LowVoltageCables.PvcAl16(),
    l=100) "Transmission line"
    annotation (Placement(transformation(extent={{2,-108},{22,-88}})));

equation
  connect(load1.terminal, line.terminal_p) annotation (Line(
      points={{30,80},{18,80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line1.terminal_p, line.terminal_n) annotation (Line(
      points={{-12,80},{-2,80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line2.terminal_p, line3.terminal_n) annotation (Line(
      points={{-14,40},{2,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line3.terminal_p, load3.terminal) annotation (Line(
      points={{22,40},{30,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line1.terminal_p, line4.terminal_n) annotation (Line(
      points={{-12,80},{-6,80},{-6,60},{0,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line4.terminal_p, load2.terminal) annotation (Line(
      points={{20,60},{30,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load4.terminal, line5.terminal_p) annotation (Line(
      points={{30,22},{22,22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line5.terminal_n, line3.terminal_n) annotation (Line(
      points={{2,22},{-8,22},{-8,40},{2,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.terminal, line0.terminal_n) annotation (Line(
      points={{-70,80},{-64,80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line0.terminal_p, line1.terminal_n) annotation (Line(
      points={{-44,80},{-32,80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad1.y, load3.y) annotation (Line(
      points={{65,40},{50,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad1.y, load4.y) annotation (Line(
      points={{65,40},{58,40},{58,22},{50,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad2.y, load1.y) annotation (Line(
      points={{65,80},{50,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad2.y, load2.y) annotation (Line(
      points={{65,80},{58,80},{58,60},{50,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line6.terminal_p,line7. terminal_n) annotation (Line(
      points={{-14,0},{2,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line7.terminal_p,load5. terminal) annotation (Line(
      points={{22,0},{30,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load6.terminal,line8. terminal_p) annotation (Line(
      points={{30,-18},{22,-18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line8.terminal_n,line7. terminal_n) annotation (Line(
      points={{2,-18},{-8,-18},{-8,0},{2,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad3.y,load5. y) annotation (Line(
      points={{65,0},{50,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad3.y,load6. y) annotation (Line(
      points={{65,0},{58,0},{58,-18},{50,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line9.terminal_p, line10.terminal_n)
                                              annotation (Line(
      points={{-14,-40},{2,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line10.terminal_p, load7.terminal)
                                            annotation (Line(
      points={{22,-40},{30,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load8.terminal, line11.terminal_p)
                                            annotation (Line(
      points={{30,-58},{22,-58}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line11.terminal_n, line10.terminal_n)
                                              annotation (Line(
      points={{2,-58},{-8,-58},{-8,-40},{2,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad4.y,load7. y) annotation (Line(
      points={{65,-40},{50,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad4.y,load8. y) annotation (Line(
      points={{65,-40},{58,-40},{58,-58},{50,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line12.terminal_p, line13.terminal_n)
                                              annotation (Line(
      points={{-14,-80},{2,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line13.terminal_p, load9.terminal)
                                            annotation (Line(
      points={{22,-80},{30,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(load10.terminal, line14.terminal_p)
                                            annotation (Line(
      points={{30,-98},{22,-98}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line14.terminal_n, line13.terminal_n)
                                              annotation (Line(
      points={{2,-98},{-8,-98},{-8,-80},{2,-80}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(varLoad5.y,load9. y) annotation (Line(
      points={{65,-80},{50,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(varLoad5.y, load10.y)
                               annotation (Line(
      points={{65,-80},{58,-80},{58,-98},{50,-98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(line2.terminal_n, line4.terminal_n) annotation (Line(
      points={{-34,40},{-34,60},{0,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line6.terminal_n, line3.terminal_n) annotation (Line(
      points={{-34,0},{-34,22},{-8,22},{-8,40},{2,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line9.terminal_n, line7.terminal_n) annotation (Line(
      points={{-34,-40},{-34,-18},{-8,-18},{-8,0},{2,0},{2,5.55112e-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(line12.terminal_n, line10.terminal_n) annotation (Line(
      points={{-34,-80},{-34,-58},{-8,-58},{-8,-40},{2,-40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(E.n, ground.p) annotation (Line(
      points={{-90,80},{-90,70}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=4000,Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Lines/Examples/DCLines.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model shows a DC grid with 10 loads and 16 cables.
Each cable is of length <i>l = 10</i> meters, a parameter that can be modified.
Each load can be either be a full nonlinear model, or be replaced by the
linearized version. The parameter <code>linearLoads = false</code>
can be used to switch between linear and nonlinear implementation.
</p>
<p>
This model can be used to test how the linearized loads are affected by the voltage drop
caused by the lines. The longer the distance between the load and the source,
the bigger is the voltage drop and thus the error introduced by the linearization.
</p>
</html>"));
end DCLines;
