within Buildings.Experimental.DHC.Plants.Combined.Subsystems.Validation;
model ChillerGroupHeatRecovery
  extends ChillerGroup(
    y1Chi(table=[0,1,1; 0.5,1,1; 0.5,1,0; 0.8,1,0; 0.8,0,0; 1,0,0]),
    dat(
      EIRFunT={0.0101739374, 0.0607200115, 0.0003348647, 0.003162578, 0.0002388594, -0.0014121289},
      capFunT={0.0387084662, 0.2305017927, 0.0004779504, 0.0178244359, -8.48808e-05, -0.0032406711},
      EIRFunPLR={0.4304252832, -0.0144718912, 5.12039e-05, -0.7562386674, 0.5661683373,
        0.0406987748, 3.0278e-06, -0.3413411197, -0.000469572, 0.0055009208},
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
    nUni=2,
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
    nPorts=1)
    "Boundary conditions for HW"
    annotation (Placement(transformation(
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
  connect(y1Chi.y, chiHea.y1) annotation (Line(points={{-88,80},{60,80},{60,9},
          {68,9}}, color={255,0,255}));
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
  Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerGroup\">
Buildings.Experimental.DHC.Plants.Combined.Subsystems.ChillerGroup</a>
in a configuration with two heat recovery chillers.
</p>
<ul>
<li>
The chillers are first operated in cooling mode 
(tracking a CHW supply temperature setpoint), and are
switched <i>Off</i> one after the other.
</li>
<li>
The chillers are then commanded <i>On</i> again, one chiller
being operated in heating mode (tracking a HW supply temperature setpoint),
the other chiller being first operated in cooling mode,
then in heating mode as well.
</li>
<li>
The chillers also receive a varying CHW and HW supply temperature
setpoint.
</li>
</ul>
</html>"));
end ChillerGroupHeatRecovery;
