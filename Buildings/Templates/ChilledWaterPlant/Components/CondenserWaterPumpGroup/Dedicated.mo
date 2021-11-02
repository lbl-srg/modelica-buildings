within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup;
model Dedicated
  extends
    Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.CondenserWaterPumpGroup(
    final typ=Types.CondenserWaterPumpGroup.DedicatedPrimary,
    final has_wse = false);

  BaseClasses.DedicatedPumps pumPri
                                   "Primary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(busCon.out.ySpePumPri, pumPri.y) annotation (Line(
      points={{0,100},{0,80},{0,80},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.y_actual, busCon.inp.uStaPumPri) annotation (Line(points={{11,8},{
          20,8},{20,80},{0,80},{0,100}},        color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_a, pumPri.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pumPri.V_flow, busCon.inp.VPri_flow) annotation (Line(points={{11,5},{
          20,5},{20,80},{0,80},{0,100}},        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumPri.ports_b, ports_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-80,-80},{80,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Dedicated;
