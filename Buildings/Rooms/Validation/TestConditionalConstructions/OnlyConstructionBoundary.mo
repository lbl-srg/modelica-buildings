within Buildings.Rooms.Validation.TestConditionalConstructions;
model OnlyConstructionBoundary "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=1,
   nSurBou=0,
   roo(
    datConBou(layers={matLayPar}, each A=12, each til=Buildings.Types.Tilt.Floor,
    each azi=Buildings.Types.Azimuth.W)));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou1[nConBou](each T=288.15)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={110,-70})));
equation
  connect(TBou1.port, roo.surf_conBou) annotation (Line(
      points={{100,-70},{70,-70},{70,-32}},
      color={191,0,0},
      smooth=Smooth.None));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/TestConditionalConstructions/OnlyConstructionBoundary.mos"
        "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
for the case of having only one construction whose other surface boundary condition
is exposed by the room model.
</p>
</html>"));
end OnlyConstructionBoundary;
