within Buildings.Fluid.Storage.Plant.BaseClasses;
model IdealReversibleConnection
  "Connecting one side of the storage plant to the district network with an ideal flow source"
  // fixme: change icon.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=true,
    final m_flow_nominal=nom.m_flow_nominal);

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Fluid.Movers.BaseClasses.IdealSource ideSou(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_small=nom.m_flow_nominal*1E-6,
    final control_m_flow=true,
    final control_dp=false) "Ideal flow source"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium)
    "Pressure rise"
    annotation (Placement(transformation(extent={{10,40},{-10,20}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Buildings.Fluid.Storage.Plant.Controls.IdealPumpPower idePumPow
    "Ideal pump power"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity="Power",
    final unit="W")
    "Estimated power consumption" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,20})));
  Modelica.Blocks.Interfaces.RealInput mSet_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate setpoint" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));
protected
  Buildings.Fluid.BaseClasses.ActuatorFilter fil(
    f=20/(2*Modelica.Constants.pi*60),
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final n=2,
    final normalized=true) "Second order filter to improve numerics"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,50})));
equation
  connect(senRelPre.p_rel, idePumPow.dpMachine)
    annotation (Line(points={{0,39},{0,46},{39,46}}, color={0,0,127}));
  connect(idePumPow.m_flow, senMasFlo.m_flow)
    annotation (Line(points={{39,54},{-48,54},{-48,11}}, color={0,0,127}));
  connect(senRelPre.port_a, ideSou.port_b) annotation (Line(
      points={{10,30},{20,30},{20,0},{10,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(senRelPre.port_b, ideSou.port_a) annotation (Line(
      points={{-10,30},{-20,30},{-20,0},{-10,0}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(senMasFlo.port_a, port_a)
    annotation (Line(points={{-58,0},{-100,0}}, color={0,127,255}));
  connect(ideSou.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(idePumPow.PEle, PEle)
    annotation (Line(points={{61,50},{110,50}}, color={0,0,127}));
  connect(senMasFlo.port_b, ideSou.port_a)
    annotation (Line(points={{-38,0},{-10,0}}, color={0,127,255}));
  connect(ideSou.m_flow_in, fil.y) annotation (Line(points={{-6,8},{-28,8},{-28,
          50},{-59,50}}, color={0,0,127}));
  connect(fil.u, mSet_flow)
    annotation (Line(points={{-82,50},{-110,50}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
[fixme: Documentation pending.]
</p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"), defaultComponentName = "ideRevCon", Icon(graphics={     Rectangle(
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
end IdealReversibleConnection;
