within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialDistribution2Pipe
  "Partial model for two-pipe distribution network"
  extends PartialDistribution;
  replaceable model Model_pipDis=Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Model for distribution pipe";
  parameter Integer iConDpSen(
    final max=nCon)=nCon
    "Index of the connection where the pressure drop is measured"
    annotation (Dialog(tab="General"),Evaluate=true);
  parameter Boolean show_entFlo=false
    "Set to true to output enthalpy flow rate difference at each connection"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line before the first connection"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
    "Nominal mass flow rate in each connection line"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mEnd_flow_nominal=
    mDis_flow_nominal-sum(mCon_flow_nominal)
    "Nominal mass flow rate in the end of the distribution line"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mDisCon_flow_nominal[nCon]=cat(
    1,
    {mDis_flow_nominal},
    {mDis_flow_nominal-sum(mCon_flow_nominal[1:i]) for i in 1:(nCon-1)})
    "Nominal mass flow rate in the distribution line before each connection"
    annotation (Dialog(tab="General",group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-220,-80},{-180,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
      iconTransformation(extent={{180,-80},{220,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dp(
    final unit="Pa",
    displayUnit="Pa") if iConDpSen >= 0
    "Pressure difference at given location (measured)"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{200,10},{240,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow[nCon](each final
      unit="W") if          show_entFlo
    "Difference in enthalpy flow rate between connection supply and return"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{200,50},{240,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mCon_flow[nCon](
    each final unit="kg/s")
    "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{200,30},{240,70}})));
  // COMPONENTS
  replaceable BaseClasses.PartialConnection2Pipe con[nCon](
    redeclare each final package Medium=Medium,
    each final show_entFlo=show_entFlo,
    final mDis_flow_nominal=mDisCon_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Model_pipDis pipEnd(
    final m_flow_nominal=mEnd_flow_nominal)
    "Pipe representing the end of the distribution line (after last connection)"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium=Medium) if iConDpSen == 0
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={-60,-30})));
initial equation
  assert(
    iConDpSen <= nCon,
    "In "+getInstanceName()+": iConDpSen = "+String(
      iConDpSen)+" whereas it must be lower than "+String(
      nCon)+".");
equation
  // Connecting outlets to inlets for all instances of connection component.
  if nCon >= 2 then
    for i in 2:nCon loop
      connect(con[i-1].port_bDisSup,con[i].port_aDisSup);
      connect(con[i-1].port_aDisRet,con[i].port_bDisRet);
    end for;
  end if;
  // Connecting dp sensor (needs to be explicit because con[iConDpSen] is
  // undefined if iConDpSen <= 0).
  if iConDpSen > 0 then
    connect(con[iConDpSen].dp,dp)
      annotation (Line(points={{12,5},{20,5},{20,20},{90,20},{90,40},{120,40}},color={0,0,127}));
  end if;
  connect(senRelPre.p_rel,dp)
    annotation (Line(points={{-51,-30},{92,-30},{92,38},{106,38},{106,40},{120,40}},
                                                                  color={0,0,127}));
  connect(con.port_bCon,ports_bCon)
    annotation (Line(points={{0,10},{0,40},{-80,40},{-80,100}},color={0,127,255}));
  connect(ports_aCon,con.port_aCon)
    annotation (Line(points={{80,100},{80,40},{6,40},{6,10}},color={0,127,255}));
  connect(port_aDisSup,con[1].port_aDisSup)
    annotation (Line(points={{-100,0},{-10,0}},color={0,127,255}));
  connect(port_bDisRet,con[1].port_bDisRet)
    annotation (Line(points={{-100,-60},{-40,-60},{-40,-6},{-10,-6}},color={0,127,255}));
  connect(con[nCon].port_aDisRet,port_aDisRet)
    annotation (Line(points={{10,-6},{40,-6},{40,-60},{100,-60}},color={0,127,255}));
  connect(con[nCon].port_bDisSup,pipEnd.port_a)
    annotation (Line(points={{10,0},{60,0}},color={0,127,255}));
  connect(pipEnd.port_b,port_bDisSup)
    annotation (Line(points={{80,0},{100,0}},color={0,127,255}));
  connect(con.mCon_flow,mCon_flow)
    annotation (Line(points={{12,7},{18,7},{18,22},{88,22},{88,60},{120,60}},color={0,0,127}));
  connect(port_aDisSup,senRelPre.port_a)
    annotation (Line(points={{-100,0},{-60,0},{-60,-20}},color={0,127,255}));
  connect(senRelPre.port_b,port_bDisRet)
    annotation (Line(points={{-60,-40},{-60,-60},{-100,-60}},color={0,127,255}));
  connect(con.dH_flow, dH_flow) annotation (Line(points={{12,9},{16,9},{16,80},{
          120,80}}, color={0,0,127}));
  annotation (
    Documentation(
      info="
<html>
<p>
Partial model of a two-pipe distribution network.
</p>
<p>
An array of replaceable partial models is used to represent the
connections along the network, including the pipe segment immediately
upstream each connection.
</p>
<p>
A replaceable partial model is used to represent the pipe segment of
the supply and return line after the last connection.
</p>
<p>
The parameter <code>iConDpSen</code> is provided to specify the index of the
connection where the pressure drop is measured.
Use zero for a sensor connected  to the supply pipe inlet and return pipe outlet.
Use a negative value if no sensor is needed.
</p>
<p>
Optionally the heat flow rate transferred to each connected load can be output.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Rectangle(
          extent={{-6,-200},{6,200}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,0},
          rotation=90),
        Rectangle(
          extent={{-53,4},{53,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-120,47},
          rotation=90),
        Rectangle(
          extent={{-44,4},{44,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={120,56},
          rotation=90),
        Rectangle(
          extent={{-6,-200},{6,200}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={0,-60},
          rotation=90),
        Rectangle(
          extent={{-27,4},{27,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={120,-39},
          rotation=90)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)));
end PartialDistribution2Pipe;
