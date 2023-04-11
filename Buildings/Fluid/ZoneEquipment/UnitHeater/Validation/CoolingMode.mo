within Buildings.Fluid.ZoneEquipment.UnitHeater.Validation;
model CoolingMode
  "Validation model for cooling mode operation of fan coil unit system"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium model for water";

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    final T=279.15,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,origin={36,-90})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    final T=318.15,
    final nPorts=1)
    "Sink for heating hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,origin={-40,-80})));

  Buildings.Fluid.ZoneEquipment.UnitHeater.UnitHeater fanCoiUni(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses1.Types.HeaSou.hotWat,

    final dpAir_nominal(displayUnit="Pa") = 100,
    final mAirOut_flow_nominal=FCUSizing.mAirOut_flow_nominal,
    redeclare package MediumA = MediumA,
    redeclare package MediumCHW = MediumW,
    redeclare package MediumHW = MediumW,
    final mAir_flow_nominal=FCUSizing.mAir_flow_nominal,
    final QHeaCoi_flow_nominal=13866,
    final mHotWat_flow_nominal=FCUSizing.mHotWat_flow_nominal,
    final UAHeaCoi_nominal=FCUSizing.UAHeaCoi_nominal,
    final mChiWat_flow_nominal=FCUSizing.mChiWat_flow_nominal,
    final UACooCoi_nominal=FCUSizing.UACooCoiTot_nominal,
    redeclare Data.FanData fanPer) "Fan coil system model"
    annotation (Placement(transformation(extent={{10,-20},{50,20}})));

  Buildings.Fluid.Sources.MassFlowSource_T souCoo(
    redeclare package Medium = MediumW,
    final use_m_flow_in=true,
    final use_T_in=true,
    nPorts=1)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={70,-90})));

  Buildings.Fluid.Sources.MassFlowSource_T souHea(
    redeclare package Medium = MediumW,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1)
    "Source for heating hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={10,-90})));

  Buildings.Fluid.ZoneEquipment.UnitHeater.Validation.Data.SizingData FCUSizing
    "Sizing parameters for fan coil unit"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/FanCoilAutoSize_ConstantFlowVariableFan.dat"),
    final columns=2:19,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus simulation results"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));

  Buildings.Fluid.Sources.Boundary_pT souAir(
    redeclare package Medium = MediumA,
    final use_Xi_in=true,
    final p(displayUnit="Pa") = 101325 + 100,
    final use_T_in=true,
    final T=279.15,
    final nPorts=1)
    "Source for zone air"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Buildings.Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumA,
    final p=101325 + 100,
    final T=279.15,
    final nPorts=1)
    "Sink for zone air"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.2)
    "Constant real signal of 0.2 for the outdoor air economizer"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar[3](
    final p=fill(273.15, 3))
    "Add 273.15 to temperature values from EPlus to convert it to Kelvin from Celsius"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    final filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Calculate mass fractions of constituents"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1)
    "Add 1 to humidity ratio value to find total mass of moist air"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1)
    "Constant real signal of 1 for holding the hot water and chilled water control valves fully open"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1/(FCUSizing.mAir_flow_nominal))
    "Calculate normalized fan speed signal"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

