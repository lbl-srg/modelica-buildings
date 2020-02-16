within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialDistribution1Pipe
  "Partial model for one-pipe distribution network"
  extends PartialDistribution;
  replaceable model Model_pipDis = Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Model for distribution pipe";
  parameter Integer iConDpSen(min=0, max=nCon) = 0
    "Index of the connection where the pressure drop is sensed (0 for no sensor)"
    annotation(Dialog(tab="General"), Evaluate=true);
  parameter Integer iConBypFloSen = 0
    "Index of the connection where the bypass flow rate is sensed (0 for no sensor)"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
    "Nominal mass flow rate in each connection line"
    annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (
      Dialog(tab="Dynamics", group="Nominal condition",
      enable=not energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState));
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealOutput mByp_flow(
    final quantity="MassFlowRate", final unit="kg/s") if iConBypFloSen > 0
    "Bypass mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    , final unit="Pa", final displayUnit="Pa") if iConDpSen > 0
    "Pressure difference at given location (sensed)"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{200,50}, {220,70}})));
  // COMPONENTS
  replaceable PartialConnection1Pipe con[nCon](
    redeclare each final package Medium = Medium,
    each final mDis_flow_nominal=mDis_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    final have_dpSen={i==iConDpSen for i in 1:nCon},
    final have_bypFloSen={i==iConBypFloSen for i in 1:nCon},
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Model_pipDis pipEnd(
    final m_flow_nominal=mDis_flow_nominal)
    "Pipe representing the end of the distribution line (after last connection)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(con.port_bCon, ports_bCon)
    annotation (Line(points={{0,10},{0,40},{-80,
          40},{-80,100}}, color={0,127,255}));
  connect(ports_aCon, con.port_aCon)
    annotation (Line(points={{80,100},{80,40},
          {6,40},{6,10}}, color={0,127,255}));
  // Connecting outlets to inlets for all instances of connection component
  if nCon >= 2 then
    for i in 2:nCon loop
      connect(con[i - 1].port_bDis, con[i].port_aDis);
    end for;
  end if;
  connect(port_aDisSup, con[1].port_aDis)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(con[nCon].port_bDis, pipEnd.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(pipEnd.port_b, port_bDisSup)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  if iConDpSen > 0 then
    connect(con[iConDpSen].dp, dp)
    annotation (Line(points={{11,2},{20,2},{20,60},{120,60}},
        color={0,0,127}));
  end if;
  if iConBypFloSen > 0 then
  connect(con[iConBypFloSen].mByp_flow, mByp_flow)
    annotation (Line(points={{11,4},{18,4},{18,
          20},{120,20}}, color={0,0,127}));
  end if;
  annotation (
    defaultComponentName="dis",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          extent={{-53,4},{53,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={120,47},
          rotation=90)}),
    Diagram( coordinateSystem(preserveAspectRatio=false)));
end PartialDistribution1Pipe;
