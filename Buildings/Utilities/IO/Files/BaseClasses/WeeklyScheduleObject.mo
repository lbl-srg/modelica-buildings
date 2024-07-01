within Buildings.Utilities.IO.Files.BaseClasses;
class WeeklyScheduleObject "Class that loads a weekly schedule"
extends ExternalObject;
  impure function constructor
    "Creates an object for the weekly schedule"
    extends Modelica.Icons.Function;
    input Boolean tableOnFile "Table is on file";
    input String sourceName "Data source";
    input Real t_offset "When time=t_offset, the time is assumed to be monday at midnight";
    input String data "Data, when tableOnFile=false";
    output WeeklyScheduleObject weeklySchedule "Pointer to the weekly schedule";
    external"C" weeklySchedule = weeklyScheduleInit(tableOnFile, sourceName, t_offset, data)
    annotation (
      Include="#include <WeeklySchedule.c>",
      IncludeDirectory="modelica://Buildings/Resources/C-Sources");

    annotation(Documentation(info="<html>
<p>
Object for storing weekly schedules.
</p>
</html>", revisions="<html>
<ul>
 <li>
 March 9 2022, by Filip Jorissen:<br/>
 First implementation.
 </li>
 </ul>
</html>"));
  end constructor;

  pure function destructor "Release storage and close the external object, write data if needed"
    input WeeklyScheduleObject weeklySchedule "Pointer to file writer object";
    external "C" weeklyScheduleFree(weeklySchedule)
    annotation(Include=" #include <WeeklyScheduleFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor for weekly schedule object.
</p>
</html>"));
  end destructor;

annotation(Documentation(info="<html>
<p>
Class definition for weekly schedule object used by
<a href=\"modelica://Buildings.Utilities.IO.Files.WeeklySchedule\">
Buildings.Utilities.IO.Files.WeeklySchedule</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 10 2022, by Filip Jorissen:<br/>
Added parameter source implementation.
</li>
<li>
March 9 2022, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeeklyScheduleObject;
