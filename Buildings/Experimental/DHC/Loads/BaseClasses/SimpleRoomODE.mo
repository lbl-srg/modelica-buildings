within Buildings.Experimental.DHC.Loads.BaseClasses;
model SimpleRoomODE
  "Simplified model for assessing room air temperature variations around a set point"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Temperature TOutHea_nominal(displayUnit="degC")
    "Outdoor air temperature at heating nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TIndHea_nominal(displayUnit="degC")
    "Indoor air temperature at heating nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal(min=0) "Heating heat flow rate (for TInd=TIndHea_nominal, TOut=TOutHea_nominal,
    with no internal gains, no solar radiation)"
    annotation (Dialog(group="Nominal condition"));
  parameter Boolean steadyStateInitial=false
    "true initializes T with dT(0)/dt=0, false initializes T with T(0)=TIndHea_nominal"
    annotation (Dialog(group="Initialization"),Evaluate=true);
  parameter Modelica.Units.SI.Time tau=1800
    "Time constant of the indoor temperature";
  Modelica.Blocks.Interfaces.RealInput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Temperature set point for heating or cooling"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput QReq_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Required heat flow rate to meet temperature set point (>=0 for heating)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput QAct_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Actual heating or cooling heat flow rate (>=0 for heating)"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput TAir(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Room air temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  parameter Modelica.Units.SI.ThermalConductance G=-QHea_flow_nominal/(
      TOutHea_nominal - TIndHea_nominal)
    "Lumped thermal conductance representing all temperature dependent heat transfer mechanisms";
initial equation
  if steadyStateInitial then
    der(
      TAir)=0;
  else
    TAir=TIndHea_nominal;
  end if;
equation
  der(
    TAir)*tau=(QAct_flow-QReq_flow)/G+TSet-TAir;
  assert(
    TAir >= 273.15,
    "In "+getInstanceName()+": The computed indoor temperature is below 0°C.");
  annotation (
    defaultComponentName="roo",
    Documentation(
      info="<html>
<p>
This is a first order ODE model assessing the indoor air temperature variations
around a set point, based on the difference between the required and actual
heating or cooling heat flow rate and a minimum set of parameters at nominal conditions.
</p>
<p>
The lumped thermal conductance <i>G</i> representing all heat transfer mechanisms
that depend on the temperature difference with the outside (transmission,
infiltration and ventilation) is assessed from the steady-state energy balance
at heating nominal conditions as
</p>
<p style=\"font-style:italic;\">
0 = Q&#775;<sub>heating, nom</sub> + G (T<sub>out, heating, nom</sub> - T<sub>ind, heating, nom</sub>).
</p>
<p>
Note that it is important for the model representativeness that
Q&#775;<sub>heating, nom</sub> be evaluated in close to steady-state conditions
with no internal heat gains and no solar heat gains.
</p>
<p>
The lumped thermal conductance <i>G</i> is then considered constant for all operating conditions.
</p>
<p>
The required heating or cooling heat flow rate (i.e. the space load) 
<i>Q&#775;<sub>heat_cool, req</sub></i> corresponds to
a steady-state control error equal to zero,
</p>
<p style=\"font-style:italic;\">
0 = Q&#775;<sub>heat_cool, req</sub> +
G (T<sub>out</sub> - T<sub>ind, set</sub>) +
Q&#775;<sub>various</sub>,
</p>
<p>
where <i>Q&#775;<sub>various</sub></i> represent the miscellaneous heat gains.
The indoor temperature variation rate due to an unmet load is given by
</p>
<p style=\"font-style:italic;\">
C &part;T<sub>ind</sub> / &part;t = Q&#775;<sub>heat_cool, act</sub> +
G (T<sub>out</sub> - T<sub>ind</sub>) + Q&#775;<sub>various</sub>,
</p>
<p>
where
<i>Q&#775;<sub>heat_cool, act</sub></i> is the actual heating or cooling heat flow rate and
<i>C</i> is the thermal capacitance of the indoor volume.
The two previous equations yield
</p>
<p style=\"font-style:italic;\">
&tau; &part;T<sub>ind</sub> / &part;t = (Q&#775;<sub>heat_cool, act</sub> - Q&#775;<sub>heat_cool, req</sub>) / G
- T<sub>ind</sub> + T<sub>ind, set</sub>,
</p>
<p>
where <i>&tau; = C / G</i> is the time constant of the indoor temperature.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Text(
          extent={{-88,16},{-8,-14}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="QReq_flow"),
        Text(
          extent={{-88,94},{-52,68}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="TSet"),
        Text(
          extent={{-88,-64},{-8,-94}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="QAct_flow"),
        Text(
          extent={{50,10},{90,-8}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="TAir")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end SimpleRoomODE;
