within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.Validation;
model FlowSetpoint
  "Validation sequence of specifying minimum bypass flow setpoint"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    staUpMinFlo(final byPasSetTim=1.5)
    "Minimum flow setpoint when there is stage up command"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    onOffStaUpMinFlo(final byPasSetTim=1.5)
    "Minimum flow setpoint when there is stage up command and the change requires one chiller off and another chiller on"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint
    staDowMinFlo(final byPasSetTim=1.5)
    "Minimum flow setpoint when there is stage down command"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noOnOff(final k=false)
    "No chiller on/off during the stage change"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse staCha(
    final width=0.25, final period=4) "Stage up command"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse upDev(
    final width=0.3, final period=4)
    "Status of upflow device"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant secSta(
    final k=2) "Stage index start from 0, 1"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter upSta(
    final p=1, final k=1) "Stage up"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Logical.Switch curSta "Current stage"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noStaCha(
    final k=false) "No stage change"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch curSta1 "Current stage"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter dowSta(
    final p=-1, final k=1) "Stage down"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant haveOnOff(final k=true)
    "Have chiller on/off during the stage change"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaNexChi(
    final width=0.8, final period=4)
    "Enable next chiller"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

equation
  connect(secSta.y, upSta.u)
    annotation (Line(points={{-119,120},{-110,120},{-110,140},{-102,140}},
      color={0,0,127}));
  connect(upSta.y, curSta.u1)
    annotation (Line(points={{-79,140},{-68,140},{-68,128},{-62,128}},
      color={0,0,127}));
  connect(secSta.y, curSta.u3)
    annotation (Line(points={{-119,120},{-110,120},{-110,112},{-62,112}},
      color={0,0,127}));
  connect(curSta.y, reaToInt.u)
    annotation (Line(points={{-39,120},{-22,120}}, color={0,0,127}));
  connect(reaToInt.y, staUpMinFlo.uSta)
    annotation (Line(points={{1,120},{32,120},{32,192},{78,192}},
      color={255,127,0}));
  connect(noOnOff.y, staUpMinFlo.uOnOff)
    annotation (Line(points={{-119,80},{36,80},{36,188},{78,188}},
      color={255,0,255}));
  connect(noStaCha.y, staUpMinFlo.uStaDow)
    annotation (Line(points={{-119,40},{40,40},{40,180},{78,180}},
      color={255,0,255}));
  connect(staCha.y, not1.u)
    annotation (Line(points={{-119,200},{-102,200}}, color={255,0,255}));
  connect(upDev.y, not2.u)
    annotation (Line(points={{-119,170},{-102,170}}, color={255,0,255}));
  connect(not1.y, curSta.u2)
    annotation (Line(points={{-79,200},{-72,200},{-72,120},{-62,120}},
      color={255,0,255}));
  connect(not1.y, staUpMinFlo.uStaUp)
    annotation (Line(points={{-79,200},{78,200}},
      color={255,0,255}));
  connect(not2.y, staUpMinFlo.uUpsDevSta)
    annotation (Line(points={{-79,170},{28,170},{28,196},{78,196}},
      color={255,0,255}));
  connect(secSta.y, dowSta.u)
    annotation (Line(points={{-119,120},{-110,120},{-110,-160},{-102,-160}},
      color={0,0,127}));
  connect(not1.y, curSta1.u2)
    annotation (Line(points={{-79,200},{-72,200},{-72,-180},{-62,-180}},
      color={255,0,255}));
  connect(dowSta.y, curSta1.u1)
    annotation (Line(points={{-79,-160},{-68,-160},{-68,-172},{-62,-172}},
      color={0,0,127}));
  connect(secSta.y, curSta1.u3)
    annotation (Line(points={{-119,120},{-110,120},{-110,-188},{-62,-188}},
      color={0,0,127}));
  connect(curSta1.y, reaToInt1.u)
    annotation (Line(points={{-39,-180},{-22,-180}}, color={0,0,127}));
  connect(noOnOff.y, staDowMinFlo.uOnOff)
    annotation (Line(points={{-119,80},{36,80},{36,-182},{78,-182}},
      color={255,0,255}));
  connect(noStaCha.y, staDowMinFlo.uStaUp)
    annotation (Line(points={{-119,40},{40,40},{40,-170},{78,-170}},
      color={255,0,255}));
  connect(not2.y, staDowMinFlo.uUpsDevSta)
    annotation (Line(points={{-79,170},{28,170},{28,-174},{78,-174}},
      color={255,0,255}));
  connect(not1.y, staDowMinFlo.uStaDow)
    annotation (Line(points={{-79,200},{20,200},{20,-190},{78,-190}},
      color={255,0,255}));
  connect(reaToInt1.y, staDowMinFlo.uSta)
    annotation (Line(points={{1,-180},{40,-180},{40,-178},{78,-178}},
      color={255,127,0}));
  connect(not1.y, onOffStaUpMinFlo.uStaUp)
    annotation (Line(points={{-79,200},{20,200},{20,10},{78,10}},
      color={255,0,255}));
  connect(not2.y, onOffStaUpMinFlo.uUpsDevSta)
    annotation (Line(points={{-79,170},{28,170},{28,6},{78,6}},
      color={255,0,255}));
  connect(reaToInt.y, onOffStaUpMinFlo.uSta)
    annotation (Line(points={{1,120},{32,120},{32,2},{78,2}},
      color={255,127,0}));
  connect(haveOnOff.y, onOffStaUpMinFlo.uOnOff)
    annotation (Line(points={{-119,0},{0,0},{0,-2},{78,-2}},
      color={255,0,255}));
  connect(noStaCha.y, onOffStaUpMinFlo.uStaDow)
    annotation (Line(points={{-119,40},{-60,40},{-60,-10},{78,-10}},
      color={255,0,255}));
  connect(noOnOff.y, staUpMinFlo.uEnaNexChi)
    annotation (Line(points={{-119,80},{36,80},{36,184},{78,184}},
      color={255,0,255}));
  connect(noOnOff.y, staDowMinFlo.uEnaNexChi)
    annotation (Line(points={{-119,80},{36,80},{36,-186},{78,-186}},
      color={255,0,255}));
  connect(enaNexChi.y, not3.u)
    annotation (Line(points={{-119,-40},{-102,-40}}, color={255,0,255}));
  connect(not3.y, onOffStaUpMinFlo.uEnaNexChi)
    annotation (Line(points={{-79,-40},{0,-40},{0,-6},{78,-6}},
      color={255,0,255}));

annotation (
 experiment(StopTime=4.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/MinimumFlowBypass/Subsequences/Validation/FlowSetpoint.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences.FlowSetpoint</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 28, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-220},{160,
            220}})));
end FlowSetpoint;
