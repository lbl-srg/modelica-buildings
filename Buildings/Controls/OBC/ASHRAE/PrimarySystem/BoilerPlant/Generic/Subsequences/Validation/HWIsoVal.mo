within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.Validation;
model HWIsoVal
    "Validate isolation valve disable sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.HWIsoVal
    cloHotIsoVal(
    final chaHotWatIsoRat=1/60) "Close isolation valve"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.HWIsoVal
    cloHotIsoVal1(
    final chaHotWatIsoRat=1/60)
    "Close isolation valve"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(
    final samplePeriod=1,
    final y_start=1)
    "Unit delay"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(
    final samplePeriod=1,
    final y_start=0.75)
    "Unit delay"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

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

equation
  connect(booPul.y, staCha.u)
    annotation (Line(points={{-178,-70},{-162,-70}}, color={255,0,255}));

  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-178,-30},{-162,-30}}, color={255,0,255}));

  connect(upsDevSta.y,cloHotIsoVal. uUpsDevSta) annotation (Line(points={{-138,-30},
          {-120,-30},{-120,10},{-102,10}},    color={255,0,255}));

  connect(upsDevSta.y, cloHotIsoVal1.uUpsDevSta) annotation (Line(points={{-138,
          -30},{100,-30},{100,10},{118,10}},
                                           color={255,0,255}));

  connect(staCha.y,cloHotIsoVal. chaPro) annotation (Line(points={{-138,-70},{-110,
          -70},{-110,4},{-102,4}},      color={255,0,255}));

  connect(staCha.y, cloHotIsoVal1.chaPro) annotation (Line(points={{-138,-70},{110,
          -70},{110,4},{118,4}},     color={255,0,255}));

  connect(cloHotIsoVal.yHotWatIsoVal, uniDel.u) annotation (Line(points={{-78,4},
          {-70,4},{-70,0},{-62,0}}, color={0,0,127}));
  connect(cloHotIsoVal1.yHotWatIsoVal, uniDel1.u) annotation (Line(points={{142,
          4},{150,4},{150,0},{158,0}}, color={0,0,127}));
  connect(uniDel.y, cloHotIsoVal.uHotWatIsoVal) annotation (Line(points={{-38,0},
          {-30,0},{-30,40},{-110,40},{-110,16},{-102,16}}, color={0,0,127}));
  connect(uniDel1.y, cloHotIsoVal1.uHotWatIsoVal) annotation (Line(points={{182,
          0},{190,0},{190,40},{110,40},{110,16},{118,16}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Subsequences/Validation/HWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
  <p>
  This example validates
  <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.HWIsoVal\">
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Subsequences.HWIsoVal</a>.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  September 30, 2020 by Karthik Devaprasad:<br/>
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
