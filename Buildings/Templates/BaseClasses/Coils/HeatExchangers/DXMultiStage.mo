within Buildings.Templates.BaseClasses.Coils.HeatExchangers;
model DXMultiStage
  extends Buildings.Templates.Interfaces.HeatExchangerDX(
    final typ=Types.HeatExchanger.DXMultiStage);

  replaceable parameter
    Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi
    constrainedby Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil
    "Performance record"
    annotation(choicesAllMatching=true);

  outer parameter Boolean have_dryCon
    "Set to true for purely sensible cooling of the condenser";

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
  connect(port_a, coi.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(weaBus.TWetBul, TWet.u) annotation (Line(
      points={{-60,100},{-60,40},{-80,40},{-80,20},{-62,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, TDry.u) annotation (Line(
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
  connect(busCon.out.yCoiCoo, coi.stage) annotation (Line(
      points={{0.1,100.1},{0.1,100.1},{0.1,20},{-20,20},{-20,8},{-11,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DXMultiStage;
