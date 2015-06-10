within Buildings.OpenStudioToModelica.PrototypeBuilding.Examples;
model SmallOfficeImposedT
  "Example of a small office building with temperature imposed in each thermal zone"
  extends Buildings.OpenStudioToModelica.Interfaces.SimulationExample(
    nRooms = 6,
    redeclare
      Buildings.OpenStudioToModelica.PrototypeBuilding.SmallOfficeBuilding
    building(roomEnDyn = Modelica.Fluid.Types.Dynamics.DynamicFreeInitial),
      redeclare InternalHeatGains.FixedTemperatureNoInternalHeatGain ihg[6](redeclare
        each final package Medium =
          Buildings.Media.Specialized.Air.PerfectGas));
    Modelica.Blocks.Sources.Constant const[6](each k=273.15 + 22)
    annotation (Placement(transformation(extent={{-100,-34},{-80,-14}})));
equation
  connect(const.y, ihg.TZon)
    annotation (Line(points={{-79,-24},{-70,-24},{-62,-24}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 23, 2015, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end SmallOfficeImposedT;
