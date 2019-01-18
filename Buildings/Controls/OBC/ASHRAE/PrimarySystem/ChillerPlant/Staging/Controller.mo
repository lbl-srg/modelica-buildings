within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging;
block Controller
  "Chiller stage for fixed speed chillers (positive displacement and centrifugal),try to have optional WSE"

  parameter Integer numSta=2 "Number of stages";

  parameter Real minPlrSta1=0.1 "Minimal part load ratio of the first stage";

  parameter Real small=0.00000001 "Small number to avoid division with zero";

  parameter Modelica.SIunits.Time minStaRun=15*60 "Minimum stage runtime";

  parameter Modelica.SIunits.Power staNomCap[numSta + 1]={small,3.517*1000*310,2
      *3.517*1000*310} "Array of nominal stage capacities starting at stage 0";

  parameter Real staUpPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Maximum operating part load ratio of the current stage before staging up";

  parameter Real staDowPlr(
    final min = 0,
    final max = 1,
    final unit="1") = 0.8
    "Minimum operating part load ratio of the next lower stage before staging down";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-70},{-140,-30}}),
    iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
    iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y(
    final min=0,
    final max=numSta) "Chiller stage"
    annotation (Placement(transformation(extent={{
    140,-10},{160,10}}), iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(k2=+1)
annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Integers.Min minInt1
annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=numSta)
annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant minStage(k=0)
annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
annotation (Placement(transformation(extent={{50,0},{70,20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=minStaRun)
    "Samples signal at a minimum runtime interval "
annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
annotation (Placement(transformation(extent={{90,40},{110,60}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
"Chilled water return temperature" annotation (Placement(transformation(
      extent={{-180,10},{-140,50}}),     iconTransformation(extent={{-120,0},
        {-100,20}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump differential static pressure setpoint"
annotation (Placement(transformation(extent={{-180,-110},{-140,-70}}),
  iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump differential static pressure"
annotation (Placement(
    transformation(extent={{-180,-170},{-140,-130}}), iconTransformation(
      extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput chiWatPumSpe(final unit="Pa", final quantity="PressureDifference")
"Chilled water pump speed"
annotation (Placement(transformation(extent={{-180,-140},{-140,-100}}),
                             iconTransformation(extent={{-140,-100},{-100,-60}})));
  Subsequences.PartLoadRatios staChaPosDis
    annotation (Placement(transformation(extent={{-52,94},{-32,114}})));
equation
  connect(staChaPosDis.y, addInt.u1) annotation (Line(points={{-31,110},{-26,
          110},{-26,66},{-22,66}},
                               color={255,127,0}));
  connect(staCap.ySta, staChaPosDis.uStaCap) annotation (Line(points={{-79,94},
          {-76,94},{-76,104},{-53,104}}, color={0,0,127}));
  connect(staCap.yStaLow, staChaPosDis.uStaLowCap) annotation (Line(points={{-79,
          86},{-74,86},{-74,102},{-53,102}}, color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-160,60},
      {-120,60},{-120,35},{-101,35}},
                                    color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-160,-10},{-120,
      -10},{-120,30},{-101,30}}, color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-160,-50},
      {-110,-50},{-110,25},{-101,25}},color={0,0,127}));
  connect(minInt1.u1, conInt.y) annotation (Line(points={{18,96},{10,96},{10,100},
      {1,100}}, color={255,127,0}));
  connect(addInt.y, minInt1.u2) annotation (Line(points={{1,60},{10,60},{10,84},
      {18,84}},color={255,127,0}));
  connect(minInt1.y, maxInt.u1) annotation (Line(points={{41,90},{50,90},{50,70},
      {14,70},{14,16},{18,16}},     color={255,127,0}));
  connect(minStage.y, maxInt.u2) annotation (Line(points={{41,-30},{50,-30},{50,
      -10},{14,-10},{14,4},{18,4}},     color={255,127,0}));
  connect(capReq.y, staChaPosDis.uCapReq) annotation (Line(points={{-79,30},{-72,
          30},{-72,100},{-53,100}},
                                color={0,0,127}));
  connect(maxInt.y, intToRea.u)
annotation (Line(points={{41,10},{48,10}},   color={255,127,0}));
  connect(intToRea.y, uniDel.u) annotation (Line(points={{71,10},{80,10},{80,30},
      {50,30},{50,50},{58,50}},
                  color={0,0,127}));
  connect(uniDel.y, reaToInt.u)
annotation (Line(points={{81,50},{88,50}}, color={0,0,127}));
  connect(y, reaToInt.y) annotation (Line(points={{150,0},{130,0},{130,50},{111,
      50}}, color={255,127,0}));
  connect(dpChiWatPumSet, staChaPosDis.dpChiWatPumSet) annotation (Line(points={{-160,
          -90},{-68,-90},{-68,97},{-53,97}},     color={0,0,127}));
  connect(chiWatPumSpe, staChaPosDis.chiWatPumSpe) annotation (Line(points={{-160,
          -120},{-66,-120},{-66,95},{-53,95}},
                                             color={0,0,127}));
  connect(dpChiWatPum, staChaPosDis.dpChiWatPum) annotation (Line(points={{-160,
          -150},{-64,-150},{-64,93},{-53,93}},
                                           color={0,0,127}));
  connect(TChiWatSupSet, staChaPosDis.TChiWatSupSet) annotation (Line(points={{-160,60},
          {-134,60},{-134,111},{-53,111}}, color={0,0,127}));
  connect(TChiWatSup, staChaPosDis.TChiWatSup) annotation (Line(points={{-160,30},
          {-132,30},{-132,109},{-53,109}},
                                       color={0,0,127}));
  connect(TChiWatRet, staChaPosDis.TChiWatRet) annotation (Line(points={{-160,-10},
          {-130,-10},{-130,107},{-53,107}},
                                        color={0,0,127}));
  connect(reaToInt.y, staChaPosDis.uChiSta) annotation (Line(points={{111,50},{120,
          50},{120,130},{-68,130},{-68,114},{-53,114}},
                                                    color={255,127,0}));
  connect(reaToInt.y, staCap.uSta) annotation (Line(points={{111,50},{120,50},{120,
          130},{-110,130},{-110,90},{-102,90}},
                                            color={255,127,0}));
  connect(reaToInt.y, addInt.u2) annotation (Line(points={{111,50},{120,50},{
      120,-50},{-26,-50},{-26,54},{-22,54}}, color={255,127,0}));
  annotation (
    defaultComponentName="chiSta",
    Icon(graphics={
    Rectangle(
    extent={{-100,-100},{100,100}},
    lineColor={0,0,127},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid),
    Text(
      extent={{-120,146},{100,108}},
      lineColor={0,0,255},
      textString="%name")}),         Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,140}})),
    Documentation(info=
               "<html>
<p>
Fixme
</p>
</html>", revisions=
      "<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
