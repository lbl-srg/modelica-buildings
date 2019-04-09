within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uStaAva
  "Validate stage capacities sequence for stage availability inputs"

  parameter Integer nSta = 3
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2], 0.2*staNomCap[3]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  parameter Real small = 0.001
  "Small number to avoid division with zero";

  parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap1(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap2(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities
    staCap3(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage3(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con[nSta](k={true,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap1[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload1[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nSta](
    final k={false,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap2[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload2[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(final k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nSta](
    final k={false,true,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap3[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload3[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage4(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta3[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[nSta](k={true,true,false})
    "Stage availability array"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

equation

  connect(stage3.y, staCap.uSta)
    annotation (Line(points={{-159,110},{-142,110}},
                                                   color={255,127,0}));
  connect(staCap.yStaNom, absErrorSta[1].u1) annotation (Line(points={{-119,117},
          {-60,117},{-60,130},{-42,130}},
                                       color={0,0,127}));
  connect(staCap.yStaDowNom, absErrorSta[2].u1) annotation (Line(points={{-119,109},
          {-60,109},{-60,130},{-42,130}},
                                       color={0,0,127}));
  connect(staCap.yStaUpNom, absErrorSta[3].u1) annotation (Line(points={{-119,113},
          {-60,113},{-60,130},{-42,130}},
                                       color={0,0,127}));
  connect(staCap.yStaMin, absErrorSta[4].u1) annotation (Line(points={{-119,102},
          {-60,102},{-60,130},{-42,130}},
                                       color={0,0,127}));
  connect(staCap.yStaUpMin, absErrorSta[5].u1) annotation (Line(points={{-119,104},
          {-60,104},{-60,130},{-42,130}},
                                       color={0,0,127}));
  connect(con.y, staCap.uStaAva) annotation (Line(points={{-159,40},{-150,40},{-150,
          104},{-142,104}},color={255,0,255}));
  connect(nomStaCap[4].y, absErrorSta[1].u2)
    annotation (Line(points={{-79,80},{-30,80},{-30,118}},
                                                       color={0,0,127}));
  connect(nomStaCap[3].y, absErrorSta[2].u2) annotation (Line(points={{-79,80},{
          -32,80},{-32,110},{-30,110},{-30,118}},
                                           color={0,0,127}));
  connect(nomStaCap[5].y, absErrorSta[3].u2) annotation (Line(points={{-79,80},{
          -28,80},{-28,110},{-30,110},{-30,118}},
                                           color={0,0,127}));
  connect(minStaUnload[4].y, absErrorSta[4].u2) annotation (Line(points={{-79,20},
          {-26,20},{-26,110},{-30,110},{-30,118}},color={0,0,127}));
  connect(minStaUnload[5].y, absErrorSta[5].u2) annotation (Line(points={{-79,20},
          {-24,20},{-24,110},{-30,110},{-30,118}},color={0,0,127}));
  connect(stage1.y, staCap1.uSta)
    annotation (Line(points={{-159,-50},{-142,-50}},
                                                   color={255,127,0}));
  connect(staCap1.yStaNom, absErrorSta1[1].u1) annotation (Line(points={{-119,-43},
          {-60,-43},{-60,-30},{-42,-30}},
                                       color={0,0,127}));
  connect(staCap1.yStaDowNom, absErrorSta1[2].u1) annotation (Line(points={{-119,
          -51},{-60,-51},{-60,-30},{-42,-30}},
                                            color={0,0,127}));
  connect(staCap1.yStaUpNom, absErrorSta1[3].u1) annotation (Line(points={{-119,
          -47},{-60,-47},{-60,-30},{-42,-30}},
                                       color={0,0,127}));
  connect(staCap1.yStaMin, absErrorSta1[4].u1) annotation (Line(points={{-119,-58},
          {-60,-58},{-60,-30},{-42,-30}},
                                       color={0,0,127}));
  connect(staCap1.yStaUpMin, absErrorSta1[5].u1) annotation (Line(points={{-119,
          -56},{-60,-56},{-60,-30},{-42,-30}},
                                       color={0,0,127}));
  connect(con1.y, staCap1.uStaAva) annotation (Line(points={{-159,-120},{-150,-120},
          {-150,-56},{-142,-56}},
                                color={255,0,255}));
  connect(nomStaCap1[4].y, absErrorSta1[1].u2)
    annotation (Line(points={{-79,-80},{-30,-80},{-30,-42}},
                                                          color={0,0,127}));
  connect(nomStaCap1[5].y, absErrorSta1[3].u2) annotation (Line(points={{-79,-80},
          {-28,-80},{-28,-50},{-30,-50},{-30,-42}},
                                               color={0,0,127}));
  connect(minStaUnload1[4].y, absErrorSta1[4].u2) annotation (Line(points={{-79,
          -140},{-26,-140},{-26,-50},{-30,-50},{-30,-42}},
                                                 color={0,0,127}));
  connect(minStaUnload1[5].y, absErrorSta1[5].u2) annotation (Line(points={{-79,
          -140},{-24,-140},{-24,-50},{-30,-50},{-30,-42}},
                                                 color={0,0,127}));

  connect(minStaUnload1[4].y, absErrorSta1[2].u2) annotation (Line(points={{-79,
          -140},{-32,-140},{-32,-50},{-30,-50},{-30,-42}},
                                                       color={0,0,127}));
  connect(stage2.y, staCap2.uSta)
    annotation (Line(points={{41,110},{58,110}}, color={255,127,0}));
  connect(staCap2.yStaNom, absErrorSta2[1].u1) annotation (Line(points={{81,117},
          {140,117},{140,130},{158,130}}, color={0,0,127}));
  connect(staCap2.yStaDowNom, absErrorSta2[2].u1) annotation (Line(points={{81,109},
          {140,109},{140,130},{158,130}}, color={0,0,127}));
  connect(staCap2.yStaUpNom, absErrorSta2[3].u1) annotation (Line(points={{81,113},
          {140,113},{140,130},{158,130}}, color={0,0,127}));
  connect(staCap2.yStaMin, absErrorSta2[4].u1) annotation (Line(points={{81,102},
          {140,102},{140,130},{158,130}}, color={0,0,127}));
  connect(staCap2.yStaUpMin, absErrorSta2[5].u1) annotation (Line(points={{81,104},
          {140,104},{140,130},{158,130}}, color={0,0,127}));
  connect(con2.y, staCap2.uStaAva) annotation (Line(points={{41,40},{50,40},{50,
          104},{58,104}}, color={255,0,255}));
  connect(nomStaCap2[4].y, absErrorSta2[1].u2)
    annotation (Line(points={{121,80},{170,80},{170,118}}, color={0,0,127}));
  connect(nomStaCap2[3].y, absErrorSta2[2].u2) annotation (Line(points={{121,80},
          {168,80},{168,110},{170,110},{170,118}}, color={0,0,127}));
  connect(nomStaCap2[5].y, absErrorSta2[3].u2) annotation (Line(points={{121,80},
          {172,80},{172,110},{170,110},{170,118}}, color={0,0,127}));
  connect(minStaUnload2[4].y, absErrorSta2[4].u2) annotation (Line(points={{121,
          20},{174,20},{174,110},{170,110},{170,118}}, color={0,0,127}));
  connect(minStaUnload2[5].y, absErrorSta2[5].u2) annotation (Line(points={{121,
          20},{176,20},{176,110},{170,110},{170,118}}, color={0,0,127}));
  connect(stage4.y,staCap3. uSta)
    annotation (Line(points={{41,-50},{58,-50}},   color={255,127,0}));
  connect(staCap3.yStaNom,absErrorSta3 [1].u1) annotation (Line(points={{81,-43},
          {140,-43},{140,-30},{158,-30}},
                                       color={0,0,127}));
  connect(staCap3.yStaDowNom,absErrorSta3 [2].u1) annotation (Line(points={{81,-51},
          {140,-51},{140,-30},{158,-30}},   color={0,0,127}));
  connect(staCap3.yStaUpNom,absErrorSta3 [3].u1) annotation (Line(points={{81,-47},
          {140,-47},{140,-30},{158,-30}},
                                       color={0,0,127}));
  connect(staCap3.yStaMin,absErrorSta3 [4].u1) annotation (Line(points={{81,-58},
          {140,-58},{140,-30},{158,-30}},
                                       color={0,0,127}));
  connect(staCap3.yStaUpMin,absErrorSta3 [5].u1) annotation (Line(points={{81,-56},
          {140,-56},{140,-30},{158,-30}},
                                       color={0,0,127}));
  connect(con3.y,staCap3. uStaAva) annotation (Line(points={{41,-120},{50,-120},
          {50,-56},{58,-56}},   color={255,0,255}));
  connect(nomStaCap3[4].y,absErrorSta3 [1].u2)
    annotation (Line(points={{121,-80},{170,-80},{170,-42}},
                                                          color={0,0,127}));
  connect(nomStaCap3[5].y,absErrorSta3 [3].u2) annotation (Line(points={{121,-80},
          {172,-80},{172,-50},{170,-50},{170,-42}},
                                               color={0,0,127}));
  connect(minStaUnload3[4].y,absErrorSta3 [4].u2) annotation (Line(points={{121,
          -140},{174,-140},{174,-50},{170,-50},{170,-42}},
                                                 color={0,0,127}));
  connect(minStaUnload3[5].y,absErrorSta3 [5].u2) annotation (Line(points={{121,
          -140},{176,-140},{176,-50},{170,-50},{170,-42}},
                                                 color={0,0,127}));
  connect(minStaUnload3[4].y,absErrorSta3 [2].u2) annotation (Line(points={{121,
          -140},{168,-140},{168,-50},{170,-50},{170,-42}},
                                                       color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-160},{200,160}})));
end Capacities_uStaAva;
