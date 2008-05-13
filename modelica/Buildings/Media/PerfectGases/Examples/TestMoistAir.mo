model TestMoistAir 
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
     redeclare package Medium = 
          Buildings.Fluids.Media.PerfectGases.MoistAir);
  
      annotation (Diagram, Commands(file="TestMoistAir.mos" "run"));
end TestMoistAir;
