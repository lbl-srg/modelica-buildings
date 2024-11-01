within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model Direct
  "Direct evaporative cooler"

  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol);

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,80}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={90,40}, extent={{-20,-20},{20,20}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations dirEvaCoo(
    redeclare final package Medium = Medium,
    final dep=dep,
    final padAre=padAre)
    "Direct evaporative cooling calculator"
    annotation (Placement(transformation(origin={30,60}, extent={{-10,-10},{10,10}})));

protected
  Medium.ThermodynamicState staInl=Medium.setState_phX(
    p=port_a.p, h=inStream(port_a.h_outflow), X=inStream(port_a.Xi_outflow))
    "State of inlet medium";

  Modelica.Blocks.Sources.RealExpression TDryBul(
    y=Medium.temperature(state=staInl))
    "Inlet air drybulb temperature"
    annotation (Placement(transformation(extent={{-80,82},{-60,98}})));

  Modelica.Blocks.Sources.RealExpression XInl[Medium.nXi](
    y=inStream(port_a.Xi_outflow))
    "Inlet air humidity ratio"
    annotation (Placement(transformation(extent={{-80,72},{-60,88}})));

  Modelica.Blocks.Sources.RealExpression pInl(
    y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-80,62},{-60,78}})));

  Modelica.Blocks.Sources.RealExpression V_flow(
    y=port_a.m_flow/Medium.density(staInl))
    "Inlet air volume flowrate"
    annotation (Placement(transformation(extent={{-80,52},{-60,68}})));

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = Medium)
    "Calculate wet bulb temperature from inlet medium state"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));

equation
  connect(dirEvaCoo.dmWat_flow, vol.mWat_flow)
    annotation (Line(points={{42,60},{60,60},{60,40},{-30,40},{-30,-18},{-11,-18}},
                                                               color={0,0,127}));
  connect(dirEvaCoo.dmWat_flow, dmWat_flow)
    annotation (Line(points={{42,60},{60,60},{60,80},{120,80}}, color={0,0,127}));

  connect(TDryBul.y, dirEvaCoo.TDryBulIn) annotation (Line(points={{-59,90},{-30,
          90},{-30,62},{18,62}}, color={0,0,127}));
  connect(TDryBul.y, wetBul.TDryBul) annotation (Line(points={{-59,90},{-30,90},
          {-30,88},{-21,88}}, color={0,0,127}));
  connect(wetBul.TWetBul, dirEvaCoo.TWetBulIn) annotation (Line(points={{1,80},{
          10,80},{10,66},{18,66}}, color={0,0,127}));
  connect(XInl.y, wetBul.Xi)
    annotation (Line(points={{-59,80},{-21,80}}, color={0,0,127}));
  connect(pInl.y, wetBul.p) annotation (Line(points={{-59,70},{-40,70},{-40,72},
          {-21,72}}, color={0,0,127}));
  connect(pInl.y, dirEvaCoo.p) annotation (Line(points={{-59,70},{-40,70},{-40,54},
          {18,54}}, color={0,0,127}));
  connect(V_flow.y, dirEvaCoo.V_flow) annotation (Line(points={{-59,60},{-30,60},
          {-30,58},{18,58}}, color={0,0,127}));
annotation (defaultComponentName="dirEvaCoo",
Icon(graphics={
  Rectangle(lineColor={0,0,255}, fillColor={95,95,95}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-70,60},{70,-60}}),
  Rectangle(lineColor={0,0,255}, fillColor={0,0,255}, pattern = LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-101,5},{100,-4}}),
  Rectangle(lineColor={0,0,255}, fillColor={255,0,0}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{0, -4},{100, 5}}),
  Text(textColor={0,0,127}, extent={{-52,-60}, {58,-120}}, textString="m=%m_flow_nominal"),
  Rectangle(lineColor={0,0,255}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-100, 5}, {101, -5}}),
  Rectangle(lineColor={0, 0, 255}, fillColor={0, 62, 0}, pattern=LinePattern.None,
            fillPattern=FillPattern.Solid, extent={{-70, 60}, {70, -60}}),
  Polygon(lineColor={255, 255, 255}, fillColor={255, 255, 255},
            fillPattern=FillPattern.Solid,
            points={{42, 42}, {54, 34}, {54, 34}, {42, 28}, {42, 30}, {50, 34}, {50, 34}, {42, 40}, {42, 42}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={255, 255, 255},
            fillPattern=FillPattern.Solid, extent={{58, -54}, {54, 52}}),
  Polygon(lineColor={255, 255, 255}, fillColor={255, 255, 255},
          fillPattern=FillPattern.Solid,
          points={{42, 10}, {54, 2}, {54, 2}, {42, -4}, {42, -2}, {50, 2}, {50, 2}, {42, 8}, {42, 10}}),
  Polygon(lineColor={255, 255, 255}, fillColor={255, 255, 255},
          fillPattern=FillPattern.Solid,
          points={{42, -26}, {54, -34}, {54, -34}, {42, -40}, {42, -38}, {50, -34}, {50, -34}, {42, -28}, {42, -26}})},
  coordinateSystem(extent={{-100, -100}, {100, 100}})),
Documentation(
info="<html>
<p>
Model for a direct evaporative cooler.
</p>
<p>
This model cools the airstream down by adiabatically increasing the humidity 
mass fraction of the air. The mass of water vapour added to the air is reported by the 
output signal <code>dmWat_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(graphics={Line(origin={28, 62}, points={{0, 0}})}));
end Direct;
