within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model IntegratedPrimaryLoadSide
  "Integrated water-side economizer on the load side in a primary-only chilled water system"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialIntegratedPrimary(
    final m_flow_nominal={m1_flow_chi_nominal,m2_flow_chi_nominal,m1_flow_wse_nominal,
      m2_flow_chi_nominal,numChi*m2_flow_chi_nominal,m2_flow_wse_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)});

 //Dynamics
  parameter Modelica.Units.SI.Time tauPump=1
    "Time constant of fluid volume for nominal flow in pumps, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Pump",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  //Pump
  parameter Integer numPum = numChi "Number of pumps"
    annotation(Dialog(group="Pump"));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perPum[numPum]
   "Performance data for the pumps"
    annotation (Dialog(group="Pump"),
          Placement(transformation(extent={{38,78},{58,98}})));
  parameter Boolean addPowerToMedium = true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation (Dialog(group="Pump"));
  parameter Modelica.Units.SI.Time riseTimePump=30
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered speed",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init initPum = initValve
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Real[numPum] yPum_start = fill(0,numPum)
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=use_inputFilter));
  parameter Real[numPum] yValPum_start = fill(0,numPum)
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real lValPum = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Pump"));
  Modelica.Blocks.Interfaces.RealInput yPum[numPum](
    each final unit = "1",
    each min=0,
    each max=1)
    "Constant normalized rotational speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-132,-28},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput powPum[numPum](
    each final quantity="Power",
    each final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Applications.BaseClasses.Equipment.FlowMachine_y pum(
    redeclare final package Medium = Medium2,
    final p_start=p2_start,
    final T_start=T2_start,
    final X_start=X2_start,
    final C_start=C2_start,
    final C_nominal=C2_nominal,
    final m_flow_small=m2_flow_small,
    final show_T=show_T,
    final per=perPum,
    addPowerToMedium=addPowerToMedium,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final init=initPum,
    final tau=tauPump,
    final allowFlowReversal=allowFlowReversal2,
    final num=numPum,
    final m_flow_nominal=m2_flow_chi_nominal,
    dpValve_nominal=6000,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final deltaM=deltaM2,
    final riseTimePump=riseTimePump,
    final riseTimeValve=riseTimeValve,
    final yValve_start=yValPum_start,
    final l=lValPum,
    final yPump_start=yPum_start,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearizeFlowResistance=linearizeFlowResistance2)
    "Pumps"
    annotation (Placement(transformation(extent={{0,-30},{-20,-10}})));

equation
  connect(yPum, pum.u)
    annotation (Line(points={{-120,-40},{10,-40},{10,-16},{2,-16}},
                                      color={0,0,127}));
  connect(pum.P, powPum) annotation (Line(points={{-21,-16},{-22,-16},{-22,-2},
          {90,-2},{90,-40},{110,-40}},color={0,0,127}));
  connect(val5.port_b, pum.port_a)
    annotation (Line(points={{40,-20},{0,-20}}, color={0,127,255}));
  connect(pum.port_b, val6.port_a)
    annotation (Line(points={{-20,-20},{-30,-20}}, color={0,127,255}));
  connect(chiPar.port_a2, val6.port_a) annotation (Line(points={{-40,24},{-26,
          24},{-26,-20},{-30,-20}}, color={0,127,255}));
  connect(senTem.port_b, pum.port_a) annotation (Line(points={{8,24},{6,24},{6,
          -20},{0,-20}}, color={0,127,255}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
April 26, 2021, by Kathryn Hinkelman:<br/>
Added junctions and removed <code>kFixed</code> redundancies.<br/>
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1472\">IBPSA, #1472</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong use of <code>each</code>.
</li>
<li>
July 1, 2017, by Yangyang Fu:<br/>
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
  <img alt=\"image\"
  src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/ChillerCooled/Equipment/IntegraredPrimaryLoadSide.png\"/>
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
</html>"), Icon(graphics={
        Polygon(
          points={{-58,40},{-58,40}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-7,-6},{9,-6},{0,3},{-7,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={46,-45},
          rotation=90),
        Polygon(
          points={{-6,-7},{-6,9},{3,0},{-6,-7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={42,-45}),
        Ellipse(
          extent={{-14,-32},{8,-54}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,128,255}),
        Polygon(
          points={{-14,-44},{-2,-54},{-2,-32},{-14,-44}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Line(points={{12,6},{12,0}}, color={0,128,255}),
        Line(points={{-70,0}}, color={0,0,0}),
        Line(points={{-18,-44}}, color={0,0,0}),
        Line(points={{-18,-44},{-14,-44}}, color={0,128,255}),
        Line(points={{8,-44},{12,-44}}, color={0,128,255})}));
end IntegratedPrimaryLoadSide;
