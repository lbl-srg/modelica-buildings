within Buildings.Fluid.Storage.Plant;
model SupplyPumpValve
  "(Draft) Plant section with supply pump and valves"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare package Medium = Medium,
    per(pressure(dp=nom.dp_nominal*{2,1.2,0}, V_flow=(nom.m_flow_nominal)/1.2*{
            0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "CHW supply pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valSupOut(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal) if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Output valve, open when tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valSupCha(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal) if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Charging valve, modulated when tank is being charged remotely"
    annotation (Placement(transformation(extent={{40,-30},{20,-10}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValSupOut(
      redeclare package Medium = Medium) if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    "Replaces valSupOut when remote charging not allowed"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.FixedResistances.CheckValve cheValSup(
    redeclare package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dpValve_nominal=0.1*nom.dp_nominal,
    dpFixed_nominal=0.1*nom.dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,60})));
  Modelica.Blocks.Interfaces.RealOutput ySup_actual[2] if nom.plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote or nom.plaTyp
     == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Actual positions of the valves connected to the supply line" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealInput yValSup[2] if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
     or nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput yPumSup "Secondary pump speed input"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));

equation
  connect(pumSup.port_b, cheValSup.port_a)
    annotation (Line(points={{-40,60},{-20,60}}, color={0,127,255}));
  connect(pasValSupOut.port_a, cheValSup.port_b) annotation (Line(points={{20,
          20},{10,20},{10,60},{-1.77636e-15,60}}, color={0,127,255}));
  connect(pumSup.y, yPumSup) annotation (Line(points={{-50,72},{-50,96},{20,96},
          {20,110}}, color={0,0,127}));
  connect(port_chiOut, pumSup.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(port_chiOut, valSupCha.port_b) annotation (Line(points={{-100,60},{-80,
          60},{-80,-20},{20,-20}}, color={0,127,255}));
  connect(valSupCha.port_a, port_CHWS) annotation (Line(points={{40,-20},{80,-20},
          {80,60},{100,60}}, color={0,127,255}));
  connect(pasValSupOut.port_b, port_CHWS) annotation (Line(points={{40,20},{80,
          20},{80,60},{100,60}}, color={0,127,255}));
  connect(port_chiInl, port_CHWR)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(cheValSup.port_b, valSupOut.port_a)
    annotation (Line(points={{-1.77636e-15,60},{20,60}}, color={0,127,255}));
  connect(valSupOut.port_b, port_CHWS)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(ySup_actual, ySup_actual)
    annotation (Line(points={{-90,110},{-90,110}}, color={0,0,127}));
  connect(valSupOut.y_actual, ySup_actual[1]) annotation (Line(points={{35,67},
          {40,67},{40,82},{-90,82},{-90,107.5}}, color={0,0,127}));
  connect(valSupCha.y_actual, ySup_actual[2]) annotation (Line(points={{25,-13},
          {24,-13},{24,-12},{-90,-12},{-90,112.5}}, color={0,0,127}));
  connect(valSupOut.y, yValSup[1]) annotation (Line(points={{30,72},{30,74},{46,
          74},{46,96},{40,96},{40,107.5}}, color={0,0,127}));
  connect(valSupCha.y, yValSup[2]) annotation (Line(points={{30,-8},{30,0},{46,
          0},{46,96},{40,96},{40,112.5}}, color={0,0,127}));
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
          points={{40,60},{24,70},{24,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,60},{80,20},{-80,20},{-80,60}},
          color={28,108,200},
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{24,30},{24,10},{40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{56,30},{56,10},{40,20}},
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
end SupplyPumpValve;
