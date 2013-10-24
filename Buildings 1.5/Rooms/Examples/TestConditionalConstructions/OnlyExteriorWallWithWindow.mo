within Buildings.Rooms.Examples.TestConditionalConstructions;
model OnlyExteriorWallWithWindow "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=2,
   nConPar=0,
   nConBou=0,
   nSurBou=0,
   roo(
    datConExtWin(layers={matLayExt, matLayExt},
                 each A=10,
                 glaSys={glaSys, glaSys},
                 each wWin=2,
                 each hWin=2,
                 each fFra=0.1,
                 til={Buildings.HeatTransfer.Types.Tilt.Floor, Buildings.HeatTransfer.Types.Tilt.Ceiling},
                 each azi=Buildings.HeatTransfer.Types.Azimuth.W)));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/TestConditionalConstructions/OnlyExteriorWallWithWindow.mos"
        "Simulate and plot"),
   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400));
end OnlyExteriorWallWithWindow;
