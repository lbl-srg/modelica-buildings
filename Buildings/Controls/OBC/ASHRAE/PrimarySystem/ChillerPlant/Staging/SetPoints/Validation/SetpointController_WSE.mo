within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Validation;
model SetpointController_WSE
  "Validates chiller stage status setpoint signal generation for plants with WSE"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(
    final have_WSE=true,
    final have_locSen=true,
    final chiDesCap={500000,700000},
    final chiMinCap={100000,200000},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement})
    "Chiller stage setpoint controller"
    annotation (Placement(transformation(extent={{60,140},{80,180}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon1(
    final have_WSE=true,
    final have_locSen=true,
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{0,1,0},{1,1,0},{1,1,1}},
    final chiDesCap={300000,400000,500000},
    final chiMinCap={50000,100000,150000},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
    "Chiller stage setpoint controller"
    annotation (Placement(transformation(extent={{60,-100},{80,-60}})));

protected
  parameter Real TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=285.15
    "Chilled water supply set temperature";

  parameter Real aveTChiWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")=288.15
    "Average measured chilled water return temperature";

  parameter Real minStaRuntime(
    final unit="s",
    final quantity="Time",
    displayUnit="h")=900
      "Minimum stage runtime";

  parameter Real aveVChiWat_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    displayUnit="m3/s")=0.05
      "Average measured chilled water flow rate";

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet(
    final amplitude=7,
    final offset=273.15 + 15,
    final freqHz=1/21600)
    "Chilled water return temeprature"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow(
    final offset=0,
    final freqHz=1/21600,
    final amplitude=0.037)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva[2](
    final k={true,true})
    "Chiller availability vector"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));

  Buildings.Controls.OBC.CDL.Reals.Max max "Maximum"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=10) "Zero order hold"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    "Integer to real conversion"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{180,140},{200,160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=100,
    final falseHoldDuration=0)
    "True hold to visualize the stage change initiation"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Pre block"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta(
    final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10,
    final delayOnInit=true) "True delay"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter wseTPre(
    final p=-3) "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TCWSup(
    final height=-2.1,
    final duration=300,
    final offset=273.15 + 16,
    final startTime=1500) "Chilled water supply temperature ramp"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable wseSta(
    final table=[0,1; 1500,1; 1500,0; 12500,0;
        12500,1; 14000,1], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments)
    "WSE is on during low loads, off during high loads"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.5) "Greater threshold"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin TChiWatRet1(
    final amplitude=7,
    final offset=273.15 + 15,
    final freqHz=1/21600)
    "Chilled water return temeprature"
    annotation (Placement(transformation(extent={{-200,-100},{-180,-80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiWatFlow1(
    final offset=0,
    final freqHz=1/21600,
    final amplitude=0.037)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva1[3](
    final k={true,true,true})
    "Chiller availability vector"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Max max1 "Maximum"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10) "Zero order hold"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    "Type converter"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Type converter"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(final
      trueHoldDuration=100, final falseHoldDuration=0)
    "True hold to visualize the stage change initiation"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Logical pre"
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta1(
    final k=true) "Plant status"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10,
    final delayOnInit=true) "True delay"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter wseTPre1(
    final p=-3)
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp TCWSup1(
    final height=-2.1,
    final duration=300,
    final offset=273.15 + 16,
    final startTime=1500) "Chilled water supply temperature ramp"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable wseSta1(
    final table=[0,1; 1500,1; 1500,0; 12500,0;
        12500,1; 14000,1], smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.LinearSegments)
    "WSE is on during low loads, off during high loads"
    annotation (Placement(transformation(extent={{-60,-220},{-40,-200}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr1(
    final t=0.5) "Greater than threshold"
    annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWat(
    final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp maxTowFanSpe(
    final height=-0.05,
    final duration=60,
    final offset=1,
    final startTime=13000) "Constant"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWat1(
    final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,-230},{-100,-210}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero1(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp maxTowFanSpe1(
    final height=-0.05,
    final duration=60,
    final offset=1,
    final startTime=13000) "Constant"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant tunPar(
    final k=0.06)
    "Assume a constant tuning parameter"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter TOutWet(
    final p=-10)
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter TOutWet1(
    final p=-10)
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

equation
  connect(dpChiWatSet.y, staSetCon.dpChiWatPumSet_local) annotation (Line(
        points={{-98,70},{-92,70},{-92,159.048},{58,159.048}},   color={0,0,127}));
  connect(dpChiWat.y, staSetCon.dpChiWatPum_local) annotation (Line(points={{-98,20},
          {-90,20},{-90,157.143},{58,157.143}},           color={0,0,127}));
  connect(chiAva.y,staSetCon. uChiAva) annotation (Line(points={{-98,210},{-28,
          210},{-28,175.238},{58,175.238}},
                        color={255,0,255}));
  connect(zero.y,max. u2) annotation (Line(points={{-178,70},{-170,70},{-170,
          104},{-162,104}},
                       color={0,0,127}));
  connect(chiWatFlow.y,max. u1) annotation (Line(points={{-178,110},{-170,110},
          {-170,116},{-162,116}},color={0,0,127}));
  connect(staSetCon.VChiWat_flow,max. y) annotation (Line(points={{58,140.952},
          {-130,140.952},{-130,110},{-138,110}},
                            color={0,0,127}));
  connect(TChiWatRet.y,staSetCon. TChiWatRet) annotation (Line(points={{-178,
          150},{-130,150},{-130,144.762},{58,144.762}},
                                  color={0,0,127}));
  connect(staSetCon.ySta,intToRea. u)
    annotation (Line(points={{82,150.476},{92,150.476},{92,150},{98,150}},
                                               color={255,127,0}));
  connect(intToRea.y,zerOrdHol. u)
    annotation (Line(points={{122,150},{138,150}},
                                                 color={0,0,127}));
  connect(zerOrdHol.y,reaToInt. u)
    annotation (Line(points={{162,150},{178,150}},
                                                 color={0,0,127}));
  connect(reaToInt.y, staSetCon.uSta) annotation (Line(points={{202,150},{210,
          150},{210,100},{50,100},{50,170.476},{58,170.476}},
                                                         color={255,127,0}));
  connect(staSetCon.yChaEdg, truFalHol.u) annotation (Line(points={{82,166.667},
          {90,166.667},{90,70},{98,70}},
                                    color={255,0,255}));
  connect(truFalHol.y,pre. u)
    annotation (Line(points={{122,70},{138,70}},   color={255,0,255}));
  connect(pre.y,staSetCon. chaPro) annotation (Line(points={{162,70},{170,70},{
          170,50},{36,50},{36,177.143},{58,177.143}},
                                     color={255,0,255}));
  connect(truDel.y,staSetCon. uPla) annotation (Line(points={{2,60},{30,60},{30,
          173.333},{58,173.333}},
                    color={255,0,255}));
  connect(maxTowFanSpe.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{-138,
          190},{34,190},{34,147.619},{58,147.619}},
                                       color={0,0,127}));
  connect(TCWSupSet.y, wseTPre.u) annotation (Line(points={{-98,170},{-80,170},
          {-80,216},{-16,216},{-16,210},{-2,210}}, color={0,0,127}));
  connect(TCWSupSet.y, staSetCon.TChiWatSupSet) annotation (Line(points={{-98,170},
          {-20,170},{-20,167.619},{58,167.619}},
                                        color={0,0,127}));
  connect(TCWSup.y, staSetCon.TChiWatSup) annotation (Line(points={{-98,110},{
          -70,110},{-70,165.714},{58,165.714}},    color={0,0,127}));
  connect(greThr.y, staSetCon.uWseSta) annotation (Line(points={{2,20},{32,20},
          {32,179.048},{58,179.048}},
                          color={255,0,255}));
  connect(dpChiWatSet1.y, staSetCon1.dpChiWatPumSet_local) annotation (Line(
        points={{-98,-170},{-92,-170},{-92,-80.9524},{58,-80.9524}},   color={0,
          0,127}));
  connect(dpChiWat1.y, staSetCon1.dpChiWatPum_local) annotation (Line(points={{-98,
          -220},{-88,-220},{-88,-82.8571},{58,-82.8571}},       color={0,0,127}));
  connect(chiAva1.y, staSetCon1.uChiAva) annotation (Line(points={{-98,-30},{
          -28,-30},{-28,-64.7619},{58,-64.7619}},
                                 color={255,0,255}));
  connect(zero1.y, max1.u2) annotation (Line(points={{-178,-170},{-170,-170},{
          -170,-136},{-162,-136}}, color={0,0,127}));
  connect(chiWatFlow1.y, max1.u1) annotation (Line(points={{-178,-130},{-170,
          -130},{-170,-124},{-162,-124}}, color={0,0,127}));
  connect(staSetCon1.VChiWat_flow, max1.y) annotation (Line(points={{58,
          -99.0476},{-130,-99.0476},{-130,-130},{-138,-130}},
                                         color={0,0,127}));
  connect(TChiWatRet1.y, staSetCon1.TChiWatRet) annotation (Line(points={{-178,
          -90},{-130,-90},{-130,-95.2381},{58,-95.2381}},
                                          color={0,0,127}));
  connect(staSetCon1.ySta, intToRea1.u)
    annotation (Line(points={{82,-89.5238},{92,-89.5238},{92,-90},{98,-90}},
                                                 color={255,127,0}));
  connect(intToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{122,-90},{138,-90}}, color={0,0,127}));
  connect(zerOrdHol1.y, reaToInt1.u)
    annotation (Line(points={{162,-90},{178,-90}}, color={0,0,127}));
  connect(reaToInt1.y, staSetCon1.uSta) annotation (Line(points={{202,-90},{210,
          -90},{210,-140},{50,-140},{50,-69.5238},{58,-69.5238}},
                                                                color={255,127,0}));
  connect(staSetCon1.yChaEdg, truFalHol1.u) annotation (Line(points={{82,
          -73.3333},{90,-73.3333},{90,-170},{98,-170}},
                                         color={255,0,255}));
  connect(truFalHol1.y, pre1.u)
    annotation (Line(points={{122,-170},{138,-170}}, color={255,0,255}));
  connect(pre1.y, staSetCon1.chaPro) annotation (Line(points={{162,-170},{170,
          -170},{170,-190},{36,-190},{36,-62.8571},{58,-62.8571}},
                                                    color={255,0,255}));
  connect(plaSta1.y, truDel1.u)
    annotation (Line(points={{-38,-170},{-22,-170}}, color={255,0,255}));
  connect(truDel1.y, staSetCon1.uPla) annotation (Line(points={{2,-170},{26,
          -170},{26,-66.6667},{58,-66.6667}},
                            color={255,0,255}));
  connect(maxTowFanSpe1.y, staSetCon1.uTowFanSpeMax) annotation (Line(points={{-138,
          -50},{34,-50},{34,-92.381},{58,-92.381}},
                                            color={0,0,127}));
  connect(TCWSupSet1.y, wseTPre1.u) annotation (Line(points={{-98,-70},{-80,-70},
          {-80,-24},{-16,-24},{-16,-30},{-2,-30}}, color={0,0,127}));
  connect(staSetCon1.TWsePre, wseTPre1.y) annotation (Line(points={{58,-97.1429},
          {30,-97.1429},{30,-30},{22,-30}},     color={0,0,127}));
  connect(TCWSupSet1.y, staSetCon1.TChiWatSupSet) annotation (Line(points={{-98,-70},
          {-20,-70},{-20,-72.381},{58,-72.381}},
                                         color={0,0,127}));
  connect(TCWSup1.y, staSetCon1.TChiWatSup) annotation (Line(points={{-98,-130},
          {-70,-130},{-70,-74.2857},{58,-74.2857}},
                                     color={0,0,127}));
  connect(wseSta1.y[1], greThr1.u)
    annotation (Line(points={{-38,-210},{-22,-210}}, color={0,0,127}));
  connect(greThr1.y, staSetCon1.uWseSta) annotation (Line(points={{2,-210},{32,
          -210},{32,-60.9524},{58,-60.9524}},
                                color={255,0,255}));
  connect(plaSta.y, truDel.u) annotation (Line(points={{-38,60},{-22,60}},
                     color={255,0,255}));
  connect(wseSta.y[1], greThr.u)
    annotation (Line(points={{-38,20},{-22,20}}, color={0,0,127}));
  connect(tunPar.y, staSetCon.uTunPar) annotation (Line(points={{-38,100},{20,
          100},{20,149.524},{58,149.524}},
                                color={0,0,127}));
  connect(tunPar.y, staSetCon1.uTunPar) annotation (Line(points={{-38,100},{40,
          100},{40,-90.4762},{58,-90.4762}},
                                color={0,0,127}));
  connect(TCWSupSet.y, TOutWet.u) annotation (Line(points={{-98,170},{-80,170},{
          -80,130},{-62,130}}, color={0,0,127}));
  connect(TOutWet.y, staSetCon.TOutWet) annotation (Line(points={{-38,130},{0,
          130},{0,151.429},{58,151.429}},
                                       color={0,0,127}));
  connect(wseTPre.y, staSetCon.TWsePre) annotation (Line(points={{22,210},{40,
          210},{40,142.857},{58,142.857}},
                                        color={0,0,127}));
  connect(TCWSupSet1.y, TOutWet1.u) annotation (Line(points={{-98,-70},{-80,-70},
          {-80,-120},{-62,-120}}, color={0,0,127}));
  connect(TOutWet1.y, staSetCon1.TOutWet) annotation (Line(points={{-38,-120},{
          28,-120},{28,-88.5714},{58,-88.5714}},
                                              color={0,0,127}));
annotation (
 experiment(StopTime=14000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Validation/SetpointController_WSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-240},{220,240}})));
end SetpointController_WSE;
