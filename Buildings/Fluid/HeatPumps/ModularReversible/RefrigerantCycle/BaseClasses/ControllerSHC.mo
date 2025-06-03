within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block ControllerSHC "Controller for modular multipipe system"
  parameter Integer nUni(
    final min=1)
    "Number of modules"
    annotation (Evaluate=true);
  parameter Real dtRun(
    final unit="s",
    final min=0,
    displayUnit="min")=15*60
    "Minimum runtime of each stage"
    annotation (Evaluate=true);
  parameter Real SPLR(
    max=1,
    min=0)=0.9
    "Staging part load ratio";
  parameter Real dtMea(
    min=0,
    unit="s")=300
    "Duration for computing load moving average";
  constant Real deltaX = 1E-4
    "Small number guarding against numerical residuals influencing stage transitions";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniHea
    "Number of modules in heating mode"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniCoo
    "Number of modules in cooling mode"
    annotation (Placement(transformation(extent={{220,-120},{260,-80}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniShc
    "Number of modules in SHC mode (may be cycling into cooling or heating mode)"
    annotation (Placement(transformation(extent={{220,80},{260,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode
    "Operating mode command: 1 for heating, 2 for cooling, 3 for SHC"
    annotation (Placement(transformation(extent={{-260,160},{-220,200}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable heat pump, false to disable heat pump"
    annotation (Placement(transformation(extent={{-260,220},{-220,260}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Templates.Plants.Controls.Utilities.StageIndex nShc(
    have_inpAva=true,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in SHC mode"
    annotation (Placement(transformation(extent={{120,90},{140,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaShc
    "Enable lead module in SHC mode"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not off "True if disabled"
    annotation (Placement(transformation(extent={{-210,230},{-190,250}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisShc
    "True if disabled OR SHC disabled"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaShc "True if SHC mode enabled"
    annotation (Placement(transformation(extent={{-170,130},{-150,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxMod[3](k=Integer({
        Buildings.Fluid.HeatPumps.Types.OperatingMode.Heating,Buildings.Fluid.HeatPumps.Types.OperatingMode.Cooling,
        Buildings.Fluid.HeatPumps.Types.OperatingMode.SHC})) "Mode index"
    annotation (Placement(transformation(extent={{-210,190},{-190,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not disShc "True if SHC disabled"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaCoo
    "Enable lead module in cooling mode"
    annotation (Placement(transformation(extent={{80,-148},{100,-128}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaHea
    "True if heating mode enabled"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaCoo
    "True if cooling mode enabled"
    annotation (Placement(transformation(extent={{-170,160},{-150,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisCooAndShc
    "True if disabled OR cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-70,160},{-50,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHeaOrShc
    "True if heating or SHC mode enabled"
    annotation (Placement(transformation(extent={{-140,190},{-120,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaCooOrShc
    "True if cooling or SHC mode enabled"
    annotation (Placement(transformation(extent={{-140,160},{-120,180}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCooAndShc
    "True if both cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-108,160},{-88,180}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisHeaAndShc
    "True if disabled OR heating and SHC disabled"
    annotation (Placement(transformation(extent={{-70,190},{-50,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not disHeaAndShc
    "True if both heating and SHC disabled"
    annotation (Placement(transformation(extent={{-108,190},{-88,210}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaHea
    "Enable lead module in heating mode"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Templates.Plants.Controls.Utilities.StageIndex nHea(
    have_inpAva=true,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in heating mode"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numUni(final k=nUni)
    "Number of modules"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));
  Templates.Plants.Controls.Utilities.StageIndex numCoo(
    have_inpAva=true,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in cooling mode"
    annotation (Placement(transformation(extent={{120,-110},{140,-90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nUniTot(nin=3)
    "Total number of modules running (in any mode)"
    annotation (Placement(transformation(extent={{200,-250},{180,-230}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold noUniAva(final t=
        nUni) "True if no more module is available"
    annotation (Placement(transformation(extent={{30,-262},{10,-242}})));
  Buildings.Controls.OBC.CDL.Logical.Or  upShc "SHC stage up condition"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  StageChangeCondition chaStaShc(
    final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity.Heating,
    final SPLR=SPLR,
    final dtMea=dtMea)
    "SHC stage change conditions based on heating load"
    annotation (Placement(transformation(extent={{-190,90},{-170,110}})));
  StageChangeCondition chaStaShcCoo(
    final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity.Cooling,
    final SPLR=SPLR,
    final dtMea=dtMea)
    "SHC stage change conditions based on cooling load"
    annotation (Placement(transformation(extent={{-190,10},{-170,30}})));
  StageChangeCondition chaStaHea(
    final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity.Heating,
    final SPLR=SPLR,
    final dtMea=dtMea)             "Heating stage change conditions"
    annotation (Placement(transformation(extent={{-190,-70},{-170,-50}})));
  StageChangeCondition chaStaCoo(
    final pol=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.StageChangeCondition.Polarity.Cooling,
    final SPLR=SPLR,
    final dtMea=dtMea)             "Cooling stage change conditions"
    annotation (Placement(transformation(extent={{-190,-190},{-170,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Or dowShc "SHC stage down condition"
    annotation (Placement(transformation(extent={{-132,10},{-112,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooInt_flow_min(final unit=
        "J/s")
    "Capacity at maximum PLR - Cooling mode, single module"
    annotation (Placement(transformation(extent={{-260,-160},{-220,-120}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooShcInt_flow_min(final
      unit="J/s")
    "Cooling capacity at maximum PLR - SHC mode, single module"
    annotation (Placement(transformation(extent={{-260,-240},{-220,-200}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaShcInt_flow_max(final
      unit="J/s")
    "Heating capacity at maximum PLR - SHC mode, single module"
    annotation (Placement(transformation(extent={{-260,-200},{-220,-160}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaSet_flow(final unit="J/s")
    "Heating load - All modules"
    annotation (Placement(transformation(extent={{-260,80},{-220,120}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooSet_flow(final unit="J/s")
    "Cooling load - All modules"
    annotation (Placement(transformation(extent={{-260,40},{-220,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaInt_flow_max(final unit=
        "J/s")
    "Capacity at maximum PLR - Heating mode, single module"
  annotation (Placement(transformation(extent={{-260,-80},{-220,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpShcTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaSetRes_flow(final unit=
        "J/s") "Residual heating load - All modules except those in SHC mode"
    annotation (Placement(transformation(extent={{-260,0},{-220,40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooSetRes_flow(final unit=
        "J/s") "Residual cooling load - All modules except those in SHC mode"
    annotation (Placement(transformation(extent={{-260,-20},{-220,20}}),
        iconTransformation(extent={{-140,-38},{-100,2}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaShcHea(nin=2)
    "Swap module from SHC to heating mode"
    annotation (Placement(transformation(extent={{-88,-70},{-68,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greRatQHea(h=deltaX)
    annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  Buildings.Controls.OBC.CDL.Logical.Or       swaShcHea1
    "Swap module from SHC to heating mode"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpHeaTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaShcCoo(nin=2)
    "Swap module from SHC to cooling mode"
    annotation (Placement(transformation(extent={{-90,-190},{-70,-170}})));
  Buildings.Controls.OBC.CDL.Logical.Or       swaShcHea3
    "Swap module from SHC to heating mode"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpCooTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaCooShc(nin=4)
    "Swap module from cooling to SHC mode"
    annotation (Placement(transformation(extent={{-80,-230},{-60,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Or dowCooOrSwa
    annotation (Placement(transformation(extent={{-10,-210},{10,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowCooTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowHeaTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd swaHeaShc(nin=3)
    "Swap module from heating to SHC mode"
    annotation (Placement(transformation(extent={{-88,-110},{-68,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or dowHeaOrSwa
    annotation (Placement(transformation(extent={{-42,-98},{-22,-78}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowShcTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaShc[nUni]
    "True if module available for SHC"
    annotation (Placement(transformation(extent={{170,70},{150,90}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaHea[nUni]
    "True if module available for heating"
    annotation (Placement(transformation(extent={{180,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniCoo(k={1,-1,-1,1}, nin=4)
    "Return nUni - nUniHea - nUniShc"
    annotation (Placement(transformation(extent={{160,-90},{180,-70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{206,30},{186,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep1(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{184,-26},{204,-6}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniHea(k={1,-1,-1,1}, nin=4)
    "Return nUni - nUniCoo - nUniShc"
    annotation (Placement(transformation(extent={{160,-26},{180,-6}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual avaCoo[nUni]
    "True if module available for cooling"
    annotation (Placement(transformation(extent={{180,-130},{160,-110}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniShc(k={1,-1,-1}, nin=3)
    "Return nUni - nUniHea - nUniCoo"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep2(final nout=
        nUni) "Replicate number of units commanded in given mode"
    annotation (Placement(transformation(extent={{184,-90},{204,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxUni[nUni](k={i for i in
            1:nUni}) "Module index"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold notUpShc(t=4/5*dtRun, h=dtRun/
        10) "SHC stage up condition not met"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And upHea "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And upCoo "Cooling stage up condition met"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{150,-190},{170,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cst[2](k={1,0})
    "Constant"
    annotation (Placement(transformation(extent={{80,-194},{100,-174}})));
  Buildings.Controls.OBC.CDL.Logical.And dowCooOrSwa1
    annotation (Placement(transformation(extent={{86,-234},{106,-214}})));
  Buildings.Controls.OBC.CDL.Logical.And dowCooOrSwa2
    annotation (Placement(transformation(extent={{72,-114},{92,-94}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{122,-62},{142,-42}})));
  Buildings.Controls.OBC.CDL.Logical.Not greRatQCoo
    annotation (Placement(transformation(extent={{-18,-136},{-38,-116}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=-1)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QHeaUnm_flow(final unit="J/s")
    "Unmet heating load - All modules" annotation (Placement(transformation(
          extent={{-298,-40},{-258,0}}), iconTransformation(extent={{-140,-152},
            {-100,-112}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QCooUnm_flow(final unit="J/s")
    "Unmet cooling load - All modules" annotation (Placement(transformation(
          extent={{-298,-60},{-258,-20}}), iconTransformation(extent={{-140,
            -172},{-100,-132}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(k=0.1)
    annotation (Placement(transformation(extent={{-188,-114},{-168,-94}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greRatQHea1(h=deltaX)
    annotation (Placement(transformation(extent={{-160,-106},{-140,-86}})));
  Buildings.Controls.OBC.CDL.Logical.And upShc1
                                               "SHC stage up condition"
    annotation (Placement(transformation(extent={{-158,94},{-138,114}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai2(k=0.1)
    annotation (Placement(transformation(extent={{-188,-150},{-168,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Less les(h=deltaX)
    annotation (Placement(transformation(extent={{-160,-142},{-140,-122}})));
  Buildings.Controls.OBC.CDL.Logical.And upHea1
    "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-130,-106},{-110,-86}})));
  Buildings.Controls.OBC.CDL.Logical.And upShc3
                                               "SHC stage up condition"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not greRatQCoo1
    annotation (Placement(transformation(extent={{-96,48},{-76,68}})));
  Buildings.Controls.OBC.CDL.Logical.And upHea2
    "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-128,-142},{-108,-122}})));
  Buildings.Controls.OBC.CDL.Logical.Or upHea3 "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-88,-134},{-68,-114}})));
  Buildings.Controls.OBC.CDL.Logical.Pre upHea4
    "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-130,-22},{-110,-2}})));
  Buildings.Controls.OBC.CDL.Logical.Pre upHea5
    "Heating stage up condition met"
    annotation (Placement(transformation(extent={{-124,-202},{-104,-182}})));
equation
  connect(on, off.u)
    annotation (Line(points={{-240,240},{-212,240}}, color={255,0,255}));
  connect(off.y, offOrDisShc.u1) annotation (Line(points={{-188,240},{-114,240},
          {-114,140},{-72,140}},color={255,0,255}));
  connect(mode, enaShc.u2) annotation (Line(points={{-240,180},{-200,180},{-200,
          132},{-172,132}},
                          color={255,127,0}));
  connect(idxMod[3].y, enaShc.u1) annotation (Line(points={{-188,200},{-184,200},
          {-184,140},{-172,140}}, color={255,127,0}));
  connect(enaShc.y, disShc.u)
    annotation (Line(points={{-148,140},{-142,140}}, color={255,0,255}));
  connect(disShc.y, offOrDisShc.u2) annotation (Line(points={{-118,140},{-116,140},
          {-116,132},{-72,132}},
                              color={255,0,255}));
  connect(offOrDisShc.y, enaLeaShc.clr) annotation (Line(points={{-48,140},{0,140},
          {0,94},{58,94}},       color={255,0,255}));
  connect(enaLeaShc.y, nShc.u1Lea) annotation (Line(points={{82,100},{98,100},{
          98,106},{118,106}},color={255,0,255}));
  connect(nShc.y, nUniShc)
    annotation (Line(points={{142,100},{240,100}},color={255,127,0}));
  connect(idxMod[1].y, enaHea.u1)
    annotation (Line(points={{-188,200},{-172,200}}, color={255,127,0}));
  connect(mode, enaCoo.u2) annotation (Line(points={{-240,180},{-200,180},{-200,
          162},{-172,162}}, color={255,127,0}));
  connect(idxMod[2].y, enaCoo.u1) annotation (Line(points={{-188,200},{-184,200},
          {-184,170},{-172,170}}, color={255,127,0}));
  connect(mode, enaHea.u2) annotation (Line(points={{-240,180},{-176,180},{-176,
          192},{-172,192}}, color={255,127,0}));
  connect(enaHea.y, enaHeaOrShc.u1)
    annotation (Line(points={{-148,200},{-142,200}}, color={255,0,255}));
  connect(enaShc.y, enaHeaOrShc.u2) annotation (Line(points={{-148,140},{-146,140},
          {-146,192},{-142,192}},      color={255,0,255}));
  connect(enaCoo.y, enaCooOrShc.u1)
    annotation (Line(points={{-148,170},{-142,170}}, color={255,0,255}));
  connect(enaShc.y, enaCooOrShc.u2) annotation (Line(points={{-148,140},{-146,140},
          {-146,162},{-142,162}},      color={255,0,255}));
  connect(enaCooOrShc.y, disCooAndShc.u)
    annotation (Line(points={{-118,170},{-110,170}},
                                                   color={255,0,255}));
  connect(disCooAndShc.y, offOrDisCooAndShc.u2) annotation (Line(points={{-86,170},
          {-84,170},{-84,162},{-72,162}},      color={255,0,255}));
  connect(enaHeaOrShc.y, disHeaAndShc.u)
    annotation (Line(points={{-118,200},{-110,200}},
                                                   color={255,0,255}));
  connect(disHeaAndShc.y, offOrDisHeaAndShc.u2) annotation (Line(points={{-86,200},
          {-84,200},{-84,192},{-72,192}},      color={255,0,255}));
  connect(off.y, offOrDisHeaAndShc.u1) annotation (Line(points={{-188,240},{-80,
          240},{-80,200},{-72,200}}, color={255,0,255}));
  connect(enaLeaHea.y, nHea.u1Lea) annotation (Line(points={{102,-20},{108,-20},
          {108,6},{118,6}},
                        color={255,0,255}));
  connect(enaLeaCoo.y, numCoo.u1Lea)
    annotation (Line(points={{102,-138},{108,-138},{108,-94},{118,-94}},
                                                           color={255,0,255}));
  connect(offOrDisHeaAndShc.y, enaLeaHea.clr) annotation (Line(points={{-48,200},
          {6,200},{6,-26},{78,-26}},
                                  color={255,0,255}));
  connect(offOrDisCooAndShc.y, enaLeaCoo.clr) annotation (Line(points={{-48,170},
          {2,170},{2,-144},{78,-144}},
                                  color={255,0,255}));
  connect(off.y, offOrDisCooAndShc.u1) annotation (Line(points={{-188,240},{-80,
          240},{-80,170},{-72,170}}, color={255,0,255}));
  connect(nUniTot.y, noUniAva.u)
    annotation (Line(points={{178,-240},{160,-240},{160,-252},{32,-252}},
                                                     color={255,127,0}));
  connect(QHeaSet_flow,chaStaShc. QSet_flow) annotation (Line(points={{-240,100},
          {-210,100},{-210,106},{-192,106}},
                                          color={0,0,127}));
  connect(QCooSet_flow,chaStaShcCoo. QSet_flow) annotation (Line(points={{-240,60},
          {-212,60},{-212,26},{-192,26}},   color={0,0,127}));
  connect(QCooShcInt_flow_min,chaStaShcCoo. Q_flow) annotation (Line(points={{-240,
          -220},{-206,-220},{-206,20},{-192,20}},    color={0,0,127}));
  connect(chaStaShc.y1Dow,dowShc. u1) annotation (Line(points={{-168,94},{-160,94},
          {-160,20},{-134,20}},   color={255,0,255}));
  connect(chaStaShcCoo.y1Dow,dowShc. u2) annotation (Line(points={{-168,14},{-160,
          14},{-160,12},{-134,12}},      color={255,0,255}));
  connect(upShc.y,y1UpShcTim. u)
    annotation (Line(points={{-108,100},{20,100},{20,60},{38,60}},
                                                 color={255,0,255}));
  connect(QHeaSetRes_flow, chaStaHea.QSet_flow) annotation (Line(points={{-240,20},
          {-214,20},{-214,-54},{-192,-54}},     color={0,0,127}));
  connect(QCooSetRes_flow, chaStaCoo.QSet_flow) annotation (Line(points={{-240,0},
          {-216,0},{-216,-174},{-192,-174}},    color={0,0,127}));
  connect(swaShcHea.y, swaShcHea1.u2) annotation (Line(points={{-66,-60},{-60,
          -60},{-60,-48},{-52,-48}},
                                color={255,0,255}));
  connect(swaShcHea1.y, y1UpHeaTim.u)
    annotation (Line(points={{-28,-40},{38,-40}}, color={255,0,255}));
  connect(y1UpHeaTim.passed, nHea.u1Up) annotation (Line(points={{62,-48},{110,-48},
          {110,2},{118,2}}, color={255,0,255}));
  connect(QHeaInt_flow_max, chaStaHea.Q_flow)
    annotation (Line(points={{-240,-60},{-192,-60}}, color={0,0,127}));
  connect(QCooInt_flow_min, chaStaCoo.Q_flow) annotation (Line(points={{-240,-140},
          {-204,-140},{-204,-180},{-192,-180}}, color={0,0,127}));
  connect(QHeaShcInt_flow_max, chaStaShc.Q_flow) annotation (Line(points={{-240,
          -180},{-208,-180},{-208,100},{-192,100}}, color={0,0,127}));
  connect(swaShcCoo.y, swaShcHea3.u2) annotation (Line(points={{-68,-180},{-60,-180},
          {-60,-168},{-52,-168}}, color={255,0,255}));
  connect(swaShcHea3.y, y1UpCooTim.u)
    annotation (Line(points={{-28,-160},{38,-160}}, color={255,0,255}));
  connect(y1UpCooTim.passed, numCoo.u1Up) annotation (Line(points={{62,-168},{112,
          -168},{112,-98},{118,-98}}, color={255,0,255}));
  connect(y1UpShcTim.passed, nShc.u1Up) annotation (Line(points={{62,52},{100,
          52},{100,102},{118,102}},
                                color={255,0,255}));
  connect(nUniShc, chaStaShc.nUni) annotation (Line(points={{240,100},{210,100},
          {210,120},{-200,120},{-200,94},{-192,94}}, color={255,127,0}));
  connect(nUniShc, chaStaShcCoo.nUni) annotation (Line(points={{240,100},{210,100},
          {210,120},{-200,120},{-200,14},{-192,14}}, color={255,127,0}));
  connect(noUniAva.y, swaCooShc.u[1]) annotation (Line(points={{8,-252},{8,-256},
          {-82,-256},{-82,-222.625}},            color={255,0,255}));
  connect(chaStaCoo.y1Dow, dowCooOrSwa.u1) annotation (Line(points={{-168,-186},
          {-140,-186},{-140,-200},{-12,-200}}, color={255,0,255}));
  connect(swaCooShc.y, dowCooOrSwa.u2) annotation (Line(points={{-58,-220},{-20,
          -220},{-20,-208},{-12,-208}}, color={255,0,255}));
  connect(dowCooOrSwa.y, y1DowCooTim.u)
    annotation (Line(points={{12,-200},{38,-200}}, color={255,0,255}));
  connect(y1DowCooTim.passed, numCoo.u1Dow) annotation (Line(points={{62,-208},{
          114,-208},{114,-102},{118,-102}}, color={255,0,255}));
  connect(noUniAva.y, swaCooShc.u[2]) annotation (Line(points={{8,-252},{8,-256},
          {-100,-256},{-100,-220.875},{-82,-220.875}},          color={255,0,255}));
  connect(noUniAva.y, swaHeaShc.u[1]) annotation (Line(points={{8,-252},{-110,
          -252},{-110,-102.333},{-90,-102.333}}, color={255,0,255}));
  connect(swaHeaShc.y, dowHeaOrSwa.u2) annotation (Line(points={{-66,-100},{-60,
          -100},{-60,-96},{-44,-96}},   color={255,0,255}));
  connect(chaStaHea.y1Dow, dowHeaOrSwa.u1) annotation (Line(points={{-168,-66},
          {-168,-76},{-52,-76},{-52,-88},{-44,-88}},             color={255,0,255}));
  connect(dowHeaOrSwa.y, y1DowHeaTim.u) annotation (Line(points={{-20,-88},{20,
          -88},{20,-80},{38,-80}},  color={255,0,255}));
  connect(y1DowHeaTim.passed, nHea.u1Dow) annotation (Line(points={{62,-88},{112,
          -88},{112,-2},{118,-2}}, color={255,0,255}));
  connect(y1DowShcTim.passed, nShc.u1Dow) annotation (Line(points={{62,12},{104,
          12},{104,98},{118,98}}, color={255,0,255}));
  connect(nUniHea, chaStaHea.nUni) annotation (Line(points={{240,0},{230,0},{
          230,-66},{-192,-66}},
                            color={255,127,0}));
  connect(upShc.y, enaLeaShc.u)
    annotation (Line(points={{-108,100},{58,100}}, color={255,0,255}));
  connect(numUni.y, remUniShc.u[1]) annotation (Line(points={{142,60},{152,60},
          {152,37.6667},{158,37.6667}}, color={255,127,0}));
  connect(nHea.y, remUniShc.u[2]) annotation (Line(points={{142,0},{152,0},{152,
          40},{158,40}}, color={255,127,0}));
  connect(idxUni.y, avaShc.u1) annotation (Line(points={{142,140},{180,140},{
          180,80},{172,80}}, color={255,127,0}));
  connect(remUniShc.y, rep.u)
    annotation (Line(points={{182,40},{208,40}}, color={255,127,0}));
  connect(numCoo.y, remUniShc.u[3]) annotation (Line(points={{142,-100},{154,
          -100},{154,42.3333},{158,42.3333}}, color={255,127,0}));
  connect(rep.y, avaShc.u2) annotation (Line(points={{184,40},{208,40},{208,72},
          {172,72}}, color={255,127,0}));
  connect(avaShc.y, nShc.u1AvaSta) annotation (Line(points={{148,80},{108,80},{
          108,94},{118,94}}, color={255,0,255}));
  connect(numUni.y, remUniHea.u[1]) annotation (Line(points={{142,60},{150,60},
          {150,-18.625},{158,-18.625}}, color={255,127,0}));
  connect(nShc.y, remUniHea.u[2]) annotation (Line(points={{142,100},{150,100},
          {150,-16.875},{158,-16.875}}, color={255,127,0}));
  connect(numCoo.y, remUniHea.u[3]) annotation (Line(points={{142,-100},{154,
          -100},{154,0},{158,0},{158,-15.125}}, color={255,127,0}));
  connect(remUniHea.y, rep1.u)
    annotation (Line(points={{182,-16},{182,-16}}, color={255,127,0}));
  connect(rep1.y, avaHea.u2) annotation (Line(points={{206,-16},{208,-16},{208,
          -48},{182,-48}}, color={255,127,0}));
  connect(avaHea.y, nHea.u1AvaSta) annotation (Line(points={{158,-40},{114,-40},
          {114,-6},{118,-6}}, color={255,0,255}));
  connect(avaCoo.y, numCoo.u1AvaSta) annotation (Line(points={{158,-120},{116,
          -120},{116,-106},{118,-106}}, color={255,0,255}));
  connect(numUni.y, remUniCoo.u[1]) annotation (Line(points={{142,60},{152,60},
          {152,-82.625},{158,-82.625}}, color={255,127,0}));
  connect(nShc.y, remUniCoo.u[2]) annotation (Line(points={{142,100},{150,100},
          {150,-80.875},{158,-80.875}}, color={255,127,0}));
  connect(nHea.y, remUniCoo.u[3]) annotation (Line(points={{142,0},{150,0},{150,
          -79.125},{158,-79.125}}, color={255,127,0}));
  connect(remUniCoo.y, rep2.u)
    annotation (Line(points={{182,-80},{182,-80}}, color={255,127,0}));
  connect(rep2.y, avaCoo.u2) annotation (Line(points={{206,-80},{206,-128},{182,
          -128}}, color={255,127,0}));
  connect(idxUni.y, avaHea.u1) annotation (Line(points={{142,140},{206,140},{
          206,-40},{182,-40}}, color={255,127,0}));
  connect(idxUni.y, avaCoo.u1) annotation (Line(points={{142,140},{208,140},{
          208,-120},{182,-120}}, color={255,127,0}));
  connect(nUniShc, nUniTot.u[1]) annotation (Line(points={{240,100},{262,100},{
          262,-242.333},{202,-242.333}}, color={255,127,0}));
  connect(nUniHea, nUniTot.u[2]) annotation (Line(points={{240,0},{256,0},{256,
          -240},{202,-240}}, color={255,127,0}));
  connect(nUniCoo, nUniTot.u[3]) annotation (Line(points={{240,-100},{252,-100},
          {252,-237.667},{202,-237.667}}, color={255,127,0}));
  connect(numCoo.y, nUniCoo)
    annotation (Line(points={{142,-100},{240,-100}}, color={255,127,0}));
  connect(nHea.y, nUniHea)
    annotation (Line(points={{142,0},{240,0}}, color={255,127,0}));
  connect(nUniCoo, chaStaCoo.nUni) annotation (Line(points={{240,-100},{244,
          -100},{244,-156},{-200,-156},{-200,-186},{-192,-186}}, color={255,127,
          0}));
  connect(notUpShc.y, upHea.u1) annotation (Line(points={{-158,-20},{-150,-20},
          {-150,-40},{-142,-40}}, color={255,0,255}));
  connect(upHea.y, swaShcHea1.u1) annotation (Line(points={{-118,-40},{-86,-40},
          {-86,-40},{-52,-40}}, color={255,0,255}));
  connect(chaStaHea.y1Up, upHea.u2) annotation (Line(points={{-168,-54},{-160,
          -54},{-160,-48},{-142,-48}}, color={255,0,255}));
  connect(upHea.y, enaLeaHea.u) annotation (Line(points={{-118,-40},{-80,-40},{
          -80,-20},{78,-20},{78,-20}}, color={255,0,255}));
  connect(upCoo.y, swaShcHea3.u1)
    annotation (Line(points={{-118,-160},{-52,-160}}, color={255,0,255}));
  connect(chaStaCoo.y1Up, upCoo.u2) annotation (Line(points={{-168,-174},{-160,
          -174},{-160,-168},{-142,-168}}, color={255,0,255}));
  connect(notUpShc.y, upCoo.u1) annotation (Line(points={{-158,-20},{-150,-20},
          {-150,-160},{-142,-160}}, color={255,0,255}));
  connect(upCoo.y, enaLeaCoo.u) annotation (Line(points={{-118,-160},{-114,-160},
          {-114,-138},{78,-138}}, color={255,0,255}));
  connect(y1DowShcTim.passed, swaShcHea.u[1]) annotation (Line(points={{62,12},
          {66,12},{66,-14},{-94,-14},{-94,-61.75},{-90,-61.75}}, color={255,0,
          255}));
  connect(y1DowCooTim.passed, dowCooOrSwa1.u1) annotation (Line(points={{62,
          -208},{72,-208},{72,-224},{84,-224}}, color={255,0,255}));
  connect(swaCooShc.y, dowCooOrSwa1.u2) annotation (Line(points={{-58,-220},{
          -20,-220},{-20,-232},{84,-232}}, color={255,0,255}));
  connect(dowCooOrSwa1.y, intSwi.u2) annotation (Line(points={{108,-224},{128,
          -224},{128,-180},{148,-180}}, color={255,0,255}));
  connect(cst[1].y, intSwi.u1) annotation (Line(points={{102,-184},{124,-184},{
          124,-172},{148,-172}}, color={255,127,0}));
  connect(cst[2].y, intSwi.u3) annotation (Line(points={{102,-184},{124,-184},{
          124,-188},{148,-188}}, color={255,127,0}));
  connect(intSwi.y, remUniCoo.u[4]) annotation (Line(points={{172,-180},{166,
          -180},{166,-77.375},{158,-77.375}}, color={255,127,0}));
  connect(upShc.y, swaCooShc.u[3]) annotation (Line(points={{-108,100},{-100,
          100},{-100,-219.125},{-82,-219.125}}, color={255,0,255}));
  connect(upShc.y, swaHeaShc.u[2]) annotation (Line(points={{-108,100},{-100,
          100},{-100,-100},{-90,-100}}, color={255,0,255}));
  connect(y1DowHeaTim.passed, dowCooOrSwa2.u1) annotation (Line(points={{62,-88},
          {66,-88},{66,-104},{70,-104}}, color={255,0,255}));
  connect(swaHeaShc.y, dowCooOrSwa2.u2) annotation (Line(points={{-66,-100},{
          -63,-100},{-63,-112},{70,-112}}, color={255,0,255}));
  connect(cst[1].y, intSwi1.u1) annotation (Line(points={{102,-184},{116,-184},
          {116,-44},{120,-44}}, color={255,127,0}));
  connect(cst[2].y, intSwi1.u3) annotation (Line(points={{102,-184},{114,-184},
          {114,-60},{120,-60}}, color={255,127,0}));
  connect(dowCooOrSwa2.y, intSwi1.u2) annotation (Line(points={{94,-104},{108,
          -104},{108,-52},{120,-52}}, color={255,0,255}));
  connect(intSwi1.y, remUniHea.u[4]) annotation (Line(points={{144,-52},{152,
          -52},{152,-13.375},{158,-13.375}}, color={255,127,0}));
  connect(y1DowShcTim.passed, swaShcCoo.u[1]) annotation (Line(points={{62,12},
          {66,12},{66,-14},{-94,-14},{-94,-181.75},{-92,-181.75}}, color={255,0,
          255}));
  connect(greRatQHea.y, greRatQCoo.u) annotation (Line(points={{-12,50},{-8,50},
          {-8,-126},{-16,-126}}, color={255,0,255}));
  connect(greRatQHea.y, swaCooShc.u[4]) annotation (Line(points={{-12,50},{-6,
          50},{-6,-217.375},{-82,-217.375}}, color={255,0,255}));
  connect(greRatQCoo.y, swaHeaShc.u[3]) annotation (Line(points={{-40,-126},{
          -94,-126},{-94,-97.6667},{-90,-97.6667}}, color={255,0,255}));
  connect(gai.y, greRatQHea.u2)
    annotation (Line(points={{-34,0},{-34,42},{-36,42}}, color={0,0,127}));
  connect(QCooUnm_flow, gai.u) annotation (Line(points={{-278,-40},{-166,-40},{
          -166,0},{-58,0}}, color={0,0,127}));
  connect(QHeaUnm_flow, greRatQHea.u1) annotation (Line(points={{-278,-20},{
          -158,-20},{-158,50},{-36,50}}, color={0,0,127}));
  connect(QHeaInt_flow_max, gai1.u) annotation (Line(points={{-240,-60},{-200,
          -60},{-200,-104},{-190,-104}}, color={0,0,127}));
  connect(gai1.y, greRatQHea1.u2)
    annotation (Line(points={{-166,-104},{-162,-104}}, color={0,0,127}));
  connect(QHeaUnm_flow, greRatQHea1.u1) annotation (Line(points={{-278,-20},{
          -212,-20},{-212,-96},{-162,-96}}, color={0,0,127}));
  connect(upShc.u1, upShc1.y) annotation (Line(points={{-132,100},{-134,100},{
          -134,104},{-136,104}}, color={255,0,255}));
  connect(chaStaShc.y1Up, upShc1.u1) annotation (Line(points={{-168,106},{-164,
          106},{-164,104},{-160,104}}, color={255,0,255}));
  connect(chaStaShcCoo.y1Up, upShc1.u2) annotation (Line(points={{-168,26},{
          -164,26},{-164,96},{-160,96}}, color={255,0,255}));
  connect(QCooInt_flow_min, gai2.u)
    annotation (Line(points={{-240,-140},{-190,-140}}, color={0,0,127}));
  connect(gai2.y, les.u2)
    annotation (Line(points={{-166,-140},{-162,-140}}, color={0,0,127}));
  connect(QCooUnm_flow, les.u1) annotation (Line(points={{-278,-40},{-264,-40},
          {-264,-120},{-162,-120},{-162,-132}}, color={0,0,127}));
  connect(greRatQHea1.y, upHea1.u1)
    annotation (Line(points={{-138,-96},{-132,-96}}, color={255,0,255}));
  connect(dowShc.y, upShc3.u2) annotation (Line(points={{-110,20},{-102,20},{
          -102,12},{-82,12}}, color={255,0,255}));
  connect(upShc3.y, y1DowShcTim.u)
    annotation (Line(points={{-58,20},{38,20}}, color={255,0,255}));
  connect(greRatQCoo1.y, upShc3.u1) annotation (Line(points={{-74,58},{-78,58},
          {-78,20},{-82,20}}, color={255,0,255}));
  connect(noUniAva.y, upHea1.u2) annotation (Line(points={{8,-252},{-132,-252},
          {-132,-104}}, color={255,0,255}));
  connect(les.y, upHea2.u1)
    annotation (Line(points={{-138,-132},{-130,-132}}, color={255,0,255}));
  connect(noUniAva.y, upHea2.u2) annotation (Line(points={{8,-252},{-130,-252},
          {-130,-140}}, color={255,0,255}));
  connect(upHea1.y, upHea3.u1) annotation (Line(points={{-108,-96},{-100,-96},{
          -100,-124},{-90,-124}}, color={255,0,255}));
  connect(upHea2.y, upHea3.u2)
    annotation (Line(points={{-106,-132},{-90,-132}}, color={255,0,255}));
  connect(upHea3.y, upShc.u2) annotation (Line(points={{-66,-124},{-98,-124},{
          -98,92},{-132,92}}, color={255,0,255}));
  connect(upHea3.y, greRatQCoo1.u) annotation (Line(points={{-66,-124},{-82,
          -124},{-82,58},{-98,58}}, color={255,0,255}));
  connect(y1UpShcTim.y, notUpShc.u) annotation (Line(points={{62,60},{80,60},{
          80,34},{-190,34},{-190,-20},{-182,-20}}, color={0,0,127}));
  connect(chaStaShcCoo.y1Dow, upHea4.u) annotation (Line(points={{-168,14},{
          -150,14},{-150,-12},{-132,-12}}, color={255,0,255}));
  connect(upHea4.y, swaShcHea.u[2]) annotation (Line(points={{-108,-12},{-102,
          -12},{-102,-60},{-90,-60},{-90,-58.25}}, color={255,0,255}));
  connect(upHea5.y, swaShcCoo.u[2]) annotation (Line(points={{-102,-192},{-98,
          -192},{-98,-178.25},{-92,-178.25}}, color={255,0,255}));
  connect(chaStaShc.y1Dow, upHea5.u) annotation (Line(points={{-168,94},{-160,
          94},{-160,-192},{-126,-192}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}},
        grid={2,2}),                                            graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -260},{220,260}})));
end ControllerSHC;
