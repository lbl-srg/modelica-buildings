within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
model IdealChillerBranch
  "A branch with an ideal temperature source and an ideal flow rate source"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom
    "Nominal values";

  Modelica.Units.SI.MassFlowRate m_flow = mFloSou.m_flow "Mass flow rate";

  Modelica.Blocks.Interfaces.RealInput mPumSet_flow
    "Primary pump mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-110}),iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-110})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,50},{90,70}}),
        iconTransformation(extent={{110,50},{90,70}})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource mFloSou(
    redeclare final package Medium = Medium,
    final control_m_flow=true,
    final m_flow_small = nom.mChi_flow_nominal * 1E-5) "Ideal flow rate source"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-30})));
  Buildings.Fluid.Sources.PropertySource_T temSou(
    redeclare package Medium = Medium,
    final use_T_in=true) "Ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Modelica.Blocks.Sources.Constant set_TLvg(k=nom.T_CHWS_nominal)
    "CHW supply temperature setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,30})));
equation
  connect(mPumSet_flow, mFloSou.m_flow_in)
    annotation (Line(points={{-20,-110},{-20,-36},{-8,-36}}, color={0,0,127}));
  connect(port_a, mFloSou.port_a) annotation (Line(points={{100,-60},{-5.55112e-16,
          -60},{-5.55112e-16,-40}}, color={0,127,255}));
  connect(mFloSou.port_b, temSou.port_a) annotation (Line(points={{6.10623e-16,-20},
          {6.10623e-16,0},{-5.55112e-16,0},{-5.55112e-16,20}}, color={0,127,255}));
  connect(temSou.port_b, port_b) annotation (Line(points={{6.10623e-16,40},{6.10623e-16,
          60},{100,60}}, color={0,127,255}));
  connect(set_TLvg.y, temSou.T_in) annotation (Line(points={{-39,30},{-20,30},{-20,
          26},{-12,26}}, color={0,0,127}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{100,60},{0,60},{0,20}},
          color={28,108,200},
          thickness=1),
        Text(
          extent={{-18,-94},{42,-74}},
          textColor={28,108,200},
          textString="m_flow"),
        Line(
          points={{100,-60},{0,-60},{0,28}},
          color={28,108,200},
          thickness=1),
        Ellipse(extent={{-20,20},{20,-20}},lineColor={0,0,0},
          origin={0,28},
          rotation=90,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{64,35},{56,5}}, color={0,0,0},
          origin={47,52},
          rotation=180),
        Line(points={{-35,-64},{-5,-56}},
                                      color={0,0,0},
          origin={73,12},
          rotation=-90),
        Ellipse(extent={{-20,20},{20,-20}},  lineColor={0,0,0},
          origin={0,-28},
          rotation=90,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(points={{-16,16},{-16,-16},{16,0},{-16,16}},  lineColor={0,0,0},
          origin={0,-24},
          rotation=90),
        Text(
          extent={{-54,-32},{54,32}},
          textColor={28,108,200},
          textString="ideal",
          origin={-58,-2},
          rotation=90)}),
Documentation(info="<html>
A branch with an ideal flow source and an ideal property (temperature) source.
</html>", revisions="<html>
<ul>
<li>
April 21, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end IdealChillerBranch;
