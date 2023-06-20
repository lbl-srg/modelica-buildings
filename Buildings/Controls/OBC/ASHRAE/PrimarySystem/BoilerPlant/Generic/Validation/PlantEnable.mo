within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation;
model PlantEnable
  "Validation model for PlantEnable sequence"

  parameter Integer nSchRow(
    final min=1) = 4
    "Number of rows to be created for plant schedule table";

  parameter Real schTab[nSchRow,2] = [0,1; 6,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable
    plaEna(
    final nIgnReq=2)
    "Testing time-variance for all inputs"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable
    plaEna1(
    final nIgnReq=2)
    "Testing time-varying number of requests"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable
    plaEna2(
    final nIgnReq=2)
    "Testing time-varying outdoor air temperature"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable
    plaEna3(
    final nIgnReq=2)
    "Testing time-varying boiler plant enable schedule"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when plant can be enabled"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=2,
    final freqHz=1/(6*60),
    final offset=2,
    final startTime=1)
    "Input for number of requests"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Rounding real input to nearest integer"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    final amplitude=2/1.8,
    final freqHz=1/700,
    final phase=3.1415926535898,
    final offset=300,
    final startTime=1)
    "Input for outdoor air temperature"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin2(
    final amplitude=2,
    final freqHz=1/(6*60),
    final offset=2,
    final startTime=1)
    "Input for number of requests"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Rounding real input to nearest integer"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Rounding real input to nearest integer"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin5(
    final amplitude=2/1.8,
    final freqHz=1/700,
    final phase=3.1415926535898,
    final offset=300,
    final startTime=1)
    "Input for outdoor air temperature"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Rounding real input to nearest integer"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=3)
    "Input for number of requests"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=297)
    "Input for outdoor air temperature"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=3)
    "Input for number of requests"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=297)
    "Input for outdoor air temperature"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.5)
    "Check if schedule lets the controller enable the plant or not"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

equation
  connect(sin.y, reaToInt.u)
    annotation (Line(points={{-68,80},{-62,80}},
      color={0,0,127}));
  connect(sin2.y, reaToInt1.u)
    annotation (Line(points={{-68,-20},{-62,-20}},
      color={0,0,127}));
  connect(con.y, reaToInt2.u)
    annotation (Line(points={{32,80},{38,80}},
      color={0,0,127}));
  connect(reaToInt3.u, con2.y)
    annotation (Line(points={{38,-20},{32,-20}},
      color={0,0,127}));
  connect(plaEna1.supResReq, reaToInt1.y)
    annotation (Line(points={{-22,-40},{-30,-40},{-30,-20},{-38,-20}},
      color={255,127,0}));
  connect(plaEna2.supResReq, reaToInt2.y)
    annotation (Line(points={{78,60},{70,60},{70,80},{62,80}},
      color={255,127,0}));
  connect(plaEna2.TOut, sin5.y)
    annotation (Line(points={{78,54},{70,54},{70,40},{32,40}},
      color={0,0,127}));
  connect(plaEna3.supResReq, reaToInt3.y)
    annotation (Line(points={{78,-40},{70,-40},{70,-20},{62,-20}},
      color={255,127,0}));
  connect(plaEna3.TOut, con3.y)
    annotation (Line(points={{78,-46},{70,-46},{70,-60},{32,-60}},
      color={0,0,127}));
  connect(reaToInt.y, plaEna.supResReq)
    annotation (Line(points={{-38,80},{-30,80},{-30,60},{-22,60}},
      color={255,127,0}));
  connect(sin1.y, plaEna.TOut)
    annotation (Line(points={{-68,40},{-30,40},{-30,54},{-22,54}},
      color={0,0,127}));
  connect(con1.y, plaEna1.TOut)
    annotation (Line(points={{-68,-60},{-30,-60},{-30,-46},{-22,-46}},
      color={0,0,127}));
  connect(enaSch.y[1], greThr.u)
    annotation (Line(points={{-88,120},{-82,120}}, color={0,0,127}));
  connect(greThr.y, plaEna.uSchEna) annotation (Line(points={{-58,120},{-26,120},
          {-26,66},{-22,66}}, color={255,0,255}));
  connect(greThr.y, plaEna1.uSchEna) annotation (Line(points={{-58,120},{-26,120},
          {-26,-34},{-22,-34}}, color={255,0,255}));
  connect(greThr.y, plaEna2.uSchEna) annotation (Line(points={{-58,120},{74,120},
          {74,66},{78,66}}, color={255,0,255}));
  connect(greThr.y, plaEna3.uSchEna) annotation (Line(points={{-58,120},{74,120},
          {74,-34},{78,-34}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={Ellipse(
                  lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-100,-100},{100,100}}),
                Polygon(
                  lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(
      preserveAspectRatio=false, extent={{-140,-140},{140,140}}),
      graphics={Text(
                  extent={{-72,26},{-24,18}},
                  textColor={28,108,200},
                  textString="Combination of all inputs"),
                Text(
                  extent={{32,26},{80,18}},
                  textColor={28,108,200},
                  textString="Changing outdoor temperature"),
                Text(
                  extent={{-80,-74},{-16,-82}},
                  textColor={28,108,200},
                  textString="Changing number of hot-water requests"),
                Text(
                  extent={{26,-74},{74,-82}},
                  textColor={28,108,200},
                  textString="Changing boiler-enable schedule")}),
    experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06),
      __Dymola_Commands(file="./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/Validation/PlantEnable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.PlantEnable</a>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      May 7, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end PlantEnable;
