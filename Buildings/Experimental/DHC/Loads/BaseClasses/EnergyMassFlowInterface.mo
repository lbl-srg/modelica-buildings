within Buildings.Experimental.DHC.Loads.BaseClasses;
model EnergyMassFlowInterface
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Boolean have_masFlo = false
    "Set to true in case of prescribed mass flow rate"
    annotation(Evaluate=true);
  parameter Boolean have_varFlo = true
    "Set to true in case of variable flow system"
    annotation(Evaluate=true, Dialog(enable=not have_masFlo));
  parameter Boolean have_pum
    "Set to true if the system has a pump"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Design heating heat flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TSup_nominal(
    start=if Q_flow_nominal<0 then 280.15 else 333.15)
    "Supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoa_nominal(
    start=if Q_flow_nominal<0 then 294.15 else 293.15)
    "Load temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal
    "Distribution system overall pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Real fra_m_flow_min = if have_pum then 0.1 else 0
    "Minimum flow rate (ratio to nominal)"
    annotation(Dialog(enable=have_pum and not have_masFlo and have_varFlo));
  parameter Modelica.SIunits.Time tau = 600
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput ena
    "Enable signal"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput QPre_flow(final unit="W")
    "Prescribed load"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
              iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,10},{-100,50}})));

  Fluid.Sensors.TemperatureTwoPort senTSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    per(final motorCooledByFluid=false),
    final nominalValuesDefineDefaultPressureCurve=true,
    final use_inputFilter=false,
    final addPowerToMedium=false,
    final dp_nominal=dp_nominal) if have_pum
    "Pump (optional)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Delays.DelayFirstOrder del(
    redeclare final package Medium = Medium,
    final tau=tau,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=m_flow_nominal,
    final nPorts=2)
    "Delayed load on the fluid stream"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
  Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=if not have_pum then 0 else dp_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final Q_flow_nominal=1)
    "Actual load on the fluid stream"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valPreInd(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    from_dp=true,
    final dpValve_nominal=dp_nominal*1/3,
    final dpFixed_nominal=dp_nominal*2/3,
    use_inputFilter=false) if not have_pum
    "Valve (optional)"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  BaseClasses.EnergyMassFlow eneMasFlo(
    final have_masFlo=have_masFlo,
    final have_varFlo=have_varFlo,
    final have_pum=have_pum,
    final Q_flow_nominal=Q_flow_nominal,
    final m_flow_nominal=m_flow_nominal,
    final TSup_nominal=TSup_nominal,
    final TLoa_nominal=TLoa_nominal,
    final fra_m_flow_min=fra_m_flow_min)
    "Block that computes the actual load"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Heat flow rate"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,50})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1/m_flow_nominal)
    "Normalize mass flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-20})));

  Networks.BaseClasses.DifferenceEnthalpyFlowRate senDifEntFlo(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final have_massFlow=true,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate"
    annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(final unit="W")
                    "Difference in enthalpy flow rate between stream 1 and 2"
    annotation (Placement(transformation(origin={120,-60},
                                                         extent={{-20,-20},{20,20}},rotation=0),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=0,origin={120,60})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mPre_flow(final unit="kg/s") if
                          have_masFlo
    "Prescribed mass flow rate"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
equation
  connect(port_a, senTSup.port_a)
    annotation (Line(points={{-100,0},{-90,0}}, color={0,127,255}));
  connect(pum.port_b, del.ports[1]) annotation (Line(points={{10,0},{38,0}},
                           color={0,127,255}));
  connect(valPreInd.port_b, del.ports[1]) annotation (Line(points={{10,-60},{20,
          -60},{20,0},{38,0}}, color={0,127,255}));
  connect(del.ports[2], hea.port_a)
    annotation (Line(points={{42,0},{60,0}},      color={0,127,255}));
  connect(eneMasFlo.m_flow, pum.m_flow_in) annotation (Line(points={{-28,86},{-20,
          86},{-20,20},{0,20},{0,12}}, color={0,0,127}));
  connect(eneMasFlo.Q_flow_actual, hea.u) annotation (Line(points={{-28,80},{52,
          80},{52,6},{58,6}}, color={0,0,127}));
  connect(eneMasFlo.Q_flow_residual, heaFlo.Q_flow)
    annotation (Line(points={{-28,74},{20,74},{20,60}}, color={0,0,127}));
  connect(heaFlo.port, del.heatPort)
    annotation (Line(points={{20,40},{20,10},{30,10}}, color={191,0,0}));
  connect(senTSup.T, eneMasFlo.TSup_actual)
    annotation (Line(points={{-80,11},{-80,77},{-52,77}}, color={0,0,127}));
  connect(ena, eneMasFlo.uEna) annotation (Line(points={{-120,90},{-94,90},{-94,
          88.8},{-52,88.8}},
                         color={255,0,255}));
  connect(QPre_flow, eneMasFlo.QPre_flow) annotation (Line(points={{-120,70},{-94,
          70},{-94,86},{-52,86}}, color={0,0,127}));
  connect(TSupSet, eneMasFlo.TSupSet) annotation (Line(points={{-120,30},{-86,30},
          {-86,80},{-52,80}}, color={0,0,127}));
  connect(senTSup.port_b, senDifEntFlo.port_a1) annotation (Line(points={{-70,0},
          {-66,0},{-66,-60},{-60,-60}}, color={0,127,255}));
  connect(senDifEntFlo.port_b1, pum.port_a) annotation (Line(points={{-40,-60},{
          -20,-60},{-20,0},{-10,0}}, color={0,127,255}));
  connect(senDifEntFlo.port_b1, valPreInd.port_a)
    annotation (Line(points={{-40,-60},{-10,-60}}, color={0,127,255}));
  connect(hea.port_b, senDifEntFlo.port_a2) annotation (Line(points={{80,0},{84,
          0},{84,-72},{-40,-72}}, color={0,127,255}));
  connect(senDifEntFlo.port_b2, port_b) annotation (Line(points={{-60,-72},{-66,
          -72},{-66,-80},{90,-80},{90,0},{100,0}}, color={0,127,255}));
  connect(gai.y, valPreInd.y) annotation (Line(points={{-40,-32},{-40,-40},{0,-40},
          {0,-48}}, color={0,0,127}));
  connect(eneMasFlo.m_flow, gai.u) annotation (Line(points={{-28,86},{-20,86},{-20,
          20},{-40,20},{-40,-8}}, color={0,0,127}));
  connect(senDifEntFlo.dH_flow, dH_flow) annotation (Line(points={{-38,-63},{
          -30,-63},{-30,-68},{40,-68},{40,-60},{120,-60}}, color={0,0,127}));
  connect(senDifEntFlo.m_flow1, eneMasFlo.m_flow_actual) annotation (Line(
        points={{-38,-57},{-30,-57},{-30,-48},{-60,-48},{-60,74},{-52,74}},
        color={0,0,127}));
  connect(mPre_flow, eneMasFlo.mPre_flow) annotation (Line(points={{-120,50},{-90,
          50},{-90,83},{-52,83}}, color={0,0,127}));
  annotation (
    defaultComponentName="eneMasFlo",
    Icon(graphics={   Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
TODO:
Criteria for unmet load:
moving average of Q_flow difference AND
supply temperature mismatch (because a permanent temperature mismatch
only leads to a transient mismatch in Q_flow, so the user
can have bad insight on degraded operating conditions.)
</p>
<p>
The block also implements the following equations that allow to split
the load between a steady state term—the part of the load that can be met
under the actual operating conditions—and a delayed term—the part of the load
that cannot be met and that will contribute to a variation of the average
temperature of the fluid inside the distribution system.
</p>
<ul>
<li>
The delayed term is computed from the load <i>Q&#775;</i> and the
corrected mass flow rate <i>m&#775;Cor</i> (unbounded) as follows.
TODO: Document the correction based on m_flow_actual, cf. case with an
active ETS and a pressure-independent valve.
<p style=\"font-style:italic;\">
Q&#775;Del = Q&#775; * (1 - exp(-max(0, m&#775;Cor - m&#775;Nom) / m&#775;Nom)).
</p>
</li>
<li>
The steady-state term is then simply computed as
<i>Q&#775;Ste = Q&#775; - Q&#775;Del</i>.
</li>
<li>
According to the above equations, when the corrected mass flow rate is
below the nominal mass flow rate, the delayed term is zero and the
steady-state term is equal to the load.
The delayed term corresponds to the part of the corrected mass flow
rate required to meet the load, which exceeds the nominal mass flow rate.
</li>
</ul>
</html>"));
end EnergyMassFlowInterface;
