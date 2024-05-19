within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.Validation;
block FailsafeCondition
  "Validation model for FailsafeCondition"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario with FailsafeCondition unmet"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon1(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario with FailsafeCondition met"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon2(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario exhibiting lower limit of hysteresis loop in sequence being
    unmet"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon3(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario exhibitng lower limit of hysteresis loop in sequence being
    met"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon4(
    final delEna=900,
    final TDif=10,
    final TDifHys=1)
    "Testing scenario with timer reset"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul(
    final amplitude=-10 + 1,
    final period=2.5*900,
    final offset=80)
    "Pulse input"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul1(
    final amplitude=-10 - 1,
    final period=2.5*900,
    final offset=80)
    "Pulse input"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul2(
    final amplitude=-1,
    final period=2.5*900,
    final offset=80 - 10)
    "Pulse input"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse pul3(
    final amplitude=-2*1 - 1/10,
    final period=2.5*900,
    final offset=80 - 10 + 1 + 1/10)
    "Pulse input"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4(
    final k=80)
    "Constant input"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con5(
    final k=69)
    "Constant input"
    annotation (Placement(transformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=1000,
    final shift=960)
    "Boolean pulse signal"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con6(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con7(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con8(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con9(
    final k=false)
    "Constant Boolean false"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Rising edge detector"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));

equation
  connect(con.y, faiSafCon.TSupSet)
    annotation (Line(points={{-58,80},{-50,80},{-50,55},{-42,55}},
      color={0,0,127}));
  connect(pul.y, faiSafCon.TSup)
    annotation (Line(points={{-58,50},{-50,50},{-50,50},{-42,50}},
      color={0,0,127}));
  connect(con1.y, faiSafCon1.TSupSet)
    annotation (Line(points={{42,80},{50,80},{50,55},{58,55}},
      color={0,0,127}));
  connect(pul1.y, faiSafCon1.TSup)
    annotation (Line(points={{42,50},{50,50},{50,50},{58,50}},
      color={0,0,127}));
  connect(con2.y,faiSafCon2.TSupSet)
    annotation (Line(points={{-58,-20},{-50,-20},{-50,-45},{-42,-45}},
      color={0,0,127}));
  connect(pul2.y,faiSafCon2.TSup)
    annotation (Line(points={{-58,-50},{-50,-50},{-50,-50},{-42,-50}},
      color={0,0,127}));
  connect(con3.y,faiSafCon3.TSupSet)
    annotation (Line(points={{42,-20},{50,-20},{50,-45},{58,-45}},
      color={0,0,127}));
  connect(pul3.y,faiSafCon3.TSup)
    annotation (Line(points={{42,-50},{50,-50},{50,-50},{58,-50}},
      color={0,0,127}));
  connect(con4.y,faiSafCon4. TSupSet)
    annotation (Line(points={{122,80},{130,80},{130,55},{138,55}},
      color={0,0,127}));
  connect(con5.y, faiSafCon4.TSup)
    annotation (Line(points={{122,50},{130,50},{130,50},{138,50}},
      color={0,0,127}));
  connect(con6.y, faiSafCon.uStaChaProEnd)
    annotation (Line(points={{-58,20},{-50,20},{-50,45},{-42,45}},
      color={255,0,255}));
  connect(con7.y, faiSafCon2.uStaChaProEnd)
    annotation (Line(points={{-58,-80},{-50,-80},{-50,-55},{-42,-55}},
      color={255,0,255}));
  connect(con8.y, faiSafCon1.uStaChaProEnd)
    annotation (Line(points={{42,20},{50,20},{50,45},{58,45}},
      color={255,0,255}));
  connect(con9.y, faiSafCon3.uStaChaProEnd)
    annotation (Line(points={{42,-80},{50,-80},{50,-55},{58,-55}},
      color={255,0,255}));
  connect(booPul.y, edg.u)
    annotation (Line(points={{102,20},{108,20}},
      color={255,0,255}));
  connect(edg.y, faiSafCon4.uStaChaProEnd)
    annotation (Line(points={{132,20},{134,20},{134,45},{138,45}},
      color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{180,100}})),
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
      </html>",
      revisions="<html>
      <ul>
      <li>
      May 21, 2020, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
    __Dymola_Commands(file=
       "./Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Staging/SetPoints/Subsequences/Validation/FailsafeCondition.mos"
       "Simulate and plot"));
end FailsafeCondition;
