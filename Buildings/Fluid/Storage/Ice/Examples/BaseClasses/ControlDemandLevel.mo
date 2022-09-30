within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlDemandLevel "Controller that outputs the demand level"
  parameter Real k = 0.1 "Gain for control error";
  parameter Real Ti=600 "Time constant of integrator block";

  parameter Real h(unit="K")=2 "Hysteresis";

  Controls.OBC.CDL.Interfaces.RealInput u_s(
      final unit="K",
      displayUnit="degC") "Set point" annotation (Placement(
        transformation(extent={{-240,60},{-200,100}}),iconTransformation(extent=
           {{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.RealInput u_m(
      final unit="K",
      displayUnit="degC") "Measurement signal" annotation (
      Placement(transformation(extent={{-240,-120},{-200,-80}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Controls.OBC.CDL.Interfaces.IntegerOutput y "Demand level"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,40},{140,80}})));

  Controls.OBC.CDL.Interfaces.RealOutput yDemLev1
    "Control signal for demand level 2"
    annotation (Placement(transformation(extent={{200,-80},{240,-40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealOutput yDemLev2
    "Control signal for demand level 2"
    annotation (Placement(transformation(extent={{200,-140},{240,-100}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    reverseActing=false,
    y_reset=0.2,
    u_s(
      final unit="K",
      displayUnit="degC"),
    u_m(
      final unit="K",
      displayUnit="degC"))
                   annotation (Placement(transformation(extent={{-140,-10},{-120,
            10}})));

  Controls.OBC.CDL.Continuous.Limiter limDemLev1(uMax=1, uMin=0)
    "Limiter for continuous control signal for demand level 1"
    annotation (Placement(transformation(extent={{160,-70},{180,-50}})));
  Controls.OBC.CDL.Continuous.Limiter limDemLev2(uMax=1, uMin=0)
    "Limiter for continuous control signal for demand level 1"
    annotation (Placement(transformation(extent={{160,-130},{180,-110}})));

  Controls.OBC.CDL.Integers.GreaterThreshold isDemLev2(t=2)
    "Output true if demand level is 2"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Controls.OBC.CDL.Continuous.Switch swi
    annotation (Placement(transformation(extent={{120,-70},{140,-50}})));
  Controls.OBC.CDL.Continuous.AddParameter redLoa(p=0.7) "Keep base load"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{72,120},{92,140}})));
  Controls.OBC.CDL.Integers.Sources.Constant zer(k=0) "Output zero"
    annotation (Placement(transformation(extent={{30,138},{50,158}})));
  Controls.OBC.CDL.Integers.Sources.Constant one(k=1) "Output 1"
    annotation (Placement(transformation(extent={{28,172},{48,192}})));
  Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{72,60},{92,80}})));
  Controls.OBC.CDL.Integers.AddParameter addPar(p=1)
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Controls.OBC.CDL.Integers.Add addInt
    annotation (Placement(transformation(extent={{110,100},{130,120}})));

  Controls.OBC.CDL.Continuous.Subtract err "Control error"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(final uLow=-h/2, final uHigh=h/2)
    "Hysteresis for enabling first stage"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Controls.OBC.CDL.Continuous.Hysteresis hys2(final uLow=0.1, final uHigh=0.98)
    "Hysteresis for enabling second stage"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Controls.OBC.CDL.Continuous.MultiplyByParameter gai(k=-1)
    "Gain to change sign of error"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Controls.OBC.CDL.Integers.Change cha
    annotation (Placement(transformation(extent={{110,140},{130,160}})));
  Controls.OBC.CDL.Logical.Timer tim1(t=3600) "Timer for minimum run time"
    annotation (Placement(transformation(extent={{172,170},{192,190}})));
  Controls.OBC.CDL.Logical.Timer tim2(t=3600) "Timer for minimum run time"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Controls.OBC.CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Controls.OBC.CDL.Logical.Or or2
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Controls.OBC.CDL.Logical.Pre pre
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
equation
  connect(conPID.u_s, u_s) annotation (Line(points={{-142,0},{-160,0},{-160,80},
          {-220,80}},color={0,0,127}));
  connect(conPID.u_m, u_m) annotation (Line(points={{-130,-12},{-130,-100},{-220,
          -100}},color={0,0,127}));
  connect(limDemLev1.y, yDemLev1)
    annotation (Line(points={{182,-60},{220,-60}},color={0,0,127}));
  connect(limDemLev2.y, yDemLev2)
    annotation (Line(points={{182,-120},{220,-120}},
                                                  color={0,0,127}));
  connect(limDemLev1.u, swi.y)
    annotation (Line(points={{158,-60},{142,-60}},
                                                 color={0,0,127}));
  connect(isDemLev2.y, swi.u2) annotation (Line(points={{42,-50},{60,-50},{60,-60},
          {118,-60}},                   color={255,0,255}));
  connect(conPID.y, swi.u3) annotation (Line(points={{-118,0},{-100,0},{-100,-68},
          {118,-68}},
                    color={0,0,127}));
  connect(conPID.y, redLoa.u)
    annotation (Line(points={{-118,0},{-100,0},{-100,-30},{78,-30}},
                                               color={0,0,127}));
  connect(redLoa.y, swi.u1) annotation (Line(points={{102,-30},{112,-30},{112,-52},
          {118,-52}},
                 color={0,0,127}));
  connect(addPar.y, y) annotation (Line(points={{162,110},{170,110},{170,0},{220,
          0}},             color={255,127,0}));
  connect(addPar.y, isDemLev2.u) annotation (Line(points={{162,110},{170,110},{170,
          20},{-80,20},{-80,-50},{18,-50}},
                                         color={255,127,0}));
  connect(intSwi.y, addInt.u1) annotation (Line(points={{94,130},{100,130},{100,
          116},{108,116}}, color={255,127,0}));
  connect(intSwi1.y, addInt.u2) annotation (Line(points={{94,70},{100,70},{100,104},
          {108,104}}, color={255,127,0}));
  connect(addPar.u, addInt.y)
    annotation (Line(points={{138,110},{132,110}}, color={255,127,0}));
  connect(zer.y, intSwi.u3) annotation (Line(points={{52,148},{62,148},{62,122},
          {70,122}}, color={255,127,0}));
  connect(one.y, intSwi.u1) annotation (Line(points={{50,182},{64,182},{64,138},
          {70,138}}, color={255,127,0}));
  connect(one.y, intSwi1.u1) annotation (Line(points={{50,182},{64,182},{64,78},
          {70,78}}, color={255,127,0}));
  connect(zer.y, intSwi1.u3) annotation (Line(points={{52,148},{62,148},{62,62},
          {70,62}}, color={255,127,0}));
  connect(u_s, err.u1) annotation (Line(points={{-220,80},{-180,80},{-180,136},{
          -162,136}}, color={0,0,127}));
  connect(err.u2, u_m) annotation (Line(points={{-162,124},{-174,124},{-174,-100},
          {-220,-100}}, color={0,0,127}));
  connect(err.y, gai.u)
    annotation (Line(points={{-138,130},{-122,130}}, color={0,0,127}));
  connect(hys1.u, gai.y)
    annotation (Line(points={{-42,130},{-98,130}}, color={0,0,127}));
  connect(conPID.y, limDemLev2.u) annotation (Line(points={{-118,0},{-100,0},{-100,
          -120},{158,-120}}, color={0,0,127}));
  connect(cha.y, conPID.trigger) annotation (Line(points={{132,150},{180,150},{180,
          -14},{-136,-14},{-136,-12}},
                                  color={255,0,255}));
  connect(hys1.y, or1.u2) annotation (Line(points={{-18,130},{-10,130},{-10,122},
          {-2,122}}, color={255,0,255}));
  connect(hys2.y, tim2.u) annotation (Line(points={{-38,40},{-14,40},{-14,70},{-52,
          70},{-52,90},{-42,90}}, color={255,0,255}));
  connect(hys2.y, or2.u2) annotation (Line(points={{-38,40},{-10,40},{-10,32},{-2,
          32}}, color={255,0,255}));
  connect(tim2.passed, or2.u1) annotation (Line(points={{-18,82},{-10,82},{-10,42},
          {0,42}}, color={255,0,255}));
  connect(or1.y, intSwi.u2)
    annotation (Line(points={{22,130},{70,130}}, color={255,0,255}));
  connect(conPID.y, hys2.u) annotation (Line(points={{-118,0},{-100,0},{-100,40},
          {-62,40}}, color={0,0,127}));
  connect(or2.y, intSwi1.u2) annotation (Line(points={{22,40},{56,40},{56,70},{70,
          70}}, color={255,0,255}));
  connect(intSwi.y, cha.u) annotation (Line(points={{94,130},{100,130},{100,150},
          {108,150}}, color={255,127,0}));
  connect(pre.u, cha.y) annotation (Line(points={{138,180},{134,180},{134,150},{
          130,150}}, color={255,0,255}));
  connect(pre.y, tim1.u)
    annotation (Line(points={{162,180},{172,180}}, color={255,0,255}));
  connect(tim1.passed, or1.u1) annotation (Line(points={{194,172},{198,172},{198,
          164},{-6,164},{-6,130},{2,130}}, color={255,0,255}));
  annotation (
  defaultComponentName="ctrDemLev",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-154,152},{146,112}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{52,72},{96,46}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=1)))}),
            Diagram(coordinateSystem(extent={{-200,-200},{200,200}})),
    Documentation(info="<html>
<p>
Block that converts a control error into a demand level signal.
This block uses a PI controller to integrate the control error
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlDemandLevel;
