within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Validation;
model Controller "Validate control of minimum bypass valve"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller
    minBypValCon(
    final byPasSetTim=1.5,
    final minFloSet={0,minOne,minTwo}) "Minimum bypass valve position"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

protected
  final parameter Modelica.SIunits.VolumeFlowRate minOne = 0.01
    "Minimum bypass flow rate at stage 1";
  final parameter Modelica.SIunits.VolumeFlowRate minTwo = 0.02
    "Minimum bypass flow rate at stage 2";
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse upDev(
    final width=0.3,
    final period=4) "Status of upflow device"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse staCha(
    final width=0.25,
    final period=4) "Stage up command"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant secSta(final k=2)
    "Stage index start from 0, 1"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter upSta(
    final p=1, final k=1) "Stage up"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch curSta "Current stage"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noStaCha(final k=false)
    "No stage change"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant haveOnOff(final k=true)
    "Have chiller on/off during the stage change"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaNexChi(
    final width=0.8,
    final period=4) "Enable next chiller"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiWatPum(
    final width=0.15,
    final period=4,
    final startTime=0.1) "Chilled water pump on command"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=minOne/2,
    final freqHz=1/2,
    final offset=minTwo/2) "Output sine wave value"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=minTwo + minOne,
    final duration=2,
    final startTime=1.2) "Output ramp value"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Measured minimum bypass flow rate"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

equation
  connect(staCha.y, not1.u)
    annotation (Line(points={{-119,40},{-102,40}}, color={255,0,255}));
  connect(upDev.y, not2.u)
    annotation (Line(points={{-119,10},{-102,10}}, color={255,0,255}));
  connect(not1.y, curSta.u2)
    annotation (Line(points={{-79,40},{-70,40},{-70,-40},{-42,-40}},
      color={255,0,255}));
  connect(secSta.y, upSta.u)
    annotation (Line(points={{-119,-40},{-110,-40},{-110,-20},{-102,-20}},
      color={0,0,127}));
  connect(upSta.y, curSta.u1)
    annotation (Line(points={{-79,-20},{-60,-20},{-60,-32},{-42,-32}},
      color={0,0,127}));
  connect(secSta.y, curSta.u3)
    annotation (Line(points={{-119,-40},{-110,-40},{-110,-48},{-42,-48}},
      color={0,0,127}));
  connect(curSta.y, reaToInt.u)
    annotation (Line(points={{-19,-40},{-2,-40}},  color={0,0,127}));
  connect(not1.y, minBypValCon.uStaUp)
    annotation (Line(points={{-79,40},{40,40},{40,-76},{79,-76}}, color={255,0,255}));
  connect(not2.y, minBypValCon.uUpsDevSta)
    annotation (Line(points={{-79,10},{36,10},{36,-79},{79,-79}}, color={255,0,255}));
  connect(reaToInt.y, minBypValCon.uSta)
    annotation (Line(points={{21,-40},{32,-40},{32,-81},{79,-81}}, color={255,127,0}));
  connect(haveOnOff.y, minBypValCon.uOnOff)
    annotation (Line(points={{-119,-90},{32,-90},{32,-84},{79,-84}},
      color={255,0,255}));
  connect(enaNexChi.y, not3.u)
    annotation (Line(points={{-119,-130},{-102,-130}}, color={255,0,255}));
  connect(not3.y, minBypValCon.uEnaNexChi)
    annotation (Line(points={{-79,-130},{36,-130},{36,-86},{79,-86}},
      color={255,0,255}));
  connect(noStaCha.y, minBypValCon.uStaDow)
    annotation (Line(points={{-119,-170},{40,-170},{40,-89},{79,-89}},
      color={255,0,255}));
  connect(chiWatPum.y, not4.u)
    annotation (Line(points={{-119,140},{-102,140}}, color={255,0,255}));
  connect(not4.y, minBypValCon.uChiWatPum)
    annotation (Line(points={{-79,140},{60,140},{60,-71},{79,-71}},
      color={255,0,255}));
  connect(sin.y, add2.u1)
    annotation (Line(points={{-119,110},{-110,110},{-110,106},{-102,106}},
      color={0,0,127}));
  connect(ram.y, add2.u2)
    annotation (Line(points={{-119,80},{-110,80},{-110,94},{-102,94}}, color={0,0,127}));
  connect(add2.y, minBypValCon.VBypas_flow)
    annotation (Line(points={{-79,100},{44,100},{44,-73},{79,-73}}, color={0,0,127}));

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
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-220},{160,220}})));
end Controller;
