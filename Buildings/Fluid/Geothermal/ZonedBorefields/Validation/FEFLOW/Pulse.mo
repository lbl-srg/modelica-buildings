within Buildings.Fluid.Geothermal.ZonedBorefields.Validation.FEFLOW;
model Pulse "Comparative model validation with FEFLOW for a pulse response"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;

  parameter Modelica.Units.SI.Temperature T_start=286.65
    "Initial temperature of the soil";

  parameter ZonedBorefields.Data.Filling.Bentonite filDat(
    kFil=1.0)
    "Borehole filling data"
    annotation (Placement(transformation(extent={{-36,-40},{-16,-20}})));
  parameter ZonedBorefields.Data.Soil.SandStone soiDat(
    kSoi=1.1,
    cSoi=1.4E6/1800,
    dSoi=1800)
    "Soil data"
    annotation (Placement(transformation(extent={{-14,-40},{6,-20}})));

  parameter Buildings.Fluid.Geothermal.ZonedBorefields.Data.Borefield.Template
    borFieDat(
    filDat=filDat,
    soiDat=soiDat,
    conDat=conDat) "Borefield data"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  parameter Data.Configuration.Template conDat(
    borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
    mBor_flow_nominal=20*995.586/24/3600*{1, 1},
    each dp_nominal=85*4*100*{1, 1},
    hBor=85,
    rBor=0.075,
    dBor=0.5,
    nZon=2,
    iZon={1,1,1,1,1,1,1,1,
          1,1,1,1,1,1,1,1,
          1,1,1,1,1,1,1,1,
          2,2,2,2},
    cooBor={{3,  1.5}, {6,  1.5}, {9,  1.5}, {12,  1.5}, {1.5,  4.5}, {4.5,  4.5}, {7.5,  4.5}, {10.5,  4.5},
            {3,  7.5}, {6,  7.5}, {9,  7.5}, {12,  7.5}, {1.5, 10.5}, {4.5, 10.5}, {7.5, 10.5}, {10.5, 10.5},
            {3, 13.5}, {6, 13.5}, {9, 13.5}, {12, 13.5}, {1.5, 16.5}, {4.5, 16.5}, {7.5, 16.5}, {10.5, 16.5},
            {5.4, 22.5}, {10.8, 22.5}, {2.7, 28.5}, {8.1, 28.5}},
    rTub=0.016,
    kTub=0.42,
    eTub=0.0029,
    xC=(2*((0.04/2)^2))^(1/2)) "Construction data"
    annotation (Placement(transformation(extent={{-58,-40},{-38,-20}})));

  final parameter Integer nZon(min=1) = borFieDat.conDat.nZon
    "Total number of independent bore field zones";

  replaceable Modelica.Blocks.Sources.Constant TIn[nZon](
    each k(each final unit="K",
      each displayUnit="degC")=293.15)
    constrainedby Modelica.Blocks.Interfaces.SO
    "Inlet temperature into each zone"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Modelica.Blocks.Sources.CombiTimeTable TOut(
    tableOnFile=true,
    tableName="tab1",
    columns={2,3},
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/Pulse.txt"),
    y(each unit="K",
      each displayUnit="degC"))
    "Reference results for the borehole fluid outlet temperature in each zone from FEFLOW"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Modelica.Units.SI.TemperatureDifference dTOut[2] =
    {if m_flow[i].y > 1E-5 then TOut.y[i] - TBorFieOut[i].T else 0 for i in 1:2}
    "Temperature difference FEFLOW minus Modelica outlet temperature";
  Real dQNor_flow[2] =
    {if m_flow[i].y > 1E-5 then (TOut.y[i] - sou[i].T) / (TBorFieOut[i].T - sou[i].T)-1 else 0 for i in 1:2}
    "Difference in heat extraction FEFLOW divided by Modelica";

  Buildings.Fluid.Geothermal.ZonedBorefields.TwoUTubes borFie(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TExt0_start=T_start,
    borFieDat=borFieDat,
    dT_dz=0) "Borefield"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sensors.TemperatureTwoPort TBorFieIn[nZon](
    redeclare each package Medium = Medium,
    each allowFlowReversal=false,
    each T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    each tau=0) "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sensors.TemperatureTwoPort TBorFieOut[nZon](
    redeclare each package Medium = Medium,
    each allowFlowReversal=false,
    each T_start=T_start,
    m_flow_nominal=borFieDat.conDat.mZon_flow_nominal,
    each tau=0) "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Sources.Boundary_ph sin[nZon](
    redeclare each package Medium = Medium,
    each nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  replaceable Modelica.Blocks.Sources.Pulse m_flow[nZon](
    amplitude=borFieDat.conDat.mZon_flow_nominal,
    each width=50,
    each period=3600*24*10,
    each startTime=0)
    constrainedby Modelica.Blocks.Interfaces.SO
    "Mass flow rate into each zone"
    annotation (Placement(transformation(extent={{-80,22},{-60,42}})));

  Sources.MassFlowSource_T sou[nZon](
    redeclare each package Medium = Medium,
    each use_m_flow_in=true,
    each use_T_in=true,
    each nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(TBorFieIn.port_b,borFie. port_a)
    annotation (Line(points={{20,0},{30,0}},       color={0,127,255}));
  connect(borFie.port_b, TBorFieOut.port_a)
    annotation (Line(points={{50,0},{60,0}},              color={0,127,255}));
  connect(sin[:].ports[1],TBorFieOut[:]. port_b) annotation (Line(points={{100,0},
          {80,0}},                color={0,127,255}));
  connect(sou.ports[1], TBorFieIn.port_a)
    annotation (Line(points={{-20,0},{0,0}},   color={0,127,255}));
  connect(m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-59,32},{-50,32},{-50,8},{-42,8}},
                                               color={0,0,127}));
  connect(TIn.y, sou.T_in) annotation (Line(points={{-59,0},{-52,0},{-52,4},{
          -42,4}}, color={0,0,127}));
  annotation (
  Diagram(coordinateSystem(extent={{-100,-60},{140,80}})),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/ZonedBorefields/Validation/FEFLOW/Pulse.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This validation cases compares the outlet temperature of a borefield with two
zones against the temperatures that were calculated with the FEFLOW software.
The mass flow rate in both zones is a pulse function.
</p>
<p>
The temperatures <code>TOut</code> are the leaving water temperatures from FEFLOW,
computed with FEFLOW's analytical solution for the borehole heat transfer.
Comparing <code>TOut</code> with the temperatures <code>TBorFieOut</code>
shows good agreement except after the step changes in mass flow rate.
The results after the step changes in mass flow rates
show similar discrepancies as the comparison of FEFLOW's analytical and
numerical solutions that is presented in the FEFLOW white paper (DHI-WASY 2010).
In the FEFLOW white paper, it is explained that the reason for this difference is
due to the FEFLOW's analytical solution not being valid for such short-time dynamics.
Therefore, the validation of the Modelica implementation is satisfactory.
</p>
<h5>References</h5>
<p>
DHI-WASY Software FEFLOW. Finite Element Subsurface Flow &amp; Transport Simulation System.
White Paper Vol. V.
DHI-WASY GmbH. Berlin 2010.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 17, 2024, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=15465600,
      Tolerance=1e-06));
end Pulse;
