within Buildings.Fluid.HeatExchangers;
model DryCoilCounterFlow
  "Counterflow coil with discretization along the flow paths and without humidity condensation"
  extends Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=false,
    final computeFlowResistance2=false,
    from_dp1=false,
    from_dp2=false);

  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Integer nEle(min=1) = 4
    "Number of pipe segments used for discretization"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 1"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Default formulation of energy balances for volume 2"
    annotation (Evaluate=true,Dialog(tab="Dynamics", group="Equations"));

  parameter Modelica.SIunits.Time tau1=20
    "Time constant at nominal flow for medium 1"
    annotation (Dialog(group="Nominal condition", enable=not steadyState_1));
  parameter Modelica.SIunits.Time tau2=1
    "Time constant at nominal flow for medium 2"
    annotation (Dialog(group="Nominal condition", enable=not steadyState_2));
  parameter Modelica.SIunits.Time tau_m=20
    "Time constant of metal at nominal UA value"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideFlowDependent=true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean waterSideTemperatureDependent=false
    "Set to false to make water-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));
  parameter Boolean airSideTemperatureDependent=false
    "Set to false to make air-side hA independent of temperature"
    annotation (Dialog(tab="Heat transfer"));

  Modelica.SIunits.HeatFlowRate Q1_flow
    "Heat transfered from solid into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow
    "Heat transfered from solid into medium 2";

  Modelica.SIunits.Temperature T1[nEle] "Water temperature";
  Modelica.SIunits.Temperature T2[nEle] "Air temperature";
  Modelica.SIunits.Temperature T_m[nEle] "Metal temperature";

  BaseClasses.HADryCoil hA(
    final UA_nominal=UA_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final waterSideTemperatureDependent=waterSideTemperatureDependent,
    final waterSideFlowDependent=waterSideFlowDependent,
    final airSideTemperatureDependent=airSideTemperatureDependent,
    final airSideFlowDependent=airSideFlowDependent,
    r_nominal=r_nominal) "Model for convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}}, rotation=
            0)));
