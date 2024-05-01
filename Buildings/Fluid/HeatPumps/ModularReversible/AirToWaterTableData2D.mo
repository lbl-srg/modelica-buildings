within Buildings.Fluid.HeatPumps.ModularReversible;
model AirToWaterTableData2D
  "Reversible air to water heat pump based on 2D manufacturer data in Europe"
  extends Buildings.Fluid.HeatPumps.ModularReversible.TableData2D(
    redeclare replaceable package MediumEva = Buildings.Media.Air,
    redeclare replaceable package MediumCon = Buildings.Media.Water,
    redeclare replaceable Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater datTabHea
      constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericAirToWater,
    redeclare replaceable Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic datTabCoo
      constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic);

  annotation (Documentation(info="<html>
<p>
  Reversible air-to-water heat pump based on
  two-dimensional data from manufacturer data, (e.g. based on EN 14511),
  using the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
  Buildings.Fluid.HeatPumps.ModularReversible.Modular</a> approach.
</p>
<p>
  For more information on the approach, see
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide</a>.
</p>
<p>
  Internal inertias and heat losses are neglected,
  as these are implicitly obtained in measured
  data from manufacturers.
  Also, icing is disabled as the performance degradation
  is already contained in the data.
</p>
<p>
Please read the documentation of the model for heating at
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D</a>.
</p>
<p>
For cooling, the assumptions are similar, and described at
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D\">
  Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D</a>
</p>
<h4>References</h4>
<p>
EN 14511-2018: Air conditioners, liquid chilling packages and heat pumps for space
heating and cooling and process chillers, with electrically driven compressors
<a href=\"https://www.beuth.de/de/norm/din-en-14511-1/298537524\">
https://www.beuth.de/de/norm/din-en-14511-1/298537524</a>
</p>

</html>"));
end AirToWaterTableData2D;
