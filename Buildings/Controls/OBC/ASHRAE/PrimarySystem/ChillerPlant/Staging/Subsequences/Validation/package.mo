within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
package Validation "Collection of validation models"
  model PartLoadRatios_u_uTyp
    "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

    parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
    "Chilled water supply set temperature";

    parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
    "Average measured chilled water return temperature";

    parameter Integer nSta = 3
      "Total number of stages";

    parameter Real aveVChiWat_flow(
      final quantity="VolumeFlowRate",
      final unit="m3/s") = 0.05
      "Average measured chilled water flow rate";

    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs0(
      final anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-260,190},{-240,210}})));

    Buildings.Controls.OBC.CDL.Continuous.Max max
      annotation (Placement(transformation(extent={{-342,350},{-320,370}})));

    PartLoadRatios                                                                               PLRs1(final
        anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
    CDL.Continuous.Max                        max1
      annotation (Placement(transformation(extent={{-122,350},{-100,370}})));
    PartLoadRatios                                                                               PLRs2(final
        anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{180,190},{200,210}})));
    CDL.Continuous.Max                        max2
      annotation (Placement(transformation(extent={{98,350},{120,370}})));
    PartLoadRatios                                                                               PLRs3(final
        anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{420,190},{440,210}})));
    CDL.Continuous.Max                        max3
      annotation (Placement(transformation(extent={{338,350},{360,370}})));
    PartLoadRatios                                                                               PLRs4(final
        anyVsdCen=true, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-260,-170},{-240,-150}})));
    CDL.Continuous.Max                        max4
      annotation (Placement(transformation(extent={{-342,-10},{-320,10}})));
    PartLoadRatios                                                                               PLRs5(final
        anyVsdCen=true, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-40,-170},{-20,-150}})));
    CDL.Continuous.Max                        max5
      annotation (Placement(transformation(extent={{-122,-10},{-100,10}})));
    PartLoadRatios                                                                               PLRs6(final
        anyVsdCen=true, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{180,-170},{200,-150}})));
    CDL.Continuous.Max                        max6
      annotation (Placement(transformation(extent={{98,-10},{120,10}})));
    PartLoadRatios                                                                               PLRs7(final
        anyVsdCen=true, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{420,-170},{440,-150}})));
    CDL.Continuous.Max                        max7
      annotation (Placement(transformation(extent={{338,-10},{360,10}})));
protected
    Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-420,180},{-400,200}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
      amplitude=6e5,
      freqHz=1/1800,
      offset=900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-420,380},{-400,400}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-420,140},{-400,160}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-420,100},{-400,120}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-420,340},{-400,360}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capDes[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-380,300},{-360,320}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capMin[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-380,260},{-360,280}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp[3](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-420,220},{-400,240}})));

    CDL.Integers.Sources.Constant                        curSta1(final k=2)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-200,180},{-180,200}})));
    CDL.Continuous.Sources.Sine                        capReq1(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1400000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-200,380},{-180,400}})));
    CDL.Integers.Sources.Constant                        staUp1(final k=3)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
    CDL.Integers.Sources.Constant                        staDown1(final k=1)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
    CDL.Continuous.Sources.Constant                        lowLim1(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-200,340},{-180,360}})));
    CDL.Continuous.Sources.Constant                        capDes1[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-160,300},{-140,320}})));
    CDL.Continuous.Sources.Constant                        capMin1[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-160,260},{-140,280}})));
    CDL.Integers.Sources.Constant                        curSta2(final k=3)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{20,180},{40,200}})));
    CDL.Continuous.Sources.Sine                        capReq2(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,380},{40,400}})));
    CDL.Integers.Sources.Constant                        staUp2(final k=3)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{20,140},{40,160}})));
    CDL.Integers.Sources.Constant                        staDown2(final k=2)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{20,100},{40,120}})));
    CDL.Continuous.Sources.Constant                        lowLim2(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,340},{40,360}})));
    CDL.Continuous.Sources.Constant                        capDes2[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{60,300},{80,320}})));
    CDL.Continuous.Sources.Constant                        capMin2[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{60,260},{80,280}})));
    CDL.Integers.Sources.Constant                        curSta3(final k=0)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{260,180},{280,200}})));
    CDL.Continuous.Sources.Sine                        capReq4(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{260,380},{280,400}})));
    CDL.Integers.Sources.Constant                        staUp3(final k=1)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{260,140},{280,160}})));
    CDL.Integers.Sources.Constant                        staDown3(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{260,100},{280,120}})));
    CDL.Continuous.Sources.Constant                        lowLim3(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{260,340},{280,360}})));
    CDL.Continuous.Sources.Constant                        capDes3[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{300,300},{320,320}})));
    CDL.Continuous.Sources.Constant                        capMin3[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{300,260},{320,280}})));
