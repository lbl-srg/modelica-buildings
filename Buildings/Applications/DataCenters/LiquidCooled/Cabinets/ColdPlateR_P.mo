within Buildings.Applications.DataCenters.LiquidCooled.Cabinets;
model ColdPlateR_P
  "Model of a cold plate in which heat transfer is characterized by R for different flow rates, and P is input"
  extends Fluid.Interfaces.PartialTwoPort;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=303.15,
              X_a=0.25)
              "Propylene glycol water, 25% mass fraction")));

  parameter Integer nCab = 1 "Number of parallel cabinets";

  parameter Data.Generic_R_m_flow datRes
    "Thermal resistance data record"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  // Flow resistance
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate for one cabinet" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate for one cabinet"
    annotation (Dialog(group="Nominal condition"));
  parameter Real deltaM(min=1E-6) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true,
                  Dialog(group = "Transition to laminar",
                         enable = not linearized));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tau=5
    "Time constant of fluid outlet temperature at nominal flow";

  Modelica.Blocks.Interfaces.RealInput PEle(
    final unit="W",
    min=0)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-120,50},{-100,70}})));

  Buildings.Applications.DataCenters.LiquidCooled.Cabinets.BaseClasses.CaseTemperature
    casTem(datRes=datRes, V_flow_nominal=m_flow_nominal/Medium.d_const)
    "Case temperature"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

protected
  Fluid.FixedResistances.PressureDrop res "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Fluid.Delays.DelayFirstOrder vol(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final tau=tau,
    final prescribedHeatFlowRate=true,
    final nPorts=2) "Fluid control volume"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Fluid.BaseClasses.MassFlowRateMultiplier masFloMul(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final k=nCab) "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier masFloCol(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final k=1/nCab) "Mass flow rate collector"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Gain gain(final k=1/nCab)
    "Gain to reduce PEle to power consumption of one case"
    annotation (Placement(transformation(extent={{-82,50},{-62,70}})));

  Modelica.Blocks.Sources.RealExpression V_flow(
    y(final unit="m3/s") = port_a.m_flow/Medium.d_constant)
    "Volume flow rate"
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
equation
  connect(gain.u, PEle)
    annotation (Line(points={{-84,60},{-120,60}}, color={0,0,127}));
  connect(gain.y, preHea.Q_flow)
    annotation (Line(points={{-61,60},{-52,60},{-52,20},{-42,20}},
                                                 color={0,0,127}));
  connect(preHea.port,vol. heatPort) annotation (Line(points={{-22,20},{-10,20},
          {-10,10},{10,10}},
                        color={191,0,0}));
  connect(res.port_b,vol. ports[1])
    annotation (Line(points={{-20,0},{19,0}}, color={0,127,255}));
  connect(vol.ports[2], masFloMul.port_a)
    annotation (Line(points={{21,0},{60,0}}, color={0,127,255}));
  connect(masFloMul.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, masFloCol.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(masFloCol.port_b, res.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(casTem.Q_flow, gain.y) annotation (Line(points={{-1,74},{-12,74},{-12,
          60},{-61,60}}, color={0,0,127}));
  connect(casTem.V_flow, V_flow.y) annotation (Line(points={{-1,86},{-28,86},{-28,
          88},{-39,88}},        color={0,0,127}));
  connect(casTem.TIn, TIn.y) annotation (Line(points={{-1,80},{-28,80},{-28,74},
          {-39,74}}, color={0,0,127}));
annotation (
  defaultComponentName="cab",
  Documentation(
    info="<html>
<p>
Model of a cold plate heat exchanger of an IT cabinet.
</p>
<p>
The model takes as input the electricity consumption, which is assumed to be
all added to the coolant fluid.
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
R = (T<sub>case</sub> - T<sub>inlet</sub>) &frasl; Q&#775;,
</p>
<p>
where
<i>T<sub>case</sub></i> is the case temperature,
<i>T<sub>inlet</sub></i> is the coolant inlet temperature and
<i>Q&#775;</i> is the heat emitted by the cold plate.
</p>
<p>
This thermal resistance is computed using the data from the data record
<a href=\"modelica://Buildings.Applications.DataCenters.LiquidCooled.Cabinets.Data.Generic_R_m_flow\">
Buildings.Applications.DataCenters.LiquidCooled.Cabinets.Data.Generic_R_m_flow</a>.
The computation is done in the block <code>casTem</code>,
which does a data fit for <i>R</i>. The relative error of this data fit
is shown in <code>casTem.relErrR</code>.
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
    Diagram(graphics={Text(
          extent={{-86,-28},{78,-64}},
          textColor={28,108,200},
          textString="Todo: use resistance that allows dp = m^n for n=1.85 (see data fit).
Make PEle a parameter, and use load as an input")}));
end ColdPlateR_P;
