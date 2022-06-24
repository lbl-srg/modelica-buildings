within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Validation;
model OutdoorAirFlow
  "Validate the sequences of setting AHU level minimum outdoor airflow rate"

  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zon1(
    AFlo=40,
    have_winSen=false,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 1"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zon2(
    AFlo=35,
    desZonPop=4,
    minZonPriFlo=0.08) "Outdoor airflow related calculations for zone 2"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zon3(
    AFlo=30,
    desZonPop=3,
    minZonPriFlo=0.06) "Outdoor airflow related calculations for zone 3"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
    ahu1(VPriSysMax_flow=0.6, peaSysPop=12)
    "AHU level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,40},{240,60}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToAhu(final numZon=3) "From zone level to AHU level"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant supFan(k=true)
    "Status of supply fan"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc2(
    duration=3600,
    height=3)
    "Occupant number in zone 2"
    annotation (Placement(transformation(extent={{-260,170},{-240,190}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,170},{-200,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc3(
    duration=3600,
    height=3,
    startTime=900) "Occupant number in zone 3"
    annotation (Placement(transformation(extent={{-260,30},{-240,50}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,30},{-200,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta(k=false)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse winSta1(period=3600)
    "Status of windows"
    annotation (Placement(transformation(extent={{-220,-140},{-200,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc4(
    duration=3600,
    startTime=900,
    height=2) "Occupant number"
    annotation (Placement(transformation(extent={{-260,-90},{-240,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=280.15,
    duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-260,130},{-240,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TDis(
    height=4,
    duration=3600,
    offset=281.15) "Terminal unit discharge air temperature"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat(k=0.1)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,80},{-240,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat1(k=0.12)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPriFloRat2(k=0.09)
    "Measured primary flow rate at VAV box"
    annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));

equation
  connect(zon1.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[1]) annotation (Line(
        points={{-98,119},{-44,119},{-44,56.6667},{138,56.6667}}, color={0,0,127}));
  connect(zon2.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[2]) annotation (Line(
        points={{-98,9},{-20,9},{-20,58},{138,58}},     color={0,0,127}));
  connect(zon3.yDesZonPeaOcc,zonToAhu. uDesZonPeaOcc[3]) annotation (Line(
        points={{-98,-101},{42,-101},{42,59.3333},{138,59.3333}},   color={0,0,127}));
  connect(zon1.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[1]) annotation (
      Line(points={{-98,116},{-50,116},{-50,54.6667},{138,54.6667}}, color={0,0,127}));
  connect(zon2.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[2]) annotation (
      Line(points={{-98,6},{-12,6},{-12,56},{138,56}},     color={0,0,127}));
  connect(zon3.VDesPopBreZon_flow,zonToAhu. VDesPopBreZon_flow[3]) annotation (
      Line(points={{-98,-104},{48,-104},{48,57.3333},{138,57.3333}},   color={0,0,127}));
  connect(zon1.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[1]) annotation (
      Line(points={{-98,113},{-56,113},{-56,52.6667},{138,52.6667}}, color={0,0,127}));
  connect(zon2.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[2]) annotation (
      Line(points={{-98,3},{-6,3},{-6,54},{138,54}},       color={0,0,127}));
  connect(zon3.VDesAreBreZon_flow,zonToAhu. VDesAreBreZon_flow[3]) annotation (
      Line(points={{-98,-107},{54,-107},{54,55.3333},{138,55.3333}},   color={0,0,127}));
  connect(zon1.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[1]) annotation (Line(
        points={{-98,110},{-62,110},{-62,46.6667},{138,46.6667}}, color={0,0,127}));
  connect(zon2.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[2]) annotation (Line(
        points={{-98,0},{2,0},{2,48},{138,48}}, color={0,0,127}));
  connect(zon3.yDesPriOutAirFra,zonToAhu. uDesPriOutAirFra[3]) annotation (Line(
        points={{-98,-110},{60,-110},{60,49.3333},{138,49.3333}},   color={0,0,127}));
  connect(zon1.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[1]) annotation (Line(
        points={{-98,107},{-68,107},{-68,44.6667},{138,44.6667}}, color={0,0,127}));
  connect(zon2.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[2]) annotation (Line(
        points={{-98,-3},{8,-3},{8,46},{138,46}}, color={0,0,127}));
  connect(zon3.VUncOutAir_flow,zonToAhu. VUncOutAir_flow[3]) annotation (Line(
        points={{-98,-113},{66,-113},{66,47.3333},{138,47.3333}}, color={0,0,127}));
  connect(zon1.yPriOutAirFra,zonToAhu. uPriOutAirFra[1]) annotation (Line(
        points={{-98,104},{-74,104},{-74,42.6667},{138,42.6667}}, color={0,0,127}));
  connect(zon2.yPriOutAirFra,zonToAhu. uPriOutAirFra[2]) annotation (Line(
        points={{-98,-6},{14,-6},{14,44},{138,44}}, color={0,0,127}));
  connect(zon3.yPriOutAirFra,zonToAhu. uPriOutAirFra[3]) annotation (Line(
        points={{-98,-116},{74,-116},{74,45.3333},{138,45.3333}}, color={0,0,127}));
  connect(zon1.VPriAir_flow,zonToAhu. VPriAir_flow[1]) annotation (Line(points={{-98,101},
          {-80,101},{-80,40.6667},{138,40.6667}}, color={0,0,127}));
  connect(zon2.VPriAir_flow,zonToAhu. VPriAir_flow[2]) annotation (Line(points={{-98,-9},
          {20,-9},{20,42},{138,42}}, color={0,0,127}));
  connect(zon3.VPriAir_flow,zonToAhu. VPriAir_flow[3]) annotation (Line(points={{-98,
          -119},{80,-119},{80,43.3333},{138,43.3333}}, color={0,0,127}));
  connect(zonToAhu.ySumDesZonPop,ahu1. sumDesZonPop)
    annotation (Line(points={{162,59},{218,59}}, color={0,0,127}));
  connect(zonToAhu.VSumDesPopBreZon_flow,ahu1. VSumDesPopBreZon_flow)
    annotation (Line(points={{162,56},{180,56},{180,57},{218,57}}, color={0,
          0,127}));
  connect(zonToAhu.VSumDesAreBreZon_flow,ahu1. VSumDesAreBreZon_flow)
    annotation (Line(points={{162,53},{182,53},{182,55},{218,55}}, color={0,
          0,127}));
  connect(zonToAhu.yDesSysVenEff,ahu1. uDesSysVenEff) annotation (Line(points={{162,50},
          {184,50},{184,53},{218,53}}, color={0,0,127}));
  connect(zonToAhu.VSumUncOutAir_flow,ahu1. VSumUncOutAir_flow) annotation (
      Line(points={{162,47},{186,47},{186,51},{218,51}}, color={0,0,127}));
  connect(zonToAhu.uOutAirFra_max,ahu1. uOutAirFra_max) annotation (Line(points={{162,44},
          {190,44},{190,47},{218,47}}, color={0,0,127}));
  connect(zonToAhu.VSumSysPriAir_flow,ahu1. VSumSysPriAir_flow) annotation (
      Line(points={{162,41},{188,41},{188,49},{218,49}}, color={0,0,127}));
  connect(ahu1.yAveOutAirFraPlu,zonToAhu. yAveOutAirFraPlu) annotation (Line(
        points={{242,55},{250,55},{250,170},{120,170},{120,52},{138,52}},
        color={0,0,127}));
  connect(supFan.y,ahu1. uSupFan) annotation (Line(points={{162,-20},{198,-20},{
          198,43},{218,43}}, color={255,0,255}));
  connect(opeMod.y,ahu1. uOpeMod) annotation (Line(points={{162,-60},{202,-60},{
          202,41},{218,41}},   color={255,127,0}));
  connect(ahu1.yReqOutAir, zon1.uReqOutAir) annotation (Line(points={{242,42},
          {260,42},{260,174},{-160,174},{-160,113},{-122,113}}, color={255,0,
          255}));
  connect(ahu1.yReqOutAir, zon2.uReqOutAir) annotation (Line(points={{242,42},
          {260,42},{260,174},{-160,174},{-160,3},{-122,3}}, color={255,0,255}));
  connect(ahu1.yReqOutAir, zon3.uReqOutAir) annotation (Line(points={{242,42},
          {260,42},{260,174},{-160,174},{-160,-107},{-122,-107}}, color={255,0,
          255}));
  connect(numOfOcc2.y,reaToInt1. u) annotation (Line(points={{-238,180},{-222,180}},
                 color={0,0,127}));
  connect(numOfOcc3.y, reaToInt2.u)
    annotation (Line(points={{-238,40},{-222,40}}, color={0,0,127}));
  connect(reaToInt1.y, zon1.nOcc) annotation (Line(points={{-198,180},{-166,180},
          {-166,119},{-122,119}}, color={255,127,0}));
  connect(reaToInt2.y, zon2.nOcc) annotation (Line(points={{-198,40},{-180,40},{
          -180,9},{-122,9}},   color={255,127,0}));
  connect(numOfOcc4.y, reaToInt3.u)
    annotation (Line(points={{-238,-80},{-222,-80}}, color={0,0,127}));
  connect(reaToInt3.y, zon3.nOcc) annotation (Line(points={{-198,-80},{-180,-80},
          {-180,-101},{-122,-101}}, color={255,127,0}));
  connect(winSta1.y, zon3.uWin) annotation (Line(points={{-198,-130},{-180,-130},
          {-180,-104},{-122,-104}}, color={255,0,255}));
  connect(winSta.y, zon2.uWin) annotation (Line(points={{-198,0},{-180,0},{-180,
          6},{-122,6}},   color={255,0,255}));
  connect(TZon.y, zon1.TZon) annotation (Line(points={{-238,140},{-174,140},{-174,
          110},{-122,110}}, color={0,0,127}));
  connect(TZon.y, zon2.TZon) annotation (Line(points={{-238,140},{-174,140},{-174,
          0},{-122,0}}, color={0,0,127}));
  connect(TZon.y, zon3.TZon) annotation (Line(points={{-238,140},{-174,140},{-174,
          -110},{-122,-110}}, color={0,0,127}));
  connect(TDis.y, zon1.TDis) annotation (Line(points={{-198,120},{-170,120},{-170,
          107},{-122,107}}, color={0,0,127}));
  connect(TDis.y, zon2.TDis) annotation (Line(points={{-198,120},{-170,120},{-170,
          -3},{-122,-3}}, color={0,0,127}));
  connect(TDis.y, zon3.TDis) annotation (Line(points={{-198,120},{-170,120},{-170,
          -113},{-122,-113}}, color={0,0,127}));
  connect(zonPriFloRat2.y, zon3.VDis_flow) annotation (Line(points={{-238,-160},
          {-166,-160},{-166,-116},{-122,-116}}, color={0,0,127}));
  connect(zonPriFloRat1.y, zon2.VDis_flow) annotation (Line(points={{-238,-30},{
          -166,-30},{-166,-6},{-122,-6}}, color={0,0,127}));
  connect(zonPriFloRat.y, zon1.VDis_flow) annotation (Line(points={{-238,90},{-166,
          90},{-166,104},{-122,104}}, color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon1.VUncOut_flow_nominal) annotation (Line(
        points={{242,58},{246,58},{246,168},{-154,168},{-154,101},{-122,101}},
        color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon2.VUncOut_flow_nominal) annotation (Line(
        points={{242,58},{246,58},{246,168},{-154,168},{-154,-9},{-122,-9}},
        color={0,0,127}));
  connect(ahu1.VDesUncOutAir_flow, zon3.VUncOut_flow_nominal) annotation (Line(
        points={{242,58},{246,58},{246,168},{-154,168},{-154,-119},{-122,-119}},
        color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/VAV/SetPoints/OutdoorAirFlow/Validation/OutdoorAirFlow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This model shows how to compose the subsequences to find the minimum outdoor
airflow setpoint of an AHU unit that serves three zones.
</p>
<ul>
<li>
The blocks <code>zon1</code>, <code>zon2</code> and <code>zon3</code> which
instantiate
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone</a>,
calculate the zone level minimum outdoor airflow setpoints.
</li>
<li>
The block <code>zonToAhu</code> which instantiates
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone</a>,
finds the sum, minimum and maximum of the zone level setpoints.
</li>
<li>
The AHU level minimum outdoor airflow setpoint is then specified by block <code>ahu1</code>.
See <a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU</a>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 14, 2020, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-280,-200},{280,200}})));
end OutdoorAirFlow;
