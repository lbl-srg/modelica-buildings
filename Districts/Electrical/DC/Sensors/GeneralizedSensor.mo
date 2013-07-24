within Districts.Electrical.DC.Sensors;
model GeneralizedSensor "Sensor for power, voltage and current"
  extends Districts.Electrical.Interfaces.GeneralizedSensor(
  redeclare final package PhaseSystem_n =
        Districts.Electrical.PhaseSystems.TwoConductor);
  annotation (defaultComponentName="sen",
  Documentation(info="<html>
<p>
Ideal sensor that measures power, voltage and current.
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
