within Buildings.Electrical.AC.OnePhase.Sensors;
model GeneralizedSensor "Sensor for power, voltage and current"
  extends Buildings.Electrical.Icons.GeneralizedSensor;
  extends Buildings.Electrical.Interfaces.PartialTwoPort(
    redeclare package PhaseSystem_p = PhaseSystems.OnePhase,
    redeclare package PhaseSystem_n = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_n terminal_n,
    redeclare Interfaces.Terminal_p terminal_p);
  Modelica.Blocks.Interfaces.RealOutput V(final quantity="ElectricPotential",
                                          final unit="V")=
      Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(terminal_n.v)
    "Voltage"
      annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50}),   iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput I(final quantity="ElectricCurrent",
                                          final unit="A")=
    Buildings.Electrical.PhaseSystems.OnePhase.systemCurrent(terminal_n.i)
    "Current"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-90})));
  Modelica.Blocks.Interfaces.RealOutput S[PhaseSystems.OnePhase.n](
                                          each final quantity="Power",
                                          each final unit="W")=
     Buildings.Electrical.PhaseSystems.OnePhase.phasePowers_vi(v=terminal_n.v, i=terminal_n.i)
    "Phase powers"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-50}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-60,-90})));
equation
  connect(terminal_n, terminal_p) annotation (Line(
      points={{-100,0},{2,0},{2,0},{100,0}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (defaultComponentName="sen",
  Documentation(info="<html>
<p>
Ideal sensor that measures power, voltage and current.
The two components of the power <i>S</i> are the active and reactive power.
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Fixed bug. The model was referencing the wrong PhaseSystem.
</li>
<li>September 4, 2014, by Michael Wetter:<br/>
Revised model, changed <code>equation</code> section to
avoid mixing graphical and textual modeling.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
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
          textString="S")}));
end GeneralizedSensor;