protected
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_1(redeclare package Medium
      = Medium1,
    allowFlowReversal=allowFlowReversal1,
    m_flow_nominal=m1_flow_nominal) "Temperature sensor"
                                      annotation (Placement(transformation(
          extent={{-58,54},{-48,66}}, rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_1(redeclare package Medium =
        Medium1) "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{-80,54},{-68,66}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen_2(redeclare package Medium
      = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    m_flow_nominal=m2_flow_nominal) "Temperature sensor"
                                      annotation (Placement(transformation(
          extent={{58,-66},{44,-54}}, rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate masFloSen_2(redeclare package Medium =
        Medium2) "Mass flow rate sensor" annotation (Placement(transformation(
          extent={{82,-66},{70,-54}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai_1(k=1/nEle)
    "Gain medium-side 1 to take discretization into account" annotation (
      Placement(transformation(extent={{-18,84},{-6,96}}, rotation=0)));
  Modelica.Blocks.Math.Gain gai_2(k=1/nEle)
    "Gain medium-side 2 to take discretization into account" annotation (
      Placement(transformation(extent={{-18,62},{-6,74}}, rotation=0)));

  replaceable BaseClasses.HexElementSensible ele[nEle]
  constrainedby BaseClasses.PartialHexElement(
    redeclare each package Medium1 = Medium1,
    redeclare each package Medium2 = Medium2,
    each allowFlowReversal1=allowFlowReversal1,
    each allowFlowReversal2=allowFlowReversal2,
    each tau1=tau1/nEle,
    each m1_flow_nominal=m1_flow_nominal,
    each tau2=tau2,
    each m2_flow_nominal=m2_flow_nominal,
    each tau_m=tau_m/nEle,
    each UA_nominal=UA_nominal/nEle,
    each energyDynamics1=energyDynamics1,
    each energyDynamics2=energyDynamics2,
    each deltaM1=deltaM1,
    each deltaM2=deltaM2,
    each from_dp1=from_dp1,
    each from_dp2=from_dp2,
    dp1_nominal={if i == 1 then dp1_nominal else 0 for i in 1:nEle},
    dp2_nominal={if i == nEle then dp2_nominal else 0 for i in 1:nEle})
    "Heat exchanger element"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Modelica.Blocks.Routing.Replicator rep1(nout=nEle) "Signal replicator"
    annotation (Placement(transformation(extent={{4,82},{18,98}})));
  Modelica.Blocks.Routing.Replicator rep2(nout=nEle) "Signal replicator"
    annotation (Placement(transformation(extent={{4,60},{18,76}})));

initial equation
  assert(UA_nominal > 0,
    "Parameter UA_nominal is negative. Check heat exchanger parameters.");
equation
  Q1_flow = sum(ele[i].Q1_flow for i in 1:nEle);
  Q2_flow = sum(ele[i].Q2_flow for i in 1:nEle);
  T1[:] = ele[:].vol1.T;
  T2[:] = ele[:].vol2.T;
  T_m[:] = ele[:].mas.T;
  connect(masFloSen_1.m_flow, hA.m1_flow) annotation (Line(points={{-74,66.6},{
          -74,72},{-82,72},{-82,97},{-61,97}}, color={0,0,127}));
  connect(port_a2, masFloSen_2.port_a)
    annotation (Line(points={{100,-60},{82,-60}}, color={0,127,255}));
  connect(masFloSen_2.port_b, temSen_2.port_a)
    annotation (Line(points={{70,-60},{58,-60}}, color={0,127,255}));
  connect(temSen_2.T, hA.T_2) annotation (Line(points={{51,-53.4},{51,-46},{-88,
          -46},{-88,87},{-61,87}}, color={0,0,127}));
  connect(masFloSen_2.m_flow, hA.m2_flow) annotation (Line(points={{76,-53.4},{
          76,-44},{-86,-44},{-86,83},{-61,83}}, color={0,0,127}));
  connect(hA.hA_1, gai_1.u) annotation (Line(points={{-39,97},{-28,97},{-28,90},
          {-19.2,90}}, color={0,0,255}));
  connect(hA.hA_2, gai_2.u) annotation (Line(points={{-39,83},{-27.5,83},{-27.5,
          68},{-19.2,68}}, color={0,0,255}));
  connect(port_a1, masFloSen_1.port_a) annotation (Line(
      points={{-100,60},{-80,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloSen_1.port_b, temSen_1.port_a) annotation (Line(
      points={{-68,60},{-58,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen_1.T, hA.T_1) annotation (Line(
      points={{-53,66.6},{-53,74},{-78,74},{-78,93},{-61,93}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSen_1.port_b, ele[1].port_a1) annotation (Line(
      points={{-48,60},{-30,60},{-30,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(ele[nEle].port_b1, port_b1) annotation (Line(
      points={{20,16},{40,16},{40,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSen_2.port_b, ele[nEle].port_a2) annotation (Line(
      points={{44,-60},{30,-60},{30,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ele[1].port_b2, port_b2) annotation (Line(
      points={{0,4},{-30,4},{-30,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nEle - 1 loop
    connect(ele[i].port_b1, ele[i + 1].port_a1) annotation (Line(
        points={{20,16},{30,16},{30,30},{-10,30},{-10,16},{0,16}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(ele[i].port_a2, ele[i + 1].port_b2) annotation (Line(
        points={{20,4},{-12,4},{-12,-10},{30,-10},{30,4},{0,4}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;

  connect(gai_1.y, rep1.u) annotation (Line(
      points={{-5.4,90},{2.6,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep1.y, ele.Gc_1) annotation (Line(
      points={{18.7,90},{22,90},{22,46},{6,46},{6,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai_2.y, rep2.u) annotation (Line(
      points={{-5.4,68},{2.6,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rep2.y, ele.Gc_2) annotation (Line(
      points={{18.7,68},{26,68},{26,-6},{14,-6},{14,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
defaultComponentName="heaCoi",
Documentation(info="<html>
<p>
Model of a discretized coil without water vapor condensation.
The coil consists of two flow paths which are, at the design flow direction,
in opposite direction to model a counterflow heat exchanger.
The flow paths are discretized into <code>nEle</code> elements. 
Each element is modeled by an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElement\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElement</a>.
Each element has a state variable for the metal. Depending
on the value of the boolean parameters <code>steadyState_1</code> and
<code>steadyState_2</code>, the fluid states are modeled dynamically or in steady
state.
</p>
<p>
The convective heat transfer coefficients can, for each fluid individually, be 
computed as a function of the flow rate and/or the temperature,
or assigned to a constant. This computation is done using an instance of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil\">
Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil</a>.
</p>
<p>
To model humidity condensation, use the model 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a> instead of this model, as
this model computes only sensible heat transfer.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2, 2012, by Michael Wetter:<br/>
Corrected error in assignment of <code>dp2_nominal</code>.
The previous assignment caused a pressure drop in all except one element,
instead of the opposite. This caused too high a flow resistance
of the heat exchanger.
</li>
<li>
October 8, 2011, by Michael Wetter:<br/>
Set <code>show_T=false</code> to avoid state events near zero flow.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>e"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,80},{40,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,80},{-36,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,80},{2,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-55},{101,-65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,65},{103,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          lineColor={0,0,255},
          textString="water-side"), Text(
          extent={{50,-32},{90,-38}},
          lineColor={0,0,255},
          textString="air-side")}));
end DryCoilCounterFlow;
