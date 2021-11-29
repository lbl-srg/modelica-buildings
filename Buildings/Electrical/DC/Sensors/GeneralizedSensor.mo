within Buildings.Electrical.DC.Sensors;
model GeneralizedSensor "Sensor for power, voltage and current"
  extends Buildings.Electrical.Icons.GeneralizedSensor;
  extends Buildings.Electrical.Interfaces.PartialTwoPort(
    redeclare package PhaseSystem_p = PhaseSystems.TwoConductor,
    redeclare package PhaseSystem_n = PhaseSystems.TwoConductor,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  Modelica.Blocks.Interfaces.RealOutput V(final quantity="ElectricPotential",
                                          final unit="V") "Voltage"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput I(final quantity="ElectricCurrent",
                                          final unit="A") "Current"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-90})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W") "Power" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-90})));
equation
  Connections.branch(terminal_p.theta, terminal_n.theta);
  terminal_p.theta = terminal_n.theta;

  V = Buildings.Electrical.PhaseSystems.TwoConductor.systemVoltage(terminal_n.v);
  I = Buildings.Electrical.PhaseSystems.TwoConductor.systemCurrent(terminal_n.i);
  P = Buildings.Electrical.PhaseSystems.TwoConductor.activePower(v=terminal_n.v, i=terminal_n.i);

  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));

  annotation (defaultComponentName="sen",
  Documentation(info="<html>
<p>
Ideal sensor that measures power, voltage and current.
The two components of the power <i>S</i> are the active and reactive power.
As this sensor is configured to measure DC power, the reactive power is always zero.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
March 19, 2015, by Michael Wetter:<br/>
Removed redeclaration of phase system in <code>Terminal_n</code> and
<code>Terminal_p</code> as it is already declared to the be the same
phase system, and it is not declared to be replaceable.
This avoids a translation error in OpenModelica.
</li>
<li>
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Text(
          extent={{-120,-42},{0,-82}},
          textColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="P")}));
end GeneralizedSensor;
