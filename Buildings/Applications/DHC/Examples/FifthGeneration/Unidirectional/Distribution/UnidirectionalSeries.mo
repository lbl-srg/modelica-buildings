within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Distribution;
model UnidirectionalSeries
  "Distribution system for unidirectional series DHC"
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
  BaseClasses.ConnectionSeries con[nCon](
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
  connect(port_disInl, con[1].port_disInl)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(con.port_conSup, ports_b1)
    annotation (Line(points={{0,10},{0,40},{-80,
          40},{-80,100}}, color={0,127,255}));
  connect(ports_a1, con.port_conRet)
    annotation (Line(points={{80,100},{80,40},{
          6,40},{6,10}}, color={0,127,255}));
  // Connecting outlets to inlets for all instances of connection component
  if nCon >= 2 then
    for i in 2:nCon loop
      connect(con[i-1].port_disOut, con[i].port_disInl);
    end for;
  end if;
  connect(con[nCon].port_disOut, port_disOut)
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
end UnidirectionalSeries;
