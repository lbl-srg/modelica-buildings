within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Validation;
model SetpointController_noWSE
  "Validates chiller stage status setpoint signal generation for plants without WSE"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(
    have_locSen=true,
    final chiDesCap={500000,700000},
    final chiMinCap={100000,200000},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement})
    "Chiller stage setpoint controller"
    annotation (Placement(transformation(extent={{60,140},{84,178}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon1(
    final have_WSE=false,
    have_locSen=true,
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{0,1,0},{1,1,0},{1,1,1}},
    final chiDesCap={300000,400000,500000},
    final chiMinCap={50000,100000,150000},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
    "Chiller stage setpoint controller"
    annotation (Placement(transformation(extent={{60,-100},{84,-62}})));

protected
  Real TChiWatSupSet(
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

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(final
      trueHoldDuration=100, final falseHoldDuration=0)
    "False hold to visualize the stage change initiation"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold truFalHol1(final
      trueHoldDuration=100, final falseHoldDuration=0)
    "False hold to visualize the stage change initiation"
    annotation (Placement(transformation(extent={{100,-180},{120,-160}})));

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
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    final samplePeriod=10) "Short plant start delay"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Type converter"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt "Type converter"
    annotation (Placement(transformation(extent={{180,140},{200,160}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Pre block"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta(
    final k=true) "Plant status"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10,
    final delayOnInit=true) "True delay"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

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
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol1(
    final samplePeriod=10) "Zero order hold"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea1 "Type converter"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1 "Type converter"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre block"
    annotation (Placement(transformation(extent={{140,-180},{160,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant plaSta1(
    final k=true) "Plant status"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10,
    final delayOnInit=true) "True delay"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

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

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSup(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));

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

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCWSup1(
    final k=273.15 + 14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero1(
    final k=0) "Constant"
    annotation (Placement(transformation(extent={{-200,-180},{-180,-160}})));

equation
  connect(dpChiWatSet.y, staSetCon.dpChiWatPumSet_local) annotation (Line(
        points={{-98,70},{-92,70},{-92,158.095},{57.6,158.095}}, color={0,0,127}));
  connect(dpChiWat.y, staSetCon.dpChiWatPum_local) annotation (Line(points={{-98,20},
          {-90,20},{-90,156.286},{57.6,156.286}},         color={0,0,127}));
  connect(TCWSupSet.y, staSetCon.TChiWatSupSet) annotation (Line(points={{-98,170},
          {-32,170},{-32,166.238},{57.6,166.238}},
                                 color={0,0,127}));
  connect(chiAva.y, staSetCon.uChiAva) annotation (Line(points={{-98,210},{-28,
          210},{-28,173.476},{57.6,173.476}},
                        color={255,0,255}));
  connect(TCWSup.y, staSetCon.TChiWatSup) annotation (Line(points={{-98,110},{
          -94,110},{-94,164.429},{57.6,164.429}},
                             color={0,0,127}));
  connect(zero.y, max.u2) annotation (Line(points={{-178,70},{-170,70},{-170,84},
          {-162,84}},  color={0,0,127}));
  connect(chiWatFlow.y, max.u1) annotation (Line(points={{-178,110},{-170,110},{
          -170,96},{-162,96}},   color={0,0,127}));
  connect(staSetCon.VChiWat_flow, max.y) annotation (Line(points={{57.6,140.905},
          {-130,140.905},{-130,90},{-138,90}},
                            color={0,0,127}));
  connect(TChiWatRet.y, staSetCon.TChiWatRet) annotation (Line(points={{-178,
          150},{-130,150},{-130,144.524},{57.6,144.524}},
                                  color={0,0,127}));
  connect(staSetCon.ySta, intToRea.u)
    annotation (Line(points={{86.4,149.952},{92,149.952},{92,150},{98,150}},
                                               color={255,127,0}));
  connect(intToRea.y, zerOrdHol.u)
    annotation (Line(points={{122,150},{138,150}},
                                                 color={0,0,127}));
  connect(zerOrdHol.y, reaToInt.u)
    annotation (Line(points={{162,150},{178,150}},
                                                 color={0,0,127}));
  connect(reaToInt.y, staSetCon.uSta) annotation (Line(points={{202,150},{210,
          150},{210,100},{50,100},{50,168.952},{57.6,168.952}},
                                                         color={255,127,0}));
  connect(staSetCon.yChaEdg, truFalHol.u) annotation (Line(points={{86.4,
          165.333},{90,165.333},{90,70},{98,70}},
                                    color={255,0,255}));
  connect(truFalHol.y, pre.u)
    annotation (Line(points={{122,70},{138,70}},   color={255,0,255}));
  connect(pre.y, staSetCon.chaPro) annotation (Line(points={{162,70},{170,70},{
          170,50},{40,50},{40,175.286},{57.6,175.286}},
                                     color={255,0,255}));
  connect(plaSta.y, truDel.u)
    annotation (Line(points={{-38,70},{-22,70}}, color={255,0,255}));
  connect(truDel.y, staSetCon.uPla) annotation (Line(points={{2,70},{34,70},{34,
          171.667},{57.6,171.667}},
                    color={255,0,255}));
  connect(dpChiWatSet1.y, staSetCon1.dpChiWatPumSet_local) annotation (Line(
        points={{-98,-170},{-92,-170},{-92,-81.9048},{57.6,-81.9048}}, color={0,
          0,127}));
  connect(dpChiWat1.y, staSetCon1.dpChiWatPum_local) annotation (Line(points={{-98,
          -220},{-90,-220},{-90,-83.7143},{57.6,-83.7143}},     color={0,0,127}));
  connect(TCWSupSet1.y, staSetCon1.TChiWatSupSet) annotation (Line(points={{-98,-70},
          {-32,-70},{-32,-73.7619},{57.6,-73.7619}},
                                         color={0,0,127}));
  connect(chiAva1.y, staSetCon1.uChiAva) annotation (Line(points={{-98,-30},{
          -28,-30},{-28,-66.5238},{57.6,-66.5238}},
                                 color={255,0,255}));
  connect(TCWSup1.y, staSetCon1.TChiWatSup) annotation (Line(points={{-98,-130},
          {-94,-130},{-94,-75.5714},{57.6,-75.5714}},
                                     color={0,0,127}));
  connect(zero1.y, max1.u2) annotation (Line(points={{-178,-170},{-170,-170},{
          -170,-156},{-162,-156}}, color={0,0,127}));
  connect(chiWatFlow1.y, max1.u1) annotation (Line(points={{-178,-130},{-170,
          -130},{-170,-144},{-162,-144}}, color={0,0,127}));
  connect(staSetCon1.VChiWat_flow, max1.y) annotation (Line(points={{57.6,
          -99.0952},{-130,-99.0952},{-130,-150},{-138,-150}},
                                         color={0,0,127}));
  connect(TChiWatRet1.y, staSetCon1.TChiWatRet) annotation (Line(points={{-178,
          -90},{-130,-90},{-130,-95.4762},{57.6,-95.4762}},
                                          color={0,0,127}));
  connect(staSetCon1.ySta, intToRea1.u)
    annotation (Line(points={{86.4,-90.0476},{92,-90.0476},{92,-90},{98,-90}},
                                                 color={255,127,0}));
  connect(intToRea1.y, zerOrdHol1.u)
    annotation (Line(points={{122,-90},{138,-90}}, color={0,0,127}));
  connect(zerOrdHol1.y, reaToInt1.u)
    annotation (Line(points={{162,-90},{178,-90}}, color={0,0,127}));
  connect(reaToInt1.y, staSetCon1.uSta) annotation (Line(points={{202,-90},{210,
          -90},{210,-140},{50,-140},{50,-71.0476},{57.6,-71.0476}},
                                                                color={255,127,0}));
  connect(staSetCon1.yChaEdg, truFalHol1.u) annotation (Line(points={{86.4,
          -74.6667},{90,-74.6667},{90,-170},{98,-170}},
                                         color={255,0,255}));
  connect(truFalHol1.y, pre1.u)
    annotation (Line(points={{122,-170},{138,-170}}, color={255,0,255}));
  connect(pre1.y, staSetCon1.chaPro) annotation (Line(points={{162,-170},{170,
          -170},{170,-190},{40,-190},{40,-64.7143},{57.6,-64.7143}},
                                                    color={255,0,255}));
  connect(plaSta1.y, truDel1.u)
    annotation (Line(points={{-38,-170},{-22,-170}}, color={255,0,255}));
  connect(truDel1.y, staSetCon1.uPla) annotation (Line(points={{2,-170},{34,
          -170},{34,-68.3333},{57.6,-68.3333}},
                            color={255,0,255}));
annotation (
 experiment(
      StopTime=14000,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Validation/SetpointController_noWSE.mos"
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
end SetpointController_noWSE;
