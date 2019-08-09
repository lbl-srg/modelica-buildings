within Buildings.Applications.DHC.Loads.BaseClasses;
model FirstOrderODE
  "Simplified first order ODE model for computing indoor temperature"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Temperature TOutHea_nominal(displayUnit="degC")
    "Outdoor temperature at heating nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TIndHea_nominal(displayUnit="degC")
    "Indoor temperature at heating nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flowHea_nominal
    "Heating (>0) heat flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = Q_flowHea_nominal
    "Heating (>0) or cooling (<0) heat flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean steadyStateInitial = false
    "true initializes T with dT(0)/dt=0, false initializes T with T(0)=TIndHea_nominal"
     annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.SIunits.Time tau = 7200
    "Time constant of the indoor temperature";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    quantity="ThermodynamicTemperature", unit="K", displayUnit="degC")
    "Setpoint temperature for heating or cooling"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
                     iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flowReq(
    quantity="HeatFlowRate", unit="W")
    "Required heat flow rate to meet setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
                       iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flowAct(
    quantity="HeatFlowRate", unit="W")
    "Actual heating or cooling heat flow rate"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
            iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TInd(
    quantity="ThermodynamicTemperature", unit="K", displayUnit="degC") "Indoor temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  parameter Modelica.SIunits.ThermalConductance G = -Q_flowHea_nominal / (TOutHea_nominal - TIndHea_nominal)
  "Lumped thermal conductance representing all deltaT dependent heat transfer mechanisms";
initial equation
  if steadyStateInitial then
    der(TInd) = 0;
  else
    TInd = TIndHea_nominal;
  end if;
equation
  der(TInd) * tau = (Q_flowAct - Q_flowReq) / G + TSet - TInd;
  annotation (
  defaultComponentName="heaFloEps",
  Documentation(info="<html>
  <p>
  This is a first order ODE model for computing the indoor temperature based on a minimum set of parameters
  at nominal conditions.
  </p>
  <p>
  From the steady-state energy balance at heating nominal conditions:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  0 = Q&#775;<sub>heating, nom</sub> + G * (T<sub>out, heating, nom</sub> - T<sub>ind, heating, nom</sub>)
  </p>
  <p>
  is assessed <i>G</i>: the lumped thermal conductance representing all heat transfer mechanisms that
  depend on the temperature difference with the outside (transmission, infiltration and ventilation). This
  coefficient is then considered constant at all conditions.
  </p>
  <p>
  When the indoor temperature setpoint is met, we have:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  0 = Q&#775;<sub>heat_cool, req</sub> +
  G * (T<sub>out</sub> - T<sub>ind, set</sub>) +
  Q&#775;<sub>various</sub>
  </p>
  <p>
  where
  <i>Q&#775;<sub>heat_cool, req</sub></i> is the required heating or cooling heat flow rate and
  <i>Q&#775;<sub>various</sub></i> represent the miscellaneous heat gains.
  The indoor temperature variation rate due to an unmet load is given by:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  C * &part;T<sub>ind</sub> / &part;t = Q&#775;<sub>heat_cool, act</sub> +
  G * (T<sub>out</sub> - T<sub>ind</sub>) + Q&#775;<sub>various</sub>
  </p>
  <p>
  where
  <i>Q&#775;<sub>heat_cool, act</sub></i> is the actual heating or cooling heat flow rate and
  <i>C</i> (J/K) is the thermal capacitance of the indoor volume.
  The two previous equations lead to:
  </p>
  <p align=\"center\" style=\"font-style:italic;\">
  &tau; * &part;T<sub>ind</sub> / &part;t = (Q&#775;<sub>heat_cool, act</sub> - Q&#775;<sub>heat_cool, req</sub>) / G
  - T<sub>ind</sub> + T<sub>ind, set</sub>
  </p>
  <p>
  where <i>&tau; = C / G</i> (s) is the time constant of the indoor temperature.
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end FirstOrderODE;
