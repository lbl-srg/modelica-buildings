within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.Data.BaseClasses;
record CoolingNominalValues "Data record of cooling mode nominal values"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.Data.BaseClasses.CoolingNominalValues;

annotation (defaultComponentName="cooNomVal",
              preferedView="info",
  Documentation(info="<html>
  <p>
This is the base record of cooling mode nominal values for heat pump models. 
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData\">
Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData</a>
for a description of the data.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 24, 2013 by Kaustubh Phalak:<br>
First implementation.
</li>
</ul>
</html>"));
end CoolingNominalValues;
