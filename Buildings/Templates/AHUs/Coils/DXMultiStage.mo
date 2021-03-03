within Buildings.Experimental.Templates.AHUs.Coils;
model DXMultiStage
  extends Interfaces.Coil(
    final typ=Types.Coil.DXMultiStage,
    final have_weaBus=true,
    final have_sou=false,
    final typAct=Types.Actuator.None,
    final typHex=Types.HeatExchanger.None);

  Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage coi(
    redeclare final package Medium = MediumAir,
    final datCoi=dat.datCoi,
    final dp_nominal=dat.dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Routing.RealPassThrough TWet if not dat.have_dryCon
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Routing.RealPassThrough TDry if dat.have_dryCon
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(port_a, coi.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(coi.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(weaBus.TWetBul, TWet.u) annotation (Line(
      points={{50,100},{50,40},{-80,40},{-80,20},{-62,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, TDry.u) annotation (Line(
      points={{50,100},{50,40},{-80,40},{-80,-20},{-62,-20}},
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
  connect(ahuBus.ahuO.yCoiCoo, coi.stage) annotation (Line(
      points={{0.1,100.1},{-20,100.1},{-20,8},{-11,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DXMultiStage;
