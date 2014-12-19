within Buildings.Electrical.Utilities;
model VoltageControl "Voltage controller"
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Voltage V_nominal
    "Nominal voltage of the node to be controlled";
  parameter Real vThresh(min=0.0, max=1.0) = 0.1
    "Threshold that activates voltage ctrl (ratio of nominal voltage)";
  parameter Modelica.SIunits.Time tDelay = 300
    "Time to wait before plugging the load back";
  final parameter Modelica.SIunits.Voltage Vmin = V_nominal*(1-vThresh)
    "Low threshold";
  final parameter Modelica.SIunits.Voltage Vmax = V_nominal*(1+vThresh)
    "High threshold";
  Modelica.Blocks.Interfaces.RealOutput y "Control signal"
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
equation

  // Output of the control block
  ctrl.y = y;

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
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Voltage
CTRL"),                                   Text(
          extent={{-100,72},{100,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="%name")}), Documentation(revisions="<html>
<ul>
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
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end VoltageControl;
