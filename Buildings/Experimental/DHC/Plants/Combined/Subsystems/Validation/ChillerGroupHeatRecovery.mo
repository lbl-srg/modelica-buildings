within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model ChillerGroupHeatRecovery
  extends ChillerGroup(
    redeclare final package MediumChiWat=Medium,
    redeclare final package MediumConWat=Medium,
    redeclare Plants.Combined.Subsystems.ChillerGroupHeatRecovery chi(typValCon
        =Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition,
      redeclare final package Medium=Medium),
    y1Chi(table=[0,1,1; 0.5,1,1; 0.5,1,0; 0.8,1,0; 0.8,0,0; 1,0,0]),
    dat(
      capFunT={0.0, 0.0031, 0.0005, -0.0323, 0.0003, 0.0004},
      EIRFunT={0.0, 0.0003, 0.0003, -0.0031, 0.0002, -0.0005},
      EIRFunPLR={0.0, 0.0461, -0.0013, -0.0023, 0.0, 0.0001, 0.0, -0.0, -0.0, 0.0},
      QEva_flow_nominal=-1E6,
      COP_nominal=2.5,
      mEva_flow_nominal=20,
      mCon_flow_nominal=22,
      TEvaLvg_nominal=279.15,
      TEvaLvgMin=277.15,
      TEvaLvgMax=308.15,
      TConLvg_nominal=333.15,
      TConLvgMin=296.15,
      TConLvgMax=336.15));

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Unique common medium for CHW, HW and CW"
    annotation (choices(
    choice(redeclare package Medium = Buildings.Media.Water "Water"),
    choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
      property_T=293.15,
      X_a=0.40)
      "Propylene glycol water, 40% mass fraction")));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(
    k=dat.TConLvg_nominal,
    y(displayUnit="degC", unit="K"))
    "HW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Coo(
    table=[0,1,1; 1,1,1; 1,1,0; 1.3,1,0; 1.3,0,0; 2,0,0],
    timeScale=1000,
    period=2000)
    "Chiller switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Fluid.Sources.Boundary_pT supConWat(
    redeclare final package Medium = Medium,
    p=retConWat.p + max({
      chi.dpCon_nominal + chi.dpBalCon_nominal + chi.dpValveCon_nominal,
      chi.dpEva_nominal + chi.dpBalEva_nominal + chi.dpValveEva_nominal}),
    T=318.15,
    nPorts=1)
    "Boundary conditions for CW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Fluid.Sources.Boundary_pT retConWat(
    redeclare final package Medium = Medium,
    p=200000,
    nPorts=1) "Boundary conditions for CW" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,0})));
equation
  connect(THeaWatSupSet.y, chi.THeaWatSupSet) annotation (Line(points={{-88,-80},
          {-16,-80},{-16,-3},{-12,-3}}, color={0,0,127}));
  connect(y1Coo.y, chi.y1Coo) annotation (Line(points={{-88,40},{-20,40},{-20,3},
          {-12,3}}, color={255,0,255}));
  connect(supConWat.ports[1], chi.port_aConWat)
    annotation (Line(points={{-70,0},{-10,0}}, color={0,127,255}));
  connect(chi.port_bConWat, retConWat.ports[1])
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  connect(y1Chi.y, chi.y1ValCon)
    annotation (Line(points={{-88,80},{-9,80},{-9,12}}, color={255,0,255}));
annotation (
__Dymola_Commands(
file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Subsystems/Validation/ChillerGroupHeatRecovery.mos"
"Simulate and plot"),
experiment(
  StopTime=2000,
  Tolerance=1e-06));
end ChillerGroupHeatRecovery;
