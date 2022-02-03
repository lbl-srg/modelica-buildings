within Buildings.Templates.Components.Coils;
model ElectricHeating "Electric heating coil"
  extends Buildings.Templates.Components.Coils.Interfaces.PartialCoil(
    final typ=Buildings.Templates.Components.Types.Coil.ElectricHeating,
    final typHex=Buildings.Templates.Components.Types.HeatExchanger.None,
    final typVal=Buildings.Templates.Components.Types.Valve.None,
    final have_sou=false,
    final have_weaBus=false);

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal(min=0)=
    dat.getReal(varName=id + ".mechanical.coil" + funStr + ".Q_flow_nominal.value")
    "Nominal heat flow rate"
    annotation (Dialog(
      group="Nominal condition"));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u hex(
    redeclare final package Medium = MediumAir,
    final Q_flow_nominal=Q_flow_nominal,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal,
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
      thickness=0.5));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<p>
Using modified getReal function with annotation(__Dymola_translate=true)
avoids warning for non literal nominal attributes.
Not supported by OCT though:
Compliance error at line 8, column 4,
  Constructors for external objects is not supported in functions

</p>
</html>"));
end ElectricHeating;
