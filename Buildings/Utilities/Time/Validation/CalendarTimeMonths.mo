within Buildings.Utilities.Time.Validation;
model CalendarTimeMonths "Validation model for the calendar time model"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.CalendarTime calTim(zerTim=Buildings.Utilities.Time.Types.ZeroTime.NY2015)
    "Computes date and time assuming time=0 corresponds to new year 2015"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation

  annotation (
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Time/Validation/CalendarTimeMonths.mos"
        "Simulate and plot"),
  Documentation(
    info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Utilities.Time.CalendarTime\">
Buildings.Utilities.Time.CalendarTime</a>
block for a period of a couple of months.
This shorter simulation time has been selected to
store the reference results that are used in the regression tests
at a resulation that makes sense for the minute and hour outputs.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StartTime=172800, Tolerance=1e-6, StopTime=345600));
end CalendarTimeMonths;
