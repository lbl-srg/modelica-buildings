within Buildings.Fluid.HeatExchangers.DXCoils.Cooling.WaterSource;
model MultiStage "Multi speed water source DX coils"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
      redeclare final Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.MultiStage eva);

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}})));

equation
  connect(eva.stage, stage)
   annotation (Line(points={{-11,8},{-16,8},{-16,80},{-112,80}},    color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Text(
          extent={{54,100},{98,80}},
          textColor={0,0,127},
          textString="P"), Line(points={{-100,80},{-68,80},{-68,20}}, color={
              255,128,0})}),    Documentation(revisions="<html>
              <ul>
<li>
April 5, 2023, by Xing Lu:<br/>
Updated air-source cooling coil class being extended from <code>MultiStage</code>
to <a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.MultiStage\">
Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.MultiStage</a>.
</li>
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
</html>", info="<html>
<p>
This model can be used to simulate a water source DX cooling coil with multiple
operating stages. Depending on the used performance curves, each
stage could be a different compressor speed, or a different mode
of operation, such as with or without hot gas reheat.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>"));
end MultiStage;
