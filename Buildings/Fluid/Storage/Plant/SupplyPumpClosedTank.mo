within Buildings.Fluid.Storage.Plant;
model SupplyPumpClosedTank
  "(Draft) Model section with supply pump and valves for a closed tank"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.NominalValues nom
    "Nominal values";

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Medium,
    per(pressure(dp=nom.dp_nominal*{2,1.2,0},
                 V_flow=(nom.m_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "Secondary CHW pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    if nom.allowRemoteCharging
    "Discharge valve, in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal) if nom.allowRemoteCharging
    "Charging valve, in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValDis(
      redeclare package Medium = Medium) if not nom.allowRemoteCharging
    "Replaces valDis when remote charging not allowed"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dpValve_nominal=0.1*nom.dp_nominal,
    dpFixed_nominal=0.1*nom.dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,60})));
  Modelica.Fluid.Interfaces.FluidPort_a port_CHWR(redeclare package Medium =
        Medium) "Port that connects to the CHW return line" annotation (
      Placement(transformation(extent={{90,-70},{110,-50}}), iconTransformation(
          extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_CHWS(redeclare package Medium =
        Medium) "Port that connects to the CHW supply line" annotation (
      Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(
          extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_chiInl(redeclare package Medium =
        Medium) "Port that connects to the chiller inlet" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_chiOut(redeclare package Medium =
        Medium) "Port that connects to the chiller outlet" annotation (
      Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(
          extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealOutput yValCha_actual
    if nom.allowRemoteCharging                         "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,110}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,110})));
  Modelica.Blocks.Interfaces.RealOutput yValDis_actual
    if nom.allowRemoteCharging                         "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,110})));
  Modelica.Blocks.Interfaces.RealInput yValCha if nom.allowRemoteCharging
    "Valve position input" annotation (Placement(transformation(extent={{10,10},
            {-10,-10}},
        rotation=90,
        origin={40,110}),       iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput yValDis if nom.allowRemoteCharging
    "Valve position input" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,110}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,110})));
  Modelica.Blocks.Interfaces.RealInput yPum "Secondary pump speed input"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,110}),    iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));
equation
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{-40,60},{-20,60}},   color={0,127,255}));
  connect(pasValDis.port_a, cheVal.port_b) annotation (Line(points={{20,20},{10,
          20},{10,60},{-1.77636e-15,60}},
                                     color={0,127,255}));
  connect(valDis.port_a, cheVal.port_b) annotation (Line(points={{20,60},{0,60}},
                                color={0,127,255}));
  connect(port_CHWS, port_CHWS)
    annotation (Line(points={{100,60},{100,60}}, color={0,127,255}));
  connect(pum.port_a, port_chiOut)
    annotation (Line(points={{-60,60},{-100,60}}, color={0,127,255}));
  connect(valCha.port_a, port_CHWS) annotation (Line(points={{40,-20},{80,-20},{
          80,60},{100,60}}, color={0,127,255}));
  connect(pasValDis.port_b, port_CHWS) annotation (Line(points={{40,20},{58,20},
          {58,60},{100,60}}, color={0,127,255}));
  connect(valDis.port_b, port_CHWS)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(port_CHWR, port_chiInl)
    annotation (Line(points={{100,-60},{-100,-60}}, color={0,127,255}));
  connect(valCha.port_b, port_chiOut) annotation (Line(points={{20,-20},{-78,-20},
          {-78,60},{-100,60}}, color={0,127,255}));
  connect(pum.y, yPum) annotation (Line(points={{-50,72},{-50,90},{0,90},{0,110}},
                 color={0,0,127}));
  connect(valDis.y, yValDis) annotation (Line(points={{30,72},{30,80},{80,80},{
          80,110}},  color={0,0,127}));
  connect(valCha.y, yValCha) annotation (Line(points={{30,-8},{30,0},{48,0},{48,
          96},{40,96},{40,110}},   color={0,0,127}));
  connect(valDis.y_actual, yValDis_actual)
    annotation (Line(points={{35,67},{44,67},{44,84},{-80,84},{-80,110}},
                                                        color={0,0,127}));
  connect(valCha.y_actual, yValCha_actual) annotation (Line(points={{25,-13},{
          24,-13},{24,-14},{-66,-14},{-66,96},{-40,96},{-40,110}},
                                                   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-30,-92},{30,-92}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=nom.allowRemoteCharging), Polygon(
          points={{-30,-92},{-10,-86},{-10,-98},{-30,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=nom.allowRemoteCharging),
        Line(points={{-30,-72},{30,-72}},color={28,108,200}),
        Polygon(
          points={{30,-72},{10,-66},{10,-78},{30,-72}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-62,-124},{62,-100}},
          textColor={0,0,127},
          textString="%name"),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{20,70},{20,50},{40,60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{60,70},{60,50},{40,60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{80,60},{80,20},{-80,20},{-80,60}}, color={28,108,200}),
        Polygon(
          points={{40,20},{20,30},{20,10},{40,20}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,20},{60,30},{60,10},{40,20}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Documentation pending.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SupplyPumpClosedTank;
