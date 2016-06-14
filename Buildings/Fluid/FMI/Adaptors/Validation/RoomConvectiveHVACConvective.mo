within Buildings.Fluid.FMI.Adaptors.Validation;
model RoomConvectiveHVACConvective
  "Simple thermal zone with convective HVAC system."
 extends Modelica.Icons.Example;

  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.HVACConvectiveSingleZone hvaCon
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.FMI.ExportContainers.Examples.FMUs.ThermalZoneConvective rooCon
    annotation (Placement(transformation(extent={{40,-2},{62,18}})));
  model BaseCase "Base model used for the validation of the FMI interfaces"
    extends Buildings.Examples.Tutorial.SpaceCooling.System3(vol(energyDynamics=
      Modelica.Fluid.Types.Dynamics.FixedInitial));
    annotation (Documentation(info="<html>
<p>
This example is the base case model which is used to validate 
the coupling of a convective thermal zone with an air-based HVAC system. 
</p>
<p>
The model which is validated is in 
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective
</a>. 
</p>
</html>"), Icon(graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-72,-14},{56,-24}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Ellipse(
            extent={{-56,-2},{-22,-36}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-72,190},{70,84}},
            lineColor={0,0,255},
            textString="%name"),
          Polygon(
            points={{-28,-6},{-56,-18},{-28,-32},{-28,-6}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{26,54},{-20,32},{70,32},{26,54}},
            lineColor={95,95,95},
            smooth=Smooth.None,
            fillPattern=FillPattern.Solid,
            fillColor={95,95,95}),
          Rectangle(
            extent={{-12,32},{62,-30}},
            lineColor={150,150,150},
            fillPattern=FillPattern.Solid,
            fillColor={150,150,150}),
          Rectangle(
            extent={{-2,-4},{20,26}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{34,-4},{54,26}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,24},{-12,16}},
            lineColor={0,0,0},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,127,255}),
          Ellipse(
            extent={{-58,36},{-24,2}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-52,32},{-24,20},{-52,6},{-52,32}},
            lineColor={0,0,255},
            fillColor={0,0,255},
            fillPattern=FillPattern.Solid)}));
  end BaseCase;
  BaseCase baseCase
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Constant rooRad(k=295.13) "Radiative temperature"
    annotation (Placement(transformation(extent={{60,-40},{40,-20}})));
equation

  connect(hvaCon.CZon, rooCon.CZon) annotation (Line(points={{-39.375,11.25},{0,
          11.25},{0,0.5},{38.625,0.5}}, color={0,0,127}));
  connect(hvaCon.X_wZon, rooCon.X_wZon) annotation (Line(points={{-39.375,13.125},
          {4,13.125},{4,3},{38.625,3}}, color={0,0,127}));
  connect(hvaCon.fluPor, rooCon.fluPor) annotation (Line(points={{-39.375,18.75},
          {0.3125,18.75},{0.3125,16.75},{39.3125,16.75}}, color={0,0,255}));
  connect(hvaCon.TAirZon, rooCon.TAirZon) annotation (Line(points={{-39.375,16.875},
          {-4,16.875},{-4,14},{24,14},{24,5.5},{38.625,5.5}}, color={0,0,127}));
  connect(hvaCon.TRadZon, rooRad.y) annotation (Line(points={{-39.375,15},{0,15},
          {0,-30},{39,-30}}, color={0,0,127}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example validates the coupling of a convective thermal zone with an air-based HVAC system.
The block <code>rooCoo</code> wraps a thermal zone model, and the block
<code>hvaCoo</code> wraps an HVAC model.
Both are encapsulated as input output blocks that can be exported as an FMU.
These blocks are then connected to simulate the coupled response.
The system model also contains an instance called <code>refMod</code>
which contains the same model but without it being encapsulated in the
FMU adaptor.
</p>
<p>The Modelica models of the thermal zone and the HVAC air-based system are taken from 
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3
</a>.
</p>
<p>
The coupling is validated against the <code>refMod</code> 
block which encapsulates the base case model 
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective.BaseCase\">
Buildings.Fluid.FMI.Adaptors.Validation.RoomConvectiveHVACConvective.BaseCase 
</a>. 
</p>
</html>", revisions="<html>
<ul>
<li>
May 03, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Validation/RoomConvectiveHVACConvective.mos"
        "Simulate and plot"),
    experiment(StartTime=1.5552e+07, StopTime=15638400));
end RoomConvectiveHVACConvective;
