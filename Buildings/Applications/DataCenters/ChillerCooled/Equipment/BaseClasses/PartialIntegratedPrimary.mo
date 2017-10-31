within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
model PartialIntegratedPrimary
  "Integrated water-side economizer for primary-only chilled water system"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE(
    numVal=6);

  //Parameters for the valve used in free cooling mode
  parameter Real lVal5(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));
  parameter Real lVal6(min=1e-10,max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));

  parameter Real yVal5_start(min=0,max=1) = 0
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=use_inputFilter));
  parameter Real yVal6_start(min=0,max=1) = 1-yVal5_start
    "Initial value of output:0-closed, 1-fully opened"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=use_inputFilter));

 Modelica.Blocks.Interfaces.RealInput yVal6(
   final unit = "1",
   min=0,
   max=1)
    "Actuator position for valve 6 (0: closed, 1: open)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,-10}), iconTransformation(
        extent={{-16,-16},{16,16}},
        origin={-116,-2})));

  Modelica.Blocks.Interfaces.RealInput yVal5(
    final unit= "1",
    min=0,
    max=1)
    "Actuator position for valve 5(0: closed, 1: open)"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        origin={-120,20}), iconTransformation(
        extent={{16,16},{-16,-16}},
        rotation=180,
        origin={-116,30})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_nominal=numChi*m2_flow_chi_nominal,
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
    final l=lVal5,
    final kFixed=0,
    final rhoStd=rhoStd[5],
    final y_start=yVal5_start)
    "Shutoff valve: closed when fully mechanic cooling is activated;
    open when fully mechanic cooling is activated"
    annotation (Placement(transformation(extent={{60,-30},{40,-10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(
    redeclare final package Medium = Medium2,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m2_flow_wse_nominal,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final homotopyInitialization=homotopyInitialization,
    final linearized=linearizeFlowResistance2,
    final deltaM=deltaM2,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTimeValve,
    final init=initValve,
    final dpFixed_nominal=0,
    final dpValve_nominal=dpValve_nominal[6],
    final l=lVal6,
    final kFixed=0,
    final rhoStd=rhoStd[6],
    final y_start=yVal6_start)
    "Shutoff valve: closed when free cooling mode is deactivated;
    open when free cooling is activated"
    annotation (Placement(transformation(extent={{-40,-30},{-60,-10}})));

equation
  connect(port_a2,val5. port_a)
    annotation (Line(points={{100,-60},{80,-60},{80,-20},{60,-20}},
      color={0,127,255}));
  connect(port_a2, wse.port_a2)
    annotation (Line(points={{100,-60},{88,-60},{80,-60},{80,24},{60,24}},
      color={0,127,255}));
  connect(val6.port_a, chiPar.port_a2)
    annotation (Line(points={{-40,-20},{-20,-20},{-20,24},{-40,24}},
      color={0,127,255}));
  connect(chiPar.port_b2, port_b2)
    annotation (Line(points={{-60,24},{-80,24},{-80,-60},{-100,-60}},
      color={0,127,255}));
  connect(val6.port_b, port_b2)
    annotation (Line(points={{-60,-20},{-80,-20},{-80,-60},{-100,-60}},
      color={0,127,255}));
  connect(val5.y, yVal5)
    annotation (Line(points={{50,-8},{50,0},{50,0},{-94,0},{-94,20},{-120,20}},
      color={0,0,127}));
  connect(yVal6, val6.y)
    annotation (Line(points={{-120,-10},{-94,-10},{-94,0},{-50,0},{-50,-8}},
      color={0,0,127}));
  connect(senTem.port_b, val5.port_b)
    annotation (Line(points={{8,24},{0,24},{0,-20},{40,-20}},
      color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
Partial model that implements integrated waterside economizer in primary-ony chilled water system.
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(graphics={
        Rectangle(
          extent={{32,42},{34,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,42},{32,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,4},{32,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,42},{56,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{56,42},{58,36}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-7,-6},{9,-6},{0,3},{-7,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-42,-45},
          rotation=90),
        Polygon(
          points={{-6,-7},{-6,9},{3,0},{-6,-7}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-46,-45}),
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
        Line(points={{90,-60},{78,-60},{78,-44},{52,-44}}, color={0,128,255}),
        Line(points={{36,-44},{12,-44}},color={0,128,255}),
        Line(points={{-18,-44},{-36,-44}}, color={0,128,255}),
        Line(points={{-94,-60},{-78,-60},{-78,-44},{-52,-44}}, color={0,128,255}),
        Line(points={{78,-44},{78,0},{64,0}}, color={0,128,255}),
        Line(points={{24,0},{14,0},{12,0},{12,-44}}, color={0,128,255}),
        Line(points={{12,6},{12,0}}, color={0,128,255}),
        Line(points={{-70,0}}, color={0,0,0}),
        Line(points={{-72,0},{-78,0},{-78,-54}}, color={0,128,255}),
        Line(points={{-24,0},{-18,0},{-18,-44}}, color={0,128,255})}));
end PartialIntegratedPrimary;
