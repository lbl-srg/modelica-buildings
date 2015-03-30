within Buildings.Rooms.Validation.TestConditionalConstructions;
model OnlyExteriorWallNoWindow "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=1,
   nConExtWin=0,
   nConPar=0,
   nConBou=0,
   nSurBou=0,
   roo(
    datConExt(layers={matLayExt}, each A=10,
           each til=Buildings.Types.Tilt.Floor, each azi=Buildings.Types.Azimuth.W)));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/TestConditionalConstructions/OnlyExteriorWallNoWindow.mos"
        "Simulate and plot"),
   Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
for the case of having only one exterior construction with no window.
</p>
</html>"));
end OnlyExteriorWallNoWindow;
