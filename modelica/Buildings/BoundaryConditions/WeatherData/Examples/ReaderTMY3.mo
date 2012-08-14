within Buildings.BoundaryConditions.WeatherData.Examples;
model ReaderTMY3 "Test model for read requested weather data"
  import Buildings;
  extends Modelica.Icons.Example;
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(
    filNam="Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos", HSou=
        Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Sources.Constant HDifHor(k=0) "Diffuse horizontal radiation"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant HGloHor(k=0) "Horizontal global radiation"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(HGloHor.y, weaDat1.HGloHor_in) annotation (Line(
      points={{-59,-10},{-28,-10},{-28,-55},{-21,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifHor.y, weaDat1.HDifHor_in) annotation (Line(
      points={{-59,-50},{-40,-50},{-40,-57.6},{-21,-57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/Examples/ReaderTMY3.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the TMY3 data reader.
</p>
</html>"));
end ReaderTMY3;
