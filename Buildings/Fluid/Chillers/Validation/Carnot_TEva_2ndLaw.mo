within Buildings.Fluid.Chillers.Validation;
model Carnot_TEva_2ndLaw
  "Test model to verify that the 2nd law is not violated"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=-4
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=4
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal = 3 "Chiller COP";
  parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal = -100E3
    "Evaporator heat flow rate";
  final parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=
    QEva_flow_nominal/dTEva_nominal/4200
    "Nominal mass flow rate at chilled water side";

  final parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=
    -m2_flow_nominal/dTCon_nominal*dTEva_nominal
    "Nominal mass flow rate at condeser water side";

  Modelica.Blocks.Sources.Constant TEvaIn(k=273.15 + 20)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Constant dTEva(k=dTEva_nominal)
    "Temperature difference over evaporator"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Math.Add TSetEvaLvg
    "Set point for evaporator leaving temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Ramp dTConEva(
    duration=1,
    offset=25,
    height=-25)
               "Temperature lift condenser inlet minus evaporator outlet"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Math.Add TConIn "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{0,6},{20,26}})));
  Chiller chi_b(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final dTEva_nominal=dTEva_nominal,
    final dTCon_nominal=dTCon_nominal,
    final QEva_flow_nominal=QEva_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_nominal=m1_flow_nominal)
    "Chiller model that uses port_b to compute Carnot efficiency" annotation (
      Placement(transformation(extent={{60,-40},{80,-20}})));

