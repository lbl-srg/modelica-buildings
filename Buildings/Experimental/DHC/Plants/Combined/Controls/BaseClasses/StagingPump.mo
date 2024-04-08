within Buildings.Experimental.DHC.Plants.Combined.Controls.BaseClasses;
block StagingPump "Pump staging"

  parameter Boolean have_flowCriterion=true
    "Set to true for flow criterion in conjunction with speed criterion"
    annotation(Evaluate=true);
  parameter Integer nPum(
    final min=1,
    start=1)
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Loop design mass flow rate (all pumps)"
    annotation(Dialog(group="Nominal condition", enable=have_flowCriterion));
  parameter Real yDow=0.30
    "Low speed limit for staging down";
  parameter Real yUp=0.99
    "High speed limit for staging up";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Ena
    "Lead pump Enable signal (e.g. based on isolation valve opening command)"
    annotation (Placement(transformation(extent={{-240,140},{-200,180}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow(final unit="kg/s")
    if have_flowCriterion
    "Mass flow rate as measured by the loop flow meter"
    annotation (Placement(
        transformation(extent={{-240,60},{-200,100}}),iconTransformation(extent={{-140,
            -20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(final unit="1")
    "Commanded speed"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nPum]
    "Start signal (VFD Run or motor starter contact)"
    annotation (Placement(
        transformation(extent={{200,-20},{240,20}}), iconTransformation(extent={{100,40},
            {140,80}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold cmp(final t=yUp, h=1e-3)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe(t=5*60)
    "True delay"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter ratFlo(
    final k=1/m_flow_nominal) if have_flowCriterion
    "Ratio of current flow rate to design value"
    annotation (Placement(transformation(extent={{-148,70},{-128,90}})));
  Buildings.Controls.OBC.CDL.Reals.Greater cmp2(h=1e-3)
    if have_flowCriterion
    "Compare"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOff(p=-0.03)
    if have_flowCriterion
    "Add offset"
    annotation (Placement(transformation(extent={{-80,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo(t=10*60)
    if have_flowCriterion
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,90},{-52,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or up
    "Check if flow or speed criterion passed for staging up"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Less cmp3(h=1e-3)
    if have_flowCriterion
    "Compare"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timFlo1(t=10*60)
    if have_flowCriterion
    "Check if true for a given time"
    annotation (Placement(transformation(extent={{-72,50},{-52,70}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold  cmp4(final t=yDow, h=1e-3)
    "Compare"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timSpe1(t=5*60) "True delay"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or  dow
    "Check if flow or speed criterion passed for staging down"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter ratOpeDsg(
    final k=1/nPum)
    "Ratio of number of operating pumps to number of operating pumps at design conditions"
    annotation (Placement(transformation(extent={{-40,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold cvtBoo[nPum](
    final t={i for i in 1:nPum})
    "Compute pump Start command from number of pumps to be commanded On"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator rep(
    final nout=nPum) "Replicate"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  StageIndex staLag(final nSta=max(1, nPum - 1), tSta=30)
    if nPum>1
    "Stage lag pumps (minimum runtime allowing for pump start time)"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal cvtInt "Convert"
    annotation (Placement(transformation(extent={{50,130},{30,150}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOffLowSta(
    final p=-1/nPum) if have_flowCriterion
    "Add offset for lower stage"
    annotation (Placement(transformation(extent={{-150,30},{-130,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger leaEna
    "Return 1 if lead pump enabled"
    annotation (Placement(transformation(extent={{30,30},{50,50}})));
  Buildings.Controls.OBC.CDL.Integers.Add num "Number of pumps enabled"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Add numPre "Number of pumps enabled"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer(final k=0)
    if nPum==1
    "Constant"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fal(final k=false)
    if not have_flowCriterion
    "Constant"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput nPumEna
    "Number of pumps that are enabled" annotation (Placement(transformation(
          extent={{200,-80},{240,-40}}), iconTransformation(extent={{100,-80},{
            140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1Any
    "Return true if any pump enabled (left limit to avoid direct feedback)"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold anyEna(final t=1)
    "Return true if any pump is enabled"
    annotation (Placement(transformation(extent={{120,-130},{140,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Left limit of signal avoiding direct feedback"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));
equation
  connect(y, cmp.u)
    annotation (Line(points={{-220,0},{-102,0}},     color={0,0,127}));
  connect(cmp.y, timSpe.u)
    annotation (Line(points={{-78,0},{-72,0}},       color={255,0,255}));
  connect(ratFlo.y, cmp2.u1)
    annotation (Line(points={{-126,80},{-120,80},{-120,100},{-102,100}},
                                                 color={0,0,127}));
  connect(addOff.y, cmp2.u2) annotation (Line(points={{-102,140},{-110,140},{
          -110,92},{-102,92}},            color={0,0,127}));
  connect(timFlo.passed, up.u1) annotation (Line(points={{-50,92},{-36,92},{-36,
          0},{-32,0}},     color={255,0,255}));
  connect(ratFlo.y, cmp3.u1) annotation (Line(points={{-126,80},{-120,80},{-120,
          60},{-102,60}}, color={0,0,127}));
  connect(y, cmp4.u) annotation (Line(points={{-220,0},{-160,0},{-160,-40},{-102,
          -40}},       color={0,0,127}));
  connect(cmp4.y, timSpe1.u)
    annotation (Line(points={{-78,-40},{-72,-40}},   color={255,0,255}));
  connect(timFlo1.passed,dow. u1) annotation (Line(points={{-50,52},{-40,52},{
          -40,-40},{-32,-40}},                   color={255,0,255}));
  connect(addOff.u, ratOpeDsg.y)
    annotation (Line(points={{-78,140},{-62,140}}, color={0,0,127}));
  connect(rep.y, cvtBoo.u)
    annotation (Line(points={{142,0},{158,0}}, color={255,127,0}));
  connect(cmp2.y, timFlo.u)
    annotation (Line(points={{-78,100},{-74,100}},
                                                 color={255,0,255}));
  connect(cmp3.y, timFlo1.u)
    annotation (Line(points={{-78,60},{-74,60}}, color={255,0,255}));
  connect(timSpe.passed, up.u2) annotation (Line(points={{-48,-8},{-32,-8}},
                               color={255,0,255}));
  connect(timSpe1.passed,dow. u2) annotation (Line(points={{-48,-48},{-40,-48},
          {-40,-48},{-32,-48}},color={255,0,255}));
  connect(y1Ena, staLag.u1) annotation (Line(points={{-220,160},{0,160},{0,6},{
          28,6}},
               color={255,0,255}));
  connect(cvtInt.y, ratOpeDsg.u)
    annotation (Line(points={{28,140},{-38,140}}, color={0,0,127}));
  connect(cvtBoo.y, y1)
    annotation (Line(points={{182,0},{220,0}}, color={255,0,255}));
  connect(addOff.y, addOffLowSta.u) annotation (Line(points={{-102,140},{-160,
          140},{-160,40},{-152,40}}, color={0,0,127}));
  connect(addOffLowSta.y, cmp3.u2) annotation (Line(points={{-128,40},{-116,40},
          {-116,52},{-102,52}}, color={0,0,127}));
  connect(y1Ena, leaEna.u) annotation (Line(points={{-220,160},{0,160},{0,40},{
          28,40}},
                color={255,0,255}));
  connect(dow.y, staLag.u1Dow) annotation (Line(points={{-8,-40},{0,-40},{0,
          -5.8},{28,-5.8}},
                      color={255,0,255}));
  connect(num.y, rep.u)
    annotation (Line(points={{102,0},{118,0}},
                                             color={255,127,0}));
  connect(staLag.idxSta, num.u2) annotation (Line(points={{52,0},{60,0},{60,-6},
          {78,-6}}, color={255,127,0}));
  connect(leaEna.y, num.u1) annotation (Line(points={{52,40},{60,40},{60,6},{78,
          6}}, color={255,127,0}));
  connect(numPre.y, cvtInt.u) annotation (Line(points={{102,60},{120,60},{120,
          140},{52,140}},
                     color={255,127,0}));
  connect(leaEna.y, numPre.u1) annotation (Line(points={{52,40},{60,40},{60,66},
          {78,66}}, color={255,127,0}));
  connect(staLag.preIdxSta, numPre.u2) annotation (Line(points={{52,-6},{56,-6},
          {56,54},{78,54}}, color={255,127,0}));
  connect(zer.y, num.u2) annotation (Line(points={{52,-40},{68,-40},{68,-6},{78,
          -6}}, color={255,127,0}));
  connect(zer.y, numPre.u2) annotation (Line(points={{52,-40},{68,-40},{68,54},
          {78,54}},color={255,127,0}));
  connect(up.y, staLag.u1Up)
    annotation (Line(points={{-8,0},{28,0}}, color={255,0,255}));
  connect(fal.y, dow.u1) annotation (Line(points={{-48,-80},{-36,-80},{-36,-40},
          {-32,-40}}, color={255,0,255}));
  connect(fal.y, up.u1) annotation (Line(points={{-48,-80},{-36,-80},{-36,0},{-32,
          0}}, color={255,0,255}));
  connect(num.y, nPumEna) annotation (Line(points={{102,0},{110,0},{110,-60},{
          220,-60}}, color={255,127,0}));
  connect(anyEna.y, pre1.u)
    annotation (Line(points={{142,-120},{158,-120}}, color={255,0,255}));
  connect(pre1.y, y1Any)
    annotation (Line(points={{182,-120},{220,-120}}, color={255,0,255}));
  connect(num.y, anyEna.u) annotation (Line(points={{102,0},{110,0},{110,-120},
          {118,-120}}, color={255,127,0}));
  connect(m_flow, ratFlo.u)
    annotation (Line(points={{-220,80},{-150,80}}, color={0,0,127}));
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
            200}})),
    Documentation(info="<html>
<p>
This block implements the logic for staging the lag pump of
a multiple-pump group.
<p>
The first staging criterion is optional and is based on <i>ratFlo</i>,
the ratio of current flow rate to design flow rate.
The lag pump is enabled whenever any of the following is true.
</p>
<ul>
<li>The pump speed command is higher than <code>yUp</code> for <i>5</i>&nbsp;min.
</li>
<li>Optionally if <code>have_flowCriterion</code> is set to <code>true</code>, the ratio <i>ratFlo</i>
is higher than <i>n / nPum - 0.03</i> for <i>10</i>&nbsp;min, where <i>n</i> is the number
of operating pumps and <i>nPum</i> is the number of pumps operating at design conditions.
</li>
</ul>
<p>
The lag pump is disabled whenever any of the following is true.
</p>
<ul>
<li>The lead pump is disabled.
</li>
<li>The pump speed command is lower than <code>yDow</code> for <i>5</i>&nbsp;min.
</li>
<li>Optionally if <code>have_flowCriterion</code> is set to <code>true</code>, the ratio <i>ratFlo</i>
is higher than <i>(n - 1) / nPum - 0.03</i> for <i>10</i>&nbsp;min.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StagingPump;
