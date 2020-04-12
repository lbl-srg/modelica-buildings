within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Change_WSE
  "Validates chiller stage status setpoint signal generation for plants with WSE"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Modelica.SIunits.Time minStaRuntime = 900
    "Minimum stage runtime";

  parameter Modelica.SIunits.VolumeFlowRate aveVChiWat_flow = 0.05
    "Average measured chilled water flow rate";

  Change                                                                               cha(
    have_WSE=true,
    nSta=5,
    nChi=3,
    staMat=[1,0,0; 0,1,0; 0,0,1; 0,1,1; 1,1,1],
    final chiDesCap={300000,400000,500000},
    final chiMinCap={100000,120000,150000},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
    "Stage change"
    annotation (Placement(transformation(extent={{60,140},{80,160}})));
  CDL.Continuous.Sources.Sine                        TChiWatRet(
    final amplitude=7,
    final offset=273.15 + 15,
    final freqHz=1/21600)
    "Chiller water return temeprature"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  CDL.Continuous.Sources.Sine                        chiWatFlow(
    final offset=0,
    final freqHz=1/21600,
    final amplitude=0.037)
    "Chilled water flow"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  CDL.Logical.Sources.Constant                        chiAva[3](final k={true,true,
        true})
    "Chiller availability vector"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  CDL.Continuous.Max                        max "Maximum"
    annotation (Placement(transformation(extent={{-162,100},{-142,120}})));
  CDL.Discrete.ZeroOrderHold                        zerOrdHol(samplePeriod=10)
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Conversions.IntegerToReal                        intToRea
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  CDL.Conversions.RealToInteger                        reaToInt
    annotation (Placement(transformation(extent={{180,140},{200,160}})));
  CDL.Logical.TrueFalseHold                        truFalHol(trueHoldDuration=0,
      falseHoldDuration=900)
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  CDL.Logical.Pre                        pre
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
  CDL.Logical.Sources.Constant                        plaSta(final k=true)
    "Plant status"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Integers.Sources.Constant                        conInt(k=0)
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  CDL.Logical.TrueDelay truDel(delayTime=10, delayOnInit=true)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Logical.Sources.Constant wseSta(final k=true) "WSE status"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  CDL.Continuous.AddParameter wseTPre(p=-3, k=1)
    "Predicted WSE outlet temperature"
    annotation (Placement(transformation(extent={{0,200},{20,220}})));
protected
  CDL.Continuous.Sources.Constant                        dpChiWat(final k=65*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Continuous.Sources.Constant                        TCWSupSet(final k=273.15
         + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  CDL.Continuous.Sources.Constant                        dpChiWatSet(final k=65*
        6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Sources.Constant                        TCWSup(final k=273.15 +
        14)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  CDL.Continuous.Sources.Constant                        zero(final k=0)
    "Constant"
    annotation (Placement(transformation(extent={{-200,60},{-180,80}})));
  CDL.Continuous.Sources.Constant maxTowFanSpe(final k=1) "Constant"
    annotation (Placement(transformation(extent={{-160,180},{-140,200}})));
equation
  connect(dpChiWatSet.y,cha. dpChiWatPumSet) annotation (Line(points={{-98,70},{
          -92,70},{-92,151},{58,151}}, color={0,0,127}));
  connect(dpChiWat.y,cha. dpChiWatPum) annotation (Line(points={{-98,20},{-90,20},
          {-90,153},{58,153}},     color={0,0,127}));
  connect(TCWSupSet.y,cha. TChiWatSupSet) annotation (Line(points={{-98,170},{-32,
          170},{-32,165},{58,165}},
                                 color={0,0,127}));
  connect(chiAva.y,cha. uChiAva) annotation (Line(points={{-98,210},{-28,210},{-28,
          131},{58,131}},
                        color={255,0,255}));
  connect(TCWSup.y,cha. TChiWatSup) annotation (Line(points={{-98,110},{-94,110},
          {-94,163},{58,163}},
                             color={0,0,127}));
  connect(zero.y,max. u2) annotation (Line(points={{-178,70},{-170,70},{-170,
          104},{-164,104}},
                       color={0,0,127}));
  connect(chiWatFlow.y,max. u1) annotation (Line(points={{-178,110},{-170,110},
          {-170,116},{-164,116}},color={0,0,127}));
  connect(cha.VChiWat_flow,max. y) annotation (Line(points={{58,141},{-130,141},
          {-130,110},{-140,110}},
                            color={0,0,127}));
  connect(TChiWatRet.y,cha. TChiWatRet) annotation (Line(points={{-178,150},{-130,
          150},{-130,145},{58,145}},
                                  color={0,0,127}));
  connect(cha.ySta,intToRea. u)
    annotation (Line(points={{82,150},{98,150}},
                                               color={255,127,0}));
  connect(intToRea.y,zerOrdHol. u)
    annotation (Line(points={{122,150},{138,150}},
                                                 color={0,0,127}));
  connect(zerOrdHol.y,reaToInt. u)
    annotation (Line(points={{162,150},{178,150}},
                                                 color={0,0,127}));
  connect(reaToInt.y,cha. u) annotation (Line(points={{202,150},{210,150},{210,100},
          {50,100},{50,139},{58,139}},
                                     color={255,127,0}));
  connect(cha.y,truFalHol. u) annotation (Line(points={{82,143},{90,143},{90,70},
          {98,70}},  color={255,0,255}));
  connect(truFalHol.y,pre. u)
    annotation (Line(points={{122,70},{138,70}},   color={255,0,255}));
  connect(pre.y,cha. chaPro) annotation (Line(points={{162,70},{170,70},{170,50},
          {40,50},{40,133},{58,133}},color={255,0,255}));
  connect(cha.uIni,conInt. y) annotation (Line(points={{58,137.2},{28,137.2},{28,
          110},{2,110}},
                    color={255,127,0}));
  connect(plaSta.y,truDel. u)
    annotation (Line(points={{-38,70},{-22,70}}, color={255,0,255}));
  connect(truDel.y,cha. uPla) annotation (Line(points={{2,70},{34,70},{34,129},{
          58,129}}, color={255,0,255}));
  connect(cha.uWseSta, wseSta.y) annotation (Line(points={{58,135},{-26,135},{
          -26,120},{-38,120}}, color={255,0,255}));
  connect(maxTowFanSpe.y, cha.uTowFanSpeMax) annotation (Line(points={{-138,190},
          {34,190},{34,148},{58,148}}, color={0,0,127}));
  connect(TCWSupSet.y, wseTPre.u) annotation (Line(points={{-98,170},{-76,170},
          {-76,216},{-16,216},{-16,210},{-2,210}}, color={0,0,127}));
  connect(cha.TWsePre, wseTPre.y) annotation (Line(points={{58,143},{42,143},{
          42,142},{30,142},{30,210},{22,210}}, color={0,0,127}));
annotation (
 experiment(StopTime=20000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Change_WSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Change</a>.
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
end Change_WSE;
