within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model SwitchBoxPump "Model for mass flow rate redirection with pumps"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Networks.BaseClasses.Junction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,60})));
  Networks.BaseClasses.Junction splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,-40})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSup(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-50,90},{-30,110}}),
        iconTransformation(extent={{-50,90},{-30,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRet(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSup(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{-50,-110},{-30,
            -90}}), iconTransformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(redeclare package Medium =
        Medium) annotation (Placement(transformation(extent={{30,90},{50,110}}),
        iconTransformation(extent={{30,90},{50,110}})));
  Controls.ReverseFlowSwitchBoxPump con "Switch box controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Interfaces.RealInput mFreCoo_flow(
    final unit="kg/s")
    "Mass flow rate for free cooling"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
       iconTransformation(extent={{-124,-44},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput mSpaHea_flow(
    final unit="kg/s")
    "Mass flow rate for space heating"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-124,36},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Pump electricity consumption"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Networks.BaseClasses.Junction splSup3(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  Networks.BaseClasses.Junction splSup4(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,0})));
  Networks.BaseClasses.Pump_m_flow pum1(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=false)
    "Pump"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,0})));
  Networks.BaseClasses.Pump_m_flow pum2(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=false)
    "Pump"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={0,60})));
  Modelica.Blocks.Math.Add add "Adder for pump power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(port_bSup, splSup1.port_2)
    annotation (Line(points={{-40,100},{-40,70}}, color={0,127,255}));
  connect(mFreCoo_flow, con.mFreCoo_flow)
    annotation (Line(points={{-120,-40},{-96,-40},{-96,-8},{-92,-8}},
                                      color={0,0,127}));
  connect(mSpaHea_flow, con.mSpaHea_flow)
    annotation (Line(points={{-120,40},{-96,40},{-96,8},{-92,8}},
                                      color={0,0,127}));
  connect(splSup1.port_1, splSup3.port_2)
    annotation (Line(points={{-40,50},{-40,10}}, color={0,127,255}));
  connect(splSup4.port_2, splSup2.port_1)
    annotation (Line(points={{40,-10},{40,-30}}, color={0,127,255}));
  connect(splSup4.port_1, port_aRet)
    annotation (Line(points={{40,10},{40,100}}, color={0,127,255}));
  connect(splSup3.port_3, pum1.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(pum1.port_b, splSup4.port_3)
    annotation (Line(points={{10,0},{22,0},{22,6.66134e-16},{30,6.66134e-16}},
                                             color={0,127,255}));
  connect(splSup1.port_3, pum2.port_a)
    annotation (Line(points={{-30,60},{-10,60}},         color={0,127,255}));
  connect(pum2.port_b, splSup2.port_3)
    annotation (Line(points={{10,60},{20,60},{20,-40},{30,-40}},
                                                          color={0,127,255}));
  connect(con.m_flow, pum1.m_flow_in)
    annotation (Line(points={{-68,0},{-60,0},{-60,-40},{0,-40},{0,-12}},
                                                         color={0,0,127}));
  connect(con.m_flow, pum2.m_flow_in) annotation (Line(points={{-68,0},{-60,0},
          {-60,40},{0,40},{0,48},{-8.88178e-16,48}},      color={0,0,127}));
  connect(add.y, PPum)
    annotation (Line(points={{91,0},{120,0}},  color={0,0,127}));
  connect(pum2.P, add.u1)
    annotation (Line(points={{11,51},{60,51},{60,6},{68,6}}, color={0,0,127}));
  connect(pum1.P, add.u2) annotation (Line(points={{11,-9},{26,-9},{26,-20},{60,
          -20},{60,-6},{68,-6}}, color={0,0,127}));
  connect(splSup2.port_2, port_bRet)
    annotation (Line(points={{40,-50},{40,-100}}, color={0,127,255}));
  connect(splSup3.port_1, port_aSup)
    annotation (Line(points={{-40,-10},{-40,-100}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={0,0,127}, fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                           Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Model that is used to ensure that the substations obtain the supply from
the upstream connection of the district loop in the reservoir network models.
</p>
</html>", revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SwitchBoxPump;
