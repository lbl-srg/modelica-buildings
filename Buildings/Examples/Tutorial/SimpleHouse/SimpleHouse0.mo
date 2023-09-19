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
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TOut
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-180,-10},{-150,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(TOut.T, weaBus.TDryBul)
    annotation (Line(points={{-82,0},{-150,0},{-150,-10}},color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}}), graphics={
        Rectangle(
          extent={{-220,40},{-38,-40}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,-60},{180,-200}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-220,180},{180,60}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-20,40},{180,-40}},
          fillColor={238,238,238},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{22,22},{-23,39}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Wall"),
        Text(
          extent={{-157,-79},{-223,-61}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-118,18},{-214,40}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather inputs"),
        Text(
          extent={{-76,158},{-214,180}},
          textColor={0,0,127},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Cooling and ventilation")}),
    experiment(Tolerance=1E-6, StopTime=1e+06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/SimpleHouse/SimpleHouse0.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
Replace IDEAS by Buildings models.
</li>
<li>
October 11, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model is used as the starting point for the <code>SimpleHouse</code> tutorial.
It contains a weather data reader and a <code>PrescribedTemperature</code> component
that allows the user to connect thermal components to the dry bulb temperature.
It was based on from the Modelica crash course organised by KU Leuven
(<a href=\"https://github.com/open-ideas/__CrashCourse__\">https://github.com/open-ideas/__CrashCourse__</a>).
</p>
</html>"));
end SimpleHouse0;
