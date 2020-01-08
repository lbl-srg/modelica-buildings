within Buildings.Fluid.Chillers.Examples;
model AbsorptionIndirectHotWaterSwitchableRecords
  "Test model for absorption indirect hot water chiller"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
   "Medium model";

  Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterSwitchableRecords
                                              absIndHotWat(
    per(
      QEva_flow_nominal=-10000,
      P_nominal=150,
      PLRMax=1,
      PLRMin=0.15,
      mEva_flow_nominal=0.247,
      mCon_flow_nominal=1.1,
      mGen_flow_nominal=1,
      dpEva_nominal=0,
      dpCon_nominal=0,
      capFunEva={0.690571,0.065571,-0.00289,0},
      capFunCon={0.245507,0.023614,0.0000278,0.000013},
      capFunGen={0.3303,0.0006852,0.0002818},
      genHIR={0.18892,0.968044,1.119202,-0.5034},
      EIRP={1,0,0},
      genConT={0.712019,-0.00478,0.000864,-0.000013},
      genEvaT={0.995571,0.046821,-0.01099,0.000608}),
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    redeclare package Medium3 = Medium,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Absorption chiller"
    annotation (Placement(transformation(extent={{-12,0},{8,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T conPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=absIndHotWat.per.mCon_flow_nominal,
    use_T_in=true,
    nPorts=1) "Condenser water pump"
     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,84})));
  Buildings.Fluid.Sources.MassFlowSource_T evaPum(
    redeclare package Medium = Medium,
    m_flow=absIndHotWat.per.mEva_flow_nominal,
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
    startTime=0) "Condenser entering water temperature"
     annotation (Placement(transformation(extent={{-98,70},{-78,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TEvaEnt(
    height=2,
    duration(displayUnit="h") = 14400,
    offset=12 + 273.15,
    startTime=0)
    "Evaporator entering water temperature"
     annotation (Placement(transformation(extent={{92,-44},{72,-24}})));
  Buildings.Fluid.Sources.Boundary_pT heaVol(
    redeclare package Medium = Medium,
    nPorts=1) "Volume for heating load"
     annotation (Placement(transformation(extent={{60,38},{40,58}})));
  Buildings.Fluid.Sources.Boundary_pT cooVol(
    redeclare package Medium = Medium, nPorts=1)
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
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Sources.Boundary_pT genVol(redeclare package Medium = Medium, nPorts=1)
    "Volume for generator"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Sources.MassFlowSource_T genPum(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=absIndHotWat.per.mGen_flow_nominal,
    use_T_in=true,
    nPorts=1) "Generator water pump" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-50,10})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TGenEnt(
    height=5,
    duration(displayUnit="h") = 14400,
    offset=85 + 273.15,
    startTime=0) "Generator entering water temperature"
    annotation (Placement(transformation(extent={{-96,0},{-76,20}})));
equation
  connect(TConEnt.y,conPum. T_in)
    annotation (Line(points={{-76,80},{-62,80}}, color={0,0,127}));
  connect(TEvaEnt.y,evaPum. T_in)
    annotation (Line(points={{70,-34},{62,-34}},
                                color={0,0,127}));
  connect(absIndHotWat.TSet, TEvaSet.y) annotation (Line(points={{-12.9091,6},{-30,
          6},{-30,-30},{-38,-30}}, color={0,0,127}));
  connect(conPum.ports[1], absIndHotWat.conEnt) annotation (Line(points={{-40,84},
          {-20,84},{-20,18},{-10.1818,18}}, color={0,127,255}));
  connect(absIndHotWat.conLvg, heaVol.ports[1]) annotation (Line(points={{8,18},{
          26,18},{26,48},{40,48}},  color={0,127,255}));
  connect(onOff.y, absIndHotWat.on) annotation (Line(points={{-39,50},{-28,50},
          {-28,18},{-12.9091,18}},color={255,0,255}));
  connect(genPum.ports[1], absIndHotWat.genEnt) annotation (Line(points={{-40,10},
          {-20,10},{-20,9.9},{-10.2727,9.9}}, color={0,127,255}));
  connect(genVol.ports[1], absIndHotWat.genLvg) annotation (Line(points={{40,10},
          {26,10},{26,9.9},{8,9.9}},  color={0,127,255}));
  connect(genPum.T_in, TGenEnt.y) annotation (Line(points={{-62,6},{-68,6},{-68,
          10},{-74,10}}, color={0,0,127}));
  connect(evaPum.ports[1], absIndHotWat.evaEnt) annotation (Line(points={{40,-30},
          {24,-30},{24,1.9},{8,1.9}},  color={0,127,255}));
  connect(absIndHotWat.evaLvg, cooVol.ports[1]) annotation (Line(points={{
          -10.1818,2},{-20,2},{-20,-70},{-40,-70}},
                                           color={0,127,255}));
  annotation (
experiment(
      StopTime=14400,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/AbsorptionIndirectHotWaterSwitchableRecords.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example that simulates the absorption chiller
<a href=\"Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterSwitchableRecords\">
Buildings.Fluid.Chillers.AbsorptionIndirectHotWaterSwitchableRecords</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
January 7, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectHotWaterSwitchableRecords;
