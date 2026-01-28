within Buildings.Fluid.Chillers.ModularReversible.BaseClasses;
model RefrigerantCycleHeatRecovery
  "Refrigerant cycle model for cooling-only or heat recovery chiller models"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle(
    use_rev=false);
  parameter Boolean have_switchover=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation (Evaluate=true);
  replaceable model RefrigerantCycleChillerCooling=Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
    useInChi=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a chiller in main operation mode";
  final model RefrigerantCycleChillerHeating=Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating(
    useInHeaPum=false)
    "Model for refrigerant cycle of a chiller in reversed operation mode";
  RefrigerantCycleChillerCooling refCycChiCoo
    "Refrigerant cycle instance for cooling"
    annotation (Placement(transformation(extent={{20,40},{60,80}},rotation=0)));
protected
  parameter String devIde=refCycChiCoo.devIde
    "Data source for refrigerant cycle";
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    k=true)
    "Placeholder signal to allow using coo variable with use_rev=false";
equation
  connect(pasTrhModSet.u, tru.y);
  connect(sigBus, refCycChiCoo.sigBus)
    annotation (Line(points={{0,100},{0,92},{40.1667,92},{40.1667,80}},color={255,204,51},thickness=0.5));
  connect(swiPEle.u2, sigBus.coo)
    annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,-2},{0,-2},{0,100}},
      color={255,0,255}),Text(string="%second",index=1,extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.coo)
    annotation (Line(points={{-58,0},{0,0},{0,100}},color={255,0,255}),Text(string=
      "%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(swiQCon.u2, sigBus.coo)
    annotation (Line(points={{58,0},{0,0},{0,100}},color={255,0,255}),Text(string=
      "%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(refCycChiCoo.QEva_flow, swiQEva.u1)
    annotation (Line(points={{53.3333,38.3333},{53.3333,24},{-10,24},{-10,8},{
          -58,8}},
      color={0,0,127}));
  connect(refCycChiCoo.QCon_flow, swiQCon.u1)
    annotation (Line(points={{26.6667,38.3333},{26.6667,8},{58,8}},color={0,0,127}));
  connect(refCycChiCoo.PEle, swiPEle.u1)
    annotation (Line(points={{40,38.3333},{40,-48},{8,-48},{8,-58}},color={0,0,127}));
  connect(refCycChiCoo.QCon_flow, swiQCon.u3)
    annotation (Line(points={{26.6667,38.3333},{26.6667,-8},{58,-8}},color={0,0,127}));
  connect(refCycChiCoo.QEva_flow, swiQEva.u3)
    annotation (Line(points={{53.3333,38.3333},{54,38.3333},{54,24},{-10,24},{
          -10,-8},{-58,-8}},
      color={0,0,127}));
  connect(refCycChiCoo.PEle, swiPEle.u3)
    annotation (Line(points={{40,38.3333},{40,-48},{-8,-48},{-8,-58}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-24,88},{22,44}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-16,82},{20,74}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-18,52},{20,58}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{-98,40},{-60,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-20,-60},{-20,-70},{-20,-80},{20,-60},{20,-80},{-20,-60}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-122,34},{-66,34},{-82,10},{-66,-22},{-120,-22}},
          color={28,108,200},
          thickness=0.5),
        Rectangle(
          extent={{60,40},{98,-28}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{120,34},{64,34},{80,10},{64,-22},{118,-22}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,40},{-80,68},{-24,68}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{22,66},{80,66},{80,40}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-28},{78,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{78,-70},{62,-70},{20,-70}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-80,-26},{-80,-68},{-20,-68}},
          color={28,108,200},
          thickness=0.5),
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillColor={0,127,255},
          textString="%name")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      revisions="<html>
<ul>
<li>
March 21, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is the refrigerant cycle model used in
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep\">
Buildings.Fluid.Chillers.ModularReversible.TableData2DLoadDep</a>.
</p>
<p>
In contrast to
<a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle\">
Buildings.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle</a>,
this model includes a unique component that can be configured to
either represent a cooling-only chiller (<code>have_switchover=false</code>)
or a heat recovery chiller (<code>have_switchover=true</code>).
A unique performance data file is required, providing
the maximum <i>cooling</i> heat flow rate and power, regardless of the setting
for <code>have_switchover</code>.
</p>
</html>"));
end RefrigerantCycleHeatRecovery;
