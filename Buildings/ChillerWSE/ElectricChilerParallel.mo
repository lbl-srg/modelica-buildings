within Buildings.ChillerWSE;
model ElectricChilerParallel "Ensembled multiple electric chillers via vector"
  extends Buildings.ChillerWSE.BaseClasses.PartialParallelElectricEIR(
    redeclare each final Buildings.Fluid.Chillers.ElectricEIR chi[n](
      redeclare each final replaceable package Medium1 = Medium1,
      redeclare each final replaceable package Medium2 = Medium2,
      per=per));

  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[n]
    "Performance data"
    annotation (choicesAllMatching = true,
                Placement(transformation(extent={{42,74},{62,94}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)));
end ElectricChilerParallel;
