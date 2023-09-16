within Buildings.Experimental.DHC.Networks.Steam;
model DistributionCondensatePipe
  "Model of a steam distribution network using fixed resistance pipe model for condensate returns"
  extends Buildings.Experimental.DHC.Networks.BaseClasses.PartialDistribution2Pipe2Medium(
    redeclare ConnectionCondensatePipe con[nCon](
      each final dp_nominal=dp_nominal),
    redeclare model Model_pipDis=Buildings.Fluid.FixedResistances.LosslessPipe);
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  annotation (
  defaultComponentName="dis",
    Documentation(
      info="<html>
<p>
This is a model of a distribution network for steam heating systems. 
The model utilizes a split-medium approach with two separate medium 
declarations between liquid (condensate return) and vapor (steam 
supply) states. The piping network features:
</p>
<ul>
<li>
a connection model with fixed hydraulic resistance and no heat loss 
in the condensate return pipe segments; 
</li>
<li>
a dummy pipe model with no hydraulic resistance and no heat loss for 
the steam supply pipes; and 
</li>
<li>
a dummy pipe model with no hydraulic resistance and no heat loss for the end of
the distribution line (after the last connection). 
</li>
</ul>
<h4>References </h4>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Wangda Zuo. 2022. 
&ldquo;A Fast and Accurate Modeling Approach for Water and Steam 
Thermodynamics with Practical Applications in District Heating System Simulation,&rdquo; 
<i>Energy</i>, 254(A), pp. 124227.
<a href=\"https://doi.org/10.1016/j.energy.2022.124227\">10.1016/j.energy.2022.124227</a>
</p>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Baptiste Ravache, Wangda Zuo 2022. 
&ldquo;Towards Open-Source Modelica Models For Steam-Based District Heating Systems.&rdquo; 
<i>Proc. of the 1st International Workshop On Open Source Modelling And Simulation Of 
Energy Systems (OSMSES 2022)</i>, Aachen, German, April 4-5, 2022.
<a href=\"https://doi.org/10.1109/OSMSES54027.2022.9769121\">10.1109/OSMSES54027.2022.9769121</a>
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 15, 2023, by Kathryn Hinkelman:<br/>
Updated publication references.
</li>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end DistributionCondensatePipe;
