within Buildings.Fluid.Air.Data.Generic.BaseClasses;
record NominalValue "Nominal conditions for air handling units"
  extends Modelica.Icons.Record;
  //-----------------------------Nominal conditions of the coil-----------------------------//

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Nominal water mass flow rate"
    annotation (Dialog(tab="General",group="Cooling Coil"));

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
    "Nominal air mass flow rate"
    annotation (Dialog(group="Cooling Coil"));

  parameter Modelica.SIunits.PressureDifference dp1_coil_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the coil"
    annotation (Dialog(tab="General",group="Cooling Coil"));

  parameter Modelica.SIunits.PressureDifference dp2_coil_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the coil"
    annotation (Dialog(group="Cooling Coil"));

  parameter Modelica.SIunits.ThermalConductance UA_nominal
    "Thermal conductance at nominal flow, used to compute time constant"
    annotation (Dialog(group="Cooling Coil"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Cooling Coil"));

  parameter Modelica.SIunits.Time tau1 = 20 "Time constant at nominal flow of medium 1"
   annotation (Dialog(group="Cooling Coil",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau2 = 1 "Time constant at nominal flow of medium 2"
   annotation (Dialog(group="Cooling Coil",
                enable=not (energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.SIunits.Time tau_m(min=0) = 20
    "Time constant of metal at nominal UA value"
  annotation(Dialog(tab="General", group="Cooling Coil",
          enable=not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial)));
  parameter Integer nEle(min=1) = 4
    "Number of pipe segments used for discretization in the cooling coil"
    annotation (Dialog(group="Cooling Coil"));

  //------------------Nominal conditions of the humidifier-----------------------------//
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
    "Water mass flow rate at u=1, positive for humidification"
    annotation (Dialog(tab="General",group="Humidifier"));
  parameter Modelica.SIunits.PressureDifference dp_humidifier_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the humidifier"
    annotation (Dialog(tab="General",group="Humidifier"));

 //------------------Nominal conditions of the Electric Heater-----------------------------//
  parameter Modelica.SIunits.PressureDifference dp_heater_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the electric heater"
    annotation (Dialog(tab="General",group="Electric Heater"));
  parameter Modelica.SIunits.HeatFlowRate Q_heater_nominal(min=0)
    "Nominal heating capacity of eletric heater,positive"
    annotation (Dialog(group="Electric Heater"));

 //------------------Nominal conditions of the water-side two-way valve-----------------------------//
  parameter Modelica.SIunits.PressureDifference dp_valve_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the water-side two-way valve"
    annotation (Dialog(tab="General",group="Valve"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NominalValue;
