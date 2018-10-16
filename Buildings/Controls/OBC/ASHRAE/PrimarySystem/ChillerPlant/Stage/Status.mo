within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block Status
  "Determines chiller stage based on the previous stage and the current capacity requirement. fixme: stagin up and down process (delays, etc) is in separate sequences."

  parameter Integer numSta = 2
  "Number of stages";

  parameter Real minPlrSta1 = 0.1
  "Minimal part load ratio of the first stage";

  parameter Real capSta1 = 3.517*1000*310
  "Capacity of stage 1";

  parameter Real capSta2 = 2*capSta1
  "Capacity of stage 2";

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

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min = 0,
    final max = numSta,
    final start = 0)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-180,-130},{-140,-90}}),
    iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
    iconTransformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yChiSta(
    final min=0,
    final max=numSta)
    "Chiller stage"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.Capacities staCap(
    final min_plr1=minPlrSta1,
    final nomCapSta1=capSta1,
    final nomCapSta2=capSta2)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.ChangePositiveDisplacement
    staChaPosDis(
    final staUpPlr=staUpPlr,
    final staDowPlr=staDowPlr,
    numSta=numSta)
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage.CapacityRequirement capReq
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Add addInt(k2=+1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Integers.Min minInt1
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Integers.Max maxInt
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(k=numSta)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant minStage(k=0)
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel(samplePeriod=1)
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{110,-20},{130,0}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity=
        "ThermodynamicTemperature")
    "Chilled water return temperature" annotation (Placement(transformation(
          extent={{-180,-50},{-140,-10}}),   iconTransformation(extent={{-120,0},
            {-100,20}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity=
        "PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-180,-170},{-140,-130}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity=
        "PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(
        transformation(extent={{-180,-200},{-140,-160}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput chiWatPumSpe(final unit="Pa", final quantity=
        "PressureDifference")
    "Chilled water pump speed"
    annotation (Placement(transformation(extent={{-180,-230},{-140,-190}}),
                                 iconTransformation(extent={{-140,-100},{-100,-60}})));
equation
  connect(uChiSta, addInt.u2) annotation (Line(points={{-160,60},{-120,60},{
          -120,10},{-50,10},{-50,-6},{-12,-6}},
                                          color={255,127,0}));
  connect(uChiSta, staCap.uChiSta) annotation (Line(points={{-160,60},{-110,60},
          {-110,30},{-102,30}},
                             color={255,127,0}));
  connect(staChaPosDis.yChiStaCha, addInt.u1) annotation (Line(points={{
          -33.8889,51.6667},{-20,51.6667},{-20,6},{-12,6}},
                                 color={255,127,0}));
  connect(uChiSta, staChaPosDis.uChiSta) annotation (Line(points={{-160,60},{
          -100,60},{-100,55},{-46.1111,55}},
                                 color={255,127,0}));
  connect(staCap.yCapNomSta, staChaPosDis.uCapNomSta) annotation (Line(points={{-79,34},
          {-70,34},{-70,52.9167},{-46.1111,52.9167}},
                                              color={0,0,127}));
  connect(staCap.yCapNomLowSta, staChaPosDis.uCapNomLowSta) annotation (Line(
        points={{-79,26},{-60,26},{-60,51.25},{-46.1111,51.25}},
                                                   color={0,0,127}));
  connect(TChiWatSupSet, capReq.TChiWatSupSet) annotation (Line(points={{-160,0},
          {-120,0},{-120,-25},{-101,-25}},
                                        color={0,0,127}));
  connect(TChiWatRet, capReq.TChiWatRet) annotation (Line(points={{-160,-70},{
          -120,-70},{-120,-30},{-101,-30}},
                                     color={0,0,127}));
  connect(VChiWat_flow, capReq.VChiWat_flow) annotation (Line(points={{-160,
          -110},{-110,-110},{-110,-35},{-101,-35}},
                                          color={0,0,127}));
  connect(minInt1.u1, conInt.y) annotation (Line(points={{38,36},{20,36},{20,40},
          {11,40}}, color={255,127,0}));
  connect(addInt.y, minInt1.u2) annotation (Line(points={{11,0},{20,0},{20,24},
          {38,24}},color={255,127,0}));
  connect(minInt1.y, maxInt.u1) annotation (Line(points={{61,30},{70,30},{70,10},
          {34,10},{34,-34},{38,-34}},   color={255,127,0}));
  connect(minStage.y, maxInt.u2) annotation (Line(points={{61,-90},{70,-90},{70,
          -60},{34,-60},{34,-46},{38,-46}}, color={255,127,0}));
  connect(capReq.yCapReq, staChaPosDis.uCapReq) annotation (Line(points={{-79,-30},
          {-60,-30},{-60,49.5833},{-46.1111,49.5833}},
                                  color={0,0,127}));
  connect(maxInt.y, intToRea.u)
    annotation (Line(points={{61,-40},{68,-40}}, color={255,127,0}));
  connect(intToRea.y, uniDel.u) annotation (Line(points={{91,-40},{100,-40},{
          100,-22},{70,-22},{70,-10},{78,-10}},
                      color={0,0,127}));
  connect(uniDel.y, reaToInt.u)
    annotation (Line(points={{101,-10},{108,-10}},
                                               color={0,0,127}));
  connect(yChiSta, reaToInt.y)
    annotation (Line(points={{150,0},{140,0},{140,-10},{131,-10}},
                                               color={255,127,0}));
  annotation (defaultComponentName = "chiSta",
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
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
Documentation(info="<html>
<p>
Fixme: This needs chattering protection (status hold for a predefined time period)
Not sure if this is the correct place for it.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Status;
