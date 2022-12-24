within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model ChillerGroupHeatRecovery
  extends ChillerGroup(
    y1Chi(table=[0,1,1; 0.5,1,1; 0.5,1,0; 0.8,1,0; 0.8,0,0; 1,0,0]),
    dat(
      capFunT={0.04633, 0.27848, 0.00046, -0.00606, 0.00029, -0.004},
      EIRFunT={0.0106, 0.0633, 0.0003, 0.0029, 0.0002, -0.0015},
      EIRFunPLR={-0.4603, 0.0461, -0.0013, -0.2349, 0.4127, 0.0146, 0.0, -0.2611, -0.0001, 0.0048},
      QEva_flow_nominal=-1E6,
      COP_nominal=2.5,
      mEva_flow_nominal=20,
      mCon_flow_nominal=22,
      TEvaLvg_nominal=279.15,
      TEvaLvgMin=277.15,
      TEvaLvgMax=308.15,
      TConLvg_nominal=333.15,
      TConLvgMin=296.15,
      TConLvgMax=336.15),
    chi(have_switchOver=true, typValCon=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition),
    retConWat(nPorts=2),
    retChiWat(nPorts=2),
    supChiWat(nPorts=2));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,1,1; 1,1,1; 1,1,0; 1.3,1,0; 1.3,0,0; 2,0,0],
    timeScale=1000,
    period=2000)
    "Chiller switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerGroup chiHea(
    have_switchOver=true,
    is_cooling=false,
    typValCon=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
    redeclare final package Medium1 = MediumConWat,
    redeclare final package Medium2 = MediumChiWat,
    show_T=true,
    nChi=2,
    typValEva=Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
    dpEva_nominal=3E5,
    dpCon_nominal=3E5,
    final dat=dat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chillers in heating mode"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp THeaWatSupSet(
    startTime=1000,
    y(displayUnit="degC", unit="K"),
    height=-5,
    duration=1000,
    offset=dat.TConLvg_nominal)
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Fluid.Sources.Boundary_pT retHeaWat(
    redeclare final package Medium = MediumConWat,
    p=retConWat.p + chi.dpCon_nominal + chi.dpBalCon_nominal + chi.dpValveCon_nominal,
    T=dat.TConLvg_nominal - 12,
    nPorts=1) "Boundary conditions for HW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,6})));

equation
  connect(y1Coo.y, chi.y1Coo) annotation (Line(points={{-88,40},{-20,40},{-20,0},
          {-12,0}}, color={255,0,255}));
  connect(y1Chi.y, chi.y1ValCon)
    annotation (Line(points={{-88,80},{-9,80},{-9,12}}, color={255,0,255}));
  connect(THeaWatSupSet.y, chiHea.TSet) annotation (Line(points={{-88,-80},{64,
          -80},{64,-9},{68,-9}}, color={0,0,127}));
  connect(y1Coo.y, chiHea.y1Coo) annotation (Line(points={{-88,40},{56,40},{56,
          0},{68,0}}, color={255,0,255}));
  connect(y1Chi.y, chiHea.y1ValCon)
    annotation (Line(points={{-88,80},{71,80},{71,12}}, color={255,0,255}));
  connect(y1Chi.y, chiHea.y1Chi) annotation (Line(points={{-88,80},{60,80},{60,
          9},{68,9}}, color={255,0,255}));
  connect(y1Chi.y, chiHea.y1ValEva) annotation (Line(points={{-88,80},{60,80},{
          60,-16},{71,-16},{71,-12}}, color={255,0,255}));
  connect(chiHea.port_b1, retConWat.ports[2]) annotation (Line(points={{90,6},{
          100,6},{100,60},{20,60},{20,90}}, color={0,127,255}));
  connect(retHeaWat.ports[1], chiHea.port_a1)
    annotation (Line(points={{50,6},{70,6}}, color={0,127,255}));
  connect(retChiWat.ports[2], chiHea.port_a2) annotation (Line(points={{20,-92},
          {20,-60},{100,-60},{100,-6},{90,-6}}, color={0,127,255}));
  connect(chiHea.port_b2, supChiWat.ports[2]) annotation (Line(points={{70,-6},
          {56,-6},{56,-20},{-20,-20},{-20,-92}}, color={0,127,255}));
annotation (
__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/ChillerGroupHeatRecovery.mos"
"Simulate and plot"),
experiment(
  StopTime=2000,
  Tolerance=1e-06));
end ChillerGroupHeatRecovery;