protected
  model Chiller "Subsystem model with the chiller"

   replaceable package Medium1 = Modelica.Media.Interfaces.PartialMedium
      "Medium model";
   replaceable package Medium2 = Modelica.Media.Interfaces.PartialMedium
      "Medium model";

    parameter Modelica.SIunits.TemperatureDifference dTEva_nominal
      "Temperature difference evaporator outlet-inlet";
    parameter Modelica.SIunits.TemperatureDifference dTCon_nominal
      "Temperature difference condenser outlet-inlet";
    parameter Modelica.SIunits.HeatFlowRate QEva_flow_nominal
      "Evaporator heat flow rate";
    parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
      "Nominal mass flow rate at condeser water side";
    parameter Modelica.SIunits.MassFlowRate m2_flow_nominal
      "Nominal mass flow rate at chilled water side";

    Buildings.Fluid.Sources.MassFlowSource_T sou1(
      redeclare package Medium = Medium1,
      nPorts=1,
      use_m_flow_in=false,
      use_T_in=true,
      m_flow=m1_flow_nominal)
                     "Mass flow rate source"
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
    Buildings.Fluid.Sources.FixedBoundary sin1(redeclare package Medium = Medium2, nPorts=1)
      "Pressure source" annotation (Placement(transformation(extent={{-10,-10},{
              10,10}}, origin={-88,-50})));
    Buildings.Fluid.Chillers.Carnot_TEva chi(
      redeclare package Medium1 = Medium1,
      redeclare package Medium2 = Medium2,
      dTEva_nominal=dTEva_nominal,
      dTCon_nominal=dTCon_nominal,
      m2_flow_nominal=m2_flow_nominal,
      show_T=true,
      QEva_flow_nominal=QEva_flow_nominal,
      allowFlowReversal1=false,
      allowFlowReversal2=false,
      etaCarnot_nominal=0.3,
      dp1_nominal=0,
      dp2_nominal=0,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      use_eta_Carnot_nominal=true) "Chiller model"
      annotation (Placement(transformation(extent={{6,-48},{26,-28}})));
    Buildings.Fluid.Sources.MassFlowSource_T sou2(
      redeclare package Medium = Medium2,
      m_flow=m2_flow_nominal,
      use_T_in=true,
      T=293.15,
      nPorts=1) "Mass flow rate source"
      annotation (Placement(transformation(extent={{102,-60},{82,-40}})));
    Buildings.Fluid.Sensors.EntropyFlowRate S_a1(
      redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal,
      tau=0) "Entropy flow rate sensor"
      annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
    Buildings.Fluid.Sensors.EntropyFlowRate S_a2(
      redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal,
      tau=0) "Entropy flow rate sensor"
      annotation (Placement(transformation(extent={{-30,-60},{-50,-40}})));
    Buildings.Fluid.Sensors.EntropyFlowRate S_a3(
      redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal,
      tau=0) "Entropy flow rate sensor"
      annotation (Placement(transformation(extent={{58,-60},{38,-40}})));
    Buildings.Fluid.Sensors.EntropyFlowRate S_a4(
      redeclare package Medium = Medium1,
      m_flow_nominal=m1_flow_nominal,
      tau=0) "Entropy flow rate sensor"
      annotation (Placement(transformation(extent={{38,-20},{58,0}})));
    Buildings.Fluid.Sources.FixedBoundary sin2(redeclare package Medium = Medium2, nPorts=1)
      "Pressure source" annotation (Placement(transformation(extent={{10,-10},{-10,
              10}}, origin={88,-10})));
    Modelica.Blocks.Math.Add SIn_flow
      "Entropy carried by flow that goes into the chiller"
      annotation (Placement(transformation(extent={{60,40},{80,60}})));
    Modelica.Blocks.Math.Add SOut_flow
      "Entropy carried by flow that leaves the chiller"
      annotation (Placement(transformation(extent={{60,10},{80,30}})));
    Modelica.Blocks.Math.Add dS_flow(k1=-1)
      "Change in entropy inflow and outflow"
      annotation (Placement(transformation(extent={{100,30},{120,50}})));

    Modelica.Blocks.Interfaces.RealInput TSetEvaLea(unit="K")
      "Set point for evaporator leaving temperature" annotation (Placement(
          transformation(extent={{-144,10},{-120,30}})));
    Modelica.Blocks.Interfaces.RealOutput SGen_flow "Entropy generated"
      annotation (Placement(transformation(extent={{140,30},{164,50}})));
    Modelica.Blocks.Interfaces.RealInput TConIn(final unit="K", displayUnit=
          "degC") "Condenser inlet temperature" annotation (Placement(
          transformation(extent={{-144,-30},{-120,-10}})));
    Modelica.Blocks.Interfaces.RealInput TEvaIn(final unit="K", displayUnit=
          "degC") "Evaporator inlet temperature" annotation (Placement(
          transformation(
          rotation=180,
          extent={{-12,-10},{12,10}},
          origin={152,-46})));
  equation
    assert(SGen_flow > 0, "Entropy generated is zero or negative, which violates the 2nd law.
  This is because the model is configured to use the inlet temperatures
  to compute the Carnot efficiency, which can lead to non-physical results.",
    level = AssertionLevel.warning);
    connect(SIn_flow.y, dS_flow.u1)
      annotation (Line(points={{81,50},{88,50},{88,46},{98,46}},
                                                               color={0,0,127}));
    connect(sin1.ports[1],S_a2. port_b) annotation (Line(points={{-78,-50},{-78,
            -50},{-50,-50}},
                         color={0,127,255}));
    connect(sou1.ports[1],S_a1. port_a) annotation (Line(points={{-80,-10},{-80,
            -10},{-50,-10}},
                        color={0,127,255}));
    connect(S_a1.port_b,chi. port_a1) annotation (Line(points={{-30,-10},{-12,-10},
            {-12,-32},{6,-32}}, color={0,127,255}));
    connect(chi.port_b1,S_a4. port_a) annotation (Line(points={{26,-32},{32,-32},
            {32,-10},{38,-10}},color={0,127,255}));
    connect(S_a4.port_b,sin2. ports[1])
      annotation (Line(points={{58,-10},{64,-10},{78,-10}}, color={0,127,255}));
    connect(S_a3.port_a,sou2. ports[1]) annotation (Line(points={{58,-50},{70,-50},
            {82,-50}},  color={0,127,255}));
    connect(S_a2.port_a,chi. port_b2) annotation (Line(points={{-30,-50},{-12,-50},
            {-12,-44},{6,-44}}, color={0,127,255}));
    connect(S_a3.port_b,chi. port_a2) annotation (Line(points={{38,-50},{36,-50},
            {36,-44},{26,-44}}, color={0,127,255}));
    connect(S_a4.S_flow,SOut_flow. u2)
      annotation (Line(points={{48,1},{48,14},{58,14}},     color={0,0,127}));
    connect(S_a2.S_flow,SOut_flow. u1) annotation (Line(points={{-40,-39},{-40,-30},
            {-20,-30},{-20,26},{58,26}},   color={0,0,127}));
    connect(S_a3.S_flow,SIn_flow. u2) annotation (Line(points={{48,-39},{48,-28},
            {30,-28},{30,44},{58,44}},color={0,0,127}));
    connect(S_a1.S_flow,SIn_flow. u1) annotation (Line(points={{-40,1},{-40,1},{
            -40,56},{58,56}},       color={0,0,127}));
    connect(SOut_flow.y,dS_flow. u2) annotation (Line(points={{81,20},{88,20},{88,
            34},{98,34}},   color={0,0,127}));
    connect(TSetEvaLea, chi.TSet) annotation (Line(points={{-132,20},{-132,20},
            {-6,20},{-6,-28},{4,-28},{4,-29}}, color={0,0,127}));
    connect(SGen_flow, dS_flow.y)
      annotation (Line(points={{152,40},{126,40},{121,40}}, color={0,0,127}));
    connect(TConIn, sou1.T_in) annotation (Line(points={{-132,-20},{-132,-20},{
            -116,-20},{-110,-20},{-110,-6},{-102,-6}}, color={0,0,127}));
    connect(TEvaIn, sou2.T_in) annotation (Line(points={{152,-46},{152,-46},{
            104,-46}}, color={0,0,127}));
    annotation (Diagram(coordinateSystem(extent={{-120,-100},{140,100}})), Icon(
          coordinateSystem(extent={{-120,-100},{140,100}})));
  end Chiller;
