within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block Controller "Head pressure controller"
  parameter Real minTowSpe=0.1 "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe=0.1 "Minimum condenser water pump speed"
    annotation (Dialog(enable= not ((not haveWSE) and fixSpePum)));
  parameter Real minHeaPreValPos=0.1 "Minimum head pressure control valve position"
    annotation (Dialog(enable= (not ((not haveWSE) and (not fixSpePum)))));
  parameter Boolean haveHeaPreConSig = false
    "Flag indicating if there is head pressure control signal from chiller controller"
    annotation (Dialog(group="Plant"));
  parameter Boolean haveWSE = true
    "Flag indicating if the plant has waterside economizer"
    annotation (Dialog(group="Plant"));
  parameter Boolean fixSpePum = true
    "Flag indicating if the plant has fixed speed condenser water pumps"
    annotation (Dialog(group="Plant", enable=not haveWSE));
  parameter Modelica.SIunits.TemperatureDifference minChiLif=10
    "Minimum allowable lift at minimum load for chiller"
    annotation (Dialog(tab="Loop signal", enable=not haveHeaPreConSig));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not haveHeaPreConSig));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Controller wseSta
    annotation (Placement(transformation(extent={{-580,230},{-520,290}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable plaEna
    annotation (Placement(transformation(extent={{-660,-380},{-618,-338}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.ControllerTwo equRot
    annotation (Placement(transformation(extent={{-366,518},{-326,558}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Controller heaPreCon(
      haveHeaPreConSig=false, haveWSE=true)
    annotation (Placement(transformation(extent={{-480,130},{-420,190}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Controller minBypValCon
    annotation (Placement(transformation(extent={{-580,-170},{-440,-30}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Controller conWatPumCon
    annotation (Placement(transformation(extent={{-680,380},{-620,440}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.ChilledWater.Controller chiWatPumCon
    annotation (Placement(transformation(extent={{-728,10},{-668,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset chiWatPlaRes
    annotation (Placement(transformation(extent={{-560,-320},{-480,-240}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterSupply chiWatSupSet
    annotation (Placement(transformation(extent={{-360,380},{-280,460}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.SetpointController staSetCon(have_WSE=
        true)
    annotation (Placement(transformation(extent={{-156,-46},{-40,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Controller towCon(
    final nTowCel=nTowCel)
    annotation (Placement(transformation(extent={{-348,-460},{-220,-190}})));

  CDL.Interfaces.RealInput VChiWat_flow(final quantity=
        "VolumeFlowRate", final unit="m3/s")
    "Measured chilled water volume flow rate"
    annotation (Placement(transformation(extent={{-840,170},{-800,210}}),
    iconTransformation(extent={{-140,-60},{-100,-20}})));

  CDL.Interfaces.RealInput TChiWatRetDow(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature downstream of the WSE"
    annotation (Placement(transformation(extent={{-840,210},{-800,250}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  CDL.Interfaces.RealInput TChiWatRet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Chiller water return temperature upstream of the WSE"
    annotation (Placement(transformation(extent={{-840,250},{-800,290}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.RealInput TOutWet(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-840,290},{-800,330}}),
        iconTransformation(extent={{-140,60},{-100,100}})));

  CDL.Interfaces.IntegerInput chiWatSupResReq
    "Number of chiller plant cooling requests"
    annotation (Placement(transformation(extent={{-840,-264},{-800,-224}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  CDL.Interfaces.BooleanInput uChiAva[nChi]
    "Chiller availability status vector"
    annotation (Placement(transformation(extent={{-840,-70},{-800,-30}}),
        iconTransformation(extent={{-140,-190},{-100,-150}})));

  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa",
      final quantity="PressureDifference") if
                                            not serChi
    "Chilled water pump differential static pressure"
    annotation (Placement(transformation(extent={{-840,70},{-800,110}}),
    iconTransformation(extent={{-140,30},{-100,70}})));

  CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-840,130},{-800,170}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not haveHeaPreConSig
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-840,100},{-800,140}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation (Placement(transformation(extent={{-840,-100},{-800,-60}}),
      iconTransformation(extent={{-140,150},{-100,190}})));

  CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation (Placement(transformation(extent={{-840,-130},{-800,-90}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Staging.Processes.Down dowProCon
    annotation (Placement(transformation(extent={{120,-104},{196,48}})));
  Staging.Processes.Up upProCon
    annotation (Placement(transformation(extent={{100,150},{176,302}})));
  CDL.Continuous.MultiMax mulMax(nin=nTowCel) "All input values are the same"
    annotation (Placement(transformation(extent={{-180,-410},{-160,-390}})));
  CDL.Interfaces.RealInput                        uChiLoa[nChi](final quantity=
        fill("HeatFlowRate", nChi), final unit=fill("W", nChi))
    "Current chiller load"
    annotation (Placement(transformation(extent={{-840,340},{-800,380}}),
      iconTransformation(extent={{-140,100},{-100,140}})));
  CDL.Logical.Or chaProUpDown "Either in staging up or in staging down process"
    annotation (Placement(transformation(extent={{260,140},{280,160}})));
  CDL.Discrete.TriggeredSampler staSam
    "Samples stage index after each staging process is finished"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
  CDL.Conversions.RealToInteger reaToInt1
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  CDL.Logical.FallingEdge falEdg
    annotation (Placement(transformation(extent={{240,40},{260,60}})));
  CDL.Interfaces.IntegerOutput                        yNumCel
    "Total number of enabled cells"
    annotation (Placement(transformation(extent={{800,330},{840,370}}),
      iconTransformation(extent={{100,150},{140,190}})));
  CDL.Interfaces.RealOutput                        yIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{800,250},{840,290}}),
      iconTransformation(extent={{100,30},{140,70}})));
  CDL.Interfaces.RealOutput                        yFanSpe[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel)) "Fan speed of each cooling tower cell"
    annotation (Placement(transformation(extent={{800,210},{840,250}}),
      iconTransformation(extent={{100,-130},{140,-90}})));
  CDL.Interfaces.BooleanOutput                        yLeaCel
    "Lead tower cell status setpoint"
    annotation (Placement(transformation(extent={{800,550},{840,590}}),
      iconTransformation(extent={{100,90},{140,130}})));
  CDL.Interfaces.BooleanOutput                        yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{800,510},{840,550}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  CDL.Interfaces.BooleanOutput                        yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{800,470},{840,510}}),
      iconTransformation(extent={{100,-190},{140,-150}})));
  CDL.Interfaces.BooleanInput                        uChiWatPum[nPum]
    "Chilled water pump status"
    annotation (Placement(transformation(extent={{-840,-170},{-800,-130}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Logical.MultiOr mulOr(nu=nPum)
    annotation (Placement(transformation(extent={{-640,-40},{-620,-20}})));
  CDL.Routing.RealReplicator reaRep(nout=nTowCel)
    annotation (Placement(transformation(extent={{-386,168},{-366,188}})));
  CDL.Interfaces.BooleanInput                        uChiIsoVal[nChi] if isHeadered
    "Chilled water isolation valve status"
    annotation (Placement(transformation(extent={{-840,-20},{-800,20}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  CDL.Interfaces.RealInput                        dpChiWat_remote[nSen](final
      unit=fill("Pa", nSen), final quantity=fill("PressureDifference", nSen))
    "Chilled water differential static pressure from remote sensor"
    annotation (Placement(transformation(extent={{-840,40},{-800,80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
equation
  connect(staSetCon.uPla, plaEna.yPla) annotation (Line(points={{-167.6,122.562},
          {-380,122.562},{-380,-358},{-498,-358},{-498,-359},{-615.9,-359}},
                                               color={255,0,255}));
  connect(TOutWet, wseSta.TOutWet) annotation (Line(points={{-820,310},{-690,
          310},{-690,284},{-586,284}}, color={0,0,127}));
  connect(TChiWatRet, wseSta.TChiWatRet) annotation (Line(points={{-820,270},{
          -586,270},{-586,272}}, color={0,0,127}));
  connect(TChiWatRetDow, wseSta.TChiWatRetDow) annotation (Line(points={{-820,
          230},{-690,230},{-690,260},{-586,260}}, color={0,0,127}));
  connect(VChiWat_flow, wseSta.VChiWat_flow) annotation (Line(points={{-820,190},
          {-660,190},{-660,248},{-586,248}}, color={0,0,127}));
  connect(TOutWet, plaEna.TOut) annotation (Line(points={{-820,310},{-720,310},
          {-720,-366},{-664.2,-366},{-664.2,-367.82}},
                                                  color={0,0,127}));
  connect(chiWatSupResReq, plaEna.chiWatSupResReq) annotation (Line(points={{-820,
          -244},{-710,-244},{-710,-350.6},{-664.2,-350.6}},color={255,127,0}));
  connect(chiWatSupSet.TChiWatSupSet, staSetCon.TChiWatSupSet) annotation (Line(
        points={{-272,396},{-260,396},{-260,140},{-220,140},{-220,87.6875},{
          -167.6,87.6875}},                                     color={0,0,127}));
  connect(TChiWatSup, staSetCon.TChiWatSup) annotation (Line(points={{-820,120},
          {-320,120},{-320,76.0625},{-167.6,76.0625}},
                                                 color={0,0,127}));
  connect(VChiWat_flow, minBypValCon.VChiWat_flow) annotation (Line(points={{-820,
          190},{-660,190},{-660,-51},{-594,-51}},      color={0,0,127}));
  connect(heaPreCon.TConWatRet, TChiWatRet) annotation (Line(points={{-486,178},
          {-696,178},{-696,270},{-820,270}}, color={0,0,127}));
  connect(TChiWatRet, staSetCon.TChiWatRet) annotation (Line(points={{-820,270},
          {-700,270},{-700,90},{-320,90},{-320,-51.8125},{-167.6,-51.8125}},
                                                                       color={0,
          0,127}));
  connect(staSetCon.TWsePre, wseSta.TWsePre) annotation (Line(points={{-167.6,
          -63.4375},{-360,-63.4375},{-360,212},{-460,212},{-460,260},{-517,260}},
        color={0,0,127}));
  connect(VChiWat_flow, staSetCon.VChiWat_flow) annotation (Line(points={{-820,
          190},{-660,190},{-660,104},{-324,104},{-324,-75.0625},{-167.6,
          -75.0625}},
        color={0,0,127}));
  connect(TChiWatSup, heaPreCon.TChiWatSup) annotation (Line(points={{-820,120},
          {-680,120},{-680,166},{-486,166}}, color={0,0,127}));
  connect(wseSta.y, heaPreCon.uWSE) annotation (Line(points={{-517,275},{-500,
          275},{-500,142},{-486,142}}, color={255,0,255}));
  connect(chiWatSupResReq, chiWatPlaRes.TChiWatSupResReq) annotation (Line(
        points={{-820,-244},{-680,-244},{-680,-280},{-568,-280}}, color={255,
          127,0}));
  connect(chiWatPlaRes.yChiWatPlaRes, chiWatSupSet.uChiWatPlaRes) annotation (
      Line(points={{-472,-280},{-406,-280},{-406,420},{-368,420}},
                                                                color={0,0,127}));
  connect(dpChiWatPum, staSetCon.dpChiWatPum) annotation (Line(points={{-820,90},
          {-528,90},{-528,17.9375},{-167.6,17.9375}},
                                                    color={0,0,127}));
  connect(chiWatSupSet.dpChiWatPumSet, staSetCon.dpChiWatPumSet) annotation (
      Line(points={{-272,444},{-240,444},{-240,76},{-204,76},{-204,6.3125},{
          -167.6,6.3125}},                                         color={0,0,
          127}));
  connect(uChi, towCon.uChi) annotation (Line(points={{-820,-80},{-688,-80},{
          -688,-210.25},{-360.8,-210.25}},
                                        color={255,0,255}));
  connect(wseSta.y, staSetCon.uWseSta) annotation (Line(points={{-517,275},{
          -394,275},{-394,157.438},{-167.6,157.438}},
                                                color={255,0,255}));
  connect(wseSta.y, towCon.uWse) annotation (Line(points={{-517,275},{-396,275},
          {-396,-223.75},{-360.8,-223.75}},
                                        color={255,0,255}));
  connect(uTowSta, towCon.uTowSta) annotation (Line(points={{-820,-110},{-674,
          -110},{-674,-250},{-440,-250},{-440,-304.75},{-360.8,-304.75}},
                                                                    color={255,
          0,255}));
  connect(plaEna.yPla, towCon.uPla) annotation (Line(points={{-615.9,-359},{
          -440,-359},{-440,-318.25},{-360.8,-318.25}},
                                              color={255,0,255}));
  connect(TOutWet, staSetCon.TOutWet) annotation (Line(points={{-820,310},{-628,
          310},{-628,74},{-212,74},{-212,-10},{-167.6,-10},{-167.6,-11.125}},
                                                       color={0,0,127}));
  connect(wseSta.yTunPar, staSetCon.uTunPar) annotation (Line(points={{-517,245},
          {-514,245},{-514,-22.75},{-167.6,-22.75}},
                                             color={0,0,127}));
  connect(towCon.yFanSpe, mulMax.u[1:4]) annotation (Line(points={{-207.2,
          -399.25},{-200,-399.25},{-200,-400},{-182,-400}},
                                        color={0,0,127}));
  connect(mulMax.y, staSetCon.uTowFanSpeMax) annotation (Line(points={{-158,
          -400},{-140,-400},{-140,-122},{-200,-122},{-200,-34.375},{-167.6,
          -34.375}},
        color={0,0,127}));
  connect(staSetCon.ySta, upProCon.uStaSet) annotation (Line(points={{-28.4,
          -16.9375},{22,-16.9375},{22,298},{58,298},{58,298.2},{92.4,298.2}},
                                                          color={255,127,0}));
  connect(staSetCon.ySta, dowProCon.uStaSet) annotation (Line(points={{-28.4,
          -16.9375},{24,-16.9375},{24,41.16},{112.4,41.16}},
                                                          color={255,127,0}));
  connect(staSetCon.yChiSet, upProCon.uChiSet) annotation (Line(points={{-28.4,
          23.75},{-2,23.75},{-2,-52},{26,-52},{26,286.8},{92.4,286.8}},
        color={255,0,255}));
  connect(staSetCon.yChiSet, dowProCon.uChiSet) annotation (Line(points={{-28.4,
          23.75},{32,23.75},{32,33.56},{112.4,33.56}},      color={255,0,255}));
  connect(uChiLoa, upProCon.uChiLoa) annotation (Line(points={{-820,360},{-200,
          360},{-200,340},{60,340},{60,271.6},{92.4,271.6}}, color={0,0,127}));
  connect(upProCon.yStaPro, chaProUpDown.u1) annotation (Line(points={{183.6,
          298.2},{220,298.2},{220,150},{258,150}}, color={255,0,255}));
  connect(dowProCon.yStaPro, chaProUpDown.u2) annotation (Line(points={{203.6,
          44.2},{220,44.2},{220,142},{258,142}}, color={255,0,255}));
  connect(chaProUpDown.y, staSetCon.chaPro) annotation (Line(points={{282,150},
          {292,150},{292,-110},{-180,-110},{-180,145.812},{-167.6,145.812}},
        color={255,0,255}));
  connect(uChi, dowProCon.uChi) annotation (Line(points={{-820,-80},{-700,-80},
          {-700,-230},{-360,-230},{-360,-150},{40,-150},{40,2.4},{112.4,2.4}},
        color={255,0,255}));
  connect(staSam.u, intToRea.y)
    annotation (Line(points={{28,110},{22,110}}, color={0,0,127}));
  connect(staSam.y, reaToInt1.u)
    annotation (Line(points={{52,110},{58,110}}, color={0,0,127}));
  connect(dowProCon.yStaPro, falEdg.u) annotation (Line(points={{203.6,44.2},{
          220,44.2},{220,50},{238,50}}, color={255,0,255}));
  connect(falEdg.y, staSam.trigger) annotation (Line(points={{262,50},{270,50},
          {270,88},{40,88},{40,98.2}}, color={255,0,255}));
  connect(staSetCon.ySta, intToRea.u) annotation (Line(points={{-28.4,-16.9375},
          {-10,-16.9375},{-10,110},{-2,110}},color={255,127,0}));
  connect(reaToInt1.y, dowProCon.uChiSta) annotation (Line(points={{82,110},{90,
          110},{90,-16.6},{112.4,-16.6}},color={255,127,0}));
  connect(reaToInt1.y, staSetCon.uSta) annotation (Line(points={{82,110},{82,
          -124},{-224,-124},{-224,105.125},{-167.6,105.125}},
                                                            color={255,127,0}));
  connect(mulMax.y, wseSta.uTowFanSpeMax) annotation (Line(points={{-158,-400},
          {-146,-400},{-146,-138},{-374,-138},{-374,30},{-622,30},{-622,236},{
          -586,236}}, color={0,0,127}));
  connect(conWatPumCon.yDesConWatPumSpe, heaPreCon.desConWatPumSpe) annotation
    (Line(points={{-614,419},{-604,419},{-604,154},{-486,154}}, color={0,0,127}));
  connect(towCon.yNumCel, yNumCel) annotation (Line(points={{-207.2,-210.25},{
          598,-210.25},{598,350},{820,350}}, color={255,127,0}));
  connect(towCon.yIsoVal, yIsoVal) annotation (Line(points={{-207.2,-291.25},{
          612,-291.25},{612,270},{820,270}}, color={0,0,127}));
  connect(towCon.yFanSpe, yFanSpe) annotation (Line(points={{-207.2,-399.25},{
          -192,-399.25},{-192,-416},{-120,-416},{-120,-302},{630,-302},{630,230},
          {820,230}}, color={0,0,127}));
  connect(towCon.yLeaCel, yLeaCel) annotation (Line(points={{-207.2,-250.75},{
          538,-250.75},{538,570},{820,570}}, color={255,0,255}));
  connect(towCon.yTowSta, yTowSta) annotation (Line(points={{-207.2,-358.75},{
          550,-358.75},{550,530},{820,530}}, color={255,0,255}));
  connect(towCon.yMakUp, yMakUp) annotation (Line(points={{-207.2,-439.75},{570,
          -439.75},{570,490},{820,490}}, color={255,0,255}));
  connect(heaPreCon.yConWatPumSpeSet, conWatPumCon.uConWatPumSpe) annotation (
      Line(points={{-417,142},{-398,142},{-398,370},{-700,370},{-700,383},{-686,
          383}}, color={0,0,127}));
  connect(chaProUpDown.y, chiWatPlaRes.chaPro) annotation (Line(points={{282,
          150},{300,150},{300,-480},{-580,-480},{-580,-304},{-568,-304}}, color
        ={255,0,255}));
  connect(uChiWatPum, chiWatPlaRes.uChiWatPum) annotation (Line(points={{-820,
          -150},{-708,-150},{-708,-270},{-580,-270},{-580,-256},{-568,-256}},
        color={255,0,255}));
  connect(mulOr.y, minBypValCon.uChiWatPum) annotation (Line(points={{-618,-30},
          {-604,-30},{-604,-37},{-594,-37}}, color={255,0,255}));
  connect(uChiWatPum, mulOr.u) annotation (Line(points={{-820,-150},{-650,-150},
          {-650,-30},{-642,-30}}, color={255,0,255}));
  connect(staSetCon.yOpeParLoaRatMin, dowProCon.uOpeParLoaRatMin) annotation (
      Line(points={{-28.4,-57.625},{60,-57.625},{60,21.4},{112.4,21.4}}, color=
          {0,0,127}));
  connect(uChi, upProCon.uChi) annotation (Line(points={{-820,-80},{-652,-80},{
          -652,24},{-248,24},{-248,190},{60,190},{60,264},{92.4,264}}, color={
          255,0,255}));
  connect(VChiWat_flow, upProCon.VChiWat_flow) annotation (Line(points={{-820,
          190},{-560,190},{-560,216},{72,216},{72,254.88},{92.4,254.88}}, color
        ={0,0,127}));
  connect(wseSta.y, upProCon.uWSE) annotation (Line(points={{-517,275},{0,275},
          {0,207},{92.4,207}}, color={255,0,255}));
  connect(wseSta.y, dowProCon.uWSE) annotation (Line(points={{-517,275},{-14,
          275},{-14,-81.2},{112.4,-81.2}}, color={255,0,255}));
  connect(heaPreCon.yMaxTowSpeSet, reaRep.u)
    annotation (Line(points={{-417,178},{-388,178}}, color={0,0,127}));
  connect(reaRep.y, towCon.uMaxTowSpeSet) annotation (Line(points={{-364,178},{
          -354,178},{-354,-166},{-388,-166},{-388,-291.25},{-360.8,-291.25}},
        color={0,0,127}));
  connect(dowProCon.VChiWat_flow, VChiWat_flow) annotation (Line(points={{112.4,
          -5.2},{62,-5.2},{62,-90},{-334,-90},{-334,126},{-760,126},{-760,190},
          {-820,190}}, color={0,0,127}));
  connect(uChiWatPum, chiWatPumCon.uChiWatPum) annotation (Line(points={{-820,
          -150},{-760,-150},{-760,61},{-734,61}}, color={255,0,255}));
  connect(uChiIsoVal, chiWatPumCon.uChiIsoVal) annotation (Line(points={{-820,0},
          {-780,0},{-780,37},{-734,37}}, color={255,0,255}));
  connect(VChiWat_flow, chiWatPumCon.VChiWat_flow) annotation (Line(points={{
          -820,190},{-754,190},{-754,31},{-734,31}}, color={0,0,127}));
  connect(dpChiWat_remote, chiWatPumCon.dpChiWat_remote) annotation (Line(
        points={{-820,60},{-766,60},{-766,19},{-734,19}}, color={0,0,127}));
annotation (
  defaultComponentName="chiPlaCon",
  Icon(coordinateSystem(extent={{-800,-740},{800,740}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-800,-740},{800,740}}), graphics={                 Text(
          extent={{236,194},{342,158}},
          lineColor={28,108,200},
          textString="might need a pre block")}),
  Documentation(info="<html>
<p>
fixme: Controller for plants with two devices or groups of devices (chillers, towers(4 cells), CW and C pumps)
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
