within Buildings.Fluid.Chillers.Examples;
model AbsorptionIndirectSteam
  "Test model for absorption indirect steam chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
   "Medium model";

  parameter Buildings.Fluid.Chillers.Data.AbsorptionIndirectSteam.Generic per(
   QEva_flow_nominal=-10000,
   P_nominal=150,
   PLRMax=1,
   PLRMin=0.15,
   mEva_flow_nominal=0.247,
   mCon_flow_nominal=1.1,
   dpEva_nominal=0,
   dpCon_nominal=0,
   capFunEva={0.690571,0.065571,-0.00289,0},
   capFunCon={0.245507,0.023614,0.0000278,0.000013},
   genHIR={0.18892,0.968044,1.119202,-0.5034},
   EIRP={1,0,0},
   genConT={0.712019,-0.00478,0.000864,-0.000013},
   genEvaT={0.995571,0.046821,-0.01099,0.000608})
    "Chiller performance data"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Fluid.Chillers.AbsorptionIndirectSteam absIndSte(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    show_T=true,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
  "Absorption chiller"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T conPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=per.mCon_flow_nominal,
    use_T_in=true,
    nPorts=1)
   "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,70})));
  Buildings.Fluid.Sources.MassFlowSource_T evaPum(
    redeclare package Medium = Medium,
    m_flow=per.mEva_flow_nominal,
    use_T_in=true,
    nPorts=1)
   "Evaporator water pump"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,-30})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TConEnt(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=20 + 273.15,
    startTime=0)
   "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-96,56},{-76,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{92,-44},{72,-24}})));
  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium,
    nPorts=1)
   "Volume for heating load"
     annotation (Placement(transformation(extent={{60,6},{40,26}})));
  Buildings.Fluid.Sources.Boundary_pT cooVol(
    redeclare package Medium = Medium,
    nPorts=1)
   "Volume for cooling load"
     annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEvaSet(
    height=4,
    duration(displayUnit="h") = 14400,
    offset=6 + 273.15,
    startTime=0)
    "Evaporator setpoint water temperature"
     annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.BooleanPulse onOff(period=3600/2) "Control input"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
equation
  connect(TConEnt.y,conPum. T_in)
    annotation (Line(points={{-74,66},{-62,66}}, color={0,0,127}));
  connect(TEvaEnt.y,evaPum. T_in)
    annotation (Line(points={{70,-34},{62,-34}},
                                color={0,0,127}));
  connect(absIndSte.port_a2, evaPum.ports[1])
    annotation (Line(points={{10,4},{20,4},{20,-30},{40,-30}},
                                 color={0,127,255}));
  connect(absIndSte.TSet, TEvaSet.y) annotation (Line(points={{-11,8},{-30,8},{
          -30,-30},{-38,-30}},
                           color={0,0,127}));
  connect(conPum.ports[1], absIndSte.port_a1)
    annotation (Line(points={{-40,70},{-20,70},{-20,16},{-10,16}},
                                     color={0,127,255}));
  connect(absIndSte.port_b1, heaVol.ports[1])
    annotation (Line(points={{10,16},{40,16}}, color={0,127,255}));
  connect(cooVol.ports[1], absIndSte.port_b2) annotation (Line(points={{-40,-70},
          {-20,-70},{-20,4},{-10,4}}, color={0,127,255}));
  connect(onOff.y, absIndSte.on)
    annotation (Line(points={{-39,12},{-11,12}}, color={255,0,255}));
  annotation (
experiment(Tolerance=1e-6, StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/AbsorptionIndirectSteam.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates the absorption chiller
<a href=\"modelica://Buildings.Fluid.Chillers.AbsorptionIndirectSteam\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteam</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
July 3, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteam;
