within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle_HeatPort
  "Model for the Rankine cycle as a bottoming cycle using a heat port"

  Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations equ(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Core equations for the Rankine cycle"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulExp "Expander work"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCon "Condenser heat flow"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,-50},
            {120,-30}}),           iconTransformation(extent={{100,-50},{120,
            -30}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-70},{120,-50}}), iconTransformation(extent={{100,-80},
            {120,-60}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="Power",
    final unit="W") "Heat rejected through condensation"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}}),
        iconTransformation(extent={{100,-110},{120,-90}})));
  parameter Buildings.Fluid.CHPs.Rankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);
  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature";
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature ";
  parameter Real etaExp "Expander efficiency";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

protected
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(final T=TEva)
    "Working fluid temperature on the evaporator side"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Math.Gain gai(k(final unit="W") = -1, y(final unit="W"))
    "Sign reversal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-30})));

equation
  connect(preTem.port, heaFloSen.port_a)
    annotation (Line(points={{-60,70},{-40,70}}, color={191,0,0}));
  connect(heaFloSen.port_b, port_a)
    annotation (Line(points={{-20,70},{0,70},{0,100}}, color={191,0,0}));
  connect(heaFloSen.Q_flow, mulExp.u1)
    annotation (Line(points={{-30,59},{-30,-24},{18,-24}}, color={0,0,127}));
  connect(mulCon.u2, heaFloSen.Q_flow)
    annotation (Line(points={{18,-86},{-30,-86},{-30,59}}, color={0,0,127}));
  connect(equ.etaThe,mulExp. u2)
    annotation (Line(points={{1,-46},{10,-46},{10,-36},{18,-36}},
                                                             color={0,0,127}));
  connect(equ.etaThe,etaThe)  annotation (Line(points={{1,-46},{80,-46},{80,-60},
          {110,-60}},
                 color={0,0,127}));
  connect(mulCon.u1, equ.rConEva) annotation (Line(points={{18,-74},{10,-74},{
          10,-54},{1,-54}}, color={0,0,127}));
  connect(mulCon.y, QCon_flow)
    annotation (Line(points={{42,-80},{110,-80}}, color={0,0,127}));
  connect(mulExp.y, gai.u)
    annotation (Line(points={{42,-30},{58,-30}}, color={0,0,127}));
  connect(gai.y, P) annotation (Line(points={{81,-30},{90,-30},{90,-40},{110,
          -40}}, color={0,0,127}));
annotation (defaultComponentName="ORC",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-67},{57,-67}}, color={0,0,0}),
        Line(
          points={{-60,-60},{-28,-20},{16,32},{40,60},{52,60},{54,30},{48,2},{52,
              -38},{58,-58}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(points={{-66,61},{-66,-78}}, color={0,0,0}),
        Polygon(
          points={{-66,73},{-74,51},{-58,51},{-66,73}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{63,-67},{41,-59},{41,-75},{63,-67}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-64,58}},
          textColor={0,0,0},
          textString="T"),
        Text(
          extent={{64,-58},{100,-100}},
          textColor={0,0,0},
          textString="s"),
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle and interfaces with
other components via a heat port. Unlike its sister model
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort\">
Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort</a>,
this model does not prevent heat back flow.
</html>", revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle_HeatPort;
