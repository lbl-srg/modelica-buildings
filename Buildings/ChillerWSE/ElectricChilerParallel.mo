within Buildings.ChillerWSE;
model ElectricChilerParallel "Multiple identical electric chillers"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelElectricEIR(
    redeclare each final Buildings.Fluid.Chillers.ElectricEIR chi[n](
      per=per));

  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[n]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements a chiller parallel with <code>n</code> identical chillers. For the chiller model please see 
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">Buildings.Fluid.Chillers.ElectricEIR</a>.
</p>
<p>
Note that altough the chillers have identical nominal conditions, they can have different 
performance curves specified in performance data <code>per</code>. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricChilerParallel;
