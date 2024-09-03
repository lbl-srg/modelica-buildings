within Buildings.HeatTransfer.Windows.BaseClasses;
model HeatCapacity
  extends Buildings.BaseClasses.BaseIcon;

  parameter Boolean haveShade
    "Parameter, equal to true if the window has a shade"
    annotation(Evaluate=true);

  parameter Modelica.Units.SI.HeatCapacity C
    "Heat capacity of element (= cp*m)";

  Modelica.Blocks.Interfaces.RealInput ySha
    if haveShade
    "Control signal for shade"
  annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput yCom
  if haveShade
  "Input 1-y"
  annotation (Placement(transformation(
          extent={{-140,-60},{-100,-20}}),
          iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portUns
    "Heat port to unshaded part of the window"
     annotation (
      Placement(transformation(extent={{95,-45},{105,-35}}),
        iconTransformation(extent={{95,-45},{105,-35}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portSha(
    T = TSha,
    Q_flow = QSha_flow)
    if haveShade
    "Heat port to shaded part of the window"
   annotation (Placement(transformation(extent={{95,35},{105,45}}),
        iconTransformation(extent={{95,35},{105,45}})));

  Modelica.Units.SI.Temperature TUns(start=293.15)
    "Temperature of unshaded part of window";

  Modelica.Units.SI.Temperature TSha(start=293.15)
    "Temperature of unshaded part of window";

  Modelica.Units.SI.TemperatureSlope der_TUns(start=0)
    "Time derivative of temperature (= der(T))";

  Modelica.Units.SI.TemperatureSlope der_TSha(start=0)
    "Time derivative of temperature (= der(T))";

protected
  final parameter Real CInv(unit="K/J") = 1/C
    "Inverse of heat capacity";

  Modelica.Blocks.Interfaces.RealInput ySha_internal
    "Internal connector";

  Modelica.Blocks.Interfaces.RealInput yCom_internal
    "Internal connector";

  Modelica.Units.SI.HeatFlowRate QSha_flow
    "Heat flow rate for shaded part of the window";

equation
  connect(ySha, ySha_internal);
  connect(yCom, yCom_internal);
  portUns.T = TUns;

  if haveShade then
    der_TUns = der(TUns);
    der_TSha = der(TSha);

    // Energy balance of window
    yCom_internal * der_TUns = CInv * portUns.Q_flow;
    ySha_internal * der_TSha = CInv * QSha_flow;
  else
    der_TUns = der(TUns);
    der_TSha = 0;

    der_TUns = portUns.Q_flow * CInv;
    TSha = 293.15;
    QSha_flow = 0;

    ySha_internal = 0;
    yCom_internal = 1;
  end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-20,60},{20,-60}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,45},{6,34}},
          lineColor={255,0,0},
          fillColor={191,0,0},
          visible=haveShade,
          fillPattern=FillPattern.Solid),
        Line(points={{0,40},{100,40}},
             visible=haveShade,
             color={255,0,0}),
        Text(
          extent={{-94,64},{-60,22}},
          textColor={0,0,127},
          textString="ySha"),
        Text(
          extent={{-92,-16},{-58,-58}},
          textColor={0,0,127},
          textString="yCom"),
        Ellipse(
          extent={{-6,-35},{6,-46}},
          lineColor={255,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-40},{0,-40}},
             color={255,0,0}),
        Rectangle(
          extent={{-52,76},{-48,4}},
          fillColor={0,0,0},
          visible=haveShade,
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,18},{-70,10},{-30,22},{-30,30},{-70,18}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          visible=haveShade,
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,38},{-70,30},{-30,42},{-30,50},{-70,38}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          visible=haveShade,
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,58},{-70,50},{-30,62},{-30,70},{-70,58}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          visible=haveShade,
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Heat capacitor in which the capacity is scaled based on the input signal <code>u</code>.
</p>
<p>
This model is similar to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.HeatCapacitor\">
Modelica.Thermal.HeatTransfer.Components.HeatCapacitor</a>.
However, it has, depending on the parameterization, either
one or two heat capacities. Depending on the input signal <code>ySha</code>,
the size of one of the capacity is decreased, and the size of the other capacity
is increased.
This model is used to add a state variable on the room-facing surface of a window.
The window implementation in the <code>Buildings</code> library is such that
there are two parts of a window, one for the unshaded part, and one for the
shaded part.
This model allows adding heat capacity to such a window with variable
areas, while conserving energy when one area shrinks and the other expands
accordingly.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatCapacity;
