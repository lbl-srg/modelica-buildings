within Buildings.ThermalZones.Detailed.Validation.TestConditionalConstructions;
model OnlyConstructionBoundary2
  "Test model for room model with states added to both surfaces of the construction"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialTestModel(
   nConExt=0,
   nConExtWin=0,
   nConPar=0,
   nConBou=1,
   nSurBou=0,
   roo(conBou(each placeCapacityAtSurf_a=false, each placeCapacityAtSurf_b=false),
    datConBou(layers={matLayPar}, each A=12, each til=Buildings.Types.Tilt.Floor,
    each azi=Buildings.Types.Azimuth.W)));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou1[nConBou](each T=288.15)
    "Boundary condition for construction" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={146,-70})));
  HeatTransfer.Convection.Interior con[nConBou](til={Buildings.Types.Tilt.Wall},
      each A=12) "Model for heat convection"
    annotation (Placement(transformation(extent={{112,-80},{92,-60}})));
equation
  connect(roo.surf_conBou, con.fluid) annotation (Line(points={{70,-32},{70,-32},
          {70,-68},{70,-70},{92,-70}}, color={191,0,0}));
  connect(con.solid, TBou1.port)
    annotation (Line(points={{112,-70},{136,-70},{136,-70}}, color={191,0,0}));
   annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/TestConditionalConstructions/OnlyConstructionBoundary2.mos"
        "Simulate and plot"),
      Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            200,160}})),
    experiment(
      StopTime=86400),
    Documentation(info="<html>
<p>
This model tests
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">Buildings.ThermalZones.Detailed.MixedAir</a>
for the case of having only one construction whose other surface boundary condition
is exposed by the room model.
This model is similar to 
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.TestConditionalConstructions.OnlyConstructionBoundary\">
Buildings.ThermalZones.Detailed.Validation.TestConditionalConstructions.OnlyConstructionBoundary</a>.
The main differences are the addition of states at the surface of the construction, 
and the convection model which is added to prevent a translation error caused by an overdetermined initialization problem.
</p>
</html>", revisions="<html>
</html>"));
end OnlyConstructionBoundary2;
