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
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal
    "Design mass flow rate (each pump)"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final unit="kg/s")
    "Mass flow rate as measured by the loop flow meter" annotation (Placement(
        transformation(extent={{-220,20},{-180,60}}), iconTransformation(extent
          ={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    "Commanded speed"
    annotation (Placement(transformation(extent={{-220,-60},{-180,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal[nChi](each final unit="1")
    "Chiller isolation valve commanded position"
    annotation (Placement(
        transformation(extent={{-220,-140},{-180,-100}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{180,-20},{220,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmp(t=0.99)
    "Compare"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratFlo(k=1/(nPum*
        mPum_flow_nominal)) "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cmp2 "Compare"
    annotation (Placement(transformation(extent={{-98,50},{-78,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1_actual[nPum]
    "Pump status" annotation (Placement(transformation(extent={{-220,100},{-180,
            140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvt[nPum]
    "Convert to real"
    annotation (Placement(transformation(extent={{-150,110},{-130,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum numOpe(nin=nPum)
    "Number of operating pumps"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOff(p=-0.03)
    "Add offset"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or ena
    "Check if flow or speed criterion passed"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmp1(
    t=5E-2,
    h=1E-2) "Compare"
    annotation (Placement(transformation(extent={{-130,-130},{-110,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum1(nin=nChi)
    "Sum up control signals"
    annotation (Placement(transformation(extent={{-160,-130},{-140,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Less    cmp3 "Compare"
    annotation (Placement(transformation(extent={{-98,10},{-78,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold  cmp4(t=0.3)
    "Compare"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe1(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or dis
    "Check if flow or speed criterion passed"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratOpeDsg(
    final k=1/nPum)
    "Ratio of number of operating pumps to number of operating pumps at design conditions"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal
                                         intEqu
                                             [nPum]
    "Check if commanded matches actual"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latEna
    "Keep signal true until commanded matches actual"
    annotation (Placement(transformation(extent={{6,-30},{26,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nin=nPum)
    "True if commanded macthes actual for all units"
    annotation (Placement(transformation(extent={{-60,150},{-40,170}})));
  Buildings.Controls.OBC.CDL.Logical.Latch latDis
    "Keep signal true until commanded matches actual"
    annotation (Placement(transformation(extent={{6,-90},{26,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger minOneIfTru(
    final integerTrue=-1) "Return -1 if staging down"
    annotation (Placement(transformation(extent={{36,-90},{56,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger oneIfTrue(
    final integerTrue=1) "Return +1 if staging up"
    annotation (Placement(transformation(extent={{36,-30},{56,-10}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum add1(nin=3)
    "Compute updated number of operating pumps"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cvtBoo[nPum](t={i
        for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{130,-10},{150,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger cvtInt "Convert"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nPum) "Replicate"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger cvtInt1[nPum]
    "Convert"
    annotation (Placement(transformation(extent={{100,130},{80,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger cvtInt2[nPum]
    "Convert"
    annotation (Placement(transformation(extent={{-150,150},{-130,170}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preY[nPum]
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{138,130},{118,150}})));
  Modelica.Blocks.Continuous.FirstOrder filFlo(T=60, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter input to avoid algebraic loop"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=time)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
equation
  connect(y, cmp.u)
    annotation (Line(points={{-200,-40},{-112,-40}}, color={0,0,127}));
  connect(cmp.y, timSpe.u)
    annotation (Line(points={{-88,-40},{-82,-40}},   color={255,0,255}));
  connect(ratFlo.y, cmp2.u1)
    annotation (Line(points={{-118,40},{-114,40},{-114,60},{-100,60}},
                                                 color={0,0,127}));
  connect(addOff.y, cmp2.u2) annotation (Line(points={{-18,120},{-10,120},{-10,
          80},{-108,80},{-108,52},{-100,52}},
                                          color={0,0,127}));
  connect(timFlo.passed,ena. u1) annotation (Line(points={{-48,52},{-46,52},{-46,
          -20},{-42,-20}},                        color={255,0,255}));
  connect(cmp1.u, sum1.y)
    annotation (Line(points={{-132,-120},{-138,-120}},
                                                     color={0,0,127}));
  connect(yVal, sum1.u)
    annotation (Line(points={{-200,-120},{-162,-120}}, color={0,0,127}));
  connect(cmp1.y, y1[1]) annotation (Line(points={{-108,-120},{160,-120},{160,0},
          {200,0}}, color={255,0,255}));
  connect(ratFlo.y, cmp3.u1) annotation (Line(points={{-118,40},{-114,40},{-114,
          20},{-100,20}}, color={0,0,127}));
  connect(addOff.y, cmp3.u2) annotation (Line(points={{-18,120},{-10,120},{-10,
          80},{-108,80},{-108,12},{-100,12}}, color={0,0,127}));
  connect(y, cmp4.u) annotation (Line(points={{-200,-40},{-160,-40},{-160,-80},{
          -112,-80}},  color={0,0,127}));
  connect(cmp4.y, timSpe1.u)
    annotation (Line(points={{-88,-80},{-82,-80}},   color={255,0,255}));
  connect(timFlo1.passed, dis.u1) annotation (Line(points={{-48,12},{-48,-80},{-42,
          -80}},                                 color={255,0,255}));
  connect(numOpe.y, ratOpeDsg.u)
    annotation (Line(points={{-98,120},{-82,120}},  color={0,0,127}));
  connect(addOff.u, ratOpeDsg.y)
    annotation (Line(points={{-42,120},{-58,120}}, color={0,0,127}));
  connect(ena.y, latEna.u)
    annotation (Line(points={{-18,-20},{4,-20}},   color={255,0,255}));
  connect(intEqu.y, mulAnd.u)
    annotation (Line(points={{-78,160},{-62,160}}, color={255,0,255}));
  connect(dis.y, latDis.u)
    annotation (Line(points={{-18,-80},{4,-80}},   color={255,0,255}));
  connect(latDis.y, minOneIfTru.u)
    annotation (Line(points={{28,-80},{34,-80}}, color={255,0,255}));
  connect(latEna.y, oneIfTrue.u)
    annotation (Line(points={{28,-20},{34,-20}}, color={255,0,255}));
  connect(numOpe.y, cvtInt.u) annotation (Line(points={{-98,120},{-90,120},{-90,
          100},{8,100}},        color={0,0,127}));
  connect(cvtInt.y, add1.u[1]) annotation (Line(points={{32,100},{60,100},{60,-2.33333},
          {68,-2.33333}},           color={255,127,0}));
  connect(oneIfTrue.y, add1.u[2]) annotation (Line(points={{58,-20},{60,-20},{60,
          0},{68,0}},                          color={255,127,0}));
  connect(minOneIfTru.y, add1.u[3]) annotation (Line(points={{58,-80},{60,-80},{
          60,2.33333},{68,2.33333}},  color={255,127,0}));
  connect(add1.y, rep.u)
    annotation (Line(points={{92,0},{98,0}}, color={255,127,0}));
  connect(rep.y, cvtBoo.u)
    annotation (Line(points={{122,0},{128,0}}, color={255,127,0}));
  connect(cvtBoo[2:nPum].y, y1[2:nPum])
    annotation (Line(points={{152,0},{200,0}}, color={255,0,255}));
  connect(cvt.y, numOpe.u)
    annotation (Line(points={{-128,120},{-122,120}}, color={0,0,127}));
  connect(cvtInt1.y, intEqu.u2) annotation (Line(points={{78,140},{-120,140},{
          -120,152},{-102,152}},
                           color={255,127,0}));
  connect(cvtInt2.y, intEqu.u1)
    annotation (Line(points={{-128,160},{-102,160}},color={255,127,0}));
  connect(y1, preY.u) annotation (Line(points={{200,0},{160,0},{160,140},{140,140}},
        color={255,0,255}));
  connect(preY.y, cvtInt1.u)
    annotation (Line(points={{116,140},{102,140}}, color={255,0,255}));
  connect(y1_actual, cvt.u)
    annotation (Line(points={{-200,120},{-152,120}}, color={255,0,255}));
  connect(y1_actual, cvtInt2.u) annotation (Line(points={{-200,120},{-170,120},{
          -170,160},{-152,160}}, color={255,0,255}));
  connect(cmp2.y, timFlo.u)
    annotation (Line(points={{-76,60},{-72,60}}, color={255,0,255}));
  connect(cmp3.y, timFlo1.u)
    annotation (Line(points={{-76,20},{-72,20}}, color={255,0,255}));
  connect(m_flow, filFlo.u)
    annotation (Line(points={{-200,40},{-172,40}}, color={0,0,127}));
  connect(filFlo.y, ratFlo.u)
    annotation (Line(points={{-149,40},{-142,40}}, color={0,0,127}));
  connect(timSpe.passed, ena.u2) annotation (Line(points={{-58,-48},{-46,-48},{-46,
          -28},{-42,-28}}, color={255,0,255}));
  connect(timSpe1.passed, dis.u2) annotation (Line(points={{-58,-88},{-50,-88},{
          -50,-88},{-42,-88}}, color={255,0,255}));
  connect(mulAnd.y, latEna.clr) annotation (Line(points={{-38,160},{0,160},{0,
          -26},{4,-26}}, color={255,0,255}));
  connect(mulAnd.y, latDis.clr) annotation (Line(points={{-38,160},{-38,159.524},
          {0,159.524},{0,-86},{4,-86}}, color={255,0,255}));
  connect(realExpression.y, triSam.u)
    annotation (Line(points={{-9,40},{28,40}}, color={0,0,127}));
  connect(latEna.y, triSam.trigger) annotation (Line(points={{28,-20},{34,-20},
          {34,28},{40,28}}, color={255,0,255}));
  connect(realExpression.y, triSam1.u) annotation (Line(points={{-9,40},{40,40},
          {40,-60},{88,-60}}, color={0,0,127}));
  connect(latDis.y, triSam1.trigger) annotation (Line(points={{28,-80},{100,-80},
          {100,-72}}, color={255,0,255}));
  annotation (
  defaultComponentName="pum",
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-180},{180,180}})));
end StagingPumpDetailed;
