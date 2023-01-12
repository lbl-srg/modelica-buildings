within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model ChillerHeatRecoveryGroup
  "Validation of heat recovery chiller group model"
  extends Modelica.Icons.Example;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium model";

  parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD
    dat "Chiller parameters"
    annotation (Placement(transformation(extent={{90,92},{110,112}})));

  Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup
    chi(
    redeclare final package Medium = Medium,
    show_T=true,
    nUni=2,
    dpEva_nominal=3E5,
    dpCon_nominal=3E5,
    final dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Chiller group"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT retChiWat(
    redeclare final package Medium = Medium,
    p=supChiWat.p + chi.dpEva_nominal + chi.dpBalEva_nominal + chi.dpValveEva_nominal,
    T=285.15,
    nPorts=1)
    "Boundary conditions for CHW"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,-102})));

  Fluid.Sources.Boundary_pT supConWat(
    redeclare final package Medium = Medium,
    p=retConWat.p + chi.dpCon_nominal + chi.dpBalCon_nominal + chi.dpValveCon_nominal,
    T=chi.TCasHeaEnt_nominal,
    nPorts=2) "Boundary conditions for CW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,100})));

  Fluid.Sources.Boundary_pT retConWat(
    redeclare final package Medium = Medium,
    p=200000,
    nPorts=2) "Boundary conditions for CW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,100})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium = Medium,
    p=200000,
    nPorts=1) "Boundary conditions for CHW"
    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-102})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1(
    table=[0,1,1; 0.8,1,1; 0.8,1,0; 0.9,1,0; 0.9,0,0; 1,0,0],
    timeScale=2000,
    period=2000) "Chiller On/Off command"
    annotation (Placement(transformation(extent={{-110,-4},{-90,16}})));
  Fluid.Sources.Boundary_pT retHeaWat(
    redeclare final package Medium = Medium,
    p=supHeaWat.p + chi.dpCon_nominal + chi.dpBalCon_nominal + chi.dpValveCon_nominal,
    T=dat.TConLvg_nominal - 12,
    nPorts=1)
    "Boundary conditions for HW"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,60})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,0,0; 0.2,0,0; 0.2,0,1; 0.6,0,1; 0.6,1,1; 1,1,1],
    timeScale=2000,
    period=2000)
    "Cooling mode switchover command"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1HeaCoo(
    table=[0,0,0; 0.4,0,0; 0.4,1,0; 0.6,1,0; 0.6,0,0; 1,0,0],
    timeScale=2000,
    period=2000)
    "Direct heat recovery switchover command"
    annotation (Placement(transformation(extent={{-110,60},{-90,80}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare final package Medium = Medium,
    p=200000,
    nPorts=1)
    "Boundary conditions for HW" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={100,8})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable TSet(
    y(each final unit="K", each displayUnit="degC"),
    table=[
      0,0,0;
      0.6,0,0;
      0.6,chi.TChiWatSup_nominal-chi.THeaWatSup_nominal,0;
      1,chi.TChiWatSup_nominal-chi.THeaWatSup_nominal,0],
    offset={chi.THeaWatSup_nominal,chi.TChiWatSup_nominal},
    timeScale=2000) "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[chi.nUni]
    "Convert DO to AO" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,-20})));
  Fluid.Sensors.TemperatureTwoPort THeaWatSup(
    redeclare final package
      Medium = Medium, final m_flow_nominal=chi.mConWat_flow_nominal)
    "HW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,8})));
  Fluid.Sensors.MassFlowRate floHeaWat(redeclare final package Medium =
        Medium) "HW flow" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,60})));
  Fluid.Sensors.MassFlowRate floChiWat(redeclare final package Medium =
        Medium) "CHW flow" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-60})));
  Fluid.Sensors.TemperatureTwoPort TChiWatSup(redeclare final package
      Medium = Medium, final m_flow_nominal=chi.mChiWat_flow_nominal)
    "CHW supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-60})));
equation
  connect(y1.y, chi.y1)
    annotation (Line(points={{-88,6},{-12,6}}, color={255,0,255}));
  connect(y1HeaCoo.y, chi.y1HeaCoo)
    annotation (Line(points={{-88,70},{-7,70},{-7,12}}, color={255,0,255}));
  connect(y1Coo.y, chi.y1Coo)
    annotation (Line(points={{-88,40},{-9,40},{-9,12}}, color={255,0,255}));
  connect(TSet.y, chi.TSet) annotation (Line(points={{-88,-60},{-36,-60},{-36,-6},
          {-12,-6}}, color={0,0,127}));
  connect(y1.y, booToRea.u) annotation (Line(points={{-88,6},{-80,6},{-80,-20},{
          -72,-20}}, color={255,0,255}));
  connect(booToRea.y, chi.yValEva) annotation (Line(points={{-48,-20},{-6.2,-20},
          {-6.2,-12}}, color={0,0,127}));
  connect(booToRea.y, chi.yValCon) annotation (Line(points={{-48,-20},{-40,-20},
          {-40,20},{6,20},{6,12}}, color={0,0,127}));
  connect(supConWat.ports[1], chi.port_a2) annotation (Line(points={{-21,90},{-21,
          30},{16,30},{16,3},{10,3}}, color={0,127,255}));
  connect(chi.port_b2, retConWat.ports[1]) annotation (Line(points={{-10,3},{-30,
          3},{-30,80},{19,80},{19,90}}, color={0,127,255}));
  connect(supConWat.ports[2], chi.port_a3) annotation (Line(points={{-19,90},{-19,
          -3.2},{-10,-3.2}}, color={0,127,255}));
  connect(chi.port_b3, retConWat.ports[2])
    annotation (Line(points={{10,-3.1},{21,-3.1},{21,90}}, color={0,127,255}));
  connect(THeaWatSup.port_b, supHeaWat.ports[1])
    annotation (Line(points={{50,8},{90,8}}, color={0,127,255}));
  connect(retHeaWat.ports[1], floHeaWat.port_a)
    annotation (Line(points={{90,60},{50,60}}, color={0,127,255}));
  connect(floHeaWat.port_b, chi.port_a1) annotation (Line(points={{30,60},{-16,60},
          {-16,8},{-10,8}}, color={0,127,255}));
  connect(chi.port_b1, THeaWatSup.port_a)
    annotation (Line(points={{10,8},{30,8}}, color={0,127,255}));
  connect(retChiWat.ports[1], floChiWat.port_a)
    annotation (Line(points={{20,-92},{20,-70}}, color={0,127,255}));
  connect(floChiWat.port_b, chi.port_a4)
    annotation (Line(points={{20,-50},{20,-8},{10,-8}}, color={0,127,255}));
  connect(supChiWat.ports[1], TChiWatSup.port_b)
    annotation (Line(points={{-20,-92},{-20,-70}}, color={0,127,255}));
  connect(TChiWatSup.port_a, chi.port_b4) annotation (Line(points={{-20,-50},{-20,
          -8.5},{-10,-8.5}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/ChillerHeatRecoveryGroup.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerHeatRecoveryGroup</a>
in a configuration with two \"cooling-only\" chillers.
The chillers are switched <i>Off</i> one after the other, and 
receive an increasing CHW supply temperature setpoint.
</p>
</html>"));
end ChillerHeatRecoveryGroup;
