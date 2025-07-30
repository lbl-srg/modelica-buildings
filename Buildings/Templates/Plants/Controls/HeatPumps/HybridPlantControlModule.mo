within Buildings.Templates.Plants.Controls.HeatPumps;
block HybridPlantControlModule
  "Controller for additional calculations required for hybrid plant with modular 2-pipe ASHPs and 4-pipe ASHP"
  parameter Boolean have_heaWat
    "Set to true for plants that provide HW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));
  parameter Boolean has_sort=true;
  parameter Boolean have_chiWat
    "Set to true for plants that provide CHW"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Integer nHp(min=1)
    "Number of heat pumps"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Boolean is_fouPip[nHp]=fill(false,nHp)
    "Vector indicating if each HP is a 4-pipe ASHP; True=Is 4-pipe ASHP;False=Not 4-pipe ASHP"
    annotation (Evaluate=true,
    Dialog(group="Plant configuration"));

  parameter Real staEquCooHea[:, nHp](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-cooling mode – Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  parameter Real staEquOneMod[:, nHp](
    each final max=1,
    each final min=0,
    each final unit="1")
    "Staging matrix for heating-only and cooling-only mode– Equipment required for each stage"
    annotation (Dialog(group="Equipment staging and rotation"));

  final parameter Integer nSta(
    final min=1)=size(staEquCooHea, 1)
    "Number of stages"
    annotation (Evaluate=true);

  final parameter Integer nEquAlt(
    final min=0)=if nHp==1 then 1 else
    max({sum({(if staEquCooHea[i, j] > 0 and staEquCooHea[i, j] < 1 then 1 else 0) for j in 1:nHp}) for i in 1:nSta})
    "Number of lead/lag alternate equipment"
    annotation (Evaluate=true);

  parameter Integer idxEquAlt[nEquAlt](final min=fill(1, nEquAlt))
    "Indices of lead/lag alternate equipment"
    annotation (Evaluate=true,
    Dialog(group="Equipment staging and rotation"));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[nSta,nHp](k=
        staEquCooHea) "Staging matrix for heating-cooling mode"
    annotation (Placement(transformation(extent={{-10,-240},{10,-220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1[nSta,nHp](k=
        staEquOneMod) "Staging matrix for heating-only and cooling-only mode"
    annotation (Placement(transformation(extent={{-10,-300},{10,-280}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nSta,nHp]
    "Switch between staging matrices for heating-cooling mode, and the staging matrix for other modes"
    annotation (Placement(transformation(extent={{28,-270},{48,-250}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if both heating plant and cooling plant are enabled"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=nHp)
    "Generate vector with size equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-50,-270},{-30,-250}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanVectorReplicator booVecRep(nin=nHp,
      nout=nSta) "Change into matrix with same dimensions as staging matrix"
    annotation (Placement(transformation(extent={{-10,-270},{10,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nHp](
    integerTrue=fill(Buildings.Controls.OBC.CDL.Types.OperationModes.Heating,nHp),
    integerFalse=fill(Buildings.Controls.OBC.CDL.Types.OperationModes.Cooling,nHp))
    "Convert binary mode signal to Integer mode signals"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi[nHp]
    "Output mode for 2-pipe and 4-pipe ASHPs"
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant isFouPip[nHp](k=is_fouPip)
    "Is the heat pump a 4-pipe ASHP?"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    "Output Integer signal 1 when both heating plant and cooling plant are enabled"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt
    "Output mode signal only when heating-cooling mode is enabled"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=Buildings.Controls.OBC.CDL.Types.OperationModes.HeatingCooling)
    "Constant Integer signal representing heating-cooling mode"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if not in heating-cooling mode"
    annotation (Placement(transformation(extent={{-114,-160},{-94,-140}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    "Output Integer 1 when not in heating-cooling mode"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply mulInt1
    "Output heating-only mode signal or cooling-only mode signal when not in heating-cooling mode"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}})));
  Buildings.Controls.OBC.CDL.Integers.Add addInt "Output non-zero mode signal"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nHp)
    "Vectorize mode signal with dimension equal to number of heat pumps"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1[nEquAlt] if not has_sort
    "Switch between two staging orders when runtime sorting is not used"
    annotation (Placement(transformation(extent={{30,-370},{50,-350}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nEquAlt](k={i
        for i in 1:nEquAlt}) if not has_sort
    "Sort components in direct order when runtime sorting is not used"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2[nEquAlt](k={i
        for i in nEquAlt:-1:1}) if not has_sort
    "Sort components in reverse order when runtime sorting is not used"
    annotation (Placement(transformation(extent={{-10,-350},{10,-330}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=
        nEquAlt) if not has_sort
    "Generate vector with size equal to list of lead-lag equipment"
    annotation (Placement(transformation(extent={{-50,-370},{-30,-350}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant heaModSig[nHp](k=fill(true,
        nHp)) if have_heaWat and not have_chiWat "Constant heating mode signal"
    annotation (Placement(transformation(extent={{-140,-210},{-120,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cooModSig[nHp](k=fill(false,
        nHp)) if not have_heaWat and have_chiWat
    "Constant cooling mode signal"
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaHea
                                       "Heating plant enable"
    annotation (Placement(transformation(extent={{-298,-10},{-258,30}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1EnaCoo
                                       "Cooling plant enable"
    annotation (Placement(transformation(extent={{-300,-70},{-260,-30}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{190,60},{210,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nHp]
    "Check for HPs in heating-only mode"
    annotation (Placement(transformation(extent={{-120,220},{-100,240}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{20,220},{40,240}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3[nHp]
    "Check for HPs in heating-only and heating-cooling mode"
    annotation (Placement(transformation(extent={{-60,220},{-40,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1[nHp]
    "Check for HPs in heating-cooling mode"
    annotation (Placement(transformation(extent={{100,300},{120,320}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2[nHp]
    "Check for HPs in cooling-only mode"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4[nHp]
    "Check for HPs in cooling-only mode or heating-cooling mode"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[nHp]
    "Left-limit of command signal to break algebraic loop"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3[nHp](
    k=fill(Buildings.Controls.OBC.CDL.Types.OperationModes.Heating,nHp))
    "Constant Integer signal representing heating mode"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5[nHp](
    k=fill(Buildings.Controls.OBC.CDL.Types.OperationModes.Cooling,nHp))
    "Constant Integer signal representing cooling mode"
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nHp]
    "Check only HPs with heat recovery"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and3[nHp]
    "Check only HPs with heat recovery"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and4[nHp] "Check only enabled HPs"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and5[nHp] "Check only enabled HPs"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat[nHp]
    "Latch that gets enabled when 4-pipe ASHP is in heating-only mode or heating-cooling mode"
    annotation (Placement(transformation(extent={{170,210},{190,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[nHp]
    "4-pipe is in cooling-only mode"
    annotation (Placement(transformation(extent={{212,210},{232,230}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg[nHp](
    final pre_u_start=fill(true,nHp))
    "Check when 4-pipe ASHP is disabled"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat1[nHp]
    "Latch that gets enabled when 4-pipe ASHP is in cooling-only mode or heating-cooling mode"
    annotation (Placement(transformation(extent={{170,130},{190,150}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3[nHp]
    "4-pipe is in heating-only mode"
    annotation (Placement(transformation(extent={{212,130},{232,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and6[nHp]
    "Check for heating-only status only in 4-pipe ASHP, and output false for all other HPs"
    annotation (Placement(transformation(extent={{260,130},{280,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and7[nHp]
    "Check for cooling-only status only in 4-pipe ASHP, and output false for all other HPs"
    annotation (Placement(transformation(extent={{260,210},{280,230}})));
  Buildings.Controls.OBC.CDL.Logical.And and8[nHp]
    "Identify heat recovery heat pumps in heating-cooling mode"
    annotation (Placement(transformation(extent={{200,300},{220,320}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5[nHp]
    "Check for primary heat pumps already enabled"
    annotation (Placement(transformation(extent={{120,350},{140,370}})));
  Buildings.Controls.OBC.CDL.Logical.And and9[nHp]
    "Check if primary pump for 4 pipe ASHP is enabled"
    annotation (Placement(transformation(extent={{260,350},{280,370}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep1(nout=nHp)
    "Vectorize mode signal with dimnension equal to number of heat pumps"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yStaEqu[nSta,nHp](
    each unit="1",
    each min=0,
    each max=1) "Staging matrix – Equipment required for each stage"
    annotation (Placement(transformation(extent={{320,-280},{360,-240}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uMod[nHp]
    if have_heaWat and have_chiWat
    "Binary mode signal indicating if 2-pipe HP is in heating mode or cooling mode"
    annotation (Placement(transformation(extent={{-300,-200},{-260,-160}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yMod[nHp]
    "Operation mode integer signal for each HP" annotation (Placement(
        transformation(extent={{320,-110},{360,-70}}), iconTransformation(
          extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaFouPipHea[nHp]
    "Availability vector of four-pipe HPs for heating operation" annotation (
      Placement(transformation(extent={{320,200},{360,240}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yAvaFouPipCoo[nHp]
    "Availability vector of four-pipe HPs for cooling operation" annotation (
      Placement(transformation(extent={{320,120},{360,160}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hp[nHp]
    "HP enable signal vector" annotation (Placement(transformation(extent={{-300,40},
            {-260,80}}),       iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1PumPri[nHp]
    "Primary pump enable for 4-pipe ASHP" annotation (Placement(transformation(
          extent={{320,340},{360,380}}), iconTransformation(extent={{100,100},{140,
            140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriHea[nHp]
    "Primary pump enable for 4-pipe ASHP" annotation (Placement(transformation(
          extent={{-300,320},{-260,360}}), iconTransformation(extent={{-140,-120},
            {-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1PumPriCoo[nHp]
    "Primary pump enable for 4-pipe ASHP" annotation (Placement(transformation(
          extent={{-298,360},{-258,400}}), iconTransformation(extent={{-140,-80},
            {-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaCoo
    "Signal indicating heat pump plant is in heating-cooling mode" annotation (
      Placement(transformation(extent={{320,-40},{360,0}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSta[nEquAlt]
    if not has_sort
    "Staging index if runtime sorting is absent" annotation (Placement(
        transformation(extent={{320,-380},{360,-340}}), iconTransformation(
          extent={{100,-140},{140,-100}})));
equation
  connect(and2.y, booScaRep.u)
    annotation (Line(points={{-198,-20},{-180,-20},{-180,-260},{-52,-260}},
                                                   color={255,0,255}));
  connect(booScaRep.y, booVecRep.u)
    annotation (Line(points={{-28,-260},{-12,-260}},
                                                   color={255,0,255}));
  connect(booVecRep.y, swi.u2)
    annotation (Line(points={{12,-260},{26,-260}},color={255,0,255}));

  connect(con.y, swi.u1) annotation (Line(points={{12,-230},{20,-230},{20,-252},
          {26,-252}},color={0,0,127}));
  connect(con1.y, swi.u3) annotation (Line(points={{12,-290},{20,-290},{20,-268},
          {26,-268}},color={0,0,127}));
  connect(booToInt.y, intSwi.u3)
    annotation (Line(points={{-58,-180},{180,-180},{180,-98},{198,-98}},
                                                   color={255,127,0}));
  connect(isFouPip.y, intSwi.u2) annotation (Line(points={{82,-40},{160,-40},{160,
          -90},{198,-90}}, color={255,0,255}));
  connect(and2.y, booToInt1.u) annotation (Line(points={{-198,-20},{-180,-20},{-180,
          -90},{-62,-90}},                     color={255,0,255}));
  connect(and2.y, not1.u) annotation (Line(points={{-198,-20},{-180,-20},{-180,-150},
          {-116,-150}},                  color={255,0,255}));
  connect(not1.y, booToInt2.u)
    annotation (Line(points={{-92,-150},{-82,-150}},
                                                 color={255,0,255}));
  connect(booToInt2.y, mulInt1.u1)
    annotation (Line(points={{-58,-150},{-40,-150},{-40,-144},{-12,-144}},
                                                          color={255,127,0}));
  connect(booToInt[nHp].y, mulInt1.u2) annotation (Line(points={{-58,-180},{-20,
          -180},{-20,-156},{-12,-156}},          color={255,127,0}));
  connect(addInt.y, intScaRep.u)
    annotation (Line(points={{102,-80},{118,-80}}, color={255,127,0}));
  connect(intScaRep.y, intSwi.u1) annotation (Line(points={{142,-80},{180,-80},{
          180,-82},{198,-82}},                     color={255,127,0}));
  connect(conInt2.y, intSwi1.u1) annotation (Line(points={{12,-340},{12,-352},{28,
          -352}},                 color={255,127,0}));
  connect(conInt1.y, intSwi1.u3) annotation (Line(points={{12,-380},{12,-378},{28,
          -378},{28,-368}},       color={255,127,0}));
  connect(booScaRep1.y, intSwi1.u2)
    annotation (Line(points={{-28,-360},{28,-360}},  color={255,0,255}));
  connect(and2.y, booScaRep1.u) annotation (Line(points={{-198,-20},{-180,-20},{
          -180,-360},{-52,-360}},                 color={255,0,255}));
  connect(heaModSig.y, booToInt.u) annotation (Line(points={{-118,-200},{-100,-200},
          {-100,-180},{-82,-180}},
                                color={255,0,255}));
  connect(cooModSig.y, booToInt.u) annotation (Line(points={{-118,-240},{-100,-240},
          {-100,-180},{-82,-180}},                                      color={
          255,0,255}));
  connect(u1EnaHea, and2.u1) annotation (Line(points={{-278,10},{-232,10},{-232,
          -20},{-222,-20}},
        color={255,0,255}));
  connect(u1EnaCoo, and2.u2) annotation (Line(points={{-280,-50},{-230,-50},{-230,
          -28},{-222,-28}},                            color={255,0,255}));
  connect(isFouPip.y, pre1.u) annotation (Line(points={{82,-40},{160,-40},{160,70},
          {188,70}},       color={255,0,255}));
  connect(intEqu.y, or3.u1)
    annotation (Line(points={{-98,230},{-62,230}}, color={255,0,255}));
  connect(intEqu1.y, or3.u2) annotation (Line(points={{122,310},{132,310},{132,248},
          {-72,248},{-72,222},{-62,222}},
                           color={255,0,255}));
  connect(intEqu2.y, or4.u1)
    annotation (Line(points={{-98,160},{-68,160},{-68,140},{-62,140}},
                                                   color={255,0,255}));
  connect(pre1.y, and1.u2) annotation (Line(points={{212,70},{220,70},{220,52},{
          92,52},{92,222},{98,222}},           color={255,0,255}));
  connect(pre1.y, and3.u2) annotation (Line(points={{212,70},{220,70},{220,52},{
          92,52},{92,132},{98,132}},           color={255,0,255}));
  connect(or3.y, and4.u1)
    annotation (Line(points={{-38,230},{-22,230}}, color={255,0,255}));
  connect(and4.y, pre.u)
    annotation (Line(points={{2,230},{18,230}},    color={255,0,255}));
  connect(or4.y, and5.u1)
    annotation (Line(points={{-38,140},{-22,140}}, color={255,0,255}));
  connect(and5.y, pre2.u)
    annotation (Line(points={{2,140},{18,140}},    color={255,0,255}));
  connect(pre.y, and1.u1)
    annotation (Line(points={{42,230},{98,230}},   color={255,0,255}));
  connect(pre2.y, and3.u1) annotation (Line(points={{42,140},{98,140}},
                 color={255,0,255}));
  connect(lat.y, not2.u) annotation (Line(points={{192,220},{210,220}}, color={
          255,0,255}));
  connect(and1.y, lat.u) annotation (Line(points={{122,230},{156,230},{156,220},
          {168,220}},  color={255,0,255}));
  connect(falEdg.y, lat.clr) annotation (Line(points={{62,60},{156,60},{156,214},
          {168,214}},
        color={255,0,255}));
  connect(lat1.y, not3.u)
    annotation (Line(points={{192,140},{210,140}}, color={255,0,255}));
  connect(and3.y, lat1.u) annotation (Line(points={{122,140},{168,140}},
                      color={255,0,255}));
  connect(falEdg.y, lat1.clr) annotation (Line(points={{62,60},{156,60},{156,134},
          {168,134}},                                   color={255,0,255}));
  connect(not3.y, and6.u1) annotation (Line(points={{234,140},{258,140}},
                      color={255,0,255}));
  connect(pre1.y, and6.u2) annotation (Line(points={{212,70},{250,70},{250,132},
          {258,132}},  color={255,0,255}));
  connect(not2.y, and7.u1) annotation (Line(points={{234,220},{258,220}},
                                                  color={255,0,255}));
  connect(pre1.y, and7.u2) annotation (Line(points={{212,70},{250,70},{250,212},
          {258,212}},  color={255,0,255}));
  connect(intEqu1.y, and8.u1) annotation (Line(points={{122,310},{198,310}},
                                                                   color={255,0,
          255}));
  connect(isFouPip.y, and8.u2) annotation (Line(points={{82,-40},{160,-40},{160,
          302},{198,302}},                color={255,0,255}));
  connect(intEqu1.y, or4.u2) annotation (Line(points={{122,310},{132,310},{132,248},
          {-72,248},{-72,132},{-62,132}},
                      color={255,0,255}));
  connect(intScaRep1.y, intEqu1.u2)
    annotation (Line(points={{-98,200},{68,200},{68,302},{98,302}},
                                                   color={255,127,0}));
  connect(conInt.y, intScaRep1.u) annotation (Line(points={{-198,130},{-170,130},
          {-170,200},{-122,200}},
                           color={255,127,0}));
  connect(conInt3.y, intEqu.u1)
    annotation (Line(points={{-198,230},{-122,230}},
                                                   color={255,127,0}));
  connect(swi.y, yStaEqu) annotation (Line(points={{50,-260},{340,-260}},
                      color={0,0,127}));
  connect(mulInt1.y, addInt.u2) annotation (Line(points={{12,-150},{60,-150},{60,
          -86},{78,-86}},  color={255,127,0}));
  connect(mulInt.y, addInt.u1)
    annotation (Line(points={{12,-70},{12,-74},{78,-74}},  color={255,127,0}));
  connect(uMod, booToInt.u) annotation (Line(points={{-280,-180},{-82,-180}},
                                                           color={255,0,255}));
  connect(intSwi.y, yMod)
    annotation (Line(points={{222,-90},{340,-90}}, color={255,127,0}));
  connect(and7.y, yAvaFouPipHea)
    annotation (Line(points={{282,220},{340,220}}, color={255,0,255}));
  connect(u1Hp, falEdg.u)
    annotation (Line(points={{-280,60},{38,60}},     color={255,0,255}));
  connect(u1Hp, and5.u2) annotation (Line(points={{-280,60},{-30,60},{-30,132},{
          -22,132}},              color={255,0,255}));
  connect(u1Hp, and4.u2) annotation (Line(points={{-280,60},{-30,60},{-30,222},{
          -22,222}},              color={255,0,255}));
  connect(and6.y, yAvaFouPipCoo)
    annotation (Line(points={{282,140},{340,140}}, color={255,0,255}));
  connect(and9.y, y1PumPri) annotation (Line(points={{282,360},{340,360}},
        color={255,0,255}));
  connect(and2.y, yHeaCoo)
    annotation (Line(points={{-198,-20},{340,-20}}, color={255,0,255}));
  connect(intSwi1.y, yIdxSta)
    annotation (Line(points={{52,-360},{340,-360}}, color={255,127,0}));
  connect(u1PumPriCoo, or5.u1) annotation (Line(points={{-278,380},{100,380},{100,
          360},{118,360}}, color={255,0,255}));
  connect(u1PumPriHea, or5.u2) annotation (Line(points={{-280,340},{100,340},{100,
          352},{118,352}}, color={255,0,255}));
  connect(intSwi.y, intEqu1.u1) annotation (Line(points={{222,-90},{240,-90},{240,
          270},{92,270},{92,310},{98,310}}, color={255,127,0}));
  connect(intSwi.y, intEqu.u2) annotation (Line(points={{222,-90},{240,-90},{240,
          270},{-148,270},{-148,222},{-122,222}}, color={255,127,0}));
  connect(conInt5.y, intEqu2.u1) annotation (Line(points={{-198,170},{-132,170},
          {-132,160},{-122,160}}, color={255,127,0}));
  connect(intSwi.y, intEqu2.u2) annotation (Line(points={{222,-90},{240,-90},{240,
          270},{-148,270},{-148,152},{-122,152}}, color={255,127,0}));
  connect(booToInt1.y, mulInt.u2) annotation (Line(points={{-38,-90},{-32,-90},{
          -32,-76},{-12,-76}}, color={255,127,0}));
  connect(conInt.y, mulInt.u1) annotation (Line(points={{-198,130},{-170,130},{-170,
          -64},{-12,-64}}, color={255,127,0}));
  connect(and8.y, and9.u2) annotation (Line(points={{222,310},{240,310},{240,352},
          {258,352}}, color={255,0,255}));
  connect(or5.y, and9.u1)
    annotation (Line(points={{142,360},{258,360}}, color={255,0,255}));
  annotation (
    defaultComponentName="ctlPlaHyb",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-140},{100,140}}),
      graphics={
        Rectangle(
          extent={{-100,140},{100,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-140,180},{140,140}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(
      coordinateSystem(
        extent={{-260,-400},{320,400}})),
    Documentation(
      info="<html>
<p>
Block that manages custom calculations for integrating 4-pipe airsource heat pump (ASHP)
with multiple modular 2-pipe heat pumps to create a hybrid air-source heat pump plant.
</p>
<p>
The implemented module manages the following functions.
<ul>
<li>
Uses the heating plant enable <code>u1EnaHea</code> and cooling plant enable
<code>u1EnaCoo</code> signals to determine operation mode <code>yMod</code>
for 4-pipe ASHP (heating-only, cooling-only, or heating-cooling). This also influences
the staging order <code>yStaEqu</code> and the equipment rotation index signal
<code>yIdxSta</code>.
</li>
<li>
Modifies the availability status vectors <code>yAvaFouPipHea</code> and
<code>yAvaFouPipCoo</code> to indicate availability of heating-cooling mode in
4-pipe ASHP, even if it is currently enabled in heating-only mode or cooling-only
mode.
</li>
<li>
Identifies primary pump operation status for 4-pipe ASHP, and manages enable status
as required between the three operation modes.
</li>
</ul>
</p>
<h4>Details</h4>
<p>
Staging matrices <code>staEqu</code>, <code>staEquCooHea</code>, and
<code>staEquOneMod</code> are required as parameters.
See the documentation of
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable\">
Buildings.Templates.Plants.Controls.StagingRotation.EquipmentEnable</a>
for the associated definition and requirements.
</p>
</html>", revisions="<html>
<ul>
<li>
July 29, 2025, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end HybridPlantControlModule;
