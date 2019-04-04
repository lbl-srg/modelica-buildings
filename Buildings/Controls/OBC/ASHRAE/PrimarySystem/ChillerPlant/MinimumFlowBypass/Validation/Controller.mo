within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Validation;
model Controller "Validate control of minimum bypass valve"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller
    minBypValCon(
    final byPasSetTim=1.5,
    final minFloSet={0,minOne,minTwo}) "Minimum bypass valve position"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  final parameter Modelica.SIunits.VolumeFlowRate minOne = 0.01
    "Minimum bypass flow rate at stage 1";
  final parameter Modelica.SIunits.VolumeFlowRate minTwo = 0.02
    "Minimum bypass flow rate at stage 2";
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse upDev(
    final width=0.3,
    final period=4) "Status of upflow device"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse staCha(
    final width=0.25,
    final period=4) "Stage up command"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant secSta(final k=2)
    "Stage index start from 0, 1"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter upSta(
    final p=1, final k=1) "Stage up"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch curSta "Current stage"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noStaCha(final k=false)
    "No stage change"
    annotation (Placement(transformation(extent={{-120,-170},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant haveOnOff(final k=true)
    "Have chiller on/off during the stage change"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaNexChi(
    final width=0.8,
    final period=4) "Enable next chiller"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiWatPum(
    final width=0.15,
    final period=4,
    final startTime=0.1) "Chilled water pump on command"
    annotation (Placement(transformation(extent={{-120,170},{-100,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=minOne/2,
    final freqHz=1/2,
    final offset=minTwo/2) "Output sine wave value"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=minTwo + minOne,
    final duration=2,
    final startTime=1.2) "Output ramp value"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Measured minimum bypass flow rate"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));

equation
  connect(staCha.y, not1.u)
    annotation (Line(points={{-99,80},{-82,80}}, color={255,0,255}));
  connect(upDev.y, not2.u)
    annotation (Line(points={{-99,40},{-82,40}}, color={255,0,255}));
  connect(not1.y, curSta.u2)
    annotation (Line(points={{-59,80},{-50,80},{-50,-20},{-22,-20}},
      color={255,0,255}));
  connect(secSta.y, upSta.u)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,0},{-82,0}},
      color={0,0,127}));
  connect(upSta.y, curSta.u1)
    annotation (Line(points={{-59,0},{-40,0},{-40,-12},{-22,-12}},
      color={0,0,127}));
  connect(secSta.y, curSta.u3)
    annotation (Line(points={{-99,-20},{-90,-20},{-90,-28},{-22,-28}},
      color={0,0,127}));
  connect(curSta.y, reaToInt.u)
    annotation (Line(points={{1,-20},{18,-20}}, color={0,0,127}));
  connect(not1.y, minBypValCon.uStaUp)
    annotation (Line(points={{-59,80},{60,80},{60,-56},{99,-56}}, color={255,0,255}));
  connect(not2.y, minBypValCon.uUpsDevSta)
    annotation (Line(points={{-59,40},{56,40},{56,-59},{99,-59}}, color={255,0,255}));
  connect(reaToInt.y, minBypValCon.uSta)
    annotation (Line(points={{41,-20},{52,-20},{52,-61},{99,-61}}, color={255,127,0}));
  connect(haveOnOff.y, minBypValCon.uOnOff)
    annotation (Line(points={{-99,-80},{52,-80},{52,-64},{99,-64}},
      color={255,0,255}));
  connect(enaNexChi.y, not3.u)
    annotation (Line(points={{-99,-120},{-82,-120}}, color={255,0,255}));
  connect(not3.y, minBypValCon.uEnaNexChi)
    annotation (Line(points={{-59,-120},{56,-120},{56,-66},{99,-66}},
      color={255,0,255}));
  connect(noStaCha.y, minBypValCon.uStaDow)
    annotation (Line(points={{-99,-160},{60,-160},{60,-69},{99,-69}},
      color={255,0,255}));
  connect(chiWatPum.y, not4.u)
    annotation (Line(points={{-99,180},{-82,180}}, color={255,0,255}));
  connect(not4.y, minBypValCon.uChiWatPum)
    annotation (Line(points={{-59,180},{80,180},{80,-51},{99,-51}},
      color={255,0,255}));
  connect(sin.y, add2.u1)
    annotation (Line(points={{-99,150},{-90,150},{-90,146},{-82,146}},
      color={0,0,127}));
  connect(ram.y, add2.u2)
    annotation (Line(points={{-99,120},{-90,120},{-90,134},{-82,134}}, color={0,0,127}));
  connect(add2.y, minBypValCon.VBypas_flow)
    annotation (Line(points={{-59,140},{64,140},{64,-53},{99,-53}}, color={0,0,127}));

annotation (
 experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/MinimumFlowBypass/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-200},{140,200}})));
end Controller;
