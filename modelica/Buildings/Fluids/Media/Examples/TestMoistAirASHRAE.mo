model TestMoistAirASHRAE 
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
            redeclare package Medium = Buildings.Fluids.Media.MoistAirASHRAE);
    annotation (Diagram, Commands(file="TestMoistAirASHRAE.mos" "run"));
end TestMoistAirASHRAE;
