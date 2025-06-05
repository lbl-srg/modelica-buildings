within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Validation;
model Controller
  "Validates the waterside economizer enable-disable controller"

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller
    wseSta(TOutWetDes(displayUnit="degC"))
    "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{-180,40},{-160,68}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller
    wseSta1 "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{-80,40},{-60,68}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller
    wseSta2 "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{40,40},{60,68}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller
    wseSta3(
    final have_byPasValCon=false,
    TOutWetDes(displayUnit="degC"))
    "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{240,40},{260,68}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin dpWSE(
    final amplitude=3000,
    freqHz=1/3600,
    final offset=4500)
    "Static pressure difference across chilled water side economizer"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));

protected
  parameter Real TOutWetBul(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=283.15
    "Average outdoor air wet bulb temperature";

  parameter Real TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=293.15
    "Chilled water retun temperature upstream of the WSE";

  parameter Real TWseOut(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=290.15
    "Chilled water retun temperature downstream of the WSE";

  parameter Real VChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.01
      "Measured chilled water return temperature";

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlow(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse TOutWetSig(
    final amplitude=5,
    final period=2*15*60,
    final offset=TOutWetBul) "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant constTowFanSig(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetSig(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-260,70},{-240,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetDow(
    final k=TWseOut)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlow1(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutWetSig1(
    final k=TOutWetBul)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-150,100},{-130,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant constTowFanSig1(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-150,-40},{-130,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetSig1(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRetDow1(
    final offset=TWseOut,
    final freqHz=1/1800,
    final amplitude=4)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-150,40},{-130,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlow2(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse TOutWetSig2(
    final amplitude=5,
    final period=2*15*60,
    final offset=TOutWetBul) "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant constTowFanSig2(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetSig2(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRetDow3(
    final offset=TWseOut,
    final freqHz=1/1800,
    final amplitude=4)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=0)
    "Stage 0"
    annotation (Placement(transformation(extent={{-300,-20},{-280,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=2)
    "Stage 0"
    annotation (Placement(transformation(extent={{-300,-60},{-280,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) "Enabled plant"
    annotation (Placement(transformation(extent={{-300,22},{-280,42}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiWatFlow3(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant constTowFanSig3(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetSig3(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatRetDow2(
    final k=TWseOut)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOutWetSig3(
    final k=292.15)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{160,100},{180,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.1,
    final period=3600) "Enabled plant"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=0)
    "Stage 0"
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TEntHex(
    final height=3,
    final duration=3600,
    final offset=290.15)
    "Return chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[2](
    final k=fill(true, 2))
    "Enabled chiller chilled water isolation valves"
    annotation (Placement(transformation(extent={{-300,-100},{-280,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con3[2](
    final k=fill(true, 2))
    "Enabled chiller chilled water isolation valves"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2[2](k=fill(1, 2))
    "Chiller chilled water isolation valve positions"
    annotation (Placement(transformation(extent={{-300,-130},{-280,-110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con4[2](k=fill(1, 2))
    "Chiller chilled water isolation valve positions"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  CDL.Logical.Sources.Constant                        con5(final k=false)
    "Not in process"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
equation
  connect(constTowFanSig.y, wseSta.uTowFanSpeMax) annotation (Line(points={{-238,
          -30},{-200,-30},{-200,59},{-182,59}}, color={0,0,127}));
  connect(TOutWetSig.y, wseSta.TOutWet) annotation (Line(points={{-238,110},{
          -200,110},{-200,67},{-182,67}},color={0,0,127}));
  connect(TChiWatRetSig.y, wseSta.TChiWatRet) annotation (Line(points={{-238,80},
          {-220,80},{-220,65},{-182,65}}, color={0,0,127}));
  connect(chiWatFlow.y, wseSta.VChiWat_flow) annotation (Line(points={{-238,10},
          {-210,10},{-210,61},{-182,61}}, color={0,0,127}));
  connect(TChiWatRetDow.y,wseSta.TChiWatRetDow)
    annotation (Line(points={{-238,50},{-230,50},{-230,63},{-182,63}}, color={0,0,127}));
  connect(constTowFanSig1.y, wseSta1.uTowFanSpeMax) annotation (Line(points={{-128,
          -30},{-96,-30},{-96,59},{-82,59}}, color={0,0,127}));
  connect(TOutWetSig1.y, wseSta1.TOutWet) annotation (Line(points={{-128,110},{
          -90,110},{-90,67},{-82,67}}, color={0,0,127}));
  connect(TChiWatRetSig1.y, wseSta1.TChiWatRet) annotation (Line(points={{-128,80},
          {-110,80},{-110,65},{-82,65}}, color={0,0,127}));
  connect(chiWatFlow1.y, wseSta1.VChiWat_flow) annotation (Line(points={{-128,10},
          {-106,10},{-106,61},{-82,61}}, color={0,0,127}));
  connect(TChiWatRetDow1.y,wseSta1.TChiWatRetDow)
    annotation (Line(points={{-128,50},{-124,50},{-124,63},{-82,63}}, color={0,0,127}));
  connect(constTowFanSig2.y, wseSta2.uTowFanSpeMax) annotation (Line(points={{-8,-30},
          {26,-30},{26,59},{38,59}},           color={0,0,127}));
  connect(TOutWetSig2.y,wseSta2. TOutWet) annotation (Line(points={{-8,110},{30,
          110},{30,67},{38,67}},     color={0,0,127}));
  connect(TChiWatRetSig2.y,wseSta2. TChiWatRet) annotation (Line(points={{-8,80},
          {10,80},{10,65},{38,65}},   color={0,0,127}));
  connect(chiWatFlow2.y,wseSta2. VChiWat_flow) annotation (Line(points={{-8,10},
          {16,10},{16,61},{38,61}},   color={0,0,127}));
  connect(wseSta2.TChiWatRetDow, TChiWatRetDow3.y)
    annotation (Line(points={{38,63},{-4,63},{-4,50},{-8,50}}, color={0,0,127}));
  connect(con.y, wseSta.uPla) annotation (Line(points={{-278,32},{-220,32},{
          -220,57},{-182,57}},
                          color={255,0,255}));
  connect(con.y, wseSta1.uPla) annotation (Line(points={{-278,32},{-116,32},{
          -116,57},{-82,57}},
                         color={255,0,255}));
  connect(con.y, wseSta2.uPla) annotation (Line(points={{-278,32},{6,32},{6,57},
          {38,57}}, color={255,0,255}));
  connect(conInt.y, wseSta.uIni) annotation (Line(points={{-278,-10},{-216,-10},
          {-216,55},{-182,55}}, color={255,127,0}));
  connect(conInt.y, wseSta1.uIni) annotation (Line(points={{-278,-10},{-112,-10},
          {-112,55},{-82,55}}, color={255,127,0}));
  connect(conInt.y, wseSta2.uIni) annotation (Line(points={{-278,-10},{10,-10},
          {10,55},{38,55}},color={255,127,0}));
  connect(conInt1.y, wseSta.uChiSta) annotation (Line(points={{-278,-50},{-206,
          -50},{-206,53},{-182,53}},
                                color={255,127,0}));
  connect(conInt1.y, wseSta1.uChiSta) annotation (Line(points={{-278,-50},{-102,
          -50},{-102,53},{-82,53}}, color={255,127,0}));
  connect(conInt1.y, wseSta2.uChiSta) annotation (Line(points={{-278,-50},{20,
          -50},{20,53},{38,53}},
                            color={255,127,0}));
  connect(dpWSE.y, wseSta.dpChiWat) annotation (Line(points={{-238,-70},{-226,
          -70},{-226,51},{-182,51}},
                                color={0,0,127}));
  connect(dpWSE.y, wseSta1.dpChiWat) annotation (Line(points={{-238,-70},{-120,
          -70},{-120,51},{-82,51}},
                               color={0,0,127}));
  connect(dpWSE.y, wseSta2.dpChiWat) annotation (Line(points={{-238,-70},{0,-70},
          {0,51},{38,51}}, color={0,0,127}));
  connect(TOutWetSig3.y, wseSta3.TOutWet) annotation (Line(points={{182,110},{
          216,110},{216,67},{238,67}}, color={0,0,127}));
  connect(TChiWatRetSig3.y, wseSta3.TChiWatRet) annotation (Line(points={{182,80},
          {212,80},{212,65},{238,65}}, color={0,0,127}));
  connect(TChiWatRetDow2.y, wseSta3.TChiWatRetDow) annotation (Line(points={{182,50},
          {204,50},{204,63},{238,63}},     color={0,0,127}));
  connect(chiWatFlow3.y, wseSta3.VChiWat_flow) annotation (Line(points={{182,10},
          {208,10},{208,61},{238,61}}, color={0,0,127}));
  connect(constTowFanSig3.y, wseSta3.uTowFanSpeMax) annotation (Line(points={{182,-30},
          {212,-30},{212,59},{238,59}},      color={0,0,127}));
  connect(conInt2.y, wseSta3.uIni) annotation (Line(points={{142,-10},{216,-10},
          {216,55},{238,55}}, color={255,127,0}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{102,30},{118,30}}, color={255,0,255}));
  connect(not1.y, wseSta3.uPla) annotation (Line(points={{142,30},{220,30},{220,
          57},{238,57}}, color={255,0,255}));
  connect(not1.y, wseSta3.uPum) annotation (Line(points={{142,30},{220,30},{220,
          49},{238,49}}, color={255,0,255}));
  connect(TEntHex.y, wseSta3.TEntHex) annotation (Line(points={{182,-70},{224,
          -70},{224,45},{238,45}},
                              color={0,0,127}));
  connect(conInt2.y, wseSta3.uChiSta) annotation (Line(points={{142,-10},{216,
          -10},{216,53},{238,53}},
                              color={255,127,0}));
  connect(con1.y, wseSta.u1ChiIsoVal) annotation (Line(points={{-278,-90},{-194,
          -90},{-194,43},{-182,43}}, color={255,0,255}));
  connect(con1.y, wseSta1.u1ChiIsoVal) annotation (Line(points={{-278,-90},{-90,
          -90},{-90,43},{-82,43}}, color={255,0,255}));
  connect(con1.y, wseSta2.u1ChiIsoVal) annotation (Line(points={{-278,-90},{30,-90},
          {30,43},{38,43}}, color={255,0,255}));
  connect(con2.y, wseSta.uChiIsoVal) annotation (Line(points={{-278,-120},{-190,
          -120},{-190,41},{-182,41}}, color={0,0,127}));
  connect(con2.y, wseSta1.uChiIsoVal) annotation (Line(points={{-278,-120},{-86,
          -120},{-86,41},{-82,41}}, color={0,0,127}));
  connect(con2.y, wseSta2.uChiIsoVal) annotation (Line(points={{-278,-120},{34,-120},
          {34,41},{38,41}}, color={0,0,127}));
  connect(con3.y, wseSta3.u1ChiIsoVal) annotation (Line(points={{142,-90},{228,-90},
          {228,43},{238,43}}, color={255,0,255}));
  connect(con4.y, wseSta3.uChiIsoVal) annotation (Line(points={{142,-120},{232,-120},
          {232,41},{238,41}}, color={0,0,127}));
  connect(con5.y, wseSta3.uStaPro) annotation (Line(points={{142,-50},{204,-50},
          {204,47},{238,47}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/Plants/Chillers/Economizers/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Economizers.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-140},{320,140}}),
        graphics={
        Text(
          extent={{-276,-92},{-194,-116}},
          textColor={0,0,127},
          textString="Tests enable conditions 
based on the outdoor air 
wetbulb temperature"),
        Text(
          extent={{-176,-88},{-88,-118}},
          textColor={0,0,127},
          textString="Tests disable conditions 
based on the chilled water  
temperature downstream of WSE"),
        Text(
          extent={{-34,-92},{40,-112}},
          textColor={0,0,127},
          textString="Combines conditions from 
the first two tests"),
        Text(
          extent={{166,-98},{256,-110}},
          textColor={0,0,127},
          textString="Plant enabled in economizer mode")}));
end Controller;
