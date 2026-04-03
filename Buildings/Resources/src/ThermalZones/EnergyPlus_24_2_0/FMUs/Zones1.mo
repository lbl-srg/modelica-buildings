within ;
model Zones1 "Model of a thermal zone"

  constant Modelica.Units.SI.Volume Core_ZN_V = 3*4*3 "Volume";
  constant Modelica.Units.SI.Area Core_ZN_AFlo = 3*4 "Floor area";
  constant Real Core_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";

  /* Results of system sizing */
  parameter Modelica.Units.SI.Power Core_ZN_QCooSen_flow = -1000
    "Design sensible load";
  parameter Modelica.Units.SI.Power Core_ZN_QCooLat_flow = -500
    "Design latent load";
  parameter Modelica.Units.SI.Temperature Core_ZN_TOutCoo = 303.15
    "Outdoor drybulb temperature at the design load";
  parameter Modelica.Units.SI.DimensionlessRatio Core_ZN_XOutCoo = 0.01
    "Outdoor humidity ratio at the design load per total air mass of the zone";
  parameter Modelica.Units.SI.Time Core_ZN_tCoo = 3600
    "Time at which the design load occurred";
  parameter Modelica.Units.SI.MassFlowRate Core_ZN_mOutCoo_flow = Core_ZN_V * 1.2 * 0.3 / 3600
    "Minimum outdoor air flow rate during the design load";

  parameter Modelica.Units.SI.Power Core_ZN_QHea_flow = 1000
    "Design heating load";
  parameter Modelica.Units.SI.Temperature Core_ZN_TOutHea = 273.15 - 20
    "Outdoor drybulb temperature at the design load";
  parameter Modelica.Units.SI.DimensionlessRatio Core_ZN_XOutHea = 0.001
    "Outdoor humidity ratio at the design load per total air mass of the zone";
  parameter Modelica.Units.SI.Time Core_ZN_tHea = 1800
    "Time at which the design load occurred";
  parameter Modelica.Units.SI.MassFlowRate Core_ZN_mOutHea_flow = Core_ZN_V * 1.2 * 0.3 / 3600
    "Minimum outdoor air flow rate during the design load";

  /* Inputs to the model */
  input Modelica.Units.NonSI.Temperature_degC Core_ZN_T "Temperature of the zone air";
  input Real Core_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.Units.SI.MassFlowRate Core_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.Units.NonSI.Temperature_degC Core_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.Units.SI.HeatFlowRate Core_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  /* Outputs from the model */
  output Modelica.Units.NonSI.Temperature_degC Core_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QLat_flow
    "Latent heat gain added to the zone";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QPeo_flow
      "Heat gain due to people";

protected
  RoomModel core(
    V =       Core_ZN_V,
    AFlo =    Core_ZN_AFlo,
    mSenFac = Core_ZN_mSenFac) "Room model";

equation
  // Inputs for room
  core.T            = Core_ZN_T;
  core.X            = Core_ZN_X;
  core.mInlets_flow = Core_ZN_mInlets_flow;
  core.TAveInlet    = Core_ZN_TAveInlet;
  core.QGaiRad_flow = Core_ZN_QGaiRad_flow;

  // Outputs from room
  core.TRad         = Core_ZN_TRad;
  core.QConSen_flow = Core_ZN_QConSen_flow;
  core.QLat_flow    = Core_ZN_QLat_flow;
  core.QPeo_flow    = Core_ZN_QPeo_flow;

  annotation (Documentation(info="<html>
<p>
Simple model of one thermal zone that is used for testing the Spawn of EnergyPlus coupling.
</p>
</html>"));
end Zones1;
