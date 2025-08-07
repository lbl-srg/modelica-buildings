within Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses;
partial model PartialDesiccant
  "Partial model for desiccant dehumidifiers"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialCondensingGases
    "Process air";
  parameter Buildings.Fluid.Dehumidifiers.Desiccant.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{120,104},{140,124}})));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(
                tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance"));
   parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics"));
  Buildings.Fluid.FixedResistances.PressureDrop resReg(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mReg_flow_nominal,
    from_dp=from_dp,
    final dp_nominal=per.dpReg_nominal,
    final linearized=linearizeFlowResistance)
    "Flow resistance in the regeneration air stream"
    annotation (Placement(transformation(extent={{-100,70},{-120,90}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electric power consumption"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
    iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    redeclare final package Medium = Medium)
    "Fluid connector a1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-190,-110},{-170,-90}}),
    iconTransformation(extent={{-110,-90},{-90,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2(
    redeclare final package Medium = Medium)
    "Fluid connector b2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{-170,70},{-190,90}}),
    iconTransformation(extent={{-110,70},{-90,90}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    redeclare final package Medium = Medium)
    "Fluid connector b1 of the supply air (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{190,-110},{170,-90}}),
    iconTransformation(extent={{110,-70},{90,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2(
    redeclare final package Medium = Medium)
    "Fluid connector a2 of the exhaust air (positive design flow direction is from port_a2 to port_b2)"
    annotation (Placement(transformation(extent={{170,70},{190,90}}),
    iconTransformation(extent={{90,70},{110,90}})));

protected
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRegEnt(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mReg_flow_nominal,
    tau=10)
    "Temperature of the regeneration air entering the dehumidifier"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SensibleHeat senHea
    "Sensible heat exchange calculation"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemProEnt(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    tau=10) "Temperature of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraProEnt(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    tau=10)
    "Humidity of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-30,-110},{-10,-90}})));
  Modelica.Blocks.Sources.RealExpression reaExp(
    final y=Medium.enthalpyOfVaporization(Medium.T_default))
    "Vaporization enthalpy"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Fluid.Interfaces.PrescribedOutlet outCon(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=per.mPro_flow_nominal,
    final energyDynamics=energyDynamics)
    "Model to set outlet conditions"
    annotation (Placement(transformation(extent={{70,-110},{90,-90}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir
    vol(redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    final m_flow_nominal=per.mReg_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    V=1,
    nPorts=2)
    "Volume for the regeneration air stream"
    annotation (Placement(transformation(extent={{-45,80},{-25,60}})));
  Modelica.Blocks.Math.Gain gai2(
    final k=-1)
    "Find the opposite number of the input"
    annotation (Placement(transformation(extent={{60,30},{40,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-2,50},{-22,30}})));
  Buildings.Fluid.Sensors.MassFlowRate senProMasFlo(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Process air mass flow rate"
    annotation (Placement(transformation(extent={{140,-110},{160,-90}})));
  Buildings.Fluid.Sensors.MassFlowRate senRegMasFlo(
    redeclare package Medium = Medium,
    final allowFlowReversal=allowFlowReversal)
    "Regeneration air mass flow rate"
    annotation (Placement(transformation(extent={{120,70},{100,90}})));
  Modelica.Blocks.Math.Gain gai1(
    final k=-1)
    "Find the opposite number of the input"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Sensible heat exchange calculation"
    annotation (Placement(transformation(extent={{120,30},{100,50}})));
equation
  connect(preHeaFlo.Q_flow, gai2.y)
    annotation (Line(points={{-2,40},{39,40}},
    color={0,0,127}));
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(points={{-22,40},{-80,40},{-80,70},{-45,70}},
    color={191,0,0}));
  connect(port_b1,senProMasFlo. port_b)
    annotation (Line(points={{180,-100},{160,-100}}, color={0,127,255}));
  connect(outCon.port_b,senProMasFlo. port_a)
    annotation (Line(points={{90,-100},{140,-100}}, color={0,127,255}));
  connect(senRegMasFlo.port_a, port_a2)
    annotation (Line(points={{120,80},{180,80}},  color={0,127,255}));
  connect(gai1.y, vol.mWat_flow) annotation (Line(points={{59,0},{-60,0},{-60,62},
          {-47,62}}, color={0,0,127}));
  connect(gai1.u, outCon.mWat_flow)
    annotation (Line(points={{82,0},{100,0},{100,-96},{91,-96}}, color={0,0,127}));
  connect(senProMasFlo.m_flow, senHea.mPro_flow)
    annotation (Line(points={{150,-89},{150,-76},{10,-76},{10,-56},{19,-56}},
        color={0,0,127}));
  connect(senMasFraProEnt.X, senHea.X_w_ProEnt)
    annotation (Line(points={{-20,-89},{-20,-60},{19,-60}}, color={0,0,127}));
  connect(senTemProEnt.port_b, senMasFraProEnt.port_a)
    annotation (Line(points={{-40,-100},{-30,-100}}, color={0,127,255}));
  connect(senMasFraProEnt.port_b, outCon.port_a)
    annotation (Line(points={{-10,-100},{70,-100}}, color={0,127,255}));
  connect(reaExp.y, senHea.hPro) annotation (Line(points={{-59,-50},{-10,-50},{
          -10,-52},{19,-52}},
                         color={0,0,127}));
  connect(vol.ports[1], senTemRegEnt.port_a)
    annotation (Line(points={{-36,80},{20,80}}, color={0,127,255}));
  connect(senTemRegEnt.port_b, senRegMasFlo.port_b)
    annotation (Line(points={{40,80},{100,80}},   color={0,127,255}));
  connect(vol.ports[2], resReg.port_a)
    annotation (Line(points={{-34,80},{-100,80}},   color={0,127,255}));
  connect(resReg.port_b, port_b2)
    annotation (Line(points={{-120,80},{-180,80}},   color={0,127,255}));
  connect(max1.y, gai2.u) annotation (Line(points={{98,40},{62,40}},  color={0,0,127}));
  connect(max1.u2, senHea.Q) annotation (Line(points={{122,34},{140,34},{140,-60},
          {41,-60}}, color={0,0,127}));
  connect(outCon.Q_flow, max1.u1) annotation (Line(points={{91,-92},{130,-92},{130,
          46},{122,46}}, color={0,0,127}));

annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),   graphics={
        Rectangle(
          extent={{-94,86},{92,76}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-86,92},{6,-90}},
          lineColor={28,108,200},
          fillPattern=FillPattern.CrossDiag,
          fillColor={255,255,255}),
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
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,140}})),
    Documentation(info="<html>
<p>
Partial model of a desiccant dehumidifier.
Specifically, this model considers the following system configuration.
</p>
<p align=\"left\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/Dehumidifiers/Desiccant/BaseClasses/dehumidifer_schematic.png\"
alt=\"Dehumidifer_Schematic.png\" border=\"1\"/>
</p>
<p>
To achieve full dehumidification functionality, the model should be expanded to include features such as 
bypass dampers or a variable speed drive for modulating dehumidification performance.
</p>
<p>Note:</p>
This model uses two components—<a href='modelica://Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SensibleHeat'>
Buildings.Fluid.Dehumidifiers.Desiccant.BaseClasses.SensibleHeat</a> 
and <a href='modelica://Buildings.Fluid.Interfaces.PrescribedOutlet'>Buildings.Fluid.Interfaces.PrescribedOutlet</a>—
to calculate the sensible heat exchange between the process air and the regeneration air, seperately. 
The one yielding the larger result is used in the final modeling process.
</html>", revisions="<html>
<ul>
<li>March 1, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialDesiccant;
