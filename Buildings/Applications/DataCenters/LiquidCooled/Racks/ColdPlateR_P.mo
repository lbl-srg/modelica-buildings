within Buildings.Applications.DataCenters.LiquidCooled.Racks;
model ColdPlateR_P
  "Model of a cold plate in which heat transfer is characterized by R for different flow rates, and P is input"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(min=0)
    "Design heat flow rate at u=1, also called Thermal Design Power (TDP)"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.TemperatureDifference dT_nominal =
    Q_flow_nominal/(m_flow_nominal*Medium.cp_const)
    "Design temperature differences, used to compute cold plate temperature"
    annotation(Dialog(group="Case temperature"));

  parameter Data.Generic_R_m_flow datTheRes "Thermal resistance data record"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  // Flow resistance
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa") = 50000
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real m = 0.54 "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  parameter Modelica.Units.SI.VolumeFlowRate VColPla_flow_nominal=sum(datTheRes.V_flow)
      /size(datTheRes.V_flow, 1)
    "Design flow rate of one cold plate, used to compute the case temperature"
    annotation (Dialog(group="Case temperature"));
  // For number of rack, we use a Real to simplify solving optimizations that involves this parameter
  parameter Real nColPla=Q_flow_nominal/(VColPla_flow_nominal*Medium.d_const*
      Medium.cp_const*dT_nominal)
    "Number of cold plates, used to compute the case temperature"
    annotation (Dialog(group="Case temperature"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tau=2
    "Time constant of fluid outlet temperature at nominal flow";

  // Initialization
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));

  Modelica.Blocks.Interfaces.RealInput u(final unit="1", min=0)
    "Normalized utilization" annotation (Placement(transformation(extent={{-140,30},
            {-100,70}}),     iconTransformation(extent={{-120,50},{-100,70}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electrical power consumed by IT"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{90,70},{110,90}})));

  Buildings.Applications.DataCenters.LiquidCooled.Racks.BaseClasses.CaseTemperature casTem(
    final datTheRes=datTheRes,
    final V_flow_nominal=m_flow_nominal/Medium.d_const/nColPla) "Case temperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent res(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final m=m)
    "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final T_start=T_start,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final prescribedHeatFlowRate=true,
    final nPorts=2) "Fluid control volume"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Modelica.Units.SI.PressureDifference dp(
    displayUnit="Pa") = res.dp
    "Pressure difference between port_a and port_b";
protected
  Modelica.Blocks.Math.Gain Q_flow(final k=Q_flow_nominal)
    "Gain to compute actual heat flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));

  Modelica.Blocks.Sources.RealExpression VColPla_flow(y(final unit="m3/s") =
      port_a.m_flow/Medium.d_const/nColPla) "Volume flow rate per cold plate"
    annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
  Modelica.Blocks.Sources.RealExpression TIn(
    y(final unit="K",
      displayUnit="degC")
        = Medium.temperature_phX(
            p=port_a.p,
            h=inStream(port_a.h_outflow),
            X=cat(1, inStream(port_a.Xi_outflow), {1 - sum(inStream(port_a.Xi_outflow))})))
      "Inlet temperature"
    annotation (Placement(transformation(extent={{-60,64},{-40,84}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(final alpha=0)
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
  Modelica.Blocks.Math.Gain QCas_flow(final k=1/nColPla)
    "Gain to compute heat flow rate per case"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(Q_flow.u, u) annotation (Line(points={{-82,50},{-120,50}},
                color={0,0,127}));
  connect(Q_flow.y, preHea.Q_flow) annotation (Line(points={{-59,50},{-52,50},{-52,
          20},{-42,20}}, color={0,0,127}));
  connect(preHea.port,vol. heatPort) annotation (Line(points={{-22,20},{-10,20},
          {-10,10},{10,10}},
                        color={191,0,0}));
  connect(res.port_b,vol. ports[1])
    annotation (Line(points={{-20,0},{19,0}}, color={0,127,255}));
  connect(casTem.V_flow, VColPla_flow.y) annotation (Line(points={{19,86},{-28,86},
          {-28,88},{-39,88}}, color={0,0,127}));
  connect(casTem.TIn, TIn.y) annotation (Line(points={{19,80},{-28,80},{-28,74},
          {-39,74}}, color={0,0,127}));
  connect(port_a, res.port_a)
    annotation (Line(points={{-100,0},{-40,0}}, color={0,127,255}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{21,0},{100,0}}, color={0,127,255}));
  connect(Q_flow.y, QCas_flow.u)
    annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  connect(QCas_flow.y, casTem.Q_flow) annotation (Line(points={{-19,50},{-10,50},
          {-10,74},{19,74}}, color={0,0,127}));
  connect(Q_flow.y, P) annotation (Line(points={{-59,50},{-52,50},{-52,32},{88,
          32},{88,90},{110,90},{110,90}}, color={0,0,127}));
annotation (
  defaultComponentName="rac",
  Documentation(
    info="<html>
<p>
Model of IT racks with cold plate heat exchangers based on the characterization
of the Open Compute Project.
</p>
<h4>Electrical and fluid characterization</h4>
<p>
The model takes as a parameter the thermal design power (TDB) <code>Q_flow_nominal</code>
and as an input the utilization <code>u</code>.
The heat added to the coolant fluid is then calculated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q_flow = u Q_flow_nominal.
</p>
<p>
The fluid outlet temperature is computed using a first order delay to mimic
the transient effect. This first order delay is characterized by the user-configurable
time constant <code>tau</code>, set by default to <code>tau=2</code> seconds.
For exact transient response, this value should be identified based on measurements.
</p>
<p>
To compute the pressure drop, the model uses
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent\">
Buildings.Fluid.FixedResistances.PressureDropPartiallyTurbulent</a>.
Therefore, the mass flow rate and pressure drop are related as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m_flow &frasl; m_flow_nominal = (dp &frasl; dp_nominal)<sup>m</sup>,
</p>
<p>
where 
<code>m_flow_nominal</code> is a parameter for the design flow rate,
<code>dp</code> is the pressure difference between inlet and outlet,
<code>dp_nominal</code> is a parameter for the design pressure difference, and
<code>m</code> is a parameter for the flow exponent.
Based on a data fit using the data in Chen et al., (2024), the default value is <code>m=1.85</code>.
The model assumes a default pressure drop <code>dp_nominal</code> of
<code>dp_nominal=50</code> kPa, which is the pressure drop of the OCP specified
cold plate with a 8x1 loop at <i>10</i> l/min flow rate with 25% PGW.
</p>
<h4>Case temperature</h4>
<p>
The model also computes the case temperature, which is the external surface temperature
of the component's packaging, typically the top-center point where a
thermal interface material or heat sink is attached.
</p>
<p>
The case temperature is computed based on the coolant inlet temperature and the
heat dissipated by the chip, using the case-to-inlet thermal resistance of a cold plate.
Thefore, the model assumes sufficient mass flow rate, e.g., this
model simplifies the case temperature as being independent of the coolant mass flow rate,
other than through the variation of the thermal resistance on that mass flow rate.
This follows the convention used in the Open Compute Project report by
Chen et al. (2023), which uses for the case-to-inlet thermal resistance the definition
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = (T_cas - T_inlet) &frasl; Q_flow,
</p>
<p>
where
<code>T_cas</code> is the case temperature,
<code>T_inlet</code> is the coolant inlet temperature and
<code>Q_flow</code> is the heat emitted by the cold plate.
Use of this equation requires knowledge of the heat flow rate of one cold plate <code>Q_flow</code>,
but the component model takes as a parameter the total design heat flow rate <code>Q_flow_nominal</code>.
The model approximates the number of cold plates using
</p>
<p align=\"center\" style=\"font-style:italic;\">
n_col = Q_flow_nominal / (VColPla_flow_nominal * rho * c_p * dT_nominal),
</p>
<p>
where
<code>VColPla_flow_nominal</code> is the design flow rate of a cold plate, approximated by default as the average
value of the data record's volume flow rate, <code>VColPla_flow_nominal = average(datRes.V_flow)</code>,
<code>rho</code> is the fluid density,
<code>c_p</code> is the fluid specific heat capacity, and
<code>dT_nominal</code> is the design temperature difference.
</p>
<p>
This thermal resistance is computed using the data from the data record
<a href=\"modelica://Buildings.Applications.DataCenters.LiquidCooled.Racks.Data.Generic_R_m_flow\">
Buildings.Applications.DataCenters.LiquidCooled.Racks.Data.Generic_R_m_flow</a>.
The computation is done in the block <code>casTem</code>,
which does a data fit for <i>R</i>. The relative error of this data fit
is shown in <code>casTem.relErrR</code>.
</p>
<h4>References</h4>
<p>
Cheng Chen, Dennis Trieu, Tejas Shah, Allen Guo, Jaylen Cheng, Christopher Chapman, Sukhvinder Kang,
Eran Dagan, Assaf Dinstag,Jane Yao.
<a href=\"https://www.opencompute.org/documents/oai-system-liquid-cooling-guidelines-in-ocp-template-mar-3-2023-update-pdf\">
OCP OAI SYSTEM LIQUID COOLING GUIDELINES</a>.
2023.
<p>
</html>",
revisions="<html>
<ul>
<li>
December 16, 2025, by Michael Wetter:<br/>
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
          extent={{-32,50},{32,36}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,28},{32,14}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,8},{32,-6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-34},{32,-48}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-32,-12},{32,-26}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-104,6},{-34,-2}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,4},{102,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,82},{-82,62}},
          textColor={0,0,127},
          textString="u"),
        Line(
          points={{-60,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-40,60},
          rotation=360)}));
end ColdPlateR_P;
