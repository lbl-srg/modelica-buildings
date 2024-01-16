within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
model RefrigerantCycle
  "Refrigerant cycle model of a heat pump"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle;
  replaceable model RefrigerantCycleHeatPumpHeating =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating(
      useInHeaPum=true)
      constrainedby
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
        useInChi=true)
      constrainedby
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a heat pump in reversed operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  RefrigerantCycleHeatPumpHeating refCycHeaPumHea
    "Refrigerant cycle instance for heating"
  annotation (Placement(transformation(extent={{20,40},{60,80}}, rotation=0)));
  RefrigerantCycleHeatPumpCooling refCycHeaPumCoo if use_rev
    "Refrigerant cycle instance for cooling"
  annotation (Placement(transformation(extent={{-60,40},{-19,80}}, rotation=0)));

protected
  Buildings.Utilities.IO.Strings.StringPassThrough strPasThr
    "String pass through to enable conditional string data";
  Buildings.Utilities.IO.Strings.Constant conStrSou(
    final k=refCycHeaPumHea.datSou)
    "Constant String data source";

initial algorithm
  assert(
    strPasThr.y == refCycHeaPumHea.datSou,
    "In " + getInstanceName() + ": Data sources for reversible operation are not equal.
    Heating data source is " + refCycHeaPumHea.datSou + ", cooling data source is "
    + strPasThr.y + ". Only continue if this is intended.",
    AssertionLevel.warning);

equation
 if use_rev then
  connect(refCycHeaPumCoo.datSouOut,  strPasThr.u);
 else
  connect(refCycHeaPumHea.QCon_flow, QCon_flow) annotation (Line(
      points={{26.6667,38.3333},{26.6667,22},{92,22},{92,0},{110,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumHea.QEva_flow, QEva_flow) annotation (Line(
      points={{53.3333,38.3333},{53.3333,28},{-90,28},{-90,0},{-110,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(refCycHeaPumHea.PEle, PEle) annotation (Line(
      points={{40,38.3333},{40,-86},{0.5,-86},{0.5,-110.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conStrSou.y, strPasThr.u);
 end if;
  connect(pasTrhModSet.u, sigBus.hea);

  connect(sigBus,refCycHeaPumCoo.sigBus)  annotation (Line(
      points={{0,100},{0,90},{-40,90},{-40,86},{-39.3292,86},{-39.3292,80}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus,refCycHeaPumHea.sigBus)  annotation (Line(
      points={{0,100},{0,90},{40.1667,90},{40.1667,80}},
      color={255,204,51},
      thickness=0.5));
  connect(swiQCon.u2, sigBus.hea) annotation (Line(points={{58,0},{0,0},{0,100}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiPEle.u2, sigBus.hea) annotation (Line(points={{2.22045e-15,-58},{2.22045e-15,
          22},{0,22},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.hea) annotation (Line(points={{-58,0},{0,0},{0,100},
          {0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(refCycHeaPumHea.QCon_flow, swiQCon.u1) annotation (Line(points={{26.6667,
          38.3333},{26.6667,8},{58,8}},         color={0,0,127}));
  connect(refCycHeaPumHea.QEva_flow, swiQEva.u1) annotation (Line(points={{53.3333,
          38.3333},{53.3333,28},{-12,28},{-12,8},{-58,8}},         color={0,0,127}));
  connect(refCycHeaPumCoo.QEva_flow, swiQCon.u3) annotation (Line(points={{
          -25.8333,38.3333},{-25.8333,-8},{58,-8}}, color={0,0,127}));
  connect(refCycHeaPumCoo.QCon_flow, swiQEva.u3) annotation (Line(points={{
          -53.1667,38.3333},{-53.1667,-8},{-58,-8}}, color={0,0,127}));
  connect(refCycHeaPumCoo.PEle, swiPEle.u3) annotation (Line(points={{-39.5,
          38.3333},{-39.5,-48},{-8,-48},{-8,-58}}, color={0,0,127}));
  connect(refCycHeaPumHea.PEle, swiPEle.u1) annotation (Line(points={{40,38.3333},
          {40,-48},{8,-48},{8,-58}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
  <li>
    <i>November 26, 2018,</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Modular refrigerant cycle model for heat pump applications used in
  the model <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible</a> and extending models
  of the modular approach.
</p>
<p>
  This model adds the replaceable model approaches for cooling and heating data
  to the partial refrigerant cylce.
</p>
<p>
  Further, an asseration warning is raised if the model approaches or
  sources for performance data differ. This indicates that they are not
  for the same device.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end RefrigerantCycle;
