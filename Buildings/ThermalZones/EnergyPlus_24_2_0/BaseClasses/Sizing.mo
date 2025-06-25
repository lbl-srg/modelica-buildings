within Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses;
record Sizing "Record of sizing parameters"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.Power QCooSen_flow(fixed=false) "Design sensible cooling load";
  parameter Modelica.Units.SI.Power QCooLat_flow(fixed=false) "Design latent cooling load";
  parameter Modelica.Units.SI.Temperature TOutCoo(fixed=false) "Outdoor drybulb temperature at the cooling design load";
  parameter Modelica.Units.SI.DimensionlessRatio XOutCoo(fixed=false) "Outdoor humidity ratio at the cooling design load per total air mass of the zone";
  parameter Modelica.Units.SI.Time TCoo(fixed=false) "Time at which these loads occurred";
  parameter Modelica.Units.SI.Power QHea_flow(fixed=false) "Design heating load";
  parameter Modelica.Units.SI.Temperature TOutHea(fixed=false) "Outdoor drybulb temperature at the heating design load";
  parameter Modelica.Units.SI.DimensionlessRatio XOutHea(fixed=false) "Outdoor humidity ratio at the heating design load per total air mass of the zone";
  parameter Modelica.Units.SI.MassFlowRate mOutCoo_flow(fixed=false) "Minimum outdoor air flow rate during the cooling design load";
  parameter Modelica.Units.SI.MassFlowRate mOutHea_flow(fixed=false) "Minimum outdoor air flow rate during the heating design load";
  parameter Modelica.Units.SI.Time THea(fixed=false) "Time at which these loads occurred";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Sizing;
