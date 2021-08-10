within Buildings.Fluid.BaseClasses;
block ActuatorFilter
  "Filter used for actuators of valves, dampers and movers"
  import Modelica.Blocks.Types.Init;
  extends Modelica.Blocks.Interfaces.SISO;

  constant Integer n=2 "Order of filter";
  parameter Modelica.SIunits.Frequency f(start=1) "Cut-off frequency";
  parameter Boolean normalized = true
    "= true, if amplitude at f_cut is 3 dB, otherwise unmodified filter";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.NoInit
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (
      Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real x_start[n]=zeros(n) "Initial or guess values of states"
    annotation (Dialog(group="Initialization"));
  parameter Real y_start=0.0
    "Initial value of output (remaining states are in steady state)"
    annotation(Dialog(enable=initType == Init.InitialOutput, group=
          "Initialization"));

  parameter Real u_nominal = 1 "Magnitude of input";

  Real x[n](each final stateSelect=StateSelect.never) = u_nom*s
    "Transformed filter states";


protected
  final parameter Real u_nom = if abs(u_nominal-1) < 1E-12 then 1-1E-12 else u_nominal
    "Magnitude of input (set to a value different from 1 to avoid elimination by symbolic processing)";

  parameter Real alpha=if normalized then sqrt(2^(1/n) - 1) else 1.0
    "Frequency correction factor for normalized filter";
  parameter Real w_u=2*Modelica.Constants.pi*f/alpha/u_nom;

  Real s[n](start=x_start/u_nom) "Filter states";

initial equation
  if initType == Init.SteadyState then
    der(s) = zeros(n);
  elseif initType == Init.InitialState then
    s = x_start/u_nom;
  elseif initType == Init.InitialOutput then
    y = y_start;
    der(s[1:n - 1]) = zeros(n - 1);
  end if;

equation
  der(s[1]) = (u - u_nom*s[1])*w_u;
  for i in 2:n loop
    der(s[i]) = (u_nom*s[i - 1] - u_nom*s[i])*w_u;
  end for;
  y =u_nom*s[n];

  annotation (
    defaultComponentName="act",
    Icon(
        coordinateSystem(preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}}),
          graphics={
        Line(points={{-80.6897,77.6256},{-80.6897,-90.3744}},
          color={192,192,192}),
        Polygon(lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-79.7044,90.6305},{-87.7044,68.6305},{-71.7044,68.6305},{-79.7044,90.6305}}),
        Line(points={{-90.0,-80.0},{82.0,-80.0}},
          color={192,192,192}),
        Polygon(lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
        Line(origin = {-17.976,-6.521},
          points = {{96.962,55.158},{16.42,50.489},{-18.988,18.583},{-32.024,-53.479},{-62.024,-73.479}},
          color = {0,0,127},
          smooth = Smooth.Bezier),
        Text(lineColor={192,192,192},
          extent={{-70.0,48.0},{26.0,94.0}},
          textString="%n"),
        Text(extent={{8.0,-146.0},{8.0,-106.0}},
          textString="f=%f")}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>
This block implements a filter that is used to approximate the actuators
of valves, dampers and fans.
</p>
<h4>Implementation</h4>
<p>
The implementation is based on
<a href=\"modelica://Modelica.Blocks.Continuous.CriticalDamping\">
Modelica.Blocks.Continuous.CriticalDamping</a>.
It differs from that model in that the internal state of the filter <code>s</code>
is transformed using <code>x = u_nominal*s</code>.
It turns out that this transformation leads to smaller system of nonlinear equations if <code>u_nominal &ne; 0</code>, see
<a href=\"https://https://github.com/ibpsa/modelica-ibpsa/issues/1498#issuecomment-885020611\">IBPSA, #1498</a>
for a discussion.
</html>", revisions="<html>
<ul>
<li>
July 22, 2021, by Michael Wetter:<br/>
First implementation for
<a href=\"https://https://github.com/ibpsa/modelica-ibpsa/issues/1498\">IBPSA, #1498</a>
</li>
</ul>
</html>"));
end ActuatorFilter;
