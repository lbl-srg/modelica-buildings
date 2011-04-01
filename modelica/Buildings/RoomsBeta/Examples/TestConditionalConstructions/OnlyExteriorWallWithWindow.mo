within Buildings.RoomsBeta.Examples.TestConditionalConstructions;
model OnlyExteriorWallWithWindow "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=2,
   nConPar=0,
   nConBou=0,
   nSurBou=0,
   roo(
    datConExtWin(layers={matLayExt, matLayExt}, each A=10,
                 glaSys={glaSys, glaSys},
                 each AWin=4, each fFra=0.1,
                 til={Buildings.HeatTransfer.Types.Tilt.Floor, Buildings.HeatTransfer.Types.Tilt.Ceiling},
                 each azi=Buildings.HeatTransfer.Types.Azimuth.W)));
   annotation(Commands(file="OnlyExteriorWallWithWindow.mos" "run"),
    experiment(
      StopTime=172800,
      Tolerance=1e-05,
      Algorithm="Radau"));
end OnlyExteriorWallWithWindow;
