within Buildings.Fluid.HeatExchangers.DXCoils.WaterSource;
model SingleSpeed "Single speed water source DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeed eva(
      redeclare final Buildings.Fluid.HeatExchangers.DXCoils.WaterSource.Data.Generic.DXCoil datCoi=datCoi));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-124,66},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
equation
  connect(eva.on, on) annotation (Line(points={{-11,8},{-11,68},{-88,68},{-88,
          78},{-112,78}},       color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
            points={{-100,80},{-68,80},{-68,20}}, color={255,85,170})}),
    Documentation(info="<html>
<p>
This model can be used to simulate a water source DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
March 21, 2017, by Michael Wetter:<br/>
Moved assignment of evaporator data <code>datCoi</code> from the
<code>constrainedBy</code> declaration in the base class
to the instantiation to work around a limitation of JModelica.
</li>
<li>
March 7, 2017, by Michael Wetter:<br/>
Refactored implementation to avoid code duplication and to propagate parameters.
</li>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeed;
