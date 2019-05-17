within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences;
block FlowSetpoint "Chilled water minimum flow setpoint"

  parameter Integer nChi = 3
    "Total number of chillers";
  parameter Boolean isParallelChiller = true
    "Flag: true means that the plant has parallel chillers";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time to reset minimum by-pass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi] = {0.005, 0.005, 0.005}
    "Minimum chilled water flow through each chiller";
  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi] = {0.025, 0.025, 0.025}
    "Maximum chilled water flow through each chiller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up logical signal"
    annotation (Placement(transformation(extent={{-380,270},{-340,310}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Resetting status of upstream device (in staging up or down process) before reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-380,230},{-340,270}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-380,130},{-340,170}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next enabling chiller"
    annotation (Placement(transformation(extent={{-380,30},{-340,70}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next disabling chiller"
    annotation (Placement(transformation(extent={{-380,-80},{-340,-40}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-382,-210},{-342,-170}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down logical signal"
    annotation (Placement(transformation(extent={{-380,-270},{-340,-230}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0)
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{340,-140},{360,-120}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{40,200},{60,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Line upSet
    "Minimum flow setpoint when there is stage up command"
    annotation (Placement(transformation(extent={{160,170},{180,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{40,280},{60,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dowSet
    "Minimum flow setpoint when there is stage down command"
    annotation (Placement(transformation(extent={{160,-240},{180,-220}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{40,-260},{60,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{220,-160},{240,-140}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and4 "Logical and"
    annotation (Placement(transformation(extent={{280,248},{300,268}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-260,-300},{-240,-280}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{220,260},{240,280}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet1
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{280,-140},{300,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-260,280},{-240,300}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-200,-260},{-180,-240}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{160,240},{180,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nChi](
    final k=minFloSet)
    "Minimum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-300,200},{-280,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxFlo[nChi](
    final k=maxFloSet) if isParallelChiller
    "Maximum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-300,160},{-280,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChi](
    each final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-300,80},{-280,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Division floRat[nChi] if isParallelChiller
    "Flow rate ratio through each chiller"
    annotation (Placement(transformation(extent={{-240,180},{-220,200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] if isParallelChiller
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nChi] if isParallelChiller
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiRat(final nin=nChi) if
       isParallelChiller
    "Flow rate ratio of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMaxFlo(final nin=nChi) if
       isParallelChiller "Maximum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max if isParallelChiller
    "Maximum flow rate ratio of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 if isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro if isParallelChiller
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1 if isParallelChiller
    "Chilled water flow setpoint after enabling next chiller"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](final k=chiInd) "Chiller index vector"
    annotation (Placement(transformation(extent={{-300,-30},{-280,-10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi) "Replicate integer input"
    annotation (Placement(transformation(extent={{-300,-70},{-280,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi] "Check equality of two integer inputs"
    annotation (Placement(transformation(extent={{-240,-30},{-220,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nChi] "Outputs true if exactly one input is true"
    annotation (Placement(transformation(extent={{-200,-30},{-180,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[nChi] if isParallelChiller
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nChi] if isParallelChiller
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro2 if isParallelChiller
    "Chilled water flow setpoint after disabling next chiller"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi) if
       isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(final nin=nChi) if
       isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(final nin=nChi) if
       isParallelChiller
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(final nin=nChi) if
       not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax2(final nin=nChi) if
       isParallelChiller
    "Maximum flow rate ratio of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax3(final nin=nChi) if
       not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-40,-180},{-20,-160}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5[nChi] if not isParallelChiller
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMinFlo(final nin=nChi) if
       not isParallelChiller "Minimum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6[nChi] if not isParallelChiller
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-180},{-120,-160}})));

equation
  connect(con2.y, upSet.x1)
    annotation (Line(points={{121,210},{130,210},{130,188},{158,188}},
      color={0,0,127}));
  connect(tim.y, upSet.u)
    annotation (Line(points={{61,290},{140,290},{140,180},{158,180}},
      color={0,0,127}));
  connect(con3.y, upSet.x2)
    annotation (Line(points={{61,210},{80,210},{80,176},{158,176}},
      color={0,0,127}));
  connect(con2.y, dowSet.x1)
    annotation (Line(points={{121,210},{130,210},{130,-222},{158,-222}},
      color={0,0,127}));
  connect(con3.y, dowSet.x2)
    annotation (Line(points={{61,210},{80,210},{80,-234},{158,-234}},
      color={0,0,127}));
  connect(tim1.y, dowSet.u)
    annotation (Line(points={{61,-250},{100,-250},{100,-230},{158,-230}},
      color={0,0,127}));
  connect(upSet.y, byPasSet.u1)
    annotation (Line(points={{181,180},{194,180},{194,-142},{218,-142}},
      color={0,0,127}));
  connect(dowSet.y, byPasSet.u3)
    annotation (Line(points={{181,-230},{200,-230},{200,-158},{218,-158}},
      color={0,0,127}));
  connect(uStaDow, not2.u)
    annotation (Line(points={{-360,-250},{-300,-250},{-300,-290},{-262,-290}},
      color={255,0,255}));
  connect(uStaUp, not3.u)
    annotation (Line(points={{-360,290},{-300,290},{-300,270},{218,270}},
      color={255,0,255}));
  connect(not3.y,and4. u1)
    annotation (Line(points={{241,270},{254,270},{254,266},{278,266}},
      color={255,0,255}));
  connect(not2.y,and4. u2)
    annotation (Line(points={{-239,-290},{254,-290},{254,258},{278,258}},
      color={255,0,255}));
  connect(byPasSet1.y, yChiWatMinFloSet)
    annotation (Line(points={{301,-130},{350,-130}}, color={0,0,127}));
  connect(byPasSet.y, byPasSet1.u3)
    annotation (Line(points={{241,-150},{260,-150},{260,-138},{278,-138}},
      color={0,0,127}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-360,290},{-262,290}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-239,290},{38,290}}, color={255,0,255}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-360,250},{-320,250},{-320,282},{-262,282}},
      color={255,0,255}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-360,250},{-320,250},{-320,-258},{-202,-258}},
      color={255,0,255}));
  connect(uStaDow, and3.u1)
    annotation (Line(points={{-360,-250},{-202,-250}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{-179,-250},{38,-250}}, color={255,0,255}));
  connect(uUpsDevSta, not1.u)
    annotation (Line(points={{-360,250},{158,250}},color={255,0,255}));
  connect(not1.y, and4.u3)
    annotation (Line(points={{181,250},{278,250}},
      color={255,0,255}));
  connect(swi.y, dowSet.f2)
    annotation (Line(points={{121,-190},{140,-190},{140,-238},{158,-238}},
      color={0,0,127}));
  connect(uStaUp, byPasSet.u2)
    annotation (Line(points={{-360,290},{-300,290},{-300,270},{200,270},{200,-150},
      {218,-150}}, color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{301,258},{320,258},{320,130},{260,130},{260,-130},
      {278,-130}}, color={255,0,255}));
  connect(minFlo.y, floRat.u1)
    annotation (Line(points={{-279,210},{-260,210},{-260,196},{-242,196}},
      color={0,0,127}));
  connect(maxFlo.y, floRat.u2)
    annotation (Line(points={{-279,170},{-256,170},{-256,184},{-242,184}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-360,150},{-142,150}}, color={255,0,255}));
  connect(floRat.y, swi1.u1)
    annotation (Line(points={{-219,190},{-154,190},{-154,158},{-142,158}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,142},{-142,142}},
      color={0,0,127}));
  connect(uChi, swi2.u2)
    annotation (Line(points={{-360,150},{-210,150},{-210,110},{-142,110}},
      color={255,0,255}));
  connect(zer.y, swi2.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,102},{-142,102}},
      color={0,0,127}));
  connect(nexEnaChi, nexChiRat.index)
    annotation (Line(points={{-360,50},{-130,50},{-130,58}},
      color={255,127,0}));
  connect(floRat.y, nexChiRat.u)
    annotation (Line(points={{-219,190},{-154,190},{-154,70},{-142,70}},
      color={0,0,127}));
  connect(nexEnaChi,nexChiMaxFlo. index)
    annotation (Line(points={{-360,50},{-316,50},{-316,10},{-130,10},{-130,18}},
      color={255,127,0}));
  connect(nexChiRat.y, max.u2)
    annotation (Line(points={{-119,70},{-60,70},{-60,64},{-42,64}},
      color={0,0,127}));
  connect(multiMax.y, max.u1)
    annotation (Line(points={{-79,150},{-60,150},{-60,76},{-42,76}},
      color={0,0,127}));
  connect(nexChiMaxFlo.y, add2.u2)
    annotation (Line(points={{-119,30},{-64,30},{-64,24},{-42,24}},
      color={0,0,127}));
  connect(mulSum.y, add2.u1)
    annotation (Line(points={{-79,110},{-64,110},{-64,36},{-42,36}},
      color={0,0,127}));
  connect(multiMax.y, pro.u1)
    annotation (Line(points={{-79,150},{-60,150},{-60,136},{-2,136}},
      color={0,0,127}));
  connect(mulSum.y, pro.u2)
    annotation (Line(points={{-79,110},{-64,110},{-64,124},{-2,124}},
      color={0,0,127}));
  connect(max.y, pro1.u1)
    annotation (Line(points={{-19,70},{-10,70},{-10,56},{-2,56}},
      color={0,0,127}));
  connect(add2.y, pro1.u2)
    annotation (Line(points={{-19,30},{-10,30},{-10,44},{-2,44}},
      color={0,0,127}));
  connect(nexDisChi, intRep.u)
    annotation (Line(points={{-360,-60},{-302,-60}}, color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-279,-20},{-242,-20}}, color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{-279,-60},{-264,-60},{-264,-28},{-242,-28}},
      color={255,127,0}));
  connect(uChi, xor.u2)
    annotation (Line(points={{-360,150},{-210,150},{-210,-28},{-202,-28}},
      color={255,0,255}));
  connect(intEqu.y, xor.u1)
    annotation (Line(points={{-219,-20},{-202,-20}}, color={255,0,255}));
  connect(xor.y, swi3.u2)
    annotation (Line(points={{-179,-20},{-142,-20}},color={255,0,255}));
  connect(xor.y, swi4.u2)
    annotation (Line(points={{-179,-20},{-166,-20},{-166,-60},{-142,-60}},
      color={255,0,255}));
  connect(floRat.y, swi3.u1)
    annotation (Line(points={{-219,190},{-154,190},{-154,-12},{-142,-12}},
      color={0,0,127}));
  connect(zer.y, swi3.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,-28},{-142,-28}},
      color={0,0,127}));
  connect(zer.y, swi4.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,-68},{-142,-68}},
      color={0,0,127}));
  connect(multiMax2.y, pro2.u1)
    annotation (Line(points={{-79,-20},{-60,-20},{-60,-34},{-2,-34}},
      color={0,0,127}));
  connect(mulSum1.y, pro2.u2)
    annotation (Line(points={{-79,-60},{-60,-60},{-60,-46},{-2,-46}},
      color={0,0,127}));
  connect(uOnOff, swi.u2)
    annotation (Line(points={{-362,-190},{98,-190}}, color={255,0,255}));
  connect(pro1.y, swi.u1)
    annotation (Line(points={{21,50},{46,50},{46,-182},{98,-182}},
      color={0,0,127}));
  connect(pro.y, upSet.f1)
    annotation (Line(points={{21,130},{40,130},{40,184},{158,184}},
      color={0,0,127}));
  connect(pro1.y, upSet.f2)
    annotation (Line(points={{21,50},{46,50},{46,172},{158,172}},
      color={0,0,127}));
  connect(pro.y, dowSet.f1)
    annotation (Line(points={{21,130},{40,130},{40,-226},{158,-226}},
      color={0,0,127}));
  connect(pro2.y, swi.u3)
    annotation (Line(points={{21,-40},{34,-40},{34,-198},{98,-198}},
      color={0,0,127}));
  connect(multiMax1.y, upSet.f1)
    annotation (Line(points={{-79,-100},{54,-100},{54,184},{158,184}},
      color={0,0,127}));
  connect(multiMax1.y, dowSet.f1)
    annotation (Line(points={{-79,-100},{54,-100},{54,-226},{158,-226}},
      color={0,0,127}));
  connect(max1.y, upSet.f2)
    annotation (Line(points={{-19,-130},{60,-130},{60,172},{158,172}},
      color={0,0,127}));
  connect(max1.y, swi.u1)
    annotation (Line(points={{-19,-130},{60,-130},{60,-182},{98,-182}},
      color={0,0,127}));
  connect(multiMax3.y, swi.u3)
    annotation (Line(points={{-19,-170},{66,-170},{66,-198},{98,-198}},
      color={0,0,127}));
  connect(pro.y, byPasSet1.u1)
    annotation (Line(points={{21,130},{40,130},{40,-122},{278,-122}},
      color={0,0,127}));
  connect(multiMax1.y, byPasSet1.u1)
    annotation (Line(points={{-79,-100},{54,-100},{54,-122},{278,-122}},
      color={0,0,127}));
  connect(swi1.y, multiMax.u)
    annotation (Line(points={{-119,150},{-102,150}}, color={0,0,127}));
  connect(swi2.y, mulSum.u)
    annotation (Line(points={{-119,110},{-102,110}}, color={0,0,127}));
  connect(swi3.y, multiMax2.u)
    annotation (Line(points={{-119,-20},{-102,-20}}, color={0,0,127}));
  connect(swi4.y, mulSum1.u)
    annotation (Line(points={{-119,-60},{-102,-60}}, color={0,0,127}));
  connect(swi5.y, multiMax1.u)
    annotation (Line(points={{-119,-100},{-102,-100}}, color={0,0,127}));
  connect(swi6.y, multiMax3.u)
    annotation (Line(points={{-119,-170},{-42,-170}},  color={0,0,127}));
  connect(maxFlo.y, swi2.u1)
    annotation (Line(points={{-279,170},{-256,170},{-256,118},{-142,118}},
      color={0,0,127}));
  connect(maxFlo.y, nexChiMaxFlo.u)
    annotation (Line(points={{-279,170},{-256,170},{-256,30},{-142,30}},
      color={0,0,127}));
  connect(maxFlo.y, swi4.u1)
    annotation (Line(points={{-279,170},{-256,170},{-256,-52},{-142,-52}},
      color={0,0,127}));
  connect(uChi, swi5.u2)
    annotation (Line(points={{-360,150},{-210,150},{-210,-100},{-142,-100}},
      color={255,0,255}));
  connect(minFlo.y, swi5.u1)
    annotation (Line(points={{-279,210},{-260,210},{-260,-92},{-142,-92}},
      color={0,0,127}));
  connect(zer.y, swi5.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,-108},{-142,-108}},
      color={0,0,127}));
  connect(minFlo.y, nexChiMinFlo.u)
    annotation (Line(points={{-279,210},{-260,210},{-260,-130},{-142,-130}},
      color={0,0,127}));
  connect(nexEnaChi, nexChiMinFlo.index)
    annotation (Line(points={{-360,50},{-316,50},{-316,-150},{-130,-150},{-130,-142}},
      color={255,127,0}));
  connect(multiMax1.y, max1.u1)
    annotation (Line(points={{-79,-100},{-60,-100},{-60,-124},{-42,-124}},
      color={0,0,127}));
  connect(nexChiMinFlo.y, max1.u2)
    annotation (Line(points={{-119,-130},{-60,-130},{-60,-136},{-42,-136}},
      color={0,0,127}));
  connect(xor.y, swi6.u2)
    annotation (Line(points={{-179,-20},{-166,-20},{-166,-170},{-142,-170}},
      color={255,0,255}));
  connect(zer.y, swi6.u3)
    annotation (Line(points={{-279,90},{-160,90},{-160,-178},{-142,-178}},
      color={0,0,127}));
  connect(minFlo.y, swi6.u1)
    annotation (Line(points={{-279,210},{-260,210},{-260,-162},{-142,-162}},
      color={0,0,127}));

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
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(extent={{-36,42},{0,28}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,28},{0,14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,14},{0,0}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,0},{0,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{-36,-14},{0,-28}}, lineColor={28,108,200}),
        Text(
          extent={{-32,38},{-12,32}},
          lineColor={28,108,200},
          textString="Stage #"),
        Text(
          extent={{-30,24},{-10,18}},
          lineColor={28,108,200},
          textString="0"),
        Text(
          extent={{-30,10},{-10,4}},
          lineColor={28,108,200},
          textString="1"),
        Text(
          extent={{-30,-4},{-10,-10}},
          lineColor={28,108,200},
          textString="2"),
        Rectangle(extent={{-36,-28},{0,-42}}, lineColor={28,108,200}),
        Text(
          extent={{-30,-18},{-10,-24}},
          lineColor={28,108,200},
          textString="..."),
        Text(
          extent={{-30,-32},{-10,-38}},
          lineColor={28,108,200},
          textString="n"),
        Rectangle(extent={{2,42},{38,28}}, lineColor={28,108,200}),
        Rectangle(extent={{2,28},{38,14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,14},{38,0}}, lineColor={28,108,200}),
        Rectangle(extent={{2,0},{38,-14}}, lineColor={28,108,200}),
        Rectangle(extent={{2,-14},{38,-28}}, lineColor={28,108,200}),
        Text(
          extent={{8,38},{34,32}},
          lineColor={28,108,200},
          textString="Min flow"),
        Text(
          extent={{6,24},{34,18}},
          lineColor={28,108,200},
          textString="minFloSet[1]"),
        Rectangle(extent={{2,-28},{38,-42}}, lineColor={28,108,200}),
        Text(
          extent={{8,-18},{28,-24}},
          lineColor={28,108,200},
          textString="..."),
        Text(
          extent={{6,10},{34,4}},
          lineColor={28,108,200},
          textString="minFloSet[2]"),
        Text(
          extent={{6,-32},{34,-38}},
          lineColor={28,108,200},
          textString="minFloSet[n]"),
        Text(
          extent={{6,-4},{34,-10}},
          lineColor={28,108,200},
          textString="minFloSet[3]")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-340,-320},{340,320}})),
  Documentation(info="<html>
<p>
Block that output chilled water minimum flow setpoint for primary-only
plants with a minimum flow bypass valve, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.8 Chilled water minimum flow bypass valve.
</p>
<ul>
<li>
The chilled water minimum flow setpoint <code>yChiWatMinFloSet</code> equals to the 
sum of the minimum chilled water flowrates of the chillers
commanded to run in each stage.
</li>
</ul>

<table summary=\"summary\" border=\"1\">
<tr>
<th> Chiller stage </th> 
<th> Minimum flow </th>  
</tr>
<tr>
<td align=\"center\">0</td>
<td align=\"center\">0</td>
</tr>
<tr>
<td align=\"center\">1</td>
<td align=\"center\"><code>minFloSet</code>[1]</td>
</tr>
<tr>
<td align=\"center\">2</td>
<td align=\"center\"><code>minFloSet</code>[2]</td>
</tr>
<tr>
<td align=\"center\">...</td>
<td align=\"center\">...</td>
</tr>
</table>
<br/>

<ul>
<li>
If there is any stage change requiring a chiller on and another chiller off,
the minimum flow setpoint shall temporarily change to include the minimum 
chilled water flowrate of both enabling chiller and disabled chiller prior
to starting the newly enabled chiller.
</li>
</ul>
<p>
Note that when there is stage change thus requires changes of 
minimum bypass flow setpoint, the change should be slowly.
For example, this could be accomplished by resetting the setpoint X GPM/second, 
where X = (NewSetpoint - OldSetpoint) / <code>byPasSetTim</code>.
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
