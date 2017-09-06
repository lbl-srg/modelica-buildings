within Buildings.Controls.OBC.ASHRAE.G36.Atomic.Validation;
model VAVMultiZoneSupFan "Validate VAVMultiZoneSupFan"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupFan
    vAVMulSupFan(numZon=4,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxDesPre=400,
    k=0.001,
    Ti=10)   "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  CDL.Continuous.Sources.Ramp ram(
    duration=28800,
    height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  CDL.Continuous.Truncation tru "Convert real input to integer"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  CDL.Continuous.Sources.Ramp vavBoxFlo1(
    duration=28800,
    height=1.5,
    offset=1) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  CDL.Continuous.Sources.Ramp vavBoxFlo2(
    duration=28800,
    offset=1,
    height=0.5) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  CDL.Continuous.Sources.Ramp vavBoxFlo3(
    duration=28800,
    height=1,
    offset=0.3) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  CDL.Continuous.Sources.Ramp vavBoxFlo4(
    duration=28800,
    height=1,
    offset=0) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/14400,
    offset=3,
    amplitude=2)    "Generate sine signal "
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  CDL.Continuous.Truncation tru1 "Convert real input to integer"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/14400,
    offset=200,
    amplitude=150) "Generate sine signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Continuous.Abs abs "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  CDL.Continuous.Abs abs1 "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(tru.y, vAVMulSupFan.uOpeMod)
    annotation (Line(points={{1,80},{40,80},{40,8},{58,8}},
      color={255,127,0}));
  connect(vavBoxFlo1.y, vAVMulSupFan.boxFloRat[1])
    annotation (Line(points={{-59,40},{-50,40},{-50,60},{34,60},{34,1.5},
      {58,1.5}}, color={0,0,127}));
  connect(vavBoxFlo2.y, vAVMulSupFan.boxFloRat[2])
    annotation (Line(points={{-19,40},{30,40},{30,2.5},{58,2.5}},
      color={0,0,127}));
  connect(vavBoxFlo3.y, vAVMulSupFan.boxFloRat[3])
    annotation (Line(points={{-59,10},{-48,10},{-48,58},{32,58},{32,3.5},
      {58,3.5}}, color={0,0,127}));
  connect(vavBoxFlo4.y, vAVMulSupFan.boxFloRat[4])
    annotation (Line(points={{-19,10},{28,10},{28,4.5},{58,4.5}},
      color={0,0,127}));
  connect(tru1.y, vAVMulSupFan.uZonPreResReq)
    annotation (Line(points={{1,-30},{20,-30},{20,-3},{58,-3}},
      color={255,127,0}));
  connect(sine1.y, vAVMulSupFan.ducStaPre)
    annotation (Line(points={{-19,-60},{24,-60},{24,-8},{58,-8}},
      color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-69,-30},{-66,-30},{-62,-30}},
                                                   color={0,0,127}));
  connect(abs1.y, tru1.u)
    annotation (Line(points={{-39,-30},{-22,-30}}, color={0,0,127}));
  connect(ram.y, abs.u)
    annotation (Line(points={{-69,80},{-68,80},{-62,80}},
                                                 color={0,0,127}));
  connect(abs.y, tru.u)
    annotation (Line(points={{-39,80},{-22,80}}, color={0,0,127}));

  annotation (experiment(StopTime=28800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Atomic/Validation/VAVMultiZoneSupFan.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupFan\">
Buildings.Controls.OBC.ASHRAE.G36.Atomic.VAVMultiZoneSupFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVMultiZoneSupFan;
