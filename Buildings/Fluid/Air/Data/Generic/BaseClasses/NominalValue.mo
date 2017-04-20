within Buildings.Fluid.Air.Data.Generic.BaseClasses;
record NominalValue "Nominal conditions for air handling units"
  extends Modelica.Icons.Record;
  //-----------------------------Nominal conditions of the coil-----------------------------//
  parameter Modelica.SIunits.Temperature T_a1_nominal=6 + 273.15
    "Nominal water inlet temperature"
    annotation (Dialog(tab="General",group="Cooling Coil"));
  parameter Modelica.SIunits.Temperature T_b1_nominal=11 + 273.15
    "Nominal water outlet temperature"
    annotation (Dialog(tab="General",group="Cooling Coil"));
  parameter Modelica.SIunits.Temperature T_a2_nominal=26 + 273.15
    "Nominal air inlet temperature"
    annotation (Dialog(tab="General",group="Cooling Coil"));
  parameter Modelica.SIunits.Temperature T_b2_nominal=12 + 273.15
    "Nominal air outlet temperature"
    annotation (Dialog(tab="General",group="Cooling Coil"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal=m1_flow_nominal*4200*(T_a1_nominal-T_b1_nominal)
    "Nominal heat transfer"
    annotation (Dialog(tab="General",group="Cooling Coil"));
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Cooling Coil"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Cooling Coil"));

  parameter Modelica.SIunits.PressureDifference dpCoil1_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the coil"
    annotation (Dialog(tab="General",group="Cooling Coil"));

  parameter Modelica.SIunits.PressureDifference dpCoil2_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the coil"
    annotation (Dialog(group="Cooling Coil"));

  parameter Modelica.SIunits.ThermalConductance UA_nominal=Q_flow_nominal/
     Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1_nominal,
        T_b1_nominal,
        T_a2_nominal,
        T_b2_nominal)
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
  parameter Modelica.SIunits.PressureDifference dpHumidifier_nominal(min=0,displayUnit="Pa")=0
    "Nominal pressure difference in the humidifier"
    annotation (Dialog(tab="General",group="Humidifier"));

 //------------------Nominal conditions of the Electric Heater-----------------------------//
  parameter Modelica.SIunits.PressureDifference dpHeater_nominal(min=0,displayUnit="Pa")=0
    "Nominal pressure difference in the electric heater"
    annotation (Dialog(tab="General",group="Electric Heater"));
  parameter Modelica.SIunits.HeatFlowRate QHeater_nominal(min=0)
    "Nominal heating capacity of eletric heater,positive"
    annotation (Dialog(group="Electric Heater"));
  parameter Real effHeater_nominal(min=0.01,max=1)=0.9 "Efficiency of electrical heater"
    annotation (Dialog(group="Electric Heater"));

 //------------------Nominal conditions of the water-side two-way valve-----------------------------//
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(min=0,displayUnit="Pa")
    "Nominal pressure difference in the water-side two-way valve"
    annotation (Dialog(tab="General",group="Valve"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
  <p>
This is the base record of nominal values for air handler models.
</p>
<p>
See the information section of
<a href=\"modelica://Buildings.Fluid.Air.Data.Generic.AirHandlingUnit\">
Buildings.Fluid.Air.Data.Generic.AirHandlingUnit</a>
for a description of the data.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end NominalValue;
