within ;
model Zones3 "Model of three thermal zones"

  constant Modelica.Units.SI.Volume Core_ZN_V = 3*4*3 "Volume";
  constant Modelica.Units.SI.Area Core_ZN_AFlo = 3*4 "Floor area";
  constant Real Core_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";


  constant Modelica.Units.SI.Volume South_ZN_V = 3*4*3 "Volume";
  constant Modelica.Units.SI.Area South_ZN_AFlo = 3*4 "Floor area";
  constant Real South_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";


  constant Modelica.Units.SI.Volume North_ZN_V = 3*4*3 "Volume";
  constant Modelica.Units.SI.Area North_ZN_AFlo = 3*4 "Floor area";
  constant Real North_ZN_mSenFac = 1 "Factor for scaling sensible thermal mass of volume";

  input Modelica.Units.NonSI.Temperature_degC Core_ZN_T "Temperature of the zone air";
  input Real Core_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.Units.SI.MassFlowRate Core_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.Units.NonSI.Temperature_degC Core_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.Units.SI.HeatFlowRate Core_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  input Modelica.Units.NonSI.Temperature_degC South_ZN_T "Temperature of the zone air";
  input Real South_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.Units.SI.MassFlowRate South_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.Units.NonSI.Temperature_degC South_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.Units.SI.HeatFlowRate South_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";

  input Modelica.Units.NonSI.Temperature_degC North_ZN_T "Temperature of the zone air";
  input Real North_ZN_X(min=0, final unit="1") "Water vapor mass fraction in kg water/kg dry air";
  input Modelica.Units.SI.MassFlowRate North_ZN_mInlets_flow
     "Sum of positive mass flow rates into the zone for all air inlets (including infiltration)";
  input Modelica.Units.NonSI.Temperature_degC North_ZN_TAveInlet
    "Average of inlets medium temperatures carried by the mass flow rates";
  input Modelica.Units.SI.HeatFlowRate North_ZN_QGaiRad_flow
    "Radiative sensible heat gain added to the zone";


  output Modelica.Units.NonSI.Temperature_degC Core_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QLat_flow(start=-0.1)
    "Latent heat gain added to the zone";
  output Modelica.Units.SI.HeatFlowRate Core_ZN_QPeo_flow
      "Heat gain due to people";

  output Modelica.Units.NonSI.Temperature_degC South_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.Units.SI.HeatFlowRate South_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.Units.SI.HeatFlowRate South_ZN_QLat_flow(start=0.1)
    "Latent heat gain added to the zone";
  output Modelica.Units.SI.HeatFlowRate South_ZN_QPeo_flow
      "Heat gain due to people";

  output Modelica.Units.NonSI.Temperature_degC North_ZN_TRad
    "Average radiative temperature in the room";
  output Modelica.Units.SI.HeatFlowRate North_ZN_QConSen_flow
    "Convective sensible heat added to the zone";
  output Modelica.Units.SI.HeatFlowRate North_ZN_QLat_flow(start=0.1)
    "Latent heat gain added to the zone";
  output Modelica.Units.SI.HeatFlowRate North_ZN_QPeo_flow
      "Heat gain due to people";

protected
  RoomModel core(
    V =       Core_ZN_V,
    AFlo =    Core_ZN_AFlo,
    mSenFac = Core_ZN_mSenFac) "Room model";

  RoomModel north(
    V =       North_ZN_V,
    AFlo =    North_ZN_AFlo,
    mSenFac = North_ZN_mSenFac) "Room model";

  RoomModel south(
    V =       South_ZN_V,
    AFlo =    South_ZN_AFlo,
    mSenFac = South_ZN_mSenFac) "Room model";

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

  // Inputs for room
  north.T            = North_ZN_T;
  north.X            = North_ZN_X;
  north.mInlets_flow = North_ZN_mInlets_flow;
  north.TAveInlet    = North_ZN_TAveInlet;
  north.QGaiRad_flow = North_ZN_QGaiRad_flow;

  // Outputs from room
  north.TRad         = North_ZN_TRad;
  north.QConSen_flow = North_ZN_QConSen_flow;
  north.QLat_flow    = North_ZN_QLat_flow;
  north.QPeo_flow    = North_ZN_QPeo_flow;

  // Inputs for room
  south.T            = South_ZN_T;
  south.X            = South_ZN_X;
  south.mInlets_flow = South_ZN_mInlets_flow;
  south.TAveInlet    = South_ZN_TAveInlet;
  south.QGaiRad_flow = South_ZN_QGaiRad_flow;

  // Outputs from room
  south.TRad         = South_ZN_TRad;
  south.QConSen_flow = South_ZN_QConSen_flow;
  south.QLat_flow    = South_ZN_QLat_flow;
  south.QPeo_flow    = South_ZN_QPeo_flow;

  annotation (Documentation(info="<html>
<p>
Simple model of three thermal zones that is used for testing the Spawn of EnergyPlus coupling.
</p>
</html>"));
end Zones3;
