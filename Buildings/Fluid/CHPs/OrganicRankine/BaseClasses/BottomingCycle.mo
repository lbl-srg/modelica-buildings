within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model BottomingCycle "Organic Rankine cycle as a bottoming"

  extends Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Declarations;

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations equ(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Core equations for the Rankine cycle"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,40},
            {120,60}}),            iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-6},{120,14}}),   iconTransformation(extent={{100,-10},
            {120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="Power",
    final unit="W") "Heat rejected through condensation"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}}),
        iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QEva_flow(
    final quantity="Power",
    final unit="W")
    "Heat flow into the evaporator" annotation (Placement(transformation(extent={{-140,36},
            {-100,76}}),            iconTransformation(extent={{-140,40},{-100,80}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulExp "Expander work"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCon "Condenser heat flow"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Math.Gain gai(k(final unit="W") = -1, y(final unit="W"))
    "Sign reversal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,50})));
equation
  connect(equ.etaThe,mulExp. u2)
    annotation (Line(points={{-19,4},{10,4},{10,44},{18,44}},color={0,0,127}));
  connect(equ.etaThe,etaThe)  annotation (Line(points={{-19,4},{110,4}},
                 color={0,0,127}));
  connect(mulCon.u1, equ.rConEva) annotation (Line(points={{18,-44},{0,-44},{0,-4},
          {-19,-4}},        color={0,0,127}));
  connect(mulCon.y, QCon_flow)
    annotation (Line(points={{42,-50},{110,-50}}, color={0,0,127}));
  connect(mulExp.y, gai.u)
    annotation (Line(points={{42,50},{58,50}},   color={0,0,127}));
  connect(gai.y, P) annotation (Line(points={{81,50},{110,50}},
                 color={0,0,127}));
  connect(QEva_flow, mulExp.u1)
    annotation (Line(points={{-120,56},{18,56}},   color={0,0,127}));
  connect(mulCon.u2, QEva_flow) annotation (Line(points={{18,-56},{-60,-56},{-60,
          56},{-120,56}},   color={0,0,127}));
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
This model is a base component of a bottoming organic Rankine cycle
and is instantiated in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle\">
Buildings.Fluid.CHPs.OrganicRankine.BottomingCycle</a>.
See documentation of that model for more details.
</p>
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
