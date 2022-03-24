within Buildings.Fluid.Boilers.BaseClasses;
partial model PartialBoiler "Boiler base class with efficiency unspecified"
  extends Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol,
    show_T = true,
    final tau=VWat*rho_default/m_flow_nominal);

  parameter Buildings.Fluid.Data.Fuels.Generic fue "Fuel type"
   annotation (choicesAllMatching = true);

  // These parameters can be supplied via Data records
  parameter Modelica.Units.SI.Power Q_flow_nominal "Nominal heating power";
  parameter Modelica.Units.SI.ThermalConductance UA=0.05*Q_flow_nominal/30
    "Overall UA value";
  parameter Modelica.Units.SI.Volume VWat=1.5E-6*Q_flow_nominal
    "Water volume of boiler" annotation (Dialog(tab="Dynamics", enable=not (
          energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.Units.SI.Mass mDry=1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity" annotation (
      Dialog(tab="Dynamics", enable=not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.Units.SI.Efficiency eta_nominal
    "Boiler efficiency at nominal condition";

  input Modelica.Units.SI.Efficiency eta "Boiler efficiency";
  Modelica.Units.SI.Power QFue_flow=y*Q_flow_nominal/eta_nominal
    "Heat released by fuel";
  Modelica.Units.SI.Power QWat_flow=eta*QFue_flow + UAOve.Q_flow
    "Heat transfer from gas into water";
    // The direction of UAOve.Q_flow is from the ambient to the boiler
    //   and therefore it takes a plus size here.
  Modelica.Units.SI.MassFlowRate mFue_flow=QFue_flow/fue.h
    "Fuel mass flow rate";
  Modelica.Units.SI.VolumeFlowRate VFue_flow=mFue_flow/fue.d
    "Fuel volume flow rate";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1) "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final quantity="ThermodynamicTemperature",
    final unit = "K",
    displayUnit = "degC",
    min=0)
    "Temperature of the fluid"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port, can be used to connect to ambient"
    annotation (Placement(transformation(extent={{-10,62}, {10,82}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCapDry(
    C=500*mDry,
    T(start=T_start))
    if not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
    "Heat capacity of boiler metal"
    annotation (Placement(transformation(extent={{-80,12},{-60,32}})));

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-43,-40},{-23,-20}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_in(y=QWat_flow)
    "Heat transfer from gas into water"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature of fluid"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor UAOve(G=UA)
    "Overall thermal conductance (if heatPort is connected)"
    annotation (Placement(transformation(extent={{-48,10},{-28,30}})));

equation
  assert(eta > 0.001, "Efficiency curve is wrong.");

  connect(UAOve.port_b, vol.heatPort) annotation (Line(
      points={{-28,20},{-22,20},{-22,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(UAOve.port_a, heatPort) annotation (Line(
      points={{-48,20},{-52,20},{-52,60},{0,60},{0,72}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCapDry.port, vol.heatPort) annotation (Line(
      points={{-70,12},{-70,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSen.T, T) annotation (Line(
      points={{21,40},{60,40},{60,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(
      points={{-23,-30},{-15,-30},{-15,-10},{-9,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Q_flow_in.y,preHeaFlo. Q_flow) annotation (Line(
      points={{-59,-30},{-43,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.heatPort, temSen.port) annotation (Line(
      points={{-9,-10},{-16,-10},{-16,40},{0,40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation ( Icon(graphics={
        Polygon(
          points={{0,-34},{-12,-52},{14,-52},{0,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={255,255,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Line(
          points={{-100,80},{-80,80},{-80,-44},{-6,-44}},
          smooth=Smooth.None),
        Line(
          points={{100,80},{80,80},{80,4}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{160,144},{40,94}},
          textColor={0,0,0},
          textString=DynamicSelect("T", String(T-273.15, format=".1f"))),
        Text(
          extent={{-38,146},{-158,96}},
          textColor={0,0,0},
          textString=DynamicSelect("y", String(y, format=".2f")))}),
defaultComponentName="boi",
Documentation(info="<html>
<p>
This is a base model of a boiler.
The efficiency specified in extended models.
See <a href=\"Modelica://Buildings.Fluid.Boilers.UsersGuide\">
Buildings.Fluid.Boilers.UsersGuide</a> for details.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 10, 2021, by Hongxiang Fu:<br/>
The heating power output of the boiler is now corrected
by its heat loss to the ambient.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2725\">
#2725</a>.
</li>
<li>
October 4, 2021, by Hongxiang Fu:<br/>
Renamed from the old
<span style=\"font-family: monospace;\">
Buildings.Fluid.Boilers.BoilerPolynomial</span>
and with the efficiency specification removed.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">
#2651</a>.
</li>
</ul>
</html>"));
end PartialBoiler;
