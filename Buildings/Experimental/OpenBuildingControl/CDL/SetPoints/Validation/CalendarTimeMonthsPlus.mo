within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation;
model CalendarTimeMonthsPlus
  "Validation model for the calendar time model with start time slightly higher than the full hour"
  extends Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation.CalendarTimeMonths;
  annotation (experiment(StartTime=172801, Tolerance=1e-6, StopTime=345601),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/SetPoints/Validation/CalendarTimeMonthsPlus.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.CalendarTime\">
Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.CalendarTime</a>.
It is identical to
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation.CalendarTimeMonths\">
Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation.CalendarTimeMonths</a>
except that the start and end time are different.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
</li>
</ul>
</html>"));
end CalendarTimeMonthsPlus;
