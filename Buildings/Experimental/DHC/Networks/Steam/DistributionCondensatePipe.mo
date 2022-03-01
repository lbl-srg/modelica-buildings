within Buildings.Experimental.DHC.Networks.Steam;
model DistributionCondensatePipe
  "Model of a steam distribution network using fixed resistance pipe model for condensate returns"
  extends Buildings.Experimental.DHC.Networks.Steam.BaseClasses.PartialDistributionTwoPipe(
    redeclare ConnectionCondensatePipe con[nCon](
      redeclare package MediumSup = MediumSup,
      redeclare package MediumRet = MediumRet),
    redeclare model Model_pipDis=Buildings.Fluid.FixedResistances.LosslessPipe);
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
a connection model with fixed hydraulic resistance with no heat loss 
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
Antoine Gautier, and Wangda Zuo. 2021. “A New Steam 
Medium Model for Fast and Accurate Simulation of District 
Heating Systems.” engrXiv. October 8. 
<a href=\\\"https://engrxiv.org/cqfmv/\\\">doi:10.31224/osf.io/cqfmv</a>
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 7, 2021 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end DistributionCondensatePipe;
