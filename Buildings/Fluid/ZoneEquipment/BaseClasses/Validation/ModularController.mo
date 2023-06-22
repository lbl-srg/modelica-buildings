within Buildings.Fluid.ZoneEquipment.BaseClasses.Validation;
model ModularController
  "Validation model for controller with constant speed fan and DX coils"

  extends Modelica.Icons.Example;

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    supHeaTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SupHeaSou.noHea,
    fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.mulSpeFan,
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum,
    cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.noCoo,
    final has_fanOpeMod=true,
    final minFanSpe=0.1,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of packaged terminal heat pump controller"
    annotation (Placement(transformation(extent={{-80,80},{-60,112}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon1(
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea,
    has_varHea=false,
    cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat,
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.windowAC,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of window air conditioner controller"
    annotation (Placement(transformation(extent={{8,18},{28,50}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon2(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=0,
    final dTHys=0.2)
    "Instance of packaged terminal air conditioner"
    annotation (Placement(transformation(extent={{100,-72},{120,-40}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{-38,70},{-18,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod(
    final period=900)
    "Supply fan operating mode signal"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    final height=10,
    final duration=36000,
    final offset=273.15 + 15)
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
    final k=273.15 + 23)
    "Heating setpoint temperature"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(
    final period=2700)
    "System availability signal"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
    final k=273.15 + 24)
    "Cooling setpoint temperature"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
    final height=6,
    final duration=3600,
    final offset=273.15 + 35)
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
    final height=5,
    final duration=36000,
    final offset=273.15 + 0)
    "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel2(
    final delayTime=10)
    "Artificial delay for proven on signal"
    annotation (Placement(transformation(extent={{130,-80},{150,-60}})));

equation
  connect(heaSetPoi.y, modCon.THeaSet) annotation (Line(points={{-118,80},{-116,
          80},{-116,98},{-82,98}},      color={0,0,127}));
  connect(TZon.y, modCon.TZon) annotation (Line(points={{-118,140},{-110,140},{
          -110,106},{-82,106}},
                     color={0,0,127}));
  connect(supFanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-118,-10},
          {-100,-10},{-100,86},{-82,86}},     color={255,0,255}));
  connect(uAva.y, modCon.uAva) annotation (Line(points={{-118,20},{-94,20},{-94,
          90},{-82,90}},   color={255,0,255}));
  connect(modCon.yFan, truDel.u) annotation (Line(points={{-58,84},{-52,84},{
          -52,80},{-40,80}},
                    color={255,0,255}));
  connect(truDel.y, modCon.uFan) annotation (Line(points={{-16,80},{-16,118},{
          -100,118},{-100,110},{-82,110}},    color={255,0,255}));
  connect(cooSetPoi.y, modCon.TCooSet) annotation (Line(points={{-118,110},{
          -104,110},{-104,102},{-82,102}},
                                       color={0,0,127}));
  connect(TSup.y, modCon.TSup) annotation (Line(points={{-118,-40},{-90,-40},{
          -90,82},{-82,82}},        color={0,0,127}));
  connect(TOut.y, modCon.TOut) annotation (Line(points={{-118,50},{-112,50},{
          -112,94},{-82,94}},
                           color={0,0,127}));
  connect(modCon1.yFan, truDel1.u) annotation (Line(points={{30,22},{30,20},{38,
          20}},            color={255,0,255}));
  connect(truDel1.y, modCon1.uFan) annotation (Line(points={{62,20},{68,20},{68,
          -22},{-12,-22},{-12,48},{6,48}},                 color={255,0,255}));
  connect(modCon2.yFan, truDel2.u) annotation (Line(points={{122,-68},{122,-70},
          {128,-70}},     color={255,0,255}));
  connect(truDel2.y, modCon2.uFan) annotation (Line(points={{152,-70},{160,-70},
          {160,-98},{88,-98},{88,-42},{98,-42}},        color={255,0,255}));
  connect(TZon.y, modCon1.TZon) annotation (Line(points={{-118,140},{-110,140},{
          -110,44},{6,44}}, color={0,0,127}));
  connect(heaSetPoi.y, modCon1.TCooSet) annotation (Line(points={{-118,80},{-116,
          80},{-116,40},{6,40}}, color={0,0,127}));
  connect(TZon.y, modCon2.TZon) annotation (Line(points={{-118,140},{-110,140},{
          -110,-46},{98,-46}}, color={0,0,127}));
  connect(cooSetPoi.y, modCon2.TCooSet) annotation (Line(points={{-118,110},{-104,
          110},{-104,-50},{98,-50}}, color={0,0,127}));
  connect(heaSetPoi.y, modCon2.THeaSet) annotation (Line(points={{-118,80},{-116,
          80},{-116,-54},{98,-54}}, color={0,0,127}));
  connect(uAva.y, modCon2.uAva) annotation (Line(points={{-118,20},{-94,20},{-94,
          -62},{98,-62}}, color={255,0,255}));
  connect(supFanOpeMod.y, modCon2.fanOpeMod) annotation (Line(points={{-118,-10},
          {-100,-10},{-100,-66},{98,-66}}, color={255,0,255}));
  connect(TSup.y, modCon2.TSup) annotation (Line(points={{-118,-40},{-90,-40},{-90,
          -70},{98,-70}}, color={0,0,127}));
  connect(uAva.y, modCon1.uAva) annotation (Line(points={{-118,20},{-94,20},{-94,
          28},{6,28}}, color={255,0,255}));
  connect(supFanOpeMod.y, modCon1.fanOpeMod) annotation (Line(points={{-118,-10},
          {-100,-10},{-100,24},{6,24}}, color={255,0,255}));
  connect(TSup.y, modCon1.TSup) annotation (Line(points={{-118,-40},{-90,-40},{-90,
          20},{6,20}}, color={0,0,127}));
  annotation(Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-120},{180,
            160}})),
    Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>, which is used for different zone equipments.  
    </p>
    <p>
    Simulation results are observed as follows: 
    <ul>
    <li>
    When the controller (<code>ModularController</code>) is used for the packaged terminal heat pump system, 
    it enables/disables the DX coils to regulate the zone temperature (<code>TZon</code>)
    tracking its setpoints (<code>cooSetPoi</code> and <code>cooSetPoi</code>). 
    The electric supplemental heating coil is activated when the outdoor temperature is below the 
    minimum outdoor air drybulb temperature limit. 
    </li>
    <li>
    When the controller (<code>ModularController</code>) is used for the packaged terminal air conditioner system, 
    it enables/disables the DX cooling coil and electric heating coil to regulate the 
    zone temperature (<code>TZon2</code>) tracking its setpoints (<code>cooSetPoi2</code> and <code>cooSetPoi2</code>).
    </li>
    <li>
    When the controller (<code>ModularController</code>) is used for the window air conditioner system, 
    it enables/disables the DX cooling coil only to regulate the zone temperature (<code>TZon1</code>) 
    tracking its cooling setpoint (<code>cooSetPoi1</code>).
    </li>
    </ul>
    </p>
    </html>",revisions="<html>
    <ul>
    <li>
    June 21, 2023 by Junke Wang and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end ModularController;
