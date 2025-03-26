within Buildings.Fluid.Chillers.ModularReversible.BaseClasses;
model RefrigerantCycle "Refrigerant cycle model of a chiller"
  extends Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.PartialModularRefrigerantCycle;

  parameter Boolean allowDifferentDeviceIdentifiers=false
    "if use_rev=true, device data for cooling and heating need to entered. Set allowDifferentDeviceIdentifiers=true to allow different device identifiers devIde"
    annotation(Dialog(enable=use_rev));

  replaceable model RefrigerantCycleChillerCooling =
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.NoCooling(
        useInChi=true)
    constrainedby
      Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle
    "Replaceable model for refrigerant cycle of a chiller in main operation mode"
    annotation (choicesAllMatching=true);

  replaceable model RefrigerantCycleChillerHeating =
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.NoHeating(
        useInHeaPum=true)
    constrainedby
      Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle
    "Replaceable model for refrigerant cycle of a chiller in reversed operation mode"
    annotation (Dialog(enable=use_rev),choicesAllMatching=true);

  RefrigerantCycleChillerCooling refCycChiCoo
    "Refrigerant cycle instance for cooling"
    annotation (Placement(transformation(extent={{21,40},{60,80}}, rotation=0)));
  RefrigerantCycleChillerHeating refCycChiHea
    "Refrigerant cycle instance for heating"
    annotation (Placement(transformation(extent={{-60,38},{-19,80}}, rotation=0)));

protected
  parameter String devIde =
    if use_rev then refCycChiHea.devIde else refCycChiCoo.devIde
    "Data source for refrigerant cycle";

initial algorithm
  if not allowDifferentDeviceIdentifiers then
    assert(
      devIde == refCycChiCoo.devIde,
      "In " + getInstanceName() + ": Device identifiers devIde for reversible operation are not equal.
      Cooling device identifier is '" + refCycChiCoo.devIde + "' but heating is '"
      + devIde + "'. To allow this, set 'allowDifferentDeviceIdentifiers=true'.",
      AssertionLevel.error);
  end if;
equation
  connect(pasTrhModSet.u, sigBus.coo);

  connect(sigBus,refCycChiHea.sigBus)  annotation (Line(
      points={{0,100},{0,92},{-39.3292,92},{-39.3292,80}},
      color={255,204,51},
      thickness=0.5));
  connect(sigBus,refCycChiCoo.sigBus)  annotation (Line(
      points={{0,100},{0,92},{40.6625,92},{40.6625,80}},
      color={255,204,51},
      thickness=0.5));

  connect(swiPEle.u2, sigBus.coo) annotation (Line(points={{2.22045e-15,-58},{
          2.22045e-15,-2},{0,-2},{0,100}},
                               color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(swiQEva.u2, sigBus.coo) annotation (Line(points={{-58,0},{0,0},{0,100}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(swiQCon.u2, sigBus.coo) annotation (Line(points={{58,0},{0,0},{0,100}},
        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(refCycChiCoo.QEva_flow, swiQEva.u1) annotation (Line(points={{53.5,
          38.3333},{53.5,24},{-10,24},{-10,8},{-58,8}}, color={0,0,127}));
  connect(refCycChiCoo.QCon_flow, swiQCon.u1)
    annotation (Line(points={{27.5,38.3333},{27.5,8},{58,8}}, color={0,0,127}));
  connect(refCycChiCoo.PEle, swiPEle.u1) annotation (Line(points={{40.5,38.3333},
          {40.5,-48},{8,-48},{8,-58}}, color={0,0,127}));
  connect(refCycChiHea.PEle, swiPEle.u3) annotation (Line(points={{-39.5,36.25},{
          -39.5,-48},{-8,-48},{-8,-58}}, color={0,0,127}));
  connect(refCycChiHea.QCon_flow, swiQEva.u3) annotation (Line(points={{-53.1667,
          36.25},{-53.1667,-8},{-58,-8}}, color={0,0,127}));
  connect(refCycChiHea.QEva_flow, swiQCon.u3) annotation (Line(points={{-25.8333,
          36.25},{-25.8333,-8},{58,-8}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
  <ul>
  <li>
  May 2, 2024, by Michael Wetter:<br/>
  Refactored check for device identifiers.<br/>
  This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">IBPSA, #1576</a>.
  </li>
  <li>
    <i>May 22, 2019,</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Modular refrigerant cycle model for chiller applications used in
  the model <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Modular\">
  Buildings.Fluid.Chillers.ModularReversible.Modular</a> and extending models
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
</html>"));
end RefrigerantCycle;
