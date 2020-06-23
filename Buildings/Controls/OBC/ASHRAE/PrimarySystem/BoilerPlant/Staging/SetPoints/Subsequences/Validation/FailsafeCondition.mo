within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
block FailsafeCondition
  "Validation model for FailsafeCondition"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario with FailsafeCondition unmet"
    annotation (Placement(transformation(extent={{-40,42},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon1(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario with FailsafeCondition met"
    annotation (Placement(transformation(extent={{60,42},{80,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon2(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario exhibiting lower limit of hysteresis loop in sequence being
    unmet"
    annotation (Placement(transformation(extent={{-40,-58},{-20,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon3(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario exhibitng lower limit of hysteresis loop in sequence being
    met"
    annotation (Placement(transformation(extent={{60,-58},{80,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final amplitude=-10 + 1,
    final period=2.5*900,
    final offset=80)
    "Pulse input"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    final amplitude=-10 - 1,
    final period=2.5*900,
    final offset=80)
    "Pulse input"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul2(
    final amplitude=-1,
    final period=2.5*900,
    final offset=80 - 10)
    "Pulse input"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul3(
    final amplitude=-2*1 - 1/10,
    final period=2.5*900,
    final offset=80 - 10 + 1 + 1/10)
    "Pulse input"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(con.y, faiSafCon.TSupSet)
    annotation (Line(points={{-58,70},{-50,70},{-50,55},{-42,55}},
      color={0,0,127}));
  connect(pul.y, faiSafCon.TSup)
    annotation (Line(points={{-58,30},{-50,30},{-50,45},{-42,45}},
      color={0,0,127}));
  connect(con1.y, faiSafCon1.TSupSet)
    annotation (Line(points={{42,70},{50,70},{50,55},{58,55}},
      color={0,0,127}));
  connect(pul1.y, faiSafCon1.TSup)
    annotation (Line(points={{42,30},{50,30},{50,45},{58,45}},
      color={0,0,127}));
  connect(con2.y,faiSafCon2.TSupSet)
    annotation (Line(points={{-58,-30},{-50,-30},{-50,-45},{-42,-45}},
      color={0,0,127}));
  connect(pul2.y,faiSafCon2.TSup)
    annotation (Line(points={{-58,-70},{-50,-70},{-50,-55},{-42,-55}},
      color={0,0,127}));
  connect(con3.y,faiSafCon3.TSupSet)
    annotation (Line(points={{42,-30},{50,-30},{50,-45},{58,-45}},
      color={0,0,127}));
  connect(pul3.y,faiSafCon3.TSup)
    annotation (Line(points={{42,-70},{50,-70},{50,-55},{58,-55}},
      color={0,0,127}));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
      graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-6),
    Documentation(info="<html>
      <p>
      This example validates
      <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition\">
      Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition</a>
      </p>
      </html>"),
    __Dymola_Commands(file=
       "./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/FailsafeCondition.mos"
       "Simulate and plot"));
end FailsafeCondition;
