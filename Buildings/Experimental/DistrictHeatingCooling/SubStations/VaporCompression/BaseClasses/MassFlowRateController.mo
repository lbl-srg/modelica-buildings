within Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses;
block MassFlowRateController
  "Controller for the mass flow rate over the consumer on the district energy system side"
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    displayUnit="K") = 4
    "Temperature difference at nominal condition (positive for cooling, negative for heating)";

  parameter Modelica.SIunits.TemperatureDifference dT_min(
    displayUnit="K")= dT_nominal/4 "Minimum temperature difference (positive)";

  parameter Modelica.SIunits.Temperature TUp_limit
    "Limit of upstream temperature beyond which mass flow rate is increased";

  parameter Buildings.Experimental.DistrictHeatingCooling.Types.Consumer consumer
    "Type of consumer"
    annotation(Evaluate=true);

  parameter Real k(min=0) = 1 "Control gain";

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default
    "Specific heat capacity of the fluid";

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Heat to be added to the district loop"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TUp(unit="K")
    "Upstream fluid temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput dTHex(
    unit="K",
    displayUnit="K") "Setpoint for heat exchanger temperature difference"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput m_flow(unit="kg/s")
    "Set point for mass flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

protected
  Modelica.SIunits.TemperatureDifference dTCor
    "Temperature difference used to correct the design value";
equation
  if consumer == Buildings.Experimental.DistrictHeatingCooling.Types.Consumer.Cooling then
    // Chiller.
    // If the upstream temperature is too warm, then increase the flow rate
    // in order to draw in water from the main distribution.
    dTCor = 0;//noEvent(max(0, k * (TUp-TUp_limit)));
    dTHex = 0;//noEvent(max(dT_min, dT_nominal-dTCor));
  else
    // Heat pump.
    // If the upstream temperature is too cold, then increase the flow rate.
    // dT_nominal < 0.
    dTCor = 0;//noEvent(max(0, k * (TUp_limit-TUp)));
    dTHex = 0;//noEvent(min(dT_min, dT_nominal + dTCor));
   end if;
   // fixme: This controller seems not to be required
   //m_flow = Q_flow/(cp_default * dTHex);
   m_flow = Q_flow/(cp_default*dT_nominal);

  annotation (
  defaultComponentName="conMas",
  Documentation(info="<html>
<p>
Controller that outputs the setpoint for the mass flow rate
over the evaporator (for heat pumps) or
condensor (for chillers).
This controller increases the mass flow rate
if the upstream fluid temperature gets too warm (for heat pumps)
or too cold (for chillers).
It is used to stabilize the temperature in a substation that has heating
and cooling. Otherwise, if a heat pump and a chiller were to draw the same
mass flow rate, but their temperature difference is not identical,
the substation would get increasingly too warm or too cold.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MassFlowRateController;
