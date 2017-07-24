within Buildings.ChillerWSE;
model IntegratedPrimarySecondary
  "Integrated waterside economizer on the load side in a primary-secondary chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialChillerWSE(
    final nVal=5,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,nChi*mChiller2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});

 // Dynamics
 parameter Modelica.SIunits.Time tauPump = 30
  "Time constant of fluid volume for nominal flow in pumps, used if energy or mass balance is dynamic"
   annotation (Dialog(tab = "Dynamics", group="Pump",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  //Pump
  parameter Integer numPum=nChi "Number of pumps"
    annotation(Dialog(group="Pump"));
  parameter Modelica.SIunits.MassFlowRate mPump_flow_nominal(min=0)=mChiller2_flow_nominal
   annotation (Dialog(group="Pump"));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[numPum]
    "Performance data for primary pumps" annotation (Dialog(group="Pump"),
      Placement(transformation(extent={{38,78},{58,98}})));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Time riseTimePum=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum=initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Real[numPum] yPum_start(each min=0)=fill(0,numPum) "Initial value of output from pumps:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate",enable=use_inputFilter));
  parameter Real[numPum] m_flow_start(each min=0)=fill(0,numPum) "Initial value of output from pumps"
    annotation(Dialog(tab="Dynamics", group="Filtered flowrate"));

 //Valve
  parameter Real lValve5(min=1e-10,max=1) = 0.0001
    "Valve 5 leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="On/Off valve"));
   parameter Real yValve5_start = 0 "Initial value of output from valve 5:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear           val5(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=nChi*mChiller2_flow_nominal,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final dpFixed_nominal=0,
    final dpValve_nominal=dpValve_nominal[5],
    final kFixed=0,
    final rhoStd=rhoStd[5],
    final y_start=yValve5_start,
    final l=lValve5)
    "Shutoff valve: closed when fully mechanic cooling is activated; open when fully mechanic cooling is activated"
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum[numPum](
    redeclare each final package Medium = Medium2,
    each final p_start=p2_start,
    each final T_start=T2_start,
    each final X_start=X2_start,
    each final C_start=C2_start,
    each final C_nominal=C2_nominal,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_small=m2_flow_small,
    each final show_T=show_T,
    final per=perPum,
    each addPowerToMedium=addPowerToMedium,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimePum,
    each final init=initPum,
    final y_start=yPum_start,
    final m_flow_start=m_flow_start,
    each final tau=tauPump,
    each final m_flow_nominal=mPump_flow_nominal) "Constant speed pumps"
    annotation (Placement(transformation(extent={{10,-30},{-10,-10}})));
  Modelica.Blocks.Interfaces.RealInput m_flow_in[numPum]
    "Prescribed mass flow rate for primary pumps"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-130,-50},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput yVal5
    "Actuator position for valve 5 (0: closed, 1: open)" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,26}), iconTransformation(extent={{-16,-16},{16,16}},
          origin={-116,30})));
  Fluid.Sensors.MassFlowRate bypFlo(redeclare package Medium = Medium2)
    "Bypass water mass flowrate"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
equation
  connect(wse.port_a2, port_a2) annotation (Line(points={{60,24},{80,24},{80,-60},
          {100,-60}}, color={0,127,255}));
  connect(port_a2,val5. port_a) annotation (Line(points={{100,-60},{100,-60},{80,
          -60},{80,-20},{60,-20}}, color={0,127,255}));
  connect(wse.port_b2,val5. port_b) annotation (Line(points={{40,24},{20,24},{20,
          -20},{40,-20}}, color={0,127,255}));

  for i in 1:numPum loop
    connect(pum[i].port_a,val5. port_b)
    annotation (Line(points={{10,-20},{40,-20}}, color={0,127,255}));
    connect(pum[i].port_b, chiPar.port_a2) annotation (Line(points={{-10,-20},{-20,
          -20},{-20,24},{-40,24}}, color={0,127,255}));
  end for;
  connect(m_flow_in, pum.m_flow_in) annotation (Line(points={{-120,-40},{-60,-40},
          {-60,0},{0.2,0},{0.2,-8}}, color={0,0,127}));
  connect(val5.y, yVal5) annotation (Line(points={{50,-8},{50,6},{-94,6},{-94,
          26},{-120,26}}, color={0,0,127}));
  connect(chiPar.port_b2, port_b2) annotation (Line(points={{-60,24},{-78,24},{
          -78,-60},{-100,-60}}, color={0,127,255}));
  connect(val5.port_b, bypFlo.port_b) annotation (Line(points={{40,-20},{30,-20},
          {30,-60},{-20,-60}}, color={0,127,255}));
  connect(bypFlo.port_a, port_b2)
    annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model implements an integrated water-side economizer (WSE) 
on the load side of the primary-secondary chilled water system, as shown in the following figure. 
In the configuration, users can model multiple chillers with only one integrated WSE. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/ChillerWSE/IntegratedPrimarySecondary.png\"/> 
</p>
<h4>Implementation</h4>
<p>The WSE located on the load side can see the warmest return chilled water, 
and hence can maximize the hours when the WSE can operate. 
Also it allows the primary pumps to be shut off when the WSE can handle the entire load.
This system have three operation modes: 
free cooling (FC) mode, partial mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode. 
</p>
<p>There are 5 valves for on/off use only, which can be controlled 
in order to switch among FC, PMC and FMC mode. 
</p>
<ul>
<li>V1 and V2 are associated with the chiller. 
When the chiller is commanded to run, V1 and V2 will be open, and vice versa. 
Note that when the number of chillers are larger than 1, 
V1 and V2 are vectored models with the same dimension as the chillers.
</li>
<li>V2 and V3 are associated with the WSE. 
When the WSE is commanded to run, V3 and V4 will be open, and vice versa. 
</li>
<li>V5 is for FMC only. When FMC is on, V5 is commanded to on. 
Otherwise, V5 is off. 
</li>
</ul>
<p>The details about how to switch among different cooling modes are shown as: </p>
<p style=\"margin-left: 30px;\">For Free Cooling (FC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are closed, and V3 and V4 are open; </li>
<li style=\"margin-left: 45px;\">V5 is closed; </li>
</ul>
<p style=\"margin-left: 30px;\">For Partially Mechanical Cooling (PMC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are open; </li>
<li style=\"margin-left: 45px;\">V5 is closed; </li>
</ul>
<p style=\"margin-left: 30px;\">For Fully Mechanical Cooling (FMC) Mode: </p>
<ul>
<li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are closed; </li>
<li style=\"margin-left: 45px;\">V5 is open; </li>
</ul>
<h4>Reference</h4>
<ul>
 <li>Stein, Jeff. 2009. Waterside Economizing in Data Centers: 
 Design and Control Considerations.<i>ASHRAE Transactions</i>, 115(2).
 </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 1, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end IntegratedPrimarySecondary;
