within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
partial model PartialDesiccant
  "Partial model for desiccant dehumidifiers"
  replaceable package Medium1 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Process air";
  replaceable package Medium2 =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Regeneration air";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal process air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal regeneration air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp1_nominal(
    displayUnit="Pa")
    "Nominal process air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dp2_nominal(
    displayUnit="Pa")
    "Nominal regeneration air pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Time tau=30
    "Time constant of the regeneration air at nominal flow ";
  parameter Real PMot_nominal(
    final unit="W")
    "Nominal power consumption of the motor"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Velocity vPro_nominal
    "Nominal velocity of the process air"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.VolumeFlowRate VPro_flow_nominal = m1_flow_nominal/rho_Pro_default
    "Nominal volumetric flow rate of the process air"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Velocity vReg_nominal
    "Nominal velocity of the regeneration air"
    annotation (Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.VolumeFlowRate VReg_flow_nominal = m2_flow_nominal/rho_Reg_default
    "Nominal volumetric flow rate of the regeneration air"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate QReg_flow_nominal
    "Nominal regeneration heating capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter  Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic perDat
    "Performance data"
    annotation (Placement(transformation(extent={{60,-78},{80,-58}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium1)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-250,-110},{-230,-90}}),
    iconTransformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium2)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-230,70},{-250,90}}),
    iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium1)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{110,-110},{90,-90}}),
    iconTransformation(extent={{110,-90},{90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium2)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{90,70},{110,90}}),
        iconTransformation(extent={{90,70},{110,90}})));

