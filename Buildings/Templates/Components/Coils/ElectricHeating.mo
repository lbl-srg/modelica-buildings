within Buildings.Templates.Components.Coils;
model ElectricHeating "Modulating electric heating coil"
  extends Buildings.Templates.Components.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.ElectricHeating,
    final typVal=Buildings.Templates.Components.Types.Valve.None);

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hex(
    redeclare final package Medium = MediumAir,
    final Q_flow_nominal=dat.Q_flow_nominal,
    final m_flow_nominal=dat.mAir_flow_nominal,
    final dp_nominal=dat.dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(port_a, hex.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(hex.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(bus.y, hex.u) annotation (Line(
      points={{0,100},{0,20},{-20,20},{-20,6},{-12,6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model for a modulating electric heating coil.
</p>
</html>"));
end ElectricHeating;
