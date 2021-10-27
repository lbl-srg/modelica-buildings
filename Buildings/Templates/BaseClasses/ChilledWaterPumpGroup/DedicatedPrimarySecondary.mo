within Buildings.Templates.BaseClasses.ChilledWaterPumpGroup;
model DedicatedPrimarySecondary
  extends Buildings.Templates.Interfaces.ChilledWaterPumpGroup(
    final typ=Types.ChilledWaterPumpGroup.DedicatedPrimary,
    final has_ParChi = true,
    final has_WSEByp = false);

  Fluid.FixedResistances.Junction splByp(redeclare package Medium = Medium,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Common leg or bypass splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,0})));
  BaseClasses.DedicatedPumps pumPri
                                   "Primary pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BaseClasses.HeaderedPumps pumSec "Secondary pumps"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(busCon.out.ySpePumPri, pumPri.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{0,80},{0,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(pumPri.y_actual, busCon.inp.uStaPumPri) annotation (Line(points={{11,8},{
          20,8},{20,80},{0.1,80},{0.1,100.1}},  color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ports_parallel, pumPri.ports_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(pumPri.V_flow, busCon.inp.VPri_flow) annotation (Line(points={{11,5},
          {20,5},{20,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumPri.port_b, splByp.port_1)
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  connect(splByp.port_2, pumSec.port_a)
    annotation (Line(points={{50,0},{60,0}}, color={0,127,255}));
  connect(pumSec.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(busCon.out.ySpePumSec, pumSec.y) annotation (Line(
      points={{0.1,100.1},{0.1,80},{70,80},{70,12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumSec.V_flow, busCon.inp.VSec_flow) annotation (Line(points={{81,5},
          {86,5},{86,80},{0.1,80},{0.1,100.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(pumSec.y_actual, busCon.inp.uStaPumSec) annotation (Line(points={{81,
          8},{86,8},{86,80},{0.1,80},{0.1,100.1}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(splByp.port_3, port_byp) annotation (Line(points={{40,-10},{40,-40},{
          0,-40},{0,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                    Bitmap(
        extent={{-80,-30},{-20,30}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg"),
                    Bitmap(
        extent={{14,-28},{74,32}},
        fileName="modelica://Buildings/Resources/Images/Templates/BaseClasses/Fans/SingleVariable.svg")}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DedicatedPrimarySecondary;
