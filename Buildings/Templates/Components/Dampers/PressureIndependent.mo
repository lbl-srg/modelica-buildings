within Buildings.Templates.Components.Dampers;
model PressureIndependent "Pressure independent damper"
  extends Buildings.Templates.Components.Interfaces.Damper(final typ=Types.Damper.PressureIndependent);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    if loc==Types.Location.Terminal           then
      dat.getReal(varName=id + ".Mechanical.Discharge air mass flow rate.value")
    else 0
    "Mass flow rate"
    annotation (Dialog(group="Nominal condition"), Evaluate=true);
  parameter Modelica.SIunits.PressureDifference dpDamper_nominal(
    min=0, displayUnit="Pa")=
    if loc==Types.Location.Terminal           then
      dat.getReal(varName=id + ".Mechanical.VAV damper pressure drop.value")
    else 0
    "Pressure drop of open damper"
    annotation (Dialog(group="Nominal condition"));

  Fluid.Actuators.Dampers.PressureIndependent damPreInd(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamper_nominal)
    "Pressure independent damper"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sensors.VolumeFlowRate VDis_flow(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    "Volume flow rate sensor"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(damPreInd.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(damPreInd.y_actual, bus.inp.yDamVAV_actual) annotation (Line(points={
          {5,7},{20,7},{20,80},{4,80},{4,100},{0.1,100},{0.1,100.1}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(bus.out.yDamVAV, damPreInd.y) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, VDis_flow.port_a)
    annotation (Line(points={{-100,0},{-50,0}}, color={0,127,255}));
  connect(VDis_flow.port_b, damPreInd.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(VDis_flow.V_flow, bus.inp.VDis_flow) annotation (Line(points={{-40,11},
          {-40,80},{-4,80},{-4,100},{0.1,100},{0.1,100.1}}, color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end PressureIndependent;
