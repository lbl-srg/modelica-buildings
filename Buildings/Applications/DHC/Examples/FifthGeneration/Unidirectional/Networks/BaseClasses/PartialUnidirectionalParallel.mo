within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Networks.BaseClasses;
partial model PartialUnidirectionalParallel
  "Hydraulic network for unidirectional parallel DHC system"
  extends BaseClasses.PartialDistributionSystem;
  replaceable model PipeDisModel = BaseClasses.PipeDistribution constrainedby
    BaseClasses.BasePipe(
      redeclare package Medium = Medium,
      allowFlowReversal=allowFlowReversal);
  replaceable model PipeConModel = BaseClasses.PipeConnection constrainedby
    BaseClasses.BasePipe(
      redeclare package Medium=Medium,
      allowFlowReversal=allowFlowReversal);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal[nCon]
    "Nominal mass flow rate in the distribution line before each connection";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nCon]
    "Nominal mass flow rate in each connection line";
  parameter Modelica.SIunits.MassFlowRate mEnd_flow_nominal
    "Nominal mass flow rate in the end of the distribution line";
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_bDisRet(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return outlet port"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
      iconTransformation(extent={{-220,-80}, {-180,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDisRet(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution return inlet port"
    annotation (Placement(transformation( extent={{90,-70},{110,-50}}),
      iconTransformation(extent={{180,-80},{ 220,-40}})));
  // COMPONENTS
  replaceable BaseClasses.ConnectionParallel con[nCon] constrainedby
    BaseClasses.PartialConnectionParallel(
      redeclare each package Medium=Medium,
      mDis_flow_nominal=mDis_flow_nominal,
      mCon_flow_nominal=mCon_flow_nominal,
      each allowFlowReversal=allowFlowReversal)
    "Connection to agent"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  PipeDisModel pipEnd(m_flow_nominal=mEnd_flow_nominal)
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
      connect(con[i - 1].port_bDisSup, con[i].port_aDisSup);
      connect(con[i - 1].port_aDisRet, con[i].port_bDisRet);
    end for;
  end if;
  connect(port_aDisSup, con[1].port_aDisSup)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_bDisRet, con[1].port_bDisRet)
    annotation (Line(points={{-100,-60},
          {-20,-60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(con[nCon].port_aDisRet, port_aDisRet)
    annotation (Line(points={{10,-6},
          {20,-6},{20,-60},{100,-60}}, color={0,127,255}));
    connect(con[nCon].port_bDisSup, pipEnd.port_a)
      annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
    connect(pipEnd.port_b, port_bDisSup)
      annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
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
    Diagram( coordinateSystem(preserveAspectRatio=false)));
end PartialUnidirectionalParallel;
