within Buildings.Electrical.Utilities;
model VoltageControl "Voltage controller"
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Modelica.Units.SI.Voltage V_nominal
    "Nominal voltage of the node to be controlled";
  parameter Real vThresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)";
  parameter Modelica.Units.SI.Time tDelay=300
    "Time to wait before plugging the load back";
  parameter Modelica.Units.SI.Time T=0.01
    "Time constant representing the switching time";
  parameter Real y_start = 1.0 "Initial value of the control output signal";
  final parameter Modelica.Units.SI.Voltage Vmin=V_nominal*(1 - vThresh)
    "Low threshold";
  final parameter Modelica.Units.SI.Voltage Vmax=V_nominal*(1 + vThresh)
    "High threshold";
  Modelica.Blocks.Interfaces.RealOutput y(start = y_start, stateSelect = StateSelect.prefer)
    "Control signal"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(
    redeclare replaceable package PhaseSystem = PhaseSystem)
    "Generalized terminal"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Buildings.Electrical.Utilities.Controllers.StateMachineVoltCtrl ctrl(
    V_nominal=V_nominal,
    vThresh=vThresh,
    tDelay=tDelay)
    "Model that implements the state machines voltage controller";
initial equation
  y = y_start;
equation

  // Output of the control block
  y + T*der(y) = ctrl.y;

  // Voltage measurements
  ctrl.V = terminal.PhaseSystem.systemVoltage(terminal.v);

  // The controller does not consume current
  terminal.i = zeros(PhaseSystem.n);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-100,-40},{100,-80}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Voltage
CTRL"),                                   Text(
          extent={{-100,72},{100,40}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}), Documentation(revisions="<html>
<ul>
<li>
March 10, 2014, by Marco Bonvini:<br/>
Added time constant <code>T</code> and first order filer to avoid
differentiation of the outputs of the finite state machine.
</li>
<li>
Oct 14, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
Aug 28, 2014, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>", info="<html>
<p>
Model representing a voltage controller that unplugs a load when
its voltage is outside of the accepted thresholds.
</p>
<p>
The model contains a finite state machine controller that detects voltage
deviations. If the voltage input <code>V</code> exceeds the
nominal value <code>V_nominal</code> by more than <i>1+V<sub>tr</sub></i>
then the control signal <code>y</code> becomes zero for
a period <code>t = tDelay</code>. If after this period the voltage is still
higher than the thresholds the output remains equal to zero.
The model has a parameter <code>T</code> that represents the time constant
associated to the electrical switch. This time constant is used to parametrize
a first order filter that represents such a dynamic effect. The presence of the first order
filter avoids that the output of the finite state machine controller
are differentiated (causing runtime errors).
</p>
</html>"));
end VoltageControl;
