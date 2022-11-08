within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Supply pump and valves that connect the storage plant to the district network"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Boolean allowRemoteCharging=nom.allowRemoteCharging
    "Allows the tank to be charged by a remote chiller"
    annotation(Dialog(group="Plant configuration"));
  parameter Boolean useReturnPump=nom.useReturnPump
    "Uses a return pump when being charged remotely"
    annotation(Dialog(group="Plant configuration"));

  //Pump sizing
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perSup
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data for the supply pump"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perRet
    if useReturnPump
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data for the return pump"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  //Valve sizing & interlock
  parameter Modelica.Units.SI.PressureDifference dpValToNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of intVal.valToNet when fully open"
    annotation (Dialog(group="Valve Sizing and Interlock", enable=
    allowRemoteCharging));
  parameter Modelica.Units.SI.PressureDifference dpValFroNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of intVal.valFroNet when fully open"
    annotation (Dialog(group="Valve Sizing and Interlock", enable=
    allowRemoteCharging));
  parameter Real tValToNetClo=0.01
    "Threshold that intVal.ValToNet is considered closed"
    annotation (Dialog(group="Valve Sizing and Interlock", enable=
    allowRemoteCharging));
  parameter Real tValFroNetClo=0.01
    "Threshold that intVal.ValFroNet is considered closed"
    annotation (Dialog(group="Valve Sizing and Interlock", enable=
    allowRemoteCharging));

  // Always enabled
  Modelica.Blocks.Interfaces.RealInput yPumSup "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));

  // Enabled if not allowRemoteCharging
  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare final package Medium = Medium,
    final per=perSup,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) if not allowRemoteCharging "CHW supply pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,28})));

  // Enabled if allowRemoteCharging
  Modelica.Blocks.Interfaces.RealInput yVal[2] if allowRemoteCharging
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={30,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Buildings.Fluid.Storage.Plant.BaseClasses.ReversibleConnection revConSup(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNet_nominal,
    final dpValFroNet_nominal=dpValFroNet_nominal,
    final tValToNetClo=tValToNetClo,
    final tValFroNetClo=tValFroNetClo,
    final per=perSup) if allowRemoteCharging
    "Reversible connection on supply side" annotation (Placement(transformation(
          rotation=0, extent={{-20,40},{20,80}})));

  // Enabled if useReturnPump
  Buildings.Fluid.Storage.Plant.BaseClasses.ReversibleConnection revConRet(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNet_nominal,
    final dpValFroNet_nominal=dpValFroNet_nominal,
    final tValToNetClo=tValToNetClo,
    final tValFroNetClo=tValFroNetClo,
    final per=perRet) if useReturnPump
    "Reversible connection on return side" annotation (Placement(transformation(
          rotation=0, extent={{-20,-80},{20,-40}})));
  Buildings.Fluid.Storage.Plant.Controls.ReturnValve conRetVal if useReturnPump
    "Processes the valve pair signal for those on the return line"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Modelica.Blocks.Interfaces.RealInput yPumRet if useReturnPump
    "Speed input of the return pump" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={70,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));

  // Enabled if not useReturnPump
  Buildings.Fluid.FixedResistances.LosslessPipe pip(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.m_flow_nominal) if not useReturnPump
    "Lossless pipe to replace conditionally enabled components"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(revConSup.yVal, yVal) annotation (Line(points={{12,82},{12,94},{30,94},
          {30,110}}, color={0,0,127}));
  connect(revConSup.y, yPumSup) annotation (Line(points={{-12,82},{-12,90},{-50,
          90},{-50,110}}, color={0,0,127}));
  connect(port_aFroChi, revConSup.port_a)
    annotation (Line(points={{-100,60},{-20,60}}, color={0,127,255}));
  connect(revConSup.port_b, port_bToNet)
    annotation (Line(points={{20,60},{100,60}}, color={0,127,255}));
  connect(port_aFroChi, pumSup.port_a) annotation (Line(points={{-100,60},{-80,60},
          {-80,28},{-60,28}}, color={0,127,255}));
  connect(pumSup.port_b, port_bToNet) annotation (Line(points={{-40,28},{80,28},
          {80,60},{100,60}}, color={0,127,255}));
  connect(pumSup.y, yPumSup)
    annotation (Line(points={{-50,40},{-50,110}}, color={0,0,127}));
  connect(port_bToChi, revConRet.port_a)
    annotation (Line(points={{-100,-60},{-20,-60}}, color={0,127,255}));
  connect(revConRet.port_b, port_aFroNet)
    annotation (Line(points={{20,-60},{100,-60}}, color={0,127,255}));
  connect(port_bToChi, pip.port_a) annotation (Line(points={{-100,-60},{-80,-60},
          {-80,-30},{-60,-30}}, color={0,127,255}));
  connect(pip.port_b, port_aFroNet) annotation (Line(points={{-40,-30},{80,-30},
          {80,-60},{100,-60}}, color={0,127,255}));
  connect(conRetVal.uVal, yVal)
    annotation (Line(points={{39,-10},{30,-10},{30,110}}, color={0,0,127}));
  connect(revConRet.yVal, conRetVal.yVal) annotation (Line(points={{12,-38},{12,
          -26},{68,-26},{68,-10},{61,-10}}, color={0,0,127}));
  connect(revConRet.y, yPumRet) annotation (Line(points={{-12,-38},{-12,12},{70,
          12},{70,110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
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
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Line(
          points={{80,60},{80,32},{-80,32},{-80,60}},
          color={28,108,200},
          visible=allowRemoteCharging),
        Polygon(
          points={{40,32},{24,42},{24,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{40,32},{56,42},{56,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-60,-40},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useReturnPump),
        Polygon(
          points={{40,-60},{24,-50},{24,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useReturnPump),
        Polygon(
          points={{40,-60},{56,-50},{56,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useReturnPump),
        Line(
          points={{80,-60},{80,-88},{-80,-88},{-80,-60}},
          color={28,108,200},
          visible=useReturnPump),
        Polygon(
          points={{40,-88},{24,-78},{24,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useReturnPump),
        Polygon(
          points={{40,-88},{56,-78},{56,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useReturnPump),
        Polygon(
          points={{-20,-60},{-50,-44},{-50,-76},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          visible=useReturnPump)}),
    defaultComponentName = "netCon",
    Documentation(info="<html>
<p>
This model is part of a storage plant model.
It contains the pump and valves that connect the storage plant to the district
network. Some of its components are conditionally enabled.
</p>
<p>
If <code>allowRemoteCharging=true</code>, a pair of interlocked valves are
enabled. One of them isolates the pump and the other allows CHW flow from
the district supply line back to the plant to charge the storage tank.
They are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.RemoteChargingSupply\">
Buildings.Fluid.Storage.Plant.Controls.RemoteChargingSupply</a>.
The
<a href=\"Modelica://Buildings.Fluid.FixedResistances.Junction\">
Buildings.Fluid.FixedResistances.Junction</a>
models are also used in this configuration to break algebraic loops.
</p>
<p>
If <code>allowRemoteCharging=false</code>, the valves and the junctions are
replaced by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough\">
Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough</a>.
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
end NetworkConnection;
