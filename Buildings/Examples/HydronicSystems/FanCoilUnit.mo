within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  extends Modelica.Icons.Example;
  ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor floor1
    annotation (Placement(transformation(extent={{24,54},{70,80}})));
  Fluid.ZoneEquipment.FanCoilUnit.FourPipe fanCoiUni
    annotation (Placement(transformation(extent={{-18,-20},{22,20}})));
  Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU
    annotation (Placement(transformation(extent={{-80,-36},{-40,44}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FanCoilUnit;
