within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
block ControllerSHC_bck3 "Controller for modular multipipe system"
  parameter Integer nUni(
    final min=1)
    "Number of modules"
    annotation (Evaluate=true);
  parameter Real dtRun(
    final unit="s",
    final min=0,
    displayUnit="min")=0
    "Minimum runtime of each stage"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1UpHea
    "Heating stage up condition"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1DowHea
    "Heating stage down condition"
    annotation (Placement(transformation(extent={{-220,0},{-180,40}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1UpCoo
    "Cooling stage up condition"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1DowCoo
    "Cooling stage down condition"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1UpShc
    "SHC stage up condition"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1DowShc
    "SHC stage down condition"
    annotation (Placement(transformation(extent={{-220,-160},{-180,-120}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniHea
    "Number of modules in heating mode"
    annotation (Placement(transformation(extent={{180,60},{220,100}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniCoo
    "Number of modules in cooling mode"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nUniShc
    "Number of modules in SHC mode (may be cycling into cooling or heating mode)"
    annotation (Placement(transformation(extent={{180,-100},{220,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput mode
    "Operating mode command: 1 for heating, 2 for cooling, 3 for SHC"
    annotation (Placement(transformation(extent={{-220,120},{-180,160}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput on
    "On/off command: true to enable heat pump, false to disable heat pump"
    annotation (Placement(transformation(extent={{-220,180},{-180,220}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpHeaTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,64},{-150,84}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowHeaTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,18},{-150,38}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpCooTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,-18},{-150,2}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowCooTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,-62},{-150,-42}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1UpShcTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,-98},{-150,-78}})));
  Buildings.Controls.OBC.CDL.Logical.Timer y1DowShcTim(final t=dtRun)
    "True if stage change condition true for dtRun"
    annotation (Placement(transformation(extent={{-170,-142},{-150,-122}})));
  Templates.Plants.Controls.Utilities.StageIndex nShc(
    have_inpAva=false,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in SHC mode"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaShc
    "Enable lead module in SHC mode"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not off "True if disabled"
    annotation (Placement(transformation(extent={{-170,190},{-150,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisShc
    "True if disabled OR SHC disabled"
    annotation (Placement(transformation(extent={{-30,90},{-10,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaShc "True if SHC mode enabled"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxMod[3](k=Integer({
        Buildings.Fluid.HeatPumps.Types.OperatingMode.Heating,Buildings.Fluid.HeatPumps.Types.OperatingMode.Cooling,
        Buildings.Fluid.HeatPumps.Types.OperatingMode.SHC})) "Mode index"
    annotation (Placement(transformation(extent={{-170,150},{-150,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not disShc "True if SHC disabled"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaCoo
    "Enable lead module in cooling mode"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaHea
    "True if heating mode enabled"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal enaCoo
    "True if cooling mode enabled"
    annotation (Placement(transformation(extent={{-130,120},{-110,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisCooAndShc
    "True if disabled OR cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-30,120},{-10,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaHeaOrShc
    "True if heating or SHC mode enabled"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Or enaCooOrShc
    "True if cooling or SHC mode enabled"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Not disCooAndShc
    "True if both cooling and SHC disabled"
    annotation (Placement(transformation(extent={{-68,120},{-48,140}})));
  Buildings.Controls.OBC.CDL.Logical.Or offOrDisHeaAndShc
    "True if disabled OR heating and SHC disabled"
    annotation (Placement(transformation(extent={{-30,150},{-10,170}})));
  Buildings.Controls.OBC.CDL.Logical.Not disHeaAndShc
    "True if both heating and SHC disabled"
    annotation (Placement(transformation(extent={{-68,150},{-48,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch enaLeaHea
    "Enable lead module in heating mode"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Templates.Plants.Controls.Utilities.StageIndex nHea(
    have_inpAva=false,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in heating mode"
    annotation (Placement(transformation(extent={{48,70},{68,90}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniCoo(k={1,-1,-1}, nin=3)
    "Return nUni - nUniHea - nUniShc"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numUni(final k=nUni)
    "Number of modules"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Templates.Plants.Controls.Utilities.StageIndex numCoo(
    have_inpAva=false,
    use_sta0=true,
    nSta=nUni,
    final dtRun=dtRun) "Number of modules to run in cooling mode"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum remUniHea(k={1,-1},    nin=2)
    "Return nUni - nUniShc"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum nUniTot(nin=2)
    "Total number of modules running (in any mode)"
    annotation (Placement(transformation(extent={{130,-170},{110,-150}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold noUniAva(final t=
        nUni) "True if no more module is available"
    annotation (Placement(transformation(extent={{100,-170},{80,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Integers.Min minInt1
    annotation (Placement(transformation(extent={{140,70},{160,90}})));
equation
  connect(y1UpHeaTim.u, y1UpHea) annotation (Line(points={{-172,74},{-176,74},{
          -176,60},{-200,60}}, color={255,0,255}));
  connect(y1DowHea, y1DowHeaTim.u) annotation (Line(points={{-200,20},{-176,20},
          {-176,28},{-172,28}}, color={255,0,255}));
  connect(y1UpCoo, y1UpCooTim.u) annotation (Line(points={{-200,-20},{-176,-20},
          {-176,-8},{-172,-8}}, color={255,0,255}));
  connect(y1DowCooTim.u, y1DowCoo) annotation (Line(points={{-172,-52},{-176,
          -52},{-176,-60},{-200,-60}}, color={255,0,255}));
  connect(y1DowShc, y1DowShcTim.u) annotation (Line(points={{-200,-140},{-176,
          -140},{-176,-132},{-172,-132}}, color={255,0,255}));
  connect(y1UpShc, y1UpShcTim.u) annotation (Line(points={{-200,-100},{-176,
          -100},{-176,-88},{-172,-88}}, color={255,0,255}));
  connect(on, off.u)
    annotation (Line(points={{-200,200},{-172,200}}, color={255,0,255}));
  connect(off.y, offOrDisShc.u1) annotation (Line(points={{-148,200},{-74,200},
          {-74,100},{-32,100}}, color={255,0,255}));
  connect(mode, enaShc.u2) annotation (Line(points={{-200,140},{-160,140},{-160,
          92},{-132,92}}, color={255,127,0}));
  connect(idxMod[3].y, enaShc.u1) annotation (Line(points={{-148,160},{-144,160},
          {-144,100},{-132,100}}, color={255,127,0}));
  connect(enaShc.y, disShc.u)
    annotation (Line(points={{-108,100},{-102,100}}, color={255,0,255}));
  connect(disShc.y, offOrDisShc.u2) annotation (Line(points={{-78,100},{-76,100},
          {-76,92},{-32,92}}, color={255,0,255}));
  connect(offOrDisShc.y, enaLeaShc.clr) annotation (Line(points={{-8,100},{0,
          100},{0,-86},{8,-86}}, color={255,0,255}));
  connect(enaLeaShc.y, nShc.u1Lea) annotation (Line(points={{32,-80},{38,-80},{
          38,-74},{48,-74}}, color={255,0,255}));
  connect(nShc.y, nUniShc)
    annotation (Line(points={{72,-80},{200,-80}}, color={255,127,0}));
  connect(idxMod[1].y, enaHea.u1)
    annotation (Line(points={{-148,160},{-132,160}}, color={255,127,0}));
  connect(mode, enaCoo.u2) annotation (Line(points={{-200,140},{-160,140},{-160,
          122},{-132,122}}, color={255,127,0}));
  connect(idxMod[2].y, enaCoo.u1) annotation (Line(points={{-148,160},{-144,160},
          {-144,130},{-132,130}}, color={255,127,0}));
  connect(mode, enaHea.u2) annotation (Line(points={{-200,140},{-136,140},{-136,
          152},{-132,152}}, color={255,127,0}));
  connect(enaHea.y, enaHeaOrShc.u1)
    annotation (Line(points={{-108,160},{-102,160}}, color={255,0,255}));
  connect(enaShc.y, enaHeaOrShc.u2) annotation (Line(points={{-108,100},{-106,
          100},{-106,152},{-102,152}}, color={255,0,255}));
  connect(enaCoo.y, enaCooOrShc.u1)
    annotation (Line(points={{-108,130},{-102,130}}, color={255,0,255}));
  connect(enaShc.y, enaCooOrShc.u2) annotation (Line(points={{-108,100},{-106,
          100},{-106,122},{-102,122}}, color={255,0,255}));
  connect(enaCooOrShc.y, disCooAndShc.u)
    annotation (Line(points={{-78,130},{-70,130}}, color={255,0,255}));
  connect(disCooAndShc.y, offOrDisCooAndShc.u2) annotation (Line(points={{-46,
          130},{-44,130},{-44,122},{-32,122}}, color={255,0,255}));
  connect(enaHeaOrShc.y, disHeaAndShc.u)
    annotation (Line(points={{-78,160},{-70,160}}, color={255,0,255}));
  connect(disHeaAndShc.y, offOrDisHeaAndShc.u2) annotation (Line(points={{-46,
          160},{-44,160},{-44,152},{-32,152}}, color={255,0,255}));
  connect(off.y, offOrDisHeaAndShc.u1) annotation (Line(points={{-148,200},{-40,
          200},{-40,160},{-32,160}}, color={255,0,255}));
  connect(enaLeaHea.y, nHea.u1Lea) annotation (Line(points={{32,80},{38,80},{38,
          86},{46,86}}, color={255,0,255}));
  connect(y1DowShcTim.passed, nShc.u1Dow) annotation (Line(points={{-148,-140},
          {42,-140},{42,-82},{48,-82}}, color={255,0,255}));
  connect(numUni.y, remUniCoo.u[1]) annotation (Line(points={{32,40},{80,40},{
          80,20},{110,20},{110,17.6667},{108,17.6667}},
                                                      color={255,127,0}));
  connect(nShc.y, remUniCoo.u[2]) annotation (Line(points={{72,-80},{90,-80},{
          90,20},{108,20}},           color={255,127,0}));
  connect(enaLeaCoo.y, numCoo.u1Lea)
    annotation (Line(points={{32,0},{38,0},{38,6},{48,6}}, color={255,0,255}));
  connect(numUni.y, remUniHea.u[1]) annotation (Line(points={{32,40},{80,40},{
          80,58.25},{108,58.25}},       color={255,127,0}));
  connect(nShc.y, remUniHea.u[2]) annotation (Line(points={{72,-80},{90,-80},{
          90,61.75},{108,61.75}},       color={255,127,0}));
  connect(y1UpCooTim.passed, numCoo.u1Up) annotation (Line(points={{-148,-16},{
          40,-16},{40,2},{48,2}}, color={255,0,255}));
  connect(y1UpShcTim.passed, nShc.u1Up) annotation (Line(points={{-148,-96},{40,
          -96},{40,-78},{48,-78}}, color={255,0,255}));
  connect(offOrDisHeaAndShc.y, enaLeaHea.clr) annotation (Line(points={{-8,160},
          {4,160},{4,74},{8,74}}, color={255,0,255}));
  connect(offOrDisCooAndShc.y, enaLeaCoo.clr) annotation (Line(points={{-8,130},
          {2,130},{2,-6},{8,-6}}, color={255,0,255}));
  connect(off.y, offOrDisCooAndShc.u1) annotation (Line(points={{-148,200},{-40,
          200},{-40,130},{-32,130}}, color={255,0,255}));
  connect(nUniHea, nUniTot.u[1]) annotation (Line(points={{200,80},{170,80},{
          170,-161.75},{132,-161.75}},   color={255,127,0}));
  connect(nUniShc, nUniTot.u[2]) annotation (Line(points={{200,-80},{174,-80},{
          174,-158.25},{132,-158.25}},   color={255,127,0}));
  connect(nUniTot.y, noUniAva.u)
    annotation (Line(points={{108,-160},{102,-160}}, color={255,127,0}));
  connect(y1UpShc, enaLeaShc.u) annotation (Line(points={{-200,-100},{-20,-100},
          {-20,-80},{8,-80}}, color={255,0,255}));
  connect(y1UpCoo, enaLeaCoo.u) annotation (Line(points={{-200,-20},{-20,-20},{
          -20,0},{8,0}}, color={255,0,255}));
  connect(y1UpHea, enaLeaHea.u) annotation (Line(points={{-200,60},{-20,60},{
          -20,80},{8,80}}, color={255,0,255}));
  connect(y1UpHeaTim.passed, nHea.u1Up) annotation (Line(points={{-148,66},{40,
          66},{40,82},{46,82}}, color={255,0,255}));
  connect(remUniCoo.y, minInt.u1) annotation (Line(points={{132,20},{136,20},{
          136,6},{138,6}}, color={255,127,0}));
  connect(numCoo.y, minInt.u2) annotation (Line(points={{72,0},{106,0},{106,-6},
          {138,-6}}, color={255,127,0}));
  connect(minInt.y, nUniCoo)
    annotation (Line(points={{162,0},{200,0}}, color={255,127,0}));
  connect(remUniHea.y, minInt1.u2) annotation (Line(points={{132,60},{136,60},{
          136,74},{138,74}}, color={255,127,0}));
  connect(nHea.y, minInt1.u1) annotation (Line(points={{70,80},{120,80},{120,86},
          {138,86}}, color={255,127,0}));
  connect(minInt1.y, nUniHea) annotation (Line(points={{162,80},{176,80},{176,
          80},{200,80}}, color={255,127,0}));
  connect(nUniHea, remUniCoo.u[3]) annotation (Line(points={{200,80},{170,80},{
          170,40},{100,40},{100,22.3333},{108,22.3333}}, color={255,127,0}));
  connect(y1DowCooTim.passed, numCoo.u1Dow) annotation (Line(points={{-148,-60},
          {44,-60},{44,-2},{48,-2}}, color={255,0,255}));
  connect(y1DowHeaTim.passed, nHea.u1Dow) annotation (Line(points={{-148,20},{
          44,20},{44,78},{46,78}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={
            {-180,-220},{180,220}})));
end ControllerSHC_bck3;
