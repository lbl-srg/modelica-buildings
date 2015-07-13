within Buildings.Electrical.DC.Conversion.Examples;
model DCDCConverter "Test model DC to DC converter"
  extends Modelica.Icons.Example;
  Buildings.Electrical.DC.Loads.Conductor resistor(
    mode=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    P_nominal=-2000,
    V_nominal=60) "Resistive load"
    annotation (Placement(transformation(extent={{38,30},{58,50}})));
  Buildings.Electrical.DC.Sources.ConstantVoltage    sou(V=120)
    "Voltage source"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Electrical.DC.Conversion.DCDCConverter conDCDC(VHigh=120, VLow=60,
      eta=0.9) "DC/DC transformer"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Electrical.DC.Loads.Conductor conductor(mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
      V_nominal=60,
    P_nominal=10e3) "Variable resistive load"
    annotation (Placement(transformation(extent={{38,-30},{58,-10}})));
  Modelica.Blocks.Sources.Ramp varLoad_P(
    duration=0.5,
    startTime=0.3,
    offset=-1000,
    height=10000)
    annotation (Placement(transformation(extent={{90,-30},{70,-10}})));
  Buildings.Electrical.DC.Sensors.GeneralizedSensor sen "Power sensor"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(varLoad_P.y, conductor.Pow) annotation (Line(
      points={{69,-20},{58,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conDCDC.terminal_p, resistor.terminal) annotation (Line(
      points={{4.44089e-16,0},{10,0},{10,40},{38,40}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(conDCDC.terminal_p, conductor.terminal) annotation (Line(
      points={{4.44089e-16,0},{10,0},{10,-20},{38,-20}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.terminal, sen.terminal_n) annotation (Line(
      points={{-70,0},{-60,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sen.terminal_p, conDCDC.terminal_n) annotation (Line(
      points={{-40,0},{-20,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (experiment(StopTime=1,Tolerance=1e-05),
    Documentation(info="<html>
<p>
This model illustrates the use of a model that converts between DC voltages.
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
