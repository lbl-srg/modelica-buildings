within Buildings.Rooms.Examples.TestConditionalConstructions;
model OneQOneT "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=0,
   nSurBou=2,
   roo(
    surBou(each A=15, each absIR=0.9, each absSol=0.9, each til=Buildings.HeatTransfer.Types.Tilt.Floor)));
  HeatTransfer.Sources.FixedHeatFlow fixedHeatFlown[1](Q_flow=0)
    annotation (Placement(transformation(extent={{16,-60},{36,-40}})));
  HeatTransfer.Sources.FixedTemperature TEasWal(T=274.15)
    annotation (Placement(transformation(extent={{120,-60},{100,-40}})));
equation
  connect(TEasWal.port, roo.surf_surBou[1]) annotation (Line(
      points={{100,-50},{60.2,-50},{60.2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedHeatFlown[1].port, roo.surf_surBou[2]) annotation (Line(
      points={{36,-50},{60.2,-50},{60.2,-30}},
      color={191,0,0},
      smooth=Smooth.None));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/TestConditionalConstructions/OneQOneT.mos"
        "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{200,
            160}}), graphics),
    experiment(
      StopTime=86400));
end OneQOneT;
