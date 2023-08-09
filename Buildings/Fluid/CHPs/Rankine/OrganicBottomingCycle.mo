within Buildings.Fluid.CHPs.Rankine;
model OrganicBottomingCycle
  "Model for the Rankine cycle as a bottoming cycle using a heat port"

  parameter Boolean preventHeatBackflow = false
    "Set true to stop heat back flow when upstream medium colder than working fluid";

  Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations equ(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Core equations for the Rankine cycle"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,-40},
            {120,-20}}),           iconTransformation(extent={{100,-50},{120,
            -30}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-56},{120,-36}}), iconTransformation(extent={{100,-80},
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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TUps if preventHeatBackflow
    "Temperature of upstream fluid" annotation (Placement(transformation(extent={{-140,36},
            {-100,76}}),           iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Routing.RealPassThrough pas if not preventHeatBackflow
    "Routing block"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulExp "Expander work"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCon "Condenser heat flow"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Math.Gain gai(k(final unit="W") = -1, y(final unit="W"))
    "Sign reversal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-30})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1 if preventHeatBackflow
    "Minimum"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Blocks.Sources.Constant SouTEva(final k=TEva) "Source block"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(heaFloSen.port_b, port_a)
    annotation (Line(points={{80,50},{84,50},{84,86},{0,86},{0,100}},
                                                       color={191,0,0}));
  connect(heaFloSen.Q_flow, mulExp.u1)
    annotation (Line(points={{70,39},{70,-10},{10,-10},{10,-24},{18,-24}},
                                                           color={0,0,127}));
  connect(mulCon.u2, heaFloSen.Q_flow)
    annotation (Line(points={{18,-86},{-30,-86},{-30,-10},{70,-10},{70,39}},
                                                           color={0,0,127}));
  connect(equ.etaThe,mulExp. u2)
    annotation (Line(points={{1,-46},{10,-46},{10,-36},{18,-36}},
                                                             color={0,0,127}));
  connect(equ.etaThe,etaThe)  annotation (Line(points={{1,-46},{110,-46}},
                 color={0,0,127}));
  connect(mulCon.u1, equ.rConEva) annotation (Line(points={{18,-74},{10,-74},{
          10,-54},{1,-54}}, color={0,0,127}));
  connect(mulCon.y, QCon_flow)
    annotation (Line(points={{42,-80},{110,-80}}, color={0,0,127}));
  connect(mulExp.y, gai.u)
    annotation (Line(points={{42,-30},{58,-30}}, color={0,0,127}));
  connect(gai.y, P) annotation (Line(points={{81,-30},{110,-30}},
                 color={0,0,127}));
  connect(min1.y, preTem.T)
    annotation (Line(points={{2,50},{18,50}}, color={0,0,127}));
  connect(SouTEva.y,min1. u2) annotation (Line(points={{-39,10},{-30,10},{-30,44},
          {-22,44}},                     color={0,0,127}));
  connect(heaFloSen.port_a, preTem.port)
    annotation (Line(points={{60,50},{40,50}}, color={191,0,0}));
  connect(min1.u1, TUps) annotation (Line(points={{-22,56},{-120,56}},
                color={0,0,127}));
  connect(SouTEva.y, pas.u)
    annotation (Line(points={{-39,10},{-22,10}}, color={0,0,127}));
  connect(pas.y, preTem.T) annotation (Line(points={{1,10},{12,10},{12,50},{18,50}},
        color={0,0,127}));
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
end OrganicBottomingCycle;
