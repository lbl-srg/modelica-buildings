within Buildings.Experimental.OpenBuildingControl.CDL.Types;
type Status = enumeration(
    FreezeProtectionStage0 "None of the Freeze Protection Stages is activated. Default value.",
    FreezeProtectionStage1 "Freeze Protection Stage 1 is activated.",
    FreezeProtectionStage2 "Freeze Protection Stage 2 is activated.",
    FreezeProtectionStage3 "Freeze Protection Stage 3 is activated.")
  "fixme This in an enumeration type used to describe G36 categories such as State Zone, AHU Mode, Freeze Protection Stage, etc."
                                                                   annotation (
    Documentation(info =     "<html>
<p>
Enumeration for the type of days.
The possible values are
fixme: turn into all G36 types
</p>
<ol>
<li>
WorkingDay
</li>
<li>
NonWorkingDay
</li>
<li>
Holiday
</li>
</ol>
</html>",
        revisions="<html>
<ul>
<li>
February 27, 2017 by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
