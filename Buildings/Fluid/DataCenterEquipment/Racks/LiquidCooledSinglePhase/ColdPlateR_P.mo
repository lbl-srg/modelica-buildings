within Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase;
model ColdPlateR_P
  "Model of a cold plate in which heat transfer is characterized by R for different flow rates, and utilization is input"
  extends Buildings.Fluid.DataCenterEquipment.Racks.BaseClasses.PartialRack(
    redeclare replaceable Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.Generic dat
    constrainedby Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.Generic,
    vol(nPorts=2));

  final parameter Modelica.Units.SI.TemperatureDifference dT_nominal=dat.PIT_nominal/
    (dat.m_flow_nominal*cp_default)
    "Design temperature differences, used to compute cold plate temperature"
    annotation (Dialog(group="Case temperature"));


  parameter Modelica.Units.SI.VolumeFlowRate VColPla_flow_nominal=sum(dat.theRes.V_flow)
      /size(dat.theRes.V_flow, 1)
    "Design flow rate of one cold plate, used to compute the case temperature"
    annotation (Dialog(group="Case temperature"));
  // For number of rack, we use a Real to simplify solving optimizations that involves this parameter
  parameter Real nColPla=dat.PIT_nominal/
    (VColPla_flow_nominal*d_default*cp_default*dT_nominal)
    "Number of cold plates, used to compute the case temperature"
    annotation (Dialog(group="Case temperature"));

  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") = preDro.dp
    "Pressure difference between port_a and port_b";

  Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.BaseClasses.CaseTemperature casTem(
    final dat=dat.theRes,
    final V_flow_nominal=dat.m_flow_nominal/d_default/nColPla)
    "Case temperature"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

protected
  parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default values";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=state_default)
    "Specific heat capacity";
  parameter Modelica.Units.SI.Density d_default=
    Medium.density(state=state_default)
    "Specific heat capacity";

  Modelica.Blocks.Sources.RealExpression VColPla_flow(y(final unit="m3/s") =
      port_a.m_flow/d_default/nColPla) "Volume flow rate per cold plate"
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

  Fluid.FixedResistances.PressureDrop preDro(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=dat.m_flow_nominal,
    final dp_nominal=dat.dp_nominal,
    final n=dat.n) "Flow resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

protected
  Modelica.Blocks.Math.Gain QCas_flow(final k=1/nColPla)
    "Gain to compute heat flow rate per case"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(casTem.V_flow, VColPla_flow.y) annotation (Line(points={{19,86},{-28,86},
          {-28,88},{-39,88}}, color={0,0,127}));
  connect(casTem.TIn, TIn.y) annotation (Line(points={{19,80},{-28,80},{-28,74},
          {-39,74}}, color={0,0,127}));
  connect(QCas_flow.y, casTem.Q_flow) annotation (Line(points={{-19,50},{-10,50},
          {-10,74},{19,74}}, color={0,0,127}));
  connect(preDro.port_b, vol.ports[1])
    annotation (Line(points={{-40,0},{60,0}}, color={0,127,255}));
  connect(preDro.port_a, port_a)
    annotation (Line(points={{-60,0},{-100,0}}, color={0,127,255}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(QCas_flow.u, P)
    annotation (Line(points={{-42,50},{-120,50}}, color={0,0,127}));
  connect(P, preHea.Q_flow) annotation (Line(points={{-120,50},{-60,50},{-60,10},
          {20,10}}, color={0,0,127}));
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
The model takes as an input the electrical power conumption  <code>P</code>
and adds it as heat added to the coolant fluid
</p>
<p align=\"center\" style=\"font-style:italic;\">
Q_flow = P.
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
but the component model takes as a parameter the total design heat flow rate <code>PIT_nominal</code>.
The model approximates the number of cold plates using
</p>
<p align=\"center\" style=\"font-style:italic;\">
n_col = PIT_nominal / (VColPla_flow_nominal * rho * c_p * dT_nominal),
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
<a href=\"modelica://Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.BaseClasses.Generic_R_m_flow\">
Buildings.Fluid.DataCenterEquipment.Racks.LiquidCooledSinglePhase.Data.Generic_R_m_flow</a>.
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
</p>
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
          extent={{40,4},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-106,4},{-40,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end ColdPlateR_P;
