within Buildings.Examples.VAVReheat;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop;

  Buildings.Controls.Continuous.LimPID heaCoiCon(
    yMax=1,
    yMin=0,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for heating coil"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.Continuous.LimPID cooCoiCon(
    reverseAction=true,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for cooling coil"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));

  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVCor "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{530,32},{550,52}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVSou "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{700,30},{720,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVEas "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,30},{900,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVNor "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1040,30},{1060,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36 conVAVWes "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,28},{1260,48}})));
  Buildings.Examples.VAVReheat.Controls.AHUGuideline36 conAHU "AHU controller"
    annotation (Placement(transformation(extent={{300,292},{340,400}})));
  Buildings.Examples.VAVReheat.Controls.ZoneSetPointsGuideline36 TSetZon1(
    THeaOn=THeaOn,
    THeaOff=THeaOff,
    TCooOff=TCooOff) annotation (Placement(transformation(rotation=0, extent={{
            68,296},{88,316}})));
equation
  connect(fanRet.port_a, dpRetFan.port_b) annotation (Line(
      points={{320,140},{320,140},{320,60}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(fanSup.port_b, dpRetFan.port_a) annotation (Line(
      points={{320,-40},{320,40}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-297,-204},{-240,-204},{-240,-260}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-297,-216},{-240,-216},{-240,-260}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TSup.port_b, senSupFlo.port_a) annotation (Line(
      points={{350,-40},{360,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCoiHeaOut.T, heaCoiCon.u_m) annotation (Line(
      points={{144,-29},{144,-20},{160,-20},{160,-180},{10,-180},{10,-172}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heaCoiCon.y, valHea.y) annotation (Line(
      points={{21,-160},{108,-160},{108,-80},{118,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooCoiCon.y, valCoo.y) annotation (Line(
      points={{21,-200},{210,-200},{210,-80},{218,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senSupFlo.V_flow, conFanRet.u) annotation (Line(
      points={{370,-29},{370,90},{200,90},{200,170},{248,170}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senRetFlo.V_flow, conFanRet.u_m) annotation (Line(
      points={{380,151},{380,134},{260,134},{260,158}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conFanRet.y, fanRet.y) annotation (Line(
      points={{271,170},{310,170},{310,152}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSup.T, cooCoiCon.u_m) annotation (Line(
      points={{340,-29},{340,-20},{356,-20},{356,-220},{10,-220},{10,-212}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(conVAVCor.TRoo, TRooAir.y5[1]) annotation (Line(points={{528,42},{520,
          42},{520,162},{511,162}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TRoo, TRooAir.y1[1]) annotation (Line(points={{698,40},{690,
          40},{690,36},{680,36},{680,178},{511,178}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TRoo) annotation (Line(points={{511,174},{868,
          174},{868,40},{878,40}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TRoo) annotation (Line(points={{511,170},{1028,
          170},{1028,40},{1038,40}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TRoo) annotation (Line(points={{511,166},{1220,
          166},{1220,38},{1238,38}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TDis, TSupCor.T) annotation (Line(points={{528,39.3333},{
          522,39.3333},{522,34},{514,34},{514,92},{569,92}},
                                                color={0,0,127}));
  connect(TSupSou.T,conVAVSou.TDis)  annotation (Line(points={{749,92},{688,92},
          {688,37.3333},{698,37.3333}},
                              color={0,0,127}));
  connect(TSupEas.T,conVAVEas.TDis)  annotation (Line(points={{929,90},{872,90},
          {872,37.3333},{878,37.3333}},
                              color={0,0,127}));
  connect(TSupNor.T,conVAVNor.TDis)  annotation (Line(points={{1089,94},{1032,
          94},{1032,37.3333},{1038,37.3333}},
                                color={0,0,127}));
  connect(TSupWes.T,conVAVWes.TDis)  annotation (Line(points={{1289,90},{1228,
          90},{1228,35.3333},{1238,35.3333}},
                                color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,48},{556,48},
          {556,47.8667},{551,47.8667}},
                                 color={0,0,127}));
  connect(cor.yVal, conVAVCor.yVal) annotation (Line(points={{566,32},{560,32},
          {560,41.3333},{551,41.3333}},
                             color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{721,45.8667},{730,
          45.8667},{730,48},{746,48}},
                              color={0,0,127}));
  connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{721,39.3333},{
          732.5,39.3333},{732.5,32},{746,32}},
                                color={0,0,127}));
  connect(conVAVEas.yVal, eas.yVal) annotation (Line(points={{901,39.3333},{
          912.5,39.3333},{912.5,32},{926,32}},
                                color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{901,45.8667},{910,
          45.8667},{910,48},{926,48}},
                              color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1061,45.8667},{
          1072.5,45.8667},{1072.5,48},{1086,48}},
                                        color={0,0,127}));
  connect(conVAVNor.yVal, nor.yVal) annotation (Line(points={{1061,39.3333},{
          1072.5,39.3333},{1072.5,32},{1086,32}},
                                  color={0,0,127}));
  connect(conVAVCor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={
          {528,50},{480,50},{480,-260},{-240,-260}}, color={0,0,127}));
  connect(conVAVCor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{528,
          47.3333},{480,47.3333},{480,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVSou.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{698,48},
          {660,48},{660,-260},{-240,-260}},          color={0,0,127}));
  connect(conVAVSou.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{698,
          45.3333},{660,45.3333},{660,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVEas.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{878,48},
          {850,48},{850,-260},{-240,-260}},          color={0,0,127}));
  connect(conVAVEas.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{878,
          45.3333},{850,45.3333},{850,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVNor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{1038,48},
          {1020,48},{1020,-260},{-240,-260}},        color={0,0,127}));
  connect(conVAVNor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{1038,
          45.3333},{1020,45.3333},{1020,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVWes.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{1238,46},
          {1202,46},{1202,-260},{-240,-260}},        color={0,0,127}));
  connect(conVAVWes.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{1238,
          43.3333},{1202,43.3333},{1202,-260},{-240,-260}},
                                                     color={0,0,127}));

  connect(conVAVWes.yVal, wes.yVal) annotation (Line(points={{1261,37.3333},{
          1272.5,37.3333},{1272.5,32},{1286,32}},
                                      color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,48},{1274,48},
          {1274,43.8667},{1261,43.8667}},
                                    color={0,0,127}));
  connect(TSetZon1.uOcc, occSch.occupied) annotation (Line(points={{66,297.688},
          {-120,297.688},{-120,290},{-258,290},{-258,-216},{-297,-216}},
                                                                    color={255,
          0,255}));
  connect(occSch.tNexOcc, TSetZon1.tNexOcc) annotation (Line(points={{-297,-204},
          {-254,-204},{-254,286},{-118,286},{-118,309.333},{66,309.333}},
                                                                  color={0,0,
          127}));
  connect(TSetZon1.TZon, flo.TRooAir) annotation (Line(points={{66,304.354},{66,
          304},{42,304},{42,500},{1164,500},{1164,450.733},{1093.44,450.733}},
                                                        color={0,0,127}));
  connect(conAHU.THeaSet, TSetZon1.THeaSet) annotation (Line(points={{298,392},
          {120,392},{120,309.333},{89,309.333}}, color={0,0,127}));
  connect(conAHU.TCooSet, TSetZon1.TCooSet) annotation (Line(points={{298,386},
          {128,386},{128,312.667},{89,312.667}}, color={0,0,127}));
  connect(conAHU.TZon, flo.TRooAir) annotation (Line(points={{298,376},{280,376},
          {280,500},{1164,500},{1164,450.733},{1093.44,450.733}}, color={0,0,
          127}));
  connect(conAHU.TOut, TOut.y) annotation (Line(points={{298,368},{-266,368},{
          -266,148},{-279,148}}, color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut)
    annotation (Line(points={{100,151},{100,364},{298,364}}, color={0,0,127}));
  connect(conAHU.TSup, TSup.T) annotation (Line(points={{298,352},{140,352},{
          140,-20},{340,-20},{340,-29}}, color={0,0,127}));
  connect(dpRetFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,50},{
          256,50},{256,48},{150,48},{150,340},{298,340}}, color={0,0,127}));
  connect(conAHU.uOpeMod, TSetZon1.opeMod) annotation (Line(points={{298,324},{
          130,324},{130,304.333},{89,304.333}}, color={255,127,0}));
  connect(conAHU.uFreProSta, TSetZon1.yFreProSta) annotation (Line(points={{298,
          316},{134,316},{134,300.167},{89,300.167}}, color={255,127,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-400},{1660,
            600}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors based
on wind pressure and flow imbalance of the HVAC system.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate
reduced by a fixed offset. The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
To model the heat transfer through the building envelope,
a model of five interconnected rooms is used.
The five room model is representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
(Deru et al, 2009). There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the
Window 5 model and described in TARCOG 2006.
</p>
<p>
Each thermal zone can have air flow from the HVAC system, through leakages of the building envelope (except for the core zone) and through bi-directional air exchange through open doors that connect adjacent zones. The bi-directional air exchange is modeled based on the differences in static pressure between adjacent rooms at a reference height plus the difference in static pressure across the door height as a function of the difference in air density.
There is also wind pressure acting on each facade. The wind pressure is a function
of the wind speed and wind direction. Therefore, infiltration is a function of the
flow imbalance of the HVAC system and of the wind conditions.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian, and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&circ;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end Guideline36;
