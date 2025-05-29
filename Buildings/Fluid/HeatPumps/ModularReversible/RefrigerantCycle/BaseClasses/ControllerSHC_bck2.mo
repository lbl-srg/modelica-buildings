within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block ControllerSHC_bck2 "Controller for modular multipipe system"
  parameter Integer nUni(
    final min=1)
    "Number of modules"
    annotation (Evaluate=true);
  parameter Real SPLR(
    max=1,
    min=0)=0.9
    "Staging part load ratio";
  parameter Real dtRun(
    final unit="s",
    final min=0,
    displayUnit="min")=0
    "Minimum runtime of each stage"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniHea
    "Number of modules in heating mode"
    annotation (Placement(transformation(extent={{220,60},{260,100}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniCoo
    "Number of modules in cooling mode"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniShc
    "Number of modules in SHC mode (may be cycling into cooling or heating mode)"
    annotation (Placement(transformation(extent={{220,-100},{260,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode
    "Operating mode command: 1 for heating, 2 for cooling, 3 for SHC"
    annotation (Placement(transformation(extent={{-260,140},{-220,180}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable heat pump, false to disable heat pump"
    annotation (Placement(transformation(extent={{-260,220},{-220,260}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpHeaTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpCooTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisShc
    "True if disabled OR SHC disabled"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaShc "True if SHC mode enabled"
    annotation (Placement(transformation(extent={{-168,110},{-148,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxMod[3](k=Integer({
        Buildings.Fluid.HeatPumps.Types.OperatingMode.Heating,Buildings.Fluid.HeatPumps.Types.OperatingMode.Cooling,
        Buildings.Fluid.HeatPumps.Types.OperatingMode.SHC})) "Mode index"
    annotation (Placement(transformation(extent={{-210,210},{-190,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not disShc "True if SHC disabled"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaHea
    "True if heating mode enabled"
    annotation (Placement(transformation(extent={{-168,170},{-148,190}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaCoo
    "True if cooling mode enabled"
    annotation (Placement(transformation(extent={{-168,140},{-148,160}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisCooAndShc
    "True if disabled OR cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHeaOrShc
    "True if heating or SHC mode enabled"
    annotation (Placement(transformation(extent={{-130,170},{-110,190}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaCooOrShc
    "True if cooling or SHC mode enabled"
    annotation (Placement(transformation(extent={{-130,140},{-110,160}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCooAndShc
    "True if both cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-98,140},{-78,160}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisHeaAndShc
    "True if disabled OR heating and SHC disabled"
    annotation (Placement(transformation(extent={{-60,170},{-40,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not disHeaAndShc
    "True if both heating and SHC disabled"
    annotation (Placement(transformation(extent={{-98,170},{-78,190}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nUniTot(nin=3)
    "Total number of modules running (in any mode)"
    annotation (Placement(transformation(extent={{200,-250},{180,-230}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold noUniAva(final t=
        nUni) "True if no more module is available"
    annotation (Placement(transformation(extent={{170,-250},{150,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooInt_flow_min(final unit="J/s")
    =min(QCooInt_flow)
    "Capacity at maximum PLR - Cooling mode, single module"
    annotation (Placement(transformation(extent={{-260,-120},{-220,-80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooShcInt_flow_min(final
      unit="J/s")=min(QCooShcInt_flow)
    "Cooling capacity at maximum PLR - SHC mode, single module"
    annotation (Placement(transformation(extent={{-260,-200},{-220,-160}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaShcInt_flow_max(final
      unit="J/s")=max(QHeaShcInt_flow)
    "Heating capacity at maximum PLR - SHC mode, single module"
    annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaSet_flow(final unit="J/s")
    "Heating load - All modules"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooSet_flow(final unit="J/s")
    "Cooling load - All modules"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaInt_flow_max(final unit="J/s")
    =max(QHeaInt_flow)
    "Capacity at maximum PLR - Heating mode, single module"
  annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Logical.And upShc "SHC stage up condition"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpShcTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaHeaShc(nin=3)
    "Swap module from heating to SHC mode"
    annotation (Placement(transformation(extent={{-108,-10},{-88,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold uniHea(final t=1)
    "True if at least one module is in heating mode"
    annotation (Placement(transformation(extent={{140,-230},{120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Not noSwaHeaShc "No swap"
    annotation (Placement(transformation(extent={{-108,-40},{-88,-20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaCooShc(nin=4)
    "Swap module from cooling to SHC mode"
    annotation (Placement(transformation(extent={{-108,-70},{-88,-50}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold uniCoo(final t=1)
    "True if at least one module is in cooling mode"
    annotation (Placement(transformation(extent={{170,-210},{150,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Nor noSwaToShc
    "True if no swap from single mode to SHC"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  StageChangeCondition chaStaShc(final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity
        .Heating, final SPLR=SPLR)
    "SHC stage change conditions based on heating load"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));
  StageChangeCondition chaStaShcCoo(final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity
        .Cooling, final SPLR=SPLR)
    "SHC stage change conditions based on cooling load"
    annotation (Placement(transformation(extent={{-200,-10},{-180,10}})));
  StageChangeCondition chaStaHea(final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity
        .Heating, final SPLR=SPLR) "Heating stage change conditions"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));
  StageChangeCondition chaStaCoo(final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity
        .Cooling, final SPLR=SPLR) "Cooling stage change conditions"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Or dowShc "SHC stage down condition"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not noUpShc
    "SHC stage up condition not met"
    annotation (Placement(transformation(extent={{-140,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And upHea "Heating stage up condition"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaShcHea(nin=2)
    "Swap module from SHC to heating mode"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not noSwaToHea "No swap to heating"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And upHeaAndNoSwa
    "Heating stage up & no swap from SHC to heating"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And upCoo "Cooling stage up condition"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaShcCoo(nin=2)
    "Swap module from SHC to cooling mode"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not noSwaToCoo "No swap to cooling"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And upCooAndNoSwa
    "Cooling stage up & no swap from SHC to cooling"
    annotation (Placement(transformation(extent={{10,-130},{30,-110}})));
  Templates.Plants.Controls.Utilities.StageIndex nShc(
    have_inpAva=true,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in SHC mode"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaCoo[nUni]
    "True if module available for cooling mode"
    annotation (Placement(transformation(extent={{162,-30},{142,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxUni[nUni](k={i for i
         in 1:nUni}) "Module index"
    annotation (Placement(transformation(extent={{202,130},{182,150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{172,10},{192,30}})));
  Templates.Plants.Controls.Utilities.StageIndex nHea(
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in heating mode"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniCoo(k={1,-1,-1}, nin=3)
    "Return nUni - nUniHea - nUniShc"
    annotation (Placement(transformation(extent={{142,10},{162,30}})));
  Templates.Plants.Controls.Utilities.StageIndex numCoo(
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in cooling mode"
    annotation (Placement(transformation(extent={{82,-10},{102,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{172,-70},{192,-50}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniHea(k={1,-1,-1}, nin=3)
    "Return nUni - nUniCoo - nUniShc"
    annotation (Placement(transformation(extent={{142,-70},{162,-50}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaCoo2[nUni]
    "True if module available for cooling mode"
    annotation (Placement(transformation(extent={{162,50},{142,70}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaShc[nUni]
    "True if module available for SHC mode"
    annotation (Placement(transformation(extent={{160,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniShc(k={1,-1,-1}, nin=3)
    "Return nUni - nUniHea - nUniCoo"
    annotation (Placement(transformation(extent={{142,90},{162,110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep2(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{172,90},{192,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numUni(final k=nUni)
    "Number of modules"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
equation
  connect(mode, enaShc.u2) annotation (Line(points={{-240,160},{-200,160},{-200,
          112},{-170,112}},
                          color={255,127,0}));
  connect(idxMod[3].y, enaShc.u1) annotation (Line(points={{-188,220},{-180,220},
          {-180,120},{-170,120}}, color={255,127,0}));
  connect(enaShc.y, disShc.u)
    annotation (Line(points={{-146,120},{-132,120}}, color={255,0,255}));
  connect(disShc.y, offOrDisShc.u2) annotation (Line(points={{-108,120},{-76,
          120},{-76,112},{-62,112}},
                              color={255,0,255}));
  connect(idxMod[1].y, enaHea.u1)
    annotation (Line(points={{-188,220},{-180,220},{-180,180},{-170,180}},
                                                     color={255,127,0}));
  connect(mode, enaCoo.u2) annotation (Line(points={{-240,160},{-200,160},{-200,
          142},{-170,142}}, color={255,127,0}));
  connect(idxMod[2].y, enaCoo.u1) annotation (Line(points={{-188,220},{-180,220},
          {-180,150},{-170,150}}, color={255,127,0}));
  connect(mode, enaHea.u2) annotation (Line(points={{-240,160},{-200,160},{-200,
          172},{-170,172}}, color={255,127,0}));
  connect(enaHea.y, enaHeaOrShc.u1)
    annotation (Line(points={{-146,180},{-132,180}}, color={255,0,255}));
  connect(enaShc.y, enaHeaOrShc.u2) annotation (Line(points={{-146,120},{-140,
          120},{-140,172},{-132,172}}, color={255,0,255}));
  connect(enaCoo.y, enaCooOrShc.u1)
    annotation (Line(points={{-146,150},{-132,150}}, color={255,0,255}));
  connect(enaShc.y, enaCooOrShc.u2) annotation (Line(points={{-146,120},{-140,
          120},{-140,142},{-132,142}}, color={255,0,255}));
  connect(enaCooOrShc.y, disCooAndShc.u)
    annotation (Line(points={{-108,150},{-100,150}},
                                                   color={255,0,255}));
  connect(disCooAndShc.y, offOrDisCooAndShc.u2) annotation (Line(points={{-76,150},
          {-74,150},{-74,142},{-62,142}},      color={255,0,255}));
  connect(enaHeaOrShc.y, disHeaAndShc.u)
    annotation (Line(points={{-108,180},{-100,180}},
                                                   color={255,0,255}));
  connect(disHeaAndShc.y, offOrDisHeaAndShc.u2) annotation (Line(points={{-76,180},
          {-74,180},{-74,172},{-62,172}},      color={255,0,255}));
  connect(nUniHea, nUniTot.u[1]) annotation (Line(points={{240,80},{210,80},{
          210,-242.333},{202,-242.333}}, color={255,127,0}));
  connect(nUniCoo, nUniTot.u[2]) annotation (Line(points={{240,0},{212,0},{212,
          -240},{202,-240}}, color={255,127,0}));
  connect(nUniShc, nUniTot.u[3]) annotation (Line(points={{240,-80},{214,-80},{
          214,-237.667},{202,-237.667}}, color={255,127,0}));
  connect(nUniTot.y, noUniAva.u)
    annotation (Line(points={{178,-240},{172,-240}}, color={255,127,0}));
  connect(upShc.y, swaHeaShc.u[1]) annotation (Line(points={{-138,40},{-120,40},
          {-120,-2},{-116,-2},{-116,-2.33333},{-110,-2.33333}}, color={255,0,
          255}));
  connect(noUniAva.y, swaHeaShc.u[2]) annotation (Line(points={{148,-240},{-118,
          -240},{-118,0},{-110,0}}, color={255,0,255}));
  connect(nUniHea, uniHea.u) annotation (Line(points={{240,80},{210,80},{210,
          -220},{142,-220}}, color={255,127,0}));
  connect(uniHea.y, swaHeaShc.u[3]) annotation (Line(points={{118,-220},{-116,
          -220},{-116,2.33333},{-110,2.33333}}, color={255,0,255}));
  connect(swaHeaShc.y, noSwaHeaShc.u) annotation (Line(points={{-86,0},{-78,0},
          {-78,-12},{-114,-12},{-114,-30},{-110,-30}}, color={255,0,255}));
  connect(upShc.y, swaCooShc.u[1]) annotation (Line(points={{-138,40},{-120,40},
          {-120,-60},{-110,-60},{-110,-62.625}}, color={255,0,255}));
  connect(noUniAva.y, swaCooShc.u[2]) annotation (Line(points={{148,-240},{-114,
          -240},{-114,-140},{-112,-140},{-112,-60.875},{-110,-60.875}}, color={
          255,0,255}));
  connect(noSwaHeaShc.y, swaCooShc.u[3]) annotation (Line(points={{-86,-30},{
          -78,-30},{-78,-42},{-114,-42},{-114,-59.125},{-110,-59.125}}, color={
          255,0,255}));
  connect(nUniCoo, uniCoo.u) annotation (Line(points={{240,0},{212,0},{212,-200},
          {172,-200}}, color={255,127,0}));
  connect(uniCoo.y, swaCooShc.u[4]) annotation (Line(points={{148,-200},{-112,
          -200},{-112,-57.375},{-110,-57.375}}, color={255,0,255}));
  connect(swaHeaShc.y, noSwaToShc.u1) annotation (Line(points={{-86,0},{-74,0},
          {-74,-20},{-72,-20}}, color={255,0,255}));
  connect(swaCooShc.y, noSwaToShc.u2) annotation (Line(points={{-86,-60},{-76,
          -60},{-76,-28},{-72,-28}}, color={255,0,255}));
  connect(QHeaSet_flow, chaStaShc.QSet_flow) annotation (Line(points={{-240,60},
          {-210,60},{-210,46},{-202,46}}, color={0,0,127}));
  connect(QCooSet_flow, chaStaShcCoo.QSet_flow) annotation (Line(points={{-240,
          20},{-212,20},{-212,6},{-202,6}}, color={0,0,127}));
  connect(QCooShcInt_flow_min, chaStaShcCoo.Q_flow) annotation (Line(points={{
          -240,-180},{-206,-180},{-206,0},{-202,0}}, color={0,0,127}));
  connect(nUniShc, chaStaShcCoo.nUni) annotation (Line(points={{240,-80},{-208,
          -80},{-208,-6},{-202,-6}}, color={255,127,0}));
  connect(nUniShc, chaStaShc.nUni) annotation (Line(points={{240,-80},{-208,-80},
          {-208,34},{-202,34}}, color={255,127,0}));
  connect(QCooSet_flow, chaStaCoo.QSet_flow) annotation (Line(points={{-240,20},
          {-212,20},{-212,-134},{-202,-134}}, color={0,0,127}));
  connect(QCooShcInt_flow_min, chaStaCoo.Q_flow) annotation (Line(points={{-240,
          -180},{-206,-180},{-206,-140},{-202,-140}}, color={0,0,127}));
  connect(QHeaShcInt_flow_max, chaStaHea.Q_flow) annotation (Line(points={{-240,
          -140},{-210,-140},{-210,-60},{-202,-60}}, color={0,0,127}));
  connect(QHeaSet_flow, chaStaHea.QSet_flow) annotation (Line(points={{-240,60},
          {-210,60},{-210,-54},{-202,-54}}, color={0,0,127}));
  connect(nUniHea, chaStaHea.nUni) annotation (Line(points={{240,80},{210,80},{
          210,-78},{-214,-78},{-214,-66},{-202,-66}}, color={255,127,0}));
  connect(nUniCoo, chaStaCoo.nUni) annotation (Line(points={{240,0},{212,0},{
          212,-84},{-214,-84},{-214,-146},{-202,-146}}, color={255,127,0}));
  connect(chaStaShc.y1Up, upShc.u1) annotation (Line(points={{-178,46},{-170,46},
          {-170,40},{-162,40}}, color={255,0,255}));
  connect(QHeaShcInt_flow_max, chaStaCoo.Q_flow)
    annotation (Line(points={{-240,-140},{-202,-140}}, color={0,0,127}));
  connect(chaStaShc.y1Dow, dowShc.u1) annotation (Line(points={{-178,34},{-170,
          34},{-170,0},{-162,0}}, color={255,0,255}));
  connect(chaStaShcCoo.y1Dow, dowShc.u2) annotation (Line(points={{-178,-6},{
          -170,-6},{-170,-8},{-162,-8}}, color={255,0,255}));
  connect(chaStaShcCoo.y1Up, upShc.u2) annotation (Line(points={{-178,6},{-166,
          6},{-166,32},{-162,32}}, color={255,0,255}));
  connect(upShc.y, noUpShc.u) annotation (Line(points={{-138,40},{-120,40},{
          -120,-30},{-138,-30}}, color={255,0,255}));
  connect(noUpShc.y, upHea.u1) annotation (Line(points={{-162,-30},{-168,-30},{
          -168,-60},{-162,-60}}, color={255,0,255}));
  connect(chaStaHea.y1Up, upHea.u2) annotation (Line(points={{-178,-54},{-172,
          -54},{-172,-68},{-162,-68}}, color={255,0,255}));
  connect(upHea.y, swaShcHea.u[1]) annotation (Line(points={{-138,-60},{-128,
          -60},{-128,-76},{-60,-76},{-60,-61.75},{-52,-61.75}}, color={255,0,
          255}));
  connect(chaStaShcCoo.y1Dow, swaShcHea.u[2]) annotation (Line(points={{-178,-6},
          {-170,-6},{-170,-74},{-62,-74},{-62,-58.25},{-52,-58.25}}, color={255,
          0,255}));
  connect(swaShcHea.y, noSwaToHea.u)
    annotation (Line(points={{-28,-60},{-22,-60}}, color={255,0,255}));
  connect(noSwaToHea.y, upHeaAndNoSwa.u1)
    annotation (Line(points={{2,-60},{8,-60}}, color={255,0,255}));
  connect(upHeaAndNoSwa.y, y1UpHeaTim.u)
    annotation (Line(points={{32,-60},{38,-60}}, color={255,0,255}));
  connect(upHea.y, upHeaAndNoSwa.u2) annotation (Line(points={{-138,-60},{-128,
          -60},{-128,-76},{2,-76},{2,-68},{8,-68}}, color={255,0,255}));
  connect(chaStaCoo.y1Up, upCoo.u2) annotation (Line(points={{-178,-134},{-170,
          -134},{-170,-128},{-162,-128}}, color={255,0,255}));
  connect(noUpShc.y, upCoo.u1) annotation (Line(points={{-162,-30},{-168,-30},{
          -168,-120},{-162,-120}}, color={255,0,255}));
  connect(swaShcCoo.y, noSwaToCoo.u)
    annotation (Line(points={{-28,-120},{-22,-120}}, color={255,0,255}));
  connect(noSwaToCoo.y, upCooAndNoSwa.u1)
    annotation (Line(points={{2,-120},{8,-120}}, color={255,0,255}));
  connect(upCoo.y, swaShcCoo.u[1]) annotation (Line(points={{-138,-120},{-60,
          -120},{-60,-121.75},{-52,-121.75}}, color={255,0,255}));
  connect(chaStaShc.y1Dow, swaShcCoo.u[2]) annotation (Line(points={{-178,34},{
          -174,34},{-174,-100},{-60,-100},{-60,-118.25},{-52,-118.25}}, color={
          255,0,255}));
  connect(upCooAndNoSwa.y, y1UpCooTim.u)
    annotation (Line(points={{32,-120},{38,-120}}, color={255,0,255}));
  connect(nShc.y, nUniShc)
    annotation (Line(points={{102,-100},{172,-100},{172,-80},{240,-80}},
                                                  color={255,127,0}));
  connect(numUni.y,remUniCoo. u[1]) annotation (Line(points={{102,40},{112,40},
          {112,18},{126,18},{126,17.6667},{140,17.6667}},
                                                      color={255,127,0}));
  connect(nHea.y,remUniCoo. u[2]) annotation (Line(points={{102,80},{122,80},{
          122,20},{140,20}},
                         color={255,127,0}));
  connect(nShc.y,remUniCoo. u[3]) annotation (Line(points={{102,-100},{122,-100},
          {122,22.3333},{140,22.3333}},
                                      color={255,127,0}));
  connect(idxUni.y,avaCoo. u1) annotation (Line(points={{180,140},{168,140},{
          168,-20},{164,-20}}, color={255,127,0}));
  connect(remUniCoo.y,rep. u)
    annotation (Line(points={{164,20},{170,20}}, color={255,127,0}));
  connect(rep.y,avaCoo. u2) annotation (Line(points={{194,20},{196,20},{196,-28},
          {164,-28}}, color={255,127,0}));
  connect(avaCoo.y,numCoo. u1AvaSta) annotation (Line(points={{140,-20},{76,-20},
          {76,-6},{80,-6}}, color={255,0,255}));
  connect(numCoo.y, nUniCoo)
    annotation (Line(points={{104,0},{240,0}},color={255,127,0}));
  connect(remUniHea.y,rep1. u)
    annotation (Line(points={{164,-60},{170,-60}}, color={255,127,0}));
  connect(numCoo.y, nUniCoo)
    annotation (Line(points={{104,0},{240,0}},color={255,127,0}));
  connect(numUni.y,remUniHea. u[1]) annotation (Line(points={{102,40},{112,40},
          {112,-62.3333},{140,-62.3333}},
                                        color={255,127,0}));
  connect(numCoo.y,remUniHea. u[2]) annotation (Line(points={{104,0},{132,0},{
          132,-60},{140,-60}}, color={255,127,0}));
  connect(nShc.y,remUniHea. u[3]) annotation (Line(points={{102,-100},{122,-100},
          {122,-57.6667},{140,-57.6667}},
                                        color={255,127,0}));
  connect(idxUni.y,avaCoo2. u1) annotation (Line(points={{180,140},{168,140},{
          168,60},{164,60}}, color={255,127,0}));
  connect(rep1.y,avaCoo2. u2) annotation (Line(points={{194,-60},{198,-60},{198,
          52},{164,52}}, color={255,127,0}));
  connect(avaCoo2.y,nHea. u1AvaSta) annotation (Line(points={{140,60},{76,60},{
          76,74},{78,74}}, color={255,0,255}));
  connect(idxUni.y,avaShc. u1) annotation (Line(points={{180,140},{168,140},{
          168,-120},{162,-120}}, color={255,127,0}));
  connect(numUni.y,remUniShc. u[1]) annotation (Line(points={{102,40},{112,40},
          {112,97.6667},{140,97.6667}},
                                      color={255,127,0}));
  connect(nHea.y,remUniShc. u[2]) annotation (Line(points={{102,80},{122,80},{
          122,100},{140,100}},
                           color={255,127,0}));
  connect(numCoo.y,remUniShc. u[3]) annotation (Line(points={{104,0},{132,0},{
          132,102.333},{140,102.333}}, color={255,127,0}));
  connect(remUniShc.y,rep2. u)
    annotation (Line(points={{164,100},{170,100}}, color={255,127,0}));
  connect(rep2.y,avaShc. u2) annotation (Line(points={{194,100},{200,100},{200,
          -128},{162,-128}}, color={255,127,0}));
  connect(avaShc.y,nShc. u1AvaSta) annotation (Line(points={{138,-120},{74,-120},
          {74,-106},{78,-106}},
                              color={255,0,255}));
  connect(nHea.y, nUniHea) annotation (Line(points={{102,80},{240,80}},
                    color={255,127,0}));
  connect(upShc.y, y1UpShcTim.u)
    annotation (Line(points={{-138,40},{38,40}}, color={255,0,255}));
  connect(y1UpShcTim.passed, nShc.u1Up) annotation (Line(points={{62,32},{74,32},
          {74,-98},{78,-98}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -260},{220,260}},
        grid={2,2})));
end ControllerSHC_bck2;
