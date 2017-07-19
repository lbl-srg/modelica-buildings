within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.Validation;
model CalendarTimeMonths
  "Validation model for the calendar time model"
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.CalendarTime calTim(
    zerTim=Buildings.Experimental.OpenBuildingControl.CDL.Types.ZeroTime.NY2017)
    "Computes date and time assuming time=0 corresponds to new year 2017"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  annotation (experiment(StartTime=172800, Tolerance=1e-6, StopTime=345600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/SetPoints/Validation/CalendarTimeMonths.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.CalendarTime\">
Buildings.Experimental.OpenBuildingControl.CDL.SetPoints.CalendarTime</a>
block for a period of a couple of months.
This shorter simulation time has been selected to
store the reference results that are used in the regression tests
at a resulation that makes sense for the minute and hour outputs.
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
end CalendarTimeMonths;
