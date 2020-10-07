within Buildings.Experimental.NaturalVentilation.Validation.BaseClasses.Validation;
model SFForecastHigh "Validation model for SF forecast high"
  ForecastHighSF forHiSF
    annotation (Placement(transformation(extent={{-38,60},{-18,80}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{22,60},{62,100}}), iconTransformation(extent={{-168,
            106},{-148,126}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{60,40},{74,40},{74,80},{42,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Documentation(info="<html>
  <p>
  This model validates the validation base class block that outputs the daily forecast high for San Francisco. 
<p>
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
Updated description. 
</li>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-98,-100},{102,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-34,58},{66,-2},{-34,-62},{-34,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SFForecastHigh;
