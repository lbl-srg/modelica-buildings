within Buildings.RoomsBeta.Examples.TestConditionalConstructions;
model OnlyExteriorWallNoWindow "Test model for room model"
  extends BaseClasses.PartialTestModel(
   nConExt=1,
   nConExtWin=0,
   nConPar=0,
   nConBou=0,
   nSurBou=0,
   roo(
    datConExt(layers={matLayExt}, each A=10,
           each til=Types.Tilt.Floor, each azi=Types.Azimuth.W)));
   annotation(Commands(file="OnlyExteriorWallNoWindow.mos" "run"));
end OnlyExteriorWallNoWindow;
