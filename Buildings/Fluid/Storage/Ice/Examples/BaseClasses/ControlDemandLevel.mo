within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
block ControlDemandLevel "Controller that outputs the demand level"
  parameter Real k = 1 "Gain for control error";
  parameter Real Ti=60 "Time constant of integrator block";

  parameter Modelica.Units.SI.Time waitTime=600
    "Wait time before transition fires";

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

  Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final k=k,
    final Ti=Ti,
    final yMax=1,
    final yMin=0,
    reverseActing=false,
    u_s(
      final unit="K",
      displayUnit="degC"),
    u_m(
      final unit="K",
      displayUnit="degC"))
                   annotation (Placement(transformation(extent={{-180,-10},{
            -160,10}})));

  Controls.OBC.CDL.Continuous.Limiter limDemLev1(uMax=1, uMin=0)
    "Limiter for continuous control signal for demand level 1"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Controls.OBC.CDL.Continuous.Limiter limDemLev2(uMax=1, uMin=0.1)
    "Limiter for continuous control signal for demand level 1"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));

  Controls.OBC.CDL.Integers.GreaterThreshold isDemLev2(t=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    "Output true if demand level is 2"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Controls.OBC.CDL.Continuous.Switch swi1
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Controls.OBC.CDL.Continuous.Add redLoa "Keep base load"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Controls.OBC.CDL.Continuous.Switch swi2
    annotation (Placement(transformation(extent={{120,-160},{140,-140}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con(final k=y1Min)
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Controls.OBC.CDL.Continuous.Subtract     redLoa1       "Keep base load"
    annotation (Placement(transformation(extent={{-20,-160},{0,-140}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0)
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Modelica.StateGraph.InitialStep off(nOut=1, nIn=1)
    annotation (Placement(transformation(extent={{-30,160},{-10,180}})));
  Modelica.StateGraph.StepWithSignal lev1(nIn=2, nOut=2) "Demand level 1"
    annotation (Placement(transformation(extent={{30,160},{50,180}})));
  Modelica.StateGraph.TransitionWithSignal to1(enableTimer=true, final waitTime=
       waitTime) "Switch to level 1"
    annotation (Placement(transformation(extent={{2,160},{22,180}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThr(t=0.1, h=0.05)
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Modelica.StateGraph.TransitionWithSignal to2(enableTimer=true, final waitTime=
       waitTime) "Switch to level 1"
    annotation (Placement(transformation(extent={{70,160},{90,180}})));
  Modelica.StateGraph.StepWithSignal lev2(nIn=1, nOut=1) "Demand level 2"
    annotation (Placement(transformation(extent={{100,160},{120,180}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThr1(t=0.98, h=0.95)
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThr(t=0.2, h=0.15)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.StateGraph.TransitionWithSignal from2To3(enableTimer=true, final
      waitTime=waitTime) "Switch to level 2"
    annotation (Placement(transformation(extent={{130,160},{150,180}})));
  Modelica.StateGraph.TransitionWithSignal from2To1(enableTimer=true, waitTime=
        waitTime)                                   "Switch to level 2"
    annotation (Placement(transformation(extent={{30,120},{10,140}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None))
    annotation (Placement(transformation(extent={{0,-26},{20,-6}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt1(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal))
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Controls.OBC.CDL.Integers.Switch intSwi
    annotation (Placement(transformation(extent={{60,-18},{80,2}})));
  Controls.OBC.CDL.Integers.Switch intSwi1
    annotation (Placement(transformation(extent={{118,-10},{138,10}})));
  Controls.OBC.CDL.Integers.Sources.Constant conInt2(k=Integer(Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Elevated))
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThr1(t=0.1, h=0.05)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  parameter Real y1Min=0.6
    "Minimum control signal for stage 1 if demand is elevated";
  Controls.OBC.CDL.Continuous.MultiplyByParameter gai(final k=1/(1 - y1Min))
    "Gain to ensure control range will be up to 1"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
equation
  connect(conPID.u_s, u_s) annotation (Line(points={{-182,0},{-194,0},{-194,80},
          {-220,80}},color={0,0,127}));
  connect(conPID.u_m, u_m) annotation (Line(points={{-170,-12},{-170,-100},{
          -220,-100}},
                 color={0,0,127}));
  connect(isDemLev2.y, swi1.u2) annotation (Line(points={{-38,-80},{100,-80},{
          100,-90},{118,-90}}, color={255,0,255}));
  connect(conPID.y, swi1.u3) annotation (Line(points={{-158,0},{-140,0},{-140,
          -98},{118,-98}},                     color={0,0,127}));
  connect(redLoa.u1, conPID.y) annotation (Line(points={{18,-54},{-140,-54},{
          -140,0},{-158,0}}, color={0,0,127}));
  connect(con.y, redLoa.u2) annotation (Line(points={{-58,-120},{12,-120},{12,
          -66},{18,-66}},
                     color={0,0,127}));
  connect(isDemLev2.y, swi2.u2) annotation (Line(points={{-38,-80},{100,-80},{
          100,-90},{112,-90},{112,-150},{118,-150}}, color={255,0,255}));
  connect(con.y, redLoa1.u2) annotation (Line(points={{-58,-120},{-28,-120},{
          -28,-156},{-22,-156}},
                      color={0,0,127}));
  connect(redLoa1.u1, conPID.y) annotation (Line(points={{-22,-144},{-144,-144},
          {-144,0},{-158,0}}, color={0,0,127}));
  connect(limDemLev2.y, swi2.u1) annotation (Line(points={{82,-150},{110,-150},
          {110,-142},{118,-142}}, color={0,0,127}));
  connect(con1.y, swi2.u3) annotation (Line(points={{2,-180},{112,-180},{112,
          -158},{118,-158}}, color={0,0,127}));
  connect(swi2.y, yDemLev2)
    annotation (Line(points={{142,-150},{180,-150},{180,-120},{220,-120}},
                                                     color={0,0,127}));
  connect(redLoa.y, limDemLev1.u)
    annotation (Line(points={{42,-60},{58,-60}}, color={0,0,127}));
  connect(limDemLev1.y, swi1.u1) annotation (Line(points={{82,-60},{112,-60},{
          112,-82},{118,-82}}, color={0,0,127}));
  connect(swi1.y, yDemLev1)
    annotation (Line(points={{142,-90},{180,-90},{180,-60},{220,-60}},
                                                   color={0,0,127}));
  connect(off.outPort[1], to1.inPort)
    annotation (Line(points={{-9.5,170},{8,170}}, color={0,0,0}));
  connect(lev1.inPort[1], to1.outPort) annotation (Line(points={{29,169.75},{22,
          169.75},{22,170},{13.5,170}}, color={0,0,0}));
  connect(conPID.y, greThr.u) annotation (Line(points={{-158,0},{-140,0},{-140,
          150},{-82,150}},
                      color={0,0,127}));
  connect(greThr.y, to1.condition) annotation (Line(points={{-58,150},{12,150},
          {12,158}},                    color={255,0,255}));
  connect(lev1.outPort[1], to2.inPort) annotation (Line(points={{50.5,169.875},{
          64,169.875},{64,170},{76,170}}, color={0,0,0}));
  connect(lev2.inPort[1], to2.outPort)
    annotation (Line(points={{99,170},{81.5,170}}, color={0,0,0}));
  connect(greThr1.y, to2.condition) annotation (Line(points={{-58,110},{80,110},
          {80,158}},                   color={255,0,255}));
  connect(lev2.outPort[1], from2To3.inPort)
    annotation (Line(points={{120.5,170},{136,170}}, color={0,0,0}));
  connect(lesThr.y, from2To3.condition) annotation (Line(points={{-58,80},{140,
          80},{140,158}},                                     color={255,0,255}));
  connect(from2To3.outPort, lev1.inPort[2]) annotation (Line(points={{141.5,170},
          {160,170},{160,192},{22,192},{22,170},{29,170},{29,170.25}}, color={0,
          0,0}));
  connect(lev1.outPort[2], from2To1.inPort) annotation (Line(points={{50.5,
          170.125},{58,170.125},{58,130},{24,130}},
                                           color={0,0,0}));
  connect(from2To1.outPort, off.inPort[1]) annotation (Line(points={{18.5,130},
          {-40,130},{-40,170},{-31,170}},                  color={0,0,0}));
  connect(lev1.active, intSwi.u2)
    annotation (Line(points={{40,159},{40,-8},{58,-8}}, color={255,0,255}));
  connect(conInt.y, intSwi.u3) annotation (Line(points={{22,-16},{58,-16}},
                    color={255,127,0}));
  connect(conInt1.y, intSwi.u1) annotation (Line(points={{22,20},{50,20},{50,0},
          {58,0}},  color={255,127,0}));
  connect(lev2.active, intSwi1.u2)
    annotation (Line(points={{110,159},{110,0},{116,0}},   color={255,0,255}));
  connect(conInt2.y, intSwi1.u1) annotation (Line(points={{82,30},{100,30},{100,
          8},{116,8}},   color={255,127,0}));
  connect(intSwi1.u3, intSwi.y) annotation (Line(points={{116,-8},{82,-8}},
                         color={255,127,0}));
  connect(intSwi1.y, y) annotation (Line(points={{140,0},{220,0}},
               color={255,127,0}));
  connect(intSwi1.y, isDemLev2.u) annotation (Line(points={{140,0},{150,0},{150,
          -42},{-68,-42},{-68,-80},{-62,-80}},
                                           color={255,127,0}));
  connect(greThr1.u, conPID.y) annotation (Line(points={{-82,110},{-140,110},{
          -140,0},{-158,0}},
                        color={0,0,127}));
  connect(lesThr.u, conPID.y) annotation (Line(points={{-82,80},{-140,80},{-140,
          0},{-158,0}}, color={0,0,127}));
  connect(lesThr1.u, conPID.y) annotation (Line(points={{-82,50},{-140,50},{
          -140,0},{-158,0}},
                        color={0,0,127}));
  connect(from2To1.condition, lesThr1.y)
    annotation (Line(points={{20,118},{20,50},{-58,50}}, color={255,0,255}));
  connect(redLoa1.y, gai.u)
    annotation (Line(points={{2,-150},{18,-150}}, color={0,0,127}));
  connect(gai.y, limDemLev2.u)
    annotation (Line(points={{42,-150},{58,-150}}, color={0,0,127}));
  annotation (
  defaultComponentName="conDemLev",
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
Block that converts a control error into a demand level signal,
and outputs the control signal for the two water and glycol loop.
</p>
<p>
This block uses a PI controller to compute the demand level.
Based on limits of this control output, and delays specified by <code>waitTime</code>,
it switches between the following demand levels:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None\">
Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None</a>: No demand.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None\">
Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Normal</a>:
Normal demand.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.None\">
Buildings.Fluid.Storage.Ice.Examples.BaseClasses.DemandLevels.Elevated</a>:
Elevated demand.
</li>
</ul>
<p>
The output <code>y</code> is used to report the demand level,
and the outputs <code>yDemLev1</code> and <code>yDemLev2</code>
are used to output the control signal for the two levels.
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
