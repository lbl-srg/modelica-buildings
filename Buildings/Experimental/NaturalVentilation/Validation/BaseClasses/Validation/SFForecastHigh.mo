within Buildings.Experimental.NaturalVentilation.Validation.BaseClasses.Validation;
model SFForecastHigh "Validation for SF forecast high"
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{8,22},{48,62}}),     iconTransformation(extent={
            {-168,106},{-148,126}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-28,2},{-8,22}})));
  ForecastHighSF forHiSF
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(weaDat.weaBus, weaBus.TDryBul) annotation (Line(
      points={{-8,12},{6,12},{6,42},{28,42}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=31536000), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NaturalVentilation/Validation/BaseClasses/Validation/SFForecastHigh.mos"
        "Simulate and plot"),Icon(coordinateSystem(preserveAspectRatio=false),
        graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-34,64},{66,4},{-34,-56},{-34,64}})}),                                                Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SFForecastHigh;
