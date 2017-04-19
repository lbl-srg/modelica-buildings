within Buildings.Experimental.OpenBuildingControl.CDL.Discrete;
model FreezeProtectionStage
  "fixme Based on boolean inputs this blocks outputs a freeze protection stage as a Status type output."

  parameter Buildings.Experimental.OpenBuildingControl.CDL.Types.Status[:]
    freProSta={Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage0,
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage1,
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage2,
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage3}
    "Array where each element is a freeze protection stage indicator";

  Interfaces.BooleanInput uStage1OnOff(start=false)
    "Freeze Protection Stage 1 Status"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Interfaces.BooleanInput uStage2OnOff(start=false)
    "Freeze Protection Stage 2 Status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput uStage3OnOff(start=false)
    "Freeze Protection Stage 3 Status"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Interfaces.StatusTypeOutput yFreezeProtectionStage
    "Type of the day for the current and the next (nout-1) days" annotation (
      Placement(transformation(extent={{100,-10},{120,10}}), iconTransformation(
          extent={{100,-10},{120,10}})));

equation
  if uStage3OnOff == true then
    yFreezeProtectionStage =
    Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage3;
  elseif uStage2OnOff == true then
      yFreezeProtectionStage =
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage2;
  elseif uStage1OnOff == true then
      yFreezeProtectionStage =
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage1;
  else
      yFreezeProtectionStage =
      Buildings.Experimental.OpenBuildingControl.CDL.Types.Status.FreezeProtectionStage0;
  end if;
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
          -100},{100,100}}), graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,85,85},
        lineThickness=5,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}),
  defaultComponentName="dayType",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-68,54},{68,-38}},
          lineColor={0,0,255},
          textString="day")}),
    Documentation(info="<html>
<p>
This block outputs a periodic signal that indicates the type of the day.
It can for example be used to generate a signal that indicates whether
the current time is a work day or a non-working day.
The output signal is of type
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Buildings.Experimental.OpenBuildingControl.CDL.Types.Day\">
Buildings.Experimental.OpenBuildingControl.CDL.Types.Day</a>.
</p>
<p>
The parameter <code>nout</code> determines how many days should be
sent to the output. For applications in which only the current day
is of interest, set <code>nout=1</code>.
For applications in which the load is predicted for the next <i>24</i> hours,
set <code>nout=2</code> in order to output the type of day for today and for
tomorrow.
</p>
<p>
The transition from one day type to another always happens when the simulation time
is a multiple of <i>1</i> day. Hence, if the simulation starts for example
at <i>t=-3600</i> seconds, then the first transition to another day will be
at <i>t=0</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2016, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FreezeProtectionStage;
