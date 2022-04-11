within Buildings.Fluid.Storage.Plant;
model SupplyPumpClosedTank
  "(Draft) Model section with supply pump and valves for a closed tank"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Boolean allowRemoteCharging = true
    "= true if the tank is allowed to be charged by a remote source";

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
    m_flow_nominal=nom.m_flow_nominal) if allowRemoteCharging
    "Discharging valve, open when tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal) if allowRemoteCharging
    "Charging valve, open when tank is being charged remotely"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValDis(
      redeclare package Medium = Medium) if not allowRemoteCharging
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
  Modelica.Blocks.Interfaces.RealOutput yValCha_actual
    if allowRemoteCharging                         "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,110}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,110})));
  Modelica.Blocks.Interfaces.RealOutput yValDis_actual
    if allowRemoteCharging                         "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealInput yValCha if allowRemoteCharging
    "Valve position input" annotation (Placement(transformation(extent={{10,10},
            {-10,-10}},
        rotation=90,
        origin={40,110}),       iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput yValDis if allowRemoteCharging
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
  connect(port_chiOut, pum.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(port_chiOut, valCha.port_b) annotation (Line(points={{-100,60},{-80,60},
          {-80,-20},{20,-20}}, color={0,127,255}));
  connect(valCha.port_a, port_CHWS) annotation (Line(points={{40,-20},{80,-20},{
          80,60},{100,60}}, color={0,127,255}));
  connect(pasValDis.port_b, port_CHWS) annotation (Line(points={{40,20},{80,20},
          {80,60},{100,60}}, color={0,127,255}));
  connect(valDis.port_b, port_CHWS)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(port_chiInl, port_CHWR)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-20,0},{40,0}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{-20,0},{0,6},{0,-6},{-20,0}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{-20,80},{40,80}},  color={28,108,200}),
        Polygon(
          points={{40,80},{20,86},{20,74},{40,80}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{20,70},{20,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{60,70},{60,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,60},{80,20},{-80,20},{-80,60}},
          color={28,108,200},
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{20,30},{20,10},{40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{60,30},{60,10},{40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
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
