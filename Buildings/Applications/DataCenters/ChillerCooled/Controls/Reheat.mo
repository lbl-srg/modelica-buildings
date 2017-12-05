within Buildings.Applications.DataCenters.ChillerCooled.Controls;
model Reheat "Model that implements an on and off controller for a reheater"

  parameter Real yValSwi(min=0, max=1, unit="1")
    "Switch point for valve signal";
  parameter Real yValDeaBan(min=0, max=1, unit="1")
    "Deadband for valve signal";
  parameter Modelica.SIunits.TemperatureDifference dTSwi
    "Switch point for temperature difference";
  parameter Modelica.SIunits.TemperatureDifference dTDeaBan
    "Deadband for temperature difference";
  parameter Modelica.SIunits.Time tWai
    "Waiting time";

  Modelica.Blocks.Interfaces.RealInput yVal(
    min=0,
    max=1,
    unit="1") "Valve position"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
                iconTransformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput dT(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Temperature difference"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
               iconTransformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "On and off signal for the reheater"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.StateGraph.InitialStepWithSignal off "Off"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-50,30})));
  Modelica.StateGraph.StepWithSignal on "On"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={50,30})));
  Modelica.StateGraph.Transition offToOn(
    enableTimer=true,
    waitTime=tWai,
    condition=yVal <= yValSwi - yValDeaBan and dT < dTSwi - dTDeaBan)
    "Conditions that switch off to on"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.StateGraph.Transition onToOff(
    condition=yVal > yValSwi+yValDeaBan or dT > dTSwi+dTDeaBan,
    enableTimer=true,
    waitTime=tWai)
    "Conditions that switch on to off"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(off.outPort[1], offToOn.inPort)
    annotation (Line(points={{-39.5,30},{-4,30}},
                                 color={0,0,0}));
  connect(offToOn.outPort, on.inPort[1])
    annotation (Line(points={{1.5,30},{39,30}},
                            color={0,0,0}));
  connect(on.outPort[1], onToOff.inPort)
    annotation (Line(points={{60.5,30},{80,30},{80,-20},{4,-20}},
                color={0,0,0}));
  connect(onToOff.outPort, off.inPort[1])
    annotation (Line(points={{-1.5,-20},{-80,-20},{-80,30},{-61,30}},
               color={0,0,0}));
  connect(on.active, y)
    annotation (Line(points={{50,19},{50,19},{50,0},{110,0}},
        color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised), Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-12,-64},{-12,60}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-12,60},{68,60}},
          color={0,0,127},
          thickness=0.5),
        Line(
          points={{-74,-64},{14,-64},{14,60}},
          color={0,0,127},
          thickness=0.5)}),
    Documentation(info="<html>
<p>This model can be used to generate on/off signal for the reheater inside the AHU.</p>
<p>This reheater will be on only if the following two conditions are satisfied at the same time:</p>
<ul>
<li>The position of the water-side valve reaches its switch point, <code>yValSwi</code>;</li>
<li>The difference between the inlet temperature of the reheater and the required outlet temperature setpoint
is lower than its critical switch point,<code>dTSwi</code>.
</li>
</ul>
<p>
In addition, a deadband and waiting time is used to avoid frequent switching.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Reheat;
