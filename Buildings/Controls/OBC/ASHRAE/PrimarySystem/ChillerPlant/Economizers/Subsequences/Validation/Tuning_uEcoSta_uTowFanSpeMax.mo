within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Validation;
model Tuning_uEcoSta_uTowFanSpeMax
  "Validate water side economizer tuning parameter sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun
    "Tests tuning parameter increase due to a dip in tower fan speed"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun1
    "Tests tuning parameter remains constant inspite of a dip in tower fan speed due to the prolonged WSE on status"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun2
    "Tests tuning parameter decrease due to WSE being on for a long time before disable"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun3
    "Tests tuning parameter remains constant despite of a dip in tower fan speed due to the prolonged WSE on status"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning wseTun4
    "Tests anti-windup"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer tim
                      "Timer"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(
    final t=7e4) "Greater than"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Constant"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi "Logical switch"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta(
    final width=0.5,
    final period=2*55*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowFanSpeSig0(
    final k=1)
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowFanSpeSig2(
    final k=1)
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowFanSig1(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{20,160},{40,180}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta1(
    final width=0.5,
    final period=2*16*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{20,200},{40,220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin cooTowFanSta1(
    final amplitude=0.2,
    final offset=1.1,
    final freqHz=1/(80*60),
    final phase=3.1415926535898) "Cooling tower fan speed status signal"
    annotation (Placement(transformation(extent={{20,118},{40,138}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min1 "Minimum"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta2(
    final width=0.5,
    final period=2*65*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta3(
    final width=0.5,
    final period=2*20*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowFanSpeSig3(
    final k=1)
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta4(
    final width=0.5,
    final period=2*20*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{20,-120},{40,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTowFanSpeSig1(
    final k=1)
    "Maximum cooling tower fan speed signal"
    annotation (Placement(transformation(extent={{20,-180},{40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse ecoSta5(
    final width=0.5,
    final period=2*65*60)
    "Water side economizer enable/disable status"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

equation
  connect(ecoSta.y,wseTun.uWseSta)  annotation (Line(points={{-98,210},{-70,210},
          {-70,175},{-42,175}}, color={255,0,255}));
  connect(maxTowFanSig1.y, min1.u1) annotation (Line(points={{42,170},{50,170},{
          50,156},{58,156}}, color={0,0,127}));
  connect(cooTowFanSta1.y, min1.u2) annotation (Line(points={{42,128},{48,128},{
          48,144},{58,144}}, color={0,0,127}));
  connect(min1.y, wseTun1.uTowFanSpeMax) annotation (Line(points={{82,150},{90,150},
          {90,165},{98,165}}, color={0,0,127}));
  connect(ecoSta1.y,wseTun1.uWseSta)  annotation (Line(points={{42,210},{70,210},
          {70,175},{98,175}}, color={255,0,255}));
  connect(ecoSta2.y,wseTun2.uWseSta)  annotation (Line(points={{-98,110},{-70,110},
          {-70,75},{-42,75}}, color={255,0,255}));
  connect(maxTowFanSpeSig2.y, wseTun2.uTowFanSpeMax) annotation (Line(points={{-98,50},
          {-70,50},{-70,65},{-42,65}}, color={0,0,127}));
  connect(maxTowFanSpeSig0.y, wseTun.uTowFanSpeMax) annotation (Line(points={{-98,150},
          {-70,150},{-70,165},{-42,165}},  color={0,0,127}));
  connect(ecoSta3.y,wseTun3.uWseSta)  annotation (Line(points={{42,90},{70,90},{
          70,55},{98,55}},  color={255,0,255}));
  connect(wseTun3.uTowFanSpeMax, maxTowFanSpeSig3.y) annotation (Line(points={{98,45},
          {70,45},{70,40},{42,40}}, color={0,0,127}));
  connect(maxTowFanSpeSig1.y, wseTun4.uTowFanSpeMax) annotation (Line(points={{42,-170},
          {80,-170},{80,-95},{98,-95}}, color={0,0,127}));
  connect(con.y, tim.u)
    annotation (Line(points={{-98,-80},{-82,-80}}, color={255,0,255}));
  connect(tim.y, greThr1.u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(greThr1.y, logSwi.u2)
    annotation (Line(points={{-18,-80},{58,-80}}, color={255,0,255}));
  connect(ecoSta5.y, logSwi.u1) annotation (Line(points={{42,-50},{50,-50},{50,
          -72},{58,-72}},
                     color={255,0,255}));
  connect(ecoSta4.y, logSwi.u3) annotation (Line(points={{42,-110},{50,-110},{50,
          -88},{58,-88}}, color={255,0,255}));
  connect(logSwi.y, wseTun4.uWseSta) annotation (Line(points={{82,-80},{90,-80},
          {90,-85},{98,-85}}, color={255,0,255}));
annotation (
 experiment(
      StopTime=150000,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizers/Subsequences/Validation/Tuning_uEcoSta_uTowFanSpeMax.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Subsequences.Tuning</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2018, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-240},{140,240}}),
        graphics={
        Text(
          extent={{-126,6},{-20,-6}},
          textColor={0,0,127},
          textString="Tests tuning parameter decrease
based on WSE enable duration
prior to disable"),
        Text(
          extent={{-10,14},{154,-18}},
          textColor={0,0,127},
          textString="Tests tuning parameter increase
based on WSE enable duration
prior to disable and cooling tower
fan speed during WSE enable."),
        Text(
          extent={{-46,-208},{48,-214}},
          textColor={0,0,127},
          textString="Tests anti-windup")}));
end Tuning_uEcoSta_uTowFanSpeMax;
