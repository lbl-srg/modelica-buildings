within Buildings.Experimental.DistrictHeatingCooling.Validation;
model IdealSmallSystem "Validation model for a small system"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 0.5E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+8
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+14
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";
  Plants.Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(
    redeclare package Medium = Medium,
    nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-110,-70})));
  SubStations.Heating hea1(redeclare package Medium = Medium, Q_flow_nominal=200E3)
    "Heating load"
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));
  SubStations.Heating hea2(redeclare package Medium = Medium, Q_flow_nominal=100E3)
    "Heating load"
    annotation (Placement(transformation(extent={{98,-10},{118,10}})));
  SubStations.Cooling coo1(redeclare package Medium = Medium, Q_flow_nominal=-150E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  SubStations.Cooling coo2(redeclare package Medium = Medium, Q_flow_nominal=-100E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-88,50},{-68,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-70,-50},{-90,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea1(table=[0,200E3; 6,200E3; 6,50E3;
        18,50E3; 18,75E3; 24,75E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea2(table=[0,100E3; 6,100E3; 6,50E3;
        18,50E3; 18,75E3; 24,75E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QCoo1(table=[0,-100E3; 6,-80E3; 6,
        -50E3; 12,-20E3; 18,-150E3; 24,-100E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QCoo2(table=[0,-10E3; 9,-100E3; 9,
        -50E3; 18,-50E3; 18,-150E3; 24,-100E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{220,80},{240,100}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.FixedResistances.Junction spl1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Fluid.FixedResistances.Junction spl2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{210,50},{230,70}})));
  Buildings.Fluid.FixedResistances.Junction spl3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{20,-30},{40,-50}})));
  Buildings.Fluid.FixedResistances.Junction spl4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{120,-30},{140,-50}})));
  Buildings.Fluid.FixedResistances.Junction spl5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false)
    annotation (Placement(transformation(extent={{150,-30},{170,-50}})));
protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));

  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-160,110},{-140,130}})));
equation

  connect(pla.port_b, pip.port_a) annotation (Line(points={{-100,60},{-92,60},{-88,
          60}},          color={0,127,255}));
  connect(pla.port_a, pip1.port_b) annotation (Line(points={{-120,60},{-128,60},
          {-128,-40},{-90,-40}},
                           color={0,127,255}));
  connect(pSet.ports[1], pip1.port_b) annotation (Line(points={{-110,-60},{-110,
          -40},{-90,-40}},
                      color={0,127,255}));
  connect(QHea1.y[1], hea1.Q_flow)
    annotation (Line(points={{-19,90},{-12,90},{-12,6},{0,6}},
                                                            color={0,0,127}));
  connect(QHea2.y[1], hea2.Q_flow)
    annotation (Line(points={{81,90},{88,90},{88,6},{96,6}}, color={0,0,127}));
  connect(QCoo1.y[1], coo1.Q_flow) annotation (Line(points={{161,90},{170,90},{170,
          6},{178,6}},     color={0,0,127}));
  connect(QCoo2.y[1], coo2.Q_flow) annotation (Line(points={{241,90},{241,90},{250,
          90},{250,6},{258,6}},     color={0,0,127}));
  connect(pip.port_b, spl.port_1)
    annotation (Line(points={{-68,60},{-68,60},{-40,60}}, color={0,127,255}));
  connect(spl.port_2, spl1.port_1)
    annotation (Line(points={{-20,60},{22,60},{50,60}},
                                               color={0,127,255}));
  connect(spl1.port_2, spl2.port_1)
    annotation (Line(points={{70,60},{210,60}},         color={0,127,255}));
  connect(spl.port_3, hea1.port_a) annotation (Line(points={{-30,50},{-30,50},{-30,
          0},{-28,0},{2,0}},
                         color={0,127,255}));
  connect(spl1.port_3, hea2.port_a) annotation (Line(points={{60,50},{60,50},{60,
          10},{60,0},{98,0}}, color={0,127,255}));
  connect(spl2.port_2, coo2.port_b) annotation (Line(points={{230,60},{230,60},{
          290,60},{290,0},{280,0}}, color={0,127,255}));
  connect(coo1.port_b, spl2.port_3)
    annotation (Line(points={{200,0},{220,0},{220,50}}, color={0,127,255}));
  connect(pip1.port_a, spl3.port_1) annotation (Line(points={{-70,-40},{-26,-40},
          {20,-40}}, color={0,127,255}));
  connect(spl3.port_3, hea1.port_b) annotation (Line(points={{30,-30},{30,-30},{
          30,0},{22,0}}, color={0,127,255}));
  connect(hea2.port_b, spl4.port_3)
    annotation (Line(points={{118,0},{130,0},{130,-30}}, color={0,127,255}));
  connect(spl4.port_1, spl3.port_2) annotation (Line(points={{120,-40},{120,-40},
          {40,-40}}, color={0,127,255}));
  connect(spl4.port_2, spl5.port_1)
    annotation (Line(points={{140,-40},{150,-40}}, color={0,127,255}));
  connect(spl5.port_3, coo1.port_a) annotation (Line(points={{160,-30},{160,-30},
          {160,0},{180,0}}, color={0,127,255}));
  connect(spl5.port_2, coo2.port_a) annotation (Line(points={{170,-40},{208,-40},
          {240,-40},{240,0},{260,0}}, color={0,127,255}));
  connect(TSetH.y, pla.TSetHea) annotation (Line(points={{-139,120},{-130,120},
          {-130,68},{-122,68}}, color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-139,90},{-134,90},{
          -134,64},{-122,64}}, color={0,0,127}));
  annotation(experiment(Tolerance=1E-06, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Validation/IdealSmallSystem.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal bi-directional heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 2, 2016, by Michael Wetter:<br/>
Removed top-level parameter <code>dp_nominal</code>.
</li>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{
            300,140}})));
end IdealSmallSystem;
