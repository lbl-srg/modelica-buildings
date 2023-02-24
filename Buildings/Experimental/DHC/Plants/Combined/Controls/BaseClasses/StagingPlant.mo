within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPlant
  "Block that computes plant stage and command signals for chillers and HRC"

  parameter Integer nChi(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Modelica.Units.SI.HeatFlowRate QChiWatChi_flow_nominal
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Integer nChiHea(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real PLRStaTra(unit="1")=0.85
    "Part load ratio triggering stage transition";
  parameter Modelica.Units.SI.HeatFlowRate QChiWatCasCoo_flow_nominal
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Specific heat capacity of the fluid";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput mChiWatPri_flow(
    final unit="kg/s")
    "Primary CHW mass flow rate"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC") "CHW supply temperature setpoint"
    annotation (Placement(transformation(
          extent={{-280,60},{-240,100}}), iconTransformation(extent={{-140,60},
            {-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(final unit="K",
      displayUnit="degC") "Primary CHW return temperature" annotation (
      Placement(transformation(extent={{-280,20},{-240,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHeaWatPri_flow(final unit="kg/s")
    "Primary HW mass flow rate" annotation (Placement(transformation(extent={{-280,
            -100},{-240,-60}}),iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "HW supply temperature setpoint" annotation (Placement(transformation(
          extent={{-280,-140},{-240,-100}}),
                                        iconTransformation(extent={{-140,-80},{
            -100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") "Primary HW return temperature" annotation (Placement(
        transformation(extent={{-280,-180},{-240,-140}}), iconTransformation(
          extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(final unit="K",
      displayUnit="degC") "CHW supply temperature" annotation (Placement(
        transformation(extent={{-280,180},{-240,220}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(final unit="Pa")
    "CHW loop differential pressure"
                                   annotation (
      Placement(transformation(extent={{-280,240},{-240,280}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(final unit="Pa")
    "CHW loop differential pressure setpoint"
                                            annotation (
     Placement(transformation(extent={{-280,260},{-240,300}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSup(final unit="K",
      displayUnit="degC") "HW supply temperature" annotation (Placement(
        transformation(extent={{-280,-240},{-240,-200}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWat(final unit="Pa")
    "HW loop differential pressure" annotation (Placement(transformation(extent
          ={{-280,-300},{-240,-260}}), iconTransformation(extent={{-140,-160},{
            -100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpHeaWatSet(final unit="Pa")
    "HW loop differential pressure setpoint" annotation (Placement(
        transformation(extent={{-280,-280},{-240,-240}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCooReq_flow(final unit="W")
    "Plant required cooling capacity (>0)" annotation (
      Placement(transformation(extent={{240,160},{280,200}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-280,140},{-240,180}}),
        iconTransformation(extent={{-140,122},{-100,162}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
        iconTransformation(extent={{-140,102},{-100,142}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HRC cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,40}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HRC On/Off command" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-100}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-20})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCooChiHea[nChiHea]
    "HRC cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-40}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-140})));

  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaChiWat
    "Compute total chiller load (>0)"
    annotation (Placement(transformation(extent={{-180,110},{-160,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTChiWatPos
    "Compute deltaT (>0)"
    annotation (Placement(transformation(extent={{-210,70},{-190,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaHeaWat
    "Compute total chiller load"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTHeaWat "Compute deltaT"
    annotation (Placement(transformation(extent={{-220,-150},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nChi) "Replicate"
    annotation (Placement(transformation(extent={{180,110},{200,130}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChi[nChi](final
      t={i for i in 1:nChi})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{210,110},{230,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-210,130},{-190,150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp1(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve1(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-150,-130},{-130,-110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{180,-110},{200,-90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChiHea[nChiHea](
      final t={i for i in 1:nChiHea})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{210,-110},{230,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiHeaCoo
    "Number of HRC required in direct HR mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-20})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numChiHea(final k=
        nChiHea) "Number of HRC"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Integers.Add nChiHeaAndCooUnb
    "Number of HRC required to meet heating and cooling load - Unbounded"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiCasCoo
    "Number of HRC required in cascading cooling"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  ModeHeatRecoveryChiller modHeaCoo(final nChiHea=nChiHea)
    "Compute the cascading cooling and direct HR switchover signals"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  Buildings.Controls.OBC.CDL.Integers.Min nChiHeaHeaAndCoo
    "Number of HRC required to meet heating and cooling load - Bounded by number of HRC"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-40})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract errTChiWatSup
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errDpChiWat
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-200,250},{-180,270}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cmpErrLim(t=-1, h=1E-4)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-170,200},{-150,220}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmpErrLim1(t=1.5E4, h=1E-1)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-170,250},{-150,270}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-110,200},{-90,220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim1(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-110,250},{-90,270}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Failsafe condition to stage up"
    annotation (Placement(transformation(extent={{-70,220},{-50,240}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-140,250},{-120,270}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-140,200},{-120,220}})));
  StageIndex staCoo(final nSta=nChi + nChiHea, tSta=15*60)
    "Compute cooling stage"
    annotation (Placement(transformation(extent={{50,144},{70,164}})));
  Modelica.Blocks.Sources.RealExpression capCoo(final y=abs(PLRStaTra*(min(nChi,
        staCoo.preIdxSta)/nChi*QChiWatChi_flow_nominal + max(0, staCoo.preIdxSta
         - nChi)/nChiHea*QChiWatCasCoo_flow_nominal)))
    "Total capacity at current stage (>0) times stage-up PLR limit "
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cmpOPLRLimUp(h=1E-1)
    "Check OPLR limit"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOPLRExcLim(t=15*60)
    "Timer for OPLR exceeding limit"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Failsafe condition or efficiency condition to stage up"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Integers.Min numOpeChi
    "Number of operating chillers"
    annotation (Placement(transformation(extent={{90,110},{110,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numChi(final k=nChi)
    "Number of chillers"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numOpeCooChiHea
    "Number of HRC required for cooling"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Sources.RealExpression capHea(final y=PLRStaTra*staHea.preIdxSta
        /nChiHea*QHeaWat_flow_nominal)
    "Total capacity at current stage times stage-up PLR limit "
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cmpOPLRLimUp1(h=1E-1)
    "Check OPLR limit"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOPLRExcLim1(t=15*60)
    "Timer for OPLR exceeding limit"
    annotation (Placement(transformation(extent={{-50,-130},{-30,-110}})));
  StageIndex staHea(final nSta=nChiHea, tSta=15*60) "Compute heating stage"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Modelica.Blocks.Sources.RealExpression capHeaLow(final y=PLRStaTra*max(0,
        staHea.preIdxSta - 1)/nChiHea*QHeaWat_flow_nominal)
    "Total capacity at next lower stage times stage-down PLR limit "
    annotation (Placement(transformation(extent={{-120,-178},{-100,-158}})));
  Buildings.Controls.OBC.CDL.Continuous.Less cmpOPLRLimDow(h=1E-1)
  "Check OPLR limit"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOPLRExcLim2(t=15*60)
    "Timer for OPLR exceeding limit"
    annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
  Modelica.Blocks.Sources.RealExpression capCooLow(final y=abs(PLRStaTra*(min(
        nChi, max(0, staCoo.preIdxSta - 1))/nChi*QChiWatChi_flow_nominal + max(
        0, staCoo.preIdxSta - 1 - nChi)/nChiHea*QChiWatCasCoo_flow_nominal)))
    "Total capacity at next lower stage (>0) times stage-down PLR limit "
    annotation (Placement(transformation(extent={{-120,62},{-100,82}})));
  Buildings.Controls.OBC.CDL.Continuous.Less cmpOPLRLimDow1(h=1E-1)
    "Check OPLR limit"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timOPLRExcLim3(t=15*60)
    "Timer for OPLR exceeding limit"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notFail
    "Failsafe conditions are not true"
    annotation (Placement(transformation(extent={{-40,190},{-20,210}})));
  Buildings.Controls.OBC.CDL.Logical.And dowAndNotFail
    "No stage up failsafe condition and efficiency condition to stage down"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errTChiWatSup1
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errDpHeaWat
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-200,-290},{-180,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold
                                                      cmpErrLim2(t=+1, h=1E-4)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-170,-230},{-150,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmpErrLim3(t=1.5E4, h=1E-1)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-170,-290},{-150,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim2(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-110,-230},{-90,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim3(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-110,-290},{-90,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3 "Failsafe condition to stage up"
    annotation (Placement(transformation(extent={{-70,-270},{-50,-250}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-140,-230},{-120,-210}})));
  Buildings.Controls.OBC.CDL.Logical.Not notFail1
    "Failsafe conditions are not true"
    annotation (Placement(transformation(extent={{-30,-230},{-10,-210}})));

  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Failsafe condition or efficiency condition to stage up"
    annotation (Placement(transformation(extent={{10,-130},{30,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And dowAndNotFail1
    "No stage up failsafe condition and efficiency condition to stage down"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  IntegerArrayHold hol(holdDuration=15*60, nin=4)
    "Minimum plant stage runtime (needed because cooling and heating stage runtimes are handled separately)"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));

equation
  connect(dTChiWatPos.y, loaChiWat.u2) annotation (Line(points={{-188,80},{-186,
          80},{-186,114},{-182,114}},
                                    color={0,0,127}));
  connect(dTHeaWat.y, loaHeaWat.u2) annotation (Line(points={{-198,-140},{-186,
          -140},{-186,-126},{-182,-126}},
                                  color={0,0,127}));
  connect(THeaWatSupSet, dTHeaWat.u1) annotation (Line(points={{-260,-120},{
          -230,-120},{-230,-134},{-222,-134}},    color={0,0,127}));
  connect(THeaWatPriRet, dTHeaWat.u2) annotation (Line(points={{-260,-160},{
          -226,-160},{-226,-146},{-222,-146}},
                                          color={0,0,127}));
  connect(rep.y, cmdChi.u)
    annotation (Line(points={{202,120},{208,120}},
                                                 color={255,127,0}));
  connect(mChiWatPri_flow, timCp.u)
    annotation (Line(points={{-260,100},{-220,100},{-220,140},{-212,140}},
                                                     color={0,0,127}));
  connect(timCp.y, loaChiWat.u1) annotation (Line(points={{-188,140},{-186,140},
          {-186,126},{-182,126}}, color={0,0,127}));
  connect(mHeaWatPri_flow, timCp1.u)
    annotation (Line(points={{-260,-80},{-222,-80}}, color={0,0,127}));
  connect(timCp1.y, loaHeaWat.u1) annotation (Line(points={{-198,-80},{-186,-80},
          {-186,-114},{-182,-114}},
                                  color={0,0,127}));
  connect(loaChiWat.y, movAve.u)
    annotation (Line(points={{-158,120},{-152,120}}, color={0,0,127}));
  connect(loaHeaWat.y, movAve1.u)
    annotation (Line(points={{-158,-120},{-152,-120}},
                                                     color={0,0,127}));
  connect(rep5.y, cmdChiHea.u)
    annotation (Line(points={{202,-100},{208,-100}},
                                                 color={255,127,0}));
  connect(cmdChiHea.y, y1ChiHea)
    annotation (Line(points={{232,-100},{260,-100}}, color={255,0,255}));
  connect(modHeaCoo.y1HeaCoo, y1HeaCooChiHea) annotation (Line(points={{202,-6},
          {220,-6},{220,-40},{260,-40}},  color={255,0,255}));
  connect(numChiHea.y, nChiHeaHeaAndCoo.u2)
    annotation (Line(points={{-58,-40},{-50,-40},{-50,-46},{-42,-46}},
                                                 color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, nChiHeaHeaAndCoo.u1) annotation (Line(points={{-58,0},
          {-50,0},{-50,-34},{-42,-34}},     color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, numChiHeaCoo.u1)
    annotation (Line(points={{-58,0},{-20,0},{-20,-14},{-2,-14}},
                                                 color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, numChiHeaCoo.u2) annotation (Line(points={{-18,-40},
          {-10,-40},{-10,-26},{-2,-26}},
                                       color={255,127,0}));
  connect(modHeaCoo.y1Coo, y1CooChiHea) annotation (Line(points={{202,6},{220,6},
          {220,40},{260,40}},      color={255,0,255}));
  connect(numChiHeaCoo.y, numChiCasCoo.u2) annotation (Line(points={{22,-20},{
          30,-20},{30,14},{38,14}},            color={255,127,0}));
  connect(TChiWatSupSet, errTChiWatSup.u1) annotation (Line(points={{-260,80},{
          -230,80},{-230,180},{-204,180},{-204,216},{-202,216}},
                                                          color={0,0,127}));
  connect(dpChiWatSet, errDpChiWat.u1) annotation (Line(points={{-260,280},{
          -206,280},{-206,266},{-202,266}},
                                       color={0,0,127}));
  connect(errTChiWatSup.y, cmpErrLim.u)
    annotation (Line(points={{-178,210},{-172,210}}, color={0,0,127}));
  connect(errDpChiWat.y, cmpErrLim1.u)
    annotation (Line(points={{-178,260},{-172,260}}, color={0,0,127}));
  connect(timErrExcLim1.passed, or2.u1) annotation (Line(points={{-88,252},{-80,
          252},{-80,230},{-72,230}},   color={255,0,255}));
  connect(timErrExcLim.passed, or2.u2) annotation (Line(points={{-88,202},{-80,
          202},{-80,222},{-72,222}},   color={255,0,255}));
  connect(cmpErrLim1.y, and2.u1)
    annotation (Line(points={{-148,260},{-142,260}}, color={255,0,255}));
  connect(and2.y, timErrExcLim1.u)
    annotation (Line(points={{-118,260},{-112,260}}, color={255,0,255}));
  connect(cmpErrLim.y, and3.u1) annotation (Line(points={{-148,210},{-142,210}},
                                  color={255,0,255}));
  connect(and3.y, timErrExcLim.u)
    annotation (Line(points={{-118,210},{-112,210}}, color={255,0,255}));
  connect(u1Coo, and3.u2) annotation (Line(points={{-260,160},{-146,160},{-146,
          202},{-142,202}}, color={255,0,255}));
  connect(u1Coo, and2.u2) annotation (Line(points={{-260,160},{-146,160},{-146,
          252},{-142,252}}, color={255,0,255}));
  connect(cmdChi.y, y1Chi)
    annotation (Line(points={{232,120},{260,120}},
                                                 color={255,0,255}));
  connect(u1Coo, staCoo.u1)
    annotation (Line(points={{-260,160},{48,160}},  color={255,0,255}));
  connect(cmpOPLRLimUp.y, timOPLRExcLim.u)
    annotation (Line(points={{-58,120},{-42,120}},
                                                 color={255,0,255}));
  connect(or2.y, or1.u1) annotation (Line(points={{-48,230},{-6,230},{-6,140},{
          -2,140}},  color={255,0,255}));
  connect(or1.y, staCoo.u1Up) annotation (Line(points={{22,140},{24,140},{24,
          154},{48,154}}, color={255,0,255}));
  connect(timOPLRExcLim.passed, or1.u2) annotation (Line(points={{-18,112},{-14,
          112},{-14,132},{-2,132}},
                                 color={255,0,255}));
  connect(numChi.y, numOpeChi.u2) annotation (Line(points={{72,100},{84,100},{
          84,114},{88,114}},
                        color={255,127,0}));
  connect(staCoo.idxSta, numOpeChi.u1) annotation (Line(points={{72,154},{80,
          154},{80,126},{88,126}},
                                 color={255,127,0}));
  connect(staCoo.idxSta, numOpeCooChiHea.u1) annotation (Line(points={{72,154},
          {80,154},{80,60},{-132,60},{-132,26},{-122,26}},   color={255,127,0}));
  connect(numOpeChi.y, numOpeCooChiHea.u2) annotation (Line(points={{112,120},{
          120,120},{120,54},{-126,54},{-126,14},{-122,14}},  color={255,127,0}));
  connect(numOpeCooChiHea.y, nChiHeaAndCooUnb.u1) annotation (Line(points={{-98,20},
          {-90,20},{-90,6},{-82,6}},           color={255,127,0}));
  connect(cmpOPLRLimUp1.y, timOPLRExcLim1.u)
    annotation (Line(points={{-58,-120},{-52,-120}}, color={255,0,255}));
  connect(u1Hea, staHea.u1) annotation (Line(points={{-260,140},{-234,140},{
          -234,-100},{40,-100},{40,-114},{48,-114}},   color={255,0,255}));
  connect(cmpOPLRLimDow.y, timOPLRExcLim2.u)
    annotation (Line(points={{-58,-160},{-52,-160}}, color={255,0,255}));
  connect(cmpOPLRLimDow1.y, timOPLRExcLim3.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={255,0,255}));
  connect(or2.y, notFail.u) annotation (Line(points={{-48,230},{-46,230},{-46,
          200},{-42,200}}, color={255,0,255}));
  connect(dowAndNotFail.y, staCoo.u1Dow) annotation (Line(points={{22,100},{26,
          100},{26,148.2},{48,148.2}},color={255,0,255}));
  connect(timOPLRExcLim3.passed, dowAndNotFail.u2) annotation (Line(points={{-18,72},
          {-10,72},{-10,92},{-2,92}},         color={255,0,255}));
  connect(notFail.y, dowAndNotFail.u1) annotation (Line(points={{-18,200},{-10,
          200},{-10,100},{-2,100}},
                                  color={255,0,255}));
  connect(staHea.idxSta, nChiHeaAndCooUnb.u2) annotation (Line(points={{72,-120},
          {80,-120},{80,-80},{-100,-80},{-100,-6},{-82,-6}},   color={255,127,0}));
  connect(numOpeCooChiHea.y, numChiCasCoo.u1) annotation (Line(points={{-98,20},
          {30,20},{30,26},{38,26}},    color={255,127,0}));
  connect(movAve.y, cmpOPLRLimUp.u1)
    annotation (Line(points={{-128,120},{-82,120}},
                                                  color={0,0,127}));
  connect(capCoo.y, cmpOPLRLimUp.u2) annotation (Line(points={{-99,100},{-94,
          100},{-94,112},{-82,112}},
                              color={0,0,127}));
  connect(movAve.y, cmpOPLRLimDow1.u1) annotation (Line(points={{-128,120},{-90,
          120},{-90,80},{-82,80}},color={0,0,127}));
  connect(capCooLow.y, cmpOPLRLimDow1.u2)
    annotation (Line(points={{-99,72},{-82,72}}, color={0,0,127}));
  connect(capHea.y, cmpOPLRLimUp1.u2) annotation (Line(points={{-99,-140},{-94,
          -140},{-94,-128},{-82,-128}}, color={0,0,127}));
  connect(movAve1.y, cmpOPLRLimUp1.u1)
    annotation (Line(points={{-128,-120},{-82,-120}}, color={0,0,127}));
  connect(capHeaLow.y, cmpOPLRLimDow.u2) annotation (Line(points={{-99,-168},{
          -82,-168}},                       color={0,0,127}));
  connect(movAve1.y, cmpOPLRLimDow.u1) annotation (Line(points={{-128,-120},{
          -90,-120},{-90,-160},{-82,-160}}, color={0,0,127}));
  connect(TChiWatSupSet, dTChiWatPos.u2) annotation (Line(points={{-260,80},{
          -230,80},{-230,74},{-212,74}}, color={0,0,127}));
  connect(TChiWatPriRet, dTChiWatPos.u1) annotation (Line(points={{-260,40},{
          -220,40},{-220,86},{-212,86}},color={0,0,127}));
  connect(dpHeaWatSet, errDpHeaWat.u1) annotation (Line(points={{-260,-260},{
          -206,-260},{-206,-274},{-202,-274}}, color={0,0,127}));
  connect(errTChiWatSup1.y, cmpErrLim2.u)
    annotation (Line(points={{-178,-220},{-172,-220}}, color={0,0,127}));
  connect(errDpHeaWat.y, cmpErrLim3.u)
    annotation (Line(points={{-178,-280},{-172,-280}}, color={0,0,127}));
  connect(cmpErrLim3.y,and1. u1)
    annotation (Line(points={{-148,-280},{-142,-280}},
                                                     color={255,0,255}));
  connect(and1.y,timErrExcLim3. u)
    annotation (Line(points={{-118,-280},{-112,-280}},
                                                     color={255,0,255}));
  connect(cmpErrLim2.y, and4.u1)
    annotation (Line(points={{-148,-220},{-142,-220}}, color={255,0,255}));
  connect(and4.y, timErrExcLim2.u)
    annotation (Line(points={{-118,-220},{-112,-220}}, color={255,0,255}));
  connect(or3.y, notFail1.u) annotation (Line(points={{-48,-260},{-40,-260},{
          -40,-220},{-32,-220}}, color={255,0,255}));
  connect(THeaWatSupSet, errTChiWatSup1.u1) annotation (Line(points={{-260,-120},
          {-230,-120},{-230,-200},{-206,-200},{-206,-214},{-202,-214}}, color={
          0,0,127}));
  connect(timErrExcLim2.passed, or3.u1) annotation (Line(points={{-88,-228},{
          -80,-228},{-80,-260},{-72,-260}}, color={255,0,255}));
  connect(timErrExcLim3.passed, or3.u2) annotation (Line(points={{-88,-288},{
          -80,-288},{-80,-268},{-72,-268}}, color={255,0,255}));
  connect(u1Hea, and4.u2) annotation (Line(points={{-260,140},{-234,140},{-234,
          -240},{-144,-240},{-144,-228},{-142,-228}}, color={255,0,255}));
  connect(u1Hea, and1.u2) annotation (Line(points={{-260,140},{-234,140},{-234,
          -240},{-144,-240},{-144,-288},{-142,-288}}, color={255,0,255}));
  connect(timOPLRExcLim1.passed, or4.u1) annotation (Line(points={{-28,-128},{
          -20,-128},{-20,-120},{8,-120}}, color={255,0,255}));
  connect(or3.y, or4.u2) annotation (Line(points={{-48,-260},{0,-260},{0,-128},
          {8,-128}}, color={255,0,255}));
  connect(timOPLRExcLim2.passed, dowAndNotFail1.u1) annotation (Line(points={{
          -28,-168},{-20,-168},{-20,-160},{8,-160}}, color={255,0,255}));
  connect(notFail1.y, dowAndNotFail1.u2) annotation (Line(points={{-8,-220},{4,
          -220},{4,-168},{8,-168}}, color={255,0,255}));
  connect(dowAndNotFail1.y, staHea.u1Dow) annotation (Line(points={{32,-160},{
          40,-160},{40,-125.8},{48,-125.8}}, color={255,0,255}));
  connect(or4.y, staHea.u1Up)
    annotation (Line(points={{32,-120},{48,-120}}, color={255,0,255}));
  connect(numOpeChi.y, hol.u[1]) annotation (Line(points={{112,120},{120,120},{
          120,-0.75},{128,-0.75}}, color={255,127,0}));
  connect(numChiCasCoo.y, hol.u[2]) annotation (Line(points={{62,20},{116,20},{
          116,-0.25},{128,-0.25}}, color={255,127,0}));
  connect(numChiHeaCoo.y, hol.u[3]) annotation (Line(points={{22,-20},{116,-20},
          {116,0.25},{128,0.25}},
                             color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, hol.u[4]) annotation (Line(points={{-18,-40},{120,
          -40},{120,-2},{128,-2},{128,0.75}},
                                       color={255,127,0}));
  connect(hol.y[1], rep.u) annotation (Line(points={{152,0},{160,0},{160,120},{
          178,120}}, color={255,127,0}));
  connect(hol.y[2], modHeaCoo.nCasCoo) annotation (Line(points={{152,0},{160,0},
          {160,6},{178,6}},   color={255,127,0}));
  connect(hol.y[3], modHeaCoo.nHeaCoo) annotation (Line(points={{152,0},{160,0},
          {160,-6},{178,-6}},
                            color={255,127,0}));
  connect(hol.y[4], rep5.u) annotation (Line(points={{152,0},{160,0},{160,-100},
          {178,-100}},color={255,127,0}));
  connect(movAve.y, QCooReq_flow) annotation (Line(points={{-128,120},{-100,120},
          {-100,180},{260,180}}, color={0,0,127}));
  connect(dpChiWat, errDpChiWat.u2) annotation (Line(points={{-260,260},{-220,
          260},{-220,254},{-202,254}}, color={0,0,127}));
  connect(TChiWatSup, errTChiWatSup.u2) annotation (Line(points={{-260,200},{
          -220,200},{-220,204},{-202,204}}, color={0,0,127}));
  connect(THeaWatSup, errTChiWatSup1.u2) annotation (Line(points={{-260,-220},{
          -220,-220},{-220,-226},{-202,-226}}, color={0,0,127}));
  connect(dpHeaWat, errDpHeaWat.u2) annotation (Line(points={{-260,-280},{-220,
          -280},{-220,-286},{-202,-286}}, color={0,0,127}));
  annotation (
  defaultComponentName="staPla",
  Documentation(info="<html>
<p>
This block implements the staging logic for the chillers and HRCs.
The units are staged in part based on an efficiency condition
using the operative part load ratio.
The units are also staged based on failsafe conditions using the CHW and HW
supply temperature and differential pressure.
</p>
<p>
For the sake of simplicity, equipment rotation (i.e. the possibility at a given
stage that either one unit or another unit can be operating) is not taken into account.
</p>
<h4>Plant stages</h4>
<p>
At cooling (resp. heating) stage <code>#i</code>, a number <code>i</code>
of units are operating in cooling (resp. heating) mode.
The cooling (resp. heating) stage <code>#0</code> (no unit operating in
that given mode) is active whenever the plant is disabled based on the cooling
and heating Enable condition (see below) or when the plant is enabled
and has been staged down due to the efficiency or failsafe conditions.
The plant stage is given by the couple (cooling stage, heating stage).
The minimum runtime of each plant stage is set to <i>15&nbsp;</i>min.
</p>
<h5>Direct heat recovery mode</h5>
<p>
All HRCs are allowed to operate in direct heat recovery mode, that is when
their condenser is indexed to the HW loop and their evaporator is indexed to the
CHW loop.
Switching a HRC to operate in direct heat recovery mode is done on
a load requirement basis. This means that HRCs are first switched over
to cascading heating or cascading cooling mode. Only when all HRCs are operating
and when a new stage up event is initiated, an additional HRC is then switched
to operate in direct heat recovery mode.
As described in
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.ModeHeatRecoveryChiller\">
Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses.ModeHeatRecoveryChiller</a>
the HRC with the highest index that is not operating operating in cascading
cooling mode is the next to be switched into direct heat recovery mode.
</p>
<p>
For example, considering a plant with two chillers and three HRCs, the table below shows
the plant stages derived from this logic.
In this table, the chiller with index <code>#i</code> is denoted <code>CHI#i</code>,
the HRC with index <code>#i</code> is denoted <code>HRC#i</code>,
the units enumerated before (resp. after) the semicolon sign (<code>:</code>) operate
in cooling (resp. heating) mode, the units marked with a star (<code>*</code>) operate
in direct heat recovery mode.
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr><th>Heating stage &darr; Cooling stage &rarr;</th>
<td>0</td>
<td>1</td>
<td>2</td>
<td>3</td>
<td>4</td>
<td>5</td>
</tr>
<tr><td>0</td>
<td>N/A:<br/>N/A</td>
<td>CHI1:<br/>N/A</td>
<td>CHI1 &amp; CHI2:<br/>N/A</td>
<td>CHI1 &amp; CHI2 &amp; HRC3:<br/>N/A</td>
<td>CHI1 &amp; CHI2 &amp; HRC3 &amp; HRC2:<br/>N/A</td>
<td>CHI1 &amp; CHI2 &amp; HRC3 &amp; HRC2 &amp; HRC1:<br/>N/A</td>
</tr>
<tr><td>1</td>
<td>N/A:<br/>HRC1</td>
<td>CHI1:<br/>HRC1</td>
<td>CHI1 &amp; CHI2:<br/>HRC1</td>
<td>CHI1 &amp; CHI2 &amp; HRC3:<br/>HRC1</td>
<td>CHI1 &amp; CHI2 &amp; HRC3 &amp; HRC2:<br/>HRC1</td>
<td>CHI1 &amp; CHI2 &amp; HRC3 &amp; HRC2:<br/>HRC1*</td>
</tr>
<tr><td>2</td>
<td>N/A:<br/>HRC1 &amp; HRC2</td>
<td>CHI1:<br/>HRC1 &amp; HRC2</td>
<td>CHI1 &amp; CHI2:<br/>HRC1 &amp; HRC2</td>
<td>CHI1 &amp; CHI2 &amp; HRC3:<br/>HRC1 &amp; HRC2</td>
<td>CHI1 &amp; CHI2 &amp; HRC3:<br/>HRC1 &amp; HRC2*</td>
<td>CHI1 &amp; CHI2 &amp; HRC3:<br/>HRC1* &amp; HRC2*</td>
</tr>
<tr><td>3</td>
<td>N/A:<br/>HRC1 &amp; HRC2 &amp; HRC3</td>
<td>CHI1:<br/>HRC1 &amp; HRC2 &amp; HRC3</td>
<td>CHI1 &amp; CHI2:<br/>HRC1 &amp; HRC2 &amp; HRC3</td>
<td>CHI1 &amp; CHI2:<br/>HRC1 &amp; HRC2 &amp; HRC3*</td>
<td>CHI1 &amp; CHI2:<br/>HRC1 &amp; HRC2* &amp; HRC3*</td>
<td>CHI1 &amp; CHI2:<br/>HRC1* &amp; HRC2* &amp; HRC3*</td>
</tr>
</table>
<h4>Cooling and heating Enable condition</h4>
<p>
The cooling and heating Enable signals <code>u1Coo</code> and <code>u1Hea</code>
shall be computed outside of the plant model,
at least based on a time schedule and ideally in conjunction
with a signal representative of the demand such as the requests yielded by
the consumer control valves.
Based on those signals, the cooling (resp. heating) stage <code>#1</code> is
activated whenever the cooling (resp. heating) Enable signal switches
to <code>true</code> and when cooling (resp. heating) has been disabled
for at least <i>15&nbsp;</i>min.
</p>
<h4>Operative part load ratio</h4>
<p>
The efficiency condition is based on the operative part load ratio
which is computed as the ratio of the required capacity
relative to design capacity of a given stage, which is the sum of the design capacity
of each unit active in a given stage.
The required capacity is calculated based on the primary mass flow rate and the
temperature difference between supply and primary return, and averaged over a
<i>5</i>-minute moving window.
<h4>Cooling and heating staging</h4>
<p>
A stage up event is initiated if any of the following conditions is true.
</p>
<ul>
<li>
Efficiency condition: the operative part load ratio of the current stage
exceeds the value of the parameter <i>PLRStaTra</i> for <i>15&nbsp;</i>min.
</li>
<li>
Failsafe conditions: the CHW (resp. HW) supply temperature is <i>1&nbsp;</i>K
higher (resp. lower) than setpoint for <i>15</i>&nbsp;min, or
the CHW (resp. HW) differential pressure is <i>1.5E4&nbsp;</i>Pa lower than
setpoint for <i>15&nbsp;</i>min.
</li>
</ul>
<p>
A stage down event is initiated if both of the following conditions are true.
</p>
<ul>
<li>
Efficiency condition: the operative part load ratio of the next lower stage
falls below the value of the parameter <i>PLRStaTra</i> for <i>15&nbsp;</i>min.
</li>
<li>
Failsafe conditions: the failsafe stage up conditions are not true.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-240,-320},{240,320}})),
    Icon(coordinateSystem(extent={{-100,-160},{100,160}}), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,170},{150,210}},
          textString="%name"),
        Rectangle(
          extent={{-100,-160},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end StagingPlant;
