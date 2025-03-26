within Buildings.Utilities.IO.Files.Validation;
model WeeklyScheduleWindowsLineEndings "Weekly schedule example"
  extends Modelica.Icons.Example;
  parameter String data = "double tab1(3,5) #test:
mon:0:0:10          -  3   1  -
tue,thu:20:30:59  123  -  45  -
wed                12  1   4  -" "Contents of schedule.txt";
  Buildings.Utilities.IO.Files.WeeklySchedule weeSchLin(
    columns={2,3,4,5},
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/schedule.txt"),
    t_offset=1e6) "Weekly schedule example using file data source"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Utilities.IO.Files.WeeklySchedule weeSchWin(
    columns={2,3,4,5},
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/scheduleWindows.txt"),
    t_offset=1e6) "Weekly schedule example using parameter data source"
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Diagnostics.AssertEquality assEqu[4](
    each startTime=-10000,
    each threShold=Modelica.Constants.small)
    "Trigger an assertion if the outputs differ"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(weeSchLin.y, assEqu.u1)
    annotation (Line(points={{11,30},{24,30},{24,6},{38,6}}, color={0,0,127}));
  connect(weeSchWin.y, assEqu.u2) annotation (Line(points={{11,-22},{24,-22},{24,
          -6},{38,-6}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Example for a weekly schedule that reads the schedule data from a file.
There are two file readers, one reading a file with Windows line endings and the other with Linux line endings.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2024, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1860\">IBPSA, #1860</a>.
</li>
</ul>
</html>"),
    experiment(
      StartTime=-10000,
      StopTime=1000000,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Validation/WeeklyScheduleWindowsLineEndings.mos"
        "Simulate and plot"));
end WeeklyScheduleWindowsLineEndings;
