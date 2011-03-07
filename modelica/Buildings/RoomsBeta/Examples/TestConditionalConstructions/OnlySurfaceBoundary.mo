within Buildings.RoomsBeta.Examples.TestConditionalConstructions;
model OnlySurfaceBoundary "Test model for room model"
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=0,
   nSurBou=1,
   roo(
    surBou(each A=15, each epsLW=0.9, each epsSW=0.9, each til=Types.Tilt.Floor)));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBou[nSurBou](each T=288.15)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={130,-70})));
  HeatTransfer.ConductorMultiLayer conOut[nSurBou](each A=15, redeclare
      Buildings.HeatTransfer.Data.OpaqueConstructions.Brick120 layers)
    "Construction that is modeled outside of room"
    annotation (Placement(transformation(extent={{80,-80},{100,-60}})));
equation
  connect(TBou.port, conOut.port_b) annotation (Line(
      points={{120,-70},{100,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo.surf_surBou, conOut.port_a) annotation (Line(
      points={{60.2,-30},{60,-30},{60,-70},{80,-70}},
      color={191,0,0},
      smooth=Smooth.None));
   annotation(Commands(file="OnlySurfaceBoundary.mos" "run"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}}), graphics),
    experiment(
      StopTime=172800,
      Tolerance=1e-05,
      Algorithm="Radau"));
end OnlySurfaceBoundary;
