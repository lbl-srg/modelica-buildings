within Buildings.Utilities.IO.Files.Examples;
model WeeklySchedule "Weekly schedule example"
  extends Modelica.Icons.Example;
  parameter String data = "double tab1(3,5) #test:
mon:0:0:10          -  3   1  -
tue,thu:20:30:59  123  -  45  -
wed                12  1   4  -" "Contents of schedule.txt";
  Buildings.Utilities.IO.Files.WeeklySchedule weeSchFil(
    columns={2,3,4,5},
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/schedule.txt"),
    t_offset=1e6) "Weekly schedule example using file data source"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Utilities.IO.Files.WeeklySchedule weeSchStri(
    columns={2,3,4,5},
    data=data,
    t_offset=1e6) "Weekly schedule example using parameter data source"
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Diagnostics.AssertEquality assEqu[4](
    each startTime=-10000,
    each threShold=Modelica.Constants.small)
    "Trigger an assertion if the outputs differ"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(weeSchFil.y, assEqu.u1)
    annotation (Line(points={{11,30},{24,30},{24,6},{38,6}}, color={0,0,127}));
  connect(weeSchStri.y, assEqu.u2) annotation (Line(points={{11,-22},{24,-22},{24,
          -6},{38,-6}}, color={0,0,127}));
  annotation (
    Documentation(revisions="<html>
<ul>
<li>
April 10 2022, by Filip Jorissen:<br/>
Added parameter source implementation.
</li>
<li>
March 21 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example and consistency test for a weekly schedule.
</p>
</html>"),
    experiment(
      StartTime=-10000,
      StopTime=1000000,
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/Files/Examples/WeeklySchedule.mos"
        "Simulate and plot"));
end WeeklySchedule;
