within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model Guideline36Summer
  "Example model using the block OptimalStart with a Guideline36 controller for a single-zone system in summer"
  extends Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.Guideline36Spring;

  annotation (experiment(
      StartTime=15984000,
      StopTime=16761600,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/OptimalStart/Guideline36Summer.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is an example model on how to use the block 
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
that integrates with a controller based on Guideline36
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.Controller</a>, 
a single-zone VAV system and a single-zone floor building.
The building, HVAC system and controller model 
can be found in the base class
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36\">
Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36</a>.
</p>
<p>
This example validates the optimal start results for the summer condition.
The first few days are initialization period. The optimal start block calculates
the optimal precooling time based on the moving average temperature slope of the 
zone computed from previous days.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2020, by Kun Zhang:<br/>
First implementation. This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2126\">2126</a>.
</li>
</ul>
</html>"));
end Guideline36Summer;
