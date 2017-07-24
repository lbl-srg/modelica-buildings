within Buildings.ChillerWSE;
model IntegratedPrimaryLoadSide
  "Integrated water-side economizer on the load side in a primary-only chilled water system"
  extends Buildings.ChillerWSE.BaseClasses.PartialIntegratedPrimary(
    final nVal=7,
    final m_flow_nominal={mChiller1_flow_nominal,mChiller2_flow_nominal,mWSE1_flow_nominal,
      mWSE2_flow_nominal,nChi*mChiller2_flow_nominal,mWSE2_flow_nominal,mChiller2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});

 //Dynamics
 parameter Modelica.SIunits.Time tauPump = 30
    "Time constant of fluid volume for nominal flow in pumps, used if energy or mass balance is dynamic"
     annotation (Dialog(tab = "Dynamics", group="Pump",
     enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));

  //Pump
  parameter Integer nPum=nChi "Number of pumps"
    annotation(Dialog(group="Pump"));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[nPum]
   "Performance data for the pumps"
    annotation (Dialog(group="Pump"),
          Placement(transformation(extent={{38,78},{58,98}})));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation (Dialog(group="Pump"));
  parameter Modelica.SIunits.Time riseTimePum=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum=initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Real[nPum] yPum_start=fill(0,nPum) "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));

 //Valve
  parameter Real lValve7(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));
  parameter Real yValve7_start = 0 "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

   Modelica.Blocks.Interfaces.RealInput yPum[nPum](each min=0, max=1)
    "Constant normalized rotational speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-132,-28},{-100,-60}})));
   Modelica.Blocks.Interfaces.RealInput yVal7(min=0,max=1)
    "Position signal for valve 7 (0: closed, 1: open) " annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-28,-120}), iconTransformation(
        extent={{-16,-16},{16,16}},
        rotation=90,
        origin={-32,-116})));

  Buildings.Fluid.Movers.SpeedControlled_y pum[nPum](
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
    each final tau=tauPump) "Identical pumps"
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val7(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=mChiller2_flow_nominal,
    final dpFixed_nominal=0,
    final l=lValve7,
    final kFixed=0,
    final deltaM=deltaM2,
    final rhoStd=rhoStd[7],
    final dpValve_nominal=dpValve_nominal[7],
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final y_start=yValve7_start)
    "Valve: the valve position is manipulated to maintain the minimum flow requirement through chillers"
    annotation (Placement(transformation(extent={{10,-90},{-10,-70}})));


equation
  for i in 1:nChi loop
  connect(val5.port_b, pum[i].port_a) annotation (Line(points={{40,-20},{14,-20},{14,
          -40},{10,-40}}, color={0,127,255}));
  connect(pum[i].port_b,val6.port_a)  annotation (Line(points={{-10,-40},{-16,-40},
          {-16,-20},{-40,-20}}, color={0,127,255}));
  end for;
  connect(val5.port_b,val7. port_a) annotation (Line(points={{40,-20},{30,-20},{
          30,-80},{10,-80}}, color={0,127,255}));
  connect(val7.port_b, port_b2) annotation (Line(points={{-10,-80},{-40,-80},{-40,
          -60},{-100,-60}}, color={0,127,255}));
 connect(pum.y, yPum) annotation (Line(points={{0.2,-28},{0.2,-10},{-26,-10},{
          -26,-40},{-120,-40}},
                            color={0,0,127}));
  connect(val7.y, yVal7) annotation (Line(points={{0,-68},{0,-68},{0,-60},{-28,-60},
          {-28,-120}}, color={0,0,127}));

  annotation (Documentation(revisions="<html>
<ul>
<li>
July 1, 2017, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model implements an integrated water-side economizer (WSE) 
on the load side of the primary-only chilled water system, as shown in the following figure. 
In the configuration, users can model multiple chillers with only one integrated WSE. 
</p>
<p align=\"center\">
  <img src=\"modelica://Buildings/Resources/Images/ChillerWSE/IntegraredPrimaryLoadSide.png\" alt=\"image\"/> 
</p>
<h4>Implementation</h4>
<p>
The WSE located on the load side can see the warmest return chilled water, 
and hence can maximize the use time of the heat exchanger. 
This system have three operation modes: 
free cooling (FC) mode, partial mechanical cooling (PMC) mode and fully mechanical cooling (FMC) mode. 
</p>
<p>
There are 7 valves for on/off use only, 
which can be controlled in order to switch among FC, PMC and FMC mode.
</p>
<ul>
 <li>V1 and V2 are associated with the chiller. 
 When the chiller is commanded to run, V1 and V2 will be open, and vice versa. 
 Note that when the number of chillers are larger than 1, 
 V1 and V2 are vectored models with the same dimension as the chillers.
 </li>
 <li>V3 and V4 are associated with the WSE. 
 When the WSE is commanded to run, V3 and V4 will be open, and vice versa. 
 </li>
 <li>V5 is for FMC only. When FMC is on, V5 is commanded to on. 
 Otherwise, V5 is off. 
 </li>
 <li>V6 is for FC only. When FC is on, V6 is commanded to on. 
 Otherwise, V6 is off. 
 </li>
 <li>V7 is controlled to track a minimum flowrate through the chiller. 
 If the cooling load is very small (e.g. when the data center start to be occupied), 
 and the flowrate through the chiller is smaller than the minimum requirement, 
 then V7 is open, and the valve position is controlled to meet the minimum flowrate through the chiller. 
 If the cooling load grows, V7 will eventually be fully closed. 
 </li>
</ul>
<p>
The details about how to switch among different cooling modes are shown as: 
</p>
<p style=\"margin-left: 30px;\">
For Free Cooling (FC) Mode:
</p>
<ul>
 <li style=\"margin-left: 45px;\">V1 and V2 are closed, and V3 and V4 are open;</li>
 <li style=\"margin-left: 45px;\">V5 is closed;</li>
 <li style=\"margin-left: 45px;\">V6 is open;</li>
 <li style=\"margin-left: 45px;\">V7 is closed;</li>
</ul>
<p style=\"margin-left: 30px;\">
For Partially Mechanical Cooling (PMC) Mode:
</p>
<ul>
 <li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are open;</li>
 <li style=\"margin-left: 45px;\">V5 is closed;</li>
 <li style=\"margin-left: 45px;\">V6 is closed;</li>
 <li style=\"margin-left: 45px;\">V7 is controlled to track a minumum flowrate through the chiller;</li>
</ul>
<p style=\"margin-left: 30px;\">
For Fully Mechanical Cooling (FMC) Mode:
</p>
<ul>
 <li style=\"margin-left: 45px;\">V1 and V2 are open, and V3 and V4 are closed;</li>
 <li style=\"margin-left: 45px;\">V5 is open;</li>
 <li style=\"margin-left: 45px;\">V6 is closed;</li>
 <li style=\"margin-left: 45px;\">V7 is controlled to track a minumum flowrate through the chiller; </li>
</ul>
<h4>Reference</h4>
<ul>
 <li>Stein, Jeff. 2009. Waterside Economizing in Data Centers: 
 Design and Control Considerations.<i>ASHRAE Transactions</i>, 115(2).
 </li>
</ul>
</html>"));
end IntegratedPrimaryLoadSide;
