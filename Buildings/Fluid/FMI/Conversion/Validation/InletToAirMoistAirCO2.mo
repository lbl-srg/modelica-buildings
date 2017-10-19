within Buildings.Fluid.FMI.Conversion.Validation;
model InletToAirMoistAirCO2
  "Validation model for inlet to Buildings.Media.Air conversion with C02 trace substances"
  extends Buildings.Fluid.FMI.Conversion.Validation.InletToAirDryAir(
    redeclare replaceable package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2"}));
  Modelica.Blocks.Sources.Constant CRev[Medium.nC](each k=0.8)
              "Trace substance for reverse flow"
    annotation (Placement(transformation(extent={{92,-80},{72,-60}})));
equation
  connect(CRev.y, conAirRevFlo.CZon) annotation (Line(points={{71,-70},{60,-70},
          {36,-70},{36,-42}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This example validates the conversion model
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.InletToAir\">
Buildings.Fluid.FMI.Conversion.InletToAir
</a>.
It is identical to
<a href=\"modelica://Buildings.Fluid.FMI.Conversion.Validation.InletToAirMoistAir\">
Buildings.Fluid.FMI.Conversion.Validation.InletToAirMoistAir</a>
except that
the medium has <code>C02</code> trace substances.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016, by Michael Wetter:<br/>
Added validation test for reverse flow.
</li>
<li>
April 28, 2016 by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Conversion/Validation/InletToAirMoistAirCO2.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=1.0));
end InletToAirMoistAirCO2;
