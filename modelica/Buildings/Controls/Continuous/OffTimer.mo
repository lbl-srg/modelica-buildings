within Buildings.Controls.Continuous;
model OffTimer "Records the time since the input changed to false"
  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;

  Modelica.Blocks.Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(
          extent={{-140,-20},{-100,20}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

  annotation (
    uses(Modelica(version="3.0")),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(graphics={
        Line(points={{-78,16},{-60,30},{-60,-8},{42,82},{42,-8},{72,18}}, color
            ={0,0,255}),
        Polygon(
          points={{92,-78},{70,-70},{70,-86},{92,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,-78},{84,-78}}, color={192,192,192}),
        Line(points={{-78,60},{-78,-88}}, color={192,192,192}),
        Polygon(
          points={{-78,82},{-86,60},{-70,60},{-78,82}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-78,-34},{-58,-34},{-58,-78},{-28,-78},{-28,-34},{40,-34},
              {40,-78},{68,-78}}, color={255,0,255})}),
    Documentation(info="<html>
Block that records the time that has elapsed since its input signal switched to false.
<p>
</p>
At the beginning of the simulation, this block outputs the time that has elapsed since the start of the simulation. Afterwards, whenever its input switches to false, the timer is reset.
</html>", revisions="<html>
<ul>
<li>
February 12, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

protected
  Modelica.Blocks.Logical.Timer timer 
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.StateGraph.InitialStepWithSignal iniSte 
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.StateGraph.TransitionWithSignal transition(enableTimer=false) 
    annotation (Placement(transformation(extent={{-50,60},{-30,80}})));
  Modelica.StateGraph.StepWithSignal staTim(nIn=2) 
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.StateGraph.StepWithSignal stoTim 
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.StateGraph.TransitionWithSignal traToOff 
    annotation (Placement(transformation(extent={{4,-10},{24,10}})));
  Modelica.StateGraph.Transition traToOn(enableTimer=false) "Transition to on" 
    annotation (Placement(transformation(extent={{56,-10},{76,10}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot 
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Logical.Not not1 
    annotation (Placement(transformation(extent={{-70,30},{-50,50}})));
  Modelica.Blocks.Logical.Or or1 
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Logical.FallingEdge fallingEdge 
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
equation
  connect(stoTim.outPort[1], traToOn.inPort)                  annotation (Line(
      points={{50.5,0},{62,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(iniSte.outPort[1], transition.inPort) annotation (Line(
      points={{-69.5,70},{-44,70}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(staTim.outPort[1], traToOff.inPort)                  annotation (Line(
      points={{0.5,0},{10,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(traToOff.outPort, stoTim.inPort[1])                 annotation (Line(
      points={{15.5,0},{29,0}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(transition.outPort, staTim.inPort[1])     annotation (Line(
      points={{-38.5,70},{-30,70},{-30,0.5},{-21,0.5}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(u, not1.u) annotation (Line(
      points={{-120,0},{-98,0},{-98,40},{-72,40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(timer.y, y) annotation (Line(
      points={{81,-60},{92,-60},{92,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(not1.y, transition.condition) annotation (Line(
      points={{-49,40},{-40,40},{-40,58}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(u, fallingEdge.u) annotation (Line(
      points={{-120,0},{-72,0}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(fallingEdge.y, traToOff.condition)              annotation (Line(
      points={{-49,0},{-40,0},{-40,-40},{14,-40},{14,-12}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(iniSte.active, or1.u2) annotation (Line(
      points={{-80,59},{-80,-68},{18,-68}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(staTim.active, or1.u1)     annotation (Line(
      points={{-10,-11},{-10,-60},{18,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(or1.y, timer.u) annotation (Line(
      points={{41,-60},{58,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(traToOn.outPort, staTim.inPort[2]) annotation (Line(
      points={{67.5,0},{80,0},{80,20},{-30,20},{-30,-0.5},{-21,-0.5}},
      color={0,0,0},
      smooth=Smooth.None));
end OffTimer;
