within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Supply pump and valves that connect the storage plant to the district network"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Boolean allowRemoteCharging=nom.allowRemoteCharging
    "Type of plant setup";

  //Pump sizing & interlock
  parameter Buildings.Fluid.Movers.Data.Generic per
    "Performance data for the supply pump" annotation (Placement(transformation(
          extent={{-100,0},{-80,20}})), Dialog(group="Pump Sizing"));

  //Valve sizing & interlock
  parameter Modelica.Units.SI.PressureDifference dpValToNet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intVal.valToNet"
    annotation (Dialog(group="Valve Sizing and Interlock", enable=
    allowRemoteCharging));
  parameter Modelica.Units.SI.PressureDifference dpValFroNet_nominal=
    0.1*nom.dp_nominal "Nominal flow rate of intVal.valFroNet"
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

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare final package Medium = Medium,
    final per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "CHW supply pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,60})));

  Modelica.Blocks.Interfaces.RealInput yPum "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-30,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
  Modelica.Blocks.Interfaces.RealInput yVal[2] if allowRemoteCharging
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));

  Buildings.Fluid.Storage.Plant.BaseClasses.InterlockedValves intVal(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=dpValToNet_nominal,
    final dpValFroNet_nominal=dpValFroNet_nominal,
    final tValToNetClo=tValToNetClo,
    final tValFroNetClo=tValFroNetClo) if allowRemoteCharging
    "A pair of interlocked valves"
    annotation (Placement(transformation(extent={{0,28},{40,68}})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.mTan_flow_nominal},
    dp_nominal={0,0,0}) if allowRemoteCharging
    "Junction"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-nom.m_flow_nominal,nom.m_flow_nominal,-nom.mTan_flow_nominal},
    dp_nominal={0,0,0}) if allowRemoteCharging
    "Junction" annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pas1(
    redeclare final package Medium = Medium)
    if not allowRemoteCharging
    "Replaces conditional components"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pas2(
    redeclare final package Medium = Medium)
    if not allowRemoteCharging
    "Replaces conditional components"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));

equation
  connect(pas2.port_b, port_bToNet) annotation (Line(points={{60,100},{90,100},
          {90,60},{100,60}}, color={0,127,255}));
  connect(intVal.yVal, yVal)
    annotation (Line(points={{20,70},{20,130}}, color={0,0,127}));
  connect(pum.port_b, intVal.port_aFroChi)
    annotation (Line(points={{-20,60},{0,60}}, color={0,127,255}));
  connect(pum.port_b, pas2.port_a) annotation (Line(points={{-20,60},{-10,60},{-10,
          100},{40,100}}, color={0,127,255}));
  connect(jun2.port_1, intVal.port_bToNet)
    annotation (Line(points={{60,60},{40,60}}, color={0,127,255}));
  connect(jun2.port_2, port_bToNet)
    annotation (Line(points={{80,60},{100,60}}, color={0,127,255}));
  connect(jun2.port_3, intVal.port_aFroNet)
    annotation (Line(points={{70,50},{70,36},{40,36}}, color={0,127,255}));
  connect(port_bToChi, port_aFroNet)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(pum.y, yPum)
    annotation (Line(points={{-30,72},{-30,130}}, color={0,0,127}));
  connect(port_aFroChi, jun1.port_1)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(jun1.port_2, pum.port_a)
    annotation (Line(points={{-60,60},{-40,60}}, color={0,127,255}));
  connect(jun1.port_3, intVal.port_bToChi)
    annotation (Line(points={{-70,50},{-70,36},{0,36}}, color={0,127,255}));
  connect(pum.port_a, pas1.port_b) annotation (Line(points={{-40,60},{-54,60},{-54,
          100},{-60,100}}, color={0,127,255}));
  connect(port_aFroChi, pas1.port_a) annotation (Line(points={{-100,60},{-86,60},
          {-86,100},{-80,100}}, color={0,127,255}));
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
          fillPattern=FillPattern.None)}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}})),
    defaultComponentName = "netCon",
    Documentation(info="<html>
<p>
[fixme: Update documentation.]
This model is part of a storage plant model.
It has the following components:
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component</th>
    <th>Enabled</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump<br/>
        <code>pumSup</code></td>
    <td>Always</td>
  </tr>
  <tr>
    <td>Supply output valve<br/>
        <code>intVal.valToNet</code></td>
    <td rowspan=\"2\"><code>plaTyp == .ClosedRemote</code>
        or <code>.Open</code></td>
  </tr>
  <tr>
    <td>Supply charging valve<br/>
        <code>intVal.valFroNet</code></td>
  </tr>
  <tr>
    <td>Auxiliary pump<br/>
        <code>pumRet</code></td>
    <td rowspan=\"3\"><code>plaTyp == .Open</code></td>
  </tr>
  <tr>
    <td>Return charging valve<br/>
        <code>intValRet.valToNet</code></td>
  </tr>
  <tr>
    <td>Return output valve<br/>
        <code>intValRet.valFroNet</code></td>
  </tr>
</tbody>
</table>
<p>
Under configurations where remote charging is allowed
(<code>plaTyp == .ClosedRemote</code> or <code>.Open</code>),
these components are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl</a>.
See its documentation for the control objectives.
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
