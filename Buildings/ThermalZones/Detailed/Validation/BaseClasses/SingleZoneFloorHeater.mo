within Buildings.ThermalZones.Detailed.Validation.BaseClasses;
model SingleZoneFloorHeater
  "A model with an ideal heater, a fan, a PI controller and an integrator"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  parameter Modelica.SIunits.Volume VRoo
    "Room air volume";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flowrate";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSetRoo(
    unit="K",
    displayUnit="degC")
    "Room setpoint temperature" annotation (Placement(transformation(extent={{-140,
            -80},{-100,-40}}), iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yEHea(
    unit="J")
    "Heating energy"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TRooMea(
    unit="K",
    displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
    iconTransformation(extent={{-140,-110},{-100,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    Ti=900,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC")) "Controller for heater"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    p=273.15 + 10,
    k=20,
    y(unit="K", displayUnit="degC"))
    "Compute the leaving water setpoint temperature"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=200,
    show_T=true) "Ideal heater"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Fan"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Continuous.Integrator EHea "Heating energy"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

equation
  connect(hea.Q_flow, EHea.u) annotation (Line(points={{41,8},{50,8},{50,-80},{
          58,-80}}, color={0,0,127}));
  connect(addPar.y, hea.TSet) annotation (Line(points={{2,-60},{10,-60},{10,8},
          {18,8}}, color={0,0,127}));
  connect(conPID.y, addPar.u)  annotation (Line(points={{-38,-60},{-22,-60}},color={0,0,127}));
  connect(fan.port_b, hea.port_a)
    annotation (Line(points={{-40,0},{20,0}}, color={0,127,255}));
  connect(TRooMea, conPID.u_m)  annotation (Line(points={{-120,-90},{-50,-90},{-50,-72}},color={0,0,127}));
  connect(TSetRoo, conPID.u_s) annotation (Line(points={{-120,-60},{-62,-60}},
                         color={0,0,127}));
  connect(EHea.y, yEHea) annotation (Line(points={{81,-80},{120,-80}},
        color={0,0,127}));
  connect(port_a, fan.port_a) annotation (Line(points={{-100,0},{-60,0}}, color={0,127,255}));
  connect(hea.port_b, port_b)
    annotation (Line(points={{40,0},{100,0}}, color={0,127,255}));
  annotation (
 Icon(coordinateSystem(preserveAspectRatio=false),
 graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  defaultComponentName="heaAndCon",
  Documentation(info = "<html>
<p>
This model includes an ideal heater, a fan, a PI controller and an integrator for the heating energy.
It is used in the validation model
<a href=\"modelica://Buildings.ThermalZones.Detailed.Validation.SingleZoneFloorWithHeating\">
Buildings.ThermalZones.Detailed.Validation.SingleZoneFloorWithHeating</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>March 28, 2020, by Kun Zhang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneFloorHeater;
