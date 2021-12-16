within Buildings.Templates.Components.HeatExchangers;
model DXCoilMultiStage "Direct expansion coil - Multi-stage"
  extends
    Buildings.Templates.Components.HeatExchangers.Interfaces.PartialCoilDirectExpansion(
    final typ=Buildings.Templates.Components.Types.HeatExchanger.DXMultiStage);

  Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage coi(
    redeclare final package Medium = Medium,
    final datCoi=datCoi,
    final dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "DX coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough TWet if not have_dryCon
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Routing.RealPassThrough TDry if have_dryCon
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  /* Control point connection - start */
  connect(bus.y, coi.stage);
  /* Control point connection - end */
  connect(port_a, coi.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(busWea.TWetBul, TWet.u) annotation (Line(
      points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busWea.TDryBul, TDry.u) annotation (Line(
      points={{-60,100},{-60,40},{-80,40},{-80,-20},{-62,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TWet.y, coi.TConIn) annotation (Line(points={{-39,20},{-30,20},{-30,3},
          {-11,3}}, color={0,0,127}));
  connect(TDry.y, coi.TConIn) annotation (Line(points={{-39,-20},{-30,-20},{-30,
          3},{-11,3}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DXCoilMultiStage;
