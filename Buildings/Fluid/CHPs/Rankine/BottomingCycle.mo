within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle
  "Model for the Rankine cycle as a bottoming cycle"

  parameter Buildings.Fluid.CHPs.Rankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);

  // Input properties
  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature";
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature ";
  parameter Real etaExp "Expander efficiency";

  Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations equ(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Core equations for the Rankine cycle"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,30},
            {120,50}}),            iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),  iconTransformation(extent={{100,-10},
            {120,10}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTemEva(final T=TEva)
    "Working fluid temperature on the evaporator side"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSenEva
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulExp "Expander work"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCon "Condenser heat flow"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    min=0,
    final quantity="Power",
    final unit="W") "Heat rejected through the condenser (positive)"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
protected
  Modelica.Blocks.Math.Gain gai(k(final unit="W") = -1, y(final unit="W"))
    "Sign reversal"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
equation
  connect(preTemEva.port, heaFloSenEva.port_a)
    annotation (Line(points={{-60,70},{-40,70}}, color={191,0,0}));
  connect(heaFloSenEva.port_b, port_a)
    annotation (Line(points={{-20,70},{0,70},{0,100}}, color={191,0,0}));
  connect(heaFloSenEva.Q_flow, mulExp.u1)
    annotation (Line(points={{-30,59},{-30,46},{18,46}}, color={0,0,127}));
  connect(equ.etaThe, mulExp.u2)
    annotation (Line(points={{1,4},{10,4},{10,34},{18,34}},  color={0,0,127}));
  connect(mulExp.y, P)
    annotation (Line(points={{42,40},{110,40}}, color={0,0,127}));
  connect(equ.etaThe, etaThe) annotation (Line(points={{1,4},{94,4},{94,0},{110,
          0}},   color={0,0,127}));
  connect(heaFloSenEva.Q_flow, mulCon.u1)
    annotation (Line(points={{-30,59},{-30,-34},{18,-34}}, color={0,0,127}));
  connect(equ.rConEva, mulCon.u2) annotation (Line(points={{1,-4},{10,-4},{10,
          -46},{18,-46}}, color={0,0,127}));
  connect(gai.u, mulCon.y)
    annotation (Line(points={{58,-40},{42,-40}}, color={0,0,127}));
  connect(gai.y, QCon_flow)
    annotation (Line(points={{81,-40},{110,-40}}, color={0,0,127}));
annotation (defaultComponentName="ran",
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
          extent={{-149,-100},{151,-140}},
          textColor={0,0,255},
          textString="%name")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle.
<a href=\"Modelica://Buildings.Fluid.CHPs.Rankine.Examples.ORCWithHeatExchangers\">
Buildings.Fluid.CHPs.Rankine.Examples.ORCWithHeatExchangers</a>
demonstrates how this model can be connected with heat exchangers.
</html>", revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle;
