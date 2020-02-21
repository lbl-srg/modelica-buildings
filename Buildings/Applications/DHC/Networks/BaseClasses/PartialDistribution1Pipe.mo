within Buildings.Applications.DHC.Networks.BaseClasses;
partial model PartialDistribution1Pipe
  "Partial model for one-pipe distribution network"
  extends PartialDistribution;
  replaceable model Model_pipDis = Fluid.Interfaces.PartialTwoPortInterface (
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Model for distribution pipe";
  parameter Integer iConDpSen(final min=1, final max=nCon) = nCon
    "Index of the connection where the pressure drop is sensed"
    annotation(Evaluate=true);
  parameter Boolean have_heaFloOut = false
    "Set to true to output the heat flow rate transferred to each connected load"
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
  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
      final unit="Pa", final displayUnit="Pa")
    "Pressure difference at given location (sensed)"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{200,50}, {220,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow[nCon](
    each final quantity="HeatFlowRate",each final unit="W") if have_heaFloOut
    "Heat flow rate transferred to the connected load (>=0 for heating)"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,70},{120,90}})));
  // COMPONENTS
  replaceable PartialConnection1Pipe con[nCon](
    redeclare each final package Medium = Medium,
    each final have_heaFloOut=have_heaFloOut,
    each final mDis_flow_nominal=mDis_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final energyDynamics=energyDynamics,
    each final tau=tau)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Model_pipDis pipEnd(
    final m_flow_nominal=mDis_flow_nominal)
    "Pipe representing the end of the distribution line (after last connection)"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
initial equation
  assert(iConDpSen >= 1 and iConDpSen <= nCon, "In " + getInstanceName() +
    ": iConDpSen = " + String(iConDpSen) + " whereas it must be between 
    1 and " + String(nCon) + ".");
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
  connect(con[iConDpSen].dp, dp)
    annotation (Line(points={{11,2},{20,2},{20,20},{90,20},{90,40},{120,40}},
        color={0,0,127}));
  connect(con.Q_flow, Q_flow)
    annotation (Line(points={{11,8},{18,8},{18,22},{88, 22},{88,80},{120,80}}, color={0,0,127}));
  annotation (
      Documentation(info="
<html>
<p>
Partial model of a one-pipe distribution network.
</p>
<p>
Three instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
One representing the main distribution supply pipe immediately upstream 
the connection.
</li>
<li>
Another one representing the main distribution return pipe immediately downstream
the connection.
</li>
<li>
The last one representing both the supply and return lines of the connection.
When replacing that model with a pipe model computing the pressure drop, 
one must double the length so that both the supply and return lines are
accounted for.
</li>
</ul>
</html>
    "),
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
