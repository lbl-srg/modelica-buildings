within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass;
block FlowSetpoint "Chilled water minimum flow setpoint for primary-only plants"

  parameter Integer nChi = 3
    "Total number of chillers";
  parameter Boolean have_parChi=true
    "Flag: true means that the plant has parallel chillers";
  parameter Real byPasSetTim(
    final unit="s",
    final quantity="Time")=300
    "Time constant for resetting minimum bypass flow";
  parameter Real minFloSet[nChi](
    final unit=fill("m3/s",nChi),
    final quantity=fill("VolumeFlowRate",nChi),
    displayUnit=fill("m3/s",nChi)) = {0.005, 0.005, 0.005}
    "Minimum chilled water flow through each chiller";
  parameter Real maxFloSet[nChi](
    final unit=fill("m3/s",nChi),
    final quantity=fill("VolumeFlowRate",nChi),
    displayUnit=fill("m3/s",nChi)) = {0.025, 0.025, 0.025}
    "Maximum chilled water flow through each chiller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up logical signal"
    annotation (Placement(transformation(extent={{-480,500},{-440,540}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Resetting status of upstream device (in staging up or down process) before reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-480,460},{-440,500}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-480,420},{-440,460}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next chiller to be enabled"
    annotation (Placement(transformation(extent={{-480,150},{-440,190}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next chiller to be disabled"
    annotation (Placement(transformation(extent={{-480,10},{-440,50}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSubCha
    "Indicate if upstream device has been reset in the sub-process. This input is used when the stage change needs chiller on-off"
    annotation (Placement(transformation(extent={{-480,-200},{-440,-160}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-480,-240},{-440,-200}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down logical signal"
    annotation (Placement(transformation(extent={{-480,-310},{-440,-270}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0)
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{440,100},{480,140}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaSet
    "True: it is in the setpoint changing process"
    annotation (Placement(transformation(extent={{440,-460},{480,-420}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-60,258},{-40,278}})));
  Buildings.Controls.OBC.CDL.Reals.Line oneMorSet
    "Minimum flow setpoint when adding one more chiller"
    annotation (Placement(transformation(extent={{100,320},{120,340}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,300},{-40,320}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim(final t=byPasSetTim)
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-220,510},{-200,530}})));
  Buildings.Controls.OBC.CDL.Reals.Line oneLeSet
    "Minimum flow setpoint when disabling one chiller"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1(final t=byPasSetTim)
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-220,-300},{-200,-280}})));
  Buildings.Controls.OBC.CDL.Reals.Switch dowSet
    "Minimum flow chilled water flow setpoint when there is stage-down command"
    annotation (Placement(transformation(extent={{240,-32},{260,-12}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,-330},{-200,-310}})));
  Buildings.Controls.OBC.CDL.Reals.Switch byPasSet1
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{400,230},{420,250}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-320,510},{-300,530}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-320,-300},{-300,-280}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minFlo[nChi](
    final k=minFloSet)
    "Minimum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-400,290},{-380,310}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxFlo[nChi](
    final k=maxFloSet)
    "Maximum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-400,250},{-380,270}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[nChi](
    final k=fill(0,nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{-400,210},{-380,230}})));
  Buildings.Controls.OBC.CDL.Reals.Divide floRat[nChi]
    "Flow rate ratio through each chiller"
    annotation (Placement(transformation(extent={{-280,270},{-260,290}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiRat(final nin=nChi)
    if have_parChi
    "Flow rate ratio of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,180},{-200,200}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMaxFlo(final nin=nChi)
    if have_parChi "Maximum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,140},{-200,160}})));
  Buildings.Controls.OBC.CDL.Reals.Max max if have_parChi
    "Maximum flow rate ratio of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-80,180},{-60,200}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index vector"
    annotation (Placement(transformation(extent={{-400,60},{-380,80}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi) "Replicate integer input"
    annotation (Placement(transformation(extent={{-400,20},{-380,40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi] "Check equality of two integer inputs"
    annotation (Placement(transformation(extent={{-320,60},{-300,80}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nChi] "Outputs true if exactly one input is true"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi4[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro2 if have_parChi
    "Chilled water flow setpoint after disabling next chiller"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1 if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum1(final nin=nChi)
    if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax1(final nin=nChi)
    if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax2(final nin=nChi)
    if have_parChi
    "Maximum flow rate ratio of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax3(final nin=nChi)
    if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi5[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMinFlo(final nin=nChi)
    if not have_parChi "Minimum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2  "Logical and"
    annotation (Placement(transformation(extent={{-400,110},{-380,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi9[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-220,440},{-200,460}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax4(
    final nin=nChi) if have_parChi
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-180,440},{-160,460}})));
  Buildings.Controls.OBC.CDL.Reals.Switch  swi10[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-220,400},{-200,420}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum2(
    final nin=nChi) if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-180,400},{-160,420}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro3 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-60,420},{-40,440}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi11[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-220,320},{-200,340}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum3(
    final nin=nChi) if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-180,320},{-160,340}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi12[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-220,360},{-200,380}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax5(final nin=nChi)
    if have_parChi
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-180,360},{-160,380}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro4 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-60,340},{-40,360}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pro1 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax multiMax6(
    final nin=nChi) if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Switch byPasSet2
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{180,350},{200,370}})));
  Buildings.Controls.OBC.CDL.Reals.Switch upSet
    "Minimum flow chilled water flow setpoint when there is stage-up command"
    annotation (Placement(transformation(extent={{240,310},{260,330}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2(final t=byPasSetTim)
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-220,-260},{-200,-240}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-320,-260},{-300,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Line oneMorSet1
    "Minimum flow setpoint when adding one more chiller"
    annotation (Placement(transformation(extent={{100,-260},{120,-240}})));
  Buildings.Controls.OBC.CDL.Reals.Switch byPasSet4
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  Buildings.Controls.OBC.CDL.Reals.Switch chaSet
    "Minimum flow chilled water flow setpoint when there is stage-change command"
    annotation (Placement(transformation(extent={{300,190},{320,210}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{300,230},{320,250}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{340,230},{360,250}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Hold the chiller status when there is any stage change"
    annotation (Placement(transformation(extent={{-360,340},{-340,360}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi] "Boolean to real"
    annotation (Placement(transformation(extent={{-400,340},{-380,360}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-380,150},{-360,170}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr[nChi](
    final t=fill(0.5, nChi))
    "Convert real to boolean"
    annotation (Placement(transformation(extent={{-320,340},{-300,360}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-400,-80},{-380,-60}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=nChi)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-400,-170},{-380,-150}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{-360,-170},{-340,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-360,-80},{-340,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-320,-80},{-300,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Valid index"
    annotation (Placement(transformation(extent={{-320,-140},{-300,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul3 if not have_parChi
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1[2] if have_parChi
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=3)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-270,-80},{-250,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "True: if it is time to change the setpoint"
    annotation (Placement(transformation(extent={{-160,-430},{-140,-410}})));
  Buildings.Controls.OBC.CDL.Logical.Or or3
    "True: if it is time to change the setpoint"
    annotation (Placement(transformation(extent={{-60,-450},{-40,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Or or4
    "Check if the setpoint has been changed"
    annotation (Placement(transformation(extent={{-98,-360},{-78,-340}})));
  Buildings.Controls.OBC.CDL.Logical.Or or5
    "True: the setpoint has been changed"
    annotation (Placement(transformation(extent={{20,-380},{40,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "True: the setpoint has been changed"
    annotation (Placement(transformation(extent={{60,-380},{80,-360}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaSet
    "True: if it is not time to change the setpoint"
    annotation (Placement(transformation(extent={{22,-490},{42,-470}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi
    "Setpoint being set"
    annotation (Placement(transformation(extent={{120,-450},{140,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Check if the setpoint is being changed"
    annotation (Placement(transformation(extent={{240,-450},{260,-430}})));
  Buildings.Controls.OBC.CDL.Logical.Edge staChaSet
    "Start changing the setpoint"
    annotation (Placement(transformation(extent={{160,-510},{180,-490}})));
  Buildings.Controls.OBC.CDL.Logical.Not chaSetPro
    "True: it is in the setpoint changing process"
    annotation (Placement(transformation(extent={{320,-450},{340,-430}})));
  Buildings.Controls.OBC.CDL.Reals.Switch byPasSet3
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{400,110},{420,130}})));
  Buildings.Controls.OBC.CDL.Logical.Latch inStaCha
    "In stage changing process"
    annotation (Placement(transformation(extent={{340,110},{360,130}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    "Setpoint at the moment when ending stage change"
    annotation (Placement(transformation(extent={{340,70},{360,90}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge endSta
    "End staging change"
    annotation (Placement(transformation(extent={{240,50},{260,70}})));

  Buildings.Controls.OBC.CDL.Logical.Edge staChaSet1
    "Start changing the setpoint"
    annotation (Placement(transformation(extent={{180,-450},{200,-430}})));
equation
  connect(uStaDow, not2.u)
    annotation (Line(points={{-460,-290},{-410,-290},{-410,-320},{-222,-320}},
      color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-298,520},{-222,520}}, color={255,0,255}));
  connect(uStaDow, and3.u1)
    annotation (Line(points={{-460,-290},{-322,-290}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{-298,-290},{-222,-290}}, color={255,0,255}));
  connect(minFlo.y, floRat.u1)
    annotation (Line(points={{-378,300},{-300,300},{-300,286},{-282,286}},
      color={0,0,127}));
  connect(maxFlo.y, floRat.u2)
    annotation (Line(points={{-378,260},{-290,260},{-290,274},{-282,274}},
      color={0,0,127}));
  connect(nexDisChi, intRep.u)
    annotation (Line(points={{-460,30},{-402,30}},   color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-378,70},{-322,70}},   color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{-378,30},{-360,30},{-360,62},{-322,62}},
      color={255,127,0}));
  connect(intEqu.y, xor.u1)
    annotation (Line(points={{-298,70},{-222,70}},   color={255,0,255}));
  connect(xor.y, swi3.u2)
    annotation (Line(points={{-198,70},{-140,70},{-140,100},{-122,100}},
      color={255,0,255}));
  connect(xor.y, swi4.u2)
    annotation (Line(points={{-198,70},{-140,70},{-140,40},{-122,40}},
      color={255,0,255}));
  connect(multiMax2.y, pro2.u1)
    annotation (Line(points={{-58,100},{-40,100},{-40,76},{-22,76}},
      color={0,0,127}));
  connect(mulSum1.y, pro2.u2)
    annotation (Line(points={{-58,40},{-40,40},{-40,64},{-22,64}},
      color={0,0,127}));
  connect(swi3.y, multiMax2.u)
    annotation (Line(points={{-98,100},{-82,100}}, color={0,0,127}));
  connect(swi4.y, mulSum1.u)
    annotation (Line(points={{-98,40},{-82,40}}, color={0,0,127}));
  connect(swi5.y, multiMax1.u)
    annotation (Line(points={{-98,-50},{-82,-50}}, color={0,0,127}));
  connect(swi6.y, multiMax3.u)
    annotation (Line(points={{-78,-130},{-22,-130}}, color={0,0,127}));
  connect(multiMax1.y, max1.u1)
    annotation (Line(points={{-58,-50},{-40,-50},{-40,-84},{-22,-84}},
      color={0,0,127}));
  connect(xor.y, swi6.u2)
    annotation (Line(points={{-198,70},{-140,70},{-140,-130},{-102,-130}},
      color={255,0,255}));
  connect(uStaDow, or2.u2)
    annotation (Line(points={{-460,-290},{-410,-290},{-410,112},{-402,112}},
      color={255,0,255}));
  connect(uStaUp, or2.u1)
    annotation (Line(points={{-460,520},{-410,520},{-410,120},{-402,120}},
      color={255,0,255}));
  connect(booToRea.y, triSam.u)
    annotation (Line(points={{-378,350},{-362,350}}, color={0,0,127}));
  connect(or2.y, booRep.u)
    annotation (Line(points={{-378,120},{-370,120},{-370,140},{-390,140},{-390,160},
          {-382,160}}, color={255,0,255}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-358,160},{-350,160},{-350,338}}, color={255,0,255}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-460,440},{-420,440},{-420,350},{-402,350}},
      color={255,0,255}));
  connect(uChi, swi9.u2)
    annotation (Line(points={{-460,440},{-330,440},{-330,450},{-222,450}},
      color={255,0,255}));
  connect(uChi, swi10.u2)
    annotation (Line(points={{-460,440},{-330,440},{-330,410},{-222,410}},
      color={255,0,255}));
  connect(floRat.y, swi9.u1)
    annotation (Line(points={{-258,280},{-250,280},{-250,458},{-222,458}},
      color={0,0,127}));
  connect(swi9.y, multiMax4.u)
    annotation (Line(points={{-198,450},{-182,450}},
      color={0,0,127}));
  connect(maxFlo.y, swi10.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,418},{-222,418}},
      color={0,0,127}));
  connect(zer.y, swi9.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,442},{-222,442}},
      color={0,0,127}));
  connect(zer.y, swi10.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,402},{-222,402}},
      color={0,0,127}));
  connect(swi10.y, mulSum2.u)
    annotation (Line(points={{-198,410},{-182,410}},
      color={0,0,127}));
  connect(multiMax4.y, pro3.u1)
    annotation (Line(points={{-158,450},{-140,450},{-140,436},{-62,436}},
      color={0,0,127}));
  connect(mulSum2.y, pro3.u2)
    annotation (Line(points={{-158,410},{-140,410},{-140,424},{-62,424}},
      color={0,0,127}));
  connect(floRat.y, swi12.u1)
    annotation (Line(points={{-258,280},{-250,280},{-250,378},{-222,378}},
      color={0,0,127}));
  connect(triSam.y, greEquThr.u)
    annotation (Line(points={{-338,350},{-322,350}}, color={0,0,127}));
  connect(greEquThr.y, swi12.u2)
    annotation (Line(points={{-298,350},{-230,350},{-230,370},{-222,370}},
      color={255,0,255}));
  connect(greEquThr.y, swi11.u2)
    annotation (Line(points={{-298,350},{-230,350},{-230,330},{-222,330}},
      color={255,0,255}));
  connect(zer.y, swi12.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,362},{-222,362}},
      color={0,0,127}));
  connect(maxFlo.y, swi11.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,338},{-222,338}},
      color={0,0,127}));
  connect(zer.y, swi11.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,322},{-222,322}},
      color={0,0,127}));
  connect(swi12.y, multiMax5.u)
    annotation (Line(points={{-198,370},{-182,370}},
      color={0,0,127}));
  connect(swi11.y, mulSum3.u)
    annotation (Line(points={{-198,330},{-182,330}},
      color={0,0,127}));
  connect(multiMax5.y, pro4.u1)
    annotation (Line(points={{-158,370},{-120,370},{-120,356},{-62,356}},
      color={0,0,127}));
  connect(mulSum3.y, pro4.u2)
    annotation (Line(points={{-158,330},{-100,330},{-100,344},{-62,344}},
      color={0,0,127}));
  connect(multiMax5.y, max.u1)
    annotation (Line(points={{-158,370},{-120,370},{-120,196},{-82,196}},
      color={0,0,127}));
  connect(mulSum3.y, add2.u1)
    annotation (Line(points={{-158,330},{-100,330},{-100,156},{-82,156}},
      color={0,0,127}));
  connect(max.y, pro1.u1)
    annotation (Line(points={{-58,190},{-40,190},{-40,176},{-22,176}}, color={0,0,127}));
  connect(add2.y, pro1.u2)
    annotation (Line(points={{-58,150},{-40,150},{-40,164},{-22,164}}, color={0,0,127}));
  connect(maxFlo.y, nexChiMaxFlo.u)
    annotation (Line(points={{-378,260},{-290,260},{-290,150},{-222,150}},
      color={0,0,127}));
  connect(greEquThr.y, xor.u2)
    annotation (Line(points={{-298,350},{-230,350},{-230,62},{-222,62}},
      color={255,0,255}));
  connect(floRat.y, swi3.u1)
    annotation (Line(points={{-258,280},{-250,280},{-250,108},{-122,108}},
      color={0,0,127}));
  connect(zer.y, swi3.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,92},{-122,92}},
      color={0,0,127}));
  connect(zer.y, swi4.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,32},{-122,32}},
      color={0,0,127}));
  connect(maxFlo.y, swi4.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,48},{-122,48}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-460,440},{-330,440},{-330,-10},{-122,-10}},
      color={255,0,255}));
  connect(greEquThr.y, swi5.u2)
    annotation (Line(points={{-298,350},{-230,350},{-230,-50},{-122,-50}},
      color={255,0,255}));
  connect(swi1.y, multiMax6.u)
    annotation (Line(points={{-98,-10},{-82,-10}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,-18},{-122,-18}},
      color={0,0,127}));
  connect(zer.y, swi5.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,-58},{-122,-58}},
      color={0,0,127}));
  connect(maxFlo.y, swi1.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,-2},{-122,-2}},
      color={0,0,127}));
  connect(maxFlo.y, swi5.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,-42},{-122,-42}},
      color={0,0,127}));
  connect(maxFlo.y, nexChiMinFlo.u)
    annotation (Line(points={{-378,260},{-290,260},{-290,-90},{-222,-90}},
      color={0,0,127}));
  connect(maxFlo.y, swi6.u1)
    annotation (Line(points={{-378,260},{-290,260},{-290,-122},{-102,-122}},
      color={0,0,127}));
  connect(zer.y, swi6.u3)
    annotation (Line(points={{-378,220},{-240,220},{-240,-138},{-102,-138}},
      color={0,0,127}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-460,480},{-380,480},{-380,512},{-322,512}},
      color={255,0,255}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-460,520},{-322,520}}, color={255,0,255}));
  connect(con2.y, oneMorSet.x1)
    annotation (Line(points={{-38,310},{70,310},{70,338},{98,338}}, color={0,0,127}));
  connect(pro4.y, oneMorSet.f1)
    annotation (Line(points={{-38,350},{60,350},{60,334},{98,334}}, color={0,0,127}));
  connect(con3.y, oneMorSet.x2)
    annotation (Line(points={{-38,268},{80,268},{80,326},{98,326}}, color={0,0,127}));
  connect(pro1.y, oneMorSet.f2)
    annotation (Line(points={{2,170},{90,170},{90,322},{98,322}},
      color={0,0,127}));
  connect(tim.y, oneMorSet.u)
    annotation (Line(points={{-198,520},{50,520},{50,330},{98,330}},
      color={0,0,127}));
  connect(con2.y, oneLeSet.x1)
    annotation (Line(points={{-38,310},{70,310},{70,-22},{98,-22}},
      color={0,0,127}));
  connect(pro4.y, oneLeSet.f1)
    annotation (Line(points={{-38,350},{60,350},{60,-26},{98,-26}},
      color={0,0,127}));
  connect(con3.y, oneLeSet.x2)
    annotation (Line(points={{-38,268},{80,268},{80,-34},{98,-34}},
      color={0,0,127}));
  connect(pro2.y, oneLeSet.f2)
    annotation (Line(points={{2,70},{50,70},{50,-38},{98,-38}},
      color={0,0,127}));
  connect(oneMorSet.y, byPasSet2.u3)
    annotation (Line(points={{122,330},{170,330},{170,352},{178,352}},
      color={0,0,127}));
  connect(pro3.y, byPasSet2.u1)
    annotation (Line(points={{-38,430},{40,430},{40,368},{178,368}},
      color={0,0,127}));
  connect(uSubCha, byPasSet2.u2)
    annotation (Line(points={{-460,-180},{150,-180},{150,360},{178,360}},
      color={255,0,255}));
  connect(uOnOff, upSet.u2)
    annotation (Line(points={{-460,-220},{220,-220},{220,320},{238,320}},
      color={255,0,255}));
  connect(byPasSet2.y, upSet.u1)
    annotation (Line(points={{202,360},{220,360},{220,328},{238,328}},
      color={0,0,127}));
  connect(oneMorSet.y, upSet.u3)
    annotation (Line(points={{122,330},{170,330},{170,312},{238,312}},
      color={0,0,127}));
  connect(uStaDow, and2.u2)
    annotation (Line(points={{-460,-290},{-410,-290},{-410,-258},{-322,-258}},
      color={255,0,255}));
  connect(uSubCha, and2.u1)
    annotation (Line(points={{-460,-180},{-420,-180},{-420,-250},{-322,-250}},
      color={255,0,255}));
  connect(and2.y, tim2.u)
    annotation (Line(points={{-298,-250},{-222,-250}}, color={255,0,255}));
  connect(con2.y, oneMorSet1.x1)
    annotation (Line(points={{-38,310},{70,310},{70,-242},{98,-242}},
      color={0,0,127}));
  connect(pro4.y, oneMorSet1.f1)
    annotation (Line(points={{-38,350},{60,350},{60,-246},{98,-246}},
      color={0,0,127}));
  connect(con3.y, oneMorSet1.x2)
    annotation (Line(points={{-38,268},{80,268},{80,-254},{98,-254}},
      color={0,0,127}));
  connect(pro1.y, oneMorSet1.f2)
    annotation (Line(points={{2,170},{90,170},{90,-258},{98,-258}},
      color={0,0,127}));
  connect(tim2.y, oneMorSet1.u)
    annotation (Line(points={{-198,-250},{98,-250}}, color={0,0,127}));
  connect(oneMorSet1.y, byPasSet4.u3)
    annotation (Line(points={{122,-250},{140,-250},{140,-208},{158,-208}},
      color={0,0,127}));
  connect(uUpsDevSta, byPasSet4.u2)
    annotation (Line(points={{-460,480},{-430,480},{-430,-200},{158,-200}},
      color={255,0,255}));
  connect(pro3.y, byPasSet4.u1)
    annotation (Line(points={{-38,430},{40,430},{40,-192},{158,-192}},
      color={0,0,127}));
  connect(uOnOff, dowSet.u2)
    annotation (Line(points={{-460,-220},{220,-220},{220,-22},{238,-22}},
      color={255,0,255}));
  connect(byPasSet4.y, dowSet.u1)
    annotation (Line(points={{182,-200},{200,-200},{200,-14},{238,-14}},
      color={0,0,127}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-460,480},{-430,480},{-430,-298},{-322,-298}},
      color={255,0,255}));
  connect(tim1.y, oneLeSet.u)
    annotation (Line(points={{-198,-290},{30,-290},{30,-30},{98,-30}},
      color={0,0,127}));
  connect(oneLeSet.y, dowSet.u3)
    annotation (Line(points={{122,-30},{238,-30}},
      color={0,0,127}));
  connect(dowSet.y, chaSet.u3)
    annotation (Line(points={{262,-22},{270,-22},{270,192},{298,192}},
      color={0,0,127}));
  connect(upSet.y, chaSet.u1)
    annotation (Line(points={{262,320},{270,320},{270,208},{298,208}},
      color={0,0,127}));
  connect(uStaUp, chaSet.u2)
    annotation (Line(points={{-460,520},{-410,520},{-410,500},{280,500},{280,200},
          {298,200}}, color={255,0,255}));
  connect(not1.y, and4.u1)
    annotation (Line(points={{322,240},{338,240}}, color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{362,240},{398,240}}, color={255,0,255}));
  connect(not2.y, and4.u2)
    annotation (Line(points={{-198,-320},{330,-320},{330,232},{338,232}},
      color={255,0,255}));
  connect(chaSet.y, byPasSet1.u3)
    annotation (Line(points={{322,200},{380,200},{380,232},{398,232}},
      color={0,0,127}));
  connect(pro3.y, byPasSet1.u1)
    annotation (Line(points={{-38,430},{380,430},{380,248},{398,248}},
      color={0,0,127}));
  connect(uStaUp, not1.u)
    annotation (Line(points={{-460,520},{-410,520},{-410,500},{280,500},{280,240},
          {298,240}}, color={255,0,255}));
  connect(multiMax1.y, oneMorSet.f1)
    annotation (Line(points={{-58,-50},{60,-50},{60,334},{98,334}},
      color={0,0,127}));
  connect(multiMax1.y, oneMorSet1.f1)
    annotation (Line(points={{-58,-50},{60,-50},{60,-246},{98,-246}},
      color={0,0,127}));
  connect(max1.y, oneMorSet.f2)
    annotation (Line(points={{2,-90},{90,-90},{90,322},{98,322}},
      color={0,0,127}));
  connect(max1.y, oneMorSet1.f2)
    annotation (Line(points={{2,-90},{90,-90},{90,-258},{98,-258}},
      color={0,0,127}));
  connect(multiMax3.y, oneLeSet.f2)
    annotation (Line(points={{2,-130},{50,-130},{50,-38},{98,-38}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet2.u1)
    annotation (Line(points={{-58,-10},{40,-10},{40,368},{178,368}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet4.u1)
    annotation (Line(points={{-58,-10},{40,-10},{40,-192},{158,-192}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet1.u1)
    annotation (Line(points={{-58,-10},{40,-10},{40,280},{380,280},{380,248},{398,
          248}},     color={0,0,127}));
  connect(multiMax1.y, oneLeSet.f1)
    annotation (Line(points={{-58,-50},{60,-50},{60,-26},{98,-26}},
      color={0,0,127}));
  connect(floRat.y, nexChiRat.u)
    annotation (Line(points={{-258,280},{-250,280},{-250,190},{-222,190}},
      color={0,0,127}));
  connect(conInt1.y, intSwi.u3) annotation (Line(points={{-338,-160},{-330,-160},
          {-330,-138},{-322,-138}}, color={255,127,0}));
  connect(and5.y, booToRea1.u)
    annotation (Line(points={{-338,-70},{-322,-70}},   color={255,0,255}));
  connect(and5.y, intSwi.u2) annotation (Line(points={{-338,-70},{-330,-70},{-330,
          -130},{-322,-130}}, color={255,0,255}));
  connect(intGreEquThr.y, and5.u1)
    annotation (Line(points={{-378,-70},{-362,-70}},   color={255,0,255}));
  connect(intLesEquThr.y, and5.u2) annotation (Line(points={{-378,-160},{-370,-160},
          {-370,-78},{-362,-78}}, color={255,0,255}));
  connect(nexEnaChi, intGreEquThr.u) annotation (Line(points={{-460,170},{-420,170},
          {-420,-70},{-402,-70}}, color={255,127,0}));
  connect(nexEnaChi, intSwi.u1) annotation (Line(points={{-460,170},{-420,170},{
          -420,-122},{-322,-122}}, color={255,127,0}));
  connect(nexEnaChi, intLesEquThr.u) annotation (Line(points={{-460,170},{-420,170},
          {-420,-160},{-402,-160}}, color={255,127,0}));
  connect(intSwi.y, nexChiMinFlo.index) annotation (Line(points={{-298,-130},{-280,
          -130},{-280,-110},{-210,-110},{-210,-102}}, color={255,127,0}));
  connect(intSwi.y, nexChiMaxFlo.index) annotation (Line(points={{-298,-130},{-280,
          -130},{-280,130},{-210,130},{-210,138}}, color={255,127,0}));
  connect(intSwi.y, nexChiRat.index) annotation (Line(points={{-298,-130},{-280,
          -130},{-280,170},{-210,170},{-210,178}}, color={255,127,0}));
  connect(booToRea1.y, reaScaRep.u)
    annotation (Line(points={{-298,-70},{-272,-70}}, color={0,0,127}));
  connect(mul3.y, max1.u2) annotation (Line(points={{-98,-80},{-80,-80},{-80,-96},
          {-22,-96}},  color={0,0,127}));
  connect(reaScaRep.y[3], mul3.u1) annotation (Line(points={{-248,-69.3333},{
          -180,-69.3333},{-180,-74},{-122,-74}},
                                              color={0,0,127}));
  connect(reaScaRep.y[1], mul1[1].u2) annotation (Line(points={{-248,-70.6667},
          {-180,-70.6667},{-180,144},{-162,144}},color={0,0,127}));
  connect(reaScaRep.y[2], mul1[2].u2) annotation (Line(points={{-248,-70},{-180,
          -70},{-180,144},{-162,144}},color={0,0,127}));
  connect(nexChiMaxFlo.y, mul1[2].u1) annotation (Line(points={{-198,150},{-180,
          150},{-180,156},{-162,156}}, color={0,0,127}));
  connect(nexChiRat.y, mul1[1].u1) annotation (Line(points={{-198,190},{-180,190},
          {-180,156},{-162,156}}, color={0,0,127}));
  connect(mul1[1].y, max.u2) annotation (Line(points={{-138,150},{-120,150},{-120,
          184},{-82,184}}, color={0,0,127}));
  connect(mul1[2].y, add2.u2) annotation (Line(points={{-138,150},{-120,150},{-120,
          144},{-82,144}}, color={0,0,127}));
  connect(nexChiMinFlo.y, mul3.u2) annotation (Line(points={{-198,-90},{-180,-90},
          {-180,-86},{-122,-86}},   color={0,0,127}));
  connect(and2.y, or1.u1) annotation (Line(points={{-298,-250},{-270,-250},{-270,
          -420},{-162,-420}}, color={255,0,255}));
  connect(and3.y, or1.u2) annotation (Line(points={{-298,-290},{-260,-290},{-260,
          -428},{-162,-428}}, color={255,0,255}));
  connect(tim2.passed, or4.u1) annotation (Line(points={{-198,-258},{-120,-258},
          {-120,-350},{-100,-350}}, color={255,0,255}));
  connect(tim1.passed, or4.u2) annotation (Line(points={{-198,-298},{-140,-298},
          {-140,-358},{-100,-358}}, color={255,0,255}));
  connect(or1.y, or3.u1) annotation (Line(points={{-138,-420},{-100,-420},{-100,
          -440},{-62,-440}}, color={255,0,255}));
  connect(or4.y, or5.u1) annotation (Line(points={{-76,-350},{-30,-350},{-30,-370},
          {18,-370}}, color={255,0,255}));
  connect(and1.y, or3.u2) annotation (Line(points={{-298,520},{-284,520},{-284,-448},
          {-62,-448}}, color={255,0,255}));
  connect(tim.passed, or5.u2) annotation (Line(points={{-198,512},{-132,512},{-132,
          -378},{18,-378}}, color={255,0,255}));
  connect(or5.y, edg.u)
    annotation (Line(points={{42,-370},{58,-370}}, color={255,0,255}));
  connect(or3.y, logSwi.u2)
    annotation (Line(points={{-38,-440},{118,-440}}, color={255,0,255}));
  connect(edg.y, logSwi.u1) annotation (Line(points={{82,-370},{100,-370},{100,
          -432},{118,-432}},
                       color={255,0,255}));
  connect(or3.y, notChaSet.u) annotation (Line(points={{-38,-440},{-20,-440},{-20,
          -480},{20,-480}}, color={255,0,255}));
  connect(notChaSet.y, logSwi.u3) annotation (Line(points={{44,-480},{100,-480},
          {100,-448},{118,-448}}, color={255,0,255}));
  connect(or3.y, staChaSet.u) annotation (Line(points={{-38,-440},{-20,-440},{-20,
          -500},{158,-500}}, color={255,0,255}));
  connect(staChaSet.y, lat.clr) annotation (Line(points={{182,-500},{220,-500},{
          220,-446},{238,-446}}, color={255,0,255}));
  connect(lat.y, chaSetPro.u)
    annotation (Line(points={{262,-440},{318,-440}}, color={255,0,255}));
  connect(chaSetPro.y, yChaSet)
    annotation (Line(points={{342,-440},{460,-440}}, color={255,0,255}));
  connect(byPasSet1.y, byPasSet3.u1) annotation (Line(points={{422,240},{430,240},
          {430,180},{380,180},{380,128},{398,128}}, color={0,0,127}));
  connect(inStaCha.y, byPasSet3.u2)
    annotation (Line(points={{362,120},{398,120}}, color={255,0,255}));
  connect(or2.y, inStaCha.u)
    annotation (Line(points={{-378,120},{338,120}}, color={255,0,255}));
  connect(byPasSet1.y, triSam1.u) annotation (Line(points={{422,240},{430,240},{
          430,180},{320,180},{320,80},{338,80}}, color={0,0,127}));
  connect(endSta.y, triSam1.trigger)
    annotation (Line(points={{262,60},{350,60},{350,68}}, color={255,0,255}));
  connect(or2.y, endSta.u) annotation (Line(points={{-378,120},{200,120},{200,60},
          {238,60}}, color={255,0,255}));
  connect(endSta.y, inStaCha.clr) annotation (Line(points={{262,60},{300,60},{300,
          114},{338,114}}, color={255,0,255}));
  connect(triSam1.y, byPasSet3.u3) annotation (Line(points={{362,80},{380,80},{380,
          112},{398,112}}, color={0,0,127}));
  connect(byPasSet3.y, yChiWatMinFloSet)
    annotation (Line(points={{422,120},{460,120}}, color={0,0,127}));
  connect(logSwi.y, staChaSet1.u)
    annotation (Line(points={{142,-440},{178,-440}}, color={255,0,255}));
  connect(staChaSet1.y, lat.u)
    annotation (Line(points={{202,-440},{238,-440}}, color={255,0,255}));
annotation (
  defaultComponentName="minChiFloSet",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-36,42},{0,28}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,28},{0,14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,14},{0,0}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,0},{0,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,-14},{0,-28}}, lineColor={28,108,200}),
        Text(
          extent={{-32,38},{-12,32}},
          textColor={28,108,200},
          textString="Stage #"),
        Text(
          extent={{-30,24},{-10,18}},
          textColor={28,108,200},
          textString="0"),
        Text(
          extent={{-30,10},{-10,4}},
          textColor={28,108,200},
          textString="1"),
        Text(
          extent={{-30,-4},{-10,-10}},
          textColor={28,108,200},
          textString="2"),
        Rectangle(extent={{-36,-28},{0,-42}}, lineColor={28,108,200}),
        Text(
          extent={{-30,-18},{-10,-24}},
          textColor={28,108,200},
          textString="..."),
        Text(
          extent={{-30,-32},{-10,-38}},
          textColor={28,108,200},
          textString="n"),
        Rectangle(extent={{2,42},{38,28}}, lineColor={28,108,200}),
        Rectangle(extent={{2,28},{38,14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,14},{38,0}}, lineColor={28,108,200}),
        Rectangle(extent={{2,0},{38,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,-14},{38,-28}}, lineColor={28,108,200}),
        Text(
          extent={{8,38},{34,32}},
          textColor={28,108,200},
          textString="Min flow"),
        Text(
          extent={{6,24},{34,18}},
          textColor={28,108,200},
          textString="minFloSet[1]"),
        Rectangle(extent={{2,-28},{38,-42}}, lineColor={28,108,200}),
        Text(
          extent={{8,-18},{28,-24}},
          textColor={28,108,200},
          textString="..."),
        Text(
          extent={{6,10},{34,4}},
          textColor={28,108,200},
          textString="minFloSet[2]"),
        Text(
          extent={{6,-32},{34,-38}},
          textColor={28,108,200},
          textString="minFloSet[n]"),
        Text(
          extent={{6,-4},{34,-10}},
          textColor={28,108,200},
          textString="minFloSet[3]"),
        Text(
          extent={{-98,20},{-44,4}},
          textColor={255,127,0},
          textString="nexEnaChi"),
        Text(
          extent={{-98,0},{-44,-16}},
          textColor={255,127,0},
          textString="nexDisChi"),
        Text(
          extent={{-98,-82},{-52,-96}},
          textColor={255,0,255},
          textString="uStaDow"),
        Text(
          extent={{-102,-64},{-60,-76}},
          textColor={255,0,255},
          textString="uOnOff"),
        Text(
          extent={{-98,-32},{-52,-46}},
          textColor={255,0,255},
          textString="uSubCha"),
        Text(
          extent={{-98,98},{-58,84}},
          textColor={255,0,255},
          textString="uStaUp"),
        Text(
          extent={{-98,78},{-38,64}},
          textColor={255,0,255},
          textString="uUpsDevSta"),
        Text(
          extent={{-98,48},{-70,34}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{44,6},{98,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yChiWatMinFloSet"),
        Text(
          extent={{58,-68},{96,-88}},
          textColor={255,0,255},
          textString="yChaSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-440,-540},{440,540}}), graphics={
        Rectangle(
          extent={{-398,498},{18,42}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-398,18},{18,-178}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-92,494},{14,478}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with parallel chillers"),
        Text(
          extent={{-80,22},{18,6}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with series chillers"),
        Text(
          extent={{-54,214},{18,198}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-46,202},{18,188}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-34,102},{18,88}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller"),
        Text(
          extent={{-54,114},{18,98}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-38,-60},{26,-74}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-30,-142},{22,-156}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller"),
        Text(
          extent={{-92,472},{10,456}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint according to"),
        Text(
          extent={{-54,460},{10,446}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="current chillers status"),
        Text(
          extent={{-88,402},{14,386}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint according to"),
        Text(
          extent={{-66,390},{14,376}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="chillers status at the moment"),
        Text(
          extent={{-62,380},{16,366}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="when  requiring stage change"),
        Text(
          extent={{-38,4},{26,-10}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="current chillers status"),
        Rectangle(
          extent={{-438,-320},{238,-538}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{124,-330},{270,-350}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Check if it is in the setpoint changing process")}),
  Documentation(info="<html>
<p>
Block that outputs chilled water minimum flow setpoint for primary-only
plants with a minimum flow bypass valve,
according to ASHRAE Guideline36-2021,
section 5.20.8 Chilled water minimum flow bypass valve.
</p>
<p>
1. For plants with parallel chillers, bypass valve shall modulate to maintain minimum
flow as measured by the chilled water flow meter at a setpoint that ensures minimum
flow through all operating chillers, as follows:
</p>
<ul>
<li>
For the operating chillers in current stage, identify the chiller with the
highest ratio of <code>minFloSet</code> to <code>maxFloSet</code>.
</li>
<li>
Calculate the minimum flow setpoint as the highest ratio multiplied by the sum
of <code>maxFloSet</code> for the operating chillers.
</li>
</ul>
<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller </th>
<th> Minimum flow </th>
<th> Maximum flow </th>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
<td align=\"center\"><code>maxFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
<td align=\"center\"><code>maxFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>

<p>
2. For plants with series chillers, bypass valve shall modulate to maintain minimum
flow as measured by the chilled water flow meter at a setpoint equal to the largest
<code>minFloSet</code> of the operating chillers in current stage.
</p>
<p>
3. If there is any stage change requiring a chiller on and another chiller off,
the minimum flow setpoint shall temporarily change to account for the
<code>minFloSet</code> of both the chiller to be enabled and to be disabled
prior to starting the newly enabled chiller.
</p>
<p>
Note that when there is a stage change requiring a change in the
minimum flow setpoint, the change should be slowly.
For example, this could be accomplished by resetting the setpoint X GPM/second,
where <code>X = (NewSetpoint - OldSetpoint) / byPasSetTim</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 31, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowSetpoint;
