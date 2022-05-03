within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
model BatteryControl "Controller for battery"

  Modelica.Blocks.Interfaces.RealInput SOC "State of charge" annotation (
      Placement(transformation(extent={{-200,-20},{-160,20}}),
        iconTransformation(extent={{-200,-20},{-160,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Power charged or discharged from battery" annotation (Placement(
        transformation(extent={{160,-10},{180,10}}), iconTransformation(
          extent={{160,-10},{180,10}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0.5)
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       0.99)
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Modelica.Blocks.Sources.BooleanExpression isDay(y=mod(time, 86400) > 7*3600
         and mod(time, 86400) <= 19*3600) "Outputs true if it is day time"
    annotation (Placement(transformation(extent={{-152,30},{-132,50}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-80,-54},{-60,-34}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-80,18},{-60,38}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.8)
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        0.01)
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  Modelica.Blocks.Math.MultiSwitch multiSwitch1(
    nu=2,
    expr={200e3,-400e3})
    annotation (Placement(transformation(extent={{104,-10},{120,10}})));
  Modelica.StateGraph.InitialStep off(nIn=1, nOut=1)
                                      "Off state"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Modelica.StateGraph.Alternative alternative(nBranches=2)
    "Splitter for alternative branches"
    annotation (Placement(transformation(extent={{-14,40},{114,140}})));
  Modelica.StateGraph.TransitionWithSignal t1(enableTimer=true, waitTime=1)
    "Transition to charge"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Modelica.StateGraph.TransitionWithSignal t2(enableTimer=true, waitTime=1)
    "Transition to discharge"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Modelica.StateGraph.StepWithSignal charge(nIn=1, nOut=1)
                                            "Charge battery"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Modelica.StateGraph.StepWithSignal discharge(nIn=1, nOut=1)
                                               "Discharge battery"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.StateGraph.TransitionWithSignal t3 "Transition to off"
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
  Modelica.StateGraph.TransitionWithSignal t4 "Transition to off"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
equation

  connect(lessThreshold.u, SOC) annotation (Line(
      points={{-122,-50},{-140,-50},{-140,0},{-180,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterEqualThreshold.u, SOC) annotation (Line(
      points={{-122,-90},{-140,-90},{-140,0},{-180,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(not1.u, isDay.y) annotation (Line(
      points={{-122,-10},{-126,-10},{-126,40},{-131,40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.u1, not1.y) annotation (Line(
      points={{-82,-44},{-92,-44},{-92,-10},{-99,-10}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessThreshold.y, and1.u2) annotation (Line(
      points={{-99,-50},{-90,-50},{-90,-52},{-82,-52}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(isDay.y, and2.u1) annotation (Line(
      points={{-131,40},{-92,40},{-92,28},{-82,28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterThreshold.u, SOC) annotation (Line(
      points={{-122,20},{-140,20},{-140,0},{-180,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold.y, and2.u2) annotation (Line(
      points={{-99,20},{-82,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessEqualThreshold.u, SOC) annotation (Line(
      points={{-122,-120},{-140,-120},{-140,0},{-180,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSwitch1.y, y) annotation (Line(
      points={{120.4,0},{170,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.outPort[1], alternative.inPort)
    annotation (Line(points={{-29.5,90},{-22,90},{-15.92,90}},
                                                        color={0,0,0}));
  connect(t1.outPort, charge.inPort[1])
    annotation (Line(points={{21.5,120},{39,120}}, color={0,0,0}));
  connect(t2.outPort, discharge.inPort[1])
    annotation (Line(points={{21.5,60},{26,60},{39,60}},
                                                 color={0,0,0}));
  connect(charge.outPort[1], t3.inPort)
    annotation (Line(points={{60.5,120},{76,120}}, color={0,0,0}));
  connect(discharge.outPort[1], t4.inPort)
    annotation (Line(points={{60.5,60},{68,60},{76,60}}, color={0,0,0}));
  connect(alternative.outPort, off.inPort[1]) annotation (Line(points={{115.28,
          90},{130,90},{130,150},{-60,150},{-60,90},{-51,90}},color={0,0,0}));
  connect(and1.y, t1.condition) annotation (Line(points={{-59,-44},{10,-44},{10,
          90},{20,90},{20,108}},               color={255,0,255}));
  connect(and2.y, t2.condition) annotation (Line(points={{-59,28},{-36,28},{-20,
          28},{20,28},{20,48}},          color={255,0,255}));
  connect(greaterEqualThreshold.y, t3.condition) annotation (Line(points={{-99,-90},
          {-99,-90},{70,-90},{70,92},{80,92},{80,108}},   color={255,0,255}));
  connect(lessEqualThreshold.y, t4.condition)
    annotation (Line(points={{-99,-120},{80,-120},{80,48}},
                                                          color={255,0,255}));
  connect(t1.inPort, alternative.split[1])
    annotation (Line(points={{16,120},{8,120},{8,115},{-0.56,115}},
                                                    color={0,0,0}));
  connect(t2.inPort, alternative.split[2])
    annotation (Line(points={{16,60},{8,60},{8,65},{-0.56,65}},
                                                  color={0,0,0}));
  connect(t3.outPort, alternative.join[1])
    annotation (Line(points={{81.5,120},{92,120},{92,115},{100.56,115}},
                                                       color={0,0,0}));
  connect(t4.outPort, alternative.join[2])
    annotation (Line(points={{81.5,60},{92,60},{92,65},{100.56,65}},
                                                     color={0,0,0}));
  connect(charge.active, multiSwitch1.u[1]) annotation (Line(
      points={{50,109},{50,92},{64,92},{64,1.5},{104,1.5}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(discharge.active, multiSwitch1.u[2]) annotation (Line(
      points={{50,49},{50,49},{50,-4},{104,-4},{104,-1.5}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  annotation ( Documentation(info="<html>
<p>
Block for a battery controller. The battery is charged during night if its charge is below
a threshold. It remains charging until it is full.
During day, it discharges provided that its charge is above a threshold. It remains
discharging until it is empty.
</p>
</html>",
        revisions="<html>
<ul>
<li>
November 17, 2016, by Michael Wetter:<br/>
Removed output of instance <code>off</code> to avoid
an overdetermined system of equations during initialization.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/578\">issue 578</a>.
</li>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
January 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-160},{160,160}}),
                    graphics={     Rectangle(
          extent={{-160,-160},{160,162}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-78,64},{-12,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,42},{-104,54},{-104,32},{-80,42}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-104,44},{-136,44}},
          color={0,0,0},
          smooth=Smooth.None),            Text(
          extent={{-150,204},{150,164}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{36,62},{102,18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{14,42},{-12,42}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{34,-6},{100,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{10,-26},{-50,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-50,20},{-50,-26}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{36,42},{12,54},{12,32},{36,42}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,-28},{10,-16},{10,-38},{34,-28}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end BatteryControl;
