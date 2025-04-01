within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
model RefrigerantCycle4Pipe "Refrigerant cycle model of a heat pump"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle4Pipe;

  parameter Boolean allowDifferentDeviceIdentifiers=false
    "if use_rev=true, device data for cooling and heating need to entered. Set allowDifferentDeviceIdentifiers=true to allow different device identifiers devIde"
    annotation(Dialog(enable=use_rev));

  replaceable model RefrigerantCycleHeatPumpHeating =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating
      (
      useInHeaPum=true)
      constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpCooling =
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling
      ( useInChi=true)
      constrainedby
    Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a heat pump in reversed operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  replaceable model RefrigerantCycleHeatPumpHeatingCooling =
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.HeatingCooling
      (
      useInHeaPum=true)
      constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a heat pump in main operation mode"
    annotation (choicesAllMatching=true);

  RefrigerantCycleHeatPumpHeating refCycHeaPumAmbHea
    "Refrigerant cycle instance for ambient heating" annotation (Placement(
        transformation(extent={{64,64},{76,76}}, rotation=0)));
  RefrigerantCycleHeatPumpCooling refCycHeaPumAmbCoo
    "Refrigerant cycle instance for ambient cooling" annotation (Placement(
        transformation(extent={{-76,64},{-64,76}}, rotation=0)));

  RefrigerantCycleHeatPumpHeatingCooling refCycHeaPumHeaCoo
    "Refrigerant cycle instance for heating cooling" annotation (Placement(
        transformation(extent={{-36,64},{-24,76}}, rotation=0)));

  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
protected
  parameter String devIde=if use_rev then refCycHeaPumAmbCoo.devIde else
      refCycHeaPumAmbHea.devIde "Data source for refrigerant cycle";

initial algorithm
  if not allowDifferentDeviceIdentifiers then
    assert(
      devIde == refCycHeaPumAmbHea.devIde,
      "In " + getInstanceName() + ": Device identifiers devIde for reversible operation are not equal.
      Heating device identifier is '" + refCycHeaPumAmbHea.devIde + "' but cooling is '"
         + devIde + "'. To allow this, set 'allowDifferentDeviceIdentifiers=true'.",
      AssertionLevel.error);
  end if;

equation
  connect(pasTrhModSet.u, sigBus.hea);

  connect(sigBus, refCycHeaPumAmbCoo.sigBus) annotation (Line(
      points={{0,100},{0,90},{-69.95,90},{-69.95,76}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus, refCycHeaPumAmbHea.sigBus) annotation (Line(
      points={{0,100},{0,90},{70.05,90},{70.05,76}},
      color={255,204,51},
      thickness=0.5));

  connect(refCycHeaPumHeaCoo.sigBus, sigBus) annotation (Line(
      points={{-29.95,76},{-29.95,86},{0,86},{0,100}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mod, swiQEva.index) annotation (Line(
      points={{0,100},{0,26},{-80,26},{-80,12}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mod, swiQCon.index) annotation (Line(
      points={{0,100},{0,26},{80,26},{80,12}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus.mod, swiPEle.index) annotation (Line(
      points={{0,100},{0,-70},{-38,-70}},
      color={255,204,51},
      thickness=0.5));
  connect(refCycHeaPumAmbCoo.QCon_flow, multiplex3_4.u1[1]) annotation (Line(
        points={{-74,63.5},{-74,48},{57,48},{57,-28}}, color={0,0,127}));
  connect(refCycHeaPumAmbCoo.QEva_flow, multiplex3_1.u1[1]) annotation (Line(
        points={{-66,63.5},{-66,52},{-6,52},{-6,7},{-18,7}}, color={0,0,127}));
  connect(const.y, multiplex3_2.u1[1]) annotation (Line(points={{-79,40},{10,40},
          {10,7},{18,7}}, color={0,0,127}));
  connect(refCycHeaPumAmbCoo.PEle, multiplex3_3.u1[1]) annotation (Line(points={
          {-70,63.5},{-70,44},{-43,44},{-43,-28}}, color={0,0,127}));
  connect(refCycHeaPumHeaCoo.QCon_flow, multiplex3_2.u2[1]) annotation (Line(
        points={{-34,63.5},{-34,44},{6,44},{6,0},{18,0}}, color={0,0,127}));
  connect(refCycHeaPumHeaCoo.QEva_flow, multiplex3_1.u2[1]) annotation (Line(
        points={{-26,63.5},{-26,54},{-2,54},{-2,0},{-18,0}}, color={0,0,127}));
  connect(refCycHeaPumHeaCoo.PEle, multiplex3_3.u2[1]) annotation (Line(points={
          {-30,63.5},{-30,38},{-50,38},{-50,-28}}, color={0,0,127}));
  connect(const.y, multiplex3_4.u2[1])
    annotation (Line(points={{-79,40},{50,40},{50,-28}}, color={0,0,127}));
  connect(refCycHeaPumAmbHea.QEva_flow, multiplex3_4.u3[1]) annotation (Line(
        points={{74,63.5},{74,54},{43,54},{43,-28}}, color={0,0,127}));
  connect(refCycHeaPumAmbHea.QCon_flow, multiplex3_2.u3[1]) annotation (Line(
        points={{66,63.5},{66,56},{2,56},{2,-7},{18,-7}}, color={0,0,127}));
  connect(refCycHeaPumAmbHea.PEle, multiplex3_3.u3[1]) annotation (Line(points={
          {70,63.5},{70,50},{-57,50},{-57,-28}}, color={0,0,127}));
  connect(const.y, multiplex3_1.u3[1]) annotation (Line(points={{-79,40},{-10,40},
          {-10,-7},{-18,-7}}, color={0,0,127}));
  connect(sigBus.mod, swiQCon1.index) annotation (Line(
      points={{0,100},{0,-70},{38,-70}},
      color={255,204,51},
      thickness=0.5));
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
    May 2, 2024, by Michael Wetter:<br/>
    Refactored check for device identifiers.<br/>
    This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">IBPSA, #1576</a>.
  </li>
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
  the model <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
  Buildings.Fluid.HeatPumps.ModularReversible.Modular</a> and extending models
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
end RefrigerantCycle4Pipe;
