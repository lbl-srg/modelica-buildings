within Buildings.Examples.VAVReheat.BaseClasses;
model ASHRAE2006_RTU
  "Variable air volume flow system with terminal reheat and ASHRAE 2006 control sequence serving five thermal zones"
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC_RTU(amb(nPorts=3));

  parameter Real ratVMinVAV_flow[numZon](each final unit="1") = {max(1.5*
    VZonOA_flow_nominal[i]/mCooVAV_flow_nominal[i]/1.2, 0.15) for i in 1:numZon}
    "Minimum discharge air flow rate ratio";

  Controls.FanVFD conFanSup(
    xSet_nominal(displayUnit="Pa") = 410,
    r_N_min=yFanMin)
    "Controller for fan"
    annotation (Placement(transformation(extent={{240,40},{260,60}})));

  Controls.ModeSelector modeSelector
    annotation (Placement(transformation(extent={{-200,-320},{-180,-300}})));

  Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-250,-350},{-230,-330}}),
      iconTransformation(extent={{-162,-100},{-142,-80}})));

  Controls.Economizer conEco(
    have_reset=true,
    have_frePro=true,
    VOut_flow_min=Vot_flow_nominal)
           "Controller for economizer"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));

  Controls.RoomTemperatureSetpoint TSetRoo(
    final THeaOn=THeaOn,
    final THeaOff=THeaOff,
    final TCooOn=TCooOn,
    final TCooOff=TCooOff)
    annotation (Placement(transformation(extent={{-300,-358},{-280,-338}})));

  Controls.DuctStaticPressureSetpoint pSetDuc(
    nin=5,
    pMin=50)
    "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{160,-16},{180,4}})));

  Controls.RoomVAV conVAV[numZon](
    have_preIndDam=fill(false, numZon),
    ratVFloMin=ratVMinVAV_flow,
    ratVFloHea=mHeaVAV_flow_nominal ./ mCooVAV_flow_nominal,
    V_flow_nominal=mCooVAV_flow_nominal/1.2)
    "Controller for terminal unit"
    annotation (Placement(transformation(extent={{580,40},{600,60}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{-100,-250},{-80,-230}})));

  Controls.SupplyAirTemperature conTSup(k=0.05, Ti=800)
    "Supply air temperature and economizer controller"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));

  Controls.SupplyAirTemperatureSetpoint TSupSet
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));

  Buildings.Fluid.Actuators.Dampers.Exponential damExh(
    from_dp=false,
    riseTime=15,
    dpFixed_nominal=5,
    redeclare package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal,
    dpDamper_nominal=5) "Exhaust air damper"
    annotation (Placement(transformation(extent={{-30,-20},{-50,0}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin TRooMin(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC"))
    "Minimum room temperature"
    annotation (Placement(transformation(extent={{-340,260},{-320,280}})));

  Utilities.Math.Average TRooAve(
    final nin=numZon,
    u(each final unit="K",
      each displayUnit="degC"),
    y(final unit="K",
      displayUnit="degC")) "Average room temperature"
    annotation (Placement(transformation(extent={{-340,230},{-320,250}})));

  Controls.FreezeStat freSta "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TRooHeaSet(
    final nout=numZon)
    "Replicate room temperature heating setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={490,64})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TRooCooSet(
    final nout=numZon)
    "Replicate room temperature cooling setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, rotation=0, origin={490,30})));

  Buildings.Controls.OBC.RooftopUnits.Controller RTUCon(
    final nCoiHea=nCoiHea,
    final nCoiCoo=nCoiCoo,
    final uThrCoi1=0.4,
    final minComSpe=0.25,
    final dUHys=0.2)
    "Controller for rooftop units"
    annotation (Placement(transformation(extent={{1010,232},{1030,260}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nCoiCoo](
    each final realTrue=1,
    each final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{1090,250},{1110,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nCoiCoo]
    "Calculate compressor speed based on product of two inputs"
    annotation (Placement(transformation(extent={{1130,230},{1150,250}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[nCoiHea](
    each final uLow=0.5,
    each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{140,-160},{160,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1[nCoiCoo](
    each final uLow=0.5,
    each final uHigh=1)
    "Check if DXs are on"
    annotation (Placement(transformation(extent={{280,-150},{300,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta[nCoiHea](
    each final t=120)
    "Output DX heating coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{180,-160},{200,-140}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timDXSta1[nCoiCoo](
    each final t=120)
    "Output DX cooling coils proven on signal when status is enabled for two minutes"
    annotation (Placement(transformation(extent={{318,-150},{338,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=0.001,
    final uHigh=0.002)
    "Check if supply fan is on"
    annotation (Placement(transformation(extent={{460,-120},{480,-100}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert Boolean fan enable signal to real value"
    annotation (Placement(transformation(extent={{500,-120},{520,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulAuxHea
    "Enable auxiliary coil if fan is on and DX coils are unable to meet heating load"
    annotation (Placement(transformation(extent={{540,-120},{560,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical Not"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{170,-110},{190,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nCoiHea)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{102,-110},{122,-90}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nCoiCoo)
    "Logical Multi Or"
    annotation (Placement(transformation(extent={{280,-100},{300,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{310,-100},{330,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea3
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{340,-100},{360,-80}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant demLimLev1(
    final k=0)
    "Demand limit level, assumes to be 0"
    annotation (Placement(transformation(extent={{910,254},{930,274}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nCoiHea](
    final k=1:nCoiHea)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{910,284},{930,304}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1[nCoiCoo](
    final k=fill(true, nCoiCoo))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{940,354},{960,374}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2[nCoiHea](
    final k=fill(true, nCoiHea))
    "Constant Boolean signal"
    annotation (Placement(transformation(extent={{910,324},{930,344}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1[nCoiCoo](
    final k=1:nCoiCoo)
    "Constant integer signal"
    annotation (Placement(transformation(extent={{940,304},{960,324}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{298,48},{318,68}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea4
    annotation (Placement(transformation(extent={{348,38},{368,58}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    annotation (Placement(transformation(extent={{388,32},{408,52}})));
equation
  connect(controlBus, modeSelector.cb) annotation (Line(
      points={{-240,-340},{-152,-340},{-152,-303.182},{-196.818,-303.182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRooAve.y, controlBus.TRooAve) annotation (Line(
      points={{-319,240},{-240,240},{-240,-340}},
      color={0,0,127}),          Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TRet.T, conEco.TRet) annotation (Line(
      points={{100,151},{100,174},{-94,174},{-94,153.333},{-81.3333,153.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSetRoo.controlBus, controlBus) annotation (Line(
      points={{-288,-342},{-264,-342},{-264,-340},{-240,-340}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(dpDisSupFan.p_rel, conFanSup.u_m) annotation (Line(
      points={{411,4.44089e-16},{396,4.44089e-16},{396,0},{380,0},{380,30},{250,
          30},{250,38}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pSetDuc.y, conFanSup.u) annotation (Line(
      points={{181,-6},{210,-6},{210,50},{238,50}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conEco.VOut_flow, VOut1.V_flow) annotation (Line(
      points={{-81.3333,142.667},{-90,142.667},{-90,80},{-80,80},{-80,-29}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-299,-204},{-240,-204},{-240,-340}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-299,-216},{-240,-216},{-240,-340}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut.y, controlBus.TOut) annotation (Line(points={{-279,180},{-240,180},
          {-240,-340}},                            color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conEco.controlBus, controlBus) annotation (Line(points={{-70.6667,
          141.467},{-70.6667,120},{-240,120},{-240,-340}},
                                              color={255,204,51}, thickness=0.5));
  connect(or2.u2, modeSelector.yFan) annotation (Line(points={{-102,-248},{-120,
          -248},{-120,-305.455},{-179.091,-305.455}},
                                     color={255,0,255}));
  connect(VAVBox.y_actual, pSetDuc.u) annotation (Line(points={{762,40},{770,40},
          {770,80},{140,80},{140,-6},{158,-6}},     color={0,0,127}));
  connect(TSup.T, conTSup.TSup) annotation (Line(
      points={{540,-29},{540,-20},{600,-20},{600,-188},{-70,-188},{-70,-214},{-62,
          -214}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conTSup.yOA, conEco.uOATSup) annotation (Line(
      points={{-38,-220},{-28,-220},{-28,-180},{-152,-180},{-152,158.667},{
          -81.3333,158.667}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(or2.y, conTSup.uEna) annotation (Line(points={{-78,-240},{-70,-240},{
          -70,-226},{-62,-226}}, color={255,0,255}));
  connect(modeSelector.yEco, conEco.uEna) annotation (Line(points={{-179.091,
          -314.545},{-160,-314.545},{-160,100},{-73.3333,100},{-73.3333,137.333}},
        color={255,0,255}));
  connect(TMix.T, conEco.TMix) annotation (Line(points={{40,-29},{40,166},{-90,
          166},{-90,148},{-81.3333,148}},
                                     color={0,0,127}));
  connect(controlBus, TSupSet.controlBus) annotation (Line(
      points={{-240,-340},{-240,-228},{-190,-228}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSupSet.TSet, conTSup.TSupSet)
    annotation (Line(points={{-178,-220},{-62,-220}},color={0,0,127}));
  connect(damRet.y, conEco.yRet) annotation (Line(points={{-12,-10},{-18,-10},{
          -18,146.667},{-58.6667,146.667}},
                                        color={0,0,127}));
  connect(damExh.y, conEco.yOA) annotation (Line(points={{-40,2},{-40,152},{
          -58.6667,152}},
                 color={0,0,127}));
  connect(damOut.y, conEco.yOA) annotation (Line(points={{-40,-28},{-40,-20},{
          -22,-20},{-22,152},{-58.6667,152}},
                                          color={0,0,127}));
  connect(damExh.port_a, TRet.port_b) annotation (Line(points={{-30,-10},{-26,-10},
          {-26,140},{90,140}}, color={0,127,255}));
  connect(freSta.y, or2.u1) annotation (Line(points={{-38,-80},{-20,-80},{-20,-100},
          {-108,-100},{-108,-240},{-102,-240}}, color={255,0,255}));
  connect(TRooMin.y, controlBus.TRooMin) annotation (Line(points={{-318,270},{-240,
          270},{-240,-340}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TRooMin.u, TRoo) annotation (Line(points={{-342,270},{-360,270},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(TRooAve.u, TRoo) annotation (Line(points={{-342,240},{-360,240},{-360,
          320},{-400,320}}, color={0,0,127}));
  connect(freSta.u, TMix.T) annotation (Line(points={{-62,-80},{-72,-80},{-72,-60},
          {26,-60},{26,-20},{40,-20},{40,-29}}, color={0,0,127}));
  connect(damExh.port_b, amb.ports[3]) annotation (Line(points={{-50,-10},{-100,
          -10},{-100,-45},{-114,-45}}, color={0,127,255}));
  connect(TRoo, conVAV.TRoo) annotation (Line(
      points={{-400,320},{-360,320},{-360,304},{48,304},{48,96},{548,96},{548,47},
          {578,47}}, color={0,0,127}));
  connect(controlBus.TRooSetHea, TRooHeaSet.u) annotation (Line(
      points={{-240,-340},{440,-340},{440,64},{478,64}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.TRooSetCoo, TRooCooSet.u) annotation (Line(
      points={{-240,-340},{440,-340},{440,30},{478,30}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TRooHeaSet.y, conVAV.TRooHeaSet) annotation (Line(points={{502,64},{552,
          64},{552,58},{578,58}}, color={0,0,127}));
  connect(TRooCooSet.y, conVAV.TRooCooSet) annotation (Line(points={{502,30},{544,
          30},{544,53},{578,53}}, color={0,0,127}));
  connect(conVAV.yDam, VAVBox.yVAV) annotation (Line(points={{602,55},{716,56}},
          color={0,0,127}));
  connect(conVAV.yVal, VAVBox.yHea) annotation (Line(points={{602,45},{608,45},{
          608,46},{716,46}},  color={0,0,127}));
  connect(VAVBox.VSup_flow, conVAV.VDis_flow) annotation (Line(points={{762,56},
          {780,56},{780,90},{570,90},{570,42},{578,42}}, color={0,0,127}));
  connect(x_pTphi.X[1],RTUCon. XOut) annotation (Line(points={{-279,100},{-200,
          100},{-200,240.167},{1008,240.167}},
                                  color={0,0,127}));
  connect(RTUCon.TOut, TOut.y) annotation (Line(points={{1008,241.917},{-210,
          241.917},{-210,180},{-279,180}},
                            color={0,0,127}));
  connect(RTUCon.yDXCooCoi,booToRea. u) annotation (Line(points={{1032,256.5},{1060,
          256.5},{1060,260},{1088,260}},
                 color={255,0,255}));
  connect(booToRea.y,mul. u1) annotation (Line(points={{1112,260},{1120,260},{1120,
          246},{1128,246}}, color={0,0,127}));
  connect(RTUCon.yComSpeCoo,mul. u2) annotation (Line(points={{1032,249.617},{
          1080,249.617},{1080,234},{1128,234}},
                                         color={0,0,127}));
  connect(mul.y, CooCoi.speRat) annotation (Line(points={{1152,240},{1160,240},
          {1160,-200},{230,-200},{230,-48},{239,-48}}, color={0,0,127}));
  connect(RTUCon.yDXHeaCoi, HeaCoi.on) annotation (Line(points={{1032,253},{1060,
          253},{1060,-180},{90,-180},{90,-48},{99,-48}},      color={255,0,255}));
  connect(timDXSta1.passed,RTUCon. uDXCooCoi) annotation (Line(points={{340,-148},
          {940,-148},{940,258.25},{1008,258.25}}, color={255,0,255}));
  connect(timDXSta.passed,RTUCon. uDXHeaCoi) annotation (Line(points={{202,-158},
          {950,-158},{950,256.5},{1008,256.5}},
                                            color={255,0,255}));
  connect(RTUCon.yAuxHea, mulAuxHea.u1) annotation (Line(points={{1032,243.667},
          {1040,243.667},{1040,-90},{530,-90},{530,-104},{538,-104}},
                                                                 color={0,0,127}));
  connect(hys1.y,timDXSta1. u) annotation (Line(points={{302,-140},{316,-140}},
          color={255,0,255}));
  connect(hys.y,timDXSta. u) annotation (Line(points={{162,-150},{178,-150}},
          color={255,0,255}));
  connect(CooCoi.P,hys1. u) annotation (Line(points={{261,-49},{261,-50},{270,
          -50},{270,-140},{278,-140}}, color={0,0,127}));
  connect(HeaCoi.P,hys. u) annotation (Line(points={{121,-49},{130,-49},{130,
          -150},{138,-150}}, color={0,0,127}));
  connect(fanSup.y_actual,hys2. u) annotation (Line(points={{421,-33},{421,-34},
          {450,-34},{450,-110},{458,-110}}, color={0,0,127}));
  connect(hys2.y,booToRea1. u) annotation (Line(points={{482,-110},{498,-110}},
          color={255,0,255}));
  connect(booToRea1.y,mulAuxHea. u2) annotation (Line(points={{522,-110},{528,
          -110},{528,-116},{538,-116}}, color={0,0,127}));
  connect(mulAuxHea.y, AuxHeaCoi.u) annotation (Line(points={{562,-110},{570,
          -110},{570,-80},{456,-80},{456,-34},{458,-34}}, color={0,0,127}));
  for i in 1:nCoiCoo loop
  connect(CooCoi[i].TOut, TOut.y) annotation (Line(points={{239,-43},{230,-43},{
          230,70},{-220,70},{-220,180},{-279,180}}, color={0,0,127}));
  end for;
  for i in 1:nCoiHea loop
  connect(HeaCoi[i].TOut, TOut.y) annotation (Line(points={{99,-36},{80,-36},{80,
          70},{-220,70},{-220,180},{-279,180}}, color={0,0,127}));
  connect(HeaCoi[i].phi, Phi.y) annotation (Line(points={{99,-32},{90,-32},{90,
            60},{-260,60},{-260,140},{-279,140}}, color={0,0,127}));
  end for;
  connect(RTUCon.uCooCoi, conTSup.yCoo) annotation (Line(points={{1008,245.417},
          {970,245.417},{970,-226},{-38,-226}},
                                           color={0,0,127}));
  connect(RTUCon.uHeaCoi, conTSup.yHea) annotation (Line(points={{1008,243.667},
          {980,243.667},{980,-214},{-38,-214}},
                                           color={0,0,127}));

  connect(not1.y,booToRea2. u)
    annotation (Line(points={{162,-100},{168,-100}},
                                                   color={255,0,255}));
  connect(mulOr.y, not1.u)
    annotation (Line(points={{124,-100},{138,-100}}, color={255,0,255}));
  connect(booToRea2.y, damPreInd.y) annotation (Line(points={{192,-100},{200,-100},
          {200,12},{110,12}}, color={0,0,127}));
  connect(RTUCon.yDXHeaCoi[1:nCoiHea], mulOr.u[1:nCoiHea]) annotation (Line(points={{1032,
          253},{1060,253},{1060,-180},{90,-180},{90,-100},{100,-100}},color={255,
          0,255}));
  connect(not2.y,booToRea3. u)
    annotation (Line(points={{332,-90},{338,-90}}, color={255,0,255}));
  connect(mulOr1.y, not2.u)
    annotation (Line(points={{302,-90},{308,-90}}, color={255,0,255}));
  connect(booToRea3.y, damPreInd1.y) annotation (Line(points={{362,-90},{374,-90},
          {374,12},{250,12}}, color={0,0,127}));
  connect(RTUCon.yDXCooCoi[1:nCoiCoo], mulOr1.u[1:nCoiCoo]) annotation (Line(points={{1032,
          256.5},{1070,256.5},{1070,-168},{260,-168},{260,-90},{278,-90}},color={255,0,255}));
  connect(booToRea1.y, damPreInd2.y) annotation (Line(points={{522,-110},{528,-110},
          {528,12},{470,12}}, color={0,0,127}));
  connect(TSupSet.TSet, RTUCon.TSupCoiSet) annotation (Line(points={{-178,-220},
          {1008,-220},{1008,234.333}}, color={0,0,127}));
  connect(RTUCon.TSupCoiHea, THeaCoi.T) annotation (Line(points={{1008,236.667},
          {970,236.667},{970,226},{140,226},{140,-29}}, color={0,0,127}));
  connect(TCooCoi.T, RTUCon.TSupCoiCoo) annotation (Line(points={{280,-29},{284,
          -29},{284,-6},{998,-6},{998,234},{1008,234},{1008,234.333}}, color={0,
          0,127}));
  connect(RTUCon.uDemLimLev,demLimLev1. y) annotation (Line(points={{1008,
          247.167},{1008,252},{940,252},{940,264},{932,264}},
                                         color={255,127,0}));
  connect(RTUCon.uCooCoiAva,con1. y) annotation (Line(points={{1008,254.75},{1008,
          258},{984,258},{984,364},{962,364}}, color={255,0,255}));
  connect(RTUCon.uHeaCoiAva,con2. y) annotation (Line(points={{1008,253},{1008,258},
          {978,258},{978,334},{932,334}}, color={255,0,255}));
  connect(RTUCon.uCooCoiSeq,conInt1. y) annotation (Line(points={{1008,251.25},{
          974,251.25},{974,314},{962,314}},
                                        color={255,127,0}));
  connect(conInt.y, RTUCon.uHeaCoiSeq) annotation (Line(points={{932,294},{950,
          294},{950,249.383},{1008,249.383}},
                                        color={255,127,0}));
  connect(con.y, conFanSup.uFan) annotation (Line(points={{320,58},{279,58},{
          279,56},{238,56}}, color={255,0,255}));
  connect(booToRea4.u, occSch.occupied) annotation (Line(points={{346,48},{322,
          48},{322,26},{-299,26},{-299,-216}}, color={255,0,255}));
  connect(booToRea4.y, mul1.u1)
    annotation (Line(points={{370,48},{386,48}}, color={0,0,127}));
  connect(conFanSup.y, mul1.u2) annotation (Line(points={{261,50},{261,88},{386,
          88},{386,36}}, color={0,0,127}));
  connect(mul1.y, fanSup.y)
    annotation (Line(points={{410,42},{410,-28}}, color={0,0,127}));
  annotation (
  defaultComponentName="hvac",
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-400},{1420,
            660}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of an HVAC system that supplies 5 zones:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC\">
Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</a>
for a description of the HVAC system.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is modulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure set point is adjusted so that at least one
VAV damper is 90% open.
The heating coil valve, outside air damper, and cooling coil valve are
modulated in sequence to maintain the supply air temperature set point.
The economizer control provides the following functions:
freeze protection, minimum outside air requirement, and supply air cooling,
see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.Economizer</a>.
The controller of the terminal units tracks the room air temperature set point
based on a \"dual maximum with constant volume heating\" logic, see
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV\">
Buildings.Examples.VAVReheat.BaseClasses.Controls.RoomVAV</a>.
</p>
<p>
There is also a finite state machine that transitions the mode of operation
of the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Guideline36\">
Buildings.Examples.VAVReheat.BaseClasses.Guideline36</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
November 9, 2021, by Baptiste:<br/>
Vectorized the terminal boxes to be expanded to any number of zones.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2735\">issue #2735</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for exhaust air damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 15, 2021, by David Blum:<br/>
Update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
October 27, 2020, by Antoine Gautier:<br/>
Refactored the supply air temperature control sequence.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2024\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for
defining duct static pressure setpoint.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,172},{220,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,100},{-158,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,96},{-2,82}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,-12},{-158,-52}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,60},{-118,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,96},{-12,62}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,86},{-22,72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{42,100},{56,60}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{104,100},{118,60}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,100},{-124,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-138,-12},{-124,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,20},{7,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={-98,23},
          rotation=90),
        Line(points={{106,60},{106,-6}}, color={0,0,255}),
        Line(points={{116,60},{116,-6}}, color={0,0,255}),
        Line(points={{106,34},{116,34}},   color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,16}),
        Ellipse(
          extent={{100,54},{112,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{106,54},{100,48},{112,48},{106,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={107,24}),
        Line(points={{44,60},{44,-6}},   color={0,0,255}),
        Line(points={{54,60},{54,-6}},   color={0,0,255}),
        Line(points={{44,34},{54,34}},     color={0,0,255}),
        Polygon(
          points={{-5,-4},{3,-4},{-1,4},{-5,-4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,16}),
        Ellipse(
          extent={{38,54},{50,42}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{44,54},{38,48},{50,48},{44,54}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-5,4},{3,4},{-1,-4},{-5,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={45,24}),
        Rectangle(
          extent={{320,172},{300,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,172},{260,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,172},{380,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,172},{340,100}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{240,20},{220,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{280,20},{260,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{320,20},{300,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{360,20},{340,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{400,20},{380,-12}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{380,136},{400,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={390,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={350,153},
          rotation=90),
        Rectangle(
          extent={{340,136},{360,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{300,136},{320,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={310,153},
          rotation=90),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={270,153},
          rotation=90),
        Rectangle(
          extent={{260,136},{280,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{220,136},{240,124}},
          lineColor={255,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-7,10},{7,-10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          origin={230,153},
          rotation=90)}));
end ASHRAE2006_RTU;
