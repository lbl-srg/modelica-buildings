within Buildings.Electrical.DC.Loads.Examples;
model LinearizedLoad "Example model to check the linearized load model"
  extends Modelica.Icons.Example;
  Real error = (sen_nlin.P - sen_lin.P)*100/sen_nlin.P
    "Percentage of error between the linearized and actual power consumption";
  Real deltaV = LinearLoad.V_nominal - sen_lin.V
    "Voltage distance between nominal condition and actual voltage";
  Buildings.Electrical.DC.Loads.Conductor NonlinearLoad(
    linearized=false,
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=100,
    P_nominal=0) "Nonlinear load model"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Sources.ConstantVoltage sou(V=100) "Voltage source"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Electrical.Analog.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-100,-32},{-80,-12}})));
  Lines.TwoPortResistance Rline1(R=2) "Line resistance"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Sensors.GeneralizedSensor sen_nlin "Sensor"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Electrical.DC.Loads.Conductor LinearLoad(
    mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    V_nominal=100,
    linearized=true,
    P_nominal=0) "Linearized load model"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Sensors.GeneralizedSensor sen_lin "Sensor"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Lines.TwoPortResistance Rline2(R=2) "Line resistance"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.2,
    offset=-50,
    height=-950) "Power consumption"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
equation
  connect(sou.terminal, Rline1.terminal_n)
                                      annotation (Line(
      points={{-70,0},{-60,0},{-60,-30},{-50,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Rline1.terminal_p, sen_nlin.terminal_n)
                                          annotation (Line(
      points={{-30,-30},{-10,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen_nlin.terminal_p, NonlinearLoad.terminal)
                                         annotation (Line(
      points={{10,-30},{30,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(LinearLoad.terminal, sen_lin.terminal_p)
                                          annotation (Line(
      points={{30,30},{10,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.n, gro.p) annotation (Line(
      points={{-90,0},{-90,-12}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, Rline2.terminal_n) annotation (Line(
      points={{-70,0},{-60,0},{-60,30},{-50,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(Rline2.terminal_p, sen_lin.terminal_n)
                                              annotation (Line(
      points={{-30,30},{-10,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(LinearLoad.Pow, ramp.y) annotation (Line(
      points={{50,30},{60,30},{60,6.66134e-16},{69,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(NonlinearLoad.Pow, ramp.y) annotation (Line(
      points={{50,-30},{60,-30},{60,6.66134e-16},{69,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (            experiment(StopTime=1.0, Tolerance=1e-06),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Loads/Examples/LinearizedLoad.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates the use of a linealized load model <a href=\"modelica://Buildings.Electrical.DC.Loads.Conductor\">Buildings.Electrical.DC.Loads.Conductor</a>. </p>
<p>Both loads are connected to the same DC voltage source through a resistive element that represents a line. The loads consume the same amount of power that is specified by the input ramp signal. </p>
<p>The nonlinear conductor model <code>NonlinearLoad</code> consumes exactly the amount of power specified by the input <code>NonlinearLoad.Pow</code>. </p>
<p>The linearized conductor model <code>LinearizedLoad</code> does not consumes the amount of power specified by the input <code>LinearizedLoad.Pow</code>. The voltage at the load deviates from the nominal value when the power consumption increases. Since the model is approximated in a neighbor of the nominal voltage, moving from that point introduces approximation errors. The plot below shows the error introduced with such an approximation. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Electrical/DC/Loads/Examples/DCload_approx.png\" alt=\"image\"/> </p>
<p>The linearized load is tested over a voltage variation of about 30 % of the nominal voltage and within this range
the maximum error is 1.23457 % that occurs when the voltage deviation is 11.11 %.</p>
</html>", revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
August 16, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LinearizedLoad;
