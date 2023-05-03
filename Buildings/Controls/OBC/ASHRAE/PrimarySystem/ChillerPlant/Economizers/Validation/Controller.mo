within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Validation;
model Controller
  "Validates the waterside economizer enable/disable controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta(TOutWetDes(displayUnit="degC"))
    "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{-190,40},{-170,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta1 "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta2 "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller
    wseSta3(
    final have_byPasValCon=false,
    TOutWetDes(displayUnit="degC"))
    "Waterside economizer enable status sequence"
    annotation (Placement(transformation(extent={{240,40},{260,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin dpWSE(
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlow(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-260,0},{-240,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse TOutWetSig(
    final amplitude=5,
    final period=2*15*60,
    final offset=TOutWetBul) "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant constTowFanSig(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetSig(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-260,70},{-240,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetDow(
    final k=TWseOut)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-260,40},{-240,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlow1(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-150,0},{-130,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutWetSig1(
    final k=TOutWetBul)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-150,100},{-130,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant constTowFanSig1(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-150,-40},{-130,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetSig1(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TChiWatRetDow1(
    final offset=TWseOut,
    final freqHz=1/1800,
    final amplitude=4)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-150,40},{-130,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlow2(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse TOutWetSig2(
    final amplitude=5,
    final period=2*15*60,
    final offset=TOutWetBul) "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-30,100},{-10,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant constTowFanSig2(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{-30,-40},{-10,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetSig2(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TChiWatRetDow3(
    final offset=TWseOut,
    final freqHz=1/1800,
    final amplitude=4)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{-30,40},{-10,60}})));

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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatFlow3(
    final k=VChiWat_flow)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant constTowFanSig3(
    final k=1)
    "Cooling tower fan full load signal"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetSig3(
    final k=TChiWatRet)
    "Chilled water return temperature upstream of WSE"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatRetDow2(
    final k=TWseOut)
    "Chilled water return temperature downstream of WSE"
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TOutWetSig3(
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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEntHex(
    final height=3,
    final duration=3600,
    final offset=290.15)
    "Return chilled water temperature entering heat exchanger"
    annotation (Placement(transformation(extent={{160,-80},{180,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical not"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
equation
  connect(constTowFanSig.y, wseSta.uTowFanSpeMax) annotation (Line(points={{-238,
          -30},{-200,-30},{-200,52},{-192,52}}, color={0,0,127}));
  connect(TOutWetSig.y, wseSta.TOutWet) annotation (Line(points={{-238,110},{-200,
          110},{-200,60},{-192,60}}, color={0,0,127}));
  connect(TChiWatRetSig.y, wseSta.TChiWatRet) annotation (Line(points={{-238,80},
          {-220,80},{-220,58},{-192,58}}, color={0,0,127}));
  connect(chiWatFlow.y, wseSta.VChiWat_flow) annotation (Line(points={{-238,10},
          {-210,10},{-210,54},{-192,54}}, color={0,0,127}));
  connect(TChiWatRetDow.y,wseSta.TChiWatRetDow)
    annotation (Line(points={{-238,50},{-230,50},{-230,56},{-192,56}}, color={0,0,127}));
  connect(constTowFanSig1.y, wseSta1.uTowFanSpeMax) annotation (Line(points={{-128,
          -30},{-90,-30},{-90,52},{-82,52}}, color={0,0,127}));
  connect(TOutWetSig1.y, wseSta1.TOutWet) annotation (Line(points={{-128,110},{-90,
          110},{-90,60},{-82,60}}, color={0,0,127}));
  connect(TChiWatRetSig1.y, wseSta1.TChiWatRet) annotation (Line(points={{-128,80},
          {-110,80},{-110,58},{-82,58}}, color={0,0,127}));
  connect(chiWatFlow1.y, wseSta1.VChiWat_flow) annotation (Line(points={{-128,10},
          {-100,10},{-100,54},{-82,54}}, color={0,0,127}));
  connect(TChiWatRetDow1.y,wseSta1.TChiWatRetDow)
    annotation (Line(points={{-128,50},{-120,50},{-120,56},{-82,56}}, color={0,0,127}));
  connect(constTowFanSig2.y, wseSta2.uTowFanSpeMax) annotation (Line(points={{-8,-30},
          {30,-30},{30,52},{38,52}},           color={0,0,127}));
  connect(TOutWetSig2.y,wseSta2. TOutWet) annotation (Line(points={{-8,110},{30,
          110},{30,60},{38,60}}, color={0,0,127}));
  connect(TChiWatRetSig2.y,wseSta2. TChiWatRet) annotation (Line(points={{-8,80},
          {10,80},{10,58},{38,58}},   color={0,0,127}));
  connect(chiWatFlow2.y,wseSta2. VChiWat_flow) annotation (Line(points={{-8,10},
          {20,10},{20,54},{38,54}},   color={0,0,127}));
  connect(wseSta2.TChiWatRetDow, TChiWatRetDow3.y)
    annotation (Line(points={{38,56},{0,56},{0,50},{-8,50}}, color={0,0,127}));
  connect(con.y, wseSta.uPla) annotation (Line(points={{-278,32},{-220,32},{-220,
          50},{-192,50}}, color={255,0,255}));
  connect(con.y, wseSta1.uPla) annotation (Line(points={{-278,32},{-110,32},{-110,
          50},{-82,50}}, color={255,0,255}));
  connect(con.y, wseSta2.uPla) annotation (Line(points={{-278,32},{10,32},{10,50},
          {38,50}}, color={255,0,255}));
  connect(conInt.y, wseSta.uIni) annotation (Line(points={{-278,-10},{-216,-10},
          {-216,48},{-192,48}}, color={255,127,0}));
  connect(conInt.y, wseSta1.uIni) annotation (Line(points={{-278,-10},{-106,-10},
          {-106,48},{-82,48}}, color={255,127,0}));
  connect(conInt.y, wseSta2.uIni) annotation (Line(points={{-278,-10},{14,-10},{
          14,48},{38,48}}, color={255,127,0}));
  connect(conInt1.y, wseSta.uChiSta) annotation (Line(points={{-278,-50},{-206,-50},
          {-206,46},{-192,46}}, color={255,127,0}));
  connect(conInt1.y, wseSta1.uChiSta) annotation (Line(points={{-278,-50},{-96,-50},
          {-96,46},{-82,46}}, color={255,127,0}));
  connect(conInt1.y, wseSta2.uChiSta) annotation (Line(points={{-278,-50},{24,-50},
          {24,46},{38,46}}, color={255,127,0}));
  connect(dpWSE.y, wseSta.dpChiWat) annotation (Line(points={{-238,-70},{-226,-70},
          {-226,44},{-192,44}}, color={0,0,127}));
  connect(dpWSE.y, wseSta1.dpChiWat) annotation (Line(points={{-238,-70},{-116,-70},
          {-116,44},{-82,44}}, color={0,0,127}));
  connect(dpWSE.y, wseSta2.dpChiWat) annotation (Line(points={{-238,-70},{4,-70},
          {4,44},{38,44}}, color={0,0,127}));
  connect(TOutWetSig3.y, wseSta3.TOutWet) annotation (Line(points={{182,110},{220,
          110},{220,60},{238,60}}, color={0,0,127}));
  connect(TChiWatRetSig3.y, wseSta3.TChiWatRet) annotation (Line(points={{182,80},
          {214,80},{214,58},{238,58}}, color={0,0,127}));
  connect(TChiWatRetDow2.y, wseSta3.TChiWatRetDow) annotation (Line(points={{182,
          50},{196,50},{196,56},{238,56}}, color={0,0,127}));
  connect(chiWatFlow3.y, wseSta3.VChiWat_flow) annotation (Line(points={{182,10},
          {204,10},{204,54},{238,54}}, color={0,0,127}));
  connect(constTowFanSig3.y, wseSta3.uTowFanSpeMax) annotation (Line(points={{182,
          -30},{208,-30},{208,52},{238,52}}, color={0,0,127}));
  connect(conInt2.y, wseSta3.uIni) annotation (Line(points={{142,-10},{212,-10},
          {212,48},{238,48}}, color={255,127,0}));
  connect(booPul.y, not1.u)
    annotation (Line(points={{102,30},{118,30}}, color={255,0,255}));
  connect(not1.y, wseSta3.uPla) annotation (Line(points={{142,30},{200,30},{200,
          50},{238,50}}, color={255,0,255}));
  connect(not1.y, wseSta3.uPum) annotation (Line(points={{142,30},{200,30},{200,
          42},{238,42}}, color={255,0,255}));
  connect(TEntHex.y, wseSta3.TEntHex) annotation (Line(points={{182,-70},{220,-70},
          {220,40},{238,40}}, color={0,0,127}));
  connect(conInt2.y, wseSta3.uChiSta) annotation (Line(points={{142,-10},{212,-10},
          {212,46},{238,46}}, color={255,127,0}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Economizers/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizers.Controller</a>.
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
          extent={{-276,-88},{-194,-112}},
          textColor={0,0,127},
          textString="Tests enable conditions 
based on the outdoor air 
wetbulb temperature"),
        Text(
          extent={{-166,-84},{-78,-114}},
          textColor={0,0,127},
          textString="Tests disable conditions 
based on the chilled water  
temperature downstream of WSE"),
        Text(
          extent={{-34,-88},{40,-108}},
          textColor={0,0,127},
          textString="Combines conditions from 
the first two tests"),
        Text(
          extent={{164,-86},{254,-98}},
          textColor={0,0,127},
          textString="Plant enabled in economizer mode")}));
end Controller;
