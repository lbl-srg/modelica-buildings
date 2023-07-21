within Buildings.Utilities.IO.Files.Examples;
model WeeklySchedule7to19
  "Weekly schedule example that outputs 1 from 7:00 to 19:00 on week-days, and 0 otherwise"
  extends Modelica.Icons.Example;

  Buildings.Utilities.IO.Files.WeeklySchedule sch
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
    Documentation(
    info="<html>
<p>
Example of a weekly schedule that outputs 1 from 7:00 to 19:00 on week-days, and 0 otherwise</p>
</html>"),
    experiment(
      StartTime=0,
      StopTime=1209600,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/WeeklySchedule7to19.mos"
        "Simulate and plot"));
end WeeklySchedule7to19;
