within Districts.BuildingLoads;
model LinearRegression
  "Whole building load model based on linear regression and table look-up"
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{
            294,-10},{314,10}}), iconTransformation(extent={{-112,-10},{-92,10}})));
  Electrical.AC.Interfaces.ThreePhasePlug threePhasePlug annotation (Placement(
        transformation(extent={{90,-10},{110,10}}), iconTransformation(extent={
            {90,-10},{110,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end LinearRegression;
