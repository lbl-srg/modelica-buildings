within Buildings.Fluid.Movers.Data;
record PumpData "Pump curves and data for a pump or fan"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal=1500 "Nominal rotational speed for flow characteristic";
  parameter Modelica.SIunits.Power P_max = 100000
    "Maximum allowed motor power - not yet used in practice";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_min=0.0
    "Minimum rotational speed";
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_max=N_nominal
    "Maximum rotational speed";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters
    pressure "Volume flow rate vs. total pressure rise";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(r_V={1}, eta={0.7}) "Hydraulic efficiency";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(r_V={1}, eta={0.7}) "Electric motor efficiency";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters
    power "Volume flow rate vs. electrical power consumption";
  parameter Boolean motorCooledByFluid=false
    "If true, then motor heat is added to fluid stream";
  parameter Boolean use_powerCharacteristic=false
    "Use powerCharacteristic instead of efficiencyCharacteristic";
end PumpData;
