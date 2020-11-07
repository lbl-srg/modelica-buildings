within Buildings.Experimental.DHC.Networks.BaseClasses;
partial model PartialConnection1Pipe
  "Partial model for connecting an agent to a one-pipe distribution network"
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),choice(redeclare package Medium=Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable model Model_pipDis=Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  replaceable model Model_pipCon=Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversal);
  parameter Boolean show_heaFlo=false
    "Set to true to output the heat flow rate transferred to the connected load"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal
    "Nominal mass flow rate in the distribution line";
  parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate in the connection line";
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.SIunits.Time tau=10
    "Time constant at nominal flow for dynamic energy and momentum balance"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",enable=not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aDis(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution inlet port"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDis(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Distribution outlet port"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aCon(
    redeclare final package Medium=Medium,
    m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection return port"
    annotation (Placement(transformation(extent={{30,110},{50,130}}),iconTransformation(extent={{50,90},{70,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bCon(
    redeclare final package Medium=Medium,
    m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default))
    "Connection supply port"
    annotation (Placement(transformation(extent={{-50,110},{-30,130}}),iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Interfaces.RealOutput mCon_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="HeatFlowRate",
    final unit="W") if show_heaFlo
    "Heat flow rate transferred to the connected load (>=0 for heating)"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Interfaces.RealOutput mByp_flow(
    final quantity="MassFlowRate",
    final unit="kg/s")
    "Bypass mass flow rate"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),iconTransformation(extent={{100,30},{120,50}})));
  // COMPONENTS
  Fluid.FixedResistances.Junction junConSup(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final dp_nominal={0,0,0},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,-mCon_flow_nominal})
    "Junction with connection supply"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-50}})));
  Fluid.FixedResistances.Junction junConRet(
    redeclare final package Medium=Medium,
    final portFlowDirection_1=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=
      if allowFlowReversal then
        Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else
        Modelica.Fluid.Types.PortFlowDirection.Entering,
    final dp_nominal={0,0,0},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    final m_flow_nominal={mDis_flow_nominal,-mDis_flow_nominal,mCon_flow_nominal})
    "Junction with connection return"
    annotation (Placement(transformation(extent={{30,-30},{50,-50}})));
  Model_pipDis pipDis
    "Distribution pipe"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Model_pipCon pipCon
    "Connection pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={-40,10})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCon(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Connection supply mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={-40,60})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    "Bypass mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={0,-40})));
  Fluid.Sensors.TemperatureTwoPort senTConSup(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal) if show_heaFlo
    "Connection supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={-60,90})));
  Fluid.Sensors.TemperatureTwoPort senTConRet(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=mCon_flow_nominal) if show_heaFlo
    "Connection return temperature sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=-90,origin={20,90})));
  Buildings.Controls.OBC.CDL.Continuous.Add sub(
    final k1=-1) if show_heaFlo
    "Delta T"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro if show_heaFlo
    "Delta T times flow rate"
    annotation (Placement(transformation(extent={{46,30},{66,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=cp_default) if show_heaFlo
    "Times cp"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={80,80})));
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=Medium.specificHeatCapacityCp(
    Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Specific heat capacity of medium at default medium state";
equation
  // Connect statements involving conditionally removed components are
  // removed at translation time by Modelica specification.
  // Only obsolete statements corresponding to the default model structure need
  // to be programmatically removed.
  if not show_heaFlo then
    connect(port_bCon,senMasFloCon.port_b)
      annotation (Line(points={{-40,120},{-40,70}},color={0,127,255}));
    connect(port_aCon,junConRet.port_3)
      annotation (Line(points={{40,120},{40,-30}},color={0,127,255}));
  end if;
  connect(junConSup.port_3,pipCon.port_a)
    annotation (Line(points={{-40,-30},{-40,0}},color={0,127,255}));
  connect(pipDis.port_b,junConSup.port_1)
    annotation (Line(points={{-60,-40},{-50,-40}},color={0,127,255}));
  connect(senMasFloCon.m_flow,mCon_flow)
    annotation (Line(points={{-29,60},{120,60}},color={0,0,127}));
  connect(pipCon.port_b,senMasFloCon.port_a)
    annotation (Line(points={{-40,20},{-40,50}},color={0,127,255}));
  connect(port_aDis,pipDis.port_a)
    annotation (Line(points={{-100,-40},{-80,-40}},color={0,127,255}));
  connect(junConRet.port_2,port_bDis)
    annotation (Line(points={{50,-40},{100,-40}},color={0,127,255}));
  connect(junConSup.port_2,senMasFloByp.port_a)
    annotation (Line(points={{-30,-40},{-10,-40}},color={0,127,255}));
  connect(senMasFloByp.port_b,junConRet.port_1)
    annotation (Line(points={{10,-40},{30,-40}},color={0,127,255}));
  connect(senMasFloByp.m_flow,mByp_flow)
    annotation (Line(points={{0,-29},{0,20},{120,20}},color={0,0,127}));
  connect(senMasFloCon.port_b,senTConSup.port_a)
    annotation (Line(points={{-40,70},{-40,76},{-60,76},{-60,80}},color={0,127,255}));
  connect(senTConSup.port_b,port_bCon)
    annotation (Line(points={{-60,100},{-60,106},{-40,106},{-40,120}},color={0,127,255}));
  connect(port_aCon,senTConRet.port_a)
    annotation (Line(points={{40,120},{40,106},{20,106},{20,100}},color={0,127,255}));
  connect(senTConRet.port_b,junConRet.port_3)
    annotation (Line(points={{20,80},{20,76},{40,76},{40,-30}},color={0,127,255}));
  connect(senTConSup.T,sub.u2)
    annotation (Line(points={{-71,90},{-80,90},{-80,34},{-2,34}},color={0,0,127}));
  connect(senTConRet.T,sub.u1)
    annotation (Line(points={{9,90},{-10,90},{-10,46},{-2,46}},color={0,0,127}));
  connect(sub.y,pro.u2)
    annotation (Line(points={{22,40},{34,40},{34,34},{44,34}},color={0,0,127}));
  connect(senMasFloCon.m_flow,pro.u1)
    annotation (Line(points={{-29,60},{30,60},{30,46},{44,46}},color={0,0,127}));
  connect(pro.y,gai.u)
    annotation (Line(points={{68,40},{80,40},{80,68}},color={0,0,127}));
  connect(gai.y,Q_flow)
    annotation (Line(points={{80,92},{80,100},{120,100}},color={0,0,127}));
  annotation (
    defaultComponentName="con",
    Documentation(
      info="
<html>
<p>
Partial model to be used for connecting an agent (e.g. energy transfer station)
to a one-pipe distribution network.
</p>
<p>
Two instances of a replaceable partial model are used to represent the pipes:
</p>
<ul>
<li>
One representing the main distribution pipe immediately upstream the connection.
</li>
<li>
The other one representing both the supply and return lines of the connection.
When replacing that model with a pipe model computing the pressure drop,
one must double the length so that both the supply and return lines are
accounted for.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,2},{100,-2}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-2,-2},{2,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-152,-104},{148,-144}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-76,12},{-20,-12}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-0.5,45.5},
          rotation=90),
        Rectangle(
          extent={{58,-2},{62,100}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-25.5,7.5},{25.5,-7.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={59.5,45.5},
          rotation=90)}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,120}})));
end PartialConnection1Pipe;
