within Buildings.Fluid.Storage.Plant.BaseClasses;
model ReversibleConnection
  "Configuration with pump and interlocked valves that support reverse flow"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal);

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom
    "Nominal values";

  parameter Modelica.Units.SI.PressureDifference dpValToNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of intVal.valToNet when fully open";
  parameter Modelica.Units.SI.PressureDifference dpValFroNet_nominal(
    final displayUnit="Pa")=
    0.1*nom.dp_nominal "Nominal pressure drop of intVal.valFroNet when fully open";
  parameter Real tValToNetClo=0.01
    "Threshold that intVal.ValToNet is considered closed";
  parameter Real tValFroNetClo=0.01
    "Threshold that intVal.ValFroNet is considered closed";

  Modelica.Units.SI.MassFlowRate mToNet_flow=intVal.valToNet.m_flow
    "Mass flow rate on the branch from the plant to the network";
  Modelica.Units.SI.MassFlowRate mFroNet_flow=intVal.valFroNet.m_flow
    "Mass flow rate on the branch from the network to the plant";

  parameter Buildings.Fluid.Movers.Data.Generic per
    "Performance data for the supply pump"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
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
        origin={-70,40})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=nom.m_flow_nominal,
    final dpValve_nominal=0.5*dpValToNet_nominal) "Check valve" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,40})));
  Buildings.Fluid.Storage.Plant.BaseClasses.InterlockedValves intVal(
    redeclare final package Medium = Medium,
    final nom=nom,
    final dpValToNet_nominal=0.5*dpValToNet_nominal,
    final dpValFroNet_nominal=dpValFroNet_nominal,
    final tValToNetClo=tValToNetClo,
    final tValFroNetClo=tValFroNetClo)
    "A pair of interlocked valves"
    annotation (Placement(transformation(extent={{0,-20},{40,20}})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={nom.mTan_flow_nominal,-nom.m_flow_nominal,nom.m_flow_nominal},
    dp_nominal={0,0,0})                        "Junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-72,0})));

  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=nom.T_CHWS_nominal,
    tau=30,
    m_flow_nominal={nom.m_flow_nominal,-nom.mTan_flow_nominal,-nom.m_flow_nominal},
    dp_nominal={0,0,0})                        "Junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={70,0})));

  Modelica.Blocks.Interfaces.RealInput yVal[2] annotation (Placement(
        transformation(rotation=-90,
                                   extent={{-10,-10},{10,10}},
        origin={20,110}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));
  Modelica.Blocks.Interfaces.RealInput y(unit="1") annotation (Placement(
        transformation(rotation=-90,
                                   extent={{-10,-10},{10,10}},
        origin={-70,110}), iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));
equation
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{-60,40},{-40,40}}, color={0,127,255}));
  connect(cheVal.port_b, intVal.port_aFroChi)
    annotation (Line(points={{-20,40},{-6,40},{-6,12},{0,12}},
                                                         color={0,127,255}));
  connect(yVal, intVal.yVal) annotation (Line(points={{20,110},{20,22}},
                    color={0,0,127}));
  connect(y, pum.y) annotation (Line(points={{-70,110},{-70,52}},
        color={0,0,127}));
  connect(jun2.port_1, intVal.port_bToNet)
    annotation (Line(points={{70,10},{70,12},{40,12}}, color={0,127,255}));
  connect(jun2.port_3, port_b) annotation (Line(points={{80,-5.55112e-16},{90,
          -5.55112e-16},{90,0},{100,0}}, color={0,127,255}));
  connect(jun2.port_2, intVal.port_aFroNet)
    annotation (Line(points={{70,-10},{70,-12},{40,-12}}, color={0,127,255}));
  connect(intVal.port_bToChi, jun1.port_1)
    annotation (Line(points={{0,-12},{-72,-12},{-72,-10}}, color={0,127,255}));
  connect(jun1.port_2, pum.port_a) annotation (Line(points={{-72,10},{-72,20},{
          -84,20},{-84,40},{-80,40}}, color={0,127,255}));
  connect(jun1.port_3, port_a) annotation (Line(points={{-82,5.55112e-16},{-91,
          5.55112e-16},{-91,0},{-100,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
[Documentation pending.]
</p>
</html>", revisions="<html>
<ul>
<li>
November 3, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"), defaultComponentName = "intVal", Icon(graphics={     Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-80,40},{80,-40}}, lineColor={28,108,200}),
        Line(points={{-100,0},{-80,0}},   color={28,108,200}),
        Ellipse(
          extent={{-62,60},{-22,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,40},{24,50},{24,30},{40,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,40},{56,50},{56,30},{40,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-40},{24,-30},{24,-50},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-40},{56,-30},{56,-50},{40,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-24,40},{-54,56},{-54,24},{-24,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Line(points={{80,0},{100,0}},     color={28,108,200})}));
end ReversibleConnection;
