within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPlant_bck
  "Block that computes the command signals for chillers and HRC"

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
  parameter Real PLRStaTra(final unit="1", final min=0, final max=1) = 0.85
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
    annotation (Placement(transformation(extent={{-280,40},{-240,80}}),
                             iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K", displayUnit="degC") "CHW supply temperature setpoint"
                                      annotation (Placement(transformation(
          extent={{-280,20},{-240,60}}),  iconTransformation(extent={{-140,20},{
            -100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatPriRet(final unit="K",
      displayUnit="degC") "Primary CHW return temperature" annotation (
      Placement(transformation(extent={{-280,-40},{-240,0}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHeaWatPri_flow(final unit="kg/s")
    "Primary HW mass flow rate" annotation (Placement(transformation(extent={{-280,
            -120},{-240,-80}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(
    final unit="K", displayUnit="degC")
    "HW supply temperature setpoint" annotation (Placement(transformation(
          extent={{-280,-160},{-240,-120}}),
                                        iconTransformation(extent={{-140,-120},{
            -100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatPriRet(final unit="K",
      displayUnit="degC") "Primary HW return temperature" annotation (Placement(
        transformation(extent={{-280,-200},{-240,-160}}), iconTransformation(
          extent={{-140,-140},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(final unit="K",
      displayUnit="degC") "CHW supply temperature" annotation (Placement(
        transformation(extent={{-328,140},{-288,180}}), iconTransformation(
          extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWat(final unit="Pa")
  "CHW loop differential pressure" annotation (
      Placement(transformation(extent={{-328,180},{-288,220}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpChiWatSet(final unit="Pa")
  "CHW loop differential pressure setpoint" annotation (
     Placement(transformation(extent={{-328,200},{-288,240}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-150,70},{-130,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaChiWat
    "Compute total chiller load"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTChiWat "Compute deltaT"
    annotation (Placement(transformation(extent={{-210,30},{-190,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply loaHeaWat
    "Compute total chiller load"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract dTHeaWat "Compute deltaT"
    annotation (Placement(transformation(extent={{-210,-190},{-190,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChi(final k=nChi/
        QChiWatChi_flow_nominal/PLRStaTra) "Scale"
    annotation (Placement(transformation(extent={{-110,70},{-90,90}})));
  Ceiling numChi(final yMin=0, final yMax=nChi)
    "Compute number of chillers required to meet cooling load"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter loaChiWatChi(final k=
        QChiWatChi_flow_nominal/nChi)
    "Compute minimum load covered by chillers"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-20})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract loaChiWatChiHea
    "Compute maximum load to be covered by HRC"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChiHea(
    final k=nChiHea/QChiWatCasCoo_flow_nominal/PLRStaTra) "Scale"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Ceiling numCoo(final yMin=0, final yMax=nChiHea)
    "Compute number of HRC required to meet cooling load"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(final nout=
        nChi)
    "Replicate"
    annotation (Placement(transformation(extent={{120,70},{140,90}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChi[nChi](final
      t={i for i in 1:nChi})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{150,70},{170,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo
    "Cooling enable signal"
    annotation (Placement(transformation(extent={{-280,100},{-240,140}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea
    "Heating enable signal"
    annotation (Placement(transformation(extent={{-280,80},{-240,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Chi[nChi]
    "Chiller On/Off command"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1CooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,0}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-40})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-210,90},{-190,110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter timCp1(final k=
        cp_default) "Scale"
    annotation (Placement(transformation(extent={{-210,-130},{-190,-110}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold scaChi1(t=nChi)
                                           "Scale"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea "Convert"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-170,10})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage movAve1(delta=300)
    "Moving average"
    annotation (Placement(transformation(extent={{-150,-170},{-130,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter scaChi3(final k=
        nChiHea/QHeaWat_flow_nominal/PLRStaTra)
                                           "Scale"
    annotation (Placement(transformation(extent={{-110,-170},{-90,-150}})));
  Ceiling numHea(final yMin=0, final yMax=nChiHea)
    "Compute number of HRC required to meet heating load"
    annotation (Placement(transformation(extent={{-80,-170},{-60,-150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep5(final nout=
        nChiHea)
    "Replicate"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cmdChiHea[nChiHea](
      final t={i for i in 1:nChiHea})
    "Compute chiller On/Off command from number of units to be commanded On"
    annotation (Placement(transformation(extent={{150,-150},{170,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiHeaCoo
    "Number of HRC required in direct HR mode" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,-70})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant numChiHea(final k=
        nChiHea) "Number of HRC"
    annotation (Placement(transformation(extent={{-40,-106},{-20,-86}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ChiHea[nChiHea]
    "HRC On/Off command" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-140}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,0})));
  IntegerArrayHold
              holChi(holdDuration=15*60, nin=1)
    "Hold signal to ensure minimum runtime at given stage"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeChi
    "Number of chillers both enabled and required to meet cooling load"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeCoo
    "Number of HRC both enabled and required to meet cooling load"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt2
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply numOpeHea
    "Number of HRC both enabled and required to meet heating load"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Add nChiHeaAndCooUnb
    "Number of HRC required to meet heating and cooling load - Unbounded"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-64})));
  Buildings.Controls.OBC.CDL.Integers.Subtract numChiCasCoo
    "Number of HRC required in cascading cooling"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  IntegerArrayHold
              holOpeChiHea(holdDuration=15*60, nin=1)
    "Hold signal to ensure minimum runtime at given stage"
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  ModeHeatRecoveryChiller modHeaCoo(final nChiHea=nChiHea)
    "Compute the indices of HRC required to be operating in direct HR mode"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1HeaCooChiHea[nChiHea]
    "HR chiller cooling mode switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={260,-70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={120,-80})));
  Buildings.Controls.OBC.CDL.Integers.Min nChiHeaHeaAndCoo
    "Number of HRC required to meet heating and cooling load - Bounded by number of HRC"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,-90})));
  IntegerArrayHold hol(nin=3, holdDuration=15*60)
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Max iniCoo
    "Initialize plant at stage 1 when cooling loop is enabled"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Integers.Max iniHea
    "Initialize plant at stage 1 when heating loop is enabled"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract errTChiWatSup
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-220,150},{-200,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract errDpChiWat
    "Compute tracking error"
    annotation (Placement(transformation(extent={{-220,190},{-200,210}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cmpErrLim(t=-1)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-180,150},{-160,170}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmpErrLim1(t=1E4)
    "Check tracking error limit"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timErrExcLim1(t=15*60)
    "Timer for error exceeding error limit"
    annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Failsafe condition to stage up"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOne(final p=1)
    "Add one unit"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFai
    "Switch to failsafe condition"
    annotation (Placement(transformation(extent={{-70,70},{-50,90}})));
  Modelica.Blocks.Continuous.FirstOrder fil2(T=60, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-270,150},{-250,170}})));
  Modelica.Blocks.Continuous.FirstOrder fil1(T=60, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter to break algebraic loop"
    annotation (Placement(transformation(extent={{-270,180},{-250,200}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-150,190},{-130,210}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Apply failsafe condition only in stage >= 1"
    annotation (Placement(transformation(extent={{-150,150},{-130,170}})));
equation
  connect(dTChiWat.y, loaChiWat.u2) annotation (Line(points={{-188,40},{-186,40},
          {-186,74},{-182,74}},   color={0,0,127}));
  connect(TChiWatSupSet, dTChiWat.u1) annotation (Line(points={{-260,40},{-230,40},
          {-230,46},{-212,46}},        color={0,0,127}));
  connect(TChiWatPriRet, dTChiWat.u2) annotation (Line(points={{-260,-20},{-220,
          -20},{-220,34},{-212,34}},color={0,0,127}));
  connect(dTHeaWat.y, loaHeaWat.u2) annotation (Line(points={{-188,-180},{-186,-180},
          {-186,-166},{-182,-166}},
                                  color={0,0,127}));
  connect(THeaWatSupSet, dTHeaWat.u1) annotation (Line(points={{-260,-140},{-230,
          -140},{-230,-174},{-212,-174}},         color={0,0,127}));
  connect(THeaWatPriRet, dTHeaWat.u2) annotation (Line(points={{-260,-180},{-230,
          -180},{-230,-186},{-212,-186}}, color={0,0,127}));
  connect(movAve.y, loaChiWatChiHea.u1) annotation (Line(points={{-128,80},{-120,
          80},{-120,0},{-140,0},{-140,-14},{-132,-14}},
                                   color={0,0,127}));
  connect(loaChiWatChi.y, loaChiWatChiHea.u2) annotation (Line(points={{-138,-20},
          {-134,-20},{-134,-26},{-132,-26}},
                                       color={0,0,127}));
  connect(loaChiWatChiHea.y, scaChiHea.u)
    annotation (Line(points={{-108,-20},{-102,-20}},
                                                 color={0,0,127}));
  connect(scaChiHea.y, numCoo.u)
    annotation (Line(points={{-78,-20},{-72,-20}},
                                                 color={0,0,127}));
  connect(rep.y, cmdChi.u)
    annotation (Line(points={{142,80},{148,80}}, color={255,127,0}));
  connect(movAve.y, scaChi.u)
    annotation (Line(points={{-128,80},{-112,80}}, color={0,0,127}));
  connect(mChiWatPri_flow, timCp.u)
    annotation (Line(points={{-260,60},{-220,60},{-220,100},{-212,100}},
                                                     color={0,0,127}));
  connect(timCp.y, loaChiWat.u1) annotation (Line(points={{-188,100},{-186,100},
          {-186,86},{-182,86}},   color={0,0,127}));
  connect(mHeaWatPri_flow, timCp1.u)
    annotation (Line(points={{-260,-100},{-222,-100},{-222,-120},{-212,-120}},
                                                     color={0,0,127}));
  connect(timCp1.y, loaHeaWat.u1) annotation (Line(points={{-188,-120},{-186,-120},
          {-186,-154},{-182,-154}},
                                  color={0,0,127}));
  connect(loaChiWat.y, movAve.u)
    annotation (Line(points={{-158,80},{-152,80}},   color={0,0,127}));
  connect(intToRea.y, loaChiWatChi.u)
    annotation (Line(points={{-170,-2},{-170,-20},{-162,-20}},
                                                   color={0,0,127}));
  connect(loaHeaWat.y, movAve1.u)
    annotation (Line(points={{-158,-160},{-152,-160}},
                                                     color={0,0,127}));
  connect(movAve1.y, scaChi3.u)
    annotation (Line(points={{-128,-160},{-112,-160}},
                                                   color={0,0,127}));
  connect(scaChi3.y, numHea.u)
    annotation (Line(points={{-88,-160},{-82,-160}}, color={0,0,127}));
  connect(rep5.y, cmdChiHea.u)
    annotation (Line(points={{142,-140},{148,-140}},
                                                 color={255,127,0}));
  connect(holChi.y[1], rep.u)
    annotation (Line(points={{102,80},{118,80}},  color={255,127,0}));
  connect(holChi.y[1], intToRea.u) annotation (Line(points={{102,80},{110,80},{
          110,40},{-170,40},{-170,22}},       color={255,127,0}));
  connect(u1Coo, booToInt.u) annotation (Line(points={{-260,120},{-122,120}},
                                color={255,0,255}));
  connect(numChi.y, numOpeChi.u2) annotation (Line(points={{-18,80},{-10,80},{-10,
          74},{-2,74}}, color={255,127,0}));
  connect(booToInt.y, numOpeChi.u1) annotation (Line(points={{-98,120},{-10,120},
          {-10,86},{-2,86}}, color={255,127,0}));
  connect(holChi.y[1], scaChi1.u) annotation (Line(points={{102,80},{110,80},{
          110,40},{-110,40},{-110,20},{-102,20}},
                                           color={255,127,0}));
  connect(scaChi1.y, booToInt1.u)
    annotation (Line(points={{-78,20},{-72,20}}, color={255,0,255}));
  connect(booToInt1.y, numOpeCoo.u1) annotation (Line(points={{-48,20},{-46,20},
          {-46,-14},{-42,-14}},
                              color={255,127,0}));
  connect(numCoo.y, numOpeCoo.u2) annotation (Line(points={{-48,-20},{-46,-20},{
          -46,-26},{-42,-26}},
                         color={255,127,0}));
  connect(u1Hea, booToInt2.u) annotation (Line(points={{-260,100},{-234,100},{
          -234,-80},{-112,-80}},color={255,0,255}));
  connect(numHea.y, numOpeHea.u2) annotation (Line(points={{-58,-160},{-50,-160},
          {-50,-146},{-42,-146}}, color={255,127,0}));
  connect(booToInt2.y, numOpeHea.u1) annotation (Line(points={{-88,-80},{-70,
          -80},{-70,-134},{-42,-134}},
                                  color={255,127,0}));
  connect(numOpeCoo.y, nChiHeaAndCooUnb.u1) annotation (Line(points={{-18,-20},{
          -10,-20},{-10,-40},{-50,-40},{-50,-58},{-42,-58}},
                                                   color={255,127,0}));
  connect(numOpeCoo.y, numChiCasCoo.u1) annotation (Line(points={{-18,-20},{10,-20},
          {10,-14},{18,-14}},
                            color={255,127,0}));
  connect(cmdChiHea.y, y1ChiHea)
    annotation (Line(points={{172,-140},{260,-140}}, color={255,0,255}));
  connect(modHeaCoo.y1HeaCoo, y1HeaCooChiHea) annotation (Line(points={{162,-46},
          {220,-46},{220,-70},{260,-70}}, color={255,0,255}));
  connect(numChiHea.y, nChiHeaHeaAndCoo.u2)
    annotation (Line(points={{-18,-96},{-12,-96}},
                                                 color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, nChiHeaHeaAndCoo.u1) annotation (Line(points={{-18,-64},
          {-14,-64},{-14,-84},{-12,-84}},   color={255,127,0}));
  connect(nChiHeaAndCooUnb.y, numChiHeaCoo.u1)
    annotation (Line(points={{-18,-64},{18,-64}},color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, numChiHeaCoo.u2) annotation (Line(points={{12,-90},
          {16,-90},{16,-76},{18,-76}}, color={255,127,0}));
  connect(modHeaCoo.y1Coo, y1CooChiHea) annotation (Line(points={{162,-34},{220,
          -34},{220,0},{260,0}},   color={255,0,255}));
  connect(numChiHeaCoo.y, numChiCasCoo.u2) annotation (Line(points={{42,-70},{46,
          -70},{46,-40},{10,-40},{10,-26},{18,-26}},
                                               color={255,127,0}));
  connect(numChiCasCoo.y, hol.u[1]) annotation (Line(points={{42,-20},{76,-20},
          {76,-40.6667},{78,-40.6667}},
                              color={255,127,0}));
  connect(numChiHeaCoo.y, hol.u[2]) annotation (Line(points={{42,-70},{76,-70},{
          76,-40},{78,-40}},     color={255,127,0}));
  connect(hol.y[1],modHeaCoo. nCasCoo) annotation (Line(points={{102,-40.6667},
          {126,-40.6667},{126,-40},{130,-40},{130,-34},{138,-34}},
                                                           color={255,127,0}));
  connect(hol.y[2],modHeaCoo. nHeaCoo) annotation (Line(points={{102,-40},{130,-40},
          {130,-46},{138,-46}},        color={255,127,0}));
  connect(nChiHeaHeaAndCoo.y, holOpeChiHea.u[1]) annotation (Line(points={{12,-90},
          {30,-90},{30,-140},{78,-140}},      color={255,127,0}));
  connect(numChiHeaCoo.y, hol.u[3]) annotation (Line(points={{42,-70},{76,-70},
          {76,-40},{78,-40},{78,-39.3333}}, color={255,127,0}));
  connect(holOpeChiHea.y[1], rep5.u)
    annotation (Line(points={{102,-140},{118,-140}}, color={255,127,0}));
  connect(numOpeChi.y, iniCoo.u2) annotation (Line(points={{22,80},{30,80},{30,74},
          {38,74}}, color={255,127,0}));
  connect(booToInt.y, iniCoo.u1) annotation (Line(points={{-98,120},{30,120},{
          30,86},{38,86}},
                        color={255,127,0}));
  connect(iniCoo.y, holChi.u[1])
    annotation (Line(points={{62,80},{78,80}}, color={255,127,0}));
  connect(numOpeHea.y, iniHea.u2) annotation (Line(points={{-18,-140},{-16,-140},
          {-16,-146},{-12,-146}}, color={255,127,0}));
  connect(booToInt2.y, iniHea.u1) annotation (Line(points={{-88,-80},{-70,-80},
          {-70,-124},{-16,-124},{-16,-134},{-12,-134}}, color={255,127,0}));
  connect(iniHea.y, nChiHeaAndCooUnb.u2) annotation (Line(points={{12,-140},{18,
          -140},{18,-120},{-50,-120},{-50,-70},{-42,-70}}, color={255,127,0}));
  connect(TChiWatSupSet, errTChiWatSup.u1) annotation (Line(points={{-260,40},{-244,
          40},{-244,42},{-230,42},{-230,166},{-222,166}}, color={0,0,127}));
  connect(dpChiWatSet, errDpChiWat.u1) annotation (Line(points={{-308,220},{
          -278,220},{-278,206},{-222,206}},
                                       color={0,0,127}));
  connect(errTChiWatSup.y, cmpErrLim.u)
    annotation (Line(points={{-198,160},{-182,160}}, color={0,0,127}));
  connect(errDpChiWat.y, cmpErrLim1.u)
    annotation (Line(points={{-198,200},{-182,200}}, color={0,0,127}));
  connect(timErrExcLim1.passed, or2.u1) annotation (Line(points={{-98,192},{-90,
          192},{-90,180},{-82,180}},   color={255,0,255}));
  connect(timErrExcLim.passed, or2.u2) annotation (Line(points={{-98,152},{-90,
          152},{-90,172},{-82,172}},   color={255,0,255}));
  connect(numChi.u, swiFai.y)
    annotation (Line(points={{-42,80},{-48,80}}, color={0,0,127}));
  connect(scaChi.y, swiFai.u3) annotation (Line(points={{-88,80},{-80,80},{-80,72},
          {-72,72}}, color={0,0,127}));
  connect(addOne.y, swiFai.u1) annotation (Line(points={{-38,140},{-30,140},{
          -30,100},{-74,100},{-74,88},{-72,88}},
                                             color={0,0,127}));
  connect(TChiWatSup, fil2.u)
    annotation (Line(points={{-308,160},{-272,160}}, color={0,0,127}));
  connect(fil2.y, errTChiWatSup.u2) annotation (Line(points={{-249,160},{-236,
          160},{-236,154},{-222,154}}, color={0,0,127}));
  connect(fil1.y, errDpChiWat.u2) annotation (Line(points={{-249,190},{-234,190},
          {-234,194},{-222,194}}, color={0,0,127}));
  connect(dpChiWat, fil1.u) annotation (Line(points={{-308,200},{-280,200},{
          -280,190},{-272,190}}, color={0,0,127}));
  connect(scaChi.y, addOne.u) annotation (Line(points={{-88,80},{-80,80},{-80,
          140},{-62,140}}, color={0,0,127}));
  connect(cmpErrLim1.y, and2.u1)
    annotation (Line(points={{-158,200},{-152,200}}, color={255,0,255}));
  connect(and2.y, timErrExcLim1.u)
    annotation (Line(points={{-128,200},{-122,200}}, color={255,0,255}));
  connect(cmpErrLim.y, and3.u1) annotation (Line(points={{-158,160},{-156,160},
          {-156,160},{-152,160}}, color={255,0,255}));
  connect(and3.y, timErrExcLim.u)
    annotation (Line(points={{-128,160},{-122,160}}, color={255,0,255}));
  connect(or2.y, swiFai.u2) annotation (Line(points={{-58,180},{-50,180},{-50,
          160},{-76,160},{-76,80},{-72,80}}, color={255,0,255}));
  connect(u1Coo, and3.u2) annotation (Line(points={{-260,120},{-156,120},{-156,
          152},{-152,152}}, color={255,0,255}));
  connect(u1Coo, and2.u2) annotation (Line(points={{-260,120},{-156,120},{-156,
          192},{-152,192}}, color={255,0,255}));
  connect(cmdChi.y, y1Chi)
    annotation (Line(points={{172,80},{260,80}}, color={255,0,255}));
  annotation (
  defaultComponentName="staPla",
  Documentation(info="<html>
</html>"),
    Diagram(coordinateSystem(extent={{-240,-240},{240,240}})),
    Icon(coordinateSystem(extent={{-100,-140},{100,140}}), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,150},{150,190}},
          textString="%name"),
        Rectangle(
          extent={{-100,-140},{100,140}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end StagingPlant_bck;
