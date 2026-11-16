within Buildings.Fluid.DataCenters.Racks.Hybrid.BaseClasses;
partial model Air
  "Partial rack model for air-cooled components"

  replaceable package MediumAir = Modelica.Media.Interfaces.PartialMedium
    "Medium for air cooling loop"
      annotation (choices(
        choice(redeclare package MediumAir = Buildings.Media.Air "Air")));

  replaceable parameter Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirRearDoorHexPassive.Generic dat
    "Performance data"
    annotation (
      Dialog(group="Performance data"),
      Placement(transformation(extent={{60,52},{80,72}})));

  // Air-cooled parameters
  parameter Modelica.Fluid.Types.Dynamics energyDynamicsAir=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for air-cooled component: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Air cooling"));

  parameter Modelica.Units.SI.Time tauAir=2
    "Time constant of air outlet temperature at nominal flow"
    annotation(Dialog(tab="Dynamics", group="Air cooling"));

  parameter Modelica.Units.SI.Temperature TAir_start = 293.15
    "Start value of air temperature"
    annotation(Dialog(tab = "Initialization", group="Air cooling"));

  // Fan control
  parameter Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy fanControl =
    Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy.Load
    "Type of fan control strategy"
    annotation(Dialog(
      group = "Fan controller"));

  parameter Real fanSpeed[:,:]=[0.0,0.0; 1.0,1.0]
    "Load and fan speed matrix (1st column normalized IT load, 2nd fan speed), e.g., fanSpeed=[0, 0; 0.5, 0.7; 1, 1])"
    annotation(Dialog(
      enable=(fanControl == Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy.Load),
      group = "Fan controller"));
  parameter Modelica.Units.SI.Temperature TAirOut_set=dat.air.TOut_nominal
    "Set point temperature for rack outlet air" annotation (Dialog(enable=(
          fanControl == Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy.OutletTemperature),
        group="Fan controller"));
  parameter Real k=1 "Gain of fan PI controller"
    annotation(Dialog(
      enable=(fanControl == Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy.OutletTemperature),
      group = "Fan controller"));
  parameter Modelica.Units.SI.Time Ti=60
    "Integrator time constant of fan PI controller"
    annotation(Dialog(
      enable=(fanControl == Buildings.Fluid.DataCenters.Racks.FanControllers.Types.Strategy.OutletTemperature),
      group = "Fan controller"));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  // Fluid ports
  Modelica.Fluid.Interfaces.FluidPort_a portAir_a(
    redeclare package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0))
    "Air cooling inlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),
      iconTransformation(extent={{-110,-50},{-90,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b portAir_b(
    redeclare package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0))
    "Air cooling outlet port"
    annotation (Placement(transformation(extent={{92,-50},{112,-30}}),
      iconTransformation(extent={{92,-50},{112,-30}})));

  // Control inputs on the left
  Modelica.Blocks.Interfaces.RealInput PAir(final unit="W", min=0)
    "Power consumed by air-cooled IT"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-120,-90},{-100,-70}})));

  // Power outputs on the right
  Modelica.Blocks.Interfaces.RealOutput PAirTot(final unit="W", min=0)
    "Electric power consumed by air-cooled IT, including fan energy"
    annotation (Placement(transformation(extent={{100,-80},{120,-60}}),
        iconTransformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Interfaces.RealOutput PAirFan(final unit="W", min=0)
    "Electric power consumed by fan for air-cooled IT" annotation (Placement(
        transformation(extent={{100,-102},{120,-82}}), iconTransformation(
          extent={{100,-110},{120,-90}})));

  // Component instances
  Buildings.Fluid.DataCenters.Racks.Air.Rack_P air(
    redeclare package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.air,
    final energyDynamics=energyDynamicsAir,
    final tau=tauAir,
    final T_start=TAir_start,
    final fanControl=fanControl,
    final fanSpeed=fanSpeed,
    final TAirOut_set=TAirOut_set,
    final k=k,
    final Ti=Ti)
    "Air-cooled rack component"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation
  connect(portAir_a, air.port_a)
    annotation (Line(points={{-100,-40},{-10,-40}}, color={0,127,255}));

  connect(PAir, air.P) annotation (Line(points={{-120,-90},{-30,-90},{-30,-34},
          {-11,-34}}, color={0,0,127}));
  connect(air.PTot, PAirTot) annotation (Line(points={{11,-32},{86,-32},{86,-70},
          {110,-70}}, color={0,0,127}));
  connect(air.PFan, PAirFan) annotation (Line(points={{11,-35},{80,-35},{80,-92},
          {110,-92}}, color={0,0,127}));
annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
This is a partial model of an IT rack with air-cooled components.
The air cooling component with integrated fans is based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Air.Rack_P\">
Buildings.Fluid.DataCenters.Racks.Air.Rack_P</a>.
</p>
<p>
The model has fluid ports for the air cooling loop.
For air cooling, <code>portAir_a</code> and <code>portAir_b</code> serve as the inlet and outlet ports.
The input <code>PAir</code> specifies the power consumption for the air-cooled IT equipment.
Note that <code>PAir</code> does not include the power to operate the fan, as this is an output of the model.
</p>
<p>
The model provides two power consumption outputs.
The output <code>PAirTot</code> is the total electric power consumed by air-cooled IT, including fan energy.
The output <code>PAirFan</code> is the electric power consumed by the fan for air-cooled IT.
</p>
<p>
This is a partial model because it does not connect the outlet port <code>air.port_b</code>
of the air-cooled component to the model output <code>portAir_b</code>.
This connection must be made by the model that extends this partial model.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,62},{40,-58}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-12},{32,-26}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-34},{32,-48}},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,-36},{100,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-106,-36},{-40,-44}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,140,72},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-139,-104},{161,-144}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{64,-62},{94,-98}},
          textColor={0,0,127},
          textString="PAirTot"),
        Text(
          extent={{64,-86},{94,-122}},
          textColor={0,0,127},
          textString="PAirFan"),
        Text(
          extent={{-92,-62},{-62,-98}},
          textColor={0,0,127},
          textString="PAir")}));
end Air;
