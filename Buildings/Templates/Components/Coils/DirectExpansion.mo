within Buildings.Templates.Components.Coils;
model DirectExpansion "Direct expansion"
  extends Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.DirectExpansion,
    final typHex=hex.typ,
    final typAct=Buildings.Templates.Components.Types.Actuator.None,
    final have_sou=false,
    final have_weaBus=true);

  inner parameter Boolean have_dryCon = true
    "Set to true for purely sensible cooling of the condenser";

  replaceable Buildings.Templates.Components.HeatExchangers.Interfaces.PartialHeatExchangerDX
    hex(
      redeclare final package Medium = MediumAir,
      final m_flow_nominal=mAir_flow_nominal,
      final dp_nominal=dpAir_nominal)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(busWea,hex.busWea)  annotation (Line(
      points={{-60,100},{-60,20},{-6,20},{-6,10}},
      color={255,204,51},
      thickness=0.5));
  connect(bus, hex.bus) annotation (Line(
      points={{0,100},{0,10}},
      color={255,204,51},
      thickness=0.5));
  connect(hex.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
      Bitmap(
        extent={{-53,-100},{53,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Coils/WaterBasedCooling.svg")}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DirectExpansion;
