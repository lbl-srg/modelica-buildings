within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Capacities_uStaAva
  "Validate stage capacities sequence for stage availability inputs"

  parameter Integer nSta = 3
  "Highest chiller stage";

  parameter Modelica.SIunits.Power staNomCap[nSta] = {5e5, 5e5, 5e5}
    "Nominal capacity at all chiller stages, starting with stage 0";

  parameter Modelica.SIunits.Power minStaUnlCap[nSta] = {0.2*staNomCap[1], 0.2*staNomCap[2], 0.2*staNomCap[3]}
    "Nominal part load ratio for at all chiller stages, starting with stage 0";

  final parameter Real small = 0.001
  "Small number to avoid division with zero";

  final parameter Real large = staNomCap[end]*nSta*10
  "Large number for numerical consistency";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap3tft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-320,280},{-300,300}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2tft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,280},{-120,300}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1tft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-320,120},{-300,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap0tft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap3ttf(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{80,280},{100,300}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2ttf(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{260,280},{280,300}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1ttf(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap0ttf(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{260,120},{280,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap3fft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-320,-60},{-300,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2fft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1fft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap0fft(
    final minStaUnlCap=minStaUnlCap,
    final staNomCap=staNomCap,
    final nSta=nSta) "Nominal capacitites at the current and stage one lower"
    annotation (Placement(transformation(extent={{-140,-220},{-120,-200}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta3tft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-220,300},{-200,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2tft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,300},{-20,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1tft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0tft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta3ttf[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{180,300},{200,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2ttf[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{360,300},{380,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1ttf[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{180,140},{200,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0ttf[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{360,140},{380,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta3fft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta2fft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta1fft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.Feedback absErrorSta0fft[5]
    "Delta between the expected and the calculated value"
    annotation (Placement(transformation(extent={{-40,-200},{-20,-180}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-280,250},{-260,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-280,190},{-260,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage3(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-380,420},{-360,440}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tft[nSta](
    final k={true,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-380,210},{-360,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap4[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,250},{-80,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload4[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-200,420},{-180,440}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap8[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-280,90},{-260,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload8[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-280,30},{-260,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-380,370},{-360,390}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap12[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload12[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(final k=0) "Chiller stage"
    annotation (Placement(transformation(extent={{-200,370},{-180,390}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap1[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{120,250},{140,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload1[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{120,190},{140,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage4(k=3)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,420},{40,440}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ttf[nSta](
    final k={true,true,false})
    "Stage availability array"
    annotation (Placement(transformation(extent={{20,210},{40,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap2[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{300,250},{320,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload2[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{300,190},{320,210}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage5(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{200,420},{220,440}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap3[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload3[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage6(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{20,370},{40,390}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap5[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{300,90},{320,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload5[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{300,30},{320,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage7(final k=0) "Chiller stage"
    annotation (Placement(transformation(extent={{200,370},{220,390}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap6[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload6[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-280,-150},{-260,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fft[nSta](
    final k={false,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-380,-130},{-360,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap7[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload7
    [nSta + 2](final k= {0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap9[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload9[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-280,-310},{-260,-290}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomStaCap10[nSta + 2](
    final k={small,5e5,10e5,15e5,large})
    "Array of chiller stage nominal capacities starting with stage 0"
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minStaUnload10[nSta + 2](
    final k={0,1e5,2e5,3e5,large})
    "Array of chiller stage minimal unload capacities"
    annotation (Placement(transformation(extent={{-100,-310},{-80,-290}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fft1[nSta](final k={false,false,true})
    "Stage availability array"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

equation
  connect(stage3.y, staCap3tft.u) annotation (Line(points={{-359,430},{-330,430},
          {-330,290},{-322,290}}, color={255,127,0}));
  connect(staCap3tft.yStaNom, absErrorSta3tft[1].u1) annotation (Line(points={{-299,
          297},{-240,297},{-240,310},{-222,310}}, color={0,0,127}));
  connect(staCap3tft.yStaDowNom, absErrorSta3tft[2].u1) annotation (Line(points=
         {{-299,289},{-240,289},{-240,310},{-222,310}}, color={0,0,127}));
  connect(staCap3tft.yStaUpNom, absErrorSta3tft[3].u1) annotation (Line(points={
          {-299,293},{-240,293},{-240,310},{-222,310}}, color={0,0,127}));
  connect(staCap3tft.yStaMin, absErrorSta3tft[4].u1) annotation (Line(points={{-299,
          283},{-240,283},{-240,310},{-222,310}}, color={0,0,127}));
  connect(staCap3tft.yStaUpMin, absErrorSta3tft[5].u1) annotation (Line(points={
          {-299,285},{-240,285},{-240,310},{-222,310}}, color={0,0,127}));
  connect(tft.y, staCap3tft.uStaAva) annotation (Line(points={{-359,220},{-350,220},
          {-350,284},{-322,284}}, color={255,0,255}));

  connect(stage2.y, staCap2tft.u) annotation (Line(points={{-179,430},{-150,430},
          {-150,290},{-142,290}}, color={255,127,0}));
  connect(staCap2tft.yStaNom, absErrorSta2tft[1].u1) annotation (Line(points={{-119,
          297},{-60,297},{-60,310},{-42,310}}, color={0,0,127}));
  connect(staCap2tft.yStaDowNom, absErrorSta2tft[2].u1) annotation (Line(points=
         {{-119,289},{-60,289},{-60,310},{-42,310}}, color={0,0,127}));
  connect(staCap2tft.yStaUpNom, absErrorSta2tft[3].u1) annotation (Line(points={
          {-119,293},{-60,293},{-60,310},{-42,310}}, color={0,0,127}));
  connect(staCap2tft.yStaMin, absErrorSta2tft[4].u1) annotation (Line(points={{-119,
          283},{-60,283},{-60,310},{-42,310}}, color={0,0,127}));
  connect(staCap2tft.yStaUpMin, absErrorSta2tft[5].u1) annotation (Line(points={
          {-119,285},{-60,285},{-60,310},{-42,310}}, color={0,0,127}));
  connect(stage1.y, staCap1tft.u) annotation (Line(points={{-359,380},{-340,380},
          {-340,130},{-322,130}}, color={255,127,0}));
  connect(staCap1tft.yStaNom, absErrorSta1tft[1].u1) annotation (Line(points={{-299,
          137},{-240,137},{-240,150},{-222,150}}, color={0,0,127}));
  connect(staCap1tft.yStaDowNom, absErrorSta1tft[2].u1) annotation (Line(points=
         {{-299,129},{-240,129},{-240,150},{-222,150}}, color={0,0,127}));
  connect(staCap1tft.yStaUpNom, absErrorSta1tft[3].u1) annotation (Line(points={
          {-299,133},{-240,133},{-240,150},{-222,150}}, color={0,0,127}));
  connect(staCap1tft.yStaMin, absErrorSta1tft[4].u1) annotation (Line(points={{-299,
          123},{-240,123},{-240,150},{-222,150}}, color={0,0,127}));
  connect(staCap1tft.yStaUpMin, absErrorSta1tft[5].u1) annotation (Line(points={
          {-299,125},{-240,125},{-240,150},{-222,150}}, color={0,0,127}));
  connect(stage0.y, staCap0tft.u) annotation (Line(points={{-179,380},{-160,380},
          {-160,130},{-142,130}}, color={255,127,0}));
  connect(staCap0tft.yStaNom, absErrorSta0tft[1].u1) annotation (Line(points={{-119,
          137},{-60,137},{-60,150},{-42,150}}, color={0,0,127}));
  connect(staCap0tft.yStaDowNom, absErrorSta0tft[2].u1) annotation (Line(points=
         {{-119,129},{-60,129},{-60,150},{-42,150}}, color={0,0,127}));
  connect(staCap0tft.yStaUpNom, absErrorSta0tft[3].u1) annotation (Line(points={
          {-119,133},{-60,133},{-60,150},{-42,150}}, color={0,0,127}));
  connect(staCap0tft.yStaMin, absErrorSta0tft[4].u1) annotation (Line(points={{-119,
          123},{-60,123},{-60,150},{-42,150}}, color={0,0,127}));
  connect(staCap0tft.yStaUpMin, absErrorSta0tft[5].u1) annotation (Line(points={
          {-119,125},{-60,125},{-60,150},{-42,150}}, color={0,0,127}));
  connect(nomStaCap[3].y, absErrorSta3tft[1].u2) annotation (Line(points={{-259,
          260},{-218,260},{-218,290},{-210,290},{-210,298}}, color={0,0,127}));
  connect(nomStaCap[5].y, absErrorSta3tft[3].u2) annotation (Line(points={{-259,
          260},{-210,260},{-210,298}}, color={0,0,127}));
  connect(absErrorSta3tft[2].u2, nomStaCap[2].y) annotation (Line(points={{-210,
          298},{-210,290},{-214,290},{-214,260},{-259,260}}, color={0,0,127}));
  connect(minStaUnload[5].y, absErrorSta3tft[5].u2) annotation (Line(points={{-259,
          200},{-202,200},{-202,290},{-210,290},{-210,298}}, color={0,0,127}));
  connect(minStaUnload[3].y, absErrorSta3tft[4].u2) annotation (Line(points={{-259,
          200},{-206,200},{-206,290},{-210,290},{-210,298}}, color={0,0,127}));
  connect(tft.y, staCap2tft.uStaAva) annotation (Line(points={{-359,220},{-150,220},
          {-150,284},{-142,284}}, color={255,0,255}));
  connect(tft.y, staCap1tft.uStaAva) annotation (Line(points={{-359,220},{-350,220},
          {-350,124},{-322,124}}, color={255,0,255}));
  connect(tft.y, staCap0tft.uStaAva) annotation (Line(points={{-359,220},{-150,220},
          {-150,124},{-142,124}}, color={255,0,255}));
  connect(nomStaCap4[2].y, absErrorSta2tft[1].u2) annotation (Line(points={{-79,
          260},{-38,260},{-38,290},{-30,290},{-30,298}}, color={0,0,127}));
  connect(nomStaCap4[3].y, absErrorSta2tft[3].u2)
    annotation (Line(points={{-79,260},{-30,260},{-30,298}}, color={0,0,127}));
  connect(minStaUnload4[2].y, absErrorSta2tft[4].u2) annotation (Line(points={{-79,
          200},{-26,200},{-26,290},{-30,290},{-30,298}}, color={0,0,127}));
  connect(minStaUnload4[3].y, absErrorSta2tft[5].u2) annotation (Line(points={{-79,
          200},{-22,200},{-22,290},{-30,290},{-30,298}}, color={0,0,127}));
  connect(nomStaCap8[2].y, absErrorSta1tft[1].u2) annotation (Line(points={{-259,
          100},{-218,100},{-218,132},{-210,132},{-210,138}}, color={0,0,127}));
  connect(nomStaCap8[2].y, absErrorSta1tft[3].u2) annotation (Line(points={{-259,
          100},{-210,100},{-210,138}}, color={0,0,127}));
  connect(minStaUnload8[2].y, absErrorSta1tft[4].u2) annotation (Line(points={{-259,
          40},{-206,40},{-206,132},{-210,132},{-210,138}}, color={0,0,127}));
  connect(minStaUnload8[2].y, absErrorSta1tft[5].u2) annotation (Line(points={{-259,
          40},{-202,40},{-202,132},{-210,132},{-210,138}}, color={0,0,127}));
  connect(nomStaCap12[1].y, absErrorSta0tft[1].u2) annotation (Line(points={{-79,
          100},{-38,100},{-38,132},{-30,132},{-30,138}}, color={0,0,127}));
  connect(nomStaCap12[1].y, absErrorSta0tft[2].u2) annotation (Line(points={{-79,
          100},{-34,100},{-34,132},{-30,132},{-30,138}}, color={0,0,127}));
  connect(nomStaCap12[2].y, absErrorSta0tft[3].u2)
    annotation (Line(points={{-79,100},{-30,100},{-30,138}}, color={0,0,127}));
  connect(minStaUnload12[1].y, absErrorSta0tft[4].u2) annotation (Line(points={{
          -79,40},{-26,40},{-26,132},{-30,132},{-30,138}}, color={0,0,127}));
  connect(minStaUnload12[2].y, absErrorSta0tft[5].u2) annotation (Line(points={{
          -79,40},{-22,40},{-22,132},{-30,132},{-30,138}}, color={0,0,127}));
  connect(minStaUnload8[2].y, absErrorSta1tft[2].u2) annotation (Line(points={{-259,
          40},{-214,40},{-214,132},{-210,132},{-210,138}}, color={0,0,127}));
  connect(minStaUnload4[2].y, absErrorSta2tft[2].u2) annotation (Line(points={{-79,
          200},{-34,200},{-34,290},{-30,290},{-30,298}}, color={0,0,127}));
  connect(stage4.y, staCap3ttf.u) annotation (Line(points={{41,430},{70,430},{
          70,290},{78,290}}, color={255,127,0}));
  connect(staCap3ttf.yStaNom, absErrorSta3ttf[1].u1) annotation (Line(points={{101,
          297},{160,297},{160,310},{178,310}}, color={0,0,127}));
  connect(staCap3ttf.yStaDowNom, absErrorSta3ttf[2].u1) annotation (Line(points=
         {{101,289},{160,289},{160,310},{178,310}}, color={0,0,127}));
  connect(staCap3ttf.yStaUpNom, absErrorSta3ttf[3].u1) annotation (Line(points={
          {101,293},{160,293},{160,310},{178,310}}, color={0,0,127}));
  connect(staCap3ttf.yStaMin, absErrorSta3ttf[4].u1) annotation (Line(points={{101,
          283},{160,283},{160,310},{178,310}}, color={0,0,127}));
  connect(staCap3ttf.yStaUpMin, absErrorSta3ttf[5].u1) annotation (Line(points={
          {101,285},{160,285},{160,310},{178,310}}, color={0,0,127}));
  connect(ttf.y, staCap3ttf.uStaAva) annotation (Line(points={{41,220},{50,220},
          {50,284},{78,284}}, color={255,0,255}));
  connect(stage5.y, staCap2ttf.u) annotation (Line(points={{221,430},{250,430},
          {250,290},{258,290}}, color={255,127,0}));
  connect(staCap2ttf.yStaNom, absErrorSta2ttf[1].u1) annotation (Line(points={{281,
          297},{340,297},{340,310},{358,310}}, color={0,0,127}));
  connect(staCap2ttf.yStaDowNom, absErrorSta2ttf[2].u1) annotation (Line(points=
         {{281,289},{340,289},{340,310},{358,310}}, color={0,0,127}));
  connect(staCap2ttf.yStaUpNom, absErrorSta2ttf[3].u1) annotation (Line(points={
          {281,293},{340,293},{340,310},{358,310}}, color={0,0,127}));
  connect(staCap2ttf.yStaMin, absErrorSta2ttf[4].u1) annotation (Line(points={{281,
          283},{340,283},{340,310},{358,310}}, color={0,0,127}));
  connect(staCap2ttf.yStaUpMin, absErrorSta2ttf[5].u1) annotation (Line(points={
          {281,285},{340,285},{340,310},{358,310}}, color={0,0,127}));
  connect(stage6.y, staCap1ttf.u) annotation (Line(points={{41,380},{60,380},{
          60,130},{78,130}}, color={255,127,0}));
  connect(staCap1ttf.yStaNom, absErrorSta1ttf[1].u1) annotation (Line(points={{101,
          137},{160,137},{160,150},{178,150}}, color={0,0,127}));
  connect(staCap1ttf.yStaDowNom, absErrorSta1ttf[2].u1) annotation (Line(points=
         {{101,129},{160,129},{160,150},{178,150}}, color={0,0,127}));
  connect(staCap1ttf.yStaUpNom, absErrorSta1ttf[3].u1) annotation (Line(points={
          {101,133},{160,133},{160,150},{178,150}}, color={0,0,127}));
  connect(staCap1ttf.yStaMin, absErrorSta1ttf[4].u1) annotation (Line(points={{101,
          123},{160,123},{160,150},{178,150}}, color={0,0,127}));
  connect(staCap1ttf.yStaUpMin, absErrorSta1ttf[5].u1) annotation (Line(points={
          {101,125},{160,125},{160,150},{178,150}}, color={0,0,127}));
  connect(stage7.y, staCap0ttf.u) annotation (Line(points={{221,380},{240,380},
          {240,130},{258,130}}, color={255,127,0}));
  connect(staCap0ttf.yStaNom, absErrorSta0ttf[1].u1) annotation (Line(points={{281,
          137},{340,137},{340,150},{358,150}}, color={0,0,127}));
  connect(staCap0ttf.yStaDowNom, absErrorSta0ttf[2].u1) annotation (Line(points=
         {{281,129},{340,129},{340,150},{358,150}}, color={0,0,127}));
  connect(staCap0ttf.yStaUpNom, absErrorSta0ttf[3].u1) annotation (Line(points={
          {281,133},{340,133},{340,150},{358,150}}, color={0,0,127}));
  connect(staCap0ttf.yStaMin, absErrorSta0ttf[4].u1) annotation (Line(points={{281,
          123},{340,123},{340,150},{358,150}}, color={0,0,127}));
  connect(staCap0ttf.yStaUpMin, absErrorSta0ttf[5].u1) annotation (Line(points={
          {281,125},{340,125},{340,150},{358,150}}, color={0,0,127}));
  connect(nomStaCap1[3].y, absErrorSta3ttf[1].u2) annotation (Line(points={{141,
          260},{182,260},{182,290},{190,290},{190,298}}, color={0,0,127}));
  connect(nomStaCap1[5].y, absErrorSta3ttf[3].u2)
    annotation (Line(points={{141,260},{190,260},{190,298}}, color={0,0,127}));
  connect(minStaUnload1[5].y, absErrorSta3ttf[5].u2) annotation (Line(points={{141,
          200},{198,200},{198,290},{190,290},{190,298}}, color={0,0,127}));
  connect(minStaUnload1[3].y, absErrorSta3ttf[4].u2) annotation (Line(points={{141,
          200},{194,200},{194,290},{190,290},{190,298}}, color={0,0,127}));
  connect(ttf.y, staCap2ttf.uStaAva) annotation (Line(points={{41,220},{250,220},
          {250,284},{258,284}}, color={255,0,255}));
  connect(ttf.y, staCap1ttf.uStaAva) annotation (Line(points={{41,220},{50,220},
          {50,124},{78,124}}, color={255,0,255}));
  connect(ttf.y, staCap0ttf.uStaAva) annotation (Line(points={{41,220},{250,220},
          {250,124},{258,124}}, color={255,0,255}));
  connect(nomStaCap3[2].y, absErrorSta1ttf[1].u2) annotation (Line(points={{141,
          100},{182,100},{182,132},{190,132},{190,138}}, color={0,0,127}));
  connect(minStaUnload3[2].y, absErrorSta1ttf[4].u2) annotation (Line(points={{141,
          40},{194,40},{194,132},{190,132},{190,138}}, color={0,0,127}));
  connect(nomStaCap5[1].y, absErrorSta0ttf[1].u2) annotation (Line(points={{321,
          100},{362,100},{362,132},{370,132},{370,138}}, color={0,0,127}));
  connect(nomStaCap5[1].y, absErrorSta0ttf[2].u2) annotation (Line(points={{321,
          100},{366,100},{366,132},{370,132},{370,138}}, color={0,0,127}));
  connect(nomStaCap5[2].y, absErrorSta0ttf[3].u2)
    annotation (Line(points={{321,100},{370,100},{370,138}}, color={0,0,127}));
  connect(minStaUnload5[1].y, absErrorSta0ttf[4].u2) annotation (Line(points={{321,
          40},{374,40},{374,132},{370,132},{370,138}}, color={0,0,127}));
  connect(minStaUnload5[2].y, absErrorSta0ttf[5].u2) annotation (Line(points={{321,
          40},{378,40},{378,132},{370,132},{370,138}}, color={0,0,127}));
  connect(minStaUnload3[2].y, absErrorSta1ttf[2].u2) annotation (Line(points={{141,
          40},{186,40},{186,132},{190,132},{190,138}}, color={0,0,127}));
  connect(nomStaCap1[3].y, absErrorSta3ttf[2].u2) annotation (Line(points={{141,
          260},{186,260},{186,290},{190,290},{190,298}}, color={0,0,127}));
  connect(nomStaCap2[3].y, absErrorSta2ttf[1].u2) annotation (Line(points={{321,
          260},{362,260},{362,290},{370,290},{370,298}}, color={0,0,127}));
  connect(nomStaCap2[2].y, absErrorSta2ttf[2].u2) annotation (Line(points={{321,
          260},{366,260},{366,290},{370,290},{370,298}}, color={0,0,127}));
  connect(minStaUnload2[3].y, absErrorSta2ttf[4].u2) annotation (Line(points={{321,
          200},{374,200},{374,290},{370,290},{370,298}}, color={0,0,127}));
  connect(nomStaCap2[5].y, absErrorSta2ttf[3].u2)
    annotation (Line(points={{321,260},{370,260},{370,298}}, color={0,0,127}));
  connect(minStaUnload3[3].y, absErrorSta1ttf[5].u2) annotation (Line(points={{141,
          40},{198,40},{198,132},{190,132},{190,138}}, color={0,0,127}));
  connect(nomStaCap3[3].y, absErrorSta1ttf[3].u2)
    annotation (Line(points={{141,100},{190,100},{190,138}}, color={0,0,127}));
  connect(minStaUnload2[5].y, absErrorSta2ttf[5].u2) annotation (Line(points={{321,
          200},{378,200},{378,290},{370,290},{370,298}}, color={0,0,127}));
  connect(stage3.y, staCap3fft.u) annotation (Line(points={{-359,430},{-330,430},
          {-330,-50},{-322,-50}}, color={255,127,0}));
  connect(staCap3fft.yStaNom, absErrorSta3fft[1].u1) annotation (Line(points={{-299,
          -43},{-240,-43},{-240,-30},{-222,-30}}, color={0,0,127}));
  connect(staCap3fft.yStaDowNom, absErrorSta3fft[2].u1) annotation (Line(points=
         {{-299,-51},{-240,-51},{-240,-30},{-222,-30}}, color={0,0,127}));
  connect(staCap3fft.yStaUpNom, absErrorSta3fft[3].u1) annotation (Line(points={
          {-299,-47},{-240,-47},{-240,-30},{-222,-30}}, color={0,0,127}));
  connect(staCap3fft.yStaMin, absErrorSta3fft[4].u1) annotation (Line(points={{-299,
          -57},{-240,-57},{-240,-30},{-222,-30}}, color={0,0,127}));
  connect(staCap3fft.yStaUpMin, absErrorSta3fft[5].u1) annotation (Line(points={
          {-299,-55},{-240,-55},{-240,-30},{-222,-30}}, color={0,0,127}));
  connect(fft.y, staCap3fft.uStaAva) annotation (Line(points={{-359,-120},{-350,
          -120},{-350,-56},{-322,-56}}, color={255,0,255}));
  connect(stage2.y, staCap2fft.u) annotation (Line(points={{-179,430},{-150,430},
          {-150,-50},{-142,-50}}, color={255,127,0}));
  connect(staCap2fft.yStaNom, absErrorSta2fft[1].u1) annotation (Line(points={{-119,
          -43},{-60,-43},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(staCap2fft.yStaDowNom, absErrorSta2fft[2].u1) annotation (Line(points=
         {{-119,-51},{-60,-51},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(staCap2fft.yStaUpNom, absErrorSta2fft[3].u1) annotation (Line(points={
          {-119,-47},{-60,-47},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(staCap2fft.yStaMin, absErrorSta2fft[4].u1) annotation (Line(points={{-119,
          -57},{-60,-57},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(staCap2fft.yStaUpMin, absErrorSta2fft[5].u1) annotation (Line(points={
          {-119,-55},{-60,-55},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(stage1.y, staCap1fft.u) annotation (Line(points={{-359,380},{-340,380},
          {-340,-210},{-322,-210}}, color={255,127,0}));
  connect(staCap1fft.yStaNom, absErrorSta1fft[1].u1) annotation (Line(points={{-299,
          -203},{-240,-203},{-240,-190},{-222,-190}}, color={0,0,127}));
  connect(staCap1fft.yStaDowNom, absErrorSta1fft[2].u1) annotation (Line(points=
         {{-299,-211},{-240,-211},{-240,-190},{-222,-190}}, color={0,0,127}));
  connect(staCap1fft.yStaUpNom, absErrorSta1fft[3].u1) annotation (Line(points={
          {-299,-207},{-240,-207},{-240,-190},{-222,-190}}, color={0,0,127}));
  connect(staCap1fft.yStaMin, absErrorSta1fft[4].u1) annotation (Line(points={{-299,
          -217},{-240,-217},{-240,-190},{-222,-190}}, color={0,0,127}));
  connect(staCap1fft.yStaUpMin, absErrorSta1fft[5].u1) annotation (Line(points={
          {-299,-215},{-240,-215},{-240,-190},{-222,-190}}, color={0,0,127}));
  connect(stage0.y, staCap0fft.u) annotation (Line(points={{-179,380},{-160,380},
          {-160,-210},{-142,-210}}, color={255,127,0}));
  connect(staCap0fft.yStaNom, absErrorSta0fft[1].u1) annotation (Line(points={{-119,
          -203},{-60,-203},{-60,-190},{-42,-190}}, color={0,0,127}));
  connect(staCap0fft.yStaDowNom, absErrorSta0fft[2].u1) annotation (Line(points=
         {{-119,-211},{-60,-211},{-60,-190},{-42,-190}}, color={0,0,127}));
  connect(staCap0fft.yStaUpNom, absErrorSta0fft[3].u1) annotation (Line(points={
          {-119,-207},{-60,-207},{-60,-190},{-42,-190}}, color={0,0,127}));
  connect(staCap0fft.yStaMin, absErrorSta0fft[4].u1) annotation (Line(points={{-119,
          -217},{-60,-217},{-60,-190},{-42,-190}}, color={0,0,127}));
  connect(staCap0fft.yStaUpMin, absErrorSta0fft[5].u1) annotation (Line(points={
          {-119,-215},{-60,-215},{-60,-190},{-42,-190}}, color={0,0,127}));
  connect(nomStaCap6[5].y, absErrorSta3fft[3].u2) annotation (Line(points={{-259,
          -80},{-210,-80},{-210,-42}}, color={0,0,127}));
  connect(minStaUnload6[5].y, absErrorSta3fft[5].u2) annotation (Line(points={{-259,
          -140},{-202,-140},{-202,-50},{-210,-50},{-210,-42}}, color={0,0,127}));
  connect(fft.y, staCap2fft.uStaAva) annotation (Line(points={{-359,-120},{-150,
          -120},{-150,-56},{-142,-56}}, color={255,0,255}));
  connect(fft.y, staCap1fft.uStaAva) annotation (Line(points={{-359,-120},{-350,
          -120},{-350,-216},{-322,-216}}, color={255,0,255}));
  connect(fft.y, staCap0fft.uStaAva) annotation (Line(points={{-359,-120},{-150,
          -120},{-150,-216},{-142,-216}}, color={255,0,255}));
  connect(nomStaCap6[2].y, absErrorSta3fft[1].u2) annotation (Line(points={{-259,
          -80},{-218,-80},{-218,-50},{-210,-50},{-210,-42}}, color={0,0,127}));
  connect(minStaUnload6[2].y, absErrorSta3fft[4].u2) annotation (Line(points={{-259,
          -140},{-206,-140},{-206,-50},{-210,-50},{-210,-42}}, color={0,0,127}));
  connect(nomStaCap7[1].y, absErrorSta2fft[1].u2) annotation (Line(points={{-79,
          -80},{-38,-80},{-38,-50},{-30,-50},{-30,-42}}, color={0,0,127}));
  connect(nomStaCap7[1].y, absErrorSta2fft[2].u2) annotation (Line(points={{-79,
          -80},{-34,-80},{-34,-50},{-30,-50},{-30,-42}}, color={0,0,127}));
  connect(nomStaCap7[2].y, absErrorSta2fft[3].u2)
    annotation (Line(points={{-79,-80},{-30,-80},{-30,-42}}, color={0,0,127}));
  connect(minStaUnload7[1].y, absErrorSta2fft[4].u2) annotation (Line(points={{-79,
          -140},{-26,-140},{-26,-50},{-30,-50},{-30,-42}}, color={0,0,127}));
  connect(minStaUnload7[2].y, absErrorSta2fft[5].u2) annotation (Line(points={{-79,
          -140},{-22,-140},{-22,-50},{-30,-50},{-30,-42}}, color={0,0,127}));
  connect(nomStaCap9[1].y, absErrorSta1fft[1].u2) annotation (Line(points={{-259,
          -240},{-218,-240},{-218,-210},{-210,-210},{-210,-202}}, color={0,0,127}));
  connect(nomStaCap9[1].y, absErrorSta1fft[2].u2) annotation (Line(points={{-259,
          -240},{-214,-240},{-214,-210},{-210,-210},{-210,-202}}, color={0,0,127}));
  connect(nomStaCap9[1].y, absErrorSta1fft[3].u2) annotation (Line(points={{-259,
          -240},{-210,-240},{-210,-202}}, color={0,0,127}));
  connect(minStaUnload9[1].y, absErrorSta1fft[4].u2) annotation (Line(points={{-259,
          -300},{-206,-300},{-206,-210},{-210,-210},{-210,-202}}, color={0,0,127}));
  connect(minStaUnload9[1].y, absErrorSta1fft[5].u2) annotation (Line(points={{-259,
          -300},{-202,-300},{-202,-210},{-210,-210},{-210,-202}}, color={0,0,127}));
  connect(nomStaCap10[1].y, absErrorSta0fft[1].u2) annotation (Line(points={{-79,
          -240},{-38,-240},{-38,-210},{-30,-210},{-30,-202}}, color={0,0,127}));
  connect(nomStaCap10[1].y, absErrorSta0fft[2].u2) annotation (Line(points={{-79,
          -240},{-34,-240},{-34,-210},{-30,-210},{-30,-202}}, color={0,0,127}));
  connect(nomStaCap10[1].y, absErrorSta0fft[3].u2) annotation (Line(points={{-79,
          -240},{-30,-240},{-30,-202}}, color={0,0,127}));
  connect(minStaUnload10[1].y, absErrorSta0fft[4].u2) annotation (Line(points={{
          -79,-300},{-26,-300},{-26,-210},{-30,-210},{-30,-202}}, color={0,0,127}));
  connect(minStaUnload10[1].y, absErrorSta0fft[5].u2) annotation (Line(points={{
          -79,-300},{-22,-300},{-22,-210},{-30,-210},{-30,-202}}, color={0,0,127}));
  connect(minStaUnload6[2].y, absErrorSta3fft[2].u2) annotation (Line(points={{-259,
          -140},{-214,-140},{-214,-50},{-210,-50},{-210,-42}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-400,-340},{400,460}})));
end Capacities_uStaAva;
