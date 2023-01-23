within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPumpDetailed "Pump staging"

  parameter Integer nPum(
    final min=1,
    start=1)
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Integer nChi(
    final min=1,
    start=1)
    "Number of chillers served by the pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Loop design mass flow rate (all pumps)"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean have_switchover=false
    "Set to true in case of switchover valve in series with isolation valve"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final unit="kg/s")
    "Mass flow rate as measured by the loop flow meter"
    annotation (Placement(
        transformation(extent={{-240,60},{-200,100}}),iconTransformation(extent
          ={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    "Commanded speed"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal[nChi](each final unit="1")
    "Chiller isolation valve commanded position"
    annotation (Placement(
        transformation(extent={{-240,-140},{-200,-100}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValSwi[nChi](each final unit="1")
    if have_switchover
    "Chiller switchover valve commanded position"
    annotation (Placement(
        transformation(extent={{-240,-180},{-200,-140}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmp(t=0.99)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratFlo(
    final k=1/m_flow_nominal)
    "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cmp2 "Compare"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1_actual[nPum]
    "Pump status"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvt[nPum]
    "Convert to real"
    annotation (Placement(transformation(extent={{-160,150},{-140,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum numOpe(nin=nPum)
    "Number of operating pumps"
    annotation (Placement(transformation(extent={{-130,150},{-110,170}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOff(p=-0.03)
    "Add offset"
    annotation (Placement(transformation(extent={{-50,150},{-30,170}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,90},{-52,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or up
    "Check if flow or speed criterion passed for staging up"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe[nChi](each t=0.1, each h=
        5E-2)
    "Check if valve open"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Less    cmp3 "Compare"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,50},{-52,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold  cmp4(t=0.3)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe1(t=5*60) "True delay"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 dow
    "Check if flow or speed criterion passed for staging down"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratOpeDsg(
    final k=1/nPum)
    "Ratio of number of operating pumps to number of operating pumps at design conditions"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger minOneIfTru(
    final integerTrue=-1) "Return -1 if staging down"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger oneIfTrue(
    final integerTrue=1) "Return +1 if staging up"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum add1(nin=3)
    "Compute updated number of operating pumps"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cvtBoo[nPum](
    final t={i for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger cvtInt "Convert"
    annotation (Placement(transformation(extent={{26,130},{46,150}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nPum) "Replicate"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler numOpeSam
    "Number of operating pumps, sampled"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
  Buildings.Controls.OBC.CDL.Logical.Or upOrDown
    "Check if flow or speed criterion passed for staging up or down"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,80})));
  Modelica.Blocks.Continuous.FirstOrder filFlo(
    T=60,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter input to avoid algebraic loop"
    annotation (Placement(transformation(extent={{-170,70},{-150,90}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cmpNumPum(t=nPum)
    "Compare sampled number of pumps to maximum number"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And updUp
    "Update number of pumps only if another pump available"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmpOnePum(t=1)
    "Compare sampled number of pumps to one"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And updDow
    "Update number of pumps only if more than one pump operating"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi
    "When transition fires switch to sampled number and update, otherwise feed current number"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={80,80})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger numOpeInt
    "Number of operating pumps"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Controls.OBC.CDL.Logical.Not leaDis
    "Return true if lead pump disabled"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr isAnyOpe(nin=nChi)
                                                      "Check if ANY valve open"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay
                                           delRis(delayTime=60)
    "Delay allowing for valve rise time"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold isOpe1[nChi](each t=0.1, each h=
        5E-2)
    if have_switchover
    "Check if valve open"
    annotation (Placement(transformation(extent={{-180,-170},{-160,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And isoAndSwiOpe[nChi]
    "Check if isolation valve AND switchover valve open"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nChi](
    each final k=true) if not have_switchover
    "Constant"
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
equation
  connect(y, cmp.u)
    annotation (Line(points={{-220,0},{-102,0}},     color={0,0,127}));
  connect(cmp.y, timSpe.u)
    annotation (Line(points={{-78,0},{-72,0}},       color={255,0,255}));
  connect(ratFlo.y, cmp2.u1)
    annotation (Line(points={{-118,80},{-116,80},{-116,100},{-102,100}},
                                                 color={0,0,127}));
  connect(addOff.y, cmp2.u2) annotation (Line(points={{-28,160},{-20,160},{-20,80},
          {-110,80},{-110,92},{-102,92}}, color={0,0,127}));
  connect(timFlo.passed, up.u1) annotation (Line(points={{-50,92},{-36,92},{-36,
          20},{-32,20}},   color={255,0,255}));
  connect(ratFlo.y, cmp3.u1) annotation (Line(points={{-118,80},{-116,80},{-116,
          60},{-102,60}}, color={0,0,127}));
  connect(addOff.y, cmp3.u2) annotation (Line(points={{-28,160},{-20,160},{-20,80},
          {-110,80},{-110,52},{-102,52}},     color={0,0,127}));
  connect(y, cmp4.u) annotation (Line(points={{-220,0},{-160,0},{-160,-40},{-102,
          -40}},       color={0,0,127}));
  connect(cmp4.y, timSpe1.u)
    annotation (Line(points={{-78,-40},{-72,-40}},   color={255,0,255}));
  connect(timFlo1.passed,dow. u1) annotation (Line(points={{-50,52},{-40,52},{-40,
          -32},{-32,-32}},                       color={255,0,255}));
  connect(numOpe.y, ratOpeDsg.u)
    annotation (Line(points={{-108,160},{-92,160}}, color={0,0,127}));
  connect(addOff.u, ratOpeDsg.y)
    annotation (Line(points={{-52,160},{-68,160}}, color={0,0,127}));
  connect(add1.y, rep.u)
    annotation (Line(points={{112,0},{118,0}},
                                             color={255,127,0}));
  connect(rep.y, cvtBoo.u)
    annotation (Line(points={{142,0},{148,0}}, color={255,127,0}));
  connect(cvtBoo[2:nPum].y, y1[2:nPum])
    annotation (Line(points={{172,0},{220,0}}, color={255,0,255}));
  connect(cvt.y, numOpe.u)
    annotation (Line(points={{-138,160},{-132,160}}, color={0,0,127}));
  connect(y1_actual, cvt.u)
    annotation (Line(points={{-220,160},{-162,160}}, color={255,0,255}));
  connect(cmp2.y, timFlo.u)
    annotation (Line(points={{-78,100},{-74,100}},
                                                 color={255,0,255}));
  connect(cmp3.y, timFlo1.u)
    annotation (Line(points={{-78,60},{-74,60}}, color={255,0,255}));
  connect(timSpe.passed, up.u2) annotation (Line(points={{-48,-8},{-36,-8},{-36,
          12},{-32,12}},       color={255,0,255}));
  connect(timSpe1.passed,dow. u2) annotation (Line(points={{-48,-48},{-40,-48},{
          -40,-40},{-32,-40}}, color={255,0,255}));
  connect(numOpe.y, numOpeSam.u) annotation (Line(points={{-108,160},{-100,160},
          {-100,140},{-12,140}}, color={0,0,127}));
  connect(numOpeSam.y, cvtInt.u)
    annotation (Line(points={{12,140},{24,140}}, color={0,0,127}));
  connect(upOrDown.y, numOpeSam.trigger) annotation (Line(points={{0,92},{0,128}},
                                               color={255,0,255}));
  connect(up.y, upOrDown.u1) annotation (Line(points={{-8,20},{0,20},{0,68}},
                             color={255,0,255}));
  connect(dow.y, upOrDown.u2)
    annotation (Line(points={{-8,-40},{8,-40},{8,68}},   color={255,0,255}));
  connect(oneIfTrue.u, updUp.y)
    annotation (Line(points={{48,20},{42,20}},            color={255,0,255}));
  connect(numOpeSam.y, cmpNumPum.u) annotation (Line(points={{12,140},{14,140},{
          14,-20},{18,-20}},  color={0,0,127}));
  connect(numOpeSam.y, cmpOnePum.u) annotation (Line(points={{12,140},{14,140},{
          14,-50},{18,-50}},  color={0,0,127}));
  connect(updDow.y, minOneIfTru.u)
    annotation (Line(points={{42,-80},{48,-80}},   color={255,0,255}));
  connect(dow.y, updDow.u1)
    annotation (Line(points={{-8,-40},{8,-40},{8,-80},{18,-80}},
                                                   color={255,0,255}));
  connect(oneIfTrue.y, add1.u[1]) annotation (Line(points={{72,20},{72,-2.33333},
          {88,-2.33333}},                   color={255,127,0}));
  connect(minOneIfTru.y, add1.u[2]) annotation (Line(points={{72,-80},{80,-80},{
          80,-4.44089e-16},{88,-4.44089e-16}},
                                      color={255,127,0}));
  connect(m_flow, filFlo.u)
    annotation (Line(points={{-220,80},{-172,80}}, color={0,0,127}));
  connect(filFlo.y, ratFlo.u)
    annotation (Line(points={{-149,80},{-142,80}}, color={0,0,127}));
  connect(numOpe.y, numOpeInt.u) annotation (Line(points={{-108,160},{-100,160},
          {-100,180},{-12,180}}, color={0,0,127}));
  connect(upOrDown.y, swi.u2) annotation (Line(points={{0,92},{0,100},{80,100},
          {80,92}},                color={255,0,255}));
  connect(swi.y, add1.u[3]) annotation (Line(points={{80,68},{80,2.33333},{88,
          2.33333}}, color={255,127,0}));
  connect(numOpeInt.y, swi.u3)
    annotation (Line(points={{12,180},{88,180},{88,92}}, color={255,127,0}));
  connect(cvtInt.y, swi.u1)
    annotation (Line(points={{48,140},{72,140},{72,92}}, color={255,127,0}));
  connect(up.y, updUp.u1)
    annotation (Line(points={{-8,20},{18,20}},   color={255,0,255}));
  connect(cmpNumPum.y, updUp.u2) annotation (Line(points={{42,-20},{44,-20},{44,
          0},{16,0},{16,12},{18,12}},       color={255,0,255}));
  connect(cmpOnePum.y, updDow.u2) annotation (Line(points={{42,-50},{44,-50},{44,
          -64},{14,-64},{14,-88},{18,-88}},        color={255,0,255}));
  connect(y1_actual[1], leaDis.u) annotation (Line(points={{-220,160},{-180,160},
          {-180,-80},{-72,-80}},   color={255,0,255}));
  connect(leaDis.y, dow.u3) annotation (Line(points={{-48,-80},{-36,-80},{-36,-48},
          {-32,-48}},      color={255,0,255}));
  connect(yVal, isOpe.u)
    annotation (Line(points={{-220,-120},{-182,-120}}, color={0,0,127}));
  connect(isAnyOpe.y,delRis. u)
    annotation (Line(points={{-38,-120},{-22,-120}},   color={255,0,255}));
  connect(yValSwi, isOpe1.u)
    annotation (Line(points={{-220,-160},{-182,-160}}, color={0,0,127}));
  connect(isOpe.y, isoAndSwiOpe.u1)
    annotation (Line(points={{-158,-120},{-102,-120}}, color={255,0,255}));
  connect(isOpe1.y, isoAndSwiOpe.u2) annotation (Line(points={{-158,-160},{-150,
          -160},{-150,-128},{-102,-128}}, color={255,0,255}));
  connect(tru.y, isoAndSwiOpe.u2) annotation (Line(points={{-118,-160},{-110,
          -160},{-110,-128},{-102,-128}}, color={255,0,255}));
  connect(isoAndSwiOpe.y, isAnyOpe.u)
    annotation (Line(points={{-78,-120},{-62,-120}}, color={255,0,255}));
  connect(delRis.y, y1[1]) annotation (Line(points={{2,-120},{180,-120},{180,0},
          {220,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="staPum",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,
            200}})));
end StagingPumpDetailed;
