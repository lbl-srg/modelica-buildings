within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.Validation;
model EnableCells
  "Validation sequence of controlling tower fan speed based on condenser water return temperature control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells
    enaTowCel
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  CDL.Continuous.Sources.Ramp                        ramp1(
    duration=3600,
    offset=0,
    height=2)    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Continuous.Round                        round1(n=0)
    "Round real number to given digits"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Conversions.RealToInteger                        reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp speWSE(
    final height=0.9, final duration=3600)
    "Tower fan speed when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.2, final period=3600,
    startTime=-3000)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plaCap(
    final height=8e5,
    final duration=3600,
    final offset=1e5) "Real operating chiller plant capacity"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe1(final k=0.5)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hpTowSpe2(final k=0)
    "Head pressure control maximum tower speed"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse chiSta1(
    final width=0.2, final period=3600) "Chiller one enabling status"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(final k=false)
    "Chiller two enabling status"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(chiSta1.y, not1.u)
    annotation (Line(points={{-158,90},{-142,90}},   color={255,0,255}));
  connect(wseSta.y, swi.u2)
    annotation (Line(points={{-158,30},{-112,30},{-112,130},{-62,130}},
      color={255,0,255}));
  connect(speWSE.y, swi.u1)
    annotation (Line(points={{-158,130},{-120,130},{-120,138},{-62,138}},
      color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-118,160},{-80,160},{-80,122},{-62,122}},
      color={0,0,127}));
  connect(not1.y, swi1.u2)
    annotation (Line(points={{-118,90},{-100,90},{-100,-40},{-62,-40}},
      color={255,0,255}));
  connect(hpTowSpe1.y, swi1.u1)
    annotation (Line(points={{-118,-20},{-96,-20},{-96,-32},{-62,-32}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-118,160},{-80,160},{-80,-48},{-62,-48}},
      color={0,0,127}));

  connect(ramp1.y,round1. u)
    annotation (Line(points={{-38,50},{-22,50}},
                                               color={0,0,127}));
  connect(round1.y,reaToInt. u)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/FanSpeed/ReturnWaterTemperature/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,220}}),
                                                   graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,
            220}})));
end EnableCells;
