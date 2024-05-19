within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.Validation;
model HWIsoVal
    "Validate isolation valve enable and disable sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal
    enaHotIsoVal(
    final nBoi=2,
    final chaHotWatIsoTim=300,
    final iniValPos=0,
    final endValPos=1)
    "Enable isolation valve"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal
    disHotIsoVal(
    final nBoi=2,
    final chaHotWatIsoTim=300,
    final iniValPos=1,
    final endValPos=0)
    "Disable isolation valve"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

protected
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

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valOne(
    final k=1)
    "Valve one position, fully open"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaBoi(
    final k=2)
    "Enabling boiler index"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant valOne1(
    final k=1)
    "Valve one position, fully open"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant disBoi(
    final k=2)
    "Disabling boiler index"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(
    final samplePeriod=1,
    final y_start=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{160,-20},{180,0}})));

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

  connect(valOne1.y, disHotIsoVal.uHotWatIsoVal[1]) annotation (Line(points={{
          42,20},{60,20},{60,4},{118,4}}, color={0,0,127}));

  connect(valOne.y, enaHotIsoVal.uHotWatIsoVal[1]) annotation (Line(points={{-178,
          20},{-140,20},{-140,14},{-102,14}}, color={0,0,127}));
  connect(enaHotIsoVal.yHotWatIsoVal[2], uniDel.u) annotation (Line(points={{-78,
          5},{-70,5},{-70,0},{-62,0}}, color={0,0,127}));
  connect(uniDel.y, enaHotIsoVal.uHotWatIsoVal[2]) annotation (Line(points={{-38,
          0},{-30,0},{-30,40},{-110,40},{-110,16},{-102,16}}, color={0,0,127}));
  connect(disHotIsoVal.yHotWatIsoVal[2], uniDel1.u) annotation (Line(points={{142,
          -5},{150,-5},{150,-10},{158,-10}}, color={0,0,127}));
  connect(uniDel1.y, disHotIsoVal.uHotWatIsoVal[2]) annotation (Line(points={{182,
          -10},{190,-10},{190,30},{110,30},{110,6},{118,6}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/Processes/Subsequences/Validation/HWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This example validates
  <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal\">
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Processes.Subsequences.HWIsoVal</a>.
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
