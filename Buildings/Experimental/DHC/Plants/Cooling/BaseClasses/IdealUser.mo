within Buildings.Experimental.DHC.Plants.Cooling.BaseClasses;
model IdealUser "Ideal user model"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Temperature T_CHWS_nominal
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")
    "Nominal pressure drop when valve is fully open";

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = Medium,
    final use_inputFilter=true,
    final dpValve_nominal=dp_nominal/2,
    final init=Modelica.Blocks.Types.Init.InitialState,
    final dpFixed_nominal=dp_nominal/2,
    final m_flow_nominal=m_flow_nominal,
    y_start=0) "User control valve"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.5,
    Ti=20,
    final reverseActing=true)  "PI controller" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,80})));
  Modelica.Blocks.Interfaces.RealInput mPre_flow(
    final quantity = "MassFlowRate",
    final unit = "kg/s")
    "Load in terms of flow rate prescription" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,80})));
  Modelica.Blocks.Interfaces.RealOutput yVal_actual(
    final unit = "1")
    "Consumer control valve actuator position" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,80}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,80})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare final package Medium = Medium)
    "Differential pressure sensor" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-72,20})));
  Modelica.Blocks.Interfaces.RealOutput dp(
    final quantity="PressureDifference",
    final unit="Pa",
    displayUnit="Pa")
    "Differential pressure from the sensor" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,20}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,40})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
        iconTransformation(extent={{-90,-70},{-110,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-20,-70},{-40,-50}})));
  Buildings.Fluid.Sources.PropertySource_T proSou(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Ideal temperature source" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={10,-60})));
  Modelica.Blocks.Sources.Constant TRet(final k=T_CHWR_nominal)
    "Constant CHW return temperature"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
equation
  connect(senRelPre.p_rel, dp) annotation (Line(points={{-63,20},{110,20}},
                           color={0,0,127}));
  connect(val.y_actual, yVal_actual)
    annotation (Line(points={{15,67},{40,67},{40,80},{110,80}},
                                                         color={0,0,127}));
  connect(senRelPre.port_a, port_a) annotation (Line(
      points={{-72,30},{-72,60},{-100,60}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(senRelPre.port_b, port_b) annotation (Line(
      points={{-72,10},{-72,-60},{-100,-60}},
      color={0,127,255},
      pattern=LinePattern.Dash));
  connect(conPI.y, val.y)
    annotation (Line(points={{-19,80},{10,80},{10,72}},   color={0,0,127}));
  connect(senMasFlo.port_b, port_b)
    annotation (Line(points={{-40,-60},{-100,-60}}, color={0,127,255}));
  connect(senMasFlo.m_flow, conPI.u_m)
    annotation (Line(points={{-30,-49},{-30,68}}, color={0,0,127}));
  connect(port_a, val.port_a)
    annotation (Line(points={{-100,60},{0,60}}, color={0,127,255}));
  connect(conPI.u_s, mPre_flow)
    annotation (Line(points={{-42,80},{-110,80}}, color={0,0,127}));
  connect(senMasFlo.port_a, proSou.port_b)
    annotation (Line(points={{-20,-60},{0,-60}}, color={0,127,255}));
  connect(proSou.port_a, val.port_b) annotation (Line(points={{20,-60},{40,-60},
          {40,60},{20,60}}, color={0,127,255}));
  connect(TRet.y, proSou.T_in)
    annotation (Line(points={{1,-30},{14,-30},{14,-48}}, color={0,0,127}));
  annotation (
    defaultComponentName = "ideUse",
                                 Documentation(info="<html>
<p>
This is a simple ideal user model used by
<a href=\"Modelica://Buildings.Experimental.DHC.Plants.Cooling.Examples.StoragePlantDualSource\">
Buildings.Experimental.DHC.Plants.Cooling.Examples.StoragePlantDualSource</a>.
The load of the user is described by a varying flow rate setpoint.
The valve is controlled to maintain the requested flow.
CHW always leaves the user at a fixed return temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-40,40},{40,-40}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-34,34},{-4,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{6,34},{34,6}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,-4},{-4,-34}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{6,-4},{34,-34}},
          pattern=LinePattern.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-151,-100},{149,-140}},
          textColor={0,0,255},
          textString="%name")}));
end IdealUser;
