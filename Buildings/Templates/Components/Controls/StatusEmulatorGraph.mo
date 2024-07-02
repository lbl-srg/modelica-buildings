within Buildings.Templates.Components.Controls;
block StatusEmulatorGraph
  "Block that emulates the status of an equipment"
  parameter Real delayTime(
    final quantity="Time",
    final unit="s")=2
    "Delay time";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1 "Equipment run command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual
    "Equipment status" annotation (Placement(transformation(extent={{100,-20},{140,
            20}}), iconTransformation(extent={{100,-20},{140,20}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.StateGraph.InitialStepWithSignal off(nOut=1, nIn=1)
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal(enableTimer=true,
      waitTime=delayTime)
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Modelica.StateGraph.StepWithSignal on(nIn=1, nOut=1)
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.StateGraph.TransitionWithSignal transitionWithSignal1(enableTimer=true,
      waitTime=delayTime)
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notY1
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
equation

  connect(off.outPort[1], transitionWithSignal.inPort)
    annotation (Line(points={{-49.5,40},{-24,40}}, color={0,0,0}));
  connect(y1, transitionWithSignal.condition)
    annotation (Line(points={{-120,0},{-20,0},{-20,28}}, color={255,0,255}));
  connect(transitionWithSignal.outPort, on.inPort[1])
    annotation (Line(points={{-18.5,40},{9,40}}, color={0,0,0}));
  connect(on.outPort[1], transitionWithSignal1.inPort)
    annotation (Line(points={{30.5,40},{56,40}}, color={0,0,0}));
  connect(transitionWithSignal1.outPort, off.inPort[1]) annotation (Line(points
        ={{61.5,40},{80,40},{80,60},{-80,60},{-80,40},{-71,40}}, color={0,0,0}));
  connect(y1, notY1.u) annotation (Line(points={{-120,0},{-20,0},{-20,-40},{8,-40}},
        color={255,0,255}));
  connect(notY1.y, transitionWithSignal1.condition)
    annotation (Line(points={{32,-40},{60,-40},{60,28}}, color={255,0,255}));
  connect(on.active, y1_actual)
    annotation (Line(points={{20,29},{20,0},{120,0}}, color={255,0,255}));
  annotation (
  defaultComponentName="sta",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>
This block emulates the status of an equipment, i.e.,
the current on/off state as reported by the hardware itself.
</p>
<p>
The implementation is based on
<a href=\"modelica://Buildings.Fluid.BaseClasses.ActuatorFilter\">
Buildings.Fluid.BaseClasses.ActuatorFilter</a>
and the model is configured with <code>yLim=0.5</code> so that
the delay between the on command and the on status is
equal to the delay between the off command and the off status
(about <i>2</i>&nbsp;s with the default parameter settings).
Note that this delay may not be representative of the actual
dynamics of certain equipment such as chillers or heat pumps.
In addition, this block uses the equipment command signal to
generate the status signal, which in turn can lead to inconsistencies
with certain equipment that run cyclically at low load and
where the status then comes and goes.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StatusEmulatorGraph;
