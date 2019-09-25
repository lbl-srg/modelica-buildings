within Buildings.Fluid.HeatPumps.Examples;
model EquationFitReversible_CoolingClosedLoop
  "Test model for a closed loop of a reverse heat pump based on performance curves"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.EquationFitReversible.Trane_Axiom_EXW240 per
   "Reverse heat pump performance data"
   annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
   "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
   "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start=281.4,
    per=per,
    scaling_factor=1)
   "Water to Water heat pump"
   annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
   annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    nPorts=1,
    use_T_in=true)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={50,-50})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse uMod(
    amplitude=1,
    width=0.5,
    period=200,
    offset=-1,
    startTime=0)
   "heat pump operational mode input signal"
   annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse pulse(
    amplitude=1,
    width=0.7,
    period(displayUnit="s") = 200,
    offset=0)
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Math.Gain Q_flow(k=4200)
    "Heat input to volume"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Blocks.Math.Gain m_flow(k=mLoa_flow_nominal)
    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mLoa_flow_nominal,
    addPowerToMedium=false)                                   "Pump"
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=285.15,
    m_flow_nominal=mLoa_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=0.1*3600*mLoa_flow_nominal/1000,
    nPorts=2)
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,8})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TSouEnt(
    amplitude=3,
    width=0.7,
    period=200,
    offset=25 + 273.15,
    startTime=0)
    "Source side entering water temperature"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TLoaSet(
    amplitude=1,
    width=0.7,
    period=200,
    offset=6 + 273.15,
    startTime=0)
    "Set point chilled water temperature"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Sources.Boundary_pT                 pre(redeclare package Medium = Medium,
      nPorts=1)
              "Pressure source"
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-30})));
equation
  connect(souPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{40,-50},{20,-50},{20,-6},{16,-6}},
                                             color={0,127,255}));
  connect(uMod.y, reaToInt.u)
   annotation (Line(points={{-68,0},{-62,0}},color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
   annotation (Line(points={{-39,0},{-5,0}},color={255,127,0}));
  connect(heaPum.port_b2, souVol.ports[1])
   annotation (Line(points={{-4,-6},{-16,
          -6},{-16,-70},{-20,-70}},color={0,127,255}));
  connect(pulse.y,m_flow. u)
   annotation (Line(points={{-68,80},{-42,80}},          color={0,0,127}));
  connect(m_flow.y,Q_flow. u)
   annotation (Line(points={{-19,80},{18,80}}, color={0,0,127}));
  connect(heaFlo.port, vol.heatPort)
   annotation (Line(points={{80,80},{80,18},{70,18}},
                                 color={191,0,0}));
  connect(pum.port_a, vol.ports[1])
   annotation (Line(points={{20,50},{58,50},{58,10},{60,10}},
                        color={0,127,255}));
  connect(vol.ports[2], heaPum.port_b1)
   annotation (Line(points={{60,6},{16,6}}, color={0,127,255}));
  connect(pum.port_b, heaPum.port_a1)
   annotation (Line(points={{0,50},{-20,50},{-20,6},{-4,6}},
                           color={0,127,255}));
  connect(m_flow.y, pum.m_flow_in)
   annotation (Line(points={{-19,80},{10,80},{10,62}},
                                                     color={0,0,127}));
  connect(Q_flow.y, heaFlo.Q_flow)
   annotation (Line(points={{41,80},{60,80}}, color={0,0,127}));
  connect(souPum.T_in, TSouEnt.y)
   annotation (Line(points={{62,-54},{68,-54},{68,-80},{42,-80}},
                          color={0,0,127}));
  connect(TLoaSet.y, heaPum.TSet)
   annotation (Line(points={{-68,40},{-26,40},{-26,9},{-5.4,9}},
                        color={0,0,127}));
  connect(heaPum.port_a1, pre.ports[1])
   annotation (Line(points={{-4,6},{-30,6},{-30,-20}}, color={0,127,255}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{120,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
              Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
             __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/EquationFitReversible_CoolingClosedLoop.mos"
        "Simulate and plot"),
         experiment(Tolerance=1e-6, StopTime=14400),
Documentation(info="<html>
<p>
Example that simulates the performance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a> based on the equation fit method.
The heat pump takes as an input the set point for the chilled leaving
water temperature and an integer input equals to -1 which corresponds to the cooling operational mode.
</p>
<p>
The heat pump is connected to a control volume to which heat is added and the pump moves the water
to the heatpump where it is cooled to meet the corresponding set point water temperature.
</p>

</html>", revisions="<html>
<ul>
<li>
September 23, 2019, by Hagar Elarga:<br/>
First implementation.
 </li>
 </ul>
 </html>"));
end EquationFitReversible_CoolingClosedLoop;
