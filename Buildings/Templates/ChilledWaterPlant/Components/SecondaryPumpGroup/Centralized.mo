within Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup;
model Centralized "Centralized secondary pumping"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.SecondaryPumpGroup.Interfaces.SecondaryPumpGroup(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.SecondaryPumpGroup.None);

  parameter Modelica.SIunits.PressureDifference dpValve_nominal=
    dat.getReal(varName=id + ".SecondaryPump.dpValve_nominal.value")
    "Shutoff valve pressure drop";

  BaseClasses.ParallelPumps pum(
    final m_flow_nominal=m_flow_nominal,
    final per=per,
    final nPum=nPum,
    final dp_nominal=dp_nominal,
    final dpValve_nominal=dpValve_nominal) "Secondary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    have_sen=has_floSen,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  replaceable parameter Fluid.Movers.Data.Generic per(pressure(V_flow=
          m_flow_nominal/1000 .* {0,1,2}, dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pum.y_actual, busCon.uStaPumSec) annotation (Line(points={{11,8},{20,8},
          {20,80},{0,80},{0,100}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.ySpe, pum.y) annotation (Line(
      points={{0,100},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pum.port_b, V_flow.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  connect(V_flow.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(V_flow.y, busCon.V_flow) annotation (Line(points={{50,12},{50,80},{0,
          80},{0,100}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-60,0},{-100,0}},
          color={28,108,200},
          thickness=1),
        Line(
          points={{-8,40},{-60,40},{-60,-40},{-8,-40}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,0},{40,80}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{40,60},{60,60},{60,-20},{40,-20}},
          color={28,108,200},
          thickness=1),
                    Bitmap(
        extent={{-40,-80},{40,0}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
        Line(
          points={{60,0},{100,0}},
          color={28,108,200},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Centralized;
