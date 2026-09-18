within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.Validation;
model HWIsoVal
    "Validate isolation valve enable and disable sequence"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal
    enaHotIsoVal(
    final reqAct=true,
    final nBoi=2)
    "Enable isolation valve"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal
    disHotIsoVal(
    final reqAct=false,
    final nBoi=2)
    "Disable isolation valve"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=15)
    "Delay to represent valve opening process"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=15)
    "Delay to represent valve closing process"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not gate for combining with true delay block"
    annotation (Placement(transformation(extent={{90,-100},{110,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Not gate for combining with true delay block"
    annotation (Placement(transformation(extent={{150,-100},{170,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Not staCha
    "Stage change command"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.20,
    final period=3600)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not upsDevSta
    "Upstream device status"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant valOne(
    final k=true)
    "Valve one position, fully open"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaBoi(
    final k=2)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant valOne1(
    final k=true)
    "Valve one position, fully open"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disBoi(
    final k=2)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre2
    "Pre block"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1(
    final pre_u_start=true)
    "Pre block"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,-70},{-162,-70}}, color={255,0,255}));

  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,-30},{-162,-30}}, color={255,0,255}));

  connect(enaBoi.y, enaHotIsoVal.nexChaBoi) annotation (Line(points={{-138,80},
          {-120,80},{-120,18},{-102,18}}, color={255,127,0}));

  connect(upsDevSta.y, enaHotIsoVal.uUpsDevSta) annotation (Line(points={{-138,
          -30},{-120,-30},{-120,5},{-102,5}}, color={255,0,255}));

  connect(upsDevSta.y, disHotIsoVal.uUpsDevSta) annotation (Line(points={{-138,
          -30},{100,-30},{100,-5},{118,-5}}, color={255,0,255}));

  connect(staCha.y, enaHotIsoVal.chaPro) annotation (Line(points={{-138,-70},{
          -110,-70},{-110,2},{-102,2}}, color={255,0,255}));

  connect(staCha.y, disHotIsoVal.chaPro) annotation (Line(points={{-138,-70},{
          110,-70},{110,-8},{118,-8}}, color={255,0,255}));

  connect(disBoi.y, disHotIsoVal.nexChaBoi) annotation (Line(points={{82,80},{
          90,80},{90,8},{118,8}}, color={255,127,0}));

  connect(pre2.y, enaHotIsoVal.uHotWatIsoVal[2]) annotation (Line(points={{-8,0},
          {0,0},{0,28},{-122,28},{-122,15.5},{-102,15.5}}, color={255,0,255}));
  connect(valOne.y, enaHotIsoVal.uHotWatIsoVal[1]) annotation (Line(points={{-178,
          20},{-122,20},{-122,14.5},{-102,14.5}}, color={255,0,255}));
  connect(pre1.y, disHotIsoVal.uHotWatIsoVal[2]) annotation (Line(points={{202,-90},
          {210,-90},{210,18},{110,18},{110,5.5},{118,5.5}}, color={255,0,255}));
  connect(valOne1.y, disHotIsoVal.uHotWatIsoVal[1]) annotation (Line(points={{42,
          20},{88,20},{88,4.5},{118,4.5}}, color={255,0,255}));
  connect(pre2.u, truDel.y)
    annotation (Line(points={{-32,0},{-38,0}}, color={255,0,255}));
  connect(enaHotIsoVal.yHotWatIsoVal[2], truDel.u) annotation (Line(points={{-78,
          4.5},{-70,4.5},{-70,0},{-62,0}}, color={255,0,255}));
  connect(disHotIsoVal.yHotWatIsoVal[2], not1.u) annotation (Line(points={{142,-5.5},
          {150,-5.5},{150,-74},{80,-74},{80,-90},{88,-90}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{112,-90},{118,-90}}, color={255,0,255}));
  connect(truDel1.y, not2.u)
    annotation (Line(points={{142,-90},{148,-90}}, color={255,0,255}));
  connect(not2.y, pre1.u)
    annotation (Line(points={{172,-90},{178,-90}}, color={255,0,255}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Boilers/Staging/Processes/Subsequences/Validation/HWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This example validates
  <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal\">
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.Processes.Subsequences.HWIsoVal</a>.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  June 18, 2020 by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
      Ellipse(lineColor = {75,138,73},
              fillColor={255,255,255},
              fillPattern = FillPattern.Solid,
              extent = {{-100,-100},{100,100}}),
      Polygon(lineColor = {0,0,255},
              fillColor = {75,138,73},
              pattern = LinePattern.None,
              fillPattern = FillPattern.Solid,
              points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-220,-120},{220,120}})));
end HWIsoVal;
