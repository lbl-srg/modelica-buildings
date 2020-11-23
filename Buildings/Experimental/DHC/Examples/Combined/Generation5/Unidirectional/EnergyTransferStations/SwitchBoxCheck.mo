within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model SwitchBoxCheck "Model for mass flow rate redirection with check valves"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
    min=0, displayUnit="Pa") = 5000
    "Valve pressure drop at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance (except for the pump always modeled in steady state)"
    annotation(Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  // IO CONECTORS
  Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
    redeclare package Medium = Medium)
    "Supply line outlet port"
    annotation (Placement(transformation(
          extent={{-50,90},{-30,110}}), iconTransformation(extent={{-50,90},{-30,
            110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
    redeclare package Medium = Medium)
    "Return line outlet port"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSup(
    redeclare package Medium = Medium)
    "Supply line inlet port"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}}),
      iconTransformation(extent={{-50,-110},{-30,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare package Medium = Medium)
    "Return line inlet port"
    annotation (Placement(transformation(
          extent={{30,90},{50,110}}), iconTransformation(extent={{30,90},{50,110}})));
  // COMPONENTS
  Networks.BaseClasses.Junction splSup(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,40})));
  Networks.BaseClasses.Junction splRet(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,40})));
  Networks.BaseClasses.Junction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,-40})));
  Networks.BaseClasses.Junction splRet1(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,-40})));
  Fluid.FixedResistances.CheckValve cheValSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal)
    "Check valve"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,0})));
  Fluid.FixedResistances.CheckValve cheValRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dpValve_nominal)
    "Check valve"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,0})));
equation
  connect(port_bSup, splSup.port_2)
    annotation (Line(points={{-40,100},{-40,50}}, color={0,127,255}));
  connect(splRet.port_1, port_aRet)
    annotation (Line(points={{40,50},{40,100}}, color={0,127,255}));
  connect(splSup1.port_3, splRet.port_3) annotation (Line(points={{-30,-40},{0,-40},
          {0,40},{30,40}}, color={0,127,255}));
  connect(port_aSup, splSup1.port_1)
    annotation (Line(points={{-40,-100},{-40,-50}}, color={0,127,255}));
  connect(splSup.port_3, splRet1.port_3) annotation (Line(points={{-30,40},{-20,
          40},{-20,0},{20,0},{20,-40},{30,-40}}, color={0,127,255}));
  connect(splRet1.port_2, port_bRet)
    annotation (Line(points={{40,-50},{40,-100}}, color={0,127,255}));
  connect(splSup1.port_2, cheValSup.port_a)
    annotation (Line(points={{-40,-30},{-40,-10}}, color={0,127,255}));
  connect(cheValSup.port_b, splSup.port_1)
    annotation (Line(points={{-40,10},{-40,30}}, color={0,127,255}));
  connect(splRet.port_2, cheValRet.port_a)
    annotation (Line(points={{40,30},{40,10}}, color={0,127,255}));
  connect(cheValRet.port_b, splRet1.port_1)
    annotation (Line(points={{40,-10},{40,-30}}, color={0,127,255}));
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
end SwitchBoxCheck;
