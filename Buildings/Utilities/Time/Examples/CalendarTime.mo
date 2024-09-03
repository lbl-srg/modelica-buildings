within Buildings.Utilities.Time.Examples;
model CalendarTime "Example for the calendar time model"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Time.CalendarTime calendarTime2016(
    zerTim=Buildings.Utilities.Time.Types.ZeroTime.NY2016)
    "Computes date and time assuming time=0 corresponds to new year 2016"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));

equation

  annotation (    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Time/Examples/CalendarTime.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
    <ul>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the use of the
<a href=\"modelica://Buildings.Utilities.Time.CalendarTime\">
Buildings.Utilities.Time.CalendarTime</a>
block.
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=1e+08));
end CalendarTime;