equation
  connect(TSetEvaLvg.u1, TEvaIn.y) annotation (Line(points={{-42,66},{-50,66},{
          -50,80},{-59,80}},
                         color={0,0,127}));
  connect(dTEva.y, TSetEvaLvg.u2) annotation (Line(points={{-59,50},{-50,50},{
          -50,54},{-42,54}},
                         color={0,0,127}));
  connect(TSetEvaLvg.y, TConIn.u1) annotation (Line(points={{-19,60},{-10,60},{
          -10,22},{-2,22}},
                       color={0,0,127}));
  connect(dTConEva.y, TConIn.u2) annotation (Line(points={{-59,10},{-30,10},{-2,
          10}},        color={0,0,127}));
  connect(TEvaIn.y, chi_b.TEvaIn) annotation (Line(points={{-59,80},{-59,80},{
          90,80},{90,-24},{90,-34.6},{80.9231,-34.6}},          color={0,0,127}));
  connect(TSetEvaLvg.y, chi_b.TSetEvaLea) annotation (Line(points={{-19,60},{
          -10,60},{-10,-28},{59.0769,-28}},
                                          color={0,0,127}));
  connect(chi_b.TConIn, TConIn.y) annotation (Line(points={{59.0769,-32},{40,
          -32},{40,16},{21,16}},                color={0,0,127}));

  annotation (experiment(Tolerance=1e-06, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Validation/Carnot_TEva_2ndLaw.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example verifies that the 2nd law of thermodynamics is not violated
despite of a very small temperature lift.
</p>
</html>", revisions="<html>
<ul>
<li>
January 9, 2017, by Michael Wetter:<br/>
Renamed internal protected class <code>Chiller</code> to be upper-case.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
Updated model because the option to use the inlet temperatures to compute the COP
has been removed.
</li>
<li>
November 18, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Carnot_TEva_2ndLaw;
