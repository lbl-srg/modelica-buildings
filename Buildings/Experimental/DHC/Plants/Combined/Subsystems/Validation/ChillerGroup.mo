within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model ChillerGroup "Validation model for chiller group"
  extends Modelica.Icons.Example;

  replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";
  replaceable package MediumConWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CW medium";

  parameter
    Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_Carrier_19XR_1403kW_7_09COP_VSD
    dat "Chiller parameters"
    annotation (Placement(transformation(extent={{70,72},{90,92}})));

  Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerGroup chi(
    redeclare final package Medium1 = MediumConWat,
    redeclare final package Medium2 = MediumChiWat,
    show_T=true,
    nChi=2,
    dpChiWatChi_nominal=3E5,
    dpConWatChi_nominal=3E5,
    final dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                   "Chiller group"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Sources.Boundary_pT retChiWat(
    redeclare final package Medium = MediumChiWat,
    p=supChiWat.p + chi.dpChiWatChi_nominal + chi.dpBalChiWatChi_nominal,
    T=288.15,
    nPorts=1) "Boundary conditions for CHW distribution system" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,-60})));
  Fluid.Sources.Boundary_pT supConWat(
    redeclare final package Medium = MediumConWat,
    p=retConWat.p + chi.dpConWatChi_nominal,
    nPorts=1) "Boundary conditions for CW distribution system" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,60})));
  Fluid.Sources.Boundary_pT retConWat(
    redeclare final package Medium = MediumConWat,
    p=200000,
    nPorts=1) "Boundary conditions for CW distribution system" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,60})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare final package Medium = MediumChiWat,
    p=200000,
    nPorts=1) "Boundary conditions for CHW distribution system" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-40,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TChiWatSupSet(
    y(displayUnit="degC", unit="K"),
    height=+5,
    duration=1000,
    offset=dat.TEvaLvg_nominal) "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u2(
    table=[0,1; 0.5,1; 0.5,0; 1,0],
    timeScale=1000,
    period=1000)
    "Chiller #2 On/Off command"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0,1; 0.8,1; 0.8,0; 1,0],
    timeScale=1000,
    period=1000) "Chiller #2 On/Off command"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
equation
  connect(chi.port_b1, retConWat.ports[1])
    annotation (Line(points={{10,6},{40,6},{40,50}}, color={0,127,255}));
  connect(supConWat.ports[1], chi.port_a1)
    annotation (Line(points={{-40,50},{-40,6},{-10,6}}, color={0,127,255}));
  connect(retChiWat.ports[1], chi.port_a2)
    annotation (Line(points={{40,-50},{40,-6},{10,-6}}, color={0,127,255}));
  connect(supChiWat.ports[1], chi.port_b2)
    annotation (Line(points={{-40,-50},{-40,-6},{-10,-6}}, color={0,127,255}));
  connect(TChiWatSupSet.y, chi.TChiWatSupSet) annotation (Line(points={{-68,-40},
          {-60,-40},{-60,-2},{-12,-2}}, color={0,0,127}));
  connect(u1.y[1], chi.u1On[1]) annotation (Line(points={{-68,40},{-60,40},{-60,
          1.5},{-12,1.5}}, color={255,0,255}));
  connect(u2.y[1], chi.u1On[2]) annotation (Line(points={{-68,0},{-60,0},{-60,2.5},
          {-12,2.5}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/ChillerGroup.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerGroup;
