within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Supply pump and valves that connect the storage plant to the district network"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Boolean allowRemoteCharging=nom.allowRemoteCharging
    "Type of plant setup";

  //Pump sizing
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data for the supply pump"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

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

  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare final package Medium = Medium,
    final per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) if not allowRemoteCharging "CHW supply pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,28})));
  Modelica.Blocks.Interfaces.RealInput yPum "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Modelica.Blocks.Interfaces.RealInput yVal[2] if allowRemoteCharging
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversibleConnection revConSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.m_flow_nominal,
    final nom=nom,
    final dpValToNet_nominal=dpValToNet_nominal,
    final dpValFroNet_nominal=dpValFroNet_nominal,
    final tValToNetClo=tValToNetClo,
    final tValFroNetClo=tValFroNetClo,
    final per=per) if allowRemoteCharging
    "Reversible connection on supply side" annotation (Placement(transformation(
          rotation=0, extent={{-20,40},{20,80}})));

equation
  connect(revConSup.yVal, yVal) annotation (Line(points={{12,82},{12,90},{50,90},
          {50,110}}, color={0,0,127}));
  connect(port_bToChi, port_aFroNet)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(revConSup.y, yPum) annotation (Line(points={{-12,82},{-12,90},{-50,90},
          {-50,110}}, color={0,0,127}));
  connect(port_aFroChi, revConSup.port_a)
    annotation (Line(points={{-100,60},{-20,60}}, color={0,127,255}));
  connect(revConSup.port_b, port_bToNet)
    annotation (Line(points={{20,60},{100,60}}, color={0,127,255}));
  connect(port_aFroChi, pumSup.port_a) annotation (Line(points={{-100,60},{-66,60},
          {-66,28},{-60,28}}, color={0,127,255}));
  connect(pumSup.port_b, port_bToNet) annotation (Line(points={{-40,28},{78,28},
          {78,60},{100,60}}, color={0,127,255}));
  connect(pumSup.y, yPum)
    annotation (Line(points={{-50,40},{-50,110}}, color={0,0,127}));
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
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,60},{80,32},{-80,32},{-80,60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{24,42},{24,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{56,42},{56,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),
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
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.Controls.RemoteCharging\">
Buildings.Fluid.Storage.Plant.Controls.RemoteCharging</a>.
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
