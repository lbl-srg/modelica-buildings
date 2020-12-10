within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model ConventionalWinter
  "Example model using the block OptimalStart with a conventional controller for a single-zone VAV system in winter"
  extends Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.ConventionalSpring;

  annotation (experiment(
      StopTime=604800,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/OptimalStart/ConventionalWinter.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is an example model on how to use the block 
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
that integrates with a conventional controller, a single-zone VAV system 
and a single-zone floor building. The building, HVAC system and controller model 
can be found in the base class
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional\">
Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional</a>. 
</p>
<p>
This example validates the optimal start results for the winter condition. Note 
that the optimal start block in this example computes for both heating and cooling conditions.
The first few days are initialization period. The optimal start block calculates
the optimal preheating time based on the moving average temperature slope of the 
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
end ConventionalWinter;
