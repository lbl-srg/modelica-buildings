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
    annotation (Placement(transformation(extent={{-480,400},{-440,440}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Resetting status of upstream device (in staging up or down process) before reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-480,360},{-440,400}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-480,320},{-440,360}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next chiller to be enabled"
    annotation (Placement(transformation(extent={{-480,50},{-440,90}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next chiller to be disabled"
    annotation (Placement(transformation(extent={{-480,-90},{-440,-50}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSubCha
    "Indicate if upstream device has been reset in the sub-process. This input is used when the stage change needs chiller on-off"
    annotation (Placement(transformation(extent={{-480,-300},{-440,-260}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-480,-340},{-440,-300}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down logical signal"
    annotation (Placement(transformation(extent={{-480,-410},{-440,-370}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0)
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{440,120},{480,160}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{-60,158},{-40,178}})));
  Buildings.Controls.OBC.CDL.Continuous.Line oneMorSet
    "Minimum flow setpoint when adding one more chiller"
    annotation (Placement(transformation(extent={{100,220},{120,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-218,410},{-198,430}})));
  Buildings.Controls.OBC.CDL.Continuous.Line oneLeSet
    "Minimum flow setpoint when disabling one chiller"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-220,-400},{-200,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch dowSet
    "Minimum flow chilled water flow setpoint when there is stage-down command"
    annotation (Placement(transformation(extent={{240,-130},{260,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-220,-430},{-200,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch byPasSet1
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{400,130},{420,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-320,410},{-300,430}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-320,-400},{-300,-380}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nChi](
    final k=minFloSet)
    "Minimum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-400,190},{-380,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxFlo[nChi](
    final k=maxFloSet)
    "Maximum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-400,150},{-380,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChi](
    final k=fill(0,nChi)) "Constant zero"
    annotation (Placement(transformation(extent={{-400,110},{-380,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide floRat[nChi]
    "Flow rate ratio through each chiller"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiRat(final nin=nChi)
    if have_parChi
    "Flow rate ratio of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,80},{-200,100}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMaxFlo(final nin=nChi)
    if have_parChi "Maximum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max if have_parChi
    "Maximum flow rate ratio of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](
    final k=chiInd) "Chiller index vector"
    annotation (Placement(transformation(extent={{-400,-40},{-380,-20}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    final nout=nChi) "Replicate integer input"
    annotation (Placement(transformation(extent={{-400,-80},{-380,-60}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi] "Check equality of two integer inputs"
    annotation (Placement(transformation(extent={{-320,-40},{-300,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nChi] "Outputs true if exactly one input is true"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro2 if have_parChi
    "Chilled water flow setpoint after disabling next chiller"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-20,-200},{0,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(final nin=nChi)
    if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(final nin=nChi)
    if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax2(final nin=nChi)
    if have_parChi
    "Maximum flow rate ratio of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax3(final nin=nChi)
    if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-20,-240},{0,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi5[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMinFlo(final nin=nChi)
    if not have_parChi "Minimum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-220,-200},{-200,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi6[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-100,-240},{-80,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2  "Logical and"
    annotation (Placement(transformation(extent={{-400,-10},{-380,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi9[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-220,340},{-200,360}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax4(
    final nin=nChi) if have_parChi
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-180,340},{-160,360}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch  swi10[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-220,300},{-200,320}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(
    final nin=nChi) if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-180,300},{-160,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro3 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-60,320},{-40,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi11[nChi] if have_parChi
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-220,220},{-200,240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum3(
    final nin=nChi) if have_parChi
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi12[nChi] if have_parChi
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-220,260},{-200,280}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax5(final nin=nChi)
    if have_parChi
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-180,260},{-160,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro4 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-60,240},{-40,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1 if have_parChi
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax6(
    final nin=nChi) if not have_parChi
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1[nChi] if not have_parChi
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch byPasSet2
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{180,250},{200,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch upSet
    "Minimum flow chilled water flow setpoint when there is stage-up command"
    annotation (Placement(transformation(extent={{240,210},{260,230}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim2
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{-220,-360},{-200,-340}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-320,-360},{-300,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Line oneMorSet1
    "Minimum flow setpoint when adding one more chiller"
    annotation (Placement(transformation(extent={{100,-360},{120,-340}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch byPasSet4
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{160,-310},{180,-290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch chaSet
    "Minimum flow chilled water flow setpoint when there is stage-change command"
    annotation (Placement(transformation(extent={{300,40},{320,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{300,130},{320,150}})));
  Buildings.Controls.OBC.CDL.Logical.And and4 "Logical and"
    annotation (Placement(transformation(extent={{340,130},{360,150}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam[nChi]
    "Hold the chiller status when there is any stage change"
    annotation (Placement(transformation(extent={{-360,240},{-340,260}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nChi] "Boolean to real"
    annotation (Placement(transformation(extent={{-400,240},{-380,260}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    final nout=nChi) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-380,30},{-360,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr[nChi](
    final t=fill(0.5, nChi))
    "Convert real to boolean"
    annotation (Placement(transformation(extent={{-320,240},{-300,260}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(
    final t=1)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-400,-180},{-380,-160}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr(
    final t=nChi)
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-400,-270},{-380,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Dummy index so the extractor will not have out of range index"
    annotation (Placement(transformation(extent={{-360,-270},{-340,-250}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "Check if index is in the range"
    annotation (Placement(transformation(extent={{-360,-180},{-340,-160}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-320,-180},{-300,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Valid index"
    annotation (Placement(transformation(extent={{-320,-240},{-300,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3 if not have_parChi
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{-120,-190},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1[2] if have_parChi
    "Ensure zero output when the index is out of range"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=3)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-270,-180},{-250,-160}})));
equation
  connect(uStaDow, not2.u)
    annotation (Line(points={{-460,-390},{-410,-390},{-410,-420},{-222,-420}},
      color={255,0,255}));
  connect(byPasSet1.y, yChiWatMinFloSet)
    annotation (Line(points={{422,140},{460,140}}, color={0,0,127}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-298,420},{-220,420}}, color={255,0,255}));
  connect(uStaDow, and3.u1)
    annotation (Line(points={{-460,-390},{-322,-390}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{-298,-390},{-222,-390}}, color={255,0,255}));
  connect(minFlo.y, floRat.u1)
    annotation (Line(points={{-378,200},{-300,200},{-300,186},{-282,186}},
      color={0,0,127}));
  connect(maxFlo.y, floRat.u2)
    annotation (Line(points={{-378,160},{-290,160},{-290,174},{-282,174}},
      color={0,0,127}));
  connect(nexDisChi, intRep.u)
    annotation (Line(points={{-460,-70},{-402,-70}}, color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-378,-30},{-322,-30}}, color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{-378,-70},{-360,-70},{-360,-38},{-322,-38}},
      color={255,127,0}));
  connect(intEqu.y, xor.u1)
    annotation (Line(points={{-298,-30},{-222,-30}}, color={255,0,255}));
  connect(xor.y, swi3.u2)
    annotation (Line(points={{-198,-30},{-140,-30},{-140,0},{-122,0}},
      color={255,0,255}));
  connect(xor.y, swi4.u2)
    annotation (Line(points={{-198,-30},{-140,-30},{-140,-60},{-122,-60}},
      color={255,0,255}));
  connect(multiMax2.y, pro2.u1)
    annotation (Line(points={{-58,0},{-40,0},{-40,-24},{-22,-24}},
      color={0,0,127}));
  connect(mulSum1.y, pro2.u2)
    annotation (Line(points={{-58,-60},{-40,-60},{-40,-36},{-22,-36}},
      color={0,0,127}));
  connect(swi3.y, multiMax2.u)
    annotation (Line(points={{-98,0},{-82,0}},   color={0,0,127}));
  connect(swi4.y, mulSum1.u)
    annotation (Line(points={{-98,-60},{-82,-60}},   color={0,0,127}));
  connect(swi5.y, multiMax1.u)
    annotation (Line(points={{-98,-150},{-82,-150}},   color={0,0,127}));
  connect(swi6.y, multiMax3.u)
    annotation (Line(points={{-78,-230},{-22,-230}},   color={0,0,127}));
  connect(multiMax1.y, max1.u1)
    annotation (Line(points={{-58,-150},{-40,-150},{-40,-184},{-22,-184}},
      color={0,0,127}));
  connect(xor.y, swi6.u2)
    annotation (Line(points={{-198,-30},{-140,-30},{-140,-230},{-102,-230}},
      color={255,0,255}));
  connect(uStaDow, or2.u2)
    annotation (Line(points={{-460,-390},{-410,-390},{-410,-8},{-402,-8}},
      color={255,0,255}));
  connect(uStaUp, or2.u1)
    annotation (Line(points={{-460,420},{-410,420},{-410,0},{-402,0}},
      color={255,0,255}));
  connect(booToRea.y, triSam.u)
    annotation (Line(points={{-378,250},{-362,250}}, color={0,0,127}));
  connect(or2.y, booRep.u)
    annotation (Line(points={{-378,0},{-370,0},{-370,20},{-390,20},{-390,40},
      {-382,40}}, color={255,0,255}));
  connect(booRep.y, triSam.trigger)
    annotation (Line(points={{-358,40},{-350,40},{-350,238}},   color={255,0,255}));
  connect(uChi, booToRea.u)
    annotation (Line(points={{-460,340},{-420,340},{-420,250},{-402,250}},
      color={255,0,255}));
  connect(uChi, swi9.u2)
    annotation (Line(points={{-460,340},{-330,340},{-330,350},{-222,350}},
      color={255,0,255}));
  connect(uChi, swi10.u2)
    annotation (Line(points={{-460,340},{-330,340},{-330,310},{-222,310}},
      color={255,0,255}));
  connect(floRat.y, swi9.u1)
    annotation (Line(points={{-258,180},{-250,180},{-250,358},{-222,358}},
      color={0,0,127}));
  connect(swi9.y, multiMax4.u)
    annotation (Line(points={{-198,350},{-188,350},{-188,350},{-182,350}},
      color={0,0,127}));
  connect(maxFlo.y, swi10.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,318},{-222,318}},
      color={0,0,127}));
  connect(zer.y, swi9.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,342},{-222,342}},
      color={0,0,127}));
  connect(zer.y, swi10.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,302},{-222,302}},
      color={0,0,127}));
  connect(swi10.y, mulSum2.u)
    annotation (Line(points={{-198,310},{-190,310},{-190,310},{-182,310}},
      color={0,0,127}));
  connect(multiMax4.y, pro3.u1)
    annotation (Line(points={{-158,350},{-140,350},{-140,336},{-62,336}},
      color={0,0,127}));
  connect(mulSum2.y, pro3.u2)
    annotation (Line(points={{-158,310},{-140,310},{-140,324},{-62,324}},
      color={0,0,127}));
  connect(floRat.y, swi12.u1)
    annotation (Line(points={{-258,180},{-250,180},{-250,278},{-222,278}},
      color={0,0,127}));
  connect(triSam.y, greEquThr.u)
    annotation (Line(points={{-338,250},{-322,250}}, color={0,0,127}));
  connect(greEquThr.y, swi12.u2)
    annotation (Line(points={{-298,250},{-230,250},{-230,270},{-222,270}},
      color={255,0,255}));
  connect(greEquThr.y, swi11.u2)
    annotation (Line(points={{-298,250},{-230,250},{-230,230},{-222,230}},
      color={255,0,255}));
  connect(zer.y, swi12.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,262},{-222,262}},
      color={0,0,127}));
  connect(maxFlo.y, swi11.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,238},{-222,238}},
      color={0,0,127}));
  connect(zer.y, swi11.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,222},{-222,222}},
      color={0,0,127}));
  connect(swi12.y, multiMax5.u)
    annotation (Line(points={{-198,270},{-190,270},{-190,270},{-182,270}},
      color={0,0,127}));
  connect(swi11.y, mulSum3.u)
    annotation (Line(points={{-198,230},{-190,230},{-190,230},{-182,230}},
      color={0,0,127}));
  connect(multiMax5.y, pro4.u1)
    annotation (Line(points={{-158,270},{-120,270},{-120,256},{-62,256}},
      color={0,0,127}));
  connect(mulSum3.y, pro4.u2)
    annotation (Line(points={{-158,230},{-100,230},{-100,244},{-62,244}},
      color={0,0,127}));
  connect(multiMax5.y, max.u1)
    annotation (Line(points={{-158,270},{-120,270},{-120,96},{-82,96}},
      color={0,0,127}));
  connect(mulSum3.y, add2.u1)
    annotation (Line(points={{-158,230},{-100,230},{-100,56},{-82,56}},
      color={0,0,127}));
  connect(max.y, pro1.u1)
    annotation (Line(points={{-58,90},{-40,90},{-40,76},{-22,76}}, color={0,0,127}));
  connect(add2.y, pro1.u2)
    annotation (Line(points={{-58,50},{-40,50},{-40,64},{-22,64}}, color={0,0,127}));
  connect(maxFlo.y, nexChiMaxFlo.u)
    annotation (Line(points={{-378,160},{-290,160},{-290,50},{-222,50}},
      color={0,0,127}));
  connect(greEquThr.y, xor.u2)
    annotation (Line(points={{-298,250},{-230,250},{-230,-38},{-222,-38}},
      color={255,0,255}));
  connect(floRat.y, swi3.u1)
    annotation (Line(points={{-258,180},{-250,180},{-250,8},{-122,8}},
      color={0,0,127}));
  connect(zer.y, swi3.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,-8},{-122,-8}},
      color={0,0,127}));
  connect(zer.y, swi4.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,-68},{-122,-68}},
      color={0,0,127}));
  connect(maxFlo.y, swi4.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,-52},{-122,-52}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-460,340},{-330,340},{-330,-110},{-122,-110}},
      color={255,0,255}));
  connect(greEquThr.y, swi5.u2)
    annotation (Line(points={{-298,250},{-230,250},{-230,-150},{-122,-150}},
      color={255,0,255}));
  connect(swi1.y, multiMax6.u)
    annotation (Line(points={{-98,-110},{-82,-110}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,-118},{-122,-118}},
      color={0,0,127}));
  connect(zer.y, swi5.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,-158},{-122,-158}},
      color={0,0,127}));
  connect(maxFlo.y, swi1.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,-102},{-122,-102}},
      color={0,0,127}));
  connect(maxFlo.y, swi5.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,-142},{-122,-142}},
      color={0,0,127}));
  connect(maxFlo.y, nexChiMinFlo.u)
    annotation (Line(points={{-378,160},{-290,160},{-290,-190},{-222,-190}},
      color={0,0,127}));
  connect(maxFlo.y, swi6.u1)
    annotation (Line(points={{-378,160},{-290,160},{-290,-222},{-102,-222}},
      color={0,0,127}));
  connect(zer.y, swi6.u3)
    annotation (Line(points={{-378,120},{-240,120},{-240,-238},{-102,-238}},
      color={0,0,127}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-460,380},{-380,380},{-380,412},{-322,412}},
      color={255,0,255}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-460,420},{-322,420}}, color={255,0,255}));
  connect(con2.y, oneMorSet.x1)
    annotation (Line(points={{-38,210},{70,210},{70,238},{98,238}}, color={0,0,127}));
  connect(pro4.y, oneMorSet.f1)
    annotation (Line(points={{-38,250},{60,250},{60,234},{98,234}}, color={0,0,127}));
  connect(con3.y, oneMorSet.x2)
    annotation (Line(points={{-38,168},{80,168},{80,226},{98,226}}, color={0,0,127}));
  connect(pro1.y, oneMorSet.f2)
    annotation (Line(points={{2,70},{90,70},{90,222},{98,222}},
      color={0,0,127}));
  connect(tim.y, oneMorSet.u)
    annotation (Line(points={{-196,420},{50,420},{50,230},{98,230}},
      color={0,0,127}));
  connect(con2.y, oneLeSet.x1)
    annotation (Line(points={{-38,210},{70,210},{70,-132},{98,-132}},
      color={0,0,127}));
  connect(pro4.y, oneLeSet.f1)
    annotation (Line(points={{-38,250},{60,250},{60,-136},{98,-136}},
      color={0,0,127}));
  connect(con3.y, oneLeSet.x2)
    annotation (Line(points={{-38,168},{80,168},{80,-144},{98,-144}},
      color={0,0,127}));
  connect(pro2.y, oneLeSet.f2)
    annotation (Line(points={{2,-30},{50,-30},{50,-148},{98,-148}},
      color={0,0,127}));
  connect(oneMorSet.y, byPasSet2.u3)
    annotation (Line(points={{122,230},{170,230},{170,252},{178,252}},
      color={0,0,127}));
  connect(pro3.y, byPasSet2.u1)
    annotation (Line(points={{-38,330},{40,330},{40,268},{178,268}},
      color={0,0,127}));
  connect(uSubCha, byPasSet2.u2)
    annotation (Line(points={{-460,-280},{150,-280},{150,260},{178,260}},
      color={255,0,255}));
  connect(uOnOff, upSet.u2)
    annotation (Line(points={{-460,-320},{220,-320},{220,220},{238,220}},
      color={255,0,255}));
  connect(byPasSet2.y, upSet.u1)
    annotation (Line(points={{202,260},{220,260},{220,228},{238,228}},
      color={0,0,127}));
  connect(oneMorSet.y, upSet.u3)
    annotation (Line(points={{122,230},{170,230},{170,212},{238,212}},
      color={0,0,127}));
  connect(uStaDow, and2.u2)
    annotation (Line(points={{-460,-390},{-410,-390},{-410,-358},{-322,-358}},
      color={255,0,255}));
  connect(uSubCha, and2.u1)
    annotation (Line(points={{-460,-280},{-420,-280},{-420,-350},{-322,-350}},
      color={255,0,255}));
  connect(and2.y, tim2.u)
    annotation (Line(points={{-298,-350},{-222,-350}}, color={255,0,255}));
  connect(con2.y, oneMorSet1.x1)
    annotation (Line(points={{-38,210},{70,210},{70,-342},{98,-342}},
      color={0,0,127}));
  connect(pro4.y, oneMorSet1.f1)
    annotation (Line(points={{-38,250},{60,250},{60,-346},{98,-346}},
      color={0,0,127}));
  connect(con3.y, oneMorSet1.x2)
    annotation (Line(points={{-38,168},{80,168},{80,-354},{98,-354}},
      color={0,0,127}));
  connect(pro1.y, oneMorSet1.f2)
    annotation (Line(points={{2,70},{90,70},{90,-358},{98,-358}},
      color={0,0,127}));
  connect(tim2.y, oneMorSet1.u)
    annotation (Line(points={{-198,-350},{98,-350}}, color={0,0,127}));
  connect(oneMorSet1.y, byPasSet4.u3)
    annotation (Line(points={{122,-350},{140,-350},{140,-308},{158,-308}},
      color={0,0,127}));
  connect(uUpsDevSta, byPasSet4.u2)
    annotation (Line(points={{-460,380},{-430,380},{-430,-300},{158,-300}},
      color={255,0,255}));
  connect(pro3.y, byPasSet4.u1)
    annotation (Line(points={{-38,330},{40,330},{40,-292},{158,-292}},
      color={0,0,127}));
  connect(uOnOff, dowSet.u2)
    annotation (Line(points={{-460,-320},{220,-320},{220,-120},{238,-120}},
      color={255,0,255}));
  connect(byPasSet4.y, dowSet.u1)
    annotation (Line(points={{182,-300},{200,-300},{200,-112},{238,-112}},
      color={0,0,127}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-460,380},{-430,380},{-430,-398},{-322,-398}},
      color={255,0,255}));
  connect(tim1.y, oneLeSet.u)
    annotation (Line(points={{-198,-390},{30,-390},{30,-140},{98,-140}},
      color={0,0,127}));
  connect(oneLeSet.y, dowSet.u3)
    annotation (Line(points={{122,-140},{180,-140},{180,-128},{238,-128}},
      color={0,0,127}));
  connect(dowSet.y, chaSet.u3)
    annotation (Line(points={{262,-120},{270,-120},{270,42},{298,42}},
      color={0,0,127}));
  connect(upSet.y, chaSet.u1)
    annotation (Line(points={{262,220},{270,220},{270,58},{298,58}},
      color={0,0,127}));
  connect(uStaUp, chaSet.u2)
    annotation (Line(points={{-460,420},{-410,420},{-410,400},{280,400},{280,50},
      {298,50}}, color={255,0,255}));
  connect(not1.y, and4.u1)
    annotation (Line(points={{322,140},{338,140}}, color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{362,140},{398,140}}, color={255,0,255}));
  connect(not2.y, and4.u2)
    annotation (Line(points={{-198,-420},{330,-420},{330,132},{338,132}},
      color={255,0,255}));
  connect(chaSet.y, byPasSet1.u3)
    annotation (Line(points={{322,50},{380,50},{380,132},{398,132}},
      color={0,0,127}));
  connect(pro3.y, byPasSet1.u1)
    annotation (Line(points={{-38,330},{380,330},{380,148},{398,148}},
      color={0,0,127}));
  connect(uStaUp, not1.u)
    annotation (Line(points={{-460,420},{-410,420},{-410,400},{280,400},
      {280,140},{298,140}}, color={255,0,255}));
  connect(multiMax1.y, oneMorSet.f1)
    annotation (Line(points={{-58,-150},{60,-150},{60,234},{98,234}},
      color={0,0,127}));
  connect(multiMax1.y, oneMorSet1.f1)
    annotation (Line(points={{-58,-150},{60,-150},{60,-346},{98,-346}},
      color={0,0,127}));
  connect(max1.y, oneMorSet.f2)
    annotation (Line(points={{2,-190},{90,-190},{90,222},{98,222}},
      color={0,0,127}));
  connect(max1.y, oneMorSet1.f2)
    annotation (Line(points={{2,-190},{90,-190},{90,-358},{98,-358}},
      color={0,0,127}));
  connect(multiMax3.y, oneLeSet.f2)
    annotation (Line(points={{2,-230},{50,-230},{50,-148},{98,-148}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet2.u1)
    annotation (Line(points={{-58,-110},{40,-110},{40,268},{178,268}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet4.u1)
    annotation (Line(points={{-58,-110},{40,-110},{40,-292},{158,-292}},
      color={0,0,127}));
  connect(multiMax6.y, byPasSet1.u1)
    annotation (Line(points={{-58,-110},{40,-110},{40,180},{380,180},{380,148},{
          398,148}}, color={0,0,127}));
  connect(multiMax1.y, oneLeSet.f1)
    annotation (Line(points={{-58,-150},{60,-150},{60,-136},{98,-136}},
      color={0,0,127}));
  connect(floRat.y, nexChiRat.u)
    annotation (Line(points={{-258,180},{-250,180},{-250,90},{-222,90}},
      color={0,0,127}));
  connect(conInt1.y, intSwi.u3) annotation (Line(points={{-338,-260},{-330,-260},
          {-330,-238},{-322,-238}}, color={255,127,0}));
  connect(and5.y, booToRea1.u)
    annotation (Line(points={{-338,-170},{-322,-170}}, color={255,0,255}));
  connect(and5.y, intSwi.u2) annotation (Line(points={{-338,-170},{-330,-170},{-330,
          -230},{-322,-230}}, color={255,0,255}));
  connect(intGreEquThr.y, and5.u1)
    annotation (Line(points={{-378,-170},{-362,-170}}, color={255,0,255}));
  connect(intLesEquThr.y, and5.u2) annotation (Line(points={{-378,-260},{-370,-260},
          {-370,-178},{-362,-178}}, color={255,0,255}));
  connect(nexEnaChi, intGreEquThr.u) annotation (Line(points={{-460,70},{-420,70},
          {-420,-170},{-402,-170}}, color={255,127,0}));
  connect(nexEnaChi, intSwi.u1) annotation (Line(points={{-460,70},{-420,70},{-420,
          -222},{-322,-222}}, color={255,127,0}));
  connect(nexEnaChi, intLesEquThr.u) annotation (Line(points={{-460,70},{-420,70},
          {-420,-260},{-402,-260}}, color={255,127,0}));
  connect(intSwi.y, nexChiMinFlo.index) annotation (Line(points={{-298,-230},{-280,
          -230},{-280,-210},{-210,-210},{-210,-202}}, color={255,127,0}));
  connect(intSwi.y, nexChiMaxFlo.index) annotation (Line(points={{-298,-230},{-280,
          -230},{-280,30},{-210,30},{-210,38}}, color={255,127,0}));
  connect(intSwi.y, nexChiRat.index) annotation (Line(points={{-298,-230},{-280,
          -230},{-280,70},{-210,70},{-210,78}}, color={255,127,0}));
  connect(booToRea1.y, reaScaRep.u)
    annotation (Line(points={{-298,-170},{-272,-170}}, color={0,0,127}));
  connect(mul3.y, max1.u2) annotation (Line(points={{-98,-180},{-80,-180},{-80,-196},
          {-22,-196}}, color={0,0,127}));
  connect(reaScaRep.y[3], mul3.u1) annotation (Line(points={{-248,-169.333},{
          -180,-169.333},{-180,-174},{-122,-174}},
                                              color={0,0,127}));
  connect(reaScaRep.y[1], mul1[1].u2) annotation (Line(points={{-248,-170.667},
          {-180,-170.667},{-180,44},{-162,44}},color={0,0,127}));
  connect(reaScaRep.y[2], mul1[2].u2) annotation (Line(points={{-248,-170},{-180,
          -170},{-180,44},{-162,44}}, color={0,0,127}));
  connect(nexChiMaxFlo.y, mul1[2].u1) annotation (Line(points={{-198,50},{-180,50},
          {-180,56},{-162,56}}, color={0,0,127}));
  connect(nexChiRat.y, mul1[1].u1) annotation (Line(points={{-198,90},{-180,90},
          {-180,56},{-162,56}}, color={0,0,127}));
  connect(mul1[1].y, max.u2) annotation (Line(points={{-138,50},{-120,50},{-120,
          84},{-82,84}}, color={0,0,127}));
  connect(mul1[2].y, add2.u2) annotation (Line(points={{-138,50},{-120,50},{-120,
          44},{-82,44}}, color={0,0,127}));
  connect(nexChiMinFlo.y, mul3.u2) annotation (Line(points={{-198,-190},{-180,-190},
          {-180,-186},{-122,-186}}, color={0,0,127}));
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
          textString="yChiWatMinFloSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-440,-440},{440,440}}), graphics={
        Rectangle(
          extent={{-398,398},{18,-58}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-398,-82},{18,-278}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-92,394},{14,378}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with parallel chillers"),
        Text(
          extent={{-80,-78},{18,-94}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with series chillers"),
        Text(
          extent={{-54,114},{18,98}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-46,102},{18,88}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-34,2},{18,-12}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller"),
        Text(
          extent={{-54,14},{18,-2}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-42,-160},{22,-174}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-30,-242},{22,-256}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller"),
        Text(
          extent={{-92,372},{10,356}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint according to"),
        Text(
          extent={{-54,360},{10,346}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="current chillers status"),
        Text(
          extent={{-88,302},{14,286}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint according to"),
        Text(
          extent={{-66,290},{14,276}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="chillers status at the moment"),
        Text(
          extent={{-62,280},{16,266}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="when  requiring stage change"),
        Text(
          extent={{-38,-96},{26,-110}},
          textColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="current chillers status")}),
  Documentation(info="<html>
<p>
Block that outputs chilled water minimum flow setpoint for primary-only
plants with a minimum flow bypass valve,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020),
section 5.2.8 Chilled water minimum flow bypass valve.
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
