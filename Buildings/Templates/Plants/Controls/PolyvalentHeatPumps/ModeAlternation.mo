within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block ModeAlternation
  "SHC and single mode alternation"
  parameter Integer nPhp(final min=1)
    "Number of polyvalent HP"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSor[nPhp]
    "Indices of units sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-200,-160},{-160,-120}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nHea
    "Number of units to be staged in heating mode"
    annotation(Placement(transformation(extent={{-200,120},{-160,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nCoo
    "Number of units to be staged in cooling mode"
    annotation(Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nShc
    "Number of units to be staged in SHC mode"
    annotation(Placement(transformation(extent={{-200,40},{-160,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nPhp]
    "Enable command of each unit in heating mode, indexed by unit"
    annotation(Placement(transformation(extent={{-200,0},{-160,40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo[nPhp]
    "Enable command of each unit in cooling mode, indexed by unit"
    annotation(Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc[nPhp]
    "Enable command of each unit in SHC mode, indexed by unit"
    annotation(Placement(transformation(extent={{-200,-120},{-160,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorHea[nPhp](
    start=1:nPhp)
    "Staging order for the heating enable logic"
    annotation(Placement(transformation(extent={{160,120},{200,160}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorCoo[nPhp](
    start=1:nPhp)
    "Staging order for the cooling enable logic"
    annotation(Placement(transformation(extent={{160,80},{200,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorShc[nPhp](
    start=1:nPhp)
    "Staging order for the SHC enable logic"
    annotation(Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaHea
    "Detect a change in the number of units staged in heating mode"
    annotation(Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaCoo
    "Detect a change in the number of units staged in cooling mode"
    annotation(Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Integers.Change chaShc
    "Detect a change in the number of units staged in SHC mode"
    annotation(Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repHea(
    final nout=nPhp)
    "Replicate heating count change to all units"
    annotation(Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repCoo(
    final nout=nPhp)
    "Replicate cooling count change to all units"
    annotation(Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repShc(
    final nout=nPhp)
    "Replicate SHC count change to all units"
    annotation(Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And andHea[nPhp]
    "True at a heating-only to/from SHC mode switch"
    annotation(Placement(transformation(extent={{-40,130},{-20,150}})));
  Buildings.Controls.OBC.CDL.Logical.And andCoo[nPhp]
    "True at a cooling-only to/from SHC mode switch"
    annotation(Placement(transformation(extent={{-40,90},{-20,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or orSin[nPhp]
    "Units enabled in heating or cooling mode"
    annotation(Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preHea[nPhp]
    "Enable command of each unit in heating mode prior to stage transition"
    annotation(Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preCoo[nPhp]
    "Enable command of each unit in cooling mode prior to stage transition"
    annotation(Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preShc[nPhp]
    "Enable command of each unit in SHC mode prior to stage transition"
    annotation(Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder
    remHeaRes(final nUni=nPhp)
    "Restrictive heating order: remove units previously enabled in cooling mode"
    annotation (Placement(transformation(extent={{-92,-70},{-72,-50}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder
    remHeaSwi(final nUni=nPhp)
    "Heating order at mode switch: also remove units previously enabled in SHC mode"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder
    remCooRes(final nUni=nPhp)
    "Restrictive cooling order: remove units previously enabled in heating mode"
    annotation (Placement(transformation(extent={{-92,-30},{-72,-10}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder
    remCooSwi(final nUni=nPhp)
    "Cooling order at mode switch: also remove units previously enabled in SHC mode"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.RemoveFromStagingOrder
    remShc(final nUni=nPhp)
    "SHC order: remove units currently enabled in heating or cooling mode"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swiHea[nPhp]
    "Apply the mode-switch heating order at a mode switch, the restrictive one otherwise"
    annotation(Placement(transformation(extent={{100,130},{120,150}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swiCoo[nPhp]
    "Apply the mode-switch cooling order at a mode switch, the restrictive one otherwise"
    annotation(Placement(transformation(extent={{30,90},{50,110}})));
equation
  connect(nHea, chaHea.u)
    annotation(Line(points={{-180,140},{-142,140}},
      color={255,127,0}));
  connect(nCoo, chaCoo.u)
    annotation(Line(points={{-180,100},{-142,100}},
      color={255,127,0}));
  connect(nShc, chaShc.u)
    annotation(Line(points={{-180,60},{-142,60}},
      color={255,127,0}));
  connect(chaHea.y, repHea.u)
    annotation(Line(points={{-118,140},{-102,140}},
      color={255,0,255}));
  connect(chaCoo.y, repCoo.u)
    annotation(Line(points={{-118,100},{-102,100}},
      color={255,0,255}));
  connect(chaShc.y, repShc.u)
    annotation(Line(points={{-118,60},{-102,60}},
      color={255,0,255}));
  connect(repHea.y, andHea.u1)
    annotation(Line(points={{-78,140},{-42,140}},
      color={255,0,255}));
  connect(repShc.y, andHea.u2)
    annotation(Line(points={{-78,60},{-60,60},{-60,132},{-42,132}},
      color={255,0,255}));
  connect(repCoo.y, andCoo.u1)
    annotation(Line(points={{-78,100},{-42,100}},
      color={255,0,255}));
  connect(repShc.y, andCoo.u2)
    annotation(Line(points={{-78,60},{-60,60},{-60,92},{-42,92}},
      color={255,0,255}));
  connect(u1Hea, preHea.u)
    annotation(Line(points={{-180,20},{-154,20},{-154,-20},{-142,-20}},
      color={255,0,255}));
  connect(u1Coo, preCoo.u)
    annotation(Line(points={{-180,-60},{-142,-60}},
      color={255,0,255}));
  connect(u1Shc, preShc.u)
    annotation(Line(points={{-180,-100},{-142,-100}},
      color={255,0,255}));
  connect(u1Hea, orSin.u1)
    annotation(Line(points={{-180,20},{-142,20}},
      color={255,0,255}));
  connect(u1Coo, orSin.u2)
    annotation(Line(points={{-180,-60},{-150,-60},{-150,12},{-142,12}},
      color={255,0,255}));
  connect(uIdxSor, remHeaRes.uIdxSor)
    annotation(Line(points={{-180,-140},{-100,-140},{-100,-54},{-94,-54}},
      color={255,127,0}));
  connect(preCoo.y, remHeaRes.u1)
    annotation(Line(points={{-118,-60},{-110,-60},{-110,-66},{-94,-66}},
      color={255,0,255}));
  connect(remHeaRes.yIdxSor, remHeaSwi.uIdxSor)
    annotation(Line(points={{-70,-60},{-50,-60},{-50,-74},{-42,-74}},
      color={255,127,0}));
  connect(preShc.y, remHeaSwi.u1)
    annotation(Line(points={{-118,-100},{-50,-100},{-50,-86},{-42,-86}},
      color={255,0,255}));
  connect(uIdxSor, remCooRes.uIdxSor)
    annotation(Line(points={{-180,-140},{-100,-140},{-100,-14},{-94,-14}},
      color={255,127,0}));
  connect(preHea.y, remCooRes.u1)
    annotation(Line(points={{-118,-20},{-110,-20},{-110,-26},{-94,-26}},
      color={255,0,255}));
  connect(remCooRes.yIdxSor, remCooSwi.uIdxSor)
    annotation(Line(points={{-70,-20},{-50,-20},{-50,-34},{-42,-34}},
      color={255,127,0}));
  connect(preShc.y, remCooSwi.u1)
    annotation(Line(points={{-118,-100},{-60,-100},{-60,-46},{-42,-46}},
      color={255,0,255}));
  connect(uIdxSor, remShc.uIdxSor)
    annotation(Line(points={{-180,-140},{-100,-140},{-100,26},{-42,26}},
      color={255,127,0}));
  connect(orSin.y, remShc.u1)
    annotation(Line(points={{-118,20},{-60,20},{-60,14},{-42,14}},
      color={255,0,255}));
  connect(remHeaRes.yIdxSor, swiHea.u1)
    annotation(Line(points={{-70,-60},{80,-60},{80,148},{98,148}},
      color={255,127,0}));
  connect(andHea.y, swiHea.u2)
    annotation(Line(points={{-18,140},{98,140}},
      color={255,0,255}));
  connect(remHeaSwi.yIdxSor, swiHea.u3)
    annotation(Line(points={{-18,-80},{60,-80},{60,132},{98,132}},
      color={255,127,0}));
  connect(remCooRes.yIdxSor, swiCoo.u1)
    annotation(Line(points={{-70,-20},{0,-20},{0,108},{28,108}},
      color={255,127,0}));
  connect(andCoo.y, swiCoo.u2)
    annotation(Line(points={{-18,100},{28,100}},
      color={255,0,255}));
  connect(remCooSwi.yIdxSor, swiCoo.u3)
    annotation(Line(points={{-18,-40},{20,-40},{20,92},{28,92}},
      color={255,127,0}));
  connect(swiHea.y, yIdxSorHea)
    annotation(Line(points={{122,140},{180,140}},
      color={255,127,0}));
  connect(swiCoo.y, yIdxSorCoo)
    annotation(Line(points={{52,100},{180,100}},
      color={255,127,0}));
  connect(remShc.yIdxSor, yIdxSorShc)
    annotation(Line(points={{-18,20},{180,20}},
      color={255,127,0}));
annotation(defaultComponentName="selModPhp",
  Icon(coordinateSystem(preserveAspectRatio=false),
  graphics={Rectangle(extent={{-100,100},{100,-100}},
    lineColor={0,0,0},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
  Text(extent={{-150,150},{150,110}},
    textString="%name",
    textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-160},{160,160}})),
  Documentation(
    info="<html>
<h5>Heating-only</h5>
<p>
  When a stage transition yields a change in both the number of staged units
  in heating mode and the number of staged units in SHC mode, i.e., a unit
  switches from/to heating-only to/from SHC mode: the units previously enabled
  in cooling mode are removed from the staging order for the heating enable
  logic. The heating enable logic can thus disable a unit previously enabled
  in either heating or SHC mode, or enable a unit previously enabled in SHC
  mode or disabled.
</p>
<p>
  At any other time, the units previously enabled in cooling or SHC mode are
  removed from the staging order for the heating enable logic. The heating
  enable logic can thus only disable a unit previously enabled in heating
  mode, or enable a unit previously disabled.
</p>
<h5>Cooling-only</h5>
<p>
  When a stage transition yields a change in both the number of staged units
  in cooling mode and the number of staged units in SHC mode, i.e., a unit
  switches from/to cooling-only to/from SHC mode: the units previously enabled
  in heating mode are removed from the staging order for the cooling enable
  logic. The cooling enable logic can thus disable a unit previously enabled
  in either cooling or SHC mode, or enable a unit previously enabled in SHC
  mode or disabled.
</p>
<p>
  At any other time, the units previously enabled in heating or SHC mode are
  removed from the staging order for the cooling enable logic. The cooling
  enable logic can thus only disable a unit previously enabled in cooling
  mode, or enable a unit previously disabled.
</p>
<h5>SHC</h5>
<p>
  At any time, the units currently enabled in heating or cooling mode are
  removed from the staging order for the SHC enable logic. The SHC enable
  logic can thus only disable a unit enabled in SHC mode, or enable a disabled
  unit. It cannot disable a unit that has been enabled in heating or cooling
  mode.
</p>
<h4>Details</h4>
<h5>Staging logic requirement</h5>
<p>
  The alternation logic in this block assumes that stage transitions are
  elementary in terms of staged unit counts: either the number of staged units
  changes by one in exactly one operating mode &ndash; a unit is staged on or
  off &ndash; or the number of staged units decreases by one in one operating
  mode and increases by one in another operating mode &ndash; a mode switch at
  plant level, which the enable logics may realize with two distinct units.
  The staging logic shall preclude any other transition. Under this
  assumption, a simultaneous change in the number of staged units in a single
  mode and in SHC mode identifies without ambiguity a mode switch between that
  mode and SHC mode.
</p>
<h5>Resolution order</h5>
<p>
  The heating and cooling enable logics resolve against the unit assignment
  <i>prior to the stage transition</i>, whereas the SHC enable logic resolves
  against the resulting heating and cooling enable commands. This establishes
  the resolution order between the three logics: at a transition where a unit
  switches between a single mode and SHC mode, the unit claimed by the heating
  or cooling enable logic is removed from the staging order for the SHC enable
  logic at the same time instant.
</p>
<p>
  Note that a unit switching from SHC mode to a single mode, or conversely, is
  not subject to the minimum off-time required by
  <a href=\"modelica://Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability\">
    Buildings.Templates.Plants.Controls.HeatPumps.Subsequences.EquipmentAvailability</a>
  for the alternation between heating-only and cooling-only mode.
</p>
</html>"));
end ModeAlternation;
