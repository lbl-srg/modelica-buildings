within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation;
model Cylindrical
  "Comparison of the Cylindrical with the GroundTemperatureResponse"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.Temperature T_start=295.15
    "Initial soil temperature";
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template borFieDat=
    Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Borefield()
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical soi(
    final steadyStateInitial=false,
    final soiDat=borFieDat.soiDat,
    final h=1,
    final r_a=borFieDat.conDat.rBor,
    final r_b=3,
    final TInt_start=T_start,
    final TExt_start=T_start) "Heat conduction in the soil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(T=T_start)
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Step heaFlo(
    offset=0,
    startTime=1000,
    height=1056/18.3) "Heat flow to soil"
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow to soil"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(soi.port_b, preTem.port) annotation (Line(
      points={{10,0},{40,0}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaFlo.y, preHeaFlo.Q_flow) annotation (Line(
      points={{-75,0},{-60,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, soi.port_a) annotation (Line(
      points={{-40,0},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/Validation/Cylindrical.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=360000.0),
    Documentation(info="<html>
<p>
This example demonstrates the use of
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Cylindrical</a>.
</p>
<p>
After a short delay, a constant heat flow rate is applied to the inner surface
of a cylindrical ground layer while the outer surface is kept at a constant
temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 13, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Cylindrical;