equation

  connect(fanCoiUni.port_HW_b, sinHea.ports[1]) annotation (Line(points={{18,-20},
          {18,-60},{-40,-60},{-40,-70}},color={0,127,255}));

  connect(souHea.ports[1], fanCoiUni.port_HW_a)
    annotation (Line(points={{10,-80},{10,-68},{24,-68},{24,-20}},
                                                         color={0,127,255}));

  connect(souAir.ports[1], fanCoiUni.port_Air_a) annotation (Line(points={{80,50},
          {90,50},{90,4},{50,4}},     color={0,127,255}));

  connect(sinAir.ports[1], fanCoiUni.port_Air_b) annotation (Line(points={{80,-30},
          {90,-30},{90,-4},{50,-4}}, color={0,127,255}));

  connect(con.y, fanCoiUni.uEco) annotation (Line(points={{-58,30},{-20,30},{
          -20,18},{8,18}},
                      color={0,0,127}));

  connect(addPar[1].y, souAir.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,54},{58,54}},  color={0,0,127}));

  connect(addPar[2].y, souHea.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-120},{6,-120},{6,-102}},
                               color={0,0,127}));

  connect(addPar[3].y, souCoo.T_in) annotation (Line(points={{-58,70},{-16,70},{
          -16,-120},{66,-120},{66,-102}}, color={0,0,127}));

  connect(weaDat.weaBus, fanCoiUni.weaBus) annotation (Line(
      points={{-60,110},{14,110},{14,18},{14.2,18}},
      color={255,204,51},
      thickness=0.5));

  connect(datRea.y[5], addPar[1].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[7], addPar[3].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[9], addPar[2].u) annotation (Line(points={{-119,0},{-110,0},{
          -110,70},{-82,70}}, color={0,0,127}));
  connect(datRea.y[16], addPar1.u) annotation (Line(points={{-119,0},{-110,0},{-110,
          -120},{-130,-120},{-130,-140},{-122,-140}}, color={0,0,127}));
  connect(datRea.y[16], div.u1) annotation (Line(points={{-119,0},{-110,0},{-110,
          -120},{-100,-120},{-100,-114},{-62,-114}}, color={0,0,127}));
  connect(addPar1.y, div.u2) annotation (Line(points={{-98,-140},{-70,-140},{-70,
          -126},{-62,-126}}, color={0,0,127}));
  connect(div.y, souAir.Xi_in[1]) annotation (Line(points={{-38,-120},{-26,-120},
          {-26,46},{58,46}}, color={0,0,127}));
  connect(con1.y, fanCoiUni.uCoo) annotation (Line(points={{-58,-30},{-30,-30},
          {-30,-9.8},{8,-9.8}},
                              color={0,0,127}));
  connect(con1.y, fanCoiUni.uHea) annotation (Line(points={{-58,-30},{-30,-30},
          {-30,-17.8},{8,-17.8}},
                              color={0,0,127}));
  connect(datRea.y[10], souHea.m_flow_in) annotation (Line(points={{-119,0},{-110,
          0},{-110,-100},{-20,-100},{-20,-112},{2,-112},{2,-102}},      color={
          0,0,127}));
  connect(datRea.y[8], souCoo.m_flow_in) annotation (Line(points={{-119,0},{-110,
          0},{-110,-100},{-20,-100},{-20,-112},{62,-112},{62,-102}},     color=
          {0,0,127}));
  connect(datRea.y[6], gai.u)
    annotation (Line(points={{-119,0},{-102,0}}, color={0,0,127}));
  connect(gai.y, fanCoiUni.uFan) annotation (Line(points={{-78,0},{-20,0},{-20,
          10},{8,10}},
                   color={0,0,127}));
  connect(sinCoo.ports[1], fanCoiUni.port_CHW_b)
    annotation (Line(points={{36,-80},{36,-20}}, color={0,127,255}));
  connect(souCoo.ports[1], fanCoiUni.port_CHW_a) annotation (Line(points={{70,-80},
          {70,-60},{42,-60},{42,-20}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-160,-160},{160,160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Validation/CoolingMode.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This is an open-loop validation model for the fan coil unit system model 
      implemented in class <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.FanCoilUnitSystem\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.FanCoilUnitSystem</a>. It consists of:
      <ul>
      <li>
      an instance of the fan coil unit system model <code>fanCoiUni</code>.
      </li>
      <li>
      mixed volume <code>souAir</code> for imposing the boundary conditions of 
      the zone air.
      </li>
      <li>
      ideal media sources <code>souCoo</code> and <code>souHea</code> for simulating 
      the supply of chilled water and heating hot-water respectively.
      </li>
      <li>
      data-table reader <code>datRea</code> for reading the simulation results from EnergyPlus.
      </li>
      </ul>
      </p>
      <p>
      The simulation model is set-up to replicate an EnergyPlus model <code>FanCoilAutoSize_ConstantFlowVariableFan.idf</code>
      (available in the <code>/Resources/Data</code> section for this subpackage.)
      An annual simulation was run on the above EnergyPlus model, and various output 
      variables were recorded. These were then inserted into a data-file that is 
      read by <code>datRea</code> in this model.
      <br>
      The data values are used to impose the boundary conditions on the simulation 
      as well as compare the performance of the Modelica model with the equivalent 
      EnergyPlus model. Once the simulation is complete, the values for the supply
      air temperature and supply air flowrate, as well as the power consumption 
      of the various components are compared against their counterparts from the 
      EnergyPlus model.
      <br>
      This model validates the cooling mode operation by running the simulation from 07/01
      through 07/10 with the weather file <code>USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos</code>.
      It then makes plots for the supply air temperature and flowrate, as well as 
      the energy consumption of the cooling coil, including sensible and latent components,
      and the energy consumption of the supply fan.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end CoolingMode;
