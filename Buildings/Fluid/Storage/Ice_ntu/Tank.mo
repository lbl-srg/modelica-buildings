within Buildings.Fluid.Storage.Ice_ntu;
model Tank "Ice tank with performance based on performance curves"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    final allowFlowReversal = false,
    final tau=tauHex,
    final energyDynamics=energyDynamicsHex,
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol);

  parameter Real SOC_start(min=0, max=1, final unit="1")
   "Start value for state of charge"
    annotation(Dialog(tab = "Initialization"));

  replaceable parameter Buildings.Fluid.Storage.Ice_ntu.Data.Tank.Generic per
    "Performance data" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{40,60},{60,80}}, rotation=0)));

  parameter Modelica.Fluid.Types.Dynamics energyDynamicsHex=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance for heat exchanger internal fluid mass"
    annotation(Evaluate=true, Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tauHex(min=1) = 30
    "Time constant of working fluid through the heat exchanger at nominal flow"
     annotation (Dialog(tab = "Dynamics heat exchanger", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  final parameter Modelica.Units.SI.SpecificHeatCapacity cp=
    Medium.specificHeatCapacityCp(
      Medium.setState_pTX(
        p=Medium.p_default,
        T=273.15,
        X=Medium.X_default))
    "Specific heat capacity of working fluid";
  Modelica.Blocks.Interfaces.RealOutput SOC(
    final unit = "1")
    "state of charge"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0) "Temperature of the fluid leaving at port_b"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(final unit="W")
    "Heat flow rate, positive during charging, negative when melting the ice"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
        iconTransformation(extent={{100,30},{120,50}})));

protected
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-11,-40})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature of fluid"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-40})));

  Modelica.Blocks.Sources.RealExpression TIn(
    final y=Medium.temperature(state=
        Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow)))) "Inlet temperature into tank"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.RealExpression limQ_flow(y=m_flow)
   "Upper/Lower limit for charging/discharging rate"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

public
  BaseClasses.Tank tank(final per=per)
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Modelica.Blocks.Interfaces.RealOutput Ttank(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC",
    min=0) "Temperature of the fluid leaving at port_b" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-90})));
equation
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(points={{-21,-40},{-26,
          -40},{-26,-10},{-9,-10}},                color={191,0,0}));
  connect(temSen.T, T) annotation (Line(points={{-51,-40},{-80,-40},{-80,50},{
          74,50},{74,80},{110,80}},
        color={0,0,127}));
  connect(vol.heatPort, temSen.port) annotation (Line(points={{-9,-10},{-26,-10},
          {-26,-40},{-30,-40}}, color={191,0,0}));
  connect(TIn.y, tank.Tin) annotation (Line(points={{-59,-70},{-40,-70},{-40,-65},
          {-22,-65}}, color={0,0,127}));
  connect(tank.Qbrine, Q_flow) annotation (Line(points={{1,-63},{80,-63},{80,40},
          {110,40}}, color={0,0,127}));
  connect(tank.SOC, SOC) annotation (Line(points={{1,-75},{88,-75},{88,-40},{110,
          -40}}, color={0,0,127}));
  connect(limQ_flow.y, tank.m_flow) annotation (Line(points={{-59,-90},{-32,-90},
          {-32,-75},{-22,-75}}, color={0,0,127}));
  connect(preHeaFlo.Q_flow, gain.y)
    annotation (Line(points={{-1,-40},{19,-40}}, color={0,0,127}));
  connect(tank.Qbrine, gain.u) annotation (Line(points={{1,-63},{60,-63},{60,
          -40},{42,-40}}, color={0,0,127}));
  connect(tank.Ttank, Ttank) annotation (Line(points={{1,-70},{20,-70},{20,-90},
          {110,-90}}, color={0,0,127}));
  annotation (defaultComponentModel="iceTan", Icon(graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,52},{-36,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-24,52},{-8,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{4,52},{20,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{32,52},{48,-54}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-92,6},{92,-4}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{100,72},{140,46}},
          textColor={0,0,88},
          textString="Q_flow"),
        Text(
          extent={{100,-48},{128,-72}},
          textColor={0,0,88},
          textString="mIce"),
        Rectangle(
          extent=DynamicSelect({{70,-60},{84,60}},{{85,-60},{70,-60+(SOC)*120}}),
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{100,-10},{128,-34}},
          textColor={0,0,88},
          textString="SOC"),
        Text(
          extent={{90,110},{124,88}},
          textColor={0,0,88},
          textString="T")}),
    Documentation(info="<html>
<p>The functions are the same as in <a href=\"https://github.com/NREL/ThermalTank\">
NREL/ThermalTank</a>
 </p>
</html>", revisions="<html>
<ul>
<li>
October 10, 2025 by Remi Patureau:<br/>
First implementation.
</li>
</ul>
</html>
"));
end Tank;
