within Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses;
record Sizing "Record of sizing parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Power QSen_flow(fixed=false)
    "Design sensible load";
  parameter Modelica.Units.SI.Power QLat_flow(fixed=false)
    "Design latent load";
  parameter Modelica.Units.SI.Temperature TOut(fixed=false)
    "Outdoor drybulb temperature at the design load";
  parameter Modelica.Units.SI.DimensionlessRatio XOut(fixed=false)
    "Outdoor humidity ratio at the design load per total air mass of the zone";
  parameter Modelica.Units.SI.MassFlowRate mOut_flow(fixed=false)
    "Minimum outdoor air flow rate during the design load";
  parameter Modelica.Units.SI.Time t(fixed=false)
    "Time at which the design load occurred";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Sizing;
