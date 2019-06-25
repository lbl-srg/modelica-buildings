within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.MinimumFlowBypass.Subsequences;
block FlowSetpoint "Chilled water minimum flow setpoint"

  parameter Integer nChi = 3
    "Total number of chillers";
  parameter Boolean isParallelChiller = true
    "Flag: true means that the plant has parallel chillers";
  parameter Modelica.SIunits.Time byPasSetTim = 300
    "Time constant for resetting minimum bypass flow";
  parameter Modelica.SIunits.VolumeFlowRate minFloSet[nChi] = {0.005, 0.005, 0.005}
    "Minimum chilled water flow through each chiller";
  parameter Modelica.SIunits.VolumeFlowRate maxFloSet[nChi] = {0.025, 0.025, 0.025}
    "Maximum chilled water flow through each chiller";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Stage up logical signal"
    annotation (Placement(transformation(extent={{-400,290},{-360,330}}),
      iconTransformation(extent={{-120,80},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uUpsDevSta
    "Resetting status of upstream device (in staging up or down process) before reset minimum chilled water flow setpoint"
    annotation (Placement(transformation(extent={{-400,250},{-360,290}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller status: true=ON"
    annotation (Placement(transformation(extent={{-400,150},{-360,190}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexEnaChi
    "Index of next chiller to be enabled"
    annotation (Placement(transformation(extent={{-400,70},{-360,110}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nexDisChi
    "Index of next chiller to be disabled"
    annotation (Placement(transformation(extent={{-400,-40},{-360,0}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaNexChi
    "Indicate that it starts to enable another chiller in a staging process. This input is used when the stage change needs chiller on/off"
    annotation (Placement(transformation(extent={{-400,-180},{-360,-140}}),
      iconTransformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOnOff
    "Indicate if the stage change requires one chiller to be enabled while another is disabled"
    annotation (Placement(transformation(extent={{-400,-220},{-360,-180}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Stage down logical signal"
    annotation (Placement(transformation(extent={{-400,-300},{-360,-260}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yChiWatMinFloSet(
    quantity="VolumeFlowRate",
    final unit="m3/s",
    final min=0)
    "Chilled water minimum flow setpoint"
    annotation (Placement(transformation(extent={{360,-130},{380,-110}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Integer chiInd[nChi]={i for i in 1:nChi}
    "Chiller index, {1,2,...,n}";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con3(
    final k=byPasSetTim)
    "Duration time to change old setpoint to new setpoint"
    annotation (Placement(transformation(extent={{80,230},{100,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Line upSet
    "Minimum flow setpoint when there is stage up command"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{140,230},{160,250}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{80,300},{100,320}})));
  Buildings.Controls.OBC.CDL.Continuous.Line dowSet
    "Minimum flow setpoint when there is stage down command"
    annotation (Placement(transformation(extent={{200,-270},{220,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim1
    "Time after suppress chiller demand"
    annotation (Placement(transformation(extent={{80,-290},{100,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Choose right setpoint when there is chiller on/off during stage change"
    annotation (Placement(transformation(extent={{140,-210},{160,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{260,-170},{280,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and4 "Logical and"
    annotation (Placement(transformation(extent={{320,270},{340,290}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 "Logical not"
    annotation (Placement(transformation(extent={{-260,-330},{-240,-310}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{260,280},{280,300}})));
  Buildings.Controls.OBC.CDL.Logical.Switch byPasSet1
    "Minimum flow chilled water flow setpoint"
    annotation (Placement(transformation(extent={{320,-130},{340,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-260,300},{-240,320}})));
  Buildings.Controls.OBC.CDL.Logical.And and3 "Logical and"
    annotation (Placement(transformation(extent={{-200,-290},{-180,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{200,260},{220,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minFlo[nChi](
    final k=minFloSet)
    "Minimum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxFlo[nChi](
    final k=maxFloSet) if isParallelChiller
    "Maximum chilled water flow through each chiller"
    annotation (Placement(transformation(extent={{-300,190},{-280,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nChi](
    each final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-300,120},{-280,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Division floRat[nChi] if isParallelChiller
    "Flow rate ratio through each chiller"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] if isParallelChiller
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[nChi] if isParallelChiller
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiRat(final nin=nChi) if
       isParallelChiller
    "Flow rate ratio of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMaxFlo(final nin=nChi) if
       isParallelChiller "Maximum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max if isParallelChiller
    "Maximum flow rate ratio of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 if isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro if isParallelChiller
    "Chilled water flow setpoint for current operating chillers"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro1 if isParallelChiller
    "Chilled water flow setpoint after enabling next chiller"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt[nChi](final k=chiInd) "Chiller index vector"
    annotation (Placement(transformation(extent={{-300,10},{-280,30}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerReplicator intRep(final nout=nChi) "Replicate integer input"
    annotation (Placement(transformation(extent={{-300,-30},{-280,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu[nChi] "Check equality of two integer inputs"
    annotation (Placement(transformation(extent={{-240,10},{-220,30}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xor[nChi] "Outputs true if exactly one input is true"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[nChi] if isParallelChiller
    "Flow rate ratio of operating chiller"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi4[nChi] if isParallelChiller
    "Maximum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro2 if isParallelChiller
    "Chilled water flow setpoint after disabling next chiller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1 if not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers after one chiller being enabled"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(final nin=nChi) if
       isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(final nin=nChi) if
       isParallelChiller
    "Sum of maximum chilled water flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax(final nin=nChi) if
       isParallelChiller
    "Maximum flow rate ratio of operating chillers"
    annotation (Placement(transformation(extent={{-100,180},{-80,200}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax1(final nin=nChi) if
       not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax2(final nin=nChi) if
       isParallelChiller
    "Maximum flow rate ratio of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax multiMax3(final nin=nChi) if
       not isParallelChiller
    "Largest minimum flow rate setpoint of operating chillers after one chiller being disabled"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi5[nChi] if not isParallelChiller
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor nexChiMinFlo(final nin=nChi) if
       not isParallelChiller "Minimum flow rate of next enabling chiller"
    annotation (Placement(transformation(extent={{-140,-100},{-120,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi6[nChi] if not isParallelChiller
    "Minimum flow rate of operating chiller"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi7
    "Choose right setpoint based on if it is enabling or disabling chiller"
    annotation (Placement(transformation(extent={{80,-250},{100,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi8
    "Choose right setpoint before and after starting enabling next chiller"
    annotation (Placement(transformation(extent={{80,-170},{100,-150}})));

equation
  connect(con2.y, upSet.x1)
    annotation (Line(points={{161,240},{170,240},{170,208},{198,208}},
      color={0,0,127}));
  connect(tim.y, upSet.u)
    annotation (Line(points={{101,310},{180,310},{180,200},{198,200}},
      color={0,0,127}));
  connect(con3.y, upSet.x2)
    annotation (Line(points={{101,240},{120,240},{120,196},{198,196}},
      color={0,0,127}));
  connect(con2.y, dowSet.x1)
    annotation (Line(points={{161,240},{170,240},{170,-252},{198,-252}},
      color={0,0,127}));
  connect(con3.y, dowSet.x2)
    annotation (Line(points={{101,240},{120,240},{120,-264},{198,-264}},
      color={0,0,127}));
  connect(tim1.y, dowSet.u)
    annotation (Line(points={{101,-280},{140,-280},{140,-260},{198,-260}},
      color={0,0,127}));
  connect(upSet.y, byPasSet.u1)
    annotation (Line(points={{221,200},{234,200},{234,-152},{258,-152}},
      color={0,0,127}));
  connect(dowSet.y, byPasSet.u3)
    annotation (Line(points={{221,-260},{240,-260},{240,-168},{258,-168}},
      color={0,0,127}));
  connect(uStaDow, not2.u)
    annotation (Line(points={{-380,-280},{-320,-280},{-320,-320},{-262,-320}},
      color={255,0,255}));
  connect(uStaUp, not3.u)
    annotation (Line(points={{-380,310},{-320,310},{-320,290},{258,290}},
      color={255,0,255}));
  connect(not3.y,and4. u1)
    annotation (Line(points={{281,290},{300,290},{300,288},{318,288}},
      color={255,0,255}));
  connect(not2.y,and4. u2)
    annotation (Line(points={{-239,-320},{292,-320},{292,280},{318,280}},
      color={255,0,255}));
  connect(byPasSet1.y, yChiWatMinFloSet)
    annotation (Line(points={{341,-120},{370,-120}}, color={0,0,127}));
  connect(byPasSet.y, byPasSet1.u3)
    annotation (Line(points={{281,-160},{300,-160},{300,-128},{318,-128}},
      color={0,0,127}));
  connect(uStaUp, and1.u1)
    annotation (Line(points={{-380,310},{-262,310}}, color={255,0,255}));
  connect(and1.y, tim.u)
    annotation (Line(points={{-239,310},{78,310}}, color={255,0,255}));
  connect(uUpsDevSta, and1.u2)
    annotation (Line(points={{-380,270},{-340,270},{-340,302},{-262,302}},
      color={255,0,255}));
  connect(uUpsDevSta, and3.u2)
    annotation (Line(points={{-380,270},{-340,270},{-340,-288},{-202,-288}},
      color={255,0,255}));
  connect(uStaDow, and3.u1)
    annotation (Line(points={{-380,-280},{-202,-280}}, color={255,0,255}));
  connect(and3.y, tim1.u)
    annotation (Line(points={{-179,-280},{78,-280}}, color={255,0,255}));
  connect(uUpsDevSta, not1.u)
    annotation (Line(points={{-380,270},{198,270}},color={255,0,255}));
  connect(not1.y, and4.u3)
    annotation (Line(points={{221,270},{260,270},{260,272},{318,272}},
      color={255,0,255}));
  connect(swi.y, dowSet.f2)
    annotation (Line(points={{161,-200},{180,-200},{180,-268},{198,-268}},
      color={0,0,127}));
  connect(uStaUp, byPasSet.u2)
    annotation (Line(points={{-380,310},{-320,310},{-320,290},{240,290},{240,-160},
          {258,-160}},
                   color={255,0,255}));
  connect(and4.y, byPasSet1.u2)
    annotation (Line(points={{341,280},{350,280},{350,150},{300,150},{300,-120},
          {318,-120}},
                   color={255,0,255}));
  connect(minFlo.y, floRat.u1)
    annotation (Line(points={{-279,240},{-260,240},{-260,226},{-242,226}},
      color={0,0,127}));
  connect(maxFlo.y, floRat.u2)
    annotation (Line(points={{-279,200},{-256,200},{-256,214},{-242,214}},
      color={0,0,127}));
  connect(uChi, swi1.u2)
    annotation (Line(points={{-380,170},{-210,170},{-210,190},{-142,190}},
      color={255,0,255}));
  connect(floRat.y, swi1.u1)
    annotation (Line(points={{-219,220},{-154,220},{-154,198},{-142,198}},
      color={0,0,127}));
  connect(zer.y, swi1.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,182},{-142,182}},
      color={0,0,127}));
  connect(uChi, swi2.u2)
    annotation (Line(points={{-380,170},{-210,170},{-210,150},{-142,150}},
      color={255,0,255}));
  connect(zer.y, swi2.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,142},{-142,142}},
      color={0,0,127}));
  connect(nexEnaChi, nexChiRat.index)
    annotation (Line(points={{-380,90},{-130,90},{-130,98}},
      color={255,127,0}));
  connect(floRat.y, nexChiRat.u)
    annotation (Line(points={{-219,220},{-154,220},{-154,110},{-142,110}},
      color={0,0,127}));
  connect(nexEnaChi,nexChiMaxFlo. index)
    annotation (Line(points={{-380,90},{-316,90},{-316,50},{-130,50},{-130,58}},
      color={255,127,0}));
  connect(nexChiRat.y, max.u2)
    annotation (Line(points={{-119,110},{-60,110},{-60,104},{-42,104}},
      color={0,0,127}));
  connect(multiMax.y, max.u1)
    annotation (Line(points={{-79,190},{-60,190},{-60,116},{-42,116}},
      color={0,0,127}));
  connect(nexChiMaxFlo.y, add2.u2)
    annotation (Line(points={{-119,70},{-64,70},{-64,64},{-42,64}},
      color={0,0,127}));
  connect(mulSum.y, add2.u1)
    annotation (Line(points={{-79,150},{-64,150},{-64,76},{-42,76}},
      color={0,0,127}));
  connect(multiMax.y, pro.u1)
    annotation (Line(points={{-79,190},{-60,190},{-60,176},{-2,176}},
      color={0,0,127}));
  connect(mulSum.y, pro.u2)
    annotation (Line(points={{-79,150},{-64,150},{-64,164},{-2,164}},
      color={0,0,127}));
  connect(max.y, pro1.u1)
    annotation (Line(points={{-19,110},{-10,110},{-10,96},{-2,96}},
      color={0,0,127}));
  connect(add2.y, pro1.u2)
    annotation (Line(points={{-19,70},{-10,70},{-10,84},{-2,84}},
      color={0,0,127}));
  connect(nexDisChi, intRep.u)
    annotation (Line(points={{-380,-20},{-302,-20}}, color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-279,20},{-242,20}},   color={255,127,0}));
  connect(intRep.y, intEqu.u2)
    annotation (Line(points={{-279,-20},{-264,-20},{-264,12},{-242,12}},
      color={255,127,0}));
  connect(uChi, xor.u2)
    annotation (Line(points={{-380,170},{-210,170},{-210,12},{-202,12}},
      color={255,0,255}));
  connect(intEqu.y, xor.u1)
    annotation (Line(points={{-219,20},{-202,20}},   color={255,0,255}));
  connect(xor.y, swi3.u2)
    annotation (Line(points={{-179,20},{-142,20}},  color={255,0,255}));
  connect(xor.y, swi4.u2)
    annotation (Line(points={{-179,20},{-166,20},{-166,-20},{-142,-20}},
      color={255,0,255}));
  connect(floRat.y, swi3.u1)
    annotation (Line(points={{-219,220},{-154,220},{-154,28},{-142,28}},
      color={0,0,127}));
  connect(zer.y, swi3.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,12},{-142,12}},
      color={0,0,127}));
  connect(zer.y, swi4.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,-28},{-142,-28}},
      color={0,0,127}));
  connect(multiMax2.y, pro2.u1)
    annotation (Line(points={{-79,20},{-60,20},{-60,6},{-2,6}},
      color={0,0,127}));
  connect(mulSum1.y, pro2.u2)
    annotation (Line(points={{-79,-20},{-60,-20},{-60,-6},{-2,-6}},
      color={0,0,127}));
  connect(uOnOff, swi.u2)
    annotation (Line(points={{-380,-200},{138,-200}},color={255,0,255}));
  connect(swi1.y, multiMax.u)
    annotation (Line(points={{-119,190},{-102,190}}, color={0,0,127}));
  connect(swi2.y, mulSum.u)
    annotation (Line(points={{-119,150},{-102,150}}, color={0,0,127}));
  connect(swi3.y, multiMax2.u)
    annotation (Line(points={{-119,20},{-102,20}},   color={0,0,127}));
  connect(swi4.y, mulSum1.u)
    annotation (Line(points={{-119,-20},{-102,-20}}, color={0,0,127}));
  connect(swi5.y, multiMax1.u)
    annotation (Line(points={{-119,-60},{-102,-60}},   color={0,0,127}));
  connect(swi6.y, multiMax3.u)
    annotation (Line(points={{-119,-130},{-42,-130}},  color={0,0,127}));
  connect(maxFlo.y, swi2.u1)
    annotation (Line(points={{-279,200},{-256,200},{-256,158},{-142,158}},
      color={0,0,127}));
  connect(maxFlo.y, nexChiMaxFlo.u)
    annotation (Line(points={{-279,200},{-256,200},{-256,70},{-142,70}},
      color={0,0,127}));
  connect(maxFlo.y, swi4.u1)
    annotation (Line(points={{-279,200},{-256,200},{-256,-12},{-142,-12}},
      color={0,0,127}));
  connect(uChi, swi5.u2)
    annotation (Line(points={{-380,170},{-210,170},{-210,-60},{-142,-60}},
      color={255,0,255}));
  connect(minFlo.y, swi5.u1)
    annotation (Line(points={{-279,240},{-260,240},{-260,-52},{-142,-52}},
      color={0,0,127}));
  connect(zer.y, swi5.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,-68},{-142,-68}},
      color={0,0,127}));
  connect(minFlo.y, nexChiMinFlo.u)
    annotation (Line(points={{-279,240},{-260,240},{-260,-90},{-142,-90}},
      color={0,0,127}));
  connect(nexEnaChi, nexChiMinFlo.index)
    annotation (Line(points={{-380,90},{-316,90},{-316,-110},{-130,-110},{-130,-102}},
      color={255,127,0}));
  connect(multiMax1.y, max1.u1)
    annotation (Line(points={{-79,-60},{-60,-60},{-60,-84},{-42,-84}},
      color={0,0,127}));
  connect(nexChiMinFlo.y, max1.u2)
    annotation (Line(points={{-119,-90},{-80,-90},{-80,-96},{-42,-96}},
      color={0,0,127}));
  connect(xor.y, swi6.u2)
    annotation (Line(points={{-179,20},{-166,20},{-166,-130},{-142,-130}},
      color={255,0,255}));
  connect(zer.y, swi6.u3)
    annotation (Line(points={{-279,130},{-160,130},{-160,-138},{-142,-138}},
      color={0,0,127}));
  connect(minFlo.y, swi6.u1)
    annotation (Line(points={{-279,240},{-260,240},{-260,-122},{-142,-122}},
      color={0,0,127}));
  connect(uStaUp, swi7.u2)
    annotation (Line(points={{-380,310},{-320,310},{-320,-240},{78,-240}},
      color={255,0,255}));
  connect(pro1.y, swi7.u1)
    annotation (Line(points={{21,90},{40,90},{40,-232},{78,-232}},
      color={0,0,127}));
  connect(pro2.y, swi7.u3)
    annotation (Line(points={{21,0},{36,0},{36,-248},{78,-248}},
      color={0,0,127}));
  connect(swi7.y, swi.u3)
    annotation (Line(points={{101,-240},{110,-240},{110,-208},{138,-208}},
      color={0,0,127}));
  connect(uEnaNexChi, swi8.u2)
    annotation (Line(points={{-380,-160},{78,-160}}, color={255,0,255}));
  connect(pro1.y, swi8.u3)
    annotation (Line(points={{21,90},{40,90},{40,-168},{78,-168}},
      color={0,0,127}));
  connect(pro.y, swi8.u1)
    annotation (Line(points={{21,170},{32,170},{32,-152},{78,-152}},
      color={0,0,127}));
  connect(swi8.y, swi.u1)
    annotation (Line(points={{101,-160},{110,-160},{110,-192},{138,-192}},
      color={0,0,127}));
  connect(pro.y, dowSet.f1)
    annotation (Line(points={{21,170},{32,170},{32,-256},{198,-256}},
      color={0,0,127}));
  connect(pro.y, upSet.f1)
    annotation (Line(points={{21,170},{32,170},{32,204},{198,204}},
      color={0,0,127}));
  connect(multiMax1.y, upSet.f1)
    annotation (Line(points={{-79,-60},{52,-60},{52,204},{198,204}},
      color={0,0,127}));
  connect(multiMax1.y, dowSet.f1)
    annotation (Line(points={{-79,-60},{52,-60},{52,-256},{198,-256}},
      color={0,0,127}));
  connect(multiMax1.y, swi8.u1)
    annotation (Line(points={{-79,-60},{52,-60},{52,-152},{78,-152}},
      color={0,0,127}));
  connect(max1.y, swi8.u3)
    annotation (Line(points={{-19,-90},{56,-90},{56,-168},{78,-168}},
      color={0,0,127}));
  connect(max1.y, swi7.u1)
    annotation (Line(points={{-19,-90},{56,-90},{56,-232},{78,-232}},
      color={0,0,127}));
  connect(multiMax3.y, swi7.u3)
    annotation (Line(points={{-19,-130},{60,-130},{60,-248},{78,-248}},
      color={0,0,127}));
  connect(multiMax1.y, byPasSet1.u1)
    annotation (Line(points={{-79,-60},{52,-60},{52,-112},{318,-112}},
      color={0,0,127}));
  connect(pro.y, byPasSet1.u1)
    annotation (Line(points={{21,170},{32,170},{32,-112},{318,-112}},
      color={0,0,127}));
  connect(swi.y, upSet.f2)
    annotation (Line(points={{161,-200},{180,-200},{180,192},{198,192}},
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
          extent={{-360,-340},{360,340}}), graphics={
        Rectangle(
          extent={{-358,258},{18,-38}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-358,-42},{18,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-90,258},{16,242}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with parallel chillers"),
        Text(
          extent={{-82,-38},{16,-54}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Plant with series chillers"),
        Text(
          extent={{-58,210},{14,194}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-50,198},{14,184}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="there is no stage change"),
        Text(
          extent={{-58,150},{14,134}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-50,138},{14,124}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-36,30},{16,16}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller"),
        Text(
          extent={{-56,42},{16,26}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Minimum flow setpoint when"),
        Text(
          extent={{-50,-64},{14,-78}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="enabling additional chiller"),
        Text(
          extent={{-38,-102},{14,-116}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="disabling one chiller")}),
  Documentation(info="<html>
<p>
Block that outputs chilled water minimum flow setpoint for primary-only
plants with a minimum flow bypass valve,
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on March 26, 2019),
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
