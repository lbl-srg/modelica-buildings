within Buildings.ThermalZones.ReducedOrder.RC.BaseClasses;
model ThermSplitter "A simple model which weights a given set of thermal inputs
  to calculate an average temperature and aggregated heat flow per output"

  parameter Integer nOut "Number of splitter outputs";
  parameter Integer nIn "Number of splitter inputs";
  parameter Real splitFactor[nOut, nIn]= fill(1/nOut, nOut, nIn)
    "Matrix of split factor for outputs (between 0 and 1 for each row)";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portIn[nIn]
    "Single thermal input"
    annotation (Placement(transformation(extent={{-120,-20},{-80,20}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portOut[nOut]
    "Set of thermal outputs" annotation (Placement(transformation(extent={{80,-20},
            {120,20}}), iconTransformation(extent={{80,-20},{120,20}})));

equation
  portOut.Q_flow = - portIn.Q_flow * transpose(splitFactor)
    "Connecting the output vector according to desired dimension";

  portIn.T = portOut.T * splitFactor
    "Equivalent building temperature rerouted to SignalInput";

  annotation (defaultComponentName="theSpl",  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}}), graphics={
  Text(
    extent={{-2,4},{26,-30}},
    textColor={255,0,0},
    textString="%",
    textStyle={TextStyle.Bold}),
  Line(
    points={{-80,0},{14,80},{14,80}},
    color={191,0,0}),
  Line(
    points={{-80,0},{18,48},{18,48}},
    color={191,0,0}),
  Line(
    points={{-80,0},{16,18},{16,18}},
    color={191,0,0}),
  Line(
    points={{-80,0},{12,-78},{12,-78}},
    color={191,0,0}),
  Line(
    points={{-80,0},{12,-46},{12,-46}},
    color={191,0,0}),
  Line(
    points={{-80,0},{12,-18},{12,-18}},
    color={191,0,0}),
  Text(
    extent={{-48,-82},{52,-100}},
    textColor={0,0,255},
    textString="ThermSplitter")}),
  Documentation(info="<html>
  <p>This model is used to weight thermal ports (inputs) according to given split
  factors per output port.</p>
  <p>The model needs the dimensions of the splitted therm ports (for input and
  output ports resp.) and the split factors, which are between 0 and 1. Each row
  of the split factor matrix gives the split factors for one output
  port. The number of columns need to align with the number of input ports.</p>
  </html>", revisions="<html>
  <ul>
  <li>
  May, 2016, by Moritz Lauster:<br/>
  Extended to handle multiple input ports.
  </li>
  <li>
  January, 2015, by Peter Remmen:<br/>
  Changed name and vectorized
  equation, added documentation
  </li>
  <li>
  October, 2014, by Peter Remmen:<br/>
  Implemented.
  </li>
  </ul>
  </html>"));
end ThermSplitter;