protected
    CDL.Integers.Sources.Constant                        curSta4(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-420,-310},{-400,-290}})));
    CDL.Continuous.Sources.Sine                        capReq5(
      amplitude=6e5,
      freqHz=1/1800,
      offset=900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-420,20},{-400,40}})));
    CDL.Integers.Sources.Constant                        staUp4(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-420,-350},{-400,-330}})));
    CDL.Integers.Sources.Constant                        staDown4(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-420,-390},{-400,-370}})));
    CDL.Continuous.Sources.Constant                        lowLim4(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-420,-20},{-400,0}})));
    CDL.Continuous.Sources.Constant                        capDes4
                                                                 [3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-380,-60},{-360,-40}})));
    CDL.Continuous.Sources.Constant                        capMin4
                                                                 [3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-380,-100},{-360,-80}})));
    CDL.Integers.Sources.Constant                        staTyp4
                                                               [3](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-420,-270},{-400,-250}})));
    CDL.Integers.Sources.Constant                        curSta5(final k=2)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-200,-310},{-180,-290}})));
    CDL.Continuous.Sources.Sine                        capReq6(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1400000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-200,20},{-180,40}})));
    CDL.Integers.Sources.Constant                        staUp5(final k=3)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-200,-350},{-180,-330}})));
    CDL.Integers.Sources.Constant                        staDown5(final k=1)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-200,-390},{-180,-370}})));
    CDL.Continuous.Sources.Constant                        lowLim5(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
    CDL.Continuous.Sources.Constant                        capDes5[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));
    CDL.Continuous.Sources.Constant                        capMin5[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
    CDL.Integers.Sources.Constant                        curSta6(final k=3)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{20,-310},{40,-290}})));
    CDL.Continuous.Sources.Sine                        capReq7(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    CDL.Integers.Sources.Constant                        staUp6(final k=3)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{20,-350},{40,-330}})));
    CDL.Integers.Sources.Constant                        staDown6(final k=2)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{20,-390},{40,-370}})));
    CDL.Continuous.Sources.Constant                        lowLim6(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    CDL.Continuous.Sources.Constant                        capDes6[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
    CDL.Continuous.Sources.Constant                        capMin6[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
    CDL.Integers.Sources.Constant                        curSta7(final k=0)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{260,-310},{280,-290}})));
    CDL.Continuous.Sources.Sine                        capReq8(
      amplitude=6e5,
      freqHz=1/1800,
      offset=1900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{260,20},{280,40}})));
    CDL.Integers.Sources.Constant                        staUp7(final k=1)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{260,-350},{280,-330}})));
    CDL.Integers.Sources.Constant                        staDown7(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{260,-390},{280,-370}})));
    CDL.Continuous.Sources.Constant                        lowLim7(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{260,-20},{280,0}})));
    CDL.Continuous.Sources.Constant                        capDes7[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{300,-60},{320,-40}})));
    CDL.Continuous.Sources.Constant                        capMin7[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{300,-100},{320,-80}})));
    CDL.Continuous.Sources.Constant Lift(final k=16) "Chiller lift"
      annotation (Placement(transformation(extent={{-420,-140},{-400,-120}})));
    CDL.Continuous.Sources.Constant LiftMin(final k=10) "Minimum chiller lift"
      annotation (Placement(transformation(extent={{-420,-220},{-400,-200}})));
    CDL.Continuous.Sources.Constant LiftMax(final k=20) "Maximum chiller lift"
      annotation (Placement(transformation(extent={{-420,-180},{-400,-160}})));
  equation

    connect(curSta.y, PLRs0.u) annotation (Line(points={{-398,190},{-261,190}},
                             color={255,127,0}));
    connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-398,150},{-320,150},{-320,
            188},{-261,188}},color={255,127,0}));
    connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-398,110},{-310,110},
            {-310,186},{-261,186}},                   color={255,127,0}));
    connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-317.8,360},{-290,360},
            {-290,213},{-261,213}},
                                 color={0,0,127}));
    connect(capReq3.y, max.u1) annotation (Line(points={{-398,390},{-360,390},{-360,
            366},{-344.2,366}}, color={0,0,127}));
    connect(lowLim.y, max.u2) annotation (Line(points={{-398,350},{-360,350},{-360,
            354},{-344.2,354}}, color={0,0,127}));
    connect(capDes[1].y, PLRs0.uCapDes) annotation (Line(points={{-358,310},{-292,
            310},{-292,211},{-261,211}}, color={0,0,127}));
    connect(capDes[2].y, PLRs0.uUpCapDes) annotation (Line(points={{-358,310},{-292,
            310},{-292,209},{-261,209}}, color={0,0,127}));
    connect(capMin[1].y, PLRs0.uDowCapDes) annotation (Line(points={{-358,270},{-294,
            270},{-294,207},{-261,207}}, color={0,0,127}));
    connect(capMin[1].y, PLRs0.uCapMin) annotation (Line(points={{-358,270},{-294,
            270},{-294,205},{-261,205}}, color={0,0,127}));
    connect(capMin[2].y, PLRs0.uUpCapMin) annotation (Line(points={{-358,270},{-296,
            270},{-296,203},{-261,203}}, color={0,0,127}));
    connect(staTyp.y, PLRs0.uTyp) annotation (Line(points={{-398,230},{-310,230},{
            -310,193},{-261,193}}, color={255,127,0}));
    connect(curSta1.y, PLRs1.u)
      annotation (Line(points={{-178,190},{-41,190}}, color={255,127,0}));
    connect(staUp1.y, PLRs1.uUp) annotation (Line(points={{-178,150},{-100,150},{-100,
            188},{-41,188}}, color={255,127,0}));
    connect(staDown1.y, PLRs1.uDown) annotation (Line(points={{-178,110},{-90,110},
            {-90,186},{-41,186}},color={255,127,0}));
    connect(max1.y, PLRs1.uCapReq) annotation (Line(points={{-97.8,360},{-70,360},
            {-70,213},{-41,213}}, color={0,0,127}));
    connect(capReq1.y, max1.u1) annotation (Line(points={{-178,390},{-140,390},{-140,
            366},{-124.2,366}}, color={0,0,127}));
    connect(lowLim1.y, max1.u2) annotation (Line(points={{-178,350},{-140,350},{-140,
            354},{-124.2,354}}, color={0,0,127}));
    connect(capDes1[2].y, PLRs1.uCapDes) annotation (Line(points={{-138,310},{-72,
            310},{-72,211},{-41,211}},
                                  color={0,0,127}));
    connect(capDes1[3].y, PLRs1.uUpCapDes) annotation (Line(points={{-138,310},{-72,
            310},{-72,209},{-41,209}}, color={0,0,127}));
    connect(capDes1[1].y, PLRs1.uDowCapDes) annotation (Line(points={{-138,310},{-74,
            310},{-74,207},{-41,207}}, color={0,0,127}));
    connect(capMin1[2].y, PLRs1.uCapMin) annotation (Line(points={{-138,270},{-74,
            270},{-74,205},{-41,205}},
                                  color={0,0,127}));
    connect(capMin1[3].y, PLRs1.uUpCapMin) annotation (Line(points={{-138,270},{-76,
            270},{-76,203},{-41,203}}, color={0,0,127}));
    connect(curSta2.y,PLRs2. u)
      annotation (Line(points={{42,190},{179,190}}, color={255,127,0}));
    connect(staUp2.y,PLRs2.uUp) annotation (Line(points={{42,150},{120,150},{120,188},
            {179,188}}, color={255,127,0}));
    connect(staDown2.y,PLRs2.uDown) annotation (Line(points={{42,110},{130,110},{130,
            186},{179,186}}, color={255,127,0}));
    connect(max2.y,PLRs2.uCapReq) annotation (Line(points={{122.2,360},{150,360},{
            150,213},{179,213}},  color={0,0,127}));
    connect(capReq2.y,max2.u1) annotation (Line(points={{42,390},{80,390},{80,366},
            {95.8,366}}, color={0,0,127}));
    connect(lowLim2.y,max2. u2) annotation (Line(points={{42,350},{80,350},{80,354},
            {95.8,354}}, color={0,0,127}));
    connect(capDes2[3].y,PLRs2.uCapDes) annotation (Line(points={{82,310},{148,310},
            {148,211},{179,211}}, color={0,0,127}));
    connect(capDes2[3].y,PLRs2.uUpCapDes) annotation (Line(points={{82,310},{148,310},
            {148,209},{179,209}},      color={0,0,127}));
    connect(capDes2[2].y,PLRs2.uDowCapDes) annotation (Line(points={{82,310},{146,
            310},{146,207},{179,207}}, color={0,0,127}));
    connect(capMin2[3].y,PLRs2.uCapMin) annotation (Line(points={{82,270},{146,270},
            {146,205},{179,205}}, color={0,0,127}));
    connect(capMin2[3].y,PLRs2.uUpCapMin) annotation (Line(points={{82,270},{144,270},
            {144,203},{179,203}},      color={0,0,127}));
    connect(curSta3.y,PLRs3. u)
      annotation (Line(points={{282,190},{419,190}},color={255,127,0}));
    connect(staUp3.y,PLRs3.uUp) annotation (Line(points={{282,150},{360,150},{360,
            188},{419,188}},
                        color={255,127,0}));
    connect(staDown3.y,PLRs3.uDown) annotation (Line(points={{282,110},{370,110},{
            370,186},{419,186}},
                             color={255,127,0}));
    connect(max3.y,PLRs3.uCapReq) annotation (Line(points={{362.2,360},{390,360},{
            390,213},{419,213}},  color={0,0,127}));
    connect(capReq4.y,max3.u1) annotation (Line(points={{282,390},{320,390},{320,366},
            {335.8,366}},color={0,0,127}));
    connect(lowLim3.y,max3. u2) annotation (Line(points={{282,350},{320,350},{320,
            354},{335.8,354}},
                         color={0,0,127}));
    connect(capMin3[1].y,PLRs3.uCapDes) annotation (Line(points={{322,270},{388,270},
            {388,211},{419,211}}, color={0,0,127}));
    connect(capDes3[1].y,PLRs3.uUpCapDes) annotation (Line(points={{322,310},{388,
            310},{388,209},{419,209}}, color={0,0,127}));
    connect(capMin3[1].y,PLRs3.uDowCapDes) annotation (Line(points={{322,270},{386,
            270},{386,207},{419,207}}, color={0,0,127}));
    connect(capMin3[1].y,PLRs3.uCapMin) annotation (Line(points={{322,270},{386,270},
            {386,205},{419,205}}, color={0,0,127}));
    connect(capMin3[1].y,PLRs3.uUpCapMin) annotation (Line(points={{322,270},{384,
            270},{384,203},{419,203}}, color={0,0,127}));
    connect(curSta4.y, PLRs4.u) annotation (Line(points={{-398,-300},{-330,-300},{
            -330,-170},{-261,-170}}, color={255,127,0}));
    connect(staUp4.y, PLRs4.uUp) annotation (Line(points={{-398,-340},{-320,-340},
            {-320,-172},{-261,-172}}, color={255,127,0}));
    connect(staDown4.y, PLRs4.uDown) annotation (Line(points={{-398,-380},{-310,-380},
            {-310,-174},{-261,-174}}, color={255,127,0}));
    connect(max4.y, PLRs4.uCapReq) annotation (Line(points={{-317.8,0},{-290,0},{-290,
            -147},{-261,-147}}, color={0,0,127}));
    connect(capReq5.y, max4.u1) annotation (Line(points={{-398,30},{-360,30},{-360,
            6},{-344.2,6}}, color={0,0,127}));
    connect(lowLim4.y, max4.u2) annotation (Line(points={{-398,-10},{-360,-10},{-360,
            -6},{-344.2,-6}}, color={0,0,127}));
    connect(capDes4[1].y, PLRs4.uCapDes) annotation (Line(points={{-358,-50},{-292,
            -50},{-292,-149},{-261,-149}}, color={0,0,127}));
    connect(capDes4[2].y, PLRs4.uUpCapDes) annotation (Line(points={{-358,-50},{-292,
            -50},{-292,-151},{-261,-151}}, color={0,0,127}));
    connect(capMin4[1].y, PLRs4.uDowCapDes) annotation (Line(points={{-358,-90},{-294,
            -90},{-294,-153},{-261,-153}}, color={0,0,127}));
    connect(capMin4[1].y, PLRs4.uCapMin) annotation (Line(points={{-358,-90},{-294,
            -90},{-294,-155},{-261,-155}}, color={0,0,127}));
    connect(capMin4[2].y, PLRs4.uUpCapMin) annotation (Line(points={{-358,-90},{-296,
            -90},{-296,-157},{-261,-157}}, color={0,0,127}));
    connect(staTyp4.y, PLRs4.uTyp) annotation (Line(points={{-398,-260},{-340,-260},
            {-340,-167},{-261,-167}}, color={255,127,0}));
    connect(curSta5.y,PLRs5. u)
      annotation (Line(points={{-178,-300},{-110,-300},{-110,-170},{-41,-170}},
                                                      color={255,127,0}));
    connect(staUp5.y,PLRs5. uUp) annotation (Line(points={{-178,-340},{-100,-340},
            {-100,-172},{-41,-172}},
                             color={255,127,0}));
    connect(staDown5.y,PLRs5. uDown) annotation (Line(points={{-178,-380},{-90,-380},
            {-90,-174},{-41,-174}},
                                 color={255,127,0}));
    connect(max5.y,PLRs5. uCapReq) annotation (Line(points={{-97.8,0},{-70,0},{-70,
            -147},{-41,-147}},    color={0,0,127}));
    connect(capReq6.y,max5. u1) annotation (Line(points={{-178,30},{-140,30},{-140,
            6},{-124.2,6}},     color={0,0,127}));
    connect(lowLim5.y,max5. u2) annotation (Line(points={{-178,-10},{-140,-10},{-140,
            -6},{-124.2,-6}},   color={0,0,127}));
    connect(capDes5[2].y,PLRs5. uCapDes) annotation (Line(points={{-138,-50},{-72,
            -50},{-72,-149},{-41,-149}},
                                  color={0,0,127}));
    connect(capDes5[3].y,PLRs5. uUpCapDes) annotation (Line(points={{-138,-50},{-72,
            -50},{-72,-151},{-41,-151}},
                                       color={0,0,127}));
    connect(capDes5[1].y,PLRs5. uDowCapDes) annotation (Line(points={{-138,-50},{-74,
            -50},{-74,-153},{-41,-153}},
                                       color={0,0,127}));
    connect(capMin5[2].y,PLRs5. uCapMin) annotation (Line(points={{-138,-90},{-74,
            -90},{-74,-155},{-41,-155}},
                                  color={0,0,127}));
    connect(capMin5[3].y,PLRs5. uUpCapMin) annotation (Line(points={{-138,-90},{-76,
            -90},{-76,-157},{-41,-157}},
                                       color={0,0,127}));
    connect(curSta6.y,PLRs6. u)
      annotation (Line(points={{42,-300},{110,-300},{110,-170},{179,-170}},
                                                    color={255,127,0}));
    connect(staUp6.y,PLRs6.uUp) annotation (Line(points={{42,-340},{120,-340},{120,
            -172},{179,-172}},
                        color={255,127,0}));
    connect(staDown6.y,PLRs6.uDown) annotation (Line(points={{42,-380},{130,-380},
            {130,-174},{179,-174}},
                             color={255,127,0}));
    connect(max6.y,PLRs6.uCapReq) annotation (Line(points={{122.2,0},{150,0},{150,
            -147},{179,-147}},    color={0,0,127}));
    connect(capReq7.y,max6.u1) annotation (Line(points={{42,30},{80,30},{80,6},{95.8,
            6}},         color={0,0,127}));
    connect(lowLim6.y,max6. u2) annotation (Line(points={{42,-10},{80,-10},{80,-6},
            {95.8,-6}},  color={0,0,127}));
    connect(capDes6[3].y,PLRs6.uCapDes) annotation (Line(points={{82,-50},{148,-50},
            {148,-149},{179,-149}},
                                  color={0,0,127}));
    connect(capDes6[3].y,PLRs6.uUpCapDes) annotation (Line(points={{82,-50},{148,-50},
            {148,-151},{179,-151}},    color={0,0,127}));
    connect(capDes6[2].y,PLRs6.uDowCapDes) annotation (Line(points={{82,-50},{146,
            -50},{146,-153},{179,-153}},
                                       color={0,0,127}));
    connect(capMin6[3].y,PLRs6.uCapMin) annotation (Line(points={{82,-90},{146,-90},
            {146,-155},{179,-155}},
                                  color={0,0,127}));
    connect(capMin6[3].y,PLRs6.uUpCapMin) annotation (Line(points={{82,-90},{144,-90},
            {144,-157},{179,-157}},    color={0,0,127}));
    connect(curSta7.y,PLRs7. u)
      annotation (Line(points={{282,-300},{350,-300},{350,-170},{419,-170}},
                                                    color={255,127,0}));
    connect(staUp7.y,PLRs7.uUp) annotation (Line(points={{282,-340},{360,-340},{360,
            -172},{419,-172}},
                        color={255,127,0}));
    connect(staDown7.y,PLRs7.uDown) annotation (Line(points={{282,-380},{370,-380},
            {370,-174},{419,-174}},
                             color={255,127,0}));
    connect(max7.y,PLRs7.uCapReq) annotation (Line(points={{362.2,0},{390,0},{390,
            -147},{419,-147}},    color={0,0,127}));
    connect(capReq8.y,max7.u1) annotation (Line(points={{282,30},{320,30},{320,6},
            {335.8,6}},  color={0,0,127}));
    connect(lowLim7.y,max7. u2) annotation (Line(points={{282,-10},{320,-10},{320,
            -6},{335.8,-6}},
                         color={0,0,127}));
    connect(capMin7[1].y,PLRs7.uCapDes) annotation (Line(points={{322,-90},{388,-90},
            {388,-149},{419,-149}},
                                  color={0,0,127}));
    connect(capDes7[1].y,PLRs7.uUpCapDes) annotation (Line(points={{322,-50},{388,
            -50},{388,-151},{419,-151}},
                                       color={0,0,127}));
    connect(capMin7[1].y,PLRs7.uDowCapDes) annotation (Line(points={{322,-90},{386,
            -90},{386,-153},{419,-153}},
                                       color={0,0,127}));
    connect(capMin7[1].y,PLRs7.uCapMin) annotation (Line(points={{322,-90},{386,-90},
            {386,-155},{419,-155}},
                                  color={0,0,127}));
    connect(capMin7[1].y,PLRs7.uUpCapMin) annotation (Line(points={{322,-90},{384,
            -90},{384,-157},{419,-157}},
                                       color={0,0,127}));
    connect(staTyp.y, PLRs1.uTyp) annotation (Line(points={{-398,230},{-90,230},{-90,
            193},{-41,193}}, color={255,127,0}));
    connect(staTyp.y, PLRs2.uTyp) annotation (Line(points={{-398,230},{130,230},{130,
            193},{179,193}}, color={255,127,0}));
    connect(staTyp4.y, PLRs5.uTyp) annotation (Line(points={{-398,-260},{-120,-260},
            {-120,-167},{-41,-167}}, color={255,127,0}));
    connect(staTyp4.y, PLRs6.uTyp) annotation (Line(points={{-398,-260},{100,-260},
            {100,-167},{179,-167}}, color={255,127,0}));
    connect(staTyp4.y, PLRs7.uTyp) annotation (Line(points={{-398,-260},{340,-260},
            {340,-167},{419,-167}}, color={255,127,0}));
    connect(Lift.y, PLRs4.uLif) annotation (Line(points={{-398,-130},{-360,-130},{
            -360,-160},{-261,-160}}, color={0,0,127}));
    connect(LiftMax.y, PLRs4.uLifMax) annotation (Line(points={{-398,-170},{-380,-170},
            {-380,-162},{-261,-162}}, color={0,0,127}));
    connect(LiftMin.y, PLRs4.uLifMin) annotation (Line(points={{-398,-210},{-360,-210},
            {-360,-164},{-261,-164}}, color={0,0,127}));
    connect(Lift.y, PLRs5.uLif) annotation (Line(points={{-398,-130},{-140,-130},{
            -140,-160},{-41,-160}}, color={0,0,127}));
    connect(LiftMax.y, PLRs5.uLifMax) annotation (Line(points={{-398,-170},{-380,-170},
            {-380,-180},{-140,-180},{-140,-162},{-41,-162}}, color={0,0,127}));
    connect(LiftMin.y, PLRs5.uLifMin) annotation (Line(points={{-398,-210},{-130,-210},
            {-130,-164},{-41,-164}}, color={0,0,127}));
    connect(Lift.y, PLRs6.uLif) annotation (Line(points={{-398,-130},{80,-130},{80,
            -160},{179,-160}}, color={0,0,127}));
    connect(Lift.y, PLRs7.uLif) annotation (Line(points={{-398,-130},{320,-130},{320,
            -160},{419,-160}}, color={0,0,127}));
    connect(LiftMax.y, PLRs6.uLifMax) annotation (Line(points={{-398,-170},{-380,-170},
            {-380,-180},{80,-180},{80,-162},{179,-162}}, color={0,0,127}));
    connect(LiftMax.y, PLRs7.uLifMax) annotation (Line(points={{-398,-170},{-380,-170},
            {-380,-180},{320,-180},{320,-162},{419,-162}}, color={0,0,127}));
    connect(LiftMin.y, PLRs6.uLifMin) annotation (Line(points={{-398,-210},{92,-210},
            {92,-164},{179,-164}}, color={0,0,127}));
    connect(PLRs7.uLifMin, LiftMin.y) annotation (Line(points={{419,-164},{332,-164},
            {332,-210},{-398,-210}}, color={0,0,127}));
    connect(staTyp.y, PLRs3.uTyp) annotation (Line(points={{-398,230},{372,230},{372,
            193},{419,193}}, color={255,127,0}));
  annotation (
   experiment(StopTime=1200.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/PartLoadRatios_u_uTyp.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
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
          coordinateSystem(preserveAspectRatio=false, extent={{-480,-420},{480,420}}),
          graphics={Text(
            extent={{-140,104},{158,32}},
            lineColor={127,127,127},
            textString="Stage types: 1 - positive displacement, 2 and 3 - constant speed centrifugal"),
            Text(
            extent={{-140,-372},{158,-444}},
            lineColor={127,127,127},
            textString="Stage types: 1 - positive displacement, 2 - variable speed centrifugal, 3 - constant speed centrifugal")}));
  end PartLoadRatios_u_uTyp;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences</a>.
</p>
<p>
Note that most validation models contain simple input data
which may not be realistic, but for which the correct
output can be obtained through an analytic solution.
The examples plot various outputs, which have been verified against these
solutions. These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"),
  Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}}),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end Validation;
