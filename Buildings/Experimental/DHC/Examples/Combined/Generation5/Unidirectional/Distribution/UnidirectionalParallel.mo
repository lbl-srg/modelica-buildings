within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Distribution;
model UnidirectionalParallel
  "Hydraulic network for unidirectional parallel DHC system"
  extends BaseClasses.PartialDistributionSystem(
    final allowFlowReversal=false);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
    "Nominal mass flow rate in the connection lines";
  parameter Modelica.SIunits.Length lDis[nCon]
    "Length of the distribution pipe before each connection";
  parameter Modelica.SIunits.Length lCon[nCon]
    "Length of the connection pipe (supply only, not counting return line)";
  parameter Modelica.SIunits.Length dhDis
    "Hydraulic diameter of the distribution pipe";
  parameter Modelica.SIunits.Length dhCon[nCon]
    "Hydraulic diameter of the connection pipe";
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_disRetOut(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(
      extent={{-110,-70},{-90,-50}}), iconTransformation(extent={{-110,-70},
        {-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_disRetInl(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation(
      extent={{90,-70},{110,-50}}), iconTransformation(extent={{90,-70},{110,
        -50}})));
  // COMPONENTS
  BaseClasses.ConnectionParallel con[nCon](
    redeclare package Medium = Medium,
    each mDis_flow_nominal=mDis_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    lDis=lDis,
    lCon=lCon,
    each dhDis=dhDis,
    dhCon=dhCon,
    each allowFlowReversal=allowFlowReversal)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(con.port_conSup, ports_conSup)
    annotation (Line(points={{0,10},{0,40}, {-80,40},{-80,100}}, color={0,127,255}));
  connect(ports_conRet, con.port_conRet)
    annotation (Line(points={{80,100},{80,40}, {6,40},{6,10}}, color={0,127,255}));
  // Connecting outlets to inlets for all instances of connection component
  if nCon >= 2 then
    for i in 2:nCon loop
      connect(con[i-1].port_disSupOut, con[i].port_disSupInl);
      connect(con[i-1].port_disRetInl, con[i].port_disRetOut);
    end for;
  end if;
  connect(port_disSupInl, con[1].port_disInl)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_disRetOut, con[1].port_disRetOut)
    annotation (Line(points={{-100, -60},{-20,-60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(con[nCon].port_disRetInl, port_disRetInl)
    annotation (Line(points={{10,-6}, {20,-6},{20,-60},{100,-60}}, color={0,127,255}));
  connect(con[nCon].port_disSupOut, port_disSupOut)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
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
end UnidirectionalParallel;
