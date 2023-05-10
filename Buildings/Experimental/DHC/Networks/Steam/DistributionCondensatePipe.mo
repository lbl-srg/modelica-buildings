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
<h4>Reference</h4>
<p>
Hinkelman, Kathryn, Saranya Anbarasu, Michael Wetter, 
Antoine Gautier, and Wangda Zuo. 2022. “A Fast and Accurate Modeling 
Approach for Water and Steam Thermodynamics with Practical 
Applications in District Heating System Simulation.” Preprint. February 24. 
<a href=\"http://dx.doi.org/10.13140/RG.2.2.20710.29762\">doi:10.13140/RG.2.2.20710.29762</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end DistributionCondensatePipe;
