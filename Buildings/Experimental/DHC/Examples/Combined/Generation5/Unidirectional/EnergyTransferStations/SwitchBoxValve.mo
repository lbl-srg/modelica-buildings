within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model SwitchBoxValve
  "Model for mass flow rate redirection with three-port two-position directional valves"
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
        origin={40,0})));
  Controls.ReverseFlowSwitchBoxValve con "Switch box controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valSup(
    redeclare package Medium = Medium,
    dpValve_nominal=dpValve_nominal,
    use_inputFilter=false,
    m_flow_nominal=m_flow_nominal,
    linearized={true,true},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Directional valve"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-40,0},
     rotation=-90)));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear valRet(
    redeclare package Medium = Medium,
    dpValve_nominal=dpValve_nominal,
    use_inputFilter=false,
    m_flow_nominal=m_flow_nominal,
    linearized={true,true},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Directional valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},origin={40,-40},
      rotation=-90)));
equation
  connect(port_bSup, splSup.port_2)
    annotation (Line(points={{-40,100},{-40,50}}, color={0,127,255}));
  connect(mFreCoo_flow, con.mFreCoo_flow)
    annotation (Line(points={{-120,-40},{-96,-40},{-96,-8},{-92,-8}},
                                      color={0,0,127}));
  connect(mSpaHea_flow, con.mSpaHea_flow)
    annotation (Line(points={{-120,40},{-96,40},{-96,8},{-92,8}},
                                      color={0,0,127}));
  connect(splRet.port_1, port_aRet)
    annotation (Line(points={{40,10},{40,100}}, color={0,127,255}));
  connect(valSup.port_1, splSup.port_1)
    annotation (Line(points={{-40,10},{-40,30}}, color={0,127,255}));
  connect(valSup.port_3, splRet.port_3)
    annotation (Line(points={{-30,0},{30,0}}, color={0,127,255}));
  connect(splRet.port_2, valRet.port_1)
    annotation (Line(points={{40,-10},{40,-30}}, color={0,127,255}));
  connect(splSup.port_3, valRet.port_3) annotation (Line(points={{-30,40},{0,40},
          {0,-40},{30,-40}}, color={0,127,255}));
  connect(valRet.port_2, port_bRet)
    annotation (Line(points={{40,-50},{40,-100}}, color={0,127,255}));
  connect(valSup.port_2, port_aSup) annotation (Line(points={{-40,-10},{-40,-100},{
          -40,-100}}, color={0,127,255}));
  connect(con.m_flow, valSup.y)
    annotation (Line(points={{-68,0},{-52,0}}, color={0,0,127}));
  connect(con.m_flow, valRet.y) annotation (Line(points={{-68,0},{-60,0},{-60,-20},
          {60,-20},{60,-40},{52,-40}}, color={0,0,127}));
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
end SwitchBoxValve;
