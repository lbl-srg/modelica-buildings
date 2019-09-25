within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.Validation;
model CHWIsoVal
  "Validate isolation valve enable and disable sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal
    enaChiIsoVal(
    nChi=2,
    chaChiWatIsoTim=300,
    iniValPos=0,
    endValPos=1) "Enable isolation valve"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  CDL.Logical.Sources.Pulse booPul(width=0.15, period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  CDL.Logical.Not staUp "Stage up command"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  CDL.Logical.Sources.Pulse booPul1(width=0.20, period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  CDL.Logical.Not upsDevSta "Upstream device status"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  CDL.Continuous.Sources.Constant valOne(k=1) "Valve one position, fully open"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Integers.Sources.Constant enaChi(k=2) "Enabling chiller index"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-138,-80},{-122,-80}}, color={255,0,255}));
  connect(booPul1.y, upsDevSta.u)
    annotation (Line(points={{-138,-40},{-122,-40}}, color={255,0,255}));
  connect(enaChi.y, enaChiIsoVal.nexChaChi) annotation (Line(points={{-98,60},{
          -70,60},{-70,8},{-62,8}}, color={255,127,0}));
  connect(valOne.y, enaChiIsoVal.uChiWatIsoVal[1]) annotation (Line(points={{
          -98,20},{-80,20},{-80,4},{-62,4}}, color={0,0,127}));
  connect(upsDevSta.y, enaChiIsoVal.uUpsDevSta) annotation (Line(points={{-98,
          -40},{-80,-40},{-80,-5},{-62,-5}}, color={255,0,255}));
  connect(staUp.y, enaChiIsoVal.uStaCha) annotation (Line(points={{-98,-80},{
          -70,-80},{-70,-8},{-62,-8}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Processes/Subsequences/Validation/CHWIsoVal.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Processes.Subsequences.CHWIsoVal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 24, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,140}})));
end CHWIsoVal;
