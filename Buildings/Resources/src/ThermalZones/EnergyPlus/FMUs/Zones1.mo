within ;
model Zones1 "Model of a thermal zone"

  constant Modelica.SIunits.Volume Core_ZN_V = 3*4*3 "Volume";
  constant Modelica.SIunits.Area Core_ZN_AFlo = 3*4 "Floor area";
  constant Real Core_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";
 // parameter Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T_start = 20
 //   "Initial temperature of zone air";

  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_T "Temperature of the zone air";
  input Real Core_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.SIunits.MassFlowRate Core_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.SIunits.HeatFlowRate Core_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  discrete output Modelica.SIunits.Conversions.NonSIunits.Temperature_degC Core_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QLat_flow
    "Latent heat gain added to the zone";
  output Modelica.SIunits.HeatFlowRate Core_ZN_QPeo_flow
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
