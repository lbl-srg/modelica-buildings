within Buildings.Controls.OBC.ASHRAE.G36.AHU.MultiZone.SetPoints.Validation;
model VAVSupplyFan "Validate VAVSupplyFan"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.AHU.MultiZone.SetPoints.VAVSupplyFan
    vAVMulSupFan(numZon=4,
    Td=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    maxDesPre=400,
    k=0.001,
    Ti=10)   "Block outputs supply fan speed"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    duration=28800,
    height=6) "Ramp signal for generating operation mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo1(
    duration=28800,
    height=1.5,
    offset=1) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo2(
    duration=28800,
    offset=1,
    height=0.5) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo3(
    duration=28800,
    height=1,
    offset=0.3) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp vavBoxFlo4(
    duration=28800,
    height=1,
    offset=0) "Ramp signal for generating VAV box flow rate"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/14400,
    offset=3,
    amplitude=2)    "Generate sine signal "
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=1/14400,
    offset=200,
    amplitude=150) "Generate sine signal"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-66,70},{-46,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs1
    "Block generates absolute value of input"
    annotation (Placement(transformation(extent={{-64,-40},{-44,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round2(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{2,-40},{22,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{2,70},{22,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Round round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

equation
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
  connect(sine1.y, vAVMulSupFan.ducStaPre)
    annotation (Line(points={{-19,-70},{40,-70},{40,-8},{58,-8}},
      color={0,0,127}));
  connect(sine.y, abs1.u)
    annotation (Line(points={{-79,-30},{-66,-30}},
      color={0,0,127}));
  connect(ram.y, abs.u)
    annotation (Line(points={{-79,80},{-68,80}},
      color={0,0,127}));
  connect(abs1.y, round2.u)
    annotation (Line(points={{-43,-30},{-32,-30}}, color={0,0,127}));
  connect(round2.y, reaToInt1.u)
    annotation (Line(points={{-9,-30},{0,-30}}, color={0,0,127}));
  connect(reaToInt1.y, vAVMulSupFan.uZonPreResReq)
    annotation (Line(points={{23,-30},{34,-30},{34,-3},{58,-3}},
      color={255,127,0}));
  connect(abs.y, round1.u)
    annotation (Line(points={{-45,80},{-32,80}}, color={0,0,127}));
  connect(round1.y, reaToInt2.u)
    annotation (Line(points={{-9,80},{0,80}}, color={0,0,127}));
  connect(reaToInt2.y, vAVMulSupFan.uOpeMod)
    annotation (Line(points={{23,80},{38,80},{38,8},{58,8}},
      color={255,127,0}));

annotation (experiment(StopTime=28800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/MultiZone/SetPoints/Validation/VAVSupplyFan.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.MultiZone.SetPoints.VAVSupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.MultiZone.SetPoints.VAVSupplyFan</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 24, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSupplyFan;
