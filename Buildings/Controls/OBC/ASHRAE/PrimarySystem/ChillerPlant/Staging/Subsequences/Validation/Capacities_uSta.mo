within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uSta
  "Validate water side economizer tuning parameter sequence"

  parameter Integer nSta = 2
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant staCap[nSta + 2](final k=
        {small,5e5,1e6,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](final k=
        {0,1e5,6e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap0(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=2) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap1(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=2) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap2(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=2) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(k=0) "Stage 0"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(k=2)
    "Stage 2 (highest stage in the example)"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  CDL.Logical.Sources.Constant con[nSta](k=fill(true, nSta))
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation

  connect(stage0.y, staCap0.uSta)
    annotation (Line(points={{-59,60},{-42,60}}, color={255,127,0}));
  connect(stage1.y, staCap1.uSta)
    annotation (Line(points={{-59,0},{-42,0}}, color={255,127,0}));
  connect(stage2.y, staCap2.uSta)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,127,0}));
  connect(staCap0.yStaNom, absErrorSta0[1].u1) annotation (Line(points={{-19,67},
          {40,67},{40,80},{58,80}}, color={0,0,127}));
  connect(staCap0.yStaDowNom, absErrorSta0[2].u1) annotation (Line(points={{-19,59},
          {40,59},{40,80},{58,80}},     color={0,0,127}));
  connect(staCap1.yStaNom, absErrorSta1[1].u1)
    annotation (Line(points={{-19,7},{40,7},{40,0},{58,0}}, color={0,0,127}));
  connect(staCap1.yStaDowNom, absErrorSta1[2].u1)
    annotation (Line(points={{-19,-1},{40,-1},{40,0},{58,0}},
                                              color={0,0,127}));
  connect(staCap2.yStaNom, absErrorSta2[1].u1) annotation (Line(points={{-19,-43},
          {40,-43},{40,-50},{58,-50}}, color={0,0,127}));
  connect(staCap2.yStaDowNom, absErrorSta2[2].u1)
    annotation (Line(points={{-19,-51},{40,-51},{40,-50},{58,-50}},
                                                  color={0,0,127}));
  connect(staCap[3].y, absErrorSta2[1].u2) annotation (Line(points={{21,30},{48,
          30},{48,-70},{70,-70},{70,-62}}, color={0,0,127}));
  connect(staCap[2].y, absErrorSta2[2].u2) annotation (Line(points={{21,30},{46,
          30},{46,-70},{70,-70},{70,-62}}, color={0,0,127}));
  connect(staCap[2].y, absErrorSta1[1].u2) annotation (Line(points={{21,30},{42,
          30},{42,-20},{70,-20},{70,-12}}, color={0,0,127}));
  connect(staCap[1].y, absErrorSta0[1].u2)
    annotation (Line(points={{21,30},{70,30},{70,68}}, color={0,0,127}));
  connect(staCap[1].y, absErrorSta0[2].u2) annotation (Line(points={{21,30},{46,
          30},{46,40},{60,40},{60,60},{70,60},{70,68}}, color={0,0,127}));
  connect(minStaUnload[2].y, absErrorSta1[2].u2) annotation (Line(points={{21,-80},
          {94,-80},{94,-20},{70,-20},{70,-12}},      color={0,0,127}));
  connect(staCap0.yStaUpNom, absErrorSta0[3].u1) annotation (Line(points={{-19,63},
          {40,63},{40,80},{58,80}},     color={0,0,127}));
  connect(staCap1.yStaUpNom, absErrorSta1[3].u1)
    annotation (Line(points={{-19,3},{40,3},{40,0},{58,0}}, color={0,0,127}));
  connect(staCap2.yStaUpNom, absErrorSta2[3].u1) annotation (Line(points={{-19,-47},
          {40,-47},{40,-50},{58,-50}},      color={0,0,127}));
  connect(staCap[2].y, absErrorSta0[3].u2) annotation (Line(points={{21,30},{54,
          30},{54,36},{64,36},{64,52},{70,52},{70,68}}, color={0,0,127}));
  connect(staCap[3].y, absErrorSta1[3].u2) annotation (Line(points={{21,30},{44,
          30},{44,-22},{70,-22},{70,-12}}, color={0,0,127}));
  connect(staCap[4].y, absErrorSta2[3].u2) annotation (Line(points={{21,30},{44,
          30},{44,-72},{70,-72},{70,-62}}, color={0,0,127}));
  connect(minStaUnload[1].y, absErrorSta0[4].u2) annotation (Line(points={{21,
          -80},{92,-80},{92,62},{70,62},{70,68}}, color={0,0,127}));
  connect(staCap0.yStaMin, absErrorSta0[4].u1) annotation (Line(points={{-19,52},
          {40,52},{40,80},{58,80}}, color={0,0,127}));
  connect(staCap0.yStaUpMin, absErrorSta0[5].u1) annotation (Line(points={{-19,54},
          {40,54},{40,80},{58,80}},     color={0,0,127}));
  connect(minStaUnload[2].y, absErrorSta0[5].u2) annotation (Line(points={{21,
          -80},{88,-80},{88,60},{70,60},{70,68}}, color={0,0,127}));
  connect(minStaUnload[3].y, absErrorSta1[5].u2) annotation (Line(points={{21,
          -80},{52,-80},{52,-78},{86,-78},{86,-22},{70,-22},{70,-12}}, color={0,
          0,127}));
  connect(minStaUnload[2].y, absErrorSta1[4].u2) annotation (Line(points={{21,
          -80},{54,-80},{54,-78},{90,-78},{90,-18},{70,-18},{70,-12}}, color={0,
          0,127}));
  connect(staCap1.yStaMin, absErrorSta1[4].u1) annotation (Line(points={{-19,-8},
          {40,-8},{40,0},{58,0}}, color={0,0,127}));
  connect(staCap1.yStaUpMin, absErrorSta1[5].u1) annotation (Line(points={{-19,-6},
          {40,-6},{40,0},{58,0}},     color={0,0,127}));
  connect(minStaUnload[3].y, absErrorSta2[4].u2)
    annotation (Line(points={{21,-80},{70,-80},{70,-62}}, color={0,0,127}));
  connect(minStaUnload[4].y, absErrorSta2[5].u2) annotation (Line(points={{21,
          -80},{72,-80},{72,-66},{70,-66},{70,-62}}, color={0,0,127}));
  connect(absErrorSta2[4].u1, staCap2.yStaMin) annotation (Line(points={{58,-50},
          {40,-50},{40,-58},{-19,-58}}, color={0,0,127}));
  connect(staCap2.yStaUpMin, absErrorSta2[5].u1) annotation (Line(points={{-19,-56},
          {40,-56},{40,-50},{58,-50}},      color={0,0,127}));
  connect(con.y, staCap0.uStaAva) annotation (Line(points={{-59,-80},{-50,-80},
          {-50,54},{-42,54}}, color={255,0,255}));
  connect(con.y, staCap1.uStaAva) annotation (Line(points={{-59,-80},{-50,-80},
          {-50,-6},{-42,-6}}, color={255,0,255}));
  connect(con.y, staCap2.uStaAva) annotation (Line(points={{-59,-80},{-50,-80},
          {-50,-56},{-42,-56}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uSta.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Capacities</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false)));
end Capacities_uSta;
