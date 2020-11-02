within Buildings.Obsolete.DistrictHeatingCooling.Examples;
model IdealSystem3Clusters
  "Validation model for a small system with three clusters of buildings"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 3*2E6
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
  Plants.Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-260,50},{-240,70}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(
    redeclare package Medium = Medium,
    nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-280,-70})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea1(redeclare package Medium = Medium, Q_flow_nominal=200E3)
    "Heating load"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea2(redeclare package Medium = Medium, Q_flow_nominal=
        200E3) "Heating load"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Cooling coo1(redeclare package Medium = Medium, Q_flow_nominal=-250E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Cooling coo2(redeclare package Medium = Medium, Q_flow_nominal=-100E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-228,50},{-208,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-210,-50},{-230,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea1(table=[0,200E3; 6,200E3; 6,50E3;
        18,50E3; 18,75E3; 24,75E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea2(table=[0,200E3; 6,200E3; 6,
        50E3; 18,50E3; 18,0E3; 24,0E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo1(table=[0,-10E3; 6,-10E3; 6,
        -10E3; 12,-20E3; 18,-250E3; 24,-250E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo2(table=[0,-10E3; 9,-100E3; 9,
        -50E3; 18,-150E3; 18,-150E3; 24,-150E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea3(redeclare package Medium = Medium, Q_flow_nominal=200E3)
    "Heating load"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea4(redeclare package Medium = Medium, Q_flow_nominal=100E3)
    "Heating load"
    annotation (Placement(transformation(extent={{220,-10},{240,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Cooling coo3(redeclare package Medium = Medium, Q_flow_nominal=-200E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));
  Obsolete.DistrictHeatingCooling.SubStations.Cooling coo4(redeclare package Medium = Medium, Q_flow_nominal=-100E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{340,-10},{360,10}})));
  Buildings.Fluid.FixedResistances.Pipe pip2(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip3(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea3(table=[0,200E3; 6,200E3; 6,50E3;
        18,50E3; 18,75E3; 24,75E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea4(table=[0,100E3; 6,100E3; 6,50E3;
        18,50E3; 18,75E3; 24,75E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{180,80},{200,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo3(table=[0,-100E3; 6,-80E3; 6,
        -50E3; 12,-100E3; 18,-200E3; 24,-200E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{240,80},{260,100}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo4(table=[0,-10E3; 9,-10E3; 9,
        -50E3; 18,-50E3; 18,-150E3; 24,-150E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{300,80},{320,100}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea5(redeclare package Medium = Medium, Q_flow_nominal=100E3)
    "Heating load"
    annotation (Placement(transformation(extent={{400,-10},{420,10}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea5(table=[0,100E3; 6,100E3; 6,
        50E3; 18,50E3; 18,0E3; 24,0E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{360,80},{380,100}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea6(redeclare package Medium = Medium, Q_flow_nominal=200E3)
    "Heating load"
    annotation (Placement(transformation(extent={{160,-210},{180,-190}})));
  Obsolete.DistrictHeatingCooling.SubStations.Heating hea7(redeclare package Medium = Medium, Q_flow_nominal=
        300E3) "Heating load"
    annotation (Placement(transformation(extent={{220,-210},{240,-190}})));
  Obsolete.DistrictHeatingCooling.SubStations.Cooling coo5(redeclare package Medium = Medium, Q_flow_nominal=-150E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{280,-210},{300,-190}})));
  Buildings.Fluid.FixedResistances.Pipe pip4(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{80,-150},{100,-130}})));
  Buildings.Fluid.FixedResistances.Pipe pip5(
    redeclare package Medium = Medium,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal/3)
    annotation (Placement(transformation(extent={{100,-250},{80,-230}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea6(table=[0,0E3; 6,0; 6,200E3;
        18,200E3; 18,20E3; 24,25E3], timeScale=3600, extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  Modelica.Blocks.Sources.CombiTimeTable QHea7(table=[0,0E3; 6,0E3; 6,
        100E3; 18,100E3; 18,200E3; 24,200E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Heating demand"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Modelica.Blocks.Sources.CombiTimeTable QCoo5(table=[0,-50E3; 6,-50E3; 6,
        -50E3; 12,-20E3; 18,-150E3; 24,-150E3], timeScale=3600, extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{240,-120},{260,-100}})));
protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-320,70},{-300,90}})));
protected
  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-320,100},{-300,120}})));
equation

  connect(pla.port_b, pip.port_a) annotation (Line(points={{-240,60},{-232,60},{
          -228,60}},     color={0,127,255}));
  connect(pip.port_b, hea1.port_a) annotation (Line(points={{-208,60},{-60,60},{
          -60,30},{-180,30},{-180,0},{-160,0}},
                               color={0,127,255}));
  connect(pip.port_b, hea2.port_a) annotation (Line(points={{-208,60},{-60,60},{
          -60,30},{-120,30},{-120,0},{-100,0}},
                      color={0,127,255}));
  connect(pip.port_b, coo1.port_b) annotation (Line(points={{-208,60},{-60,60},{
          -60,30},{-12,30},{-12,0},{-20,0}},
                                color={0,127,255}));
  connect(pip.port_b, coo2.port_b) annotation (Line(points={{-208,60},{-208,60},
          {-60,60},{-60,30},{44,30},{44,0},{40,0}},
                                color={0,127,255}));
  connect(pla.port_a, pip1.port_b) annotation (Line(points={{-260,60},{-280,60},
          {-280,-40},{-230,-40}},
                           color={0,127,255}));
  connect(pip1.port_a, hea1.port_b) annotation (Line(points={{-210,-40},{-210,-40},
          {-60,-40},{-60,-20},{-128,-20},{-128,0},{-140,0}},
                                   color={0,127,255}));
  connect(pip1.port_a, hea2.port_b) annotation (Line(points={{-210,-40},{-210,-40},
          {-60,-40},{-60,-20},{-70,-20},{-70,0},{-80,0}},
                                      color={0,127,255}));
  connect(pip1.port_a, coo1.port_a) annotation (Line(points={{-210,-40},{-60,-40},
          {-60,-20},{-50,-20},{-50,0},{-40,0}},
                                      color={0,127,255}));
  connect(pip1.port_a, coo2.port_a) annotation (Line(points={{-210,-40},{-210,-40},
          {-60,-40},{-60,-20},{6,-20},{6,0},{20,0}},
                                      color={0,127,255}));
  connect(QHea1.y[1], hea1.Q_flow)
    annotation (Line(points={{-179,90},{-172,90},{-172,6},{-162,6}},
                                                          color={0,0,127}));
  connect(QHea2.y[1], hea2.Q_flow)
    annotation (Line(points={{-119,90},{-110,90},{-110,6},{-102,6}},
                                                             color={0,0,127}));
  connect(QCoo1.y[1], coo1.Q_flow) annotation (Line(points={{-59,90},{-50,90},{-50,
          6},{-42,6}}, color={0,0,127}));
  connect(QCoo2.y[1], coo2.Q_flow) annotation (Line(points={{1,90},{10,90},{10,6},
          {18,6}},     color={0,0,127}));
  connect(pSet.ports[1], pip1.port_b) annotation (Line(points={{-280,-60},{-280,
          -40},{-230,-40}},
                      color={0,127,255}));
  connect(pip2.port_b, hea3.port_a) annotation (Line(points={{100,60},{260,60},{
          260,30},{140,30},{140,0},{160,0}}, color={0,127,255}));
  connect(pip2.port_b, hea4.port_a) annotation (Line(points={{100,60},{260,60},{
          260,30},{200,30},{200,0},{220,0}}, color={0,127,255}));
  connect(pip2.port_b, coo3.port_b) annotation (Line(points={{100,60},{260,60},{
          260,30},{308,30},{308,0},{300,0}}, color={0,127,255}));
  connect(pip2.port_b, coo4.port_b) annotation (Line(points={{100,60},{100,60},{
          260,60},{260,30},{364,30},{364,0},{360,0}}, color={0,127,255}));
  connect(pip3.port_a,hea3. port_b) annotation (Line(points={{100,-40},{100,-40},
          {260,-40},{260,-20},{192,-20},{192,0},{180,0}},
                                   color={0,127,255}));
  connect(pip3.port_a,hea4. port_b) annotation (Line(points={{100,-40},{100,-40},
          {260,-40},{260,-20},{250,-20},{250,0},{240,0}},
                                      color={0,127,255}));
  connect(pip3.port_a,coo3. port_a) annotation (Line(points={{100,-40},{260,-40},
          {260,-20},{270,-20},{270,0},{280,0}},
                                      color={0,127,255}));
  connect(pip3.port_a,coo4. port_a) annotation (Line(points={{100,-40},{100,-40},
          {260,-40},{260,-20},{326,-20},{326,0},{340,0}},
                                      color={0,127,255}));
  connect(QHea3.y[1],hea3.Q_flow)
    annotation (Line(points={{141,90},{148,90},{148,6},{158,6}},
                                                          color={0,0,127}));
  connect(QHea4.y[1],hea4.Q_flow)
    annotation (Line(points={{201,90},{210,90},{210,6},{218,6}},
                                                             color={0,0,127}));
  connect(QCoo3.y[1],coo3.Q_flow) annotation (Line(points={{261,90},{270,90},{270,
          6},{278,6}}, color={0,0,127}));
  connect(QCoo4.y[1],coo4.Q_flow) annotation (Line(points={{321,90},{330,90},{330,
          6},{338,6}}, color={0,0,127}));
  connect(pip2.port_a, pip.port_b)
    annotation (Line(points={{80,60},{-208,60}}, color={0,127,255}));
  connect(pip3.port_b, pip1.port_a) annotation (Line(points={{80,-40},{80,-40},{
          -210,-40}}, color={0,127,255}));
  connect(pip3.port_a,hea5. port_b) annotation (Line(points={{100,-40},{100,-40},
          {260,-40},{260,-20},{430,-20},{430,0},{420,0}},
                                      color={0,127,255}));
  connect(pip2.port_b, hea5.port_a) annotation (Line(points={{100,60},{260,60},{
          260,30},{380,30},{380,0},{400,0}}, color={0,127,255}));
  connect(QHea5.y[1],hea5.Q_flow)
    annotation (Line(points={{381,90},{390,90},{390,6},{398,6}},
                                                             color={0,0,127}));
  connect(pip4.port_b, hea6.port_a) annotation (Line(points={{100,-140},{260,-140},
          {260,-170},{140,-170},{140,-200},{160,-200}}, color={0,127,255}));
  connect(pip4.port_b, hea7.port_a) annotation (Line(points={{100,-140},{260,
          -140},{260,-170},{200,-170},{200,-200},{220,-200}},
                                                        color={0,127,255}));
  connect(pip4.port_b, coo5.port_b) annotation (Line(points={{100,-140},{260,-140},
          {260,-170},{308,-170},{308,-200},{300,-200}}, color={0,127,255}));
  connect(pip5.port_a,hea6. port_b) annotation (Line(points={{100,-240},{100,-240},
          {260,-240},{260,-220},{192,-220},{192,-200},{180,-200}},
                                   color={0,127,255}));
  connect(pip5.port_a,hea7. port_b) annotation (Line(points={{100,-240},{100,
          -240},{260,-240},{260,-220},{250,-220},{250,-200},{240,-200}},
                                      color={0,127,255}));
  connect(pip5.port_a,coo5. port_a) annotation (Line(points={{100,-240},{260,-240},
          {260,-220},{270,-220},{270,-200},{280,-200}},
                                      color={0,127,255}));
  connect(QHea6.y[1],hea6.Q_flow)
    annotation (Line(points={{141,-110},{148,-110},{148,-194},{158,-194}},
                                                          color={0,0,127}));
  connect(QHea7.y[1],hea7.Q_flow)
    annotation (Line(points={{201,-110},{210,-110},{210,-194},{218,-194}},
                                                             color={0,0,127}));
  connect(QCoo5.y[1],coo5.Q_flow) annotation (Line(points={{261,-110},{270,-110},
          {270,-194},{278,-194}},
                       color={0,0,127}));
  connect(pip4.port_a, pip.port_b) annotation (Line(points={{80,-140},{60,-140},
          {60,60},{-208,60}},           color={0,127,255}));
  connect(pip5.port_b, pip1.port_a) annotation (Line(points={{80,-240},{40,-240},
          {40,-40},{-210,-40}}, color={0,127,255}));
  connect(TSetH.y, pla.TSetHea) annotation (Line(points={{-299,110},{-270,110},{
          -270,68},{-262,68}}, color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-299,80},{-290,80},{-290,
          64},{-262,64}}, color={0,0,127}));
  annotation(experiment(Tolerance=1E-06, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Examples/IdealSystem3Clusters.mos"
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{460,
            140}})));
end IdealSystem3Clusters;
