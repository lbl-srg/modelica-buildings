within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
model BatteryControl "Controller for battery"
 extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput SOC "State of charge" annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y
    "Power charged or discharged from battery" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  Modelica_StateGraph2.Step off(initialStep=true, nOut=2,
    nIn=2,
    use_activePort=true) "Battery is disconnected"
    annotation (Placement(transformation(extent={{28,28},{36,36}})));
  Modelica_StateGraph2.Transition T1(
    use_conditionPort=true,
    delayedTransition=true,
    waitTime=1)
    annotation (Placement(transformation(extent={{16,-4},{24,4}})));
  Modelica_StateGraph2.Step charge(
    nOut=1,
    initialStep=false,
    use_activePort=true,
    nIn=1) "Battery is being charged"
    annotation (Placement(transformation(extent={{16,-34},{24,-26}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=0.5)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold=
       0.99)
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica_StateGraph2.Transition T3(use_conditionPort=true, use_firePort=
        false)
    annotation (Placement(transformation(extent={{16,-64},{24,-56}})));
  Modelica.Blocks.Sources.BooleanExpression isDay(y=mod(time, 86400) > 7*3600
         and mod(time, 86400) <= 19*3600) "Outputs true if it is day time"
    annotation (Placement(transformation(extent={{-92,60},{-72,80}})));
  Modelica_StateGraph2.Step discharge(
    nOut=1,
    initialStep=false,
    use_activePort=true,
    nIn=1) "Battery is being discharged"
    annotation (Placement(transformation(extent={{46,-34},{54,-26}})));
  Modelica.Blocks.Logical.Not not1
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Logical.And and1
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica_StateGraph2.Transition T2(
    use_conditionPort=true,
    delayedTransition=true,
    waitTime=1)
    annotation (Placement(transformation(extent={{46,-4},{54,4}})));
  Modelica.Blocks.Logical.And and2
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=0.8)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold(threshold=
        0.01)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica_StateGraph2.Transition T4(use_conditionPort=true, use_firePort=
        false)
    annotation (Placement(transformation(extent={{46,-64},{54,-56}})));
  Modelica.Blocks.Math.MultiSwitch multiSwitch1(nu=3, expr={0,200e3,-400e3})
    annotation (Placement(transformation(extent={{80,-10},{96,10}})));
equation

  connect(lessThreshold.u, SOC) annotation (Line(
      points={{-62,-20},{-80,-20},{-80,8.88178e-16},{-120,8.88178e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterEqualThreshold.y, T3.conditionPort) annotation (Line(
      points={{-39,-60},{15,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterEqualThreshold.u, SOC) annotation (Line(
      points={{-62,-60},{-80,-60},{-80,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(charge.outPort[1], T3.inPort) annotation (Line(
      points={{20,-34.6},{20,-56}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(not1.u, isDay.y) annotation (Line(
      points={{-62,20},{-66,20},{-66,70},{-71,70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.u1, not1.y) annotation (Line(
      points={{-22,0},{-28,0},{-28,0},{-32,0},{-32,20},{-39,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessThreshold.y, and1.u2) annotation (Line(
      points={{-39,-20},{-32,-20},{-32,-8},{-22,-8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, T1.conditionPort) annotation (Line(
      points={{1,0},{15,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(charge.inPort[1], T1.outPort) annotation (Line(
      points={{20,-26},{20,-5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, discharge.inPort[1]) annotation (Line(
      points={{50,-5},{50,-26}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(isDay.y, and2.u1) annotation (Line(
      points={{-71,70},{-22,70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greaterThreshold.u, SOC) annotation (Line(
      points={{-62,50},{-80,50},{-80,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(greaterThreshold.y, and2.u2) annotation (Line(
      points={{-39,50},{-30,50},{-30,62},{-22,62}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and2.y, T2.conditionPort) annotation (Line(
      points={{1,70},{10,70},{10,14},{40,14},{40,0},{45,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lessEqualThreshold.u, SOC) annotation (Line(
      points={{-62,-90},{-80,-90},{-80,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lessEqualThreshold.y, T4.conditionPort) annotation (Line(
      points={{-39,-90},{40,-90},{40,-60},{45,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(discharge.outPort[1], T4.inPort) annotation (Line(
      points={{50,-34.6},{50,-56}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T3.outPort, off.inPort[1]) annotation (Line(
      points={{20,-65},{20,-80},{70,-80},{70,48},{32,48},{32,36},{31,36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T4.outPort, off.inPort[2]) annotation (Line(
      points={{50,-65},{50,-80},{70,-80},{70,48},{32,48},{32,36},{33,36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(off.outPort[1], T1.inPort) annotation (Line(
      points={{31,27.4},{31,20},{20,20},{20,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(off.outPort[2], T2.inPort) annotation (Line(
      points={{33,27.4},{33,20},{50,20},{50,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(off.activePort, multiSwitch1.u[1]) annotation (Line(
      points={{36.72,32},{74,32},{74,2},{80,2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(charge.activePort, multiSwitch1.u[2]) annotation (Line(
      points={{24.72,-30},{40,-30},{40,-12},{72,-12},{72,4.44089e-16},{80,
          4.44089e-16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(discharge.activePort, multiSwitch1.u[3]) annotation (Line(
      points={{54.72,-30},{74,-30},{74,-2},{80,-2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{110,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiSwitch1.y, y) annotation (Line(
      points={{96.4,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
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
January 11, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-74,56},{-8,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,56},{86,12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,32},{10,40},{10,24},{20,32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-74,34},{-84,42},{-84,26},{-74,34}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,-8},{86,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-30},{10,-22},{10,-38},{20,-30}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,32},{12,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,-32},{2,-32},{2,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-78,34},{-96,34}},
          color={0,0,0},
          smooth=Smooth.None)}));
end BatteryControl;
