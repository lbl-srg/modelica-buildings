within Buildings.Examples.Tutorial.SimpleHouse;
model SimpleHouse0
  "Start file for simple house example"
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air "Medium model for air";
  package MediumWater = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.Area AWall = 100 "Wall area";
  parameter Modelica.Units.SI.Length dWall = 0.25 "Wall thickness";
  parameter Modelica.Units.SI.ThermalConductivity kWall = 0.04 "Wall thermal conductivity";
  parameter Modelica.Units.SI.Density rhoWall = 2000 "Wall density";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpWall = 1000 "Wall specific heat capacity";
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}}),
        iconTransformation(extent={{-152,-10},{-132,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOut
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-160,0},{-130,0}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.T, weaBus.TDryBul)
    annotation (Line(points={{-82,0},{-130,0}},           color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,
            -220},{220,220}}), graphics={
        Rectangle(
          extent={{-200,60},{-20,-60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-200,-80},{200,-200}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-200,200},{200,80}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,60},{200,-60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{57.25,40.25},{2.75,59.75}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Building"),
        Text(
          extent={{-137,-99},{-203,-81}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-102,39},{-198,61}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather inputs"),
        Text(
          extent={{-61,179},{-199,201}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cooling and ventilation")}),
    experiment(Tolerance=1E-6, StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
Replace IDEAS by Buildings models and general revision/update of the model.
</li>
<li>
October 11, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used as the starting point for the
<a href=\"modelica://Buildings.Examples.Tutorial.SimpleHouse\">Buildings.Examples.Tutorial.SimpleHouse</a>
tutorial.
It contains a weather data reader and a <code>PrescribedTemperature</code> component
that allows the user to connect thermal components to the dry bulb temperature.
It was based on from the Modelica crash course organised by KU Leuven
(<a href=\"https://github.com/open-ideas/__CrashCourse__\">https://github.com/open-ideas/__CrashCourse__</a>).
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse0.mos"
        "Simulate and plot"));
end SimpleHouse0;