protected
  Buildings.Fluid.Interfaces.PrescribedOutlet outCon(
    redeclare package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Model to set outlet conditions"
    annotation (Placement(transformation(extent={{-6,-110},{14,-90}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance dehPer(
    final vPro_nominal=vPro_nominal,
    final VPro_flow_nominal=VPro_flow_nominal,
    final vReg_nominal=vReg_nominal,
    final VReg_flow_nominal=VReg_flow_nominal,
    final QReg_flow_nominal=QReg_flow_nominal,
    final per=perDat)
    "Calculate the performance of the dehumidifier"
    annotation (Placement(transformation(extent={{-58,-94},{-38,-74}})));
  Modelica.Blocks.Sources.RealExpression VPro_flow(
      final y(final unit="m3/s")= outCon.port_a.m_flow/Medium1.density(
      state=Medium1.setState_phX(
      p=port_a1.p,
      h=port_a1.h_outflow,
      X=port_a1.Xi_outflow)))
    "Process air volume flow rate"
    annotation (Placement(transformation(extent={{-110,-106},{-90,-86}})));
  Modelica.Blocks.Sources.RealExpression TProEnt(
    final y(final unit="K")=
    Medium1.temperature(Medium1.setState_phX(
    p=port_a1.p,
    h=inStream(port_a1.h_outflow),
    X=inStream(port_a1.Xi_outflow))))
    "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-110,-38},{-90,-18}})));
  Modelica.Blocks.Sources.RealExpression TRegEnt(
    final y(final unit="K")=
    Medium2.temperature(Medium2.setState_phX(
    p=port_a2.p,
    h=inStream(port_a2.h_outflow),
    X=inStream(port_a2.Xi_outflow))))
    "Temperature of the regeneration air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-110,-54},{-90,-34}})));
   Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    vol(redeclare final package Medium = Medium2,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final m_flow_nominal=m2_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=m2_flow_nominal*tau/rho_Reg_default,
    nPorts=1)
    "Volume for the regeneration air stream"
     annotation (Placement(transformation(extent={{-105,66},{-85,46}})));
  Modelica.Blocks.Math.Gain gai1(
    final k=-1)
    "Find the opposite number of the input"
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));
  Modelica.Blocks.Math.Gain gai2(
    final k=-1)
    "Find the opposite number of the input"
    annotation (Placement(transformation(extent={{0,30},{-20,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-62,50},{-82,30}})));
  Modelica.Blocks.Sources.RealExpression mPro_flow(
   final y(final unit="kg/s")= outCon.port_a.m_flow)
   "Process air mass flow rate"
    annotation (Placement(transformation(extent={{-110,-124},{-90,-104}})));
  parameter Integer i1_w(min=1, fixed=false)
   "Index for water substance";
  parameter Medium2.ThermodynamicState sta_Reg_default=Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default)
   "Default state of the regeneration air";
  parameter Modelica.Units.SI.Density rho_Reg_default=Medium2.density(sta_Reg_default)
    "Default density of the regeneration air";
  parameter Medium2.ThermodynamicState sta_Pro_default=Medium2.setState_pTX(
      T=Medium2.T_default,
      p=Medium2.p_default,
      X=Medium2.X_default)
    "Default state of the process air";
  parameter Modelica.Units.SI.Density rho_Pro_default=Medium2.density(sta_Pro_default)
    "Default density of the process air";
initial algorithm
  i1_w:= -1;
  for i in 1:Medium1.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium1.substanceNames[i],
                                            string2="Water",
                                            caseSensitive=false) then
      i1_w := i;
    end if;
   end for;

equation
  connect(dehPer.TProLea, outCon.TSet)
    annotation (Line(points={{-37,-76},{-12,-76},
          {-12,-92},{-7,-92}}, color={0,0,127}));
  connect(dehPer.X_w_ProLea, outCon.X_wSet)
    annotation (Line(points={{-37,-80},{
          -14,-80},{-14,-96},{-7,-96}}, color={0,0,127}));
  connect(VPro_flow.y, dehPer.VPro_flow)
    annotation (Line(points={{-89,-96},{-78,
          -96},{-78,-92.2},{-59,-92.2}}, color={0,0,127}));
  connect(TProEnt.y, dehPer.TProEnt)
    annotation (Line(points={{-89,-28},{-70,-28},
          {-70,-79.8},{-59,-79.8}}, color={0,0,127}));
  connect(TRegEnt.y, dehPer.TRegEnt)
    annotation (Line(points={{-89,-44},{-84,-44},
          {-84,-84},{-59,-84}}, color={0,0,127}));
  connect(outCon.mWat_flow, gai1.u)
    annotation (Line(points={{15,-96},{18,-96},{
          18,-92},{20,-92},{20,10},{2,10}},
          color={0,0,127}));
  connect(gai1.y, vol.mWat_flow)
    annotation (Line(points={{-21,10},{-40,10},{
          -40,20},{-130,20},{-130,48},{-107,48}},
          color={0,0,127}));
  connect(preHeaFlo.Q_flow, gai2.y)
    annotation (Line(points={{-62,40},{-21,40}}, color={0,0,127}));
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(points={{-82,40},{-120,
          40},{-120,56},{-105,56}}, color={191,0,0}));
  connect(gai2.u,outCon. Q_flow)
    annotation (Line(points={{2,40},{40,40},{40,-92},
          {15,-92}}, color={0,0,127}));
  connect(vol.ports[1], port_b2)
    annotation (Line(points={{-95,66},{-144,66},{
          -144,80},{-240,80}},
          color={0,127,255}));
  connect(mPro_flow.y, dehPer.mPro_flow)
    annotation (Line(points={{-89,-114},{-48,
          -114},{-48,-95}}, color={0,0,127}));
  connect(outCon.port_b, port_b1)
    annotation (Line(points={{14,-100},{100,-100}}, color={0,127,255}));
    annotation (Dialog(group="Nominal condition"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
        {100,100}}), graphics={
        Rectangle(
          extent={{-86,92},{6,-90}},
          lineColor={28,108,200},
          fillPattern=FillPattern.CrossDiag,
          fillColor={255,255,255}),
        Rectangle(
          extent={{-94,86},{-86,76}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-92,-74},{-86,-84}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{6,-74},{98,-84}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={106,162,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-104},{151,-144}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-240,-140},{100,100}})),
    Documentation(info="<html>
<p>
Partial model of a desiccant dehumidifier.
Specifically, this model considers the following configuration.
</p>
<p align=\"left\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/Dehumidifiers/Desiccant/BaseClasses/dehumidifer_schematic.png\"
alt=\"Dehumidifer_Schematic.png\" border=\"1\"/>
</p>
<p>
This model should be extended with a heating coil and/or a regeneration air fan.
It takes two inputs: a boolean signal for dehumidification and a real signal for the motor speed ratio.
  <ul>
     <li>
     The boolean signal determines if the dehumidifier occurs or not.
     </li>
     <li>
     The real signal specifies the amount of sensible and latent heat exchange that occurs in the dehumidifier and can be
     used to adjust the outline condition of the process air.
     </li>
  </ul>
More details can be found in <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance\">
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.Performance</a>.
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>First implementation. </li>
</ul>
</html>"));
end PartialDesiccant;
