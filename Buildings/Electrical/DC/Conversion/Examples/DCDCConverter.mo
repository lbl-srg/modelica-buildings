within Buildings.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Loads.Conductor resistor(
    mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    P_nominal=-2000,
    V_nominal=60)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-100,22},{-80,42}})));
  Buildings.Electrical.DC.Conversion.DCDCConverter conDCDC(VHigh=120, VLow=60,
      eta=0.9)
    annotation (Placement(transformation(extent={{-46,22},{-26,42}})));
  Buildings.Electrical.DC.Loads.Conductor conductor(mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
      V_nominal=60,
    P_nominal=10e3)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp varLoad_P(
    duration=0.5,
    startTime=0.3,
    offset=-1000,
    height=10000)
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen
    annotation (Placement(transformation(extent={{-72,22},{-52,42}})));
equation
  connect(varLoad_P.y, conductor.Pow) annotation (Line(
      points={{49,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDCDC.terminal_p, resistor.terminal) annotation (Line(
      points={{-26,32},{-10,32},{-10,60},{20,60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.terminal_p, conductor.terminal) annotation (Line(
      points={{-26,32},{-10,32},{-10,0},{20,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, sen.terminal_n) annotation (Line(
      points={{-80,32},{-72,32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, conDCDC.terminal_n) annotation (Line(
      points={{-52,32},{-46,32}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}}),      graphics), experiment(StopTime=1,Tolerance=1e-05),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts DC voltage to DC voltage.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 2, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
January 29, 2013, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/DC/Conversion/Examples/DCDCConverter.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(extent={{-140,-100},{100,140}})));
end DCDCConverter;
