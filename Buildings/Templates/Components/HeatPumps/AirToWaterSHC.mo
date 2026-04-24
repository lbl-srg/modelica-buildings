within Buildings.Templates.Components.HeatPumps;
model AirToWaterSHC
  "Simultaneous heating and cooling (SHC) air-to-water heat pumps"
  extends Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC(
    final typ=Buildings.Templates.Components.Types.HeatPump.AirToWaterSHC);
  Fluid.Sensors.MassFlowRate mSouWat_flow(redeclare final package Medium =
        MediumSou) "Source mass flow rate"
    annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
equation
  connect(hp.P, bus.P) annotation (Line(points={{11,-6},{14,-6},{14,140},{0,140},
          {0,160}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(port_aSou, mSouWat_flow.port_a)
    annotation (Line(points={{80,-140},{80,-20},{70,-20}}, color={0,127,255}));
  connect(mSouWat_flow.port_b, TSouEnt.port_a)
    annotation (Line(points={{50,-20},{40,-20}}, color={0,127,255}));
  annotation (
    defaultComponentName="hp",
    Documentation(
      info="<html>
<p>
This is a model for a simultaneous heating and cooling (SHC) air-to-water heat pump 
where the capacity and power are interpolated from manufacturer data along the
source and sink temperature and the part load ratio.
</p>
<p>
This model is a wrapper for
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC\">
Buildings.Fluid.HeatPumps.ModularReversible.TableData2DLoadDepSHC</a>,
which the user may refer to for the modeling assumptions.
Note that, by default, internal safeties in this model are disabled.
</p>
<h4>Control points</h4>
<p>
Refer to the documentation of the base class
<a href=\"modelica://Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC\">
Buildings.Templates.Components.BaseClasses.PartialHeatPumpTableData2DLoadDepSHC</a>
for a description of the available control input and output variables.
</p>
</html>", revisions="<html>
<ul>
<li>September 1, 2025, by Xing Lu, Karthik Devaprasad:<br>First implementation. </li>
</ul>
</html>"));
end AirToWaterSHC;
