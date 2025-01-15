within Buildings.Fluid.HydronicConfigurations.PassiveNetworks.Examples;
model DualMixing
  "Model illustrating the operation of a dual mixing circuit"
  extends BaseClasses.PartialPassivePrimary(
    typ=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating,
    m1_flow_nominal=if abs(TLiqSup_nominal - TLiqEnt_nominal) > Modelica.Constants.eps
      then m2_flow_nominal*(TLiqEnt_nominal - TLiqLvg_nominal)/(TLiqSup_nominal - TLiqLvg_nominal)
      else 0.95*m2_flow_nominal,
    TLiqEnt_nominal=35 + 273.15,
    TLiqLvg_nominal=25 + 273.15,
    TLiqSup_nominal=60 + 273.15,
    del1(nPorts=2),
    ref(use_T_in=true));

  parameter Real kSizBal(final min=0) = 1.0
    "Sizing factor for bypass balancing valve (1 means balanced)"
    annotation(Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal(final min=0)=
    nTer * mTer_flow_nominal
    "Mass flow rate in consumer circuit at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=
    abs(loa.loa.Q_flow_nominal) / 3 / 1015
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=
    24 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions";

  Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing con(
    typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.NoVariableInput,
    final typCtl=typ,
    redeclare final package Medium=MediumLiq,
    final energyDynamics=energyDynamics,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    dp1_nominal=res1.dp_nominal,
    final dp2_nominal=dpPip_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal,
    final dpBal3_nominal=kSizBal * (con.dpValve_nominal + res1.dp_nominal))
    "Hydronic connection"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl loa(
      redeclare final package MediumLiq = MediumLiq,
      final typ=typ,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final mAir_flow_nominal=mAir_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      final TLiqEntChg_nominal=TLiqEntChg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(
    table=[0,0; 6,0; 6,1; 15,1; 15,1; 22,1; 22,0; 24,0],
    timeScale=3600,
    period=86400) "Operating mode (time schedule)"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2Set(
    y(final unit="K", displayUnit="degC"),
    final k=TLiqEnt_nominal) "Consumer circuit temperature set point"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T1Set(
    y(final unit="K", displayUnit="degC"),
    final k=TLiqSup_nominal) "Primary circuit temperature set point"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));
  ActiveNetworks.Examples.BaseClasses.LoadThreeWayValveControl loa1(
    redeclare final package MediumLiq = MediumLiq,
    final typ=typ,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final mAir_flow_nominal=mAir_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final phiAirEnt_nominal=phiAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal,
    final TLiqEntChg_nominal=TLiqEntChg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=con.pum.m_flow_nominal - loa.mLiq_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Delays.DelayFirstOrder del2(
    redeclare final package Medium = MediumLiq,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=m2_flow_nominal,
    nPorts=3) "Fluid transport delay"
    annotation (Placement(transformation(extent={{30,-20},{50,-40}})));
equation
  connect(con.port_b2, loa.port_a)
    annotation (Line(points={{4,-20},{4,0},{20,0},{20,30}},
                                                      color={0,127,255}));
  connect(con.port_b1, del1.ports[2])
    annotation (Line(points={{16,-40},{20,-40},{20,-80}}, color={0,127,255}));
  connect(mode.y[1], loa.mode) annotation (Line(points={{-98,80},{-20,80},{-20,
          34},{18,34}},
                    color={255,127,0}));
  connect(mode.y[1], con.mode) annotation (Line(points={{-98,80},{-20,80},{-20,
          -22},{-2,-22}}, color={255,127,0}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,120},{-10,120},{-10,
          38},{18,38}}, color={0,0,127}));
  connect(res1.port_b, con.port_a1) annotation (Line(points={{-10,-60},{0,-60},
          {0,-40},{4,-40}}, color={0,127,255}));
  connect(con.port_b2, res2.port_a)
    annotation (Line(points={{4,-20},{4,0},{50,0}}, color={0,127,255}));
  connect(res2.port_b, loa1.port_a)
    annotation (Line(points={{70,0},{80,0},{80,30}}, color={0,127,255}));
  connect(del2.ports[1], con.port_a2) annotation (Line(points={{38.6667,-20},{
          28,-20},{28,-20},{16,-20}},  color={0,127,255}));
  connect(loa.port_b, del2.ports[2]) annotation (Line(points={{40,30},{40,6},{40,
          -20},{40,-20}}, color={0,127,255}));
  connect(loa1.port_b, del2.ports[3]) annotation (Line(points={{100,30},{100,
          -20},{41.3333,-20}},
                          color={0,127,255}));
  connect(mode.y[1], loa1.mode) annotation (Line(points={{-98,80},{60,80},{60,
          34},{78,34}},
                    color={255,127,0}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,120},{70,120},{70,38},
          {78,38}}, color={0,0,127}));
  connect(T1Set.y, ref.T_in) annotation (Line(points={{-98,-120},{-90,-120},{-90,
          -92},{-112,-92},{-112,-74},{-102,-74}}, color={0,0,127}));
  connect(T2Set.y, con.set) annotation (Line(points={{-98,-30},{-8,-30},{-8,-34},
          {-2,-34}}, color={0,0,127}));
annotation (
experiment(
    StopTime=86400,
    Tolerance=1e-6),
__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/PassiveNetworks/Examples/DualMixing.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model represents a heating system where the configuration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing\">
Buildings.Fluid.HydronicConfigurations.PassiveNetworks.DualMixing</a>
serves as the interface between a variable flow primary circuit
and a constant flow secondary circuit.
The secondary supply temperature is constant and lower
than the primary circuit.
</p>
<p>
The fixed bypass of the dual mixing circuit is balanced at design conditions
if <code>kSizBal=1</code>.
Selecting a lower value such as <code>kSizBal=0.6</code> illustrates
the operation with an oversized balancing valve, yielding
a lower pressure drop.
One can observe that the secondary supply temperature set point cannot
be met despite the control valve being fully open.
The secondary distribution pump operates with sufficient head
as the design flow rate is met in the consumer circuit.
This is the low pressure differential at the boundaries
of the control valve due to the oversized balancing valve
that creates the primary flow shortage and prevents from
serving the load properly.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end DualMixing;
