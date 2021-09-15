within Buildings.Applications.BaseClasses.Equipment;
model ElectricChillerParallel "Multiple identical electric chillers"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialParallelElectricEIR(
    redeclare final Buildings.Fluid.Chillers.ElectricEIR chi[num](
      final per=per));

  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[num]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));
  annotation (    Documentation(info="<html>
<p>
This model implements a chiller parallel with <code>num</code> identical chillers. For the chiller model please see
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">Buildings.Fluid.Chillers.ElectricEIR</a>.
</p>
<p>
Note that although the chillers have identical nominal conditions, they can have different
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
end ElectricChillerParallel;
