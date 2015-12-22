within Buildings.Experimental.DistrictHeatingCooling.Validation;
model IdealSmallSystem "Validation model for a small system"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 2E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+8
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+14
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
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
    Q_flow_nominal=Q_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-70})));
  SubStations.Heating hea1(redeclare package Medium = Medium, Q_flow_nominal=200E3)
    "Heating load"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  SubStations.Heating hea2(redeclare package Medium = Medium, Q_flow_nominal=100E3)
    "Heating load"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  SubStations.Cooling coo1(redeclare package Medium = Medium, Q_flow_nominal=-150E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  SubStations.Cooling coo2(redeclare package Medium = Medium, Q_flow_nominal=-100E3)
    "Cooling load"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-48,50},{-28,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-30,-50},{-50,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea1(table=[0,200E3; 6*3600,200E3; 6*3600,50E3;
        18*3600,50E3; 18*3600,75E3; 24*3600,75E3], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea2(table=[0,100E3; 6*3600,100E3; 6*3600,50E3;
        18*3600,50E3; 18*3600,75E3; 24*3600,75E3], extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QCoo1(table=[0,-100E3; 6*3600,-80E3; 6*3600,
        -50E3; 12*3600,-20E3; 18*3600,-150E3; 24*3600,-100E3], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QCoo2(table=[0,-10E3; 9*3600,-100E3; 9*3600,
        -50E3; 18*3600,-50E3; 18*3600,-150E3; 24*3600,-100E3], extrapolation=
        Modelica.Blocks.Types.Extrapolation.Periodic) "Cooling demand"
    annotation (Placement(transformation(extent={{160,80},{180,100}})));
equation

  connect(pla.port_b, pip.port_a) annotation (Line(points={{-60,60},{-52,60},{
          -48,60}},      color={0,127,255}));
  connect(pip.port_b, hea1.port_a) annotation (Line(points={{-28,60},{0,60},{0,
          58},{0,0},{20,0}},   color={0,127,255}));
  connect(pip.port_b, hea2.port_a) annotation (Line(points={{-28,60},{60,60},{60,
          0},{80,0}}, color={0,127,255}));
  connect(pip.port_b, coo1.port_b) annotation (Line(points={{-28,60},{74,60},{168,
          60},{168,0},{160,0}}, color={0,127,255}));
  connect(pip.port_b, coo2.port_b) annotation (Line(points={{-28,60},{-28,60},{228,
          60},{228,0},{220,0}}, color={0,127,255}));
  connect(pla.port_a, pip1.port_b) annotation (Line(points={{-80,60},{-88,60},{
          -88,-40},{-50,-40}},
                           color={0,127,255}));
  connect(pip1.port_a, hea1.port_b) annotation (Line(points={{-30,-40},{-30,-40},
          {52,-40},{52,0},{40,0}}, color={0,127,255}));
  connect(pip1.port_a, hea2.port_b) annotation (Line(points={{-30,-40},{-30,-40},
          {110,-40},{110,0},{100,0}}, color={0,127,255}));
  connect(pip1.port_a, coo1.port_a) annotation (Line(points={{-30,-40},{72,-40},
          {120,-40},{120,0},{140,0}}, color={0,127,255}));
  connect(pip1.port_a, coo2.port_a) annotation (Line(points={{-30,-40},{84,-40},
          {174,-40},{174,0},{200,0}}, color={0,127,255}));
  connect(pSet.ports[1], pip1.port_b) annotation (Line(points={{-70,-60},{-70,-40},
          {-50,-40}}, color={0,127,255}));
  connect(QHea1.y[1], hea1.Q_flow)
    annotation (Line(points={{1,90},{10,90},{10,6},{18,6}}, color={0,0,127}));
  connect(QHea2.y[1], hea2.Q_flow)
    annotation (Line(points={{61,90},{70,90},{70,6},{78,6}}, color={0,0,127}));
  connect(QCoo1.y[1], coo1.Q_flow) annotation (Line(points={{121,90},{130,90},{
          130,6},{138,6}}, color={0,0,127}));
  connect(QCoo2.y[1], coo2.Q_flow) annotation (Line(points={{181,90},{186,90},{
          190,90},{190,6},{198,6}}, color={0,0,127}));
  annotation(experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Validation/IdealSmallSystem.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal anergy heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            240,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end IdealSmallSystem;
