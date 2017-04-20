within Buildings.Fluid.Interfaces.Examples;
model StaticTwoPortConservationEquation
  "Model that tests the static two port conservation equation"
extends Modelica.Icons.Example;
 package MediumW = Buildings.Media.Water "Medium model";
 package MediumA = Buildings.Media.Air "Medium model";

  Modelica.Blocks.Sources.Constant mWat_flow(k=0)
    "Water mass flow rate added to the control volume"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.TimeTable QSen_flow(startTime=0, table=[
                                0,-100;
                                900,-100;
                                900,0;
                                1800,0;
                                1800,100])
    "Sensible heat flow rate added to the control volume"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  SubModel modWatRev(
    redeclare package Medium = MediumW,
    allowFlowReversal=true,
    use_mWat_flow = false) "Submodel for energy and mass balance" annotation (
      Placement(transformation(extent={{-10,40},{10,60}})));
  SubModel modWatNoRev(
    redeclare package Medium = MediumW,
    allowFlowReversal=false,
    use_mWat_flow = false) "Submodel for energy and mass balance" annotation (
     Placement(transformation(extent={{-10,10},{10,30}})));
  SubModel modAirRev(
    redeclare package Medium = MediumA,
    allowFlowReversal=true,
    use_mWat_flow = true) "Submodel for energy and mass balance"     annotation (
      Placement(transformation(extent={{-10,-40},{10,-20}})));
  SubModel modAirNoRev(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    use_mWat_flow = true) "Submodel for energy and mass balance"      annotation (
     Placement(transformation(extent={{-10,-70},{10,-50}})));
equation

  connect(QSen_flow.y, modWatRev.Q_flow) annotation (Line(points={{-59,70},{-36,
          70},{-36,58},{-11,58}}, color={0,0,127}));
  connect(mWat_flow.y, modWatRev.mWat_flow) annotation (Line(points={{-59,30},{-40,
          30},{-40,54},{-10.8,54}}, color={0,0,127}));
protected
  model SubModel
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium model";
    Sources.MassFlowSource_T bou(
      nPorts=1,
      redeclare package Medium = Medium,
      m_flow=0.01) "Boundary condition for mass flow rate"
      annotation (Placement(transformation(extent={{-78,-10},{-58,10}})));
    Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation conEqn(
      redeclare package Medium = Medium,
      m_flow_nominal=0.01,
      show_T=true,
      allowFlowReversal=allowFlowReversal,
      use_mWat_flow=use_mWat_flow,
      prescribedHeatFlowRate=true) "Steady-state conservation equation"
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    Buildings.Fluid.Sources.Boundary_pT sin(
      use_p_in=false,
      redeclare package Medium = Medium,
      nPorts=1,
      p=101325,
      T=283.15) "Sink"
      annotation (Placement(transformation(extent={{82,-8},{62,12}})));

    Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W") annotation (Placement(
          transformation(extent={{-120,70},{-100,90}})));
    Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s") annotation (
        Placement(transformation(extent={{-118,30},{-98,50}})));
    parameter Boolean use_mWat_flow
      "Set to true to enable exchange of moisture";
    parameter Boolean allowFlowReversal=true
      "= false to simplify equations, assuming, but not enforcing, no flow reversal";
  equation
    connect(conEqn.port_b, sin.ports[1])
      annotation (Line(points={{12,0},{62,0},{62,2}}, color={0,127,255}));
    connect(conEqn.port_a, bou.ports[1]) annotation (Line(
        points={{-8,0},{-58,0}},
        color={0,127,255}));
    connect(Q_flow, conEqn.Q_flow) annotation (Line(points={{-110,80},{-110,80},
            {-20,80},{-10,80},{-10,8}}, color={0,0,127}));
    connect(mWat_flow, conEqn.mWat_flow) annotation (Line(points={{-108,40},{-108,
            40},{-68,40},{-40,40},{-40,4},{-10,4}}, color={0,0,127}));
  end SubModel;
equation
  connect(QSen_flow.y, modWatNoRev.Q_flow) annotation (Line(points={{-59,70},{-36,
          70},{-36,28},{-11,28}}, color={0,0,127}));
  connect(mWat_flow.y, modWatNoRev.mWat_flow) annotation (Line(points={{-59,30},
          {-40,30},{-40,24},{-10.8,24}}, color={0,0,127}));
  connect(QSen_flow.y, modAirRev.Q_flow) annotation (Line(points={{-59,70},{-36,
          70},{-36,-22},{-11,-22}}, color={0,0,127}));
  connect(mWat_flow.y, modAirRev.mWat_flow) annotation (Line(points={{-59,30},{-40,
          30},{-40,-26},{-10.8,-26}}, color={0,0,127}));
  connect(QSen_flow.y, modAirNoRev.Q_flow) annotation (Line(points={{-59,70},{-36,
          70},{-36,-52},{-11,-52}}, color={0,0,127}));
  connect(mWat_flow.y, modAirNoRev.mWat_flow) annotation (Line(points={{-59,30},
          {-40,30},{-40,-56},{-10.8,-56}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/StaticTwoPortConservationEquation.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Model that tests the conservation equations that are used
for the heat and mass balance.
The instances have either water or air, and either allow or prohibit
flow reversal.
This example tests the implementation of the steady-state balance.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016 by Michael Wetter:<br/>
Updated model to use the new parameter <code>use_mWat_flow</code>
rather than <code>sensibleOnly</code>.
</li>
<li>
July 17, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StaticTwoPortConservationEquation;
