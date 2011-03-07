within Buildings.RoomsBeta.Examples.TestConditionalConstructions;
model OnlyConstructionBoundary "Test model for room model"
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=1,
   nSurBou=0,
   roo(
    datConBou(layers={matLayPar}, each A=12, each til=Types.Tilt.Floor,
    each azi=Types.Azimuth.W)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBou1[nConBou](each T=288.15)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-70})));
equation
  connect(TBou1.port, roo.surf_conBou) annotation (Line(
      points={{100,-70},{70,-70},{70,-34}},
      color={191,0,0},
      smooth=Smooth.None));
   annotation(Commands(file="OnlyConstructionBoundary.mos" "run"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}}), graphics),
    experiment(
      StopTime=172800,
      Tolerance=1e-05,
      Algorithm="Radau"));
end OnlyConstructionBoundary;
