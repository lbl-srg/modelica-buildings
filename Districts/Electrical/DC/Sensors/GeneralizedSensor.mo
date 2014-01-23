within Districts.Electrical.DC.Sensors;
model GeneralizedSensor "Sensor for power, voltage and current"
  extends Districts.Electrical.Interfaces.GeneralizedSensor(
  redeclare final package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor,
  redeclare final Interfaces.Terminal_n terminal_n,
  redeclare final Interfaces.Terminal_p terminal_p);
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
July 24, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GeneralizedSensor;
