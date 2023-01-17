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
        transformation(extent={{-220,-180},{-180,-140}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent={{100,-20},
            {140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmp(t=0.99)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratFlo(k=1/(nPum*
        mPum_flow_nominal)) "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-140,30},{-120,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cmp2 "Compare"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1_actual[nPum]
    "Pump status" annotation (Placement(transformation(extent={{-220,100},{-180,
            140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cvt[nPum]
    "Convert to real"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum numOpe(nin=nPum)
    "Number of operating pumps"
    annotation (Placement(transformation(extent={{-130,110},{-110,130}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addOff(p=-0.03)
    "Add offset"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,50},{-52,70}})));
  Buildings.Controls.OBC.CDL.Logical.Or up
    "Check if flow or speed criterion passed for staging up"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmp1(
    t=5E-2,
    h=1E-2) "Compare"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum1(nin=nChi)
    "Sum up control signals"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Less    cmp3 "Compare"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(t=10*60)
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,10},{-52,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold  cmp4(t=0.3)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe1(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-70,-130},{-50,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Or dow
    "Check if flow or speed criterion passed for staging down"
    annotation (Placement(transformation(extent={{-30,-130},{-10,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter ratOpeDsg(
    final k=1/nPum)
    "Ratio of number of operating pumps to number of operating pumps at design conditions"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger minOneIfTru(
    final integerTrue=-1) "Return -1 if staging down"
    annotation (Placement(transformation(extent={{50,-130},{70,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger oneIfTrue(
    final integerTrue=1) "Return +1 if staging up"
    annotation (Placement(transformation(extent={{50,-32},{70,-12}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum add1(nin=3)
    "Compute updated number of operating pumps"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cvtBoo[nPum](t={i
        for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger cvtInt "Convert"
    annotation (Placement(transformation(extent={{26,90},{46,110}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nPum) "Replicate"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler numOpeSam
    "Number of operating pumps, sampled"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or upOrDown
    "Check if flow or speed criterion passed for staging up or down"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Modelica.Blocks.Continuous.FirstOrder filFlo(T=60, initType=Modelica.Blocks.Types.Init.InitialOutput)
    "Filter input to avoid algebraic loop"
    annotation (Placement(transformation(extent={{-170,30},{-150,50}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold cmpNumPum(t=nPum)
    "Compare sampled number of pumps to maximum number"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And updUp
    "Update number of pumps only if another pump available"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold cmpOnePum(t=1)
    "Compare sampled number of pumps to one"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And updDow
    "Update number of pumps only if more than one pump operating"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Switch swi
    "When transition fires switch to sampled number and update, otherwise feed current number"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,40})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger numOpeInt
    "Number of operating pumps"
    annotation (Placement(transformation(extent={{-10,130},{10,150}})));
equation
  connect(y, cmp.u)
    annotation (Line(points={{-200,-40},{-102,-40}}, color={0,0,127}));
  connect(cmp.y, timSpe.u)
    annotation (Line(points={{-78,-40},{-72,-40}},   color={255,0,255}));
  connect(ratFlo.y, cmp2.u1)
    annotation (Line(points={{-118,40},{-116,40},{-116,60},{-102,60}},
                                                 color={0,0,127}));
  connect(addOff.y, cmp2.u2) annotation (Line(points={{-28,120},{-20,120},{-20,
          40},{-110,40},{-110,52},{-102,52}},
                                          color={0,0,127}));
  connect(timFlo.passed, up.u1) annotation (Line(points={{-50,52},{-36,52},{-36,
          -20},{-32,-20}}, color={255,0,255}));
  connect(cmp1.u, sum1.y)
    annotation (Line(points={{-102,-160},{-108,-160}},
                                                     color={0,0,127}));
  connect(yVal, sum1.u)
    annotation (Line(points={{-200,-160},{-132,-160}}, color={0,0,127}));
  connect(cmp1.y, y1[1]) annotation (Line(points={{-78,-160},{180,-160},{180,0},
          {220,0}}, color={255,0,255}));
  connect(ratFlo.y, cmp3.u1) annotation (Line(points={{-118,40},{-116,40},{-116,
          20},{-102,20}}, color={0,0,127}));
  connect(addOff.y, cmp3.u2) annotation (Line(points={{-28,120},{-20,120},{-20,
          40},{-110,40},{-110,12},{-102,12}}, color={0,0,127}));
  connect(y, cmp4.u) annotation (Line(points={{-200,-40},{-140,-40},{-140,-120},
          {-102,-120}},color={0,0,127}));
  connect(cmp4.y, timSpe1.u)
    annotation (Line(points={{-78,-120},{-72,-120}}, color={255,0,255}));
  connect(timFlo1.passed,dow. u1) annotation (Line(points={{-50,12},{-40,12},{
          -40,-120},{-32,-120}},                 color={255,0,255}));
  connect(numOpe.y, ratOpeDsg.u)
    annotation (Line(points={{-108,120},{-92,120}}, color={0,0,127}));
  connect(addOff.u, ratOpeDsg.y)
    annotation (Line(points={{-52,120},{-68,120}}, color={0,0,127}));
  connect(add1.y, rep.u)
    annotation (Line(points={{112,0},{118,0}},
                                             color={255,127,0}));
  connect(rep.y, cvtBoo.u)
    annotation (Line(points={{142,0},{148,0}}, color={255,127,0}));
  connect(cvtBoo[2:nPum].y, y1[2:nPum])
    annotation (Line(points={{172,0},{220,0}}, color={255,0,255}));
  connect(cvt.y, numOpe.u)
    annotation (Line(points={{-138,120},{-132,120}}, color={0,0,127}));
  connect(y1_actual, cvt.u)
    annotation (Line(points={{-200,120},{-162,120}}, color={255,0,255}));
  connect(cmp2.y, timFlo.u)
    annotation (Line(points={{-78,60},{-74,60}}, color={255,0,255}));
  connect(cmp3.y, timFlo1.u)
    annotation (Line(points={{-78,20},{-74,20}}, color={255,0,255}));
  connect(timSpe.passed, up.u2) annotation (Line(points={{-48,-48},{-36,-48},{
          -36,-28},{-32,-28}}, color={255,0,255}));
  connect(timSpe1.passed,dow. u2) annotation (Line(points={{-48,-128},{-32,-128}},
                               color={255,0,255}));
  connect(numOpe.y, numOpeSam.u) annotation (Line(points={{-108,120},{-100,120},
          {-100,100},{-12,100}}, color={0,0,127}));
  connect(numOpeSam.y, cvtInt.u)
    annotation (Line(points={{12,100},{24,100}}, color={0,0,127}));
  connect(upOrDown.y, numOpeSam.trigger) annotation (Line(points={{6.66134e-16,
          52},{6.66134e-16,60},{0,60},{0,88}}, color={255,0,255}));
  connect(up.y, upOrDown.u1) annotation (Line(points={{-8,-20},{0,-20},{0,28},{
          -8.88178e-16,28}}, color={255,0,255}));
  connect(dow.y, upOrDown.u2)
    annotation (Line(points={{-8,-120},{8,-120},{8,28}}, color={255,0,255}));
  connect(oneIfTrue.u, updUp.y)
    annotation (Line(points={{48,-22},{48,-20},{42,-20}}, color={255,0,255}));
  connect(numOpeSam.y, cmpNumPum.u) annotation (Line(points={{12,100},{14,100},
          {14,-60},{18,-60}}, color={0,0,127}));
  connect(numOpeSam.y, cmpOnePum.u) annotation (Line(points={{12,100},{14,100},
          {14,-90},{18,-90}}, color={0,0,127}));
  connect(updDow.y, minOneIfTru.u)
    annotation (Line(points={{42,-120},{48,-120}}, color={255,0,255}));
  connect(dow.y, updDow.u1)
    annotation (Line(points={{-8,-120},{18,-120}}, color={255,0,255}));
  connect(oneIfTrue.y, add1.u[1]) annotation (Line(points={{72,-22},{72,
          -2.33333},{88,-2.33333}},         color={255,127,0}));
  connect(minOneIfTru.y, add1.u[2]) annotation (Line(points={{72,-120},{80,-120},
          {80,-4.44089e-16},{88,-4.44089e-16}},
                                      color={255,127,0}));
  connect(m_flow, filFlo.u)
    annotation (Line(points={{-200,40},{-172,40}}, color={0,0,127}));
  connect(filFlo.y, ratFlo.u)
    annotation (Line(points={{-149,40},{-142,40}}, color={0,0,127}));
  connect(numOpe.y, numOpeInt.u) annotation (Line(points={{-108,120},{-100,120},
          {-100,140},{-12,140}}, color={0,0,127}));
  connect(upOrDown.y, swi.u2) annotation (Line(points={{6.66134e-16,52},{0,52},
          {0,60},{60,60},{60,52}}, color={255,0,255}));
  connect(swi.y, add1.u[3]) annotation (Line(points={{60,28},{60,2.33333},{88,
          2.33333}}, color={255,127,0}));
  connect(numOpeInt.y, swi.u3)
    annotation (Line(points={{12,140},{68,140},{68,52}}, color={255,127,0}));
  connect(cvtInt.y, swi.u1)
    annotation (Line(points={{48,100},{52,100},{52,52}}, color={255,127,0}));
  connect(up.y, updUp.u1)
    annotation (Line(points={{-8,-20},{18,-20}}, color={255,0,255}));
  connect(cmpNumPum.y, updUp.u2) annotation (Line(points={{42,-60},{44,-60},{44,
          -40},{16,-40},{16,-28},{18,-28}}, color={255,0,255}));
  connect(cmpOnePum.y, updDow.u2) annotation (Line(points={{42,-90},{44,-90},{
          44,-104},{14,-104},{14,-128},{18,-128}}, color={255,0,255}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,
            200}})));
end StagingPumpDetailed;
