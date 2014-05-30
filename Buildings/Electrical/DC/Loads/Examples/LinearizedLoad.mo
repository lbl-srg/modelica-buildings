within Buildings.Electrical.DC.Loads.Examples;
model LinearizedLoad "Example model to check the linearized load model"
  import Buildings;
  extends Modelica.Icons.Example;
  Real error = (sen_nlin.S[1] - sen_lin.S[1])*100/sen_nlin.S[1];
  Buildings.Electrical.DC.Loads.Conductor NonlinearLoad(
    linear=false,
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    V_nominal=100,
    P_nominal=0) "Resistor"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
  Sources.ConstantVoltage sou(V=100) "Voltage source"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Electrical.Analog.Basic.Ground gro "Ground"
    annotation (Placement(transformation(extent={{-100,-32},{-80,-12}})));
  Lines.TwoPortResistance Rline1(R=2) "Resistance"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  Sensors.GeneralizedSensor sen_nlin
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Electrical.DC.Loads.Conductor LinearLoad(
    mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    V_nominal=100,
    linear=true,
    P_nominal=0) "Resistor"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Sensors.GeneralizedSensor sen_lin
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Lines.TwoPortResistance Rline2(R=2) "Resistance"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=0.5,
    startTime=0.2,
    offset=-50,
    height=-950)
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
  connect(sou.npin, gro.p) annotation (Line(
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
            experiment(StopTime=1.0, Tolerance=1e-06, __Dymola_Algorithm="Radau"),
            __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Loads/Examples/LinearizedLoad.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the resistor model.
</p>
</html>", revisions="<html>
<ul>
<li>
August 16, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end LinearizedLoad;
