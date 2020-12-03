within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model SwitchBox
  "Model for mass flow rate redirection with three-port two-position directional valves"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Boolean have_hotWat = false
    "Set to true if the ETS supplies domestic hot water"
    annotation (Evaluate=true);
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mFreCoo_flow(
    final unit="kg/s")
    "Mass flow rate for free cooling"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
       iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHeaWat_flow(
    final unit="kg/s") "Mass flow rate for heating water production"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,2},{-100,42}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHotWat_flow(
    final unit="kg/s") if have_hotWat
    "Mass flow rate for hot water production" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-140,40},{-100,80}})));
  // COMPONENTS
  DHC.EnergyTransferStations.BaseClasses.Junction splSup(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal) "Flow splitter"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-40,40})));
  DHC.EnergyTransferStations.BaseClasses.Junction splRet(
    redeclare package Medium = Medium,
    m_flow_nominal={1,1,1}*m_flow_nominal) "Flow splitter"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={40,0})));
  SwitchBoxController con "Switch box controller"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));
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
  Modelica.Blocks.Sources.Constant zer(k=0) if not have_hotWat
    "Replacement variable"
    annotation (Placement(transformation(extent={{-46,70},{-66,90}})));
  Controls.OBC.CDL.Continuous.Add add2
    "Add flow rates for all heating applications"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,20})));
equation
  connect(port_bSup, splSup.port_2)
    annotation (Line(points={{-40,100},{-40,50}}, color={0,127,255}));
  connect(mFreCoo_flow, con.mFreCoo_flow) annotation (Line(points={{-120,-40},{-96,
          -40},{-96,-28},{-92,-28}},
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
    annotation (Line(points={{-68,-20},{-60,-20},{-60,0},{-52,0}},
                                               color={0,0,127}));
  connect(con.m_flow, valRet.y) annotation (Line(points={{-68,-20},{60,-20},{60,
          -40},{52,-40}},              color={0,0,127}));
  connect(mHotWat_flow, add2.u1)
    annotation (Line(points={{-120,80},{-74,80},{-74,32}}, color={0,0,127}));
  connect(mHeaWat_flow, add2.u2)
    annotation (Line(points={{-120,40},{-86,40},{-86,32}}, color={0,0,127}));
  connect(zer.y, add2.u1)
    annotation (Line(points={{-67,80},{-74,80},{-74,32}}, color={0,0,127}));
  connect(add2.y, con.mHeaAll_flow) annotation (Line(points={{-80,8},{-80,0},{-96,
          0},{-96,-12},{-92,-12}}, color={0,0,127}));
  annotation (
  defaultComponentName="swiFlo",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
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
end SwitchBox;
