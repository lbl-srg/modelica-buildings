within Buildings.Applications.DHC.CentralPlants.Heating.Generation1.Subsystems;
model BoilerSubsystem
  "Boiler subsystem containing parallel boilers and economizers"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTwoMedium;
  Fluid.Boilers.SteamBoilerFourPort boi[num]
    annotation (Placement(transformation(extent={{20,-12},{40,10}})));
  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex[num]
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Fluid.Sources.Boundary_pT airSou "Air source"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Fluid.Sources.Boundary_pT airSin "Air sink"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Fluid.Movers.SpeedControlled_y fan[num]
    annotation (Placement(transformation(extent={{50,-60},{30,-40}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val[num]
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BoilerSubsystem;
