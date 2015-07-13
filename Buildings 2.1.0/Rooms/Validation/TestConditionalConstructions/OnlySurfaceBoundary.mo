within Buildings.Rooms.Validation.TestConditionalConstructions;
model OnlySurfaceBoundary "Test model for room model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=0,
   nSurBou=1,
   roo(
    surBou(each A=15, each absIR=0.9, each absSol=0.9, each til=Buildings.Types.Tilt.Floor)));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou[nSurBou](each T=288.15)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={130,-70})));
  HeatTransfer.Conduction.MultiLayer conOut[nSurBou](
    each A=15,
    each layers = matLayPar) "Construction that is modeled outside of room"
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
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/TestConditionalConstructions/OnlySurfaceBoundary.mos"
        "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.Rooms.MixedAir\">Buildings.Rooms.MixedAir</a>
for the case of having only one surface with specified boundary conditions.
</p>
</html>"));
end OnlySurfaceBoundary;
