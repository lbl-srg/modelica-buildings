within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model ElectricHeater "Model for electric heater"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    final computeFlowResistance=(abs(dp_nominal) > Modelica.Constants.eps));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.Units.SI.Efficiency eta(max=1) = 1
    "Effciency of electrical heater";
  parameter Modelica.Units.SI.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)" annotation (Evaluate=true);
  parameter Modelica.Units.SI.Temperature T_start=Medium.T_default
    "Start value of temperature" annotation (Dialog(tab="Initialization"));
   // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Modelica.Units.SI.Time tau(min=0) = 10 "Time constant at nominal flow rate (used
    if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Heat flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final quantity="Power",
    final unit="W")
   "Electrical power consumed"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable heater, or false to disable heater"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    final quantity = "ThermodynamicTemperature",
    displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));


  Buildings.Fluid.HeatExchangers.Heater_T hea(
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final tau=tau,
    final from_dp=from_dp,
    final linearizeFlowResistance=linearizeFlowResistance,
    final deltaM=deltaM,
    final m_flow_small=m_flow_small,
    final show_T=show_T,
    final homotopyInitialization=homotopyInitialization,
    final allowFlowReversal=allowFlowReversal,
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final QMax_flow=QMax_flow)
    "Heater with prescribed temperature"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Math.Gain gaiEff(final k=1/eta) "Gain for efficiency"
    annotation (Placement(transformation(extent={{58,-70},{78,-50}})));
protected
  Modelica.Blocks.Logical.Switch swi "Switch for temperature setpoint"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Modelica.Blocks.Sources.Constant zer(final k=-273.15)
                                                  "Zero signal"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(port_a, hea.port_a)
    annotation (Line(points={{-100,0},{-54,0},{-8,0}}, color={0,127,255}));
  connect(hea.port_b, port_b)
    annotation (Line(points={{12,0},{56,0},{100,0}}, color={0,127,255}));
  connect(hea.Q_flow, Q_flow)
    annotation (Line(points={{13,8},{40,8},{40,80},{110,80}}, color={0,0,127}));
  connect(on, swi.u2)
    annotation (Line(points={{-120,30},{-80,30},{-62,30}}, color={255,0,255}));
  connect(swi.y, hea.TSet)
    annotation (Line(points={{-39,30},{-20,30},{-20,8},{-10,8}}, color={0,0,127}));
  connect(TSet, swi.u1)
    annotation (Line(points={{-120,80},{-80,80},{-80,38},{-62,38}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-79,-30},{-70,-30},{-70,22},{-62,22}}, color={0,0,127}));
  connect(hea.Q_flow, gaiEff.u)
    annotation (Line(points={{13,8},{40,8},{40,-60},{56,-60}}, color={0,0,127}));
  connect(gaiEff.y, P)
    annotation (Line(points={{79,-60},{90,-60},{90,-60},{110,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,34},{-34,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{18,-6},{62,-52}},
          textColor={255,255,255},
          textString="+"),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,60},{70,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{26,108},{94,84}},
          textColor={0,0,127},
          textString="Q_flow"),
        Text(
          extent={{-110,102},{-74,84}},
          textColor={0,0,127},
          textString="T"),
        Rectangle(
          extent={{-70,60},{-66,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Model for an ideal heater that controls its outlet temperature to
a prescribed outlet temperature with constant efficiency.
</p>
<p>
The switch model <code>swi</code> is used to turn on/off the heater.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>May 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricHeater;
