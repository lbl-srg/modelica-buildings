within Buildings.RoomsBeta.Examples.TestConditionalConstructions;
model OnlyPartition "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=1,
   nConBou=0,
   nSurBou=0,
   roo(
    datConPar(layers={matLayPar}, each A=10,
    each til=Buildings.HeatTransfer.Types.Tilt.Floor,
    each azi=Buildings.HeatTransfer.Types.Azimuth.W)));

   annotation(Commands(file="OnlyPartition.mos" "run"),
    experiment(
      StopTime=172800,
      Tolerance=1e-05,
      Algorithm="Radau"));
end OnlyPartition;
