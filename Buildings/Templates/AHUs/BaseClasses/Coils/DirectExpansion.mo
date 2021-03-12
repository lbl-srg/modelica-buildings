within Buildings.Templates.AHUs.BaseClasses.Coils;
model DirectExpansion
  extends Interfaces.Coil(
    final typ=Types.Coil.DirectExpansion,
    final have_weaBus=true,
    final have_sou=false,
    final typAct=Types.Actuator.None,
    final typHex=hex.typ);

  parameter Boolean have_dryCon = true
    "Set to true for purely sensible cooling of the condenser";

  replaceable HeatExchangers.DXVariableSpeed hex
    constrainedby Interfaces.HeatExchangerDX(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=mAir_flow_nominal,
      final dp_nominal=dpAir_nominal)
    "Heat exchanger"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(weaBus, hex.weaBus) annotation (Line(
      points={{-60,100},{-60,20},{-6,20},{-6,10}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, hex.ahuBus) annotation (Line(
      points={{0,100},{0,10}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectExpansion;
