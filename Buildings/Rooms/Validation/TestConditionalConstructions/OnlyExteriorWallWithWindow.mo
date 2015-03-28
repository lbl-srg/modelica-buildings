within Buildings.Rooms.Validation.TestConditionalConstructions;
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
                 til={Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Ceiling},
                 each azi=Buildings.Types.Azimuth.W)));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/TestConditionalConstructions/OnlyExteriorWallWithWindow.mos"
        "Simulate and plot"),
   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
for the case of having only one exterior construction with window.
</p>
</html>"));
end OnlyExteriorWallWithWindow;
