within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.Validation.BaseClasses.Validation;
model ChicagoForecastHigh
  "Validation model for forecast high temperature for Chicago"
  Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTemperatureSignal.Validation.BaseClasses.ForecastHighChicago forHiChi
    "Forecast high for Chicago location"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat2(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{26,24},{46,44}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather bus"
    annotation (Placement(
        transformation(extent={{8,54},{48,94}}), iconTransformation(extent={
            {-168,106},{-148,126}})));
equation
  connect(weaDat2.weaBus,weaBus1. TDryBul) annotation (Line(
      points={{46,34},{40,34},{40,74},{28,74}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (experiment(Tolerance=1E-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/SlabTemperatureSignal/Validation/BaseClasses/Validation/ChicagoForecastHigh.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This validates the Chicago forecast high. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.  
</li>
</ul>
</html>"),Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChicagoForecastHigh;
