within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
model RefrigerantCycleConditional
  "Refrigerant cycle model of a heat pump"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle;
  parameter Boolean allowDifferentDeviceIdentifiers=false
    "if use_rev=true, device data for cooling and heating need to be provided. Set allowDifferentDeviceIdentifiers=true to allow different device identifiers devId"
    annotation (Dialog(enable=use_rev));
  replaceable model RefrigerantCycleHeatPumpHeating=
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating(
    useInHeaPum=true)
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);
  replaceable model RefrigerantCycleHeatPumpCooling=
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
    useInChi=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a heat pump in reversed operation mode"
    annotation (Dialog(enable=use_rev),
  choicesAllMatching=true);
  RefrigerantCycleHeatPumpHeating refCycHeaPumHea
    "Refrigerant cycle instance for heating"
    annotation (Placement(transformation(extent={{20,40},{60,80}},rotation=0)));
  RefrigerantCycleHeatPumpCooling refCycHeaPumCoo
    if use_rev
    "Refrigerant cycle instance for cooling"
    annotation (Placement(transformation(extent={{-60,40},{-19,80}},rotation=0)));
protected
  parameter String devIde=refCycHeaPumHea.devIde
    "Data source for refrigerant cycle";
public
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0)
    if not use_rev
    "Placeholder signal"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
initial algorithm
  if not allowDifferentDeviceIdentifiers then
    assert(devIde == refCycHeaPumHea.devIde, "In " + getInstanceName() +
      ": Device identifiers devIde for reversible operation are not equal.
      Heating device identifier is '" + refCycHeaPumHea.devIde +
      "' but cooling is '" + devIde +
      "'. To allow this, set 'allowDifferentDeviceIdentifiers=true'.", AssertionLevel.error);
  end if;
equation
  connect(pasTrhModSet.u, sigBus.hea);
  connect(sigBus, refCycHeaPumCoo.sigBus)
    annotation (Line(points={{0,100},{0,90},{-40,90},{-40,86},{-39.3292,86},{
          -39.3292,80}},
      color={255,204,51},thickness=0.5));
  connect(sigBus, refCycHeaPumHea.sigBus)
    annotation (Line(points={{0,100},{0,90},{40.1667,90},{40.1667,80}},color={255,204,51},thickness=0.5));
  connect(swiQCon.u2, sigBus.hea)
    annotation (Line(points={{58,0},{0,0},{0,100}},color={255,0,255}),Text(string=
      "%second",index=1,extent={{-6,3},{-6,3}},horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.hea)
    annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,22},{0,22},{0,100}},
      color={255,0,255}),Text(string="%second",index=1,extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.hea)
    annotation (Line(points={{-58,0},{0,0},{0,100},{0,100}},color={255,0,255}),
      Text(string="%second",index=1,extent={{6,3},{6,3}},horizontalAlignment=TextAlignment.Left));
  connect(refCycHeaPumHea.QCon_flow, swiQCon.u1)
    annotation (Line(points={{26.6667,38.3333},{26.6667,8},{58,8}},color={0,0,127}));
  connect(refCycHeaPumHea.QEva_flow, swiQEva.u1)
    annotation (Line(points={{53.3333,38.3333},{53.3333,28},{-12,28},{-12,8},{
          -58,8}},
      color={0,0,127}));
  connect(refCycHeaPumCoo.QEva_flow, swiQCon.u3)
    annotation (Line(points={{-25.8333,38.3333},{-25.8333,-8},{58,-8}},color={0,0,127}));
  connect(refCycHeaPumCoo.QCon_flow, swiQEva.u3)
    annotation (Line(points={{-53.1667,38.3333},{-53.1667,-8},{-58,-8}},color={0,0,127}));
  connect(refCycHeaPumCoo.PEle, swiPEle.u3)
    annotation (Line(points={{-39.5,38.3333},{-39.5,-48},{-8,-48},{-8,-58}},
      color={0,0,127}));
  connect(refCycHeaPumHea.PEle, swiPEle.u1)
    annotation (Line(points={{40,38.3333},{40,-48},{8,-48},{8,-58}},color={0,0,127}));
  connect(zer.y, swiQEva.u3)
    annotation (Line(points={{-58,-40},{-54,-40},{-54,-8},{-58,-8}},color={0,0,127}));
  connect(zer.y, swiPEle.u3)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,-48},{-8,-48},{-8,-58}},
      color={0,0,127}));
  connect(zer.y, swiQCon.u3)
    annotation (Line(points={{-58,-40},{-26,-40},{-26,-8},{58,-8}},color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false),
      graphics={
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
          fillPattern=FillPattern.HorizontalCylinder,
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
This model is similar to
<a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
Buildings.Fluid.HeatPumps.ModularReversible.Modular</a>
except that the cooling cycle component is declared as a conditional
component, which can be removed by setting <code>use_rev</code> to false.
</p>
</html>"));
end RefrigerantCycleConditional;
