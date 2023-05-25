within Buildings.Fluid.DXSystems.Cooling.WaterSource;
model VariableSpeed "Variable speed water source DX coils"
  extends
    Buildings.Fluid.DXSystems.BaseClasses.PartialWaterCooledDXCoil(
      redeclare final
      Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed
      eva(
        final minSpeRat=minSpeRat,
        final speRatDeaBan=speRatDeaBan));

  parameter Real minSpeRat(min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";

  Modelica.Blocks.Interfaces.RealInput speRat(
   min=0,
   max=1,
   final unit="1")
   "Speed ratio"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}})));

equation

  connect(speRat, eva.speRat) annotation (Line(points={{-112,80},{-16,80},{-16,
          8},{-11,8}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Line(
            points={{-100,80},{-68,80},{-68,20}}, color={28,108,200})}),
    Documentation(info="<html>
<p>
This model can be used to simulate a water source DX cooling coil with variable speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.DXSystems.UsersGuide\">
Buildings.Fluid.DXSystems.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu:<br/>
Updated air-source cooling coil class being extended from <code>VariableSpeed</code>
to <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a>.
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
</html>"));
end VariableSpeed;
