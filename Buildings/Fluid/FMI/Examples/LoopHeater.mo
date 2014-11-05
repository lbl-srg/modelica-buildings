within Buildings.Fluid.FMI.Examples;
model LoopHeater "Fluid loop with a heater"
  extends Modelica.Icons.Example;
  IdealSource_m_flow sou "Flow source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

  HeaterCooler_u     hea "Flow resistance"
    annotation (Placement(transformation(extent={{-20,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Constant m_flow(k=0) "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Constant uHea(k=0) "Control signal for heater"
    annotation (Placement(transformation(extent={{30,-34},{10,-14}})));
equation
  connect(m_flow.y, sou.m_flow_in) annotation (Line(
      points={{-59,50},{-30.2,50},{-30.2,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hea.outlet, sou.inlet) annotation (Line(
      points={{-41,-30},{-52,-30},{-52,10},{-41,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(sou.outlet, hea.inlet) annotation (Line(
      points={{-19,10},{-10,10},{-10,-30},{-19,-30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(uHea.y, hea.u) annotation (Line(
      points={{9,-24},{-18,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end LoopHeater;
