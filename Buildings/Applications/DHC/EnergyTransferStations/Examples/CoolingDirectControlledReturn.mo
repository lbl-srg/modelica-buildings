within Buildings.Applications.DHC.EnergyTransferStations.Examples;
model CoolingDirectControlledReturn
  "Example model for direct cooling energy transfer station with in-building pump and controlled district return temperature"
  extends Modelica.Icons.Example;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Examples/CoolingDirect.mos"
    "Simulate and plot"),
  experiment(
    StartTime=0,
    StopTime=86400,
    Tolerance=1e-03),
    Documentation(info="<html>
<p>This model provides an example for the direct cooling energy transfer station model, which
contains in-building pumping and controls the district return temperature. The control valve is 
modulated proportionally to the instantaneous cooling load with respect to the maxiumum load.
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
