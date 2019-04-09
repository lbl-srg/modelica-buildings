within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uStaAva
  "Validate stage capacities sequence for stage availability inputs"

  parameter Integer nSta = 3
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2], 0.2*staNomCap[2]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap[nSta + 2](
      final k={small,5e5,5e5,1e6,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](
    final k= {0,1e5,1e5,2e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage3(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  CDL.Logical.Sources.Constant con[nSta](k={true,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  CDL.Continuous.Sources.Constant nomStaCap1[nSta + 2](final k={small,small,
        small,5e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  CDL.Continuous.Sources.Constant minStaUnload1[nSta + 2](final k={0,0,0,1e5,
        large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));

  Capacities
    staCap1(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  CDL.Integers.Sources.Constant stage1(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  CDL.Continuous.Feedback absErrorSta1[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  CDL.Logical.Sources.Constant con1[nSta](k={false,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

equation

  connect(stage3.y, staCap.uSta)
    annotation (Line(points={{-59,110},{-42,110}}, color={255,127,0}));
  connect(staCap.yStaNom, absErrorSta[1].u1) annotation (Line(points={{-19,117},
          {40,117},{40,130},{58,130}}, color={0,0,127}));
  connect(staCap.yStaDowNom, absErrorSta[2].u1) annotation (Line(points={{-19,109},
          {40,109},{40,130},{58,130}}, color={0,0,127}));
  connect(staCap.yStaUpNom, absErrorSta[3].u1) annotation (Line(points={{-19,113},
          {40,113},{40,130},{58,130}}, color={0,0,127}));
  connect(staCap.yStaMin, absErrorSta[4].u1) annotation (Line(points={{-19,102},
          {40,102},{40,130},{58,130}}, color={0,0,127}));
  connect(staCap.yStaUpMin, absErrorSta[5].u1) annotation (Line(points={{-19,104},
          {40,104},{40,130},{58,130}}, color={0,0,127}));
  connect(con.y, staCap.uStaAva) annotation (Line(points={{-59,40},{-50,40},{-50,
          104},{-42,104}}, color={255,0,255}));
  connect(nomStaCap[4].y, absErrorSta[1].u2)
    annotation (Line(points={{21,80},{70,80},{70,118}},color={0,0,127}));
  connect(nomStaCap[3].y, absErrorSta[2].u2) annotation (Line(points={{21,80},{68,
          80},{68,110},{70,110},{70,118}}, color={0,0,127}));
  connect(nomStaCap[5].y, absErrorSta[3].u2) annotation (Line(points={{21,80},{72,
          80},{72,110},{70,110},{70,118}}, color={0,0,127}));
  connect(minStaUnload[4].y, absErrorSta[4].u2) annotation (Line(points={{21,20},
          {74,20},{74,110},{70,110},{70,118}},    color={0,0,127}));
  connect(minStaUnload[5].y, absErrorSta[5].u2) annotation (Line(points={{21,20},
          {76,20},{76,110},{70,110},{70,118}},    color={0,0,127}));
  connect(stage1.y, staCap1.uSta)
    annotation (Line(points={{-59,-50},{-42,-50}}, color={255,127,0}));
  connect(staCap1.yStaNom, absErrorSta1[1].u1) annotation (Line(points={{-19,-43},
          {40,-43},{40,-30},{58,-30}}, color={0,0,127}));
  connect(staCap1.yStaDowNom, absErrorSta1[2].u1) annotation (Line(points={{-19,-51},
          {40,-51},{40,-30},{58,-30}},      color={0,0,127}));
  connect(staCap1.yStaUpNom, absErrorSta1[3].u1) annotation (Line(points={{-19,-47},
          {40,-47},{40,-30},{58,-30}}, color={0,0,127}));
  connect(staCap1.yStaMin, absErrorSta1[4].u1) annotation (Line(points={{-19,-58},
          {40,-58},{40,-30},{58,-30}}, color={0,0,127}));
  connect(staCap1.yStaUpMin, absErrorSta1[5].u1) annotation (Line(points={{-19,-56},
          {40,-56},{40,-30},{58,-30}}, color={0,0,127}));
  connect(con1.y, staCap1.uStaAva) annotation (Line(points={{-59,-120},{-50,-120},
          {-50,-56},{-42,-56}}, color={255,0,255}));
  connect(nomStaCap1[4].y, absErrorSta1[1].u2)
    annotation (Line(points={{21,-80},{70,-80},{70,-42}}, color={0,0,127}));
  connect(nomStaCap1[5].y, absErrorSta1[3].u2) annotation (Line(points={{21,-80},
          {72,-80},{72,-50},{70,-50},{70,-42}},color={0,0,127}));
  connect(minStaUnload1[4].y, absErrorSta1[4].u2) annotation (Line(points={{21,-140},
          {74,-140},{74,-50},{70,-50},{70,-42}}, color={0,0,127}));
  connect(minStaUnload1[5].y, absErrorSta1[5].u2) annotation (Line(points={{21,-140},
          {76,-140},{76,-50},{70,-50},{70,-42}}, color={0,0,127}));

  connect(minStaUnload1[4].y, absErrorSta1[2].u2) annotation (Line(points={{21,
          -140},{68,-140},{68,-50},{70,-50},{70,-42}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Capacities_uStaAva.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})));
end Capacities_uStaAva;
