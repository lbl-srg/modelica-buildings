within Buildings.Templates.Components.Coils;
model DirectExpansion "Direct expansion"
  extends Buildings.Templates.Components.Interfaces.Coil(
    final typ=Types.Coil.DirectExpansion,
    final typHex=hex.typ,
    final typAct=Types.Actuator.None,
    final have_sou=false,
    final have_weaBus=true);

  inner parameter Boolean have_dryCon = true
    "Set to true for purely sensible cooling of the condenser";

  // DX coils get their nominal flow rate assigned from the data record.
  // Only the air pressure drop needs to be declared.
  inner parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + ".Mechanical." + funStr + " coil.Air pressure drop.value")
    "Air pressure drop"
    annotation (
      Dialog(group="Nominal condition"),
      Evaluate=true);

  replaceable Interfaces.HeatExchangerDX hex(redeclare final package Medium =
        MediumAir, final dp_nominal=dpAir_nominal) "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(weaBus, hex.weaBus) annotation (Line(
      points={{-60,100},{-60,20},{-6,20},{-6,10}},
      color={255,204,51},
      thickness=0.5));
  connect(busCon,hex.busCon)  annotation (Line(
      points={{0,100},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(hex.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectExpansion;
