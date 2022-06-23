within Buildings.Fluid.HydronicConfigurations.ActiveNetworks;
model Throttle "Throttle circuit"
  extends Fluid.HydronicConfigurations.Interfaces.PartialHydronicConfiguration(
    dpValve_nominal=dp2_nominal,
    final dpBal2_nominal=0,
    final dpBal3_nominal=0,
    final m1_flow_nominal=m2_flow_nominal,
    final typVal=Buildings.Fluid.HydronicConfigurations.Types.Valve.TwoWay,
    final typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
    final typCtl=Buildings.Fluid.HydronicConfigurations.Types.Control.None);

  Buildings.Fluid.HydronicConfigurations.Components.TwoWayValve val(
    redeclare final package Medium=Medium,
    final typCha=typCha,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=if use_lumFloRes then dpBal1_nominal + dp2_nominal else 0,
    final flowCharacteristics=flowCharacteristics)
    "Control valve"
    annotation (
      Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={60,0})));
  Buildings.Fluid.FixedResistances.PressureDrop res1(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m1_flow_nominal,
    final dp_nominal=if use_lumFloRes then 0 else dpBal1_nominal)
    "Primary balancing valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-50})));
equation
  connect(res1.port_b, port_b1)
    annotation (Line(points={{60,-60},{60,-100}}, color={0,127,255}));
  connect(port_b2, port_a1)
    annotation (Line(points={{-60,100},{-60,-100}}, color={0,127,255}));

  connect(val.port_b,res1. port_a)
    annotation (Line(points={{60,-10},{60,-40}}, color={0,127,255}));
  connect(val.port_a, port_a2)
    annotation (Line(points={{60,10},{60,100},{60,100}}, color={0,127,255}));
  connect(yVal, val.y)
    annotation (Line(points={{-120,0},{48,0}}, color={0,0,127}));
  connect(val.y_actual, yVal_actual) annotation (Line(points={{53,-6},{53,-20},{
          80,-20},{80,-40},{120,-40}},  color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,-90},{-60,90}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{60,-90},{60,90}},
          color={0,0,0},
          thickness=0.5),
        Polygon(
          points={{-54,-40},{-60,-30},{-66,-40},{-54,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{54,64},{60,54},{66,64},{54,64}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,80},{-40,40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=typPum<>Buildings.Fluid.HydronicConfigurations.Types.Pump.None,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-60,80},{-42.5,50},{-77.5,50}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=typPum <> Buildings.Fluid.HydronicConfigurations.Types.Pump.None),
        Rectangle(
          extent={{26,10},{46,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          visible=typCtl==Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,0},
          rotation=180),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,0},
          rotation=90),
        Line(
          points={{26,0},{-100,0}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dot,
          visible=typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.None),
        Line(
          points={{-14,-1.71451e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-60},
          rotation=180,
          visible=dpBal1_nominal > 0),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-60},
          rotation=90,
          visible=dpBal1_nominal > 0),
        Line(
          points={{-20,-1.83696e-15},{3.74941e-32,-6.12325e-16}},
          color={0,0,0},
          thickness=0.5,
          origin={46,-70},
          rotation=270,
          visible=dpBal1_nominal > 0)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
<img alt=\"Schematic\"
src=\"modelica://Buildings/Resources/Images/Fluid/HydronicConfigurations/ActiveNetworks/Throttle.png\"/>
</p>
<p>
Lumped flow resistance includes consumer circuit, primary balancing 
valve and control valve.
</p>
</html>"));
end Throttle;
