model TestMoistAirPerfect 
  extends Modelica.Media.Examples.Tests.Components.PartialTestModel(
            redeclare package Medium = Buildings.Fluids.Media.MoistAirPerfect);
    annotation (Diagram, Commands(file="TestMoistAirPerfect.mos" "run"));
end TestMoistAirPerfect;
